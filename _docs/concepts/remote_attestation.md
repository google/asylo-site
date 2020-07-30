---

title: Remote Attestation

overview: Remote attestation support in Asylo

location: /_docs/concepts/remote_attestation.md

order: 30

layout: docs

type: markdown

toc: true

---

{% include home.html %}


## Overview

Remote attestation enables an enclave to remotely attest its identity to another
entity, which can be another enclave or a non-enclave. Remote attestation
mechanisms are strictly stronger than local attestation mechanisms because they
use an external authority (usually a certificate authority) as the root of trust
rather than a machine-local root of trust, such as a symmetric secret.

Asylo currently supports two mechanisms for remote attestation for Intel SGX.

## SGX Remote Attestation

### Quoting Enclaves

SGX remote attestation is enabled by a _quoting enclave_. A quoting enclave is
an enclave that produces _quotes_, or remote attestations, on behalf of enclaves
running on the same machine. A quoting enclave is certified by one or more
certificate authorities. This enables the quoting enclave to produce quotes that
chain back to a trusted authority.

A quoting enclave can be certified by Intel by having its hardware REPORT signed
by the Provisioning Certification Key (PCK). The PCK is a signing key wielded by
the Provisioning Certification Enclave (PCE), a special enclave written, signed,
and distributed by Intel. Intel issues PCK certificates chaining back to the
Intel SGX Root CA, the root of the
[Intel SGX PKI](https://download.01.org/intel-sgx/dcap-1.1/linux/docs/Intel_SGX_PCK_Certificate_CRL_Spec-1.1.pdf).

Remote attestation is built on top of local attestation: a quoting enclave uses
SGX local attestation to verify another enclave's identity before signing a
statement about that enclave's identity. This same mechanism is used by the PCE
to certify an quoting enclave.

Asylo supports two different quoting enclaves: the Intel ECDSA Quoting Enclave
and the Asylo Assertion Generator Enclave.

### Intel ECDSA Quoting Enclave

The Intel ECDSA Quoting Enclave is a quoting enclave written, signed, and
distributed by Intel. The QE is written using the Intel SGX SDK and,
consequently, has a smaller Trusted Computing Base (TCB) than a quoting enclave
written using Asylo.

#### When to Use it

The Intel ECDSA QE is recommended for Asylo applications that require a minimal
TCB. Additionally, if using older SGX hardware with limited EPC, the Intel ECDSA
QE is recommended because it allows loading on-demand.

#### How to Use it

NOTE: This requires running on an Intel CPU that supports SGX with
[Flexible Launch Control (FLC)](https://software.intel.com/en-us/blogs/2018/12/09/an-update-on-3rd-party-attestation).

Asylo provides the
[`asylo::SgxIntelEcdsaQeRemoteAssertionGenerator`]({{home}}/doxygen/classasylo_1_1SgxAgeRemoteAssertionGenerator.html)
and
[`asylo::SgxIntelEcdsaQeRemoteAssertionVerifier`]({{home}}/doxygen/classasylo_1_1SgxIntelEcdsaQeRemoteAssertionVerifier.html)
classes that assist in generating and verifying attestations produced by the
Intel ECDSA QE.

Asylo does not currently support using Intel QE-generated attestations as a
[gRPC authentication mechanism]({{home}}/docs/reference/grpc_auth.html).

You can download Intel's architectural enclaves (the QE and the PCE) from
[Intel's website](https://download.01.org/intel-sgx/sgx-dcap/). This process is
streamlined with the following commands:

```shell
DCAP_VERSION="1.6" # Replace with the most up-to-date version available.

INTEL_ENCLAVES_PATH="/opt/intel_enclaves/${DCAP_VERSION}"
mkdir -p "${INTEL_ENCLAVES_PATH}"

curl -SL "https://download.01.org/intel-sgx/sgx-dcap/${DCAP_VERSION}/linux/prebuilt_dcap_${DCAP_VERSION}.tar.gz" \
| tar -xvz --strip=5 -C "${INTEL_ENCLAVES_PATH}"
```

### Asylo Assertion Generator Enclave

The Assertion Generator Enclave (AGE) is a quoting enclave that is part of the
Asylo framework. It is written using the Asylo framework and, consequently, has
a larger Trusted Computing Base (TCB) than the Intel QE. The AGE TCB notably
includes:

*   [Protobuf](https://developers.google.com/protocol-buffers) (like all Asylo
    enclaves)
*   [Abseil](https://abseil.io/) (like all Asylo enclaves)
*   [gRPC](https://grpc.io/)
*   [BoringSSL](https://boringssl.googlesource.com/boringssl/)

The AGE runs a long-lived gRPC attestation server. An enclave can make an RPC to
this service to obtain an attestation. Due to running an RPC server, the AGE
must be run as a long-lived process (like a system daemon). See
[instructions below](#how-to-use-it-1) for how to run it.

The AGE defines various entry-points for key and certificate management using
the [Asylo API]({{home}}/docs/concepts/api-overview.html).

This includes support for co-certification: Asylo users can extend the AGE's
logic to allow for custom certification logic.

#### When to Use it

The AGE is recommended for any Asylo applications that make use of Asylo's
[gRPC authentication mechanism]({{home}}/docs/reference/grpc_auth.html)
(and therefore already take a dependency on gRPC), as well as for users that
want to manage their own SGX PKI.

#### How to Use it

The primary use of AGE-based attestation is in
[establishing secure gRPC connections]({{home}}/docs/reference/grpc_auth.html#bidirectional-sgx-remote-authentication).

However, Asylo also provides
[`asylo::SgxAgeRemoteAssertionGenerator`]({{home}}/doxygen/classasylo_1_1SgxAgeRemoteAssertionGenerator.html)
and
[`asylo::SgxAgeRemoteAssertionVerifier`]({{home}}/doxygen/classasylo_1_1SgxAgeRemoteAssertionVerifier.html)
classes that can be used to generate and verify attestations by the AGE for uses
outside of gRPC authentication.

In either usage scenario, users must run the AGE alongside their Asylo
application. Asylo provides a binary `age_main` that runs the AGE and allows
users to interact with its various entry-points. This can be run in either
production mode on real SGX hardware or in "fake" mode using SGX-simulation.

##### SGX Hardware

NOTE: This requires running on an Intel CPU that supports SGX with
[Flexible Launch Control (FLC)](https://software.intel.com/en-us/blogs/2018/12/09/an-update-on-3rd-party-attestation).

First, download Intel's architectural enclaves from
[Intel's website](https://download.01.org/intel-sgx/sgx-dcap/). This is
streamlined with the following commands (Note: only the `libsgx_pce.signed.so`
file is needed):

```shell
DCAP_VERSION="1.6" # Replace with the most up-to-date version available.

INTEL_ENCLAVES_PATH="/opt/intel_enclaves/${DCAP_VERSION}"
mkdir -p "${INTEL_ENCLAVES_PATH}"

curl -sL "https://download.01.org/intel-sgx/sgx-dcap/${DCAP_VERSION}/linux/prebuilt_dcap_${DCAP_VERSION}.tar.gz" \
| tar -xvz --strip=5 -C "${INTEL_ENCLAVES_PATH}"
```

Next, fetch a PCK certificate and issuer certificate chain for the target
machine. Asylo does not currently provide any tooling for this. Users are
referred to Intel's
[PCK Certificate Retrieval Tool](https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/tools/PCKRetrievalTool)
distributed with
[Intel SGX DCAP](https://github.com/intel/SGXDataCenterAttestationPrimitives).
Also see Intel's
[documentation](https://download.01.org/intel-sgx/latest/dcap-latest/linux/docs/Intel_SGX_ECDSA_QuoteLibReference_DCAP_API.pdf)
about provisioning an SGX platform with PCK certificates.

The certificate chain should be formatted as an
[`asylo::CertificateChain`]({{home}}/docs/reference/proto/crypto/asylo.certificate.v1.html).

Save the PCK certificate chain to a file, then set the environment variable
`${PCK_CERTIFICATE_CHAIN}` to that file's fully qualified path.

An example certificate chain textproto to store in that file:

```textproto

# proto-message: CertificateChain
certificates: {
  format: X509_PEM
  data: "-----BEGIN CERTIFICATE-----\n"
        "..<certificate_data>..\n"
        "-----END CERTIFICATE-----"
}
certificates: {
  format: X509_PEM
  data: "-----BEGIN CERTIFICATE-----\n"
        "..<certificate_data>..\n"
        "-----END CERTIFICATE-----"
}

```

Then, build the AGE:

```shell
bazel build --define="SGX_SIM=0" //asylo/identity/attestation/sgx/internal:remote_assertion_generator_enclave_sgx_hw.so
```

Set the environment variable `${AGE_PATH}` to the AGE binary's fully qualified
path.

```shell
AGE_PATH=/path/to/age/binary
```

Finally, run the AGE:

```shell
bazel run //asylo/identity/attestation/sgx:age_main -- \
--start_age \
--age_path="${AGE_PATH}" \
--issuer_certificate_chain="${PCK_CERTIFICATE_CHAIN}" \
--intel_enclaves_path="${INTEL_ENCLAVES_PATH}" \
```

##### SGX Simulation

WARNING: This mode runs the AGE as an SGX-simulation enclave and uses a
software-simulated PCE. Consequently, attestations produced in this mode will
**_not_** be rooted in the
[Intel SGX PKI](https://download.01.org/intel-sgx/dcap-1.1/linux/docs/Intel_SGX_PCK_Certificate_CRL_Spec-1.1.pdf).
This mode is suitable for testing attestation with Asylo applications.

First, build the AGE:

```shell
bazel build --define="SGX_SIM=1" //asylo/identity/attestation/sgx/internal:remote_assertion_generator_enclave_sgx_sim.so
```

Set the environment variable `${AGE_PATH}` to the AGE binary's fully qualified
path.

```shell
AGE_PATH=/path/to/age/binary
```

Then, run the AGE:

```shell
bazel run //asylo/identity/attestation/sgx:age_main -- \
--start_age \
--use_fake_pce \
--age_path="${AGE_PATH}"
```
