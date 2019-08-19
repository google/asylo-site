---

title: Asylo SGX backend build rules

overview: Build rules for defining SGX enclaves.

location: /_docs/reference/api/bazel/sgx_sdk_bzl.md

layout: docs

type: markdown

toc: true

---
{% include home.html %}
<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#sgx_enclave_configuration"></a>

## sgx_enclave_configuration

<pre>
sgx_enclave_configuration(<a href="#sgx_enclave_configuration-name">name</a>, <a href="#sgx_enclave_configuration-disable_debug">disable_debug</a>, <a href="#sgx_enclave_configuration-heap_max_size">heap_max_size</a>, <a href="#sgx_enclave_configuration-isvextprodid">isvextprodid</a>, <a href="#sgx_enclave_configuration-isvfamilyid">isvfamilyid</a>, <a href="#sgx_enclave_configuration-isvsvn">isvsvn</a>, <a href="#sgx_enclave_configuration-kss">kss</a>, <a href="#sgx_enclave_configuration-misc_mask">misc_mask</a>, <a href="#sgx_enclave_configuration-misc_select">misc_select</a>, <a href="#sgx_enclave_configuration-prodid">prodid</a>, <a href="#sgx_enclave_configuration-provision_key">provision_key</a>, <a href="#sgx_enclave_configuration-stack_max_size">stack_max_size</a>, <a href="#sgx_enclave_configuration-tcs_num">tcs_num</a>, <a href="#sgx_enclave_configuration-tcs_policy">tcs_policy</a>)
</pre>



### Attributes

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="sgx_enclave_configuration-name">
      <td><code>name</code></td>
      <td>
        <a href="https://bazel.build/docs/build-ref.html#name">Name</a>; required
        <p>
          A unique name for this target.
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-disable_debug">
      <td><code>disable_debug</code></td>
      <td>
        String; optional
        <p>
          Indicates whether launching the enclave in debug mode is disabled
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-heap_max_size">
      <td><code>heap_max_size</code></td>
      <td>
        String; optional
        <p>
          The enclave's maximum heap size in bytes (4KB aligned)
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-isvextprodid">
      <td><code>isvextprodid</code></td>
      <td>
        String; optional
        <p>
          The enclave's 16-byte extended ISVPRODID value. It is an error to set this attribute if 'kss' is set to False
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-isvfamilyid">
      <td><code>isvfamilyid</code></td>
      <td>
        String; optional
        <p>
          The enclave's 16-byte extended ISV Family ID. It is an error to set this attribute if 'kss' is set to False
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-isvsvn">
      <td><code>isvsvn</code></td>
      <td>
        String; optional
        <p>
          The enclave's ISV (Independent Software Vendor) assigned Security Version Number
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-kss">
      <td><code>kss</code></td>
      <td>
        Boolean; optional
        <p>
          Indicates whether the enclave can use Key Sharing and Separation (KSS)
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-misc_mask">
      <td><code>misc_mask</code></td>
      <td>
        String; optional
        <p>
          A mask indicating which bits in misc_select are enforced
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-misc_select">
      <td><code>misc_select</code></td>
      <td>
        String; optional
        <p>
          The desired Extended SSA frame feature (must be 0)
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-prodid">
      <td><code>prodid</code></td>
      <td>
        String; optional
        <p>
          The enclave's ISV (Independent Software Vendor) assigned Product ID
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-provision_key">
      <td><code>provision_key</code></td>
      <td>
        String; optional
        <p>
          Indicates whether the enclave has access to the Provisioning Key and the Provisioning Seal Key
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-stack_max_size">
      <td><code>stack_max_size</code></td>
      <td>
        String; optional
        <p>
          The enclave's maximum stack size in bytes (4KB aligned)
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-tcs_num">
      <td><code>tcs_num</code></td>
      <td>
        String; optional
        <p>
          The number of Thread Control Structures allocated for the enclave
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave_configuration-tcs_policy">
      <td><code>tcs_policy</code></td>
      <td>
        String; optional
        <p>
          The TCS management policy (0 - The TCS is bound to the untrusted thread, 1 - The TCS is unbound to the untrusted thread)
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#SGXEnclaveConfigInfo"></a>

## SGXEnclaveConfigInfo

<pre>
SGXEnclaveConfigInfo()
</pre>





<a name="#SGXEnclaveInfo"></a>

## SGXEnclaveInfo

<pre>
SGXEnclaveInfo()
</pre>





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


### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="sgx_enclave-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The debug-signed enclave target name.
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave-config">
      <td><code>config</code></td>
      <td>
        optional. default is <code>"@linux_sgx//:enclave_debug_config"</code>
        <p>
          An sgx_enclave_configuration rule.
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave-testonly">
      <td><code>testonly</code></td>
      <td>
        optional. default is <code>0</code>
        <p>
          0 or 1, set to 1 if the target is only used in tests.
        </p>
      </td>
    </tr>
    <tr id="sgx_enclave-kwargs">
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


<a name="#sgx_tags"></a>

## sgx_tags

<pre>
sgx_tags()
</pre>

Returns tags for SGX targets.



