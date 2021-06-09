---

title: gRPC Authn and Authz

overview: Reference for authentication and authorization in Asylo gRPC.

location: /_docs/reference/grpc_auth.md

order: 30

layout: docs

type: markdown

toc: true

---

{% include home.html %}


## Introduction

Enclaves can be used to locally protect data at rest using sealing keys provided
by the hardware. To protect data in transit, it is necessary to establish a
secure, authenticated channel over which data is encrypted and
integrity-protected in transit to an authorized peer.

Secure communication channels are a fundamental building block for developing
large-scale, distributed systems of enclaves. However, commonly-used security
protocols like TLS don't support enclave identities, nor do they support the
unique attestation mechanisms available to enclaves. To solve this problem,
Asylo provides support for secure enclave gRPC communication channels where
enclave attestation is built into channel establishment by way of a novel
security protocol.

## Attestation During Channel Establishment

Asylo applications can host secure gRPC services inside their enclave. Such
enclavized gRPC services may handle security-sensitive RPCs and, consequently,
must be secured so that only authenticated and authorized peers can call those
RPCs.

Asylo provides a custom gRPC transport security stack that enables developers to
set up secure channels between enclavized applications. These channels are
backed by enclave attestation; in the case of SGX, these attestations are
produced by the hardware.

Asylo's gRPC security stack can be used to establish a secure channel between
two enclave applications, or between an enclave application and a non-enclave
application. In the process of creating a secure channel, the two endpoints
mutually authenticate and establish a shared key bound to their identities and
to the session. Asylo's gRPC transport security stack accomplishes this using a
key-exchange protocol that is enlightened about enclave identities like SGX
identities. Attestation is handled during channel establishment so each endpoint
is aware of its peer's identities when the channel is live.

### Enclave Key Exchange Protocol

The Enclave Key Exchange Protocol (EKEP) is an authenticated Elliptic Curve
Diffie-Hellman key negotiation protocol. This protocol is based on the
[Application Layer Transport Security (ALTS) handshake protocol](https://cloud.google.com/security/encryption-in-transit/application-layer-transport-security/#handshake_protocol),
which was developed by Google for securing RPC communications. The ALTS
handshake protocol has many desired properties of a key-negotiation protocol
used to establish communication to and from enclaves, but does not support
enclave identities.

EKEP is derived from the ALTS handshake protocol, but with several
modifications:

*   Participants can assert arbitrary identities
*   Participants can assert multiple identities
*   Participants negotiate which identities are asserted
*   Participants are always expected to use ephemeral Diffie-Hellman keys; if
    both participants comply, then perfect forward secrecy is guaranteed
*   Session resumption is unsupported

Note that although there are a number of similarities between the two protocols,
an EKEP endpoint is not compatible with an ALTS endpoint.

The specification for the Enclave Key Exchange Protocol can be found
[here]({{home}}/docs/concepts/ekep.html).

## Authentication

To configure security-related options on a gRPC endpoint (a client or server),
an entity must define the authentication policy that is to be enforced on a
channel. Such a policy specifies:

*   What types of identities the entity will accept from a peer
*   What types of identities the entity is willing to present to a peer

A client's and server's configurations are compatible if both of the following
are true:

*   The client is willing to present a non-empty subset of the types of
    identities accepted by the server
*   The server is willing to present a non-empty subset of the types of
    identities accepted by the client

If a client's and server's configurations are incompatible then a secure channel
cannot be created between the endpoints.

Asylo authentication policies are encapsulated within
[`asylo::EnclaveCredentialsOptions`]({{home}}/doxygen/structasylo_1_1EnclaveCredentialsOptions.html)
objects. Asylo provides various factories for commonly-used authentication
policies.

The following sections describe the various `asylo::EnclaveCredentialsOptions`
that are supported in Asylo.

### Bidirectional SGX Local Authentication

This credentials configuration enables the client and server to mutually
authenticate using SGX local attestation.

```c++
#include "asylo/grpc/auth/sgx_local_credentials_options.h"
```

```c++
asylo::EnclaveCredentialsOptions options = asylo::BidirectionalSgxLocalCredentialsOptions();
```

[SGX local attestation](https://software.intel.com/en-us/node/702983) is
facilitated by the CPU, which generates SGX hardware REPORTs for locally-running
enclaves. As a result, this configuration is only intended for channels set up
between two SGX enclaves running on the same SGX-capable CPU.

One important use for SGX local attestation is in communicating with Asylo's
[Assertion Generator Enclave (AGE)]({{home}}/docs/concepts/remote_attestation.html#asylo-assertion-generator-enclave).
A quoting enclave is an enclave that produces signed attestations, or _quotes_,
on behalf of other locally-running enclaves.

#### Enclave Configuration

To order to use SGX local attestation, an enclave must be configured to use the
SGX local assertion authority in its
[`asylo::EnclaveConfig`]({{home}}/docs/reference/proto/asylo.enclave.v1.html#EnclaveConfig),
which is passed to the enclave via
[`asylo::TrustedApplication::Initialize`]({{home}}/doxygen/classasylo_1_1TrustedApplication.html#afcdfb29385aeb42c0a9cb79180b79153):

```c++
#include "asylo/enclave.proto.h"
#include "asylo/identity/enclave_assertion_authority_config.proto.h"
#include "asylo/identity/enclave_assertion_authority_configs.h"
#include "asylo/util/statusor.h"
```

```c++
// See additional reference below about |attestation_domain|.
std::string attestation_domain = ...

asylo::StatusOr<asylo::EnclaveAssertionAuthorityConfig> result =
    asylo::CreateSgxLocalAssertionAuthorityConfig(attestation_domain);

if (!result.ok()) {
  // Log or return error
}

asylo::EnclaveConfig config;
*config.add_enclave_assertion_authority_configs() =
    std::move(result).value()
```

#### Reference

*   [SGX local credentials options documentation]({{home}}/doxygen/sgx__local__credentials__options_8h.html)
*   [`CreateSgxLocalAssertionAuthorityConfig()` documentation]({{home}}/doxygen/namespaceasylo.html#ac166310b0b726d04c9b42ded112ea66c)
*   [`SgxLocalAssertionAuthorityConfig` and "Attestation Domain" documentation]({{home}}/docs/reference/proto/identity/asylo.sgx_local_assertion_authority_config.v1.html)

### Bidirectional SGX Remote Authentication

This credentials configuration enables a client and server to mutually
authenticate using SGX remote attestation. It is based on quotes produced by
Asylo's
[Assertion Generator Enclave (AGE)]({{home}}/docs/concepts/remote_attestation.html#asylo-assertion-generator-enclave).

This configuration can only be used between two SGX enclaves.

```c++
#include "asylo/grpc/auth/sgx_age_remote_credentials_options.h"
```

```c++
asylo::EnclaveCredentialsOptions options =
    asylo::BidirectionalSgxAgeRemoteCredentialsOptions();
```

#### Enclave Configuration

In order to use SGX remote attestation, an enclave must be configured to use the
SGX remote assertion authority in its
[`asylo::EnclaveConfig`]({{home}}/docs/reference/proto/asylo.enclave.v1.html#EnclaveConfig),
which is passed to the enclave via
[`asylo::TrustedApplication::Initialize`]({{home}}/doxygen/classasylo_1_1TrustedApplication.html#afcdfb29385aeb42c0a9cb79180b79153):

```c++
#include "asylo/enclave.proto.h"
#include "asylo/identity/enclave_assertion_authority_config.proto.h"
#include "asylo/identity/enclave_assertion_authority_configs.h"
#include "asylo/identity/platform/sgx/sgx_identity.proto.h"
```

```c++
std::string age_server_address = ... // Set this to the address of the AGE's gRPC server.
asylo::SgxIdentity age_sgx_identity = ... // Set this to the AGE's expected identity.

asylo::EnclaveConfig config;
*config.add_enclave_assertion_authority_configs() =
    asylo::CreateSgxAgeRemoteAssertionAuthorityConfig(age_server_address,
                                                      age_sgx_identity);
```

#### Reference

*   [SGX AGE bidirectional remote credentials options documentation]({{home}}/doxygen/sgx__age__remote__credentials__options_8h.html)
*   [`CreateSgxAgeRemoteAssertionAuthorityConfig()` documentation]({{home}}/doxygen/namespaceasylo.html#ad8ed081abf7ba7312e4c1b1b2c27dd62)

### Unidirectional SGX Remote Authentication

Asylo also supports setting up connections in which only one side of the
connection uses SGX remote attestation. The peer does not have to be an SGX
enclave. Remote assertions are generated by Asylo's
[Assertion Generator Enclave (AGE)]({{home}}/docs/concepts/remote_attestation.html#asylo-assertion-generator-enclave).

To use unidirectional SGX remote attestation, the enclave endpoint that is using
SGX remote attestation should use the following configuration:

```c++
#include "asylo/grpc/auth/sgx_age_remote_credentials_options.h"
```

```c++
asylo::EnclaveCredentialsOptions options =
    asylo::SelfSgxAgeRemoteCredentialsOptions();
```

The peer that is verifying the enclave's identity should use the following
configuration:

```c++
#include "asylo/grpc/auth/peer_sgx_age_remote_credentials_options.h"
```

```c++
asylo::EnclaveCredentialsOptions options =
    asylo::PeerSgxAgeRemoteCredentialsOptions();
```

#### Enclave Configuration

Enclave configuration is similar to that described for
[Bidirectional SGX Remote Authentication](#bidirectional-sgx-remote-authentication).

A non-enclave peer verifier should use the following configuration in the
application setup:

```c++
std::string age_server_address = ...  // Set this to the address of the AGE's gRPC server.
asylo::SgxIdentity age_sgx_identity = ...  // Set this to the AGE's expected identity.

std::vector<asylo::EnclaveAssertionAuthorityConfig> configs =
    {asylo::CreateSgxAgeRemoteAssertionAuthorityConfig(age_server_address,
                                                       age_sgx_identity)};
asylo::InitializeEnclaveAssertionAuthorities(configs.begin(), configs.end());
```

#### Reference

*   [SGX AGE self remote credentials options documentation]({{home}}/doxygen/sgx__age__remote__credentials__options_8h.html)
*   [SGX AGE peer remote credentials options documentation]({{home}}/doxygen/peer__sgx__age__remote__credentials__options_8h.html)
*   [`CreateSgxAgeRemoteAssertionAuthorityConfig()` documentation]({{home}}/doxygen/namespaceasylo.html#ad8ed081abf7ba7312e4c1b1b2c27dd62)

### Bidirectional Null Authentication

This credentials configuration is used for a mutually unauthenticated
connection. This configuration can be used between any two enclave or
non-enclave entities.

```c++
#include "asylo/grpc/auth/null_credentials_options.h"
```

```c++
asylo::EnclaveCredentialsOptions options =
    asylo::BidirectionalNullCredentialsOptions();
```

WARNING: This is considered an insecure configuration, like using
[`grpc::InsecureChannelCredentials()`](https://grpc.io/docs/guides/auth/#c) on
the client and `grpc::InsecureServerCredentials()` on the server, and should not
be used for production systems. This configuration does provide channel
encryption but the channel is completely unauthenticated. You may find it useful
for testing your gRPC client and server before setting up real security policies
in your application.

Null credentials are most useful in setting up unidirectionally authenticated
connections, which are occasionally useful in production systems. See
[Custom Authentication Policy](#custom-authentication-policy) for more
information about setting up unidirectionally authenticated connections.

#### Enclave Configuration

In order to use null attestation, an enclave must be configured to use the null
assertion authority in its
[`asylo::EnclaveConfig`]({{home}}/docs/reference/proto/asylo.enclave.v1.html#EnclaveConfig),
which is passed to the enclave via
[`asylo::TrustedApplication::Initialize`]({{home}}/doxygen/classasylo_1_1TrustedApplication.html#afcdfb29385aeb42c0a9cb79180b79153):

```c++
#include "asylo/enclave.proto.h"
#include "asylo/identity/enclave_assertion_authority_config.proto.h"
#include "asylo/identity/enclave_assertion_authority_configs.h"
```

```c++
asylo::EnclaveConfig config;
*config.add_enclave_assertion_authority_configs() =
    asylo::CreateNullAssertionAuthorityConfig();
```

#### Reference

*   [Null credentials options documentation]({{home}}/doxygen/null__credentials__options_8h.html)
*   [`CreateNullAssertionAuthorityConfig()` documentation]({{home}}/doxygen/namespaceasylo.html#a88125b3707d0c495049e944fb1b2122a)

### Custom Authentication Policy

For situations where Asylo's pre-configured options do not match the exact
security requirements of an application, users can also craft a credentials
options object that reflects their custom authentication policy. This can be
done by combining `asylo::EnclaveCredentialsOptions` objects with the
[`asylo::EnclaveCredentialsOptions::Add()`]({{home}}/doxygen/structasylo_1_1EnclaveCredentialsOptions.html#ad17840319adbd66c6e20f884bb0db757)
method.

For example, to configure a secure channel in which the server authenticates
using SGX remote attestation attested, but the client is unauthenticated, we can
combine two credentials options objects:

```c++
#include "asylo/grpc/auth/null_credentials_options.h"
#include "asylo/grpc/auth/sgx_remote_credentials_options.h"
```

```c++
asylo::EnclaveCredentialsOptions options =
  asylo::PeerSgxLocalCredentialsOptions().Add(
      asylo::SelfNullCredentialsOptions());
```

The same pattern can be used to craft other more complex authentication
policies. Policies on self (i.e., which types of identities are presented to the
peer) are set with `Self*()` factories, and policies on the peer (i.e., which
types of identities are required to be presented by the peer) are set with
`Peer*()` factories.

### Server Credentials

The
[`asylo::EnclaveServerCredentials()`]({{home}}/doxygen/namespaceasylo.html#a41ae5afd47e724b67e79da0ef6d923fe)
function can be used to create a `grpc::ServerCredentials` that enforces the
authentication policy defined in a given `asylo::EnclaveCredentialsOptions`
object. The resulting credentials object can be used to build and start a gRPC
server.

```c++
#include "asylo/grpc/auth/enclave_credentials_options.h"
#include "asylo/grpc/auth/enclave_server_credentials.h"
```

```c++
// 1. Create credentials options to configure the server's authentication
// policy.
asylo::EnclaveCredentialsOptions credentials_options = …

// 2. Create a server credentials object.
std::shared_ptr<grpc::ServerCredentials> server_credentials =
  asylo::EnclaveServerCredentials(credentials_options);

// 3. Create a server using the credentials.
::grpc::ServerBuilder builder;
builder.AddListeningPort("localhost:1234", server_credentials);
```

### Channel Credentials

Configuring a gRPC client's authentication policy is similar to configuring a
gRPC server. The
[`asylo::EnclaveChannelCredentials()`]({{home}}/doxygen/namespaceasylo.html#a6172f61ca6679f7d266b9aebbbc5238b)
function can be used to create a `grpc::ChannelCredentials` object that enforces
the authentication policy defined in a given `asylo::EnclaveCredentialsOptions`
object. The resulting credentials object can be used to create a
`grpc::Channel`:

```c++
#include "asylo/grpc/auth/enclave_credentials_options.h"
#include "asylo/grpc/auth/enclave_channel_credentials.h"
```

```c++
// 1. Create credentials options to configure the client's authentication
// policy.
asylo::EnclaveCredentialsOptions credentials_options = …

// 2. Create a channel credentials object.
std::shared_ptr<grpc::ChannelCredentials> channel_credentials =
  asylo::EnclaveChannelCredentials(credentials_options);

// 3. Create a channel using the credentials.
std::shared_ptr<::grpc::Channel> channel =
     ::grpc::CreateChannel("localhost:1234", channel_credentials);
```

## Authorization

Enforcing an authentication policy on a channel ensures that a peer has
authenticated with an expected set of identities (e.g., *"My peer **must** be an
SGX enclave"*).

Most applications writers will also want to enforce authorization policies that
specify additional constraints on an accepted peer's identity (e.g., *"My peer
**must** be an SGX enclave signed by **Foo** and **must** have an ISVPRODID of 2
and an ISVSVN of 3 or higher”*).

Asylo allows users to develop and enforce complex authorization policies, both
client-side and server-side, in their applications:

*   Server-side authorization policies can be enforced at the channel level or
    at the call level.
*   Client-side authorization policies can be enforced only at the channel
    level.

### Defining an ACL

An ACL is defined as an
[`asylo::IdentityAclPredicate`]({{home}}/docs/reference/proto/identity/asylo.identity_acl.v1.html),
which is a recursive structure that allows individual conditions to be combined
with logical operators (`AND`, `OR`, and `NOT`). An
[`asylo::EnclaveIdentityExpectation`]({{home}}/docs/reference/proto/identity/asylo.identity.v1.html#EnclaveIdentityExpectation)
can be used to define a single expectation against an identity. An
`asylo::EnclaveIdentityExpectation` comprises a reference identity and a match
spec that is applied to that identity.

#### SGX Identity ACLs

ACLs for SGX identities are defined as
[`asylo::SgxIdentityExpectation`]({{home}}/docs/reference/proto/identity/asylo.sgx_identity.v1.html#SgxIdentityExpectation)
messages. An `asylo::SgxIdentityExpectation` is composed of an
[`asylo::SgxIdentity`]({{home}}/docs/reference/proto/identity/asylo.sgx_identity.v1.html#SgxIdentity)
and an
[`asylo::SgxIdentityMatchSpec`]({{home}}/docs/reference/proto/identity/asylo.sgx_identity.v1.html#SgxIdentityMatchSpec).
It can be serialized into the `match_spec` field of an
`asylo::EnclaveIdentityExpectation`.

Asylo provides several common variants of `asylo::SgxIdentityMatchSpec`:
`DEFAULT`, `STRICT_LOCAL`, and `STRICT_REMOTE`. These can be constructed with
[`asylo::CreateSgxIdentityMatchSpec`]({{home}}/doxygen/namespaceasylo.html#a22a059eec748ce444409556e72e35bd6),
and further modified to fit the exact expectation of an application. Match specs
are combined with identities to form expectations using
[`asylo::CreateSgxIdentityExpectation`]({{home}}/doxygen/namespaceasylo.html#abd6ac352ae3f0b0a2caa5d611e32392b).
See the
[`sgx_identity_util.h`]({{home}}/doxygen/sgx__identity__util_8h.html)
library for more operations on SGX identities, match specs, and expectations.

### Channel-level Authorization

A gRPC client or server can enforce an authorization policy at the channel level
by configuring the `asylo::EnclaveCredentialsOptions` object used to create the
`grpc::ClientCredentials` or `grpc::ServerCredentials` with a `peer_acl`:

```c++
asylo::EnclaveCredentialsOptions credentials_options = …
credentials_options.peer_acl = …
```

The `peer_acl` field contains an `asylo::IdentityAclPredicate` proto and can be
defined as described [above](#defining-an-acl).

Note that if the ACL is not met then the connection will be terminated. If more
fine-grained access-control is desired, consider using
[Call-level Authorization](#call-level-authorization-server-only) instead.

### Call-level Authorization (Server only)

#### Authentication Context

A gRPC server using Asylo's gRPC transport security stack can access the
authenticated peer's identities, as well as other properties of the channel,
through an
[`asylo::EnclaveAuthContext`]({{home}}/doxygen/classasylo_1_1EnclaveAuthContext.html)
object.

#### Evaluating an ACL

The
[`asylo::EnclaveAuthContext::EvaluateAcl()`]({{home}}/doxygen/classasylo_1_1EnclaveAuthContext.html#a3d64b4047b059c9964ef123075993416)
method can be used to evaluate the authenticated peer's identities against an
ACL.

```c++
#include "asylo/grpc/auth/enclave_auth_context.h"
#include "asylo/identity/identity_acl.proto.h"
```

```c++
::grpc::Status FooImpl::Bar(
    ::grpc::ServerContext *context,
    const BarRequest *request,
    BarResponse *response) {
  // Create an EnclaveAuthContext object.
  asylo::EnclaveAuthContext enclave_auth_context = …

  std::string explanation;
  asylo::IdentityAclPredicate acl = …
  auto evaluate_result = enclave_auth_context.EvaluateAcl(acl, &explanation);
  if (!evaluate_result.ok()) {
    // Log the error and/or return
  }
  if (!evaluate_result.value()) {
    // Peer is unauthorized! Log the explanation and/or return.
  }
}
```

#### Extracting Peer Identities

For more specialized use-cases, the peer's identities can be extracted and
examined directly using the
[`asylo::EnclaveAuthContext::FindEnclaveIdentity()`]({{home}}/doxygen/classasylo_1_1EnclaveAuthContext.html#a96674aceb617807a23c4b521da0110d8)
method. Users can select specific identities by specifying an
[`asylo::EnclaveIdentityDescription`]({{home}}/docs/reference/proto/identity/asylo.identity.v1.html).
See
[all supported identity types]({{home}}/doxygen/descriptions_8h.html).

```c++
#include "asylo/grpc/auth/enclave_auth_context.h"
#include "asylo/identity/descriptions.h"
#include "asylo/identity/identity.proto.h"
```

```c++
::grpc::Status FooImpl::Bar(
    ::grpc::ServerContext *context,
    const BarRequest *request,
    BarResponse *response) {
  // Create an EnclaveAuthContext object.
  asylo::EnclaveAuthContext enclave_auth_context = …

  asylo:: EnclaveIdentityDescription identity_description;
  // Select an SGX identity using the SGX identity description.
  asylo::SetSgxIdentityDescription(&identity_description);
  auto identity_result =
    enclave_auth_context.FindEnclaveIdentity(identity_description);
  if (!identity_result.ok()) {
    // Log the error and/or return
  }

 const asylo::EnclaveIdentity &identity = *identity_result.value();
 // Do something with |identity|.
 …
}
```
