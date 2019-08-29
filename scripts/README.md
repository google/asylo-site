# Documentation and site builder scripts

Our website uses a protobuf compiler plugin from the [Istio
toolchain](https://github.com/istio/tools). The html files
that tool produces need some transformation in order for
them to be usable in a local site build.

The compiler must know which `.proto` files to build in the
first place. We use a simple `.manifest` file format to list
all the public protos to include in the source code documentation.

The `build.sh` script fetches the Asylo SDK source from a given location,
builds the documentation (unless given `-n` or `--nodocs`), and then
builds the site in a docker container (unless given `-j` or `--nojekyll`).

A `Dockerfile` is provided that builds a container image with the needed
dependencies to run this script.

To build documentation for the Asylo SDK already stored in `/opt/asylo/sdk`,
run
```bash
build.sh /opt/asylo/sdk
```

To build documentation for a given archive of the Asylo SDK, pass the URL
to the archive or a path to the archive file (`.tar.gz`).
```bash
build.sh ~/Downloads/asylo-v0.2.0.tar.gz
build.sh https://github.com/google/asylo/archive/v0.2.0.tar.gz
```

## The `.manifest` file format

The manifest file instructs the site builder script to generate
documentation for each of the listed files. 

Each listed proto file gets its own page at its stated `$homeLocation`
(see [protobuf documentation format](#protobuf-documentation-format) for details).

The format of this file is a newline-separated list of paths to proto files.
Comments are ignored to the end of the line.
A line path may optionally have a second field to provide the compiler with
non-default flags.

The default flags to the Istio `--docs_out` extension to `protoc` are

```
mode=jekyll_html,camel_case_fields=false,link_by_file=true
```

The field may optionally use two aliases for flags. The first, "default" is the
same as the flags above. The second, "pkg" is similar, but instructs the compiler
to generate per-package documentation rather than per-file:

```
mode=jekyll_html,camel_case_fields=false,link_by_file=false
```

Per-package documentation transitively follows imports and generates all
`message`, `service`, and `enum` documentation elements.
Any file may document the `pkg` statement in a package compilation (not per-file),
but no two files may document it.

## Protobuf documentation format

For full details, see the protobuf documentation extension's [README.md](https://github.com/istio/tools/tree/master/protoc-gen-docs).

Documentation for a proto element is a leading comment or a trailing comment:

```
// Leading comment to `DocumentedProto`.
message DocumentedProto {
  optional string field = 1;  // Trailing comment to `field`.
}
```

A file treats the `pkg` statement as the introduction of either the file or the
entire package, depending on the compilation mode. The leading comment of the
`pkg` statement is rendered as the introduction text for the resulting
documentation page.

Above the `pkg` statement can be "detached" comments that contain metadata for
the resulting documentation page. A detached comment does not immediately
precede or trail a code element. For example,

```
// This is a detached comment because there is nothing above or below it.
// Except more comments.

// Still detached.

// This is attached to the `pkg` statement.
pkg example;
```

Metadata in the detached comments above the `pkg` statement are tagged with
keywords. 

*  `"$title: "` defines both the link text in navigation and the top header element of the
   documentation page
*  `"$overview: "` defines the snippet that appears to the right of the link in a
   directory's section listing.
*  `"$homeLocation: "` defines the location of the documentation of the package or file.
   These location filenames should be versioned to releases to allow archival linking to
   release-contextual documentation. The `"$front_matter: "` tag may define a `redirect_from: `
   front-matter entry for a more ergonomic URL to redirect to the latest version (e.g.,
   `enclave.html` may redirect to `asylo.enclave.v1.html`)

Each of the above may only appear in one file per compilation unit.  The
`"$front_matter: "` tag may appear arbitrarily often (still in a detached
comment above the `pkg` statement). In per-file mode, a compilation unit is one
file. In per-package mode, a compilation unit includes all transitively imported
files.

## Prose documentation

The concepts, guides, and about pages are hand-written rather than
generated. These documents are typically developed outside the live website to
allow for collaborative editing. These markdown files should contain Jekyll
front matter to indicate the documents' intended location location in the
repo. The root of the repository is considered `/`.  For example, the `about.md`
file is in the `_about` subdirectory, so it should have front matter such as

```
---
title: About
location: /_about/about.md
---
```

Do not add `redirect_from: /about/about.html` for this file because it will
create a redirect loop.

### Markdown image dependencies

Markdown has an image embedding directive, `![Caption](url)`, that is not
appropriate for the website. The alternative image placement markup states more
specific information about size and ratios. Therefore the `build.sh` script
interprets some comments related to image embeddings to replace
`![Caption](url)` with a user-provided replacement. Additionally, since docs are
sourced from the Asylo repo, the images are copied from their source path to a
stated destination.

```markdown
<!--asylo:image-replace-begin(destination-path-relative-to-destination-doc)-->

![Caption](source-path-relative-to-source-doc)
<!--asylo:image-replace-with[...]-->
```

The `[...]` is any text you want, except `$destination` and `$description` will
be replaced with `destination-path-relative-to-destination-doc` and `Caption`
respectively, and newlines are unsupported.

Example from the website:

```markdown
<!--asylo:image-replace-begin(./img/asylo.png)-->

![Asylo architecture](images/asylo.png)
<!--asylo:image-replace-with {% include figure.html width='80%' ratio='46.36%' img='$destination' alt='$description' title='$description' caption='$description' %} -->
```

The `-a` option to `build.sh` additionally applies to the relocated image files.
