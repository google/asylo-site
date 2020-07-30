---

title: Asylo Remote Backend

overview: Technical dive into the inner workings of Remote Backend

location: /_docs/concepts/remote-backend.md

order: 60

layout: docs

type: markdown

---

{% include home.html %}


## Introduction

The Asylo Enclave Remote Backend (`RemoteBackend`) utilizes two gRPC peering
agents, [`RemoteEnclaveProxyClient`](#remoteenclaveproxyclient) (`ProxyClient`)
on the host machine running inside the Untrusted application, and
[`RemoteEnclaveProxyServer`](#remoteenclaveproxyserver) (`ProxyServer`) on the
target server wrapping the Enclave. All Enclave calls and Untrusted calls are
still made with the Asylo API, but are forwarded from one gRPC agent to the
other.

Local enclaves provide execution isolation by means of SGX or another Trusted
Execution Environment (TEE). `RemoteBackend` provides execution isolation by
placing the enclave on a separate target server. The target server can have the
security properties required by the user application, whether that be SGX,
AMD-SEV, or physical security.

The underlying technology, gRPC, allows users to place the user application and
target server across any network routable space. For instance, the user
application could be placed in the cloud, while the target server could be
placed on-prem, or vice versa.

In this concepts guide we will do a deep technical dive into the inner workings
of the `RemoteBackend`. This guide assumes technical knowledge of the
[Asylo API]({{home}}/docs/concepts/api-overview.html) model.

## Primary Components

### RemoteEnclaveProxyClient

The `RemoteEnclaveProxyClient` implements
[`primitives::Client`](https://github.com/google/asylo/blob/master/asylo/platform/primitives/untrusted_primitives.h#L85)
and runs in the application on the host machine.

As part of configuration for the `ProxyClient` an implementation of
`RemoteProvision` must be provided. `RemoteProvision` describes two functions:

-   `Provision()` (required):

    `Provision()` provides the `ProxyClient` with a means to launch the
    requisite `ProxyServer`. This can be by means of the provided
    [RemoteProxyProvisionServer](#localremoteproxyprovision-and-remoteproxyprovisionserver),
    the provided
    [LocalRemoteProxyProvision](#localremoteproxyprovision-and-remoteproxyprovisionserver),
    or a custom implementation provided by the user.

-   `Finalize()` (optional):

    `Finalize()` is called during the `EnclaveManager::Destroy` call, and
    performs final actions prior to destroying the `ProxyClient`. `Finalize()`
    must be safe to call more than once.

### RemoteEnclaveProxyServer

The `RemoteEnclaveProxyServer` runs on the machine with the TEE. The
`ProxyServer` loads an enclave, handles entry calls, and will finally terminate
the enclave upon request from the `ProxyClient`. All untrusted exit calls made
by the loaded enclave will be forwarded to the untrusted application and
performed on the non-TEE machine.

### RemoteProxyClientConfig

The `RemoteProxyClientConfig` provides the client with the `Provision` object,
necessary to launch a `ProxyServer`, and the proper credentials to connect to
it. It is held by the `EnclaveLoadConfig` and passed to the `ProxyClient` via
the `EnclaveManager` during the `LoadEnclave` call.

### Communicator

`Communicator` performs all calls between the `ProxyClient` and `ProxyServer`
and handles connection and disconnection between the two. Currently
`Communicator` only supports IPv6.

## Local vs Remote Enclave Lifecycle

The lifecycle of an Asylo Enclave is largely unchanged in the Remote case. The
enclave is still loaded and initialized on an `EnclaveManager::LoadEnclave`
call, and will live and respond to `EnterAndRun` calls until an
`EnclaveManager::DestroyEnclave` call is made.

There are two key differences to the lifecycle:

1.  During the `EnclaveManager::LoadEnclave` call two additional steps are
    performed:

    -   The `ProxyClient` will call `RemoteProvision::Provision()` in order to
        start a `ProxyServer` and inform it of the address and port the
        `ProxyClient` is running on.
    -   The `ProxyClient` will make a blocking call to
        `WaitForEndPointAddress()`, where it will wait for the `ProxyServer` to
        initiate connection.

2.  Termination of `ProxyClient` or `ProxyServer` outside of normal operations
    (i.e. kill -9, or power loss) may cause the application to terminate or
    behave unexpectedly.

## Utilities

`RemoteBackend` requires additional steps for setup, configuration, and
monitoring. To aid in this, Asylo has added several utilities.

### LocalRemoteProxyProvision and RemoteProxyProvisionServer

Provisioning a `ProxyServer` is one of the key steps to starting the
`RemoteBackend` loading an enclave remotely. In addition to `RemoteProvision`,
where an Asylo user can implement their own Provisioning service, Asylo provides
two sample `RemoteProvision` implementations. It is likely that neither
provisioning service is sufficient for production use cases, but they can be a
guide in developing your own provisioning service.

`LocalRemoteProxyProvision` launches a `ProxyServer` on the local machine. Its
primary use is for testing. The user flow is to start a `ProxyClient` configured
to use `LocalRemoteProxyProvision`, and use the `--remote_proxy` flag to pass
the path to the desired remote proxy. `LocalRemoteProxyProvision` will take care
of all the provisioniong and connection.

`RemoteProxyProvisionServer` launches a `ProxyServer` on a remote machine. The
user flow is to start a `RemoteProxyProvisionServer` on the remote machine, and
then start a `ProxyClient` on a local machine. The `ProxyClient` will contact
the `RemoteProxyProvisionServer`, send the enclave across the wire, and request
a `ProxyServer`. The `ProxyServer` will start, and the
`RemoteProxyProvisionServer` will pass back the address for the `ProxyServer`.
The `ProxyClient` then communicates with the `ProxyServer` per normal
operations.

### `GrpcChannelBuilder`

gRPC channels are relatively simple to setup, but managing configuration and
credentialing between numerous gRPC servers and clients can become burdensome.
To aid in this Asylo has developed the `GrpcChannelBuilder`. It’s purpose is to
allow users to easily configure each gRPC server at runtime.

If used, `GrpcChannelBuilder` introduces 3 commandline flags:

1.  `--security_type`:

    Can be one of either `local` or `ssl` and defaults to `local`.

    -   `local`: Utilizes gRPC::Insecure\*Credentials(), these credentials
        provide no authentication and data could be spoofed or intercepted.

    -   `ssl`: Utilizes gRPC::Ssl\*Credentials(), these credentials provide the
        added benefit of secure authentication, mitigating the ability of spoof
        and intercept attacks.

2.  `--ssl_server_cred`:

    Local path to a self-signed ssl credential. Required if `--security_type ==
    ssl`.

3.  `--ssl_server_cert`:

    Local path to a self-signed ssl certificate. Required if `--security_type ==
    ssl`.

These options might be insufficient for `RemoteBackend` usage in a specific
production environment; other security types and additional authentication would
need to be implemented in those cases. As such, custom credentialling can be
provided via `RemoteEnclaveConfig::Create()`. Keep in mind that the default
`RemoteEnclaveConfig` uses `GrpcChannelBuilder` with `--security_type=local`.

### OpenCensus Metrics Collection

Metrics are an important aspect for any distributed application. To aid in the
collection effort, Asylo provides metrics via
[OpenCensus](https://opencensus.io/). OpenCensus collects the metrics locally
and can export them to several backends, currently OpenCensus
[supports exporting metrics](https://opencensus.io/exporters/) to
[Prometheus](https://prometheus.io/) and
[StackDriver](https://cloud.google.com/stackdriver/), custom exporters can also
be built.

To use the OpenCensus metrics collection, an Asylo User would add an
OpenCensusMetricConfig to the RemoteEnclaveConfig, and register an exporter via
the
[instructions provided by OpenCensus](https://opencensus.io/quickstart/cpp/metrics/).
