---

title:  //asylo/bazel:asylo_deps.bzl

overview: Repository rules for importing dependencies needed for Asylo

location: /_docs/reference/api/bazel/asylo_deps_bzl.md

layout: docs

type: markdown

toc: true

---
{% include home.html %}
<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#asylo_backend_deps"></a>

## asylo_backend_deps

<pre>
asylo_backend_deps()
</pre>

Macro to include Asylo's tools for defining a backend.



<a name="#asylo_deps"></a>

## asylo_deps

<pre>
asylo_deps(<a href="#asylo_deps-toolchain_path">toolchain_path</a>)
</pre>

Macro to include Asylo's critical dependencies in a WORKSPACE.

### Parameters

<table class="params-table">
  <colgroup>
    <col class="col-param" />
    <col class="col-description" />
  </colgroup>
  <tbody>
    <tr id="asylo_deps-toolchain_path">
      <td><code>toolchain_path</code></td>
      <td>
        optional. default is <code>None</code>
        <p>
          The absolute path to the installed Asylo toolchain.
                This can be omitted if the path is the first line of
                /usr/local/share/asylo/default_toolchain_location
        </p>
      </td>
    </tr>
  </tbody>
</table>


<a name="#asylo_go_deps"></a>

## asylo_go_deps

<pre>
asylo_go_deps()
</pre>

Macro to include Asylo's Go dependencies in a WORKSPACE.



<a name="#asylo_testonly_deps"></a>

## asylo_testonly_deps

<pre>
asylo_testonly_deps()
</pre>

Macro to include Asylo's testing-only dependencies in a WORKSPACE.



