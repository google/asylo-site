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


<a name="#boringssl_sign_enclave_signing_material"></a>

## boringssl_sign_enclave_signing_material

<pre>
boringssl_sign_enclave_signing_material(<a href="#boringssl_sign_enclave_signing_material-name">name</a>, <a href="#boringssl_sign_enclave_signing_material-private_key">private_key</a>, <a href="#boringssl_sign_enclave_signing_material-signature">signature</a>, <a href="#boringssl_sign_enclave_signing_material-signing_material">signing_material</a>)
</pre>

Signs an enclave signing material file with a given private key for use in sgx_signed_enclave.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory |
| :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |
| private_key |  The RSA-3072 private key with public exponent 3 in PEM format used to sign the input enclave signing material.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |
| signature |  The output signature file name [default: &lt;name&gt;.sig].   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional |
| signing_material |  A target defined by sgx_generate_enclave_signing_material.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |


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


<a name="#sgx_cc_unsigned_enclave"></a>

## sgx_cc_unsigned_enclave

<pre>
sgx_cc_unsigned_enclave(<a href="#sgx_cc_unsigned_enclave-name">name</a>, <a href="#sgx_cc_unsigned_enclave-additional_linker_inputs">additional_linker_inputs</a>, <a href="#sgx_cc_unsigned_enclave-copts">copts</a>, <a href="#sgx_cc_unsigned_enclave-defines">defines</a>, <a href="#sgx_cc_unsigned_enclave-deps">deps</a>, <a href="#sgx_cc_unsigned_enclave-includes">includes</a>, <a href="#sgx_cc_unsigned_enclave-linkopts">linkopts</a>, <a href="#sgx_cc_unsigned_enclave-linkshared">linkshared</a>, <a href="#sgx_cc_unsigned_enclave-linkstatic">linkstatic</a>, <a href="#sgx_cc_unsigned_enclave-malloc">malloc</a>, <a href="#sgx_cc_unsigned_enclave-srcs">srcs</a>, <a href="#sgx_cc_unsigned_enclave-stamp">stamp</a>)
</pre>

Defines a C++ unsigned enclave in an SGX backend

**ATTRIBUTES**


| Name  | Description | Type | Mandatory |
| :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |
| additional_linker_inputs |  Version scripts to pass to the linker.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional |
| copts |  copts for cc_binary.   | List of strings | optional |
| defines |  defines for cc_binary.   | List of strings | optional |
| deps |  deps for cc_binary.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional |
| includes |  includes for cc_binary.   | List of strings | optional |
| linkopts |  linkopts for cc_binary.   | List of strings | optional |
| linkshared |  linkshared for cc_binary.   | Integer | optional |
| linkstatic |  linkstatic for cc_binary.   | Integer | optional |
| malloc |  Custom malloc for cc_binary. Not supported. Must be the default malloc.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional |
| srcs |  srcs for cc_binary.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional |
| stamp |  stamp for cc_binary, not supported. Must be false.   | Boolean | optional |


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


<a name="#sgx_generate_enclave_signing_material"></a>

## sgx_generate_enclave_signing_material

<pre>
sgx_generate_enclave_signing_material(<a href="#sgx_generate_enclave_signing_material-name">name</a>, <a href="#sgx_generate_enclave_signing_material-config">config</a>, <a href="#sgx_generate_enclave_signing_material-signing_material">signing_material</a>, <a href="#sgx_generate_enclave_signing_material-unsigned">unsigned</a>)
</pre>

Creates a file that contains the parts of the enclave SIGSTRUCT that must be signed.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory |
| :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |
| config |  A path to a configuration XML file, or a label of an sgx_enclave_config target. A configuration specifies identity attributes, runtime behaviors that are security-critical, and other components of the enclave SIGSTRUCT.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |
| signing_material |  The name of the output file. Default is "&lt;name&gt;.dat".   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional |
| unsigned |  The label of the unsigned enclave binary to be measured and hashed as a SIGSTRUCT field   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |


<a name="#sgx_signed_enclave"></a>

## sgx_signed_enclave

<pre>
sgx_signed_enclave(<a href="#sgx_signed_enclave-name">name</a>, <a href="#sgx_signed_enclave-public_key">public_key</a>, <a href="#sgx_signed_enclave-signature">signature</a>, <a href="#sgx_signed_enclave-signing_material">signing_material</a>)
</pre>

Creates a signed enclave binary using a signature file.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory |
| :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |
| public_key |  The public key to verify the provided signature.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |
| signature |  The sha256 digest of the enclave signing material signed by the RSA-3072 private key with public exponent 3.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |
| signing_material |  The label of a sgx_generate_enclave_signing_material target that includes both the unsigned enclave and its config.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |


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
| unsigned |  A target created by sgx_cc_unsigned_enclave    |


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


<a name="#sgx.debug_enclave"></a>

## sgx.debug_enclave

<pre>
sgx.debug_enclave(<a href="#sgx.debug_enclave-name">name</a>, <a href="#sgx.debug_enclave-unsigned">unsigned</a>, <a href="#sgx.debug_enclave-config">config</a>, <a href="#sgx.debug_enclave-tags">tags</a>, <a href="#sgx.debug_enclave-deprecation">deprecation</a>, <a href="#sgx.debug_enclave-visibility">visibility</a>, <a href="#sgx.debug_enclave-testonly">testonly</a>)
</pre>

Creates a signed enclave binary by using a debug key.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The target name   |  none |
| unsigned |  The label of the unsigned enclave binary.   |  none |
| config |  The enclave configuration label to use.   |  <code>None</code> |
| tags |  Bazel tags to add to name.   |  <code>[]</code> |
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
| backends |  The Asylo backend labels to build with (:asylo_sgx_sim and/or<br>    :asylo_sgx_hw)   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], name_derivation = "_sgx_hw", order = 2, tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], name_derivation = "_sgx_sim", order = 1, tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dict from backend label to enclave target name.<br>    Optional.   |  <code>{}</code> |
| kwargs |  cc_binary arguments.   |  none |


<a name="#sgx_debug_enclave"></a>

## sgx_debug_enclave

<pre>
sgx_debug_enclave(<a href="#sgx_debug_enclave-name">name</a>, <a href="#sgx_debug_enclave-unsigned">unsigned</a>, <a href="#sgx_debug_enclave-config">config</a>, <a href="#sgx_debug_enclave-tags">tags</a>, <a href="#sgx_debug_enclave-deprecation">deprecation</a>, <a href="#sgx_debug_enclave-visibility">visibility</a>, <a href="#sgx_debug_enclave-testonly">testonly</a>)
</pre>

Creates a signed enclave binary by using a debug key.

**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The target name   |  none |
| unsigned |  The label of the unsigned enclave binary.   |  none |
| config |  The enclave configuration label to use.   |  <code>None</code> |
| tags |  Bazel tags to add to name.   |  <code>[]</code> |
| deprecation |  An optional deprecation message that issues a warning.   |  <code>None</code> |
| visibility |  The optional visibility of the enclave binary.   |  <code>None</code> |
| testonly |  True if the target should only be used in tests.   |  <code>False</code> |


<a name="#sgx_enclave"></a>

## sgx_enclave

<pre>
sgx_enclave(<a href="#sgx_enclave-name">name</a>, <a href="#sgx_enclave-config">config</a>, <a href="#sgx_enclave-testonly">testonly</a>, <a href="#sgx_enclave-kwargs">kwargs</a>)
</pre>

Build rule for creating SGX enclave shared object files signed for testing.

The enclave is signed with test key stored in
@linux_sgx//:enclave_test_private.pem.

This macro creates two build targets:
  1) name_unsigned.so: cc_binary that builds the unsigned enclave.
  2) name: internal signing rule that (debug) signs name_unsigned.so.


**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  The debug-signed enclave target name.   |  none |
| config |  An sgx_enclave_configuration rule.   |  <code>"@linux_sgx//:enclave_debug_config"</code> |
| testonly |  0 or 1, set to 1 if the target is only used in tests.   |  <code>0</code> |
| kwargs |  cc_binary arguments.   |  none |


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
| backends |  The Asylo backend labels to build with (:asylo_sgx_sim and/or<br>    :asylo_sgx_hw)   |  <code>{"@linux_sgx//:asylo_sgx_hw": struct(config_settings = ["@linux_sgx//:sgx_hw"], name_derivation = "_sgx_hw", order = 2, tags = ["asylo-sgx-hw", "manual"]), "@linux_sgx//:asylo_sgx_sim": struct(config_settings = ["@linux_sgx//:sgx_sim"], name_derivation = "_sgx_sim", order = 1, tags = ["asylo-sgx-sim", "manual"])}</code> |
| name_by_backend |  A dict from backend label to enclave target name.<br>    Optional.   |  <code>{}</code> |
| kwargs |  cc_binary arguments.   |  none |


