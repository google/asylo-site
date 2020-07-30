---

title: Build enclaves and tests in Asylo

overview: How to use Bazel with the Asylo toolchain

location: /_docs/concepts/building.md

order: 20

layout: docs

type: markdown

---

{% include home.html %}


Enclave applications in Asylo exist in an inherently multi-platform environment
that must make extensive use of cross compilation. The trusted execution target
(the enclave) is modeled by the build system as a second platform distinct from
the untrusted host. In addition to supporting multiple security backend
technologies, enclaves themselves pose a cross-compilation challenge. Asylo
provides enclaves with a POSIX-like environment, a libc and libc++
implementation. This environment is different from a glibc-linux target, or any
other standard compilation target. An Asylo enclave in a particular security
backend thus constitutes its own platform.

This document describes the abstractions and tools we use to provide a smooth
development experience in with Asylo, even with cross-compilation challenges.

The section [Backend-generic rules](#backend-generic-rules) contains a concrete
guide to using Asylo's macros to define enclaves and tests.

## Multi-platform builds

An enclave application has at least 2 build contexts: an untrusted part built
for the host environment (e.g., a GNU/Linux user application), and a trusted
part (e.g., an Asylo SGX enclave). More are possible, such as a second enclave
built with a different Asylo backend.

The Bazel build tool we use for hermetic builds has native support for cross
compilation via its notion of a
[crosstool](https://docs.bazel.build/versions/master/tutorial/cc-toolchain-config.html),
which is similar to CMake's notion of a package configuration. Before Bazel's
1.0 release, a target and its full dependency graph must be built for the same
target. In the Asylo framework, we have tests that combine both an untrusted
application built for Linux and an enclave built in the Asylo platform. The test
is a single target, but necessarily consists of targets built for different
platforms. The way we made this work pre-1.0 is not a long-term solution.

Bazel version 1.0 has partial support for a feature called
[configuration transitions](https://github.com/bazelbuild/bazel/issues/5574) as
part of the Bazel team's
[configurability roadmap](https://bazel.build/roadmaps/configuration.html).
Transitions allow build rules to specify their intended target platforms.

## Core Bazel concepts that Asylo uses

Some Bazel vocabulary we use:

*   **Target**: An object at build time that represents built artifacts and
    compile-time information. A target is produced by a rule, and a target is
    referenced by a label.
*   **Label**: A way to reference a target. It's a lightly structured string
    that has an optional workspace (name of a `WORKSPACE`-declared dependency),
    a package (a path within a workspace that contains a `BUILD` file), and a
    name (the string provided to a rule's "name" argument).
*   **Rule**: A rule generates targets with compile-time computation which may
    include invoking toolchain-provided executables or user-defined "tool"
    dependencies that run at build time.
*   **Macro**: A compile-time function that may not inspect targets, or the
    outcomes of any compilation before invoking a serious of rules or providing
    computations to other macros. Macros produce rules before rules are executed
    to produce targets.

The Bazel build system has a compile-time computation language,
[Starlark](https://docs.bazel.build/versions/master/skylark/language.html), that
is restricted enough to be analyzable for reliable builds, but flexible enough
to support a wide diversity of projects. In addition to native rules like
`cc_binary` for defining C/C++ targets from libraries and source files, Bazel
has user-defined rules via Starlark.

Every target built by Bazel can have associated compile-time metadata that other
rules can consume and interpret as part of their operation. Metadata is provided
by a data type called a _provider_, which is plainly a named struct type. For
example, each `cc_library` target has a `CcInfo` provider that explains which
headers it provides and how it should be linked with other targets. In Asylo, we
use providers to tag enclaves with their backend provenance, signing material
with their enclave and configuration provenance, and even as a way of giving
compile-time semantics to Asylo backends themselves.

## Organization of transition-based builds

Our build rules use target-associated Starlark providers to learn and share
enclave-specific information at compile-time. An Asylo backend is specified as a
target with an associated `AsyloBackendInfo` provider. A label to such a target
is a _backend label_.

This provider contains information on how to build an enclave, and which
providers on a target are important to propagate forward when using any of the
{`asylo`,`backend`}​`_`​{`test`,`library`,`binary`} rules to force a transition
before building a specified target.

In all cases where possible, we ensure that our representation of an Asylo
backend is open for users to write their own backends without modifying Asylo's
source code. Asylo rules that accept backend labels to multiplex on are written
with an "open world assumption". We do not assume a backend is one of a set few
in order to allow users to define their own backends without modifying Asylo.

## Backend-generic and backend-agnostic targets

Some enclave behaviors are specific to a backend technology (backend-specific).
Sometimes we can replicate the behavior across technologies and provide a common
interface (backend-generic). In some cases, backend differences must be given a
name that carries distinct meaning across all backends (e.g., backend-specific
identities). Some enclave behaviors are shared across all conceivable backends
because they're generally available on computer architectures that support
trusted execution environments (backend-agnostic).

We make a distinction between backend-specific, backend-generic, and
backend-agnostic code as a way to help users navigate our codebase to establish
trust. This also helps conceptualize the code tree organization.

A target is considered _backend-specific_ if its behavior is defined only for a
single backend. A target is _backend-generic_ if its behavior is defined for any
of a given set of backends (a `backends` build argument). A target is considered
_backend-agnostic_ if its behavior is well-defined regardless of backend choice.
Backend-agnostic libraries should be usable within any enclave backend (e.g.,
crypto libraries). A backend-agnostic target is backend-generic, but the
converse is not generally true. The main difference is that a backend-generic
target may conditionally build different code based on each possible backend.

You can write backend-generic unsigned enclave binaries with
`cc_unsigned_enclave`, and backend-generic signed enclave binaries with
`sign_enclave_with_untrusted_key` (or its alias `debug_sign_enclave`)[^1]. The
`backends` field specifies a list of backends a target should be built against,
where each backend is described by a backend label. Similarly, backend-generic
tests can be written with `enclave_test` and `cc_enclave_test` again with the
same `backends` field. If a test has a backend-dependent data dependency (like
an enclave loader), then it can use the `backend_specific_data` to undergo a
backend transition before including it in the test's dependencies.

In these generic rules, the default behavior of what the `name` field refers to
in tests and non-tests is different since tests cannot be aliased in the same
way that non-tests can. In all cases, each generic macro generates multiple
targets, one per backend given. The names of the generated targets are derived
from the `name` field and properties of backend labels provided. Each of the
backend-specific targets will be buildable without top level flags. In order to
use a generic enclave in a generic loader, a generic enclave defines an alias
named `name` that selects the appropriate backend-specific target based on the
backend's `config_setting`.

Tests are not used as dependencies, so `name` is not an alias like for
non-tests. Bazel does not allow an alias of a test to be considered a test
either, so `name` instead resolves to **one** of the backend-specific tests by
means of a `test_suite` definition. This is so that any test name that textually
appears in a BUILD file actually resolves to a test. We only resolve to one test
rather than multiple since we don't have the information at build time which
backends the running machine actually supports. Users can use the
backend-specific test name if they are trying to run the test for a specific
backend. Backends can be ordered such that your preference is default for the
`test_suite` definition, rather than the default defined by the `order` fields
in `enclave_info.bzl`'s `ALL_BACKEND_LABELS`.

Many libraries can be written in an Asylo-backend-agnostic manner, and we strive
to make the only semantic differences between backend changes security-relavent
judgments. For example, a dlopen enclave will not run with encrypted memory, and
it will not be able to create SGX attestation assertions, but it will have the
same behavior with interactions with the POSIX abstractions. Please
[file an issue](https://github.com/google/asylo/issues) if you find this is not
the case.

## Backend labels

The active Asylo backend is the value of the backend `label_flag`,
`@com_google_asylo_backend_provider//:backend`. Label values for the backend
flag must be backend labels. A backend label has no run time content—it is
merely for directing compilation. A backend label becomes a target that provides
the `AsyloBackendInfo` provider. Each backend must provide their own
implementations of `cc_unsigned_enclave`, and `debug_sign_enclave`. If the
backend does not need signing, like the dlopen backend, then the implementation
of `debug_sign_enclave` can just copy the unsigned enclave to its output path
and reprovide its providers.

The generic implementations of `cc_unsigned_enclave` and `debug_sign_enclave`
simply call the implementation functions in the backend attribute's
`AsyloBackendInfo` provider. For `debug_sign_enclave`, there is a good chance an
implementation will want hidden attributes to get access to default files, or
the sign tool itself. The generic rule provides the `key`, `sign_tool`, and
`config` attributes which are populated with backend-specific defaults.

## Backend-generic rules

The previous section described how `cc_unsigned_enclave` and
`debug_sign_enclave` rules are implemented such that their implementations are
provided by a specific backend label. In fact they are written in terms of rules
that depend on a specific backend, `cc_backend_unsigned_enclave` and
`backend_debug_sign_enclave`, but are themselves macros. The macros generate
multiple targets, one per backend in the `backends` argument. The generic target
is an alias that selects which backend-specific target it is, depending on the
backend `label_flag` setting.

An enclave target thus cannot cannot be directly built without a flag specifying
the backend. Enclaves are used in conjunction with tests and loaders though. The
`enclave_test` and `cc_enclave_test` forms generate tests for each considered
backend and _don't_ select among them. Each generated test depends on the
generic enclaves under a backend transition[^2]. The select in the generic
enclaves can then be determined. Each backend-specific target generated by a
backend-generic rule like `enclave_test` gets its name transformed in a
backend-specific way. The specific transformation depends on how the backends
are specified to the macros.

For example, the test `//asylo/test/misc:enclave_smoke_test`:

```python
cc_unsigned_enclave(
    name = "test_enclave_smoke_unsigned.so",
    srcs = ["hello_world.cc"],
    copts = ASYLO_DEFAULT_COPTS,
    deps = ["@com_google_asylo//asylo:enclave_runtime"],
)

debug_sign_enclave(
    name = "test_enclave_smoke.so",
    unsigned = ":test_enclave_smoke_unsigned.so",
)

enclave_test(
    name = "enclave_smoke_test",
    srcs = ["hello_world_test.cc"],
    backends = sgx.backend_labels,
    copts = ASYLO_DEFAULT_COPTS,
    enclaves = {"enclave": ":test_enclave_smoke.so"},
    tap = 1,
    test_args = ["--enclave_path='{enclave}'"],
    deps = TEST_DEPS_COMMON,
)
```

The `enclave_smoke_test` definition will generate two tests: one for the SGX
simulation backend, and one for the SGX hardware backend. The two tests are
`//asylo/test/misc:enclave_smoke_sgx_sim_test` and
`//asylo/test/misc:enclave_smoke_sgx_hw_test` respectively. The names are
derived from `enclave_smoke_test` and the default backend label struct
definitions Asylo has for the two SGX backends. A simulation target should get
`_sgx_sim` in an appropriate place for the type of target, for example. You can
use Bazel's query tool to help find targets too, so for any `a.so` or `a_test`,
try

```shell
bazel query //path/to/pkg/... | grep '^a'
```

If you want to directly build the `sgx_sim` version of `test_enclave_smoke.so`,
you can do so in a couple ways:

1.  Know the `_sgx_sim` name transformation for the `asylo_sgx_sim` backend and
    run

    ```shell
     bazel build //asylo/test/misc:test_enclave_smoke_sgx_sim.so
    ```

2.  Select the backend before building the `test_enclave_smoke.so` alias:

    ```
     bazel build \
     --@com_google_asylo_backend_provider//=@linux_sgx//:asylo_sgx_sim \
     //asylo/test/misc:test_enclave_smoke.so
    ```

**Aside:** the name `enclave_smoke_test` still names a test in order to not be
surprising. Which test it is depends on the `order` values in the passed
backends' backend label structs. The backend with the smallest `order` value
should ideally be "the backend that is most likely to work on the user's
machine", like a simulation backend. For good user experience, ideally any named
test in a file that isn't explicitly tagged as a problem (e.g., "noregression")
should be runnable. This guideline doesn't apply for non-generic tests, or tests
that explicitly state which hardware they're targeting.

### Backend-dependent data dependencies

The generic build rules that straddle two platforms, e.g., `enclave_test` and
`enclave_loader`, have extra features to handle genericity in their host
targets. A test for example may have a data dependency on an application that
loads an enclave. The dependency can inherit the backend selection by using the
`backend_dependent_data` attribute. This attribute undergoes a backend (but not
toolchain) transition to support the different untrusted runtimes that may be
necessary to run the different enclaves.

Some arguments may not be able to undergo transition due to limits on Bazel's
support for transitions. For example, the `test_args` argument to `enclave_test`
cannot undergo the same kind of backend transition to select amongst different
argument strings to the test. For now, we recommend workarounds such as using
`$(location //label/of/alias:with_transition)` as an argument and using the
provided location to give extra information about what backend was selected.

## The `backends` field for generic rules

Each backend label denotes a target which carries compile-time information in an
`AsyloBackendInfo` provider. Providers are not available for the backend-generic
macros to inspect. Instead, the backends passed to a backend-generic macro may
be in one of two forms:

1.  A dictionary that maps backend labels to backend label structs. A backend
    label struct contains information about the backend that is useful for
    producing backend-generic rules. See `enclave_info.bzl` for more
    information.
1.  A list of backend labels. If these labels are Asylo-provided backends, then
    this is a shorthand for a restriction to the given backend labels of a
    dictionary Asylo defines of all backends to their backend label struct.

The dictionary option is how we provide an open world semantics for these rules.

[^1]: The build rules that sign enclaves automatically assume an adversarial
    build environment. If a private key is exposed to the build environment,
    it must be treated as untrusted. This is reasonable for enclaves built for
    testing purposes or for enclave applications that place trust entirely in
    the enclave code identity and disregard the signer identity.
[^2]: The Bazel transition support is provided along side the old strategy that
    requires the top level `--config` flags. During the migration period,
    you're able to disable transitions within your project by adding the
    following to your `WORKSPACE` file:

    ```
    load("@com_google_asylo//asylo/bazel:asylo_deps.bzl",
         "asylo_disable_transitions")
    asylo_disable_transitions()
    ```
