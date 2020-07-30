---

title:  //asylo/bazel:asylo.bzl

overview: Build rules for defining enclaves and tests.

location: /_docs/reference/api/bazel/asylo_bzl.md

order: 40

layout: docs

type: markdown

toc: true

---
{% include home.html %}
<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#backend_sign_enclave_with_untrusted_key"></a>

## backend_sign_enclave_with_untrusted_key

<pre>
backend_sign_enclave_with_untrusted_key(<a href="#backend_sign_enclave_with_untrusted_key-name">name</a>, <a href="#backend_sign_enclave_with_untrusted_key-backend">backend</a>, <a href="#backend_sign_enclave_with_untrusted_key-unsigned">unsigned</a>, <a href="#backend_sign_enclave_with_untrusted_key-config">config</a>, <a href="#backend_sign_enclave_with_untrusted_key-backend_label_struct">backend_label_struct</a>, <a href="#backend_sign_enclave_with_untrusted_key-kwargs">kwargs</a>)
</pre>

Defines the 'signed' version of an unsigned enclave target.

The signer is backend-specific.


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="backend_sign_enclave_with_untrusted_key-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The rule name.
        </p>
      </td>
    </tr>
    <tr id="backend_sign_enclave_with_untrusted_key-backend">
      <td><code>backend</code></td>
      <td>
        required.
        <p>
          An Asylo backend label.
        </p>
      </td>
    </tr>
    <tr id="backend_sign_enclave_with_untrusted_key-unsigned">
      <td><code>unsigned</code></td>
      <td>
        required.
        <p>
          The label of the unsigned enclave target.
        </p>
      </td>
    </tr>
    <tr id="backend_sign_enclave_with_untrusted_key-config">
      <td><code>config</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          An enclave signer configuration label. Optional.
        </p>
      </td>
    </tr>
    <tr id="backend_sign_enclave_with_untrusted_key-backend_label_struct">
      <td><code>backend_label_struct</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          Optional backend label struct (details in
    enclave_info.bzl)
        </p>
      </td>
    </tr>
    <tr id="backend_sign_enclave_with_untrusted_key-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          Generic rule arguments like tags and testonly.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#cc_backend_unsigned_enclave"></a>

## cc_backend_unsigned_enclave

<pre>
cc_backend_unsigned_enclave(<a href="#cc_backend_unsigned_enclave-name">name</a>, <a href="#cc_backend_unsigned_enclave-backend">backend</a>, <a href="#cc_backend_unsigned_enclave-kwargs">kwargs</a>)
</pre>

Defines a C++ unsigned enclave target in the provided backend.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="cc_backend_unsigned_enclave-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The rule name.
        </p>
      </td>
    </tr>
    <tr id="cc_backend_unsigned_enclave-backend">
      <td><code>backend</code></td>
      <td>
        required.
        <p>
          An Asylo backend label.
        </p>
      </td>
    </tr>
    <tr id="cc_backend_unsigned_enclave-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          Arguments to cc_binary.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#cc_backend_unsigned_enclave_experimental"></a>

## cc_backend_unsigned_enclave_experimental

<pre>
cc_backend_unsigned_enclave_experimental(<a href="#cc_backend_unsigned_enclave_experimental-name">name</a>, <a href="#cc_backend_unsigned_enclave_experimental-backend">backend</a>, <a href="#cc_backend_unsigned_enclave_experimental-kwargs">kwargs</a>)
</pre>

Defines a C++ unsigned enclave target in the provided backend.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="cc_backend_unsigned_enclave_experimental-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The rule name.
        </p>
      </td>
    </tr>
    <tr id="cc_backend_unsigned_enclave_experimental-backend">
      <td><code>backend</code></td>
      <td>
        required.
        <p>
          An Asylo backend label.
        </p>
      </td>
    </tr>
    <tr id="cc_backend_unsigned_enclave_experimental-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          Arguments to cc_binary.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#cc_enclave_binary"></a>

## cc_enclave_binary

<pre>
cc_enclave_binary(<a href="#cc_enclave_binary-name">name</a>, <a href="#cc_enclave_binary-application_enclave_config">application_enclave_config</a>, <a href="#cc_enclave_binary-enclave_build_config">enclave_build_config</a>, <a href="#cc_enclave_binary-application_library_linkstatic">application_library_linkstatic</a>, <a href="#cc_enclave_binary-backends">backends</a>, <a href="#cc_enclave_binary-unsigned_name_by_backend">unsigned_name_by_backend</a>, <a href="#cc_enclave_binary-signed_name_by_backend">signed_name_by_backend</a>, <a href="#cc_enclave_binary-testonly">testonly</a>, <a href="#cc_enclave_binary-kwargs">kwargs</a>)
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
          A backend-specific configuration target to be
  passed to the enclave signer. Optional.
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
    <tr id="cc_enclave_binary-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          The asylo backend labels the binary uses. Must specify at least
  one. Defaults to all supported backends. If more than one, then
  name is an alias to a select on backend value to backend-specialized
  targets. See enclave_info.bzl:all_backends documentation for details.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_binary-unsigned_name_by_backend">
      <td><code>unsigned_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to backend-
  specific target label for the defined unsigned enclaves.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_binary-signed_name_by_backend">
      <td><code>signed_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to backend-
    specific target label for the defined signed enclaves.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_binary-testonly">
      <td><code>testonly</code></td>
      <td>
        optional. default is <code>0</code>
        <p>
          True if the targets should only be used in tests.
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
cc_enclave_test(<a href="#cc_enclave_test-name">name</a>, <a href="#cc_enclave_test-srcs">srcs</a>, <a href="#cc_enclave_test-enclave_config">enclave_config</a>, <a href="#cc_enclave_test-remote_proxy">remote_proxy</a>, <a href="#cc_enclave_test-tags">tags</a>, <a href="#cc_enclave_test-deps">deps</a>, <a href="#cc_enclave_test-test_in_initialize">test_in_initialize</a>, <a href="#cc_enclave_test-backends">backends</a>, <a href="#cc_enclave_test-unsigned_name_by_backend">unsigned_name_by_backend</a>, <a href="#cc_enclave_test-signed_name_by_backend">signed_name_by_backend</a>, <a href="#cc_enclave_test-test_name_by_backend">test_name_by_backend</a>, <a href="#cc_enclave_test-kwargs">kwargs</a>)
</pre>

Build target that runs a cc_test srcs inside of an enclave.

This macro creates two targets, one sign_enclave_with_untrusted_key target with the test
source. And another test runner application to launch the test enclave.


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
          A backend-specific configuration target to be passed to
    the signer for each backend. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-remote_proxy">
      <td><code>remote_proxy</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          Host-side executable that is going to run remote enclave
    proxy server which will actually load the enclave(s). If empty, the
    enclave(s) are loaded locally.
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
    <tr id="cc_enclave_test-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          The asylo backend labels the binary uses. Must specify at least
    one. Defaults to all supported backends. If more than one, then
    name is an alias to a select on backend value to backend-specialized
    targets. See enclave_info.bzl:all_backends documentation for details.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-unsigned_name_by_backend">
      <td><code>unsigned_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to backend-
    specific target label for the defined unsigned enclaves.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-signed_name_by_backend">
      <td><code>signed_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to backend-
    specific target label for the defined signed enclaves.
        </p>
      </td>
    </tr>
    <tr id="cc_enclave_test-test_name_by_backend">
      <td><code>test_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to
    backend-specific name for the test target.
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
cc_test(<a href="#cc_test-name">name</a>, <a href="#cc_test-enclave_test_name">enclave_test_name</a>, <a href="#cc_test-enclave_test_unsigned_name_by_backend">enclave_test_unsigned_name_by_backend</a>, <a href="#cc_test-enclave_test_signed_name_by_backend">enclave_test_signed_name_by_backend</a>, <a href="#cc_test-enclave_test_config">enclave_test_config</a>, <a href="#cc_test-srcs">srcs</a>, <a href="#cc_test-deps">deps</a>, <a href="#cc_test-backends">backends</a>, <a href="#cc_test-kwargs">kwargs</a>)
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
    <tr id="cc_test-enclave_test_unsigned_name_by_backend">
      <td><code>enclave_test_unsigned_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary of backend label to
  test name for backend-specific unsigned enclave targets generated by
  cc_enclave_test. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_test-enclave_test_signed_name_by_backend">
      <td><code>enclave_test_signed_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary of backend label to
  test name for backend-specific signed enclave targets generated by
  cc_enclave_test. Optional.
        </p>
      </td>
    </tr>
    <tr id="cc_test-enclave_test_config">
      <td><code>enclave_test_config</code></td>
      <td>
        optional. default is <code>""</code>
        <p>
          A backend-specific configuration target to be passed
  to the enclave signer for each backend. Optional.
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
    <tr id="cc_test-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          The asylo backend labels the binary uses. Must specify at least
  one. Defaults to all supported backends. If more than one, then
  name is an alias to a select on backend value to backend-specialized
  targets. See enclave_info.bzl:all_backends documentation for details.
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
cc_test_and_cc_enclave_test(<a href="#cc_test_and_cc_enclave_test-name">name</a>, <a href="#cc_test_and_cc_enclave_test-enclave_test_name">enclave_test_name</a>, <a href="#cc_test_and_cc_enclave_test-enclave_test_config">enclave_test_config</a>, <a href="#cc_test_and_cc_enclave_test-srcs">srcs</a>, <a href="#cc_test_and_cc_enclave_test-deps">deps</a>, <a href="#cc_test_and_cc_enclave_test-backends">backends</a>, <a href="#cc_test_and_cc_enclave_test-kwargs">kwargs</a>)
</pre>

An alias for cc_test with a default enclave_test_name.

This macro is identical to cc_test, except it passes in an enclave
test name automatically. It is provided for convenience of overriding the
default definition of cc_test without having to specify enclave test names.
If this behavior is not desired, use cc_test instead, which will not create
and enclave test unless given an enclave test name.

This is most useful if imported as
  load(
      "//asylo/bazel:asylo.bzl",
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
          A backend-specific configuration target to be passed
    to the signer. Optional.
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
    <tr id="cc_test_and_cc_enclave_test-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          The asylo backend labels the binary uses. Must specify at least
    one. Defaults to all supported backends. If more than one, then
    name is an alias to a select on backend value to backend-specialized
    targets. See enclave_info.bzl:all_backends documentation for details.
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


<a name="#cc_unsigned_enclave"></a>

## cc_unsigned_enclave

<pre>
cc_unsigned_enclave(<a href="#cc_unsigned_enclave-name">name</a>, <a href="#cc_unsigned_enclave-backends">backends</a>, <a href="#cc_unsigned_enclave-name_by_backend">name_by_backend</a>, <a href="#cc_unsigned_enclave-kwargs">kwargs</a>)
</pre>

Creates a C++ unsigned enclave target in all or any backend.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="cc_unsigned_enclave-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The rule name.
        </p>
      </td>
    </tr>
    <tr id="cc_unsigned_enclave-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          The asylo backend labels the binary uses. Must specify at least
  one. Defaults to all supported backends. If more than one, then
  name is an alias to a select on backend value to backend-specialized
  targets. See enclave_info.bzl:all_backends documentation for details.
        </p>
      </td>
    </tr>
    <tr id="cc_unsigned_enclave-name_by_backend">
      <td><code>name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to backend-
  specific target label.
        </p>
      </td>
    </tr>
    <tr id="cc_unsigned_enclave-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          Remainder arguments to the backend rule.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#debug_sign_enclave"></a>

## debug_sign_enclave

<pre>
debug_sign_enclave(<a href="#debug_sign_enclave-name">name</a>, <a href="#debug_sign_enclave-kwargs">kwargs</a>)
</pre>

Alias for sign_enclave_with_untrusted_key.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="debug_sign_enclave-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The rule name,
        </p>
      </td>
    </tr>
    <tr id="debug_sign_enclave-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          The rest of the arguments to sign_enclave_with_untrusted_key.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#dlopen_enclave_loader"></a>

## dlopen_enclave_loader

<pre>
dlopen_enclave_loader(<a href="#dlopen_enclave_loader-name">name</a>, <a href="#dlopen_enclave_loader-enclaves">enclaves</a>, <a href="#dlopen_enclave_loader-embedded_enclaves">embedded_enclaves</a>, <a href="#dlopen_enclave_loader-loader_args">loader_args</a>, <a href="#dlopen_enclave_loader-remote_proxy">remote_proxy</a>, <a href="#dlopen_enclave_loader-kwargs">kwargs</a>)
</pre>

Thin wrapper around enclave loader, adds necessary linkopts and testonly=1

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="dlopen_enclave_loader-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          Name for build target.
        </p>
      </td>
    </tr>
    <tr id="dlopen_enclave_loader-enclaves">
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
    <tr id="dlopen_enclave_loader-embedded_enclaves">
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
    <tr id="dlopen_enclave_loader-loader_args">
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
    <tr id="dlopen_enclave_loader-remote_proxy">
      <td><code>remote_proxy</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          Host-side executable that is going to run remote enclave
  proxy server which will actually load the enclave(s). If empty, the
  enclave(s) are loaded locally.
        </p>
      </td>
    </tr>
    <tr id="dlopen_enclave_loader-kwargs">
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


<a name="#dlopen_enclave_test"></a>

## dlopen_enclave_test

<pre>
dlopen_enclave_test(<a href="#dlopen_enclave_test-name">name</a>, <a href="#dlopen_enclave_test-kwargs">kwargs</a>)
</pre>

Thin wrapper around enclave test, adds 'asylo-dlopen' tag and necessary linkopts

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="dlopen_enclave_test-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          enclave_test name
        </p>
      </td>
    </tr>
    <tr id="dlopen_enclave_test-kwargs">
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


<a name="#enclave_build_test"></a>

## enclave_build_test

<pre>
enclave_build_test(<a href="#enclave_build_test-name">name</a>, <a href="#enclave_build_test-enclaves">enclaves</a>, <a href="#enclave_build_test-tags">tags</a>, <a href="#enclave_build_test-name_by_backend">name_by_backend</a>, <a href="#enclave_build_test-backends">backends</a>)
</pre>

Tests that the given enclaves build in the specified backends.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="enclave_build_test-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The rule name and base name for backend-specific name
    derivations.
        </p>
      </td>
    </tr>
    <tr id="enclave_build_test-enclaves">
      <td><code>enclaves</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          A list of enclave labels.
        </p>
      </td>
    </tr>
    <tr id="enclave_build_test-tags">
      <td><code>tags</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          Tags to apply to the test targets.
        </p>
      </td>
    </tr>
    <tr id="enclave_build_test-name_by_backend">
      <td><code>name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to backend-
    specific test name.
        </p>
      </td>
    </tr>
    <tr id="enclave_build_test-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          A list of Asylo backend labels.
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#enclave_loader"></a>

## enclave_loader

<pre>
enclave_loader(<a href="#enclave_loader-name">name</a>, <a href="#enclave_loader-enclaves">enclaves</a>, <a href="#enclave_loader-embedded_enclaves">embedded_enclaves</a>, <a href="#enclave_loader-loader_args">loader_args</a>, <a href="#enclave_loader-remote_proxy">remote_proxy</a>, <a href="#enclave_loader-backends">backends</a>, <a href="#enclave_loader-loader_name_by_backend">loader_name_by_backend</a>, <a href="#enclave_loader-name_by_backend">name_by_backend</a>, <a href="#enclave_loader-deprecation">deprecation</a>, <a href="#enclave_loader-kwargs">kwargs</a>)
</pre>

Wraps a cc_binary with a dependency on enclave availability at runtime.

Creates a loader for the given enclaves and containing the given embedded
enclaves. Passes flags according to `loader_args`, which can contain
references to targets from `enclaves`.

The loader is subject to a backend transition by the specified backends.

This macro creates three build targets:
  1) name: shell script that runs `name_host_loader`.
  2) name_loader: cc_binary used as loader in `name`. This is a normal
                  cc_binary. It cannot be directly run because there
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
  path to its output binary. Enclaves are built under a backend
  transition.
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
    <tr id="enclave_loader-remote_proxy">
      <td><code>remote_proxy</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          Host-side executable that is going to run remote enclave
  proxy server which will actually load the enclave(s). If empty, the
  enclave(s) are loaded locally.
        </p>
      </td>
    </tr>
    <tr id="enclave_loader-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          The asylo backend labels the binary uses. Must specify at least
    one. Defaults to all supported backends. If more than one, then
    name is an alias to a select on backend value to backend-specialized
    targets. See enclave_info.bzl:all_backends documentation for details.
        </p>
      </td>
    </tr>
    <tr id="enclave_loader-loader_name_by_backend">
      <td><code>loader_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          Dictionary of backend label to loader name for
  backend-specific enclave driver. Optional.
        </p>
      </td>
    </tr>
    <tr id="enclave_loader-name_by_backend">
      <td><code>name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to backend-
    specific loader script name.
        </p>
      </td>
    </tr>
    <tr id="enclave_loader-deprecation">
      <td><code>deprecation</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          A string deprecation message for uses of this macro that
    have been marked deprecated. Optional.
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
enclave_test(<a href="#enclave_test-name">name</a>, <a href="#enclave_test-enclaves">enclaves</a>, <a href="#enclave_test-embedded_enclaves">embedded_enclaves</a>, <a href="#enclave_test-test_args">test_args</a>, <a href="#enclave_test-remote_proxy">remote_proxy</a>, <a href="#enclave_test-backend_dependent_data">backend_dependent_data</a>, <a href="#enclave_test-tags">tags</a>, <a href="#enclave_test-backends">backends</a>, <a href="#enclave_test-loader_name_by_backend">loader_name_by_backend</a>, <a href="#enclave_test-test_name_by_backend">test_name_by_backend</a>, <a href="#enclave_test-deprecation">deprecation</a>, <a href="#enclave_test-kwargs">kwargs</a>)
</pre>

Build target for testing one or more enclaves.

Creates a cc_test for a given enclave. Passes flags according to
`test_args`, which can contain references to targets from `enclaves`.

This macro creates three build targets:
 1) name: sh_test that runs the enclave_test.
 2) name_driver: cc_test used as test loader in `name`. This is a normal
                 cc_test. It cannot be directly run because there is
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
    <tr id="enclave_test-remote_proxy">
      <td><code>remote_proxy</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          Host-side executable that is going to run remote enclave
  proxy server which will actually load the enclave(s). If empty, the
  enclave(s) are loaded locally.
        </p>
      </td>
    </tr>
    <tr id="enclave_test-backend_dependent_data">
      <td><code>backend_dependent_data</code></td>
      <td>
        optional. default is <code>[]</code>
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
    <tr id="enclave_test-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          The asylo backend labels the binary uses. Must specify at least
  one. Defaults to all supported backends. If more than one, then
  name is an alias to a select on backend value to backend-specialized
  targets. See enclave_info.bzl:all_backends documentation for details.
        </p>
      </td>
    </tr>
    <tr id="enclave_test-loader_name_by_backend">
      <td><code>loader_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
      </td>
    </tr>
    <tr id="enclave_test-test_name_by_backend">
      <td><code>test_name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
      </td>
    </tr>
    <tr id="enclave_test-deprecation">
      <td><code>deprecation</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          A string deprecation message for uses of this macro that
  have been marked deprecated. Optional.
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

Build target for testing one or more instances of 'sign_enclave_with_untrusted_key'.

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


<a name="#sign_enclave_with_untrusted_key"></a>

## sign_enclave_with_untrusted_key

<pre>
sign_enclave_with_untrusted_key(<a href="#sign_enclave_with_untrusted_key-name">name</a>, <a href="#sign_enclave_with_untrusted_key-unsigned">unsigned</a>, <a href="#sign_enclave_with_untrusted_key-key">key</a>, <a href="#sign_enclave_with_untrusted_key-backends">backends</a>, <a href="#sign_enclave_with_untrusted_key-config">config</a>, <a href="#sign_enclave_with_untrusted_key-testonly">testonly</a>, <a href="#sign_enclave_with_untrusted_key-name_by_backend">name_by_backend</a>, <a href="#sign_enclave_with_untrusted_key-visibility">visibility</a>)
</pre>

Signs an unsigned enclave according the the backend's signing procedure.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="sign_enclave_with_untrusted_key-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The signed enclave target name.
        </p>
      </td>
    </tr>
    <tr id="sign_enclave_with_untrusted_key-unsigned">
      <td><code>unsigned</code></td>
      <td>
        required.
        <p>
          The label to the unsigned enclave.
        </p>
      </td>
    </tr>
    <tr id="sign_enclave_with_untrusted_key-key">
      <td><code>key</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          The untrusted private key for signing. Default value is defined by
    the backend.
        </p>
      </td>
    </tr>
    <tr id="sign_enclave_with_untrusted_key-backends">
      <td><code>backends</code></td>
      <td>
        optional. default is <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"], transitive_features_transform = &lt;function _lvi_all_loads_to_features&gt;)}</code>
        <p>
          The asylo backend labels the binary uses. Must specify at least
  one. Defaults to all supported backends. If more than one, then
  name is an alias to a select on backend value to backend-specialized
  targets. See enclave_info.bzl:all_backends documentation for details.
        </p>
      </td>
    </tr>
    <tr id="sign_enclave_with_untrusted_key-config">
      <td><code>config</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          A label to a config target that the backend-specific signing
  tool uses.
        </p>
      </td>
    </tr>
    <tr id="sign_enclave_with_untrusted_key-testonly">
      <td><code>testonly</code></td>
      <td>
        optional. default is <code>0</code>
        <p>
          True if the target should only be used in tests.
        </p>
      </td>
    </tr>
    <tr id="sign_enclave_with_untrusted_key-name_by_backend">
      <td><code>name_by_backend</code></td>
      <td>
        optional. default is <code>{}</code>
        <p>
          An optional dictionary from backend label to backend-
  specific target label.
        </p>
      </td>
    </tr>
    <tr id="sign_enclave_with_untrusted_key-visibility">
      <td><code>visibility</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          Optional target visibility.
        </p>
      </td>
    </tr>
  </tbody>
</table>


