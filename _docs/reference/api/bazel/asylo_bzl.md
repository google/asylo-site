---

title:  Asylo C++ build rules

overview: Build rules for defining enclaves and tests.

location: /_docs/reference/api/bazel/asylo_bzl.md

layout: docs

type: markdown

toc: true

---
{% include home.html %}
<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#asylo_tags"></a>

## asylo_tags

<pre>
asylo_tags(<a href="#asylo_tags-backend_tag">backend_tag</a>)
</pre>

Returns appropriate tags for Asylo target.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="asylo_tags-backend_tag">
      <td><code>backend_tag</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          String that indicates the backend technology used. Can be
             one of
             * "asylo-sgx"
             * "asylo-sim"
             * None
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#cc_enclave_binary"></a>

## cc_enclave_binary

<pre>
cc_enclave_binary(<a href="#cc_enclave_binary-name">name</a>, <a href="#cc_enclave_binary-application_enclave_config">application_enclave_config</a>, <a href="#cc_enclave_binary-enclave_build_config">enclave_build_config</a>, <a href="#cc_enclave_binary-application_library_linkstatic">application_library_linkstatic</a>, <a href="#cc_enclave_binary-kwargs">kwargs</a>)
</pre>

Creates a cc_binary that runs an application inside an enclave.

Mostly compatible with the cc_binary interface. The following options are
not supported:

  * linkshared
  * malloc
  * stamp

Usage of unsupported aspects of the cc_binary interface will result in build
failures.

fork() inside Asylo is enabled by default in this rule.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="cc_enclave_binary-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          Name for the build target.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_binary-application_enclave_config">
      <td><code>application_enclave_config</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          A target that defines a function called
    ApplicationConfig() returning and EnclaveConfig. The returned config
    is passed to the application enclave. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_binary-enclave_build_config">
      <td><code>enclave_build_config</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          An sgx_enclave_configuration target to be passed to
    the enclave. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_binary-application_library_linkstatic">
      <td><code>application_library_linkstatic</code></td>
      <td>
        optional. default is <code>True</code>
        <p>
          When building the application as a
    library, whether to allow that library to be statically linked. See
    the `linkstatic` option on `cc_library`. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_binary-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          cc_binary arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#cc_enclave_test"></a>

## cc_enclave_test

<pre>
cc_enclave_test(<a href="#cc_enclave_test-name">name</a>, <a href="#cc_enclave_test-srcs">srcs</a>, <a href="#cc_enclave_test-enclave_config">enclave_config</a>, <a href="#cc_enclave_test-tags">tags</a>, <a href="#cc_enclave_test-deps">deps</a>, <a href="#cc_enclave_test-test_in_initialize">test_in_initialize</a>, <a href="#cc_enclave_test-kwargs">kwargs</a>)
</pre>

Build target that runs a cc_test srcs inside of an enclave.

This macro creates two targets, one sgx_enclave target with the test source.
And another test runner application to launch the test enclave.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="cc_enclave_test-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          Target name for will be &lt;name&gt;_enclave.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-srcs">
      <td><code>srcs</code></td>
      <td>
        required.
        <p>
          Same as cc_test srcs.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-enclave_config">
      <td><code>enclave_config</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          An sgx_enclave_configuration target to be passed to the
    enclave. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-tags">
      <td><code>tags</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          Same as cc_test tags.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-deps">
      <td><code>deps</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          Same as cc_test deps.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-test_in_initialize">
      <td><code>test_in_initialize</code></td>
      <td>
        optional. default is <code>False</code>
        <p>
          If True, tests run in Initialize, rather than Run. This
    allows us to ensure the initialization and post-initialization execution
    environments provide the same runtime behavior and semantics.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          cc_test arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#cc_test"></a>

## cc_test

<pre>
cc_test(<a href="#cc_test-name">name</a>, <a href="#cc_test-enclave_test_name">enclave_test_name</a>, <a href="#cc_test-enclave_test_config">enclave_test_config</a>, <a href="#cc_test-srcs">srcs</a>, <a href="#cc_test-deps">deps</a>, <a href="#cc_test-kwargs">kwargs</a>)
</pre>

Build macro that creates a cc_test target and a cc_enclave_test target.

This macro generates a cc_test target, which will run a gtest test suite
normally, and optionally a cc_enclave_test, which will run the test suite
inside of an enclave.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="cc_test-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          Same as native cc_test name.
        </p>
      </td>
    </tr>
    <tr id="cc_test-enclave_test_name">
      <td><code>enclave_test_name</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          Name for the generated cc_enclave_test. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_test-enclave_test_config">
      <td><code>enclave_test_config</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          An sgx_enclave_configuration target to be passed to
    the enclave. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_test-srcs">
      <td><code>srcs</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          Same as native cc_test srcs.
        </p>
      </td>
    </tr>
    <tr id="cc_test-deps">
      <td><code>deps</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          Same as native cc_test deps.
        </p>
      </td>
    </tr>
    <tr id="cc_test-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          cc_test arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#cc_test_and_cc_enclave_test"></a>

## cc_test_and_cc_enclave_test

<pre>
cc_test_and_cc_enclave_test(<a href="#cc_test_and_cc_enclave_test-name">name</a>, <a href="#cc_test_and_cc_enclave_test-enclave_test_name">enclave_test_name</a>, <a href="#cc_test_and_cc_enclave_test-enclave_test_config">enclave_test_config</a>, <a href="#cc_test_and_cc_enclave_test-srcs">srcs</a>, <a href="#cc_test_and_cc_enclave_test-deps">deps</a>, <a href="#cc_test_and_cc_enclave_test-kwargs">kwargs</a>)
</pre>

An alias for cc_test with a default enclave_test_name.

This macro is identical to cc_test, except it passes in an enclave
test name automatically. It is provided for convenience of overriding the
default definition of cc_test without having to specify enclave test names.
If this behavior is not desired, use cc_test instead, which will not create
and enclave test unless given an enclave test name.

This is most useful if imported as
  load(
      _workspace_name + "/bazel:asylo.bzl",
      cc_test = "cc_test_and_cc_enclave_test",
  )
so any cc_test defined in the BUILD file will generate both native and
enclave tests.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="cc_test_and_cc_enclave_test-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          See documentation for name in native cc_test rule.
        </p>
      </td>
    </tr>
    <tr id="cc_test_and_cc_enclave_test-enclave_test_name">
      <td><code>enclave_test_name</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          See documentation for enclave_test_name in cc_test above.
    If not provided and name ends with "_test", then defaults to name with
    "_test" replaced with "_enclave_test". If not provided and name does
    not end with "_test", then defaults to name appended with "_enclave".
        </p>
      </td>
    </tr>
    <tr id="cc_test_and_cc_enclave_test-enclave_test_config">
      <td><code>enclave_test_config</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          An sgx_enclave_configuration target to be passed to
    the enclave. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_test_and_cc_enclave_test-srcs">
      <td><code>srcs</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          See documentation for srcs in native cc_test rule.
        </p>
      </td>
    </tr>
    <tr id="cc_test_and_cc_enclave_test-deps">
      <td><code>deps</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          See documentation for deps in native cc_test rule.
        </p>
      </td>
    </tr>
    <tr id="cc_test_and_cc_enclave_test-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          See documentation for **kwargs in native cc_test rule.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#copy_from_host"></a>

## copy_from_host

<pre>
copy_from_host(<a href="#copy_from_host-target">target</a>, <a href="#copy_from_host-output">output</a>, <a href="#copy_from_host-name">name</a>)
</pre>

Genrule that builds target with host CROSSTOOL.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="copy_from_host-target">
      <td><code>target</code></td>
      <td>
        required.
      </td>
    </tr>
    <tr id="copy_from_host-output">
      <td><code>output</code></td>
      <td>
        required.
      </td>
    </tr>
    <tr id="copy_from_host-name">
      <td><code>name</code></td>
      <td>
        optional. default is <code>""</code>
      </td>
    </tr>
  </tbody>
</table>


<a name="#embed_enclaves"></a>

## embed_enclaves

<pre>
embed_enclaves(<a href="#embed_enclaves-name">name</a>, <a href="#embed_enclaves-elf_file">elf_file</a>, <a href="#embed_enclaves-enclaves">enclaves</a>, <a href="#embed_enclaves-kwargs">kwargs</a>)
</pre>

Build rule for embedding one or more enclaves into an ELF file.

Each enclave is embedded in a new ELF section that does not get loaded into
memory automatically when the elf file is run.

If the original binary already has a section with the same name as one of
the given section names, objcopy (and the bazel invocation) will fail with
an error message stating that the file is in the wrong format.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="embed_enclaves-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The name of a new ELF file containing the contents of the original
  ELF file and the embedded enclaves.
        </p>
      </td>
    </tr>
    <tr id="embed_enclaves-elf_file">
      <td><code>elf_file</code></td>
      <td>
        required.
        <p>
          The ELF file to embed the enclaves in. This target is built with
  the host toolchain.
        </p>
      </td>
    </tr>
    <tr id="embed_enclaves-enclaves">
      <td><code>enclaves</code></td>
      <td>
        required.
        <p>
          A dictionary from new ELF section names to the enclave files
  that should be embedded in those sections. The section names may not
  start with ".", since section names starting with "." are reserved for
  the system.
        </p>
      </td>
    </tr>
    <tr id="embed_enclaves-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          genrule arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#enclave_loader"></a>

## enclave_loader

<pre>
enclave_loader(<a href="#enclave_loader-name">name</a>, <a href="#enclave_loader-enclaves">enclaves</a>, <a href="#enclave_loader-embedded_enclaves">embedded_enclaves</a>, <a href="#enclave_loader-loader_args">loader_args</a>, <a href="#enclave_loader-kwargs">kwargs</a>)
</pre>

Wraps a cc_binary with a dependency on enclave availability at runtime.

Creates a loader for the given enclaves and containing the given embedded
enclaves. Passes flags according to `loader_args`, which can contain
references to targets from `enclaves`.

This macro creates three build targets:
  1) name: shell script that runs `name_host_loader`.
  2) name_loader: cc_binary used as loader in `name`. This is a normal
                  native cc_binary. It cannot be directly run because there
                  is an undeclared dependency on the enclaves.
  3) name_host_loader: genrule that builds `name_loader` with the host
                       crosstool.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="enclave_loader-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          Name for build target.
        </p>
      </td>
    </tr>
    <tr id="enclave_loader-enclaves">
      <td><code>enclaves</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary from enclave names to target dependencies. The
  dictionary must be injective. This dictionary is used to format each
  string in `loader_args` after each enclave target is interpreted as the
  path to its output binary.
        </p>
      </td>
    </tr>
    <tr id="enclave_loader-embedded_enclaves">
      <td><code>embedded_enclaves</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary from ELF section names (that do not start
  with '.') to target dependencies. Each target in the dictionary is
  embedded in the loader binary under the corresponding ELF section.
        </p>
      </td>
    </tr>
    <tr id="enclave_loader-loader_args">
      <td><code>loader_args</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          List of arguments to be passed to `loader`. Arguments may
  contain {enclave_name}-style references to keys from the `enclaves` dict,
  each of which will be replaced with the path to the named enclave.
        </p>
      </td>
    </tr>
    <tr id="enclave_loader-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          cc_binary arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#enclave_test"></a>

## enclave_test

<pre>
enclave_test(<a href="#enclave_test-name">name</a>, <a href="#enclave_test-enclaves">enclaves</a>, <a href="#enclave_test-embedded_enclaves">embedded_enclaves</a>, <a href="#enclave_test-test_args">test_args</a>, <a href="#enclave_test-tags">tags</a>, <a href="#enclave_test-kwargs">kwargs</a>)
</pre>

Build target for testing one or more enclaves.

Creates a cc_test for a given enclave. Passes flags according to
`test_args`, which can contain references to targets from `enclaves`.

This macro creates three build targets:
 1) name: sh_test that runs the enclave_test.
 2) name_driver: cc_test used as test loader in `name`. This is a normal
                 native cc_test. It cannot be directly run because there is
                 an undeclared dependency on enclave.
 3) name_host_driver: genrule that builds name_driver with host crosstool.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="enclave_test-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          Name for build target.
        </p>
      </td>
    </tr>
    <tr id="enclave_test-enclaves">
      <td><code>enclaves</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary from enclave names to target dependencies. The
  dictionary must be injective. This dictionary is used to format each
  string in `test_args` after each enclave target is interpreted as the
  path to its output binary.
        </p>
      </td>
    </tr>
    <tr id="enclave_test-embedded_enclaves">
      <td><code>embedded_enclaves</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary from ELF section names (that do not start
 with '.') to target dependencies. Each target in the dictionary is
 embedded in the test binary under the corresponding ELF section.
        </p>
      </td>
    </tr>
    <tr id="enclave_test-test_args">
      <td><code>test_args</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          List of arguments to be passed to the test binary. Arguments may
 contain {enclave_name}-style references to keys from the `enclaves` dict,
 each of which will be replaced with the path to the named enclave. This
 replacement only occurs for non-embedded enclaves.
        </p>
      </td>
    </tr>
    <tr id="enclave_test-tags">
      <td><code>tags</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          Label attached to this test to allow for querying.
        </p>
      </td>
    </tr>
    <tr id="enclave_test-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          cc_test arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#sgx_enclave_test"></a>

## sgx_enclave_test

<pre>
sgx_enclave_test(<a href="#sgx_enclave_test-name">name</a>, <a href="#sgx_enclave_test-srcs">srcs</a>, <a href="#sgx_enclave_test-kwargs">kwargs</a>)
</pre>

Build target for testing one or more instances of 'sgx_enclave'.

This macro invokes enclave_test with the "asylo-sgx" tag added.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="sgx_enclave_test-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The target name.
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_test-srcs">
      <td><code>srcs</code></td>
      <td>
        required.
        <p>
          Same as cc_test srcs.
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_test-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          enclave_test arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#sim_enclave"></a>

## sim_enclave

<pre>
sim_enclave(<a href="#sim_enclave-name">name</a>, <a href="#sim_enclave-kwargs">kwargs</a>)
</pre>

Build rule for creating simulated enclave object files signed for testing.

The enclave simulation backend currently makes use of the SGX simulator.
However, this is subject to change and users of this rule should not make
assumptions about it being related to SGX.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="sim_enclave-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The name of the signed enclave object file.
        </p>
      </td>
    </tr>
    <tr id="sim_enclave-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          cc_binary arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#sim_enclave_loader"></a>

## sim_enclave_loader

<pre>
sim_enclave_loader(<a href="#sim_enclave_loader-name">name</a>, <a href="#sim_enclave_loader-enclaves">enclaves</a>, <a href="#sim_enclave_loader-embedded_enclaves">embedded_enclaves</a>, <a href="#sim_enclave_loader-loader_args">loader_args</a>, <a href="#sim_enclave_loader-kwargs">kwargs</a>)
</pre>

Thin wrapper around enclave loader, adds necessary linkopts and testonly=1

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="sim_enclave_loader-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          Name for build target.
        </p>
      </td>
    </tr>
    <tr id="sim_enclave_loader-enclaves">
      <td><code>enclaves</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary from enclave names to target dependencies. The
  dictionary must be injective. This dictionary is used to format each
  string in `loader_args` after each enclave target is interpreted as the
  path to its output binary.
        </p>
      </td>
    </tr>
    <tr id="sim_enclave_loader-embedded_enclaves">
      <td><code>embedded_enclaves</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary from ELF section names (that do not start
  with '.') to target dependencies. Each target in the dictionary is
  embedded in the loader binary under the corresponding ELF section.
        </p>
      </td>
    </tr>
    <tr id="sim_enclave_loader-loader_args">
      <td><code>loader_args</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          List of arguments to be passed to `loader`. Arguments may
  contain {enclave_name}-style references to keys from the `enclaves` dict,
  each of which will be replaced with the path to the named enclave.
        </p>
      </td>
    </tr>
    <tr id="sim_enclave_loader-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          cc_binary arguments.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#sim_enclave_test"></a>

## sim_enclave_test

<pre>
sim_enclave_test(<a href="#sim_enclave_test-name">name</a>, <a href="#sim_enclave_test-kwargs">kwargs</a>)
</pre>

Thin wrapper around enclave test, adds 'asylo-sim' tag and necessary linkopts

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="sim_enclave_test-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          enclave_test name
        </p>
      </td>
    </tr>
    <tr id="sim_enclave_test-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          same as enclave_test kwargs
        </p>
      </td>
    </tr>
  </tbody>
</table>


