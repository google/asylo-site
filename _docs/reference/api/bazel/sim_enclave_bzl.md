---

title:  Asylo simulation backend build rules

overview: Build rules for the process-separated simulation enclave backend.

location: /_docs/reference/api/bazel/sim_enclave_bzl.md

layout: docs

type: markdown

toc: true

---
{% include home.html %}
<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#SimEnclaveInfo"></a>

## SimEnclaveInfo

<pre>
SimEnclaveInfo()
</pre>





<a name="#sim_enclave"></a>

## sim_enclave

<pre>
sim_enclave(<a href="#sim_enclave-name">name</a>, <a href="#sim_enclave-deps">deps</a>, <a href="#sim_enclave-kwargs">kwargs</a>)
</pre>

Build rule for creating a simulated enclave shared object file.

A rule like cc_binary, but builds name_simulated.so and provides
name as a target that may be consumed as an enclave in Asylo.

Creates two targets:
  name: A binary that may be provided to an enclave loader's enclaves.
  name_simulated.so: The underlying cc_binary which is reprovided as an
                     enclave target. If name has a ".so" suffix, then it
                     is replaced with "_simulated.so".


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
          The simulated enclave target name.
        </p>
      </td>
    </tr>
    <tr id="sim_enclave-deps">
      <td><code>deps</code></td>
      <td>
        optional. default is <code>[]</code>
        <p>
          Dependencies for the cc_binary
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


