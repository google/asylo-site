---
title: "Real-World Applications in Enclaves"
overview: Enclavizing Redis and SQLite
publish_date: 2019-08-09
subtitle: Enclavizing Redis and SQLite
attribution: The Asylo Team

order: 18

layout: blog
type: markdown
---
{% include home.html %}

## Summary

Enclaves provide the powerful property that they're protected and isolated from
the system on which they run. This is very different from the traditional
application model where the underlying operating system, et al., is implicitly
trusted, and it opens up the door for exciting new types of systems.

Being isolated from the operating system and peripheral hardware (e.g., disk
storage, network cards, etc), however, means that an enclave application doesn’t
have direct access to the functionality that an operating system or special
hardware would provide. While some applications wouldn’t require that kind of
additional functionality, the vast majority do require it to varying degrees.

Asylo works to bridge this gap by providing the same POSIX interfaces to this
functionality that applications would invoke on a non-enclave system. However,
the Asylo versions of these interfaces work behind the scenes to interact with
the untrusted operating system in ways that don’t trust it. This can involve
encrypting data, tokenizing potentially sensitive values, or verifying that the
operating system is not being malicious before using its responses.

One example of the POSIX support is signals. Many real-world applications
register and handle signals for various purposes. The enclaves do not support
signal handling. Signals are sent by the kernel to the host operating system.
Asylo provides a secure signal handling system that allows incoming signals to
enter and notify the enclave, which invokes handlers registered inside the
enclave.

Another example is `fork()`. This is also widely used by real-world
applications. For security reasons, enclaves are not cloneable. If `fork()` is
called on the host operating system with a running enclave, the enclave will
not exist in the new process (the address space for the enclave will simply be
empty). Asylo provides secure `fork()` that safely encrypts a snapshot of the
parent enclave and restores it in the child enclave.

As Asylo continues to add more and more POSIX interfaces in this manner, it
becomes easier and easier to port applications to run in enclaves. This blog
post discusses the technical details behind some interesting new additions
(including signals and `fork()`) that significantly improve this. In fact, as of
Asylo 0.4.0, one can run a wide variety of real-world applications (including
Redis and SQLite) without even modifying any of their source code!

## Technical Details
In recent months, several enhancements to the Asylo framework enabled the
enclavization of non-trivial user applications such as Redis and SQLite. These
enhancements include the addition of the `cc_enclave_binary` rule that enables
wrapping of whole C++ applications as well as additional POSIX support. We
briefly describe some of the highlights below.

### Application wrapper

To make it easy to run an application in an enclave, Asylo now provides an
application wrapper, which enables users to easily run an existing application
in an enclave without any source code modifications.

Asylo now provides the [`cc_enclave_binary` Bazel macro](https://github.com/google/asylo/blob/v0.4.0/asylo/bazel/asylo.bzl#L457)
that allows users to wrap existing applications in an enclave. Users can simply
put the existing application they want to run as a library in the deps field of
this macro, and build/run it with Bazel. The binary will be linked in as a
library, instead of being loaded at runtime. The `application_enclave_config`
field can be used to pass a custom configuration into the enclave.

Every enclave application needs at least a small amount of non-enclave code
called a "loader" that is launched by the OS. Asylo provides a stock loader
that can launch the wrapped application inside an enclave. When running a
`cc_enclave_binary` target, the application wrapper first runs its loader on the
host side. The loader then loads the enclave and invokes its EnterAndRun method.
The application wrapper's loader passes the command-line arguments to the
enclave in an EnclaveInput message. Inside the enclave, the corresponding `Run`
method invokes the wrapped application's main function with the provided
command-line arguments. When main returns, `Run` places the return value from
`main` in an `EnclaveOutput` message, which `EnterAndRun` returns to the loader.
The application wrapper's loader then returns this value as the exit code to the
OS.

By doing this, the binary accepts input and provides output in the same way as
the application normally would, but all of the original application is being run
inside an enclave.

### Asylo POSIX support

Asylo provides rich POSIX support for running applications such as Redis or
SQLite inside an enclave. The goal of Asylo’s POSIX layer is to provide enclaves
with functionality that is provided by a regular OS to non-enclave applications.
Users writing code do not need to know their code is running inside an enclave,
and should expect the same result from a syscall as if it were called from a
regular application on a regular host.

Most syscalls are not security-sensitive. For these syscalls, Asylo exits the
enclave and delegates the syscall to the host. For syscalls that may cause
security issues if called directly by the OS, Asylo adds additional in-enclave
processing that removes the need to trust the operating system while making use
of the host OS’s syscall. For other syscalls, Asylo emulates the functionality
of the syscall without exiting the enclave. Below are a few examples of how
Asylo supports some security-sensitive syscalls inside an enclave.

#### Enclave Signals

Many applications, including Redis, register signal handlers for various
purposes. Asylo provides signal-handling support for enclaves. Signals registered
inside the enclave will be delivered into the enclave.

When a signal handler is registered inside an enclave, either through the
`sigaction` or `signal` system calls, Asylo stores the enclave-specified signal
handler inside the enclave as a function pointer. Asylo then exits the enclave
and registers an untrusted signal handler on the host. When the OS delivers the
corresponding signal to the loader application, it invokes the untrusted signal
handler. This signal handler then invokes an enclave entry call to enter the
enclave with all inputs of the signal handler (`signum`, `info`, `ucontext`).
Once inside the enclave, Asylo looks up and invokes the enclave-side signal
handler registered by the user.

When the signal mask is set from inside an enclave through `sigprocmask`, a
signal mask stored inside the enclave is modified accordingly, and Asylo also
exits the enclave to modify the signal mask on the host. Therefore, even if the
host OS is malicious and the signal mask cannot be trusted, the enclave still
prevents the handlers for masked signals from being invoked (The host OS can
still block signals from being delivered into the enclave).

#### Enclave `fork()`

Redis, and many other applications, also invoke the `fork()` system call. Redis
uses `fork()` for snapshotting its database state. Asylo provides support for
the `fork()` system call.

For security reasons, enclave backends such as SGX do not allow an untrusted OS
to clone an enclave. To enable running applications that make `fork()` calls
inside an enclave without modification, Asylo provides `fork()` support with
security features provided for such applications. Asylo `fork()` takes a snapshot
of the enclave, creates a child process, loads a new enclave in the child, and
restores that enclave from the snapshot. The Asylo `fork()` functionality
provides the following security guarantees:

1. Only the enclavized portion of the application can request a `fork()` of the
   enclave.
2. The cloned enclave has exactly the same identity as the parent enclave.
3. If no other threads were running inside the parent enclave when it called
   `fork()`, the cloned enclave's state is the same as that of the parent
   enclave when it called `fork()`. Since the snapshot is currently not taken
   fully atomically, other threads running in the enclave may cause the state
   restored to the cloned enclave to not be fully consistent.
4. The enclave state is only transferred to the clone in an encrypted form, with
   a randomly generated AES256-GCM-SIV encryption key.
5. The parent securely transfers the snapshot encryption key to the child, and
   the child only restores its state from the parent’s encrypted snapshot. These
   properties are guaranteed by the `fork()` implementation via a one-time
   authenticated EC-based Diffie-Hellman key exchange between the two enclaves.
6. At most one cloned enclave will be created per `fork()` request.
7. If the encrypted snapshot is modified, the child enclave will not restore,
   and blocks all entries.

To accomplish #3, when the parent enclave requests a `fork()`, Asylo blocks any
new entries into the enclave, sets an indicator that the parent enclave has
requested a `fork()`, and exits the enclave. The untrusted Asylo runtime then
enters the parent enclave using a special entry point to generate an encrypted
snapshot of the mutable state of the parent enclave.

#### More POSIX support

Asylo is actively providing more POSIX support. Please check [our website](https://asylo.dev) or [Open Source Asylo](https://github.com/google/asylo)
for more updates.

## Running Redis/SQLite With Asylo

Running Redis or SQLite inside an enclave with Asylo is straightforward. All
that’s needed is:

1. Import Asylo 0.4.0 and Redis 5.0.4/SQLite 3.28.0 in your WORKSPACE file.
2. Copy the contents of Asylo “.bazelrc” for Bazel build configurations. It can
   be found from Asylo repository [`.bazelrc`](https://github.com/google/asylo/blob/master/.bazelrc).
3. Add a simple `cc_enclave_binary` BUILD target that wraps the application.

The fully detailed instructions to run Redis can be found at
[Run Redis Inside An Enclave](https://github.com/google/asylo/blob/master/asylo/examples/redis/README.md).

The fully detailed instructions to run SQLite can be found at
[Run SQLite Inside An Enclave](https://github.com/google/asylo/blob/master/asylo/examples/sqlite/README.md).
