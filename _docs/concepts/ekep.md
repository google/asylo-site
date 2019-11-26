---

title: Enclave Key Exchange Protocol (EKEP)

overview: An authenticated Diffie-Hellman key-negotiation protocol for secure channel establishment.

location: /_docs/concepts/ekep.md

order: 12

layout: docs

type: markdown

toc: true

---

{% include home.html %}


## Background

Enclave Key Exchange Protocol (EKEP) is the protocol used by the Asylo gRPC
security stack to establish secure gRPC sessions. EKEP is based on the
[ALTS handshake protocol](https://cloud.google.com/security/encryption-in-transit/application-layer-transport-security/#handshake_protocol).
While it follows the fundamental principles of the ALTS handshake protocol, EKEP
differs from the ALTS handshake protocol in the following aspects:

1.  EKEP always uses ephemeral Diffie-Hellman keys. If both participants comply,
    then perfect forward secrecy is guaranteed. Session resumption is not
    supported in EKEP. ALTS supports ephemeral Diffie-Hellman keys, but also
    supports session resumption based on previously-generated resumption
    tickets. Session resumption was dropped to keep the protocol and its
    implementation simple. We may revisit this limitation in the future if there
    is a strong need to support session resumption.
1.  EKEP requires that participants present credentials that are
    cryptographically bound to a challenge provided by their peer during the
    handshake. This prevents attackers that steal a participant's ephemeral
    credentials from spoofing that participant in the future.
1.  EKEP allows each participant to assert multiple identities. The key exchange
    succeeds only if each peer can verify all identities asserted by their peer.
    This feature of EKEP allows participants to enforce rich authorization
    policies like "A peer can only talk to me if it is running in enclave *foo*
    and has a key that is certified by CA *bar*."
1.  EKEP adds two messages that allow the participants to negotiate which
    assertions will be exchanged, along with any information necessary for
    generating those assertions.

## Handshake Ciphersuites

An EKEP ciphersuite specifies a Diffie-Hellman (DH) group and a cryptographic
hash function. EKEP currently supports only one handshake ciphersuite.

```protobuf
enum HandshakeCipher {
    UNKNOWN_HANDSHAKE_CIPHER = 0;
    CURVE25519_SHA256 = 1;
}
```

Note that, unlike the ALTS handshake protocol, EKEP only supports ephemeral
keys, and consequently there is no distinction between ephemeral and
non-ephemeral ciphersuites.

## Record Protocols

A record protocol specifies a ciphersuite to use after the EKEP handshake
successfully completes. EKEP supports the
[ALTS record protocol](https://cloud.google.com/security/encryption-in-transit/application-layer-transport-security/#record_protocol)
with 128-bit AES keys in GCM mode.

```protobuf
enum RecordProtocol {
    UNKNOWN_RECORD_PROTOCOL = 0;
    ALTSRP_AES128_GCM = 1;
}
```

## EKEP Protocol Version

Versions of the EKEP protocol are represented as strings. The first and current
version of EKEP is `"EKEP v1"`.

```protobuf
message EkepVersion {
  optional string name = 1;
}
```

## Additional Authenticated Data

EKEP allows participants to specify additional authenticated data that is used
to configure the session and is authenticated during the handshake. This data is
sent in the clear, so it should not contain any secrets.

```protobuf
message AdditionalAuthenticatedData {
  optional bytes data = 1;
}
```

## Identity

EKEP supports the following identity types.

```protobuf
enum EnclaveIdentityType {
  UNKNOWN_IDENTITY = 0;
  NULL_IDENTITY = 1;
  CODE_IDENTITY = 2;
  CERT_IDENTITY = 3;
}
```

`NULL_IDENTITY` indicates an identity that has no associated cryptographic
credentials. `CODE_IDENTITY` indicates an identity associated with a code
measurement (e.g., an SGX enclave's code identity). `CERT_IDENTITY` indicates an
identity associated with a certificate that is issued by some trusted
certification authority (e.g., an X.509 certificate). These labels are just used
for classification purposes and have no impact on the protocol.

## Assertion

An assertion is a cryptographically verifiable statement of an identity; an
identity corresponding to a given assertion is said to be *asserted* by that
assertion. An assertion has the following format.

```protobuf
message AssertionDescription {
  optional EnclaveIdentityType identity_type = 1;
  optional string authority_type = 2;
}

message Assertion {
  optional AssertionDescription description = 1;
  optional bytes assertion = 2;
}
```

The `description` field describes two aspects of the assertion:

*   The type of enclave identity that is asserted
*   The assertion authority that is associated with the assertion

An *assertion authority* is an entity responsible for handling generation and
verification of a particular assertion type. An assertion authority consists of:

*   An *assertion generator*, which is responsible for generating assertions
*   An *assertion verifier*, which is responsible for verifying assertions

All assertion authorities possess a unique name. The name of an assertion
authority may refer to an enclave technology or enclave architecture associated
with the assertion, as well as any method used to produce or verify an
assertion. For example, the string `"SGX Local"` is used to denote the assertion
authority that handles SGX-based assertions between enclaves on the same (local)
platform. The string `"Any"` is used for assertions that are not associated with
any particular assertion authority, such as the null assertion.

The `assertion` field contains the raw bytes of the assertion. The exact format
and interpretation of these bytes is up to the assertion authority that is used
to generate and verify the assertion. One possible use of this field is to
encode a serialized protocol-buffer message.

To illustrate an example of an assertion, we point readers to the
[SGX local assertion](https://github.com/google/asylo/blob/master/asylo/identity/sgx/local_assertion.proto),
which is an assertion of an SGX enclave's code identity. Such an assertion can
be described by setting the description to an identity type of `CODE_IDENTITY`
and the `"SGX Local"` assertion authority. The `assertion` field itself is set
to the raw bytes of an SGX REPORT structure.

### Assertion Generation and Verification

Before exchanging assertions, EKEP participants first generate and exchange
ephemeral Diffie-Hellman key-pairs and unique challenges. The size of the DH
public key depends on the ciphersuite in use. The challenge is a 32-byte random
value that should be produced by a CSRNG.

An assertion binds an identity to two parameters -- the participant's DH public
key and some additional binding data. The size of the additional binding data as
well as the exact binding mechanism depend on the assertion type and the
handshake ciphersuite. In the context of EKEP, the additional binding data is
always a hash of the EKEP [transcript](#transcript) up to that point. Note that
the transcript used by each participant includes the precommit message
(described below in [CLIENT_PRECOMMIT Message](#client_precommit-message),
[SERVER_PRECOMMIT Message](#server_precommit-message)) from their peer, which
contains the peer's challenge. As a result, each of a participant's assertions
effectively binds an asserted identity to the peer-provided challenge.

EKEP allows participants to assert multiple identities within a single
handshake. All identities asserted by a participant must be bound to the same DH
public key. A handshake succeeds only if both participants are able to
successfully verify all assertions presented by their peer, and if each asserted
identity is bound to both the participant's DH public key and the handshake
transcript.

For EKEP to be compatible with a particular type of assertion, the assertion
must have an associated assertion generator and assertion verifier available.
[Asylo](https://github.com/google/asylo/tree/master/asylo/identity) provides a
number of assertion generator and assertion verifier libraries that can be used
to generate and verify assertions for code-based identities, certificate-based
identities, and null identities. These concepts are implemented as subclasses of
the
[`asylo::EnclaveAssertionGenerator`]({{home}}/doxygen/classasylo_1_1EnclaveAssertionGenerator.html)
and
[`asylo::EnclaveAssertionVerifier`]({{home}}/doxygen/classasylo_1_1EnclaveAssertionVerifier.html)
interfaces.

### Assertion Offers

Before exchanging assertions, EKEP participants first exchange *assertion
offers*. An assertion offer describes an assertion that a participant is capable
of producing, and has the following format:

```protobuf
message AssertionOffer {
    optional AssertionDescription description = 1;
    optional bytes additional_information = 2;
}
```

The `description` field uniquely identifies the assertion authority capable of
handling the assertion being offered. Some assertion verifiers may require
additional information to determine whether the assertion offer is acceptable.
The `additional_information` field can be used to store such information. Note
that `additional_information` is just a bytes field. The interpretation of these
bytes is specific to the assertion authority that handles the offer. One
possible usage of this field is to store a serialized protocol-buffer message.

As an illustration, consider an offer for an SGX local assertion. The offer can
be described by setting the description to an identity type of `CODE_IDENTITY`
and the `"SGX Local"` assertion authority. Note that since SGX local
attestations can only be verified by other enclaves running on the same physical
platform, participants must first exchange machine identifiers, or *local
attestation domains*, to determine whether local attestation is appropriate.
This information is encoded in the `additional_info` field of the offer using
the following serialized protocol-buffer message:

```protobuf
message SgxLocalAssertionOfferAdditionalInfo {
    optional string local_attestation_domain = 1;
}
```

This is just one example of how the `additional_information` field could be used
to encode additional data for the peer. The `additional_information` field
provides a general-purpose mechanism for exchanging information related to an
assertion offer. It is up to an assertion authority to determine whether to make
use of this field and how to populate it.

### Assertion Requests

In addition to exchanging assertion offers in the opening message of the
handshake, EKEP participants also exchange assertion requests. An assertion
request describes an assertion that is accepted by a participant. A client's
assertion request does not necessarily need to be fulfilled, but a server's
assertion request must be fulfilled. An assertion request has the following
format:

```protobuf
message AssertionRequest {
    optional AssertionDescription description = 1;
    optional bytes additional_information = 2;
}
```

As in an assertion offer, the `description` field uniquely identifies the
assertion authority capable of handling the requested assertion. Some assertion
generators may require additional information to determine whether the assertion
request can be fulfilled. The `additional_information` field can be used to
store such information. Again, the interpretation of this field is specific to
the assertion authority that handles the offer. One possible usage of this field
might be to store a serialized protocol-buffer message.

As an example of an assertion request, consider a request for an SGX local
assertion. The request's description is set to indicate an identity type of
`CODE_IDENTITY` and the `"SGX Local"` assertion authority. Since an SGX
attestation must be targeted at a particular enclave, the participant requesting
the assertion includes a TARGETINFO value specifying themself as the target
enclave in the request. Additionally, since SGX local assertions can only be
exchanged between enclaves on the same machine, the participant also includes a
unique machine identifier, or *local attestation domain*, in the request. These
two values are encoded in the `additional_information` field using the following
serialized protocol-buffer message:

```protobuf
message LocalAssertionRequestAdditionalInfo {
    optional bytes target = 1;
    optional bytes local_attestation_domain = 2;
}
```

## Framing

EKEP messages are framed as shown below (offsets are shown in bytes):

 {% include figure.html width='80%' ratio='46.36%' img='./images/ekep-frame.svg' alt='EKEP framing' title='EKEP framing' caption='EKEP framing' %} 

`size` and `message-type` are both 32-bit little-endian unsigned integers.
`message` is a serialized protocol buffer message.

## Transcript

An EKEP _transcript_ is the concatenation of all [handshake frames](#framing)
exchanged so far in an EKEP handshake. Handshake frames are concatenated in the
order in which they arrive.

For example, consider the transcript after the `SERVER_ID` message is received.

We use the following notation:

*   **P<sub>C</sub>** is the EKEP frame containing the `CLIENT_PRECOMMIT`
    message
*   **P<sub>S</sub>** is the EKEP frame containing the `SERVER_PRECOMMIT`
    message
*   **I<sub>C</sub>** is the EKEP frame containing the `CLIENT_ID` message
*   **I<sub>S</sub>** is the EKEP frame containing the `SERVER_ID` message

Using this notation, the transcript at this stage in the protocol is computed as
follows:

<code>transcript = (**P<sub>C</sub>** || **P<sub>S</sub>** || **I<sub>C</sub>**
|| **I<sub>S</sub>**)</code>

Note that a transcript is a complete and cumulative record of the data sent
during the handshake (i.e. no data added to the transcript is ever removed).
Additionally, since participants exchange nonces and ephemeral DH public keys
during an EKEP handshake, the transcript for an EKEP session contains data that
is unique to that session. This provides the useful property that a transcript
of an EKEP handshake uniquely represents that handshake. It follows that a
cryptographic hash computed over a transcript also uniquely represents that EKEP
handshake.

A cryptographic hash of an EKEP transcript is computed using the negotiated
ciphersuite, and is used at various points during the protocol, including:

*   [Assertion Generation and Verification](#assertion-generation-and-verification)
*   [Deriving EKEP Secrets](#deriving-ekep-secrets)

## Handshake

### Message Types

An EKEP handshake uses the following message types.

```protobuf
enum MessageType {
  UNKNOWN_MESSAGE = 0;
  ABORT = 100;
  CLIENT_PRECOMMIT = 101;
  SERVER_PRECOMMIT = 102;
  CLIENT_ID = 103;
  SERVER_ID = 104;
  SERVER_FINISH = 105;
  CLIENT_FINISH = 106;
}
```

Each of these message types corresponds to a protocol buffer message that can be
exchanged during an EKEP handshake.

### Handshake Sequence

The goal of the EKEP handshake is to establish shared keying material for a
session. EKEP achieves this through a six-message handshake between the
participants.

 {% include figure.html width='80%' ratio='100%' img='./images/ekep-handshake.svg' alt='EKEP Handshake' title='EKEP Handshake' caption='EKEP Handshake' %} 

Subsequent sections describe the formats of EKEP handshake messages and the
message-specific verification procedures in detail.

## `ABORT` Message

An `ABORT` message is sent by an EKEP participant when it detects an error. Once
a participant receives an `ABORT` message from its peer, it must immediately
terminate the handshake. An `ABORT` message has the following format.

```protobuf
message AbortMessage {
  enum ErrorCode {
    UNKNOWN_ERROR_CODE = 0;
    BAD_MESSAGE = 1;
    DESERIALIZATION_FAILED = 2;
    BAD_PROTOCOL_VERSION = 3;
    BAD_HANDSHAKE_CIPHER = 4;
    BAD_RECORD_PROTOCOL = 5;
    BAD_AUTHENTICATOR = 6;
    BAD_ASSERTION_TYPE = 7;
    BAD_ASSERTION = 8;
    PROTOCOL_ERROR = 9;
    INTERNAL_ERROR = 10;
  }
  optional ErrorCode code = 1;
  optional string message = 2;
}
```

## `CLIENT_PRECOMMIT` Message

#### `CLIENT_PRECOMMIT` format

`CLIENT_PRECOMMIT` is the first message in an EKEP handshake, and has the
following format.

```protobuf
message ClientPrecommit {
  repeated EkepVersion available_ekep_versions = 1;
  repeated HandshakeCipher available_cipher_suites = 2;
  repeated RecordProtocol available_record_protocols = 3;
  optional AdditionalAuthenticatedData options = 4;
  repeated AssertionOffer client_offers = 5;
  repeated AssertionRequest client_requests = 6;
  optional bytes challenge = 7;
}
```

It has the following constraints:

*   `available_ekep_versions` lists the client's available EKEP versions in
    order of preference
*   `available_cipher_suites` lists the client's available cipher suites in
    order of preference
*   `available_record_protocols` lists the client's available record protocols
    in order of preference
*   `challenge` must contain exactly 32 bytes of random data

#### Server validation of `CLIENT_PRECOMMIT`

The server examines `CLIENT_PRECOMMIT` messages for compatibility. If it detects
any of the following incompatibilities, it sends an `ABORT` message with the
specified error type:

*   `BAD_HANDSHAKE_CIPHER`: If none of the client's available cipher suites are
    acceptable
*   `BAD_ASSERTION_TYPE`: If none of the client's offered assertion types are
    acceptable to the server, or if none of the client's requested assertion
    types can be presented by the server
*   `PROTOCOL_ERROR`: If the client did not provide exactly 32 bytes of random
    data
*   `BAD_RECORD_PROTOCOL`: If none of the client's available record protocols
    are acceptable
*   `BAD_PROTOCOL_VERSION`: If none of the client's available EKEP versions are
    acceptable

## `SERVER_PRECOMMIT` Message

#### `SERVER_PRECOMMIT` format

If server validation of a `CLIENT_PRECOMMIT` succeeds, then the server sends a
`SERVER_PRECOMMIT` message, which has the following format.

```protobuf
message ServerPrecommit {
  optional EkepVersion selected_ekep_version = 1;
  optional HandshakeCipher selected_cipher_suite = 2;
  optional RecordProtocol selected_record_protocol = 3;
  optional AdditionalAuthenticatedData options = 4;
  repeated AssertionOffer server_offers = 5;
  repeated AssertionRequest server_requests = 6;
  optional bytes challenge = 7;
}
```

It has the following constraints:

*   `server_requests` is a non-empty subset of the assertions that were offered
    by the client in the `CLIENT_PRECOMMIT` message
*   `server_offers` is a non-empty subset of the assertions that were requested
    by the client in the `CLIENT_PRECOMMIT` message
*   `selected_ekep_version` is available to the client. A server is expected to
    select the most recent EKEP version available to both the server and client,
    although there is no way for the client to verify this.
*   `selected_record_protocol` is a protocol from `available_record_protocols`
    presented by the client in the `CLIENT_PRECOMMIT` message
*   `selected_cipher_suite` is a cipher suite from `available_cipher_suites`
    presented by the client in the `CLIENT_PRECOMMIT` message
*   `challenge` must contain exactly 32 bytes of random data

#### Client validation of `SERVER_PRECOMMIT`

The client examines `SERVER_PRECOMMIT` messages for compatibility. If any of the
following conditions are true, then the client sends an `ABORT` message with a
PROTOCOL_ERROR code:

*   `selected_ekep_version` is not a version offered by the client
*   `selected_record_protocol` is not a record protocol offered by the client
*   `selected_cipher_suite` is not a cipher suite offered by the client
*   `server_requests` is not a non-empty subset of the assertions that were
    offered by the client
*   `server_offers` is not a non-empty subset of the assertions that were
    requested by the client
*   `challenge` does not contain exactly 32 bytes of random data

## `CLIENT_ID` Message

#### `CLIENT_ID` format

If client validation of the server's `SERVER_PRECOMMIT` succeeds, the client
prepares a `CLIENT_ID` message based on parameters included in the
`SERVER_PRECOMMIT` message. The client generates a verifiable assertion to
satisfy each `AssertionRequest` in the `SERVER_PRECOMMIT` message.

A `CLIENT_ID` message has the following format.

```protobuf
message ClientId {
    optional bytes dh_public_key = 1;
    repeated Assertion assertions = 2;
}
```

It has the following constraints:

*   `dh_public_key` is a valid public key for the negotiated cipher suite
*   `assertions` is the set of assertions requested by the server in the
    `SERVER_PRECOMMIT` message
*   Each assertion in `assertions` is bound to `dh_public_key` and the handshake
    transcript

#### Server validation of `CLIENT_ID`

After receiving a `CLIENT_ID` message, the server verifies all assertions
included in that message. The server sends an `ABORT` message with a
BAD_ASSERTION error code if any of the following are true:

*   One or more of the assertions in `assertions` cannot be verified
*   One or more of the assertions in `assertions` is not bound to
    `dh_public_key`
*   One or more of the assertions in `assertions` is not bound to the handshake
    transcript containing messages up to and including the `SERVER_PRECOMMIT`
    message
*   `assertions` is not the set of assertions requested by the server in
    `server_requests` of the `SERVER_PRECOMMIT` message

If the `CLIENT_ID` message passes validation, the server uses its own DH private
key, the client's `dh_public_key`, and the negotiated Diffie-Hellman group to
generate a shared secret.

## `SERVER_ID` Message

#### `SERVER_ID` format

Next, the server prepares a `SERVER_ID` message based on parameters included in
the `CLIENT_PRECOMMIT` message. The server generates a verifiable assertion to
satisfy each `AssertionOffer` in the `SERVER_PRECOMMIT` message.

A `SERVER_ID` message has the following format.

```protobuf
message ServerId {
    optional bytes dh_public_key = 1;
    repeated Assertion assertions = 2;
}
```

It has the following constraints:

*   `dh_public_key` is a valid public key for the negotiated cipher suite
*   `assertions` is the set of assertions offered by the server in the
    `SERVER_PRECOMMIT` message
*   Each assertion in `assertions` is bound to `dh_public_key` and the handshake
    transcript

#### Client validation of `SERVER_ID`

After receiving a `SERVER_ID` message, the client verifies all the assertions
provided by the server. The client sends an `ABORT` message with a
`BAD_ASSERTION` error code if any of the following conditions hold:

*   One or more of the assertions in `assertions` cannot be verified
*   One or more of the assertions in `assertions` is not bound to
    `dh_public_key`
*   One or more of the assertions in `assertions` is not bound to the handshake
    transcript containing messages up to and including the `CLIENT_ID` message
*   `assertions` is not the set of assertions offered by the server in
    `server_offers` of the `SERVER_PRECOMMIT` message

If the `SERVER_ID` message passes validation, the client uses its own DH private
key, the server's `dh_public_key`, and the negotiated Diffie-Hellman group to
generate a shared secret.

## `SERVER_FINISH` Message

#### `SERVER_FINISH` format

After sending a `SERVER_ID` message, the server is able to derive a Master
Secret **M<sub>S</sub>** and an Authenticator Secret **A<sub>S</sub>**[^1]. This
is done as described in [Deriving EKEP Secrets](#deriving-ekep-secrets).

The server then derives `handshake_authenticator` as follows:

<code>handshake_authenticator = HMAC-H(**A<sub>S</sub>**,
**T<sub>S</sub>**)</code>

We use the following definitions in the above computation:

*   **H** is the hash function from the negotiated `HandshakeCipher`
*   **HMAC-H** is the HMAC function (as defined in
    [RFC 2104](https://www.ietf.org/rfc/rfc2104.txt)) instantiated with **H**
*   **T<sub>S</sub>** is `"EKEP Handshake v1: Server Finish"` as a UTF-8
    encoded, non null-terminated string, and is used as the `text` parameter.
*   **A<sub>S</sub>** is the Authenticator Secret computed by the server, and is
    used as the key.

After computing a <code>handshake_authenticator</code>, the server sends a
`SERVER_FINISH` message, which has the following format.

```protobuf
message ServerFinish {
    optional bytes handshake_authenticator = 1;
}
```

#### Client validation of `SERVER_FINISH`

The client verifies that:

<code>handshake_authenticator ≟ HMAC-H(**A<sub>C</sub>**,
**T<sub>S</sub>**)</code>

Where **T<sub>S</sub>**, **A<sub>C</sub>**, and **HMAC-H** have the same
definitions as before.

If the client's HMAC value does not match, the client aborts the handshake by
sending an `ABORT` message with a `BAD_AUTHENTICATOR` error code.

## `CLIENT_FINISH` Message

#### `CLIENT_FINISH` format

If the client verification of the `SERVER_ID` and the `SERVER_FINISH` messages
succeeded, then the client can derive the shared secret using the server's DH
public key (also constant within all assertions provided by the server), its own
DH private key, and the negotiated Diffie-Hellman group. The client then derives
**M<sub>C</sub>** and **A<sub>C</sub>** as described in
[Deriving EKEP Secrets](#deriving-ekep-secrets).

The client then computes `handshake_authenticator` as follows:

<code>handshake_authenticator = HMAC-H(**A<sub>C</sub>**,
**T<sub>C</sub>**</code>)

We use the following definitions in the above computation:

*   **H** is the hash function from the negotiated `HandshakeCipher`
*   **HMAC-H** is the HMAC function (as defined in
    [RFC 2104](https://www.ietf.org/rfc/rfc2104.txt)) instantiated with **H**
*   **T<sub>C</sub>** is `"EKEP Handshake v1: Client Finish"` as a UTF-8
    encoded, non null-terminated string, and is used as the `text` parameter.
*   **A<sub>C</sub>** is the Authenticator Secret computed by the client, and is
    used as the key.

After computing a <code>handshake_authenticator</code>, the client sends a
`CLIENT_FINISH` message, which has the following format.

```protobuf
message ClientFinish {
    optional bytes handshake_authenticator = 1;
}
```

#### Server validation of `CLIENT_FINISH`

The server verifies that:

<code>handshake_authenticator ≟ HMAC-H(**A<sub>S</sub>**,
**T<sub>C</sub>**)</code>

Where **T<sub>C</sub>**, **A<sub>S</sub>**, and **HMAC-H** have the same
definitions as before.

If the server's HMAC value does not match, the server silently closes the
connection without sending an `ABORT` message (no handshake messages are
exchanged after a `CLIENT_FINISH` message is sent).

## Deriving EKEP Secrets

Based on the first four handshake messages exchanged, the client and server both
derive two additional secrets: a Master Secret **M** and an Authenticator Secret
**A**.

**M** and **A** are both 512 bits in size.

We use the following definitions:

*   **HKDF-Extract** and **HKDF-Expand** are used as defined in
    [RFC-5869](https://tools.ietf.org/html/rfc5869). Both are instantiated using
    the hash function **H**.
*   **P<sub>C</sub>** is the EKEP frame containing the `CLIENT_PRECOMMIT`
    message
*   **P<sub>S</sub>** is the EKEP frame containing the `SERVER_PRECOMMIT`
    message
*   **I<sub>C</sub>** is the EKEP frame containing the `CLIENT_ID` message
*   **I<sub>S</sub>** is the EKEP frame containing the `SERVER_ID` message
*   **H** is the hash function from the negotiated `HandshakeCipher`
*   **S<sub>1</sub>** is `"EKEP Handshake v1"` as a UTF-8 encoded, non
    null-terminated string, and is used as the `salt` parameter in
    **HKDF-Extract**.
*   **C** is the ephemeral shared secret derived from the client and server's DH
    parameters using the negotiated Diffie-Hellman group, and is the key in
    **HKDF-Extract**.

A pseudo-random key **K<sub>1</sub>** is derived as follows:

<code>**K<sub>1</sub>** = HKDF-Extract(**S<sub>1</sub>**, **C**)</code>

**M** and **A** are derived as follows:

<code>(**M** || **A**) = HKDF-Expand(**K<sub>1</sub>**, **H**(**P<sub>C</sub>**
|| **P<sub>S</sub>** || **I<sub>C</sub>** || **I<sub>S</sub>**)), (512 * 2) /
8)</code>

## Deriving Record Protocol Secrets

After a successful EKEP handshake, a client and server both derive a key of
appropriate length for the negotiated record protocol. Note that any errors that
occur during derivation of the record-protocol key are not treated as handshake
protocol errors. If a participant encounters an error during key derivation,
they must not send an Abort message and must instead silently close the
connection.

We use the symbols defined and derived in
[Deriving EKEP Secrets](#deriving-ekep-secrets). Additionally, we use the
following new definitions:

*   **F<sub>C</sub>** is the EKEP frame containing the `CLIENT_FINISH` message
*   **F<sub>S</sub>** is the EKEP frame containing the `SERVER_FINISH` message
*   **S<sub>2</sub>** is `"EKEP Record Protocol v1"` as a UTF-8 encoded, non
    null-terminated string
*   **L** is the length of the key needed for the record protocol (in bytes)

The record protocol key **X** is derived through another iteration of HKDF, as
follows:

<code>**K<sub>2</sub>** = HKDF-Extract(**S<sub>2</sub>**, **M**)</code>

<code>**X** = HKDF-Expand(**K<sub>2</sub>**, **H**(**P<sub>C</sub>** ||
**P<sub>S</sub>** || **I<sub>C</sub>** || **I<sub>S</sub>** || **F<sub>C</sub>**
|| **F<sub>S</sub>**), **L**)</code>

<!-- Footnotes themselves at the bottom. -->

## Notes

[^1]: **A<sub>S</sub>** and **A<sub>C</sub>** refer to the Authenticator Secret
    **A** derived by the server and the client respectively. In a successful
    EKEP handshake, **A<sub>S</sub>** and **A<sub>C</sub>** are expected to
    take on the same value. (Likewise for **M<sub>S</sub>** and
    **M<sub>C</sub>**).
