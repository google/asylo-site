---

title: Asylo Overview

overview: Get a better understanding of the problem space and how Asylo is designed to enable solutions.

location: /_about/overview.md

order: 20

layout: about

type: markdown

---


## Introduction

Asylo enables you to take advantage of emerging hardware and software
technologies that provide
[trusted execution environments](https://en.wikipedia.org/wiki/Trusted_execution_environment),
known as an *enclaves*. Asylo provides an API, trusted and untrusted runtime
libraries, and C/C++ toolchain so you can integrate your application with an
enclave backend of your choice. The benefit of running your application using an
enclave is that it provides confidentiality and integrity assurances for your
sensitive workloads.

The main goals of Asylo are:

+   **Ease of use**. Asylo provides ready-to-use containers, an open source API,
    libraries, and tools that you can use to run your application backed by an
    enclave technology of your choice. Ease of deployment is a focus.
+   **Portability across enclave backends**. Once your application is adapted to
    the Asylo API and toolchain, you can switch to a different backend by simply
    re-compiling and re-packaging your application. There is no need to refactor
    your code because the Asylo API and toolchain are designed to work with
    various enclave technologies.

## Architecture

Asylo allows an untrusted execution environment to host a trusted environment.
The benefit is to enable sensitive workloads in an untrusted execution
environment with the inherited confidentiality and integrity guarantees of the
chosen trusted execution environment.

{% include figure.html width='80%' ratio='46.36%' img='./img/asylo.png'
alt='Asylo architecture' title='Asylo architecture' caption='Asylo architecture'
%}

The untrusted execution environment consists of surrounding infrastructure—for
instance the operating system and system libraries—and human operators that are
less trusted than an enclave. The trusted execution environment consists of one
or more enclaves, which protect code and data in a sensitive workload. A trusted
execution environment allows an enclave to:

+   Prevent vulnerabilities outside the enclave from compromising the workloads
    that run in the enclave. Depending on the enclave technology, this
    protection may shield application code and sensitive data from one or more
    of the following:

    +   Guest virtual machine (VM) kernel or user mode vulnerabilities
    +   A compromised hypervisor or host operating system

+   Provide confidentiality and integrity assurances for sensitive workloads at
    the enclave communication boundary with its host in an untrusted
    environment. Confidentiality and integrity protection within an enclave is
    stronger than protection provided by OS-native applications.

+   Provide integrity assurances for the enclave during execution. Depending on
    the enclave technology, users can either remotely or locally verify the
    integrity of the enclave that runs their sensitive workloads.

## Security backends

Asylo provides a choice of *security backends*:

+   Software backends, such as those based on isolation provided by hardware
    virtualization
+   Hardware backends, such as those based on proprietary CPU manufacturer
    implementations

Developers choose a backend that meets the security requirements for their
sensitive workloads. The Asylo team has long-term design plans to protect the
confidentiality and integrity of a wider range sensitive workloads and
additional backends. Depending on the backend, Asylo is designed to integrate
applications with enclaves that provide confidentiality and integrity guarantees
against the following threats:

+   Malicious or compromised administrator
+   Malicious or compromised tenant of a hypervisor
+   Malicious or compromised network
+   Compromised operating system
+   Compromised BIOS

The v0.3 release of Asylo supports a simulated enclave backend, which should not
be used in production environments. Support for additional backends will be
added over time to meet the varying needs and security requirements of Asylo
users.

## Release information

Asylo provides an API and toolchain to enable developers to develop and run
applications that use one or many communicating enclaves. Asylo supports an
expanding subset of POSIX, which enables running POSIX applications in an
enclave with little to no source modification. Iterations of Asylo are intended
to release without requiring significant change to the programming model.

The v0.3 release of Asylo is not intended for production use.
