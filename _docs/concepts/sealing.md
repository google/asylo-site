---

title: Secret Sealing

overview: Reference for secret sealing.

location: /_docs/concepts/sealing.md

order: 40

layout: docs

type: markdown

toc: true

---

{% include home.html %}


## Overview

Sealing provides an enclave with the ability to encrypt a secret such that it is
only accessible to an enclave with specific identity properties.

Asylo currently supports secret sealing using Intel SGX.

## SGX Sealing

### Background

SGX sealing is done using symmetric encryption keys provided by SGX hardware.
These keys are derived from root secrets fused into the processor. An enclave
cannot access the root keys of a particular CPU, but it can request the CPU to
derive a key rooted in the hardware secrets through an instruction called
EGETKEY.

The EGETKEY instruction allows deriving various types of keys, one of which is
called the _sealing key_. When requesting a sealing key, an enclave specifies a
_Key Policy_ indicating which properties of the enclave’s identity should be
mixed into the key. The Key Policy enables an enclave to derive sealing keys
with varying properties, thereby enabling sealing configurations with varying
properties.

### Sealing Configurations

SGX allows users to derive sealing keys with complex key policies, some of which
are rather esoteric and whose use is not well-defined.

To simplify these options, Asylo supports just two basic sealing configurations:
an MRENCLAVE sealing configuration and an MRSIGNER sealing configuration.

NOTE: Unless otherwise stated, all properties and invariants described below are
enforced in hardware (i.e., microcode), not in software (i.e., Asylo).

#### MRENCLAVE configuration

The MRENCLAVE value of an enclave is a measurement of the enclave's creation
process. Sealing based on MRENCLAVE is sometimes referred to sealing to _code_
_identity_.

Note that an enclave can only specify whether or not its _own_ MRENCLAVE is
mixed into the sealing key derivation, but not _what_ MRENCLAVE value is mixed
in.

##### Properties

This sealing configuration will bind secrets to a particular code measurement.
Consequently, any changes to an enclave's code also change the MRENCLAVE value,
making it impossible for a new enclave to unseal secrets sealed by a previous
"code version" of the enclave. From the hardware’s point of view these enclaves
are completely unrelated with respect to MRENCLAVE.

MRENCLAVE-based sealing is very strict and, consequently, very brittle. Since
the MRENCLAVE sealing configuration is so strict, it is also considered to be
the most secure sealing configuration.

##### When to use it

This sealing configuration can be used when the enclave signer is not trusted
because, e.g., the signer has the ability to sign malicious enclaves.

##### Asylo reference

This sealing configuration can be used by creating an
[`asylo::SgxLocalSecretSealer`]({{home}}/doxygen/classasylo_1_1SgxLocalSecretSealer.html)
[`asylo::SgxLocalSecretSealer::CreateMrenclaveSecretSealer`]({{home}}/doxygen/classasylo_1_1SgxLocalSecretSealer.html#a6159d2205a9cf13ca1c38f113116d70b)
factory. See the code examples for `asylo::SgxLocalSecretSealer` for more
details on usage.

#### MRSIGNER (aka signer-assigned-identity) configuration

The MRSIGNER value of an enclave is a measurement of the key used to sign it.
MRSIGNER-based sealing actually refers to more than just the MRSIGNER value
though. It is based on the _signer-assigned identity_ of the enclave, which
includes the triplet {MRSIGNER, ISVPRODID , ISVSVN}.

The ISVPRODID is the product identifier of the enclave, and can be treated as a
name for the enclave (e.g., ISVPRODID 1 means the _Foobar Certificate
Authority_). The ISVSVN is the security version number of the enclave. ISVPRODID
and ISVSVN are assigned by the enclave signer, whereas MRSIGNER is calculated
from the enclave signing key.

MRSIGNER can be treated as a namespace in which ISVPRODID values are assigned.
This means that an enclave signed as `{ISVPRODID: 1, MRSIGNER: foo}` has no
relationship to an enclave signed as `{ISVPRODID: 1, MRSIGNER: bar}`; these
enclaves cannot share secrets using an MRSIGNER-based sealing policy.

Similarly, {MRSIGNER, ISVPRODID} can be treated as a namespace in which ISVSVN
values are assigned. The ISVSVN value for an enclave should be incremented
anytime a security-sensitive bug in the enclave is fixed.

Note that an enclave can only specify whether or not to mix in its _own_
MRSIGNER value (and therefore, its ISVPRODID value) into the sealing key
derivation, but not which values of MRSIGNER or ISVPRODID to use. An enclave
_can_, however, specify any ISVSVN that is less than or equal to its current
ISVSVN. Asylo only allows enclaves to seal to their current ISVSVN, but allows
them to unseal secrets from older ISVSVNs.

##### Properties

This sealing configuration most notably allows for _forward-portability of
secrets_ via the ISVSVN value. This means that secrets sealed to lower ISVSVNs
are available to the enclave at a higher ISVSVN, but secrets sealed to higher
ISVSVNs are not available to the enclave from a lower ISVSVN.

##### When to use it

This configuration provides the most flexibility with respect to porting
secrets. As long as the enclave signing key is trusted, this is a safe choice
for an enclave’s sealing configuration.

##### Asylo reference

This sealing configuration can be used by creating an
[`asylo::SgxLocalSecretSealer`]({{home}}/doxygen/classasylo_1_1SgxLocalSecretSealer.html)
using the
[`asylo::SgxLocalSecretSealer::CreateMrsignerSecretSealer`]({{home}}/doxygen/classasylo_1_1SgxLocalSecretSealer.html#acfb7e4abdf0f1b170123677d27dbb26e)
factory. See the code examples for `asylo::SgxLocalSecretSealer` for more
details on usage.

### Other features

#### CPUSVN

CPUSVN is a representation of the platform's TCB, including the microcode update
version and authenticated code modules. Enclaves can specify a CPUSVN to be
mixed into the sealing key derivation. Unlike, ISVSVN, CPUSVN is not an integer
and thus cannot be compared mathematically. However, similar to the ISVSVN,
secrets sealed to older CPUSVN values can be unsealed by enclaves running on
platforms with later CPUSVN values. Enclaves cannot seal secrets to later CPUSVN
values that are not accessible to the enclave. The hardware defines which CPUSVN
values are considered later.

By default, Asylo’s MRENCLAVE and MRSIGNER sealing configurations always mix in
the current CPUSVN value.

The CPUSVN used in sealing key derivation can be customized by changing the
[`asylo::SealedSecretHeader`]({{home}}/docs/reference/proto/identity/asylo.sealed_secret.v1.html#SealedSecretHeader)
set by
[`asylo::SgxLocalSecretSealer::SetDefaultHeader()`]({{home}}/doxygen/classasylo_1_1SgxLocalSecretSealer.html#aa1509a5c117344e66033b2294ec88d87).
This is only recommended for advanced users.

#### Enclave ATTRIBUTES

Enclave ATTRIBUTES is a bitset representation of various features that may
affect the enclave’s security. This includes both features related to the
enclave itself as well as features enabled on the system unrelated to SGX. An
enclave can request a sealing key that has any subset of ATTRIBUTES bits mixed
in.

Asylo’s MRENCLAVE and MRSIGNER sealing configurations always mix in a default
set of security-sensitive bits into the derivation of the sealing key. See
[this file](https://github.com/google/asylo/blob/master/asylo/identity/platform/sgx/internal/secs_attributes.cc) for more
details on which bits fall into the “security-sensitive” set.

The set of ATTRIBUTES bits used in the key derivation can be customized by
changing the default
[`asylo::SealedSecretHeader`]({{home}}/docs/reference/proto/identity/asylo.sealed_secret.v1.html#SealedSecretHeader)
set by
[`asylo::SgxLocalSecretSealer::SetDefaultHeader()`]({{home}}/doxygen/classasylo_1_1SgxLocalSecretSealer.html#aa1509a5c117344e66033b2294ec88d87).
This is only recommended for advanced users.

#### Key Sealing and Separation (KSS)

Asylo does not currently support deriving sealing keys using KSS features like
ISVEXTPRODID, ISVFAMILYID, NOISVPRODID, CONFIGID, or CONFIGSVN.
