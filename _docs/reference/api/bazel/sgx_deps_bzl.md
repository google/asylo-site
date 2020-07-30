---

title:  //asylo/bazel:sgx_deps.bzl

overview: Repository rules for importing dependencies needed for the SGX backends

location: /_docs/reference/api/bazel/sgx_deps_bzl.md

layout: docs

type: markdown

toc: true

---
{% include home.html %}
<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#sgx_deps"></a>

## sgx_deps

<pre>
sgx_deps()
</pre>

Macro to include Asylo's SGX backend dependencies in a WORKSPACE.

SGX backend dependencies have Intel's highest level of LVI mitigation
("All-Loads-Mitigation") applied automatically [1]. This can be customized
on a per-target basis by specifying one of "lvi_all_loads_mitigation",
"lvi_control_flow_mitigation", or "lvi_no_auto_mitigation" in the list of
`transitive_features` on the corresponding unsigned enclave target, or with
a top-level `--features=lvi_*_mitigation` flag passed to Bazel.

[1]: https://software.intel.com/security-software-guidance/insights/deep-dive-load-value-injection



