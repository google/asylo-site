---

title:  //asylo/bazel:dlopen_enclave.bzl

overview: Build rules for the process-separated dlopen enclave backend.

location: /_docs/reference/api/bazel/dlopen_enclave_bzl.md

layout: docs

type: markdown

toc: true

---
{% include home.html %}
<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#asylo_dlopen_backend"></a>

## asylo_dlopen_backend

<pre>
asylo_dlopen_backend(<a href="#asylo_dlopen_backend-name">name</a>)
</pre>

Declares name of the Asylo dlopen backend. Used in backend transitions.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory |
| :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |


<a name="#DlopenEnclaveInfo"></a>

## DlopenEnclaveInfo

<pre>
DlopenEnclaveInfo()
</pre>

A provider attached to a dlopen enclave target for compile-time type-checking purposes

**FIELDS**



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


<a name="#primitives_dlopen_enclave"></a>

## primitives_dlopen_enclave

<pre>
primitives_dlopen_enclave(<a href="#primitives_dlopen_enclave-name">name</a>, <a href="#primitives_dlopen_enclave-kwargs">kwargs</a>)
</pre>

Defines a cc_binary enclave that uses the dlopen backend.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="primitives_dlopen_enclave-name">
      <td><code>name</code></td>
      <td>
        required.
        <p>
          The rule name.
        </p>
      </td>
    </tr>
    <tr id="primitives_dlopen_enclave-kwargs">
      <td><code>kwargs</code></td>
      <td>
        optional.
        <p>
          The arguments to cc_binary.
        </p>
      </td>
    </tr>
  </tbody>
</table>


