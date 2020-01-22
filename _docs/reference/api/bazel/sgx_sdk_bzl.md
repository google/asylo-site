---

title: "@linux_sgx//:sgx_sdk.bzl"

overview: Build rules for defining SGX enclaves.

location: /_docs/reference/api/bazel/sgx_sdk_bzl.md

layout: docs

type: markdown

toc: true

---
{% include home.html %}
<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#asylo_sgx_backend"></a>

## asylo_sgx_backend

<pre>
asylo_sgx_backend(<a href="#asylo_sgx_backend-name">name</a>)
</pre>

Defines an Asylo backend label for the SGX backend. Should only be used by @linux_sgx.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory |
| :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |


<a name="#enclave_lds"></a>

## enclave_lds

<pre>
enclave_lds(<a href="#enclave_lds-name">name</a>, <a href="#enclave_lds-debug">debug</a>, <a href="#enclave_lds-simulation">simulation</a>)
</pre>

Creates a version script to limit enclave symbol visibility

**ATTRIBUTES**


| Name  | Description | Type | Mandatory |
| :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |
| debug |  -   | Boolean | required |
| simulation |  -   | Boolean | required |


<a name="#sgx_full_enclave_configuration"></a>

## sgx_full_enclave_configuration

<pre>
sgx_full_enclave_configuration(<a href="#sgx_full_enclave_configuration-name">name</a>, <a href="#sgx_full_enclave_configuration-base">base</a>, <a href="#sgx_full_enclave_configuration-disable_debug">disable_debug</a>, <a href="#sgx_full_enclave_configuration-heap_max_size">heap_max_size</a>, <a href="#sgx_full_enclave_configuration-isvextprodid">isvextprodid</a>, <a href="#sgx_full_enclave_configuration-isvfamilyid">isvfamilyid</a>, <a href="#sgx_full_enclave_configuration-isvsvn">isvsvn</a>, <a href="#sgx_full_enclave_configuration-kss">kss</a>, <a href="#sgx_full_enclave_configuration-misc_mask">misc_mask</a>, <a href="#sgx_full_enclave_configuration-misc_select">misc_select</a>, <a href="#sgx_full_enclave_configuration-prodid">prodid</a>, <a href="#sgx_full_enclave_configuration-provision_key">provision_key</a>, <a href="#sgx_full_enclave_configuration-stack_max_size">stack_max_size</a>, <a href="#sgx_full_enclave_configuration-tcs_num">tcs_num</a>, <a href="#sgx_full_enclave_configuration-tcs_policy">tcs_policy</a>)
</pre>

Defines an enclave configuration that is meant to be used as base configuration. Use sgx_enclave_configuration to get a sensible default base.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory |
| :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |
| base |  An initial configuration from which to derive. Base configuration fields may be overwritten by setting fields in this configuration.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional |
| disable_debug |  Indicates whether launching the enclave in debug mode is disabled   | String | optional |
| heap_max_size |  The enclave's maximum heap size in bytes (4KB aligned)   | String | optional |
| isvextprodid |  The enclave's 16-byte extended ISVPRODID value. It is an error to set this attribute if 'kss' is set to False   | String | optional |
| isvfamilyid |  The enclave's 16-byte extended ISV Family ID. It is an error to set this attribute if 'kss' is set to False   | String | optional |
| isvsvn |  The enclave's ISV (Independent Software Vendor) assigned Security Version Number   | String | optional |
| kss |  A boolean that indicates whether the enclave can use Key Sharing and Separation (KSS)   | Boolean | optional |
| misc_mask |  A mask indicating which bits in misc_select are enforced   | String | optional |
| misc_select |  The desired Extended SSA frame feature (must be 0)   | String | optional |
| prodid |  The enclave's ISV (Independent Software Vendor) assigned Product ID   | String | optional |
| provision_key |  Indicates whether the enclave has access to the Provisioning Key and the Provisioning Seal Key   | String | optional |
| stack_max_size |  The enclave's maximum stack size in bytes (4KB aligned)   | String | optional |
| tcs_num |  The number of Thread Control Structures allocated for the enclave   | String | optional |
| tcs_policy |  The TCS management policy (0 - The TCS is bound to the untrusted thread, 1 - The TCS is unbound to the untrusted thread)   | String | optional |


<a name="#SGXEnclaveConfigInfo"></a>

## SGXEnclaveConfigInfo

<pre>
SGXEnclaveConfigInfo(<a href="#SGXEnclaveConfigInfo-disable_debug">disable_debug</a>, <a href="#SGXEnclaveConfigInfo-heap_max_size">heap_max_size</a>, <a href="#SGXEnclaveConfigInfo-isvsvn">isvsvn</a>, <a href="#SGXEnclaveConfigInfo-misc_mask">misc_mask</a>, <a href="#SGXEnclaveConfigInfo-misc_select">misc_select</a>, <a href="#SGXEnclaveConfigInfo-prodid">prodid</a>, <a href="#SGXEnclaveConfigInfo-provision_key">provision_key</a>, <a href="#SGXEnclaveConfigInfo-kss">kss</a>, <a href="#SGXEnclaveConfigInfo-isvextprodid">isvextprodid</a>, <a href="#SGXEnclaveConfigInfo-isvfamilyid">isvfamilyid</a>, <a href="#SGXEnclaveConfigInfo-stack_max_size">stack_max_size</a>, <a href="#SGXEnclaveConfigInfo-tcs_num">tcs_num</a>, <a href="#SGXEnclaveConfigInfo-tcs_policy">tcs_policy</a>)
</pre>

Stores an enclave configuration for enclave signing

**FIELDS**


| Name  | Description |
| :-------------: | :-------------: |
| disable_debug |  Indicates whether launching the enclave in debug mode is disabled    |
| heap_max_size |  The enclave's maximum heap size in bytes (4KB aligned)    |
| isvsvn |  The enclave's ISV (Independent Software Vendor) assigned Security Version Number    |
| misc_mask |  A mask indicating which bits in misc_select are enforced    |
| misc_select |  The desired Extended SSA frame feature (must be 0)    |
| prodid |  The enclave's ISV (Independent Software Vendor) assigned Product ID    |
| provision_key |  Indicates whether the enclave has access to the Provisioning Key and the Provisioning Seal Key    |
| kss |  A boolean that indicates whether the enclave can use Key Sharing and Separation (KSS)    |
| isvextprodid |  The enclave's 16-byte extended ISVPRODID value. It is an error to set this attribute if 'kss' is set to False    |
| isvfamilyid |  The enclave's 16-byte extended ISV Family ID. It is an error to set this attribute if 'kss' is set to False    |
| stack_max_size |  The enclave's maximum stack size in bytes (4KB aligned)    |
| tcs_num |  The number of Thread Control Structures allocated for the enclave    |
| tcs_policy |  The TCS management policy (0 - The TCS is bound to the untrusted thread, 1 - The TCS is unbound to the untrusted thread)    |


<a name="#SGXEnclaveInfo"></a>

## SGXEnclaveInfo

<pre>
SGXEnclaveInfo()
</pre>

A provider attached to an SGX enclave target for compile-time type-checking purposes

**FIELDS**



<a name="#SGXSigstructInfo"></a>

## SGXSigstructInfo

<pre>
SGXSigstructInfo(<a href="#SGXSigstructInfo-config">config</a>, <a href="#SGXSigstructInfo-unsigned">unsigned</a>)
</pre>

A provider on enclave signing material that carries the enclave and configuration targets that generate it.

**FIELDS**


| Name  | Description |
| :-------------: | :-------------: |
| config |  An SGXEnclaveConfigInfo provider that represents the configuration options    |
| unsigned |  A cc_unsigned_enclave in an SGX backend    |


<a name="#boringssl_sign_enclave_signing_material"></a>

## boringssl_sign_enclave_signing_material

<pre>
boringssl_sign_enclave_signing_material(<a href="#boringssl_sign_enclave_signing_material-name">name</a>, <a href="#boringssl_sign_enclave_signing_material-signing_material">signing_material</a>, <a href="#boringssl_sign_enclave_signing_material-private_key">private_key</a>, <a href="#boringssl_sign_enclave_signing_material-signature">signature</a>, <a href="#boringssl_sign_enclave_signing_material-backends">backends</a>, <a href="#boringssl_sign_enclave_signing_material-name_by_backend">name_by_backend</a>, <a href="#boringssl_sign_enclave_signing_material-visibility">visibility</a>, <a href="#boringssl_sign_enclave_signing_material-tags">tags</a>, <a href="#boringssl_sign_enclave_signing_material-testonly">testonly</a>)
</pre>

Signs signing material with a private key.

Signing is done in each backend if transitions enabled.


**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name, used in name derivations if transitions enabled.   |  none |
| signing_material |  The output of generate_enclave_signing_material.   |  none |
| private_key |  A label to an RSA 3072 public exponent 3 private key in<br>    PEM format.   |  none |
| signature |  An optional output file name (default name + ".sig", where<br>    name is backend-specific if transitions enabled).   |  <code>None</code> |
| backends |  The list of backend labels to build signing_material against.   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  An optional dictionary from backend label to name to<br>    backend-specific target name.   |  <code>{}</code> |
| visibility |  An optional target visibility.   |  <code>None</code> |
| tags |  Tags to apply to each target.   |  <code>[]</code> |
| testonly |  True if the target should only be used in tests.   |  <code>0</code> |


<a name="#boringssl_sign_sigstruct"></a>

## boringssl_sign_sigstruct

<pre>
boringssl_sign_sigstruct(<a href="#boringssl_sign_sigstruct-name">name</a>, <a href="#boringssl_sign_sigstruct-sigstruct">sigstruct</a>, <a href="#boringssl_sign_sigstruct-kwargs">kwargs</a>)
</pre>

Signs enclave signing material with a given private key.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name.   |  none |
| sigstruct |  A target defined by sgx_generate_enclave_signing_material.   |  none |
| kwargs |  The arguments passed to boringssl_sign_enclave_signing_material.   |  none |


<a name="#sgx.boringssl_sign_sigstruct"></a>

## sgx.boringssl_sign_sigstruct

<pre>
sgx.boringssl_sign_sigstruct(<a href="#sgx.boringssl_sign_sigstruct-name">name</a>, <a href="#sgx.boringssl_sign_sigstruct-sigstruct">sigstruct</a>, <a href="#sgx.boringssl_sign_sigstruct-kwargs">kwargs</a>)
</pre>

Signs enclave signing material with a given private key.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name.   |  none |
| sigstruct |  A target defined by sgx_generate_enclave_signing_material.   |  none |
| kwargs |  The arguments passed to boringssl_sign_enclave_signing_material.   |  none |


<a name="#sgx.boringssl_sign_enclave_signing_material"></a>

## sgx.boringssl_sign_enclave_signing_material

<pre>
sgx.boringssl_sign_enclave_signing_material(<a href="#sgx.boringssl_sign_enclave_signing_material-name">name</a>, <a href="#sgx.boringssl_sign_enclave_signing_material-signing_material">signing_material</a>, <a href="#sgx.boringssl_sign_enclave_signing_material-private_key">private_key</a>, <a href="#sgx.boringssl_sign_enclave_signing_material-signature">signature</a>, <a href="#sgx.boringssl_sign_enclave_signing_material-backends">backends</a>, <a href="#sgx.boringssl_sign_enclave_signing_material-name_by_backend">name_by_backend</a>, <a href="#sgx.boringssl_sign_enclave_signing_material-visibility">visibility</a>, <a href="#sgx.boringssl_sign_enclave_signing_material-tags">tags</a>, <a href="#sgx.boringssl_sign_enclave_signing_material-testonly">testonly</a>)
</pre>

Signs signing material with a private key.

Signing is done in each backend if transitions enabled.


**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name, used in name derivations if transitions enabled.   |  none |
| signing_material |  The output of generate_enclave_signing_material.   |  none |
| private_key |  A label to an RSA 3072 public exponent 3 private key in<br>    PEM format.   |  none |
| signature |  An optional output file name (default name + ".sig", where<br>    name is backend-specific if transitions enabled).   |  <code>None</code> |
| backends |  The list of backend labels to build signing_material against.   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  An optional dictionary from backend label to name to<br>    backend-specific target name.   |  <code>{}</code> |
| visibility |  An optional target visibility.   |  <code>None</code> |
| tags |  Tags to apply to each target.   |  <code>[]</code> |
| testonly |  True if the target should only be used in tests.   |  <code>0</code> |


<a name="#sgx.debug_enclave"></a>

## sgx.debug_enclave

<pre>
sgx.debug_enclave(<a href="#sgx.debug_enclave-name">name</a>, <a href="#sgx.debug_enclave-kwargs">kwargs</a>)
</pre>

An alias for sgx_sign_enclave_with_untrusted_key.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The name of the rule.   |  none |
| kwargs |  The rest of the arguments to<br>    sgx_sign_enclave_with_untrusted_key.   |  none |


<a name="#sgx.sign_enclave_with_untrusted_key"></a>

## sgx.sign_enclave_with_untrusted_key

<pre>
sgx.sign_enclave_with_untrusted_key(<a href="#sgx.sign_enclave_with_untrusted_key-name">name</a>, <a href="#sgx.sign_enclave_with_untrusted_key-unsigned">unsigned</a>, <a href="#sgx.sign_enclave_with_untrusted_key-config">config</a>, <a href="#sgx.sign_enclave_with_untrusted_key-key">key</a>, <a href="#sgx.sign_enclave_with_untrusted_key-tags">tags</a>, <a href="#sgx.sign_enclave_with_untrusted_key-backends">backends</a>, <a href="#sgx.sign_enclave_with_untrusted_key-name_by_backend">name_by_backend</a>, <a href="#sgx.sign_enclave_with_untrusted_key-deprecation">deprecation</a>, <a href="#sgx.sign_enclave_with_untrusted_key-visibility">visibility</a>, <a href="#sgx.sign_enclave_with_untrusted_key-testonly">testonly</a>)
</pre>

Creates a signed enclave binary by using a debug key.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The target name   |  none |
| unsigned |  The label of the unsigned enclave binary.   |  none |
| config |  The enclave configuration label to use.   |  <code>None</code> |
| key |  The untrusted key to use for signing.   |  <code>None</code> |
| tags |  Bazel tags to add to name.   |  <code>[]</code> |
| backends |  The list of backends to build against.   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dictionary from backend label to target name for<br>    user-specified target names when defining backend-specific targets.   |  <code>{}</code> |
| deprecation |  An optional deprecation message that issues a warning.   |  <code>None</code> |
| visibility |  The optional visibility of the enclave binary.   |  <code>None</code> |
| testonly |  True if the target should only be used in tests.   |  <code>False</code> |


<a name="#sgx.enclave_configuration"></a>

## sgx.enclave_configuration

<pre>
sgx.enclave_configuration(<a href="#sgx.enclave_configuration-base">base</a>, <a href="#sgx.enclave_configuration-kwargs">kwargs</a>)
</pre>

Wraps sgx_full_enclave_configuration with a default base target.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| base |  An optional base config<br>  [default @linux_sgx//:enclave_debug_config].   |  <code>"@linux_sgx//:enclave_debug_config"</code> |
| kwargs |  The rest of the sgx_full_enclave_configuration arguments.   |  none |


<a name="#sgx.generate_enclave_signing_material"></a>

## sgx.generate_enclave_signing_material

<pre>
sgx.generate_enclave_signing_material(<a href="#sgx.generate_enclave_signing_material-name">name</a>, <a href="#sgx.generate_enclave_signing_material-config">config</a>, <a href="#sgx.generate_enclave_signing_material-unsigned">unsigned</a>, <a href="#sgx.generate_enclave_signing_material-backends">backends</a>, <a href="#sgx.generate_enclave_signing_material-name_by_backend">name_by_backend</a>, <a href="#sgx.generate_enclave_signing_material-signing_material">signing_material</a>, <a href="#sgx.generate_enclave_signing_material-visibility">visibility</a>, <a href="#sgx.generate_enclave_signing_material-tags">tags</a>, <a href="#sgx.generate_enclave_signing_material-testonly">testonly</a>)
</pre>

Builds the file to sign for creating a signed enclave binary.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name, used in name derivations when transitions enabled.   |  none |
| config |  An enclave_configuration target label.   |  none |
| unsigned |  A label to an SGX unsigned enclave target. Should be generic<br>    in the backends provided, so it is recommended to use an<br>    sgx_cc_unsigned_enclave target.   |  none |
| backends |  The list of backends to build against.   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dictionary from backend label to target name for<br>    user-specified target names when defining backend-specific targets.   |  <code>{}</code> |
| signing_material |  An optional output file name.   |  <code>None</code> |
| visibility |  An optional visibility specification.   |  <code>None</code> |
| tags |  Tags to apply to each target.   |  <code>[]</code> |
| testonly |  If true, the target may only be dependended on by testonly<br>    and test targets.   |  <code>0</code> |


<a name="#sgx.generate_sigstruct"></a>

## sgx.generate_sigstruct

<pre>
sgx.generate_sigstruct(<a href="#sgx.generate_sigstruct-name">name</a>, <a href="#sgx.generate_sigstruct-sigstruct">sigstruct</a>, <a href="#sgx.generate_sigstruct-kwargs">kwargs</a>)
</pre>

Creates a file that contains parts of the enclave SIGSTRUCT.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name.   |  none |
| sigstruct |  The name of the output file. Default is "&lt;name&gt;.dat".   |  <code>None</code> |
| kwargs |  The arguments passed to sgx_generate_enclave_signing_material.   |  none |


<a name="#sgx.signed_enclave"></a>

## sgx.signed_enclave

<pre>
sgx.signed_enclave(<a href="#sgx.signed_enclave-name">name</a>, <a href="#sgx.signed_enclave-public_key">public_key</a>, <a href="#sgx.signed_enclave-signature">signature</a>, <a href="#sgx.signed_enclave-signing_material">signing_material</a>, <a href="#sgx.signed_enclave-backends">backends</a>, <a href="#sgx.signed_enclave-name_by_backend">name_by_backend</a>, <a href="#sgx.signed_enclave-visibility">visibility</a>, <a href="#sgx.signed_enclave-testonly">testonly</a>, <a href="#sgx.signed_enclave-tags">tags</a>)
</pre>

Creates a signed enclave binary using a signature file.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name, used in name derivations when transitions enabled.   |  none |
| public_key |  The public key to verify the provided signature.   |  none |
| signature |  The sha256 digest of the enclave signing material signed by<br>    the RSA-3072 private key with public exponent 3.   |  none |
| signing_material |  The label of a sgx_generate_enclave_signing_material<br>    target that includes both the unsigned enclave and its config.   |  none |
| backends |  The list of backends to build against.   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dictionary from backend label to target name for<br>    user-specified target names when defining backend-specific targets.   |  <code>{}</code> |
| visibility |  An optional visibility specification.   |  <code>None</code> |
| testonly |  If true, the target may only be dependended on by testonly<br>    and test targets.   |  <code>0</code> |
| tags |  Tags to apply to each target.   |  <code>[]</code> |


<a name="#sgx.tags"></a>

## sgx.tags

<pre>
sgx.tags()
</pre>

Returns tags for SGX targets.

**PARAMETERS**



<a name="#sgx.unsigned_enclave"></a>

## sgx.unsigned_enclave

<pre>
sgx.unsigned_enclave(<a href="#sgx.unsigned_enclave-name">name</a>, <a href="#sgx.unsigned_enclave-stamp">stamp</a>, <a href="#sgx.unsigned_enclave-backends">backends</a>, <a href="#sgx.unsigned_enclave-name_by_backend">name_by_backend</a>, <a href="#sgx.unsigned_enclave-kwargs">kwargs</a>)
</pre>

Build rule for creating a C++ unsigned SGX enclave shared object file.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The enclave target name.   |  none |
| stamp |  The cc_binary stamp argument, but with a default value 0.   |  <code>0</code> |
| backends |  The Asylo backend labels to build with (:asylo_sgx_sim and/or<br>    :asylo_sgx_hw)   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dict from backend label to enclave target name.<br>    Optional.   |  <code>{}</code> |
| kwargs |  cc_binary arguments.   |  none |


<a name="#sgx_debug_enclave"></a>

## sgx_debug_enclave

<pre>
sgx_debug_enclave(<a href="#sgx_debug_enclave-name">name</a>, <a href="#sgx_debug_enclave-kwargs">kwargs</a>)
</pre>

An alias for sgx_sign_enclave_with_untrusted_key.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The name of the rule.   |  none |
| kwargs |  The rest of the arguments to<br>    sgx_sign_enclave_with_untrusted_key.   |  none |


<a name="#sgx_enclave_configuration"></a>

## sgx_enclave_configuration

<pre>
sgx_enclave_configuration(<a href="#sgx_enclave_configuration-base">base</a>, <a href="#sgx_enclave_configuration-kwargs">kwargs</a>)
</pre>

Wraps sgx_full_enclave_configuration with a default base target.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| base |  An optional base config<br>  [default @linux_sgx//:enclave_debug_config].   |  <code>"@linux_sgx//:enclave_debug_config"</code> |
| kwargs |  The rest of the sgx_full_enclave_configuration arguments.   |  none |


<a name="#sgx_generate_enclave_signing_material"></a>

## sgx_generate_enclave_signing_material

<pre>
sgx_generate_enclave_signing_material(<a href="#sgx_generate_enclave_signing_material-name">name</a>, <a href="#sgx_generate_enclave_signing_material-config">config</a>, <a href="#sgx_generate_enclave_signing_material-unsigned">unsigned</a>, <a href="#sgx_generate_enclave_signing_material-backends">backends</a>, <a href="#sgx_generate_enclave_signing_material-name_by_backend">name_by_backend</a>, <a href="#sgx_generate_enclave_signing_material-signing_material">signing_material</a>, <a href="#sgx_generate_enclave_signing_material-visibility">visibility</a>, <a href="#sgx_generate_enclave_signing_material-tags">tags</a>, <a href="#sgx_generate_enclave_signing_material-testonly">testonly</a>)
</pre>

Builds the file to sign for creating a signed enclave binary.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name, used in name derivations when transitions enabled.   |  none |
| config |  An enclave_configuration target label.   |  none |
| unsigned |  A label to an SGX unsigned enclave target. Should be generic<br>    in the backends provided, so it is recommended to use an<br>    sgx_cc_unsigned_enclave target.   |  none |
| backends |  The list of backends to build against.   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dictionary from backend label to target name for<br>    user-specified target names when defining backend-specific targets.   |  <code>{}</code> |
| signing_material |  An optional output file name.   |  <code>None</code> |
| visibility |  An optional visibility specification.   |  <code>None</code> |
| tags |  Tags to apply to each target.   |  <code>[]</code> |
| testonly |  If true, the target may only be dependended on by testonly<br>    and test targets.   |  <code>0</code> |


<a name="#sgx_generate_sigstruct"></a>

## sgx_generate_sigstruct

<pre>
sgx_generate_sigstruct(<a href="#sgx_generate_sigstruct-name">name</a>, <a href="#sgx_generate_sigstruct-sigstruct">sigstruct</a>, <a href="#sgx_generate_sigstruct-kwargs">kwargs</a>)
</pre>

Creates a file that contains parts of the enclave SIGSTRUCT.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name.   |  none |
| sigstruct |  The name of the output file. Default is "&lt;name&gt;.dat".   |  <code>None</code> |
| kwargs |  The arguments passed to sgx_generate_enclave_signing_material.   |  none |


<a name="#sgx_sign_enclave_with_untrusted_key"></a>

## sgx_sign_enclave_with_untrusted_key

<pre>
sgx_sign_enclave_with_untrusted_key(<a href="#sgx_sign_enclave_with_untrusted_key-name">name</a>, <a href="#sgx_sign_enclave_with_untrusted_key-unsigned">unsigned</a>, <a href="#sgx_sign_enclave_with_untrusted_key-config">config</a>, <a href="#sgx_sign_enclave_with_untrusted_key-key">key</a>, <a href="#sgx_sign_enclave_with_untrusted_key-tags">tags</a>, <a href="#sgx_sign_enclave_with_untrusted_key-backends">backends</a>, <a href="#sgx_sign_enclave_with_untrusted_key-name_by_backend">name_by_backend</a>, <a href="#sgx_sign_enclave_with_untrusted_key-deprecation">deprecation</a>, <a href="#sgx_sign_enclave_with_untrusted_key-visibility">visibility</a>, <a href="#sgx_sign_enclave_with_untrusted_key-testonly">testonly</a>)
</pre>

Creates a signed enclave binary by using a debug key.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The target name   |  none |
| unsigned |  The label of the unsigned enclave binary.   |  none |
| config |  The enclave configuration label to use.   |  <code>None</code> |
| key |  The untrusted key to use for signing.   |  <code>None</code> |
| tags |  Bazel tags to add to name.   |  <code>[]</code> |
| backends |  The list of backends to build against.   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dictionary from backend label to target name for<br>    user-specified target names when defining backend-specific targets.   |  <code>{}</code> |
| deprecation |  An optional deprecation message that issues a warning.   |  <code>None</code> |
| visibility |  The optional visibility of the enclave binary.   |  <code>None</code> |
| testonly |  True if the target should only be used in tests.   |  <code>False</code> |


<a name="#sgx_signed_enclave"></a>

## sgx_signed_enclave

<pre>
sgx_signed_enclave(<a href="#sgx_signed_enclave-name">name</a>, <a href="#sgx_signed_enclave-public_key">public_key</a>, <a href="#sgx_signed_enclave-signature">signature</a>, <a href="#sgx_signed_enclave-signing_material">signing_material</a>, <a href="#sgx_signed_enclave-backends">backends</a>, <a href="#sgx_signed_enclave-name_by_backend">name_by_backend</a>, <a href="#sgx_signed_enclave-visibility">visibility</a>, <a href="#sgx_signed_enclave-testonly">testonly</a>, <a href="#sgx_signed_enclave-tags">tags</a>)
</pre>

Creates a signed enclave binary using a signature file.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The rule name, used in name derivations when transitions enabled.   |  none |
| public_key |  The public key to verify the provided signature.   |  none |
| signature |  The sha256 digest of the enclave signing material signed by<br>    the RSA-3072 private key with public exponent 3.   |  none |
| signing_material |  The label of a sgx_generate_enclave_signing_material<br>    target that includes both the unsigned enclave and its config.   |  none |
| backends |  The list of backends to build against.   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dictionary from backend label to target name for<br>    user-specified target names when defining backend-specific targets.   |  <code>{}</code> |
| visibility |  An optional visibility specification.   |  <code>None</code> |
| testonly |  If true, the target may only be dependended on by testonly<br>    and test targets.   |  <code>0</code> |
| tags |  Tags to apply to each target.   |  <code>[]</code> |


<a name="#sgx_tags"></a>

## sgx_tags

<pre>
sgx_tags()
</pre>

Returns tags for SGX targets.

**PARAMETERS**



<a name="#sgx_unsigned_enclave"></a>

## sgx_unsigned_enclave

<pre>
sgx_unsigned_enclave(<a href="#sgx_unsigned_enclave-name">name</a>, <a href="#sgx_unsigned_enclave-stamp">stamp</a>, <a href="#sgx_unsigned_enclave-backends">backends</a>, <a href="#sgx_unsigned_enclave-name_by_backend">name_by_backend</a>, <a href="#sgx_unsigned_enclave-kwargs">kwargs</a>)
</pre>

Build rule for creating a C++ unsigned SGX enclave shared object file.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The enclave target name.   |  none |
| stamp |  The cc_binary stamp argument, but with a default value 0.   |  <code>0</code> |
| backends |  The Asylo backend labels to build with (:asylo_sgx_sim and/or<br>    :asylo_sgx_hw)   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_hw", order = 2, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], debug_default_config = "@linux_sgx//:enclave_debug_config", debug_private_key = "@linux_sgx//:enclave_test_private.pem", name_derivation = "_sgx_sim", order = 1, sign_tool = "@linux_sgx//:sgx_sign_tool", tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dict from backend label to enclave target name.<br>    Optional.   |  <code>{}</code> |
| kwargs |  cc_binary arguments.   |  none |


