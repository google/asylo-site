---
title: "Asylo 0.3.0 Release"
overview: Hardware support and other enhancements.
publish_date: 2018-09-20
subtitle: Hardware support and other enhancements
attribution: The Asylo Team

order: 19

layout: blog
type: markdown
---
{% include home.html %}


Today, we’re excited to announce version 0.3.0 of Asylo, which introduces
support for Intel Software Guard Extensions (SGX) hardware enclaves. Now, in
addition to enclaves simulated in software, application developers can use Asylo
to build applications that leverage the security properties of SGX in a
portable, vendor-agnostic way. In the 0.3.0 release, Asylo has also been updated
to use version 2.3 of Intel’s SGX SDK, which includes some mitigations for the
widely publicized
[Spectre](https://en.wikipedia.org/wiki/Spectre_%28security_vulnerability%29)
and
[Meltdown](https://en.wikipedia.org/wiki/Meltdown_%28security_vulnerability%29) CPU vulnerabilities.

The recently-disclosed [Foreshadow](https://foreshadowattack.eu/) SGX
vulnerabilities, while mitigated by the SGX SDK update to some extent, highlight
the importance of a vendor-agnostic and technology-agnostic approach to
secure-system development. As new technologies prove themselves in the real
world, engineers building secure systems have the freedom and agility to adopt
the best technology for their requirements.

This flexibility is possible with Asylo because the POSIX layer and the
application-programming model are built on top of backend-agnostic primitives. A
core objective of the Asylo framework is to provide a low-friction way of
changing an application’s enclave backend, without ever having to deal with
backend-specific features. Our goal is to make switching between backend
technologies require as few changes as possible to the application source code,
as this reduces the possibility of subtle bugs/vulnerabilities introduced by
code rewrites.

Asylo's added support for SGX hardware should not be construed as a substitute
for users' own diligence. While SGX is an exciting technology, the side-channel
attacks that have emerged in recent months may make SGX on its own an
unacceptable backend for some applications. Every security technology has its
strengths and weaknesses, and these aspects should be evaluated by the enclave
user. Asylo’s support for SGX should not be interpreted as an endorsement of SGX
or any of its claims. Asylo provides a uniform technology stack and programming
model across a range of isolation technologies, but the Asylo team is not able
to determine the suitability of any particular technology with respect to an
application’s security requirements.

Finally, the Asylo team recommends using defense-in-depth measures to protect
sensitive applications. Running an application inside an enclave should be
viewed as an additional layer of defense, rather than as a substitute for OS and
machine security.
