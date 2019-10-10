#!/bin/bash

set -e

# Configurable variables.
readonly BASE_URL=https://asylo.dev
readonly DOCS_URL="${BASE_URL}/docs"
readonly DOCS_DIR="_docs"
readonly SOURCES_DEFAULT=/opt/asylo/docs

readonly TEMP_ARCHIVE_PATH=/tmp/asylo.tar.gz
# The path relative to the sources directory to a file that lists
# which proto files are public and thus need to have documentation
# generated for them.
readonly PROTO_MANIFEST_PATH=asylo/public_protos.manifest
# The path relative to the sources directory to a file that lists
# the stardoc documentation labels to build, along with the output
# files' destination directory.
readonly BAZEL_MANIFEST_PATH=asylo/bzl_docs.manifest
# The path relative to the sources directory to a file that lists
# which prose markdown files
readonly DOCS_MANIFEST_DEFAULT=asylo/docs.manifest

# Derived variables.
readonly HERE=$(realpath $(dirname "$0"))
# This script expects to be in the site's scripts/ subdirectory.
readonly SITE=$(realpath "${HERE}/..")

function usage() {
  cat <<EOF
  Usage: $0 [flags] [path-to-sources]
  Flags:
    -a,--git-add         Run `git add` on all created files.
    -n,--nodocs          Run without building any documentation.
    -j,--nojekyll        Run without starting a Jekyll server in docker.
    -x,--nodoxygen       Run without building Doxygen documentation.
    -p,--noprotos        Run without building protobuf documentation.
    -b,--nobazel         Run without building bazel documentation.
    -m,--manifest <path> Perform relocation from a documentation manifest.
                         [default manifest path is asylo/docs.manifest]
    -h,--help            Print this message to stdout.

  The path to asylo can be a path to a .tar.gz file, an https://
  URL for a .tar.gz file, or a system directory path.
  The path default is ${SOURCES_DEFAULT}.

  This script builds an up-to-date Asylo website and serves it
  incrementally from localhost for quick development iteration.
EOF
}


NO_DOCS=
NO_JEKYLL=
NO_DOXYGEN=
NO_PROTOS=
DOCS_MANIFEST=
GIT_ADD=
readonly LONG="manifest:,nodocs,nobazel,nodoxygen,nojekyll,noprotos,git-add,help"
readonly PARSED=$(getopt -o abnjphxm: --long "${LONG}" -n "$(basename "$0")" -- "$@")
eval set -- "${PARSED}"
while true; do
  case "$1" in
    -a|--git-add) GIT_ADD=1; shift ;;
    -n|--nodocs) NO_DOCS=1 ; shift ;;
    -j|--nojekyll) NO_JEKYLL=1; shift ;;
    -x|--nodoxygen) NO_DOXYGEN=1; shift ;;
    -p|--noprotos) NO_PROTOS=1; shift ;;
    -b|--nobazel) NO_BAZEL=1; shift ;;
    -m|--manifest)
      # Followed by another flag, or explicitly "default"
      if [[ "$2" = -* ]]; then
        DOCS_MANIFEST="${DOCS_MANIFEST_DEFAULT}"
        shift
      elif [[ "$2" = default ]]; then
        DOCS_MANIFEST="${DOCS_MANIFEST_DEFAULT}"
        shift 2
      else
        DOCS_MANIFEST="$2";
        shift 2
      fi
      ;;
    -h|--help) usage ; exit 0 ;;
    --) shift ; break;;
    *) echo "Unexpected input $1"; usage; exit 1 ;;
  esac
done
ASYLO_LOCATION="$1"

# No location given. Use the default.
if [[ -z "${ASYLO_LOCATION}" ]]; then
  ASYLO_LOCATION="${SOURCES_DEFAULT}"
fi

# If the path is not an existing directory or file, treat it as a URL.
if [[ -n "${ASYLO_LOCATION}" ]] &&
   [[ ! -e "${ASYLO_LOCATION}" ]] &&
   wget -nv "${ASYLO_LOCATION}" -O "${TEMP_ARCHIVE_PATH}"; then
  ASYLO_LOCATION=${TEMP_ARCHIVE_PATH}
fi

# Decompress the given or downloaded file.
if [[ -f "${ASYLO_LOCATION}" ]]; then
  TEMP=$(mktemp -d)
  if ! tar xvf "${ASYLO_LOCATION}" -C "${TEMP}"; then
    echo "Could not decompress Asylo archive ${ASYLO_LOCATION}" >&2
    exit 1
  fi
  ASYLO_LOCATION="${TEMP}"
fi

# Find and transform image uses.
#
# <!--asylo:image-replace-begin(dest)-->
#
# ![description](source)
# <!--asylo:image-replace-with replacement-->
#
# becomes
#
# replacement'
#
# where replacement' is replacement with $destination substituted for dest,
# and $description substituded for description.
#
# The more long-form replacement allows use of non ![desc](url) forms.
#
# <!--asylo:image-replace-begin(source => dest)-->
# anything
# <!--asylo:image-replace-with replacement-->
#
# becomes replacement with $destination substituted for dest. There is no
# substitution for description.
#
# The file source gets relocated to dest, relative to the image file's
# relocation destination.
# See [the README](README.md#markdown-image-dependencies) for more explanation.
function relocate_images() {
  local source_dir="$1"
  local out_file="$2"
  local out_dir="$3"
  local replace_re='/(.*)<!--\s*asylo:image-replace-with(.*)-->(.*)/'
  local begin_move_re='/<!--\s*asylo:image-replace-begin\(([^=) ]*)\s*=>\s*([^)]*)*\)-->/'
  local begin_re='/<!--\s*asylo:image-replace-begin\(([^)]*)\)-->/'
  local source_re='/!\[(.*)\]\((.*)\)/'
  local full_source=$(printf '\\"%s/\" source "\\"' "${ASYLO_LOCATION}/${source_dir}")
  local full_destination=$(printf '\\"%s/\" destination "\\"' "${out_dir}")
  local mkdir_command=$(printf '"mkdir -p $(dirname %s)"' "${full_destination}")
  local copy_command=$(printf '"cp %s %s"' "${full_source}" "${full_destination}")
  local git_add_destination=
  local git_add_command=
  if [[ -n "${GIT_ADD}" ]]; then
    git_add_command=$(printf '"git -C \\"%s\\" add %s"' "${SITE}" "${full_destination}")
    git_add_destination="system(${git_add_command})"
  fi
  local transformed=$(mktemp)
  gawk "{
    simple = (\$0 ~ ${begin_re});
    extra = (\$0 ~ ${begin_move_re});
    if (simple || extra) {
      description = \"\";
      destination = \"\";
      source = \"\";
      if (extra) {
        source = gensub(${begin_move_re}, \"\\\\1\", 1, \$0);
        destination = gensub(${begin_move_re}, \"\\\\2\", 1, \$0);
        do { getline; } while (\$0 !~ ${replace_re});
      } else if (simple) {
        destination = gensub(${begin_re}, \"\\\\1\", 1, \$0);
        do { getline; } while (\$0 ~ /^\\s*\$/);
        if (\$0 !~ ${source_re}) {
          print \"Unexpected source image syntax \" \$0 > \"/dev/stderr\"
          exit 1
        }
        description = gensub(${source_re}, \"\\\\1\", 1, \$0);
        source = gensub(${source_re}, \"\\\\2\", 1, \$0);
        do { getline; } while (\$0 ~ /^\\s*\$/);
      }
      if (\$0 !~ ${replace_re}) {
        print \"Unexpected image replacement syntax \" \$0 > \"/dev/stderr\"
        exit 1
      }

      # Fill in the $destination and $description variables in replacement text.
      pre = gensub(${replace_re}, \"\\\\1\", 1, \$0);
      replacement = gensub(${replace_re}, \"\\\\2\", 1, \$0);
      post = gensub(${replace_re}, \"\\\\3\", 1, \$0);
      if (!extra) {
        replacement = gensub(/\\\$description/, description, \"g\", replacement);
      }
      replacement = gensub(/\\\$destination/, destination, \"g\", replacement);
      print pre replacement post

      # Ensure the destination directory exists.
      system(${mkdir_command});

      # Copy over the image.
      print \"Writing file ${out_dir}/\" destination > \"/dev/stderr\"
      system(${copy_command});

      # Add the image to staging if -a given.
      ${git_add_destination}
    } else { print }
  }" "${out_file}" > "${transformed}"
  mv "${transformed}" "${out_file}"
}

# Given the name of a .pb.html or .md file, extract the $location marker and
# then copy the file to that relative location in the _docs hierarchy.
function relocate_file() {
  local readonly FILENAME="$1"
  local readonly OUT_DIR="$2"
  local readonly RELATIVE_BASE_URL="$3"

  local readonly LOCATION_PREFIX="^location: ${RELATIVE_BASE_URL}"
  local readonly LOCATION_LINE=$(grep "${LOCATION_PREFIX}" "${FILENAME}")
  if [[ -z "${LOCATION_LINE}" ]]; then
      echo "No 'location:' tag in ${FILENAME}, skipping"
      return
  fi
  local readonly PREFIX_LENGTH=${#LOCATION_PREFIX}
  local readonly RELATIVE_PATH="${LOCATION_LINE:${PREFIX_LENGTH}}"
  local readonly BASENAME=$(basename "${RELATIVE_PATH}")
  local readonly DIRNAME=$(dirname "${RELATIVE_PATH}")
  mkdir -p "${OUT_DIR}/${DIRNAME}"
  local readonly OUT_PATH="${OUT_DIR}/${DIRNAME}/${BASENAME}"
  echo "Writing file ${OUT_PATH}"
  # Replace absolute paths to DOMAIN with the baseurl for <a href="">
  # and for markdown [..]()
  sed -e "s!href=\"${BASE_URL}!href=\"{{site.baseurl}}!g" \
    -e "s!\][(]${BASE_URL}!]({{home}}!g" ${FILENAME} > "${OUT_PATH}"
  # If an md file, replace header links that use _ spacing with -.
  # Also remove jekyll-front-matter comment wrappers.
  if [[ "${FILENAME}" = *.md ]]; then
    sed -i -e ':a' -e 's/\(][(]#[^)_]*\)_/\1-/;t a' \
      -e '/^\s*<!--jekyll-front-matter/d' \
      -e '/^\s*jekyll-front-matter-->/d' \
      "${OUT_PATH}"
    relocate_images $(dirname "${FILENAME}") "${OUT_PATH}" "${OUT_DIR}/${DIRNAME}"
  fi

  if [[ -n "${GIT_ADD}" ]]; then
    (cd "${SITE}"; git add "${OUT_PATH}")
  fi
}

function build_proto_file_doc() {
  # Uses protoc-gen-docs from github.com/istio/tools to produce documentation
  # from comments in a .proto file.
  if [[ -z $(which protoc-gen-docs) ]]; then
    echo "ERROR: Missing the proto documentation compiler protoc-gen-docs." >&2
    return 1
  fi

  local TEMP=$(mktemp -d)
  local SOURCE="$1"
  local OUT_DIR="$2"
  local USER_FLAGS="$3"
  local FLAGS="mode=jekyll_html,camel_case_fields=false,per_file=true"
  if [[ "${USER_FLAGS}" = "pkg" ]]; then
    FLAGS=$(sed -e 's/per_file=true//' <<< "${FLAGS}")
  elif [[ -n "${USER_FLAGS}" ]] && [[ "${USER_FLAGS}" != "default" ]]; then
    FLAGS="${USER_FLAGS}"
  fi
  local CMD="protoc --docs_out=${FLAGS}:${TEMP}"
  # This assumes the .proto file is in the asylo package.
  local OUT_BASE=$(sed -e 's/\.proto$/.pb.html/' <<< $(basename "${SOURCE}"))

  ${CMD} "${SOURCE}"
  relocate_file "${TEMP}/${OUT_BASE}" "${OUT_DIR}" "${DOCS_URL}"
  rm -rf "${TEMP}"
}

function build_proto_docs() {
  # Build the protobuf documentation.
  local readonly MANIFEST="$1"
  while read path flags; do
    if [[ -n "${path}" ]]; then
        build_proto_file_doc "${path}" "${SITE}/${DOCS_DIR}" "${flags}"
    fi
  done < <(sed -e 's/#.*//' "${MANIFEST}")
}

function jekyll_bzl_transform() {
  local original="$1"
  local markdown="$2"
  local output_file="$(mktemp --suffix=.md)"

  # Find the comment block that starts website-docs-metadata
  awk '{
    if ($0 ~ /# website-docs-metadata/) {
      getline
      while ($0 ~ /^#/) {
        gsub(/^#$/, "");
        gsub(/^# /, "");
        print
        getline
      }
    }
  }' "${original}" > "${output_file}"
  cat "${markdown}" >> "${output_file}"
  echo "${output_file}"
}

function build_bazel_docs() {
  # Build the Starlark documentation.
  local readonly MANIFEST="$1"
  local paths=()
  local out_dir="${SITE}"
  local path
  local source
  while read path source; do
    if [[ -n "${path}" ]]; then
      # Build and record all output paths
      local output=$(mktemp)
      paths=($(bazel build "${path}" 2>&1 | tee "${output}" | grep -E '^[[:space:]]+bazel-' | sed 's/^\s*//g'))
      if [[ "${#paths[@]}" -eq 0 ]]; then
        echo "WARNING: No output for bazel documentation on ${path}" >&2
        cat "${output}"
      elif [[ "${#paths[@]}" -ne 1 ]]; then
        echo "WARNING: unexpected multiple output files for ${path}: ${paths[@]}" >&2
      fi
      rm "${output}"
      if [[ "${path:0:1}" = "@" ]]; then
        source="$(bazel info execution_root)/${source}"
      fi
      # Copy each path to the Bazel documentation directory.
      for path in "${paths[@]}"; do
        # Put the front matter from the source bzl file in the output markdown header.
        # The comment block that begins "# website-docs-metadata" will have its
        # content, sans website-docs-metadata, written to the top of the md file.
        local transformed=$(jekyll_bzl_transform "${source}" "${path}")
        relocate_file "${transformed}" "${out_dir}"
        rm "${transformed}"
      done
    fi
  done < <(sed -e 's/#.*//' "${MANIFEST}")
}

function build_doxygen_docs() {
  # Build the C++ reference docs.
  rm -rf "${SITE}/doxygen"
  # Change SGXLoader references to the SimLoader alias.
  if which doxygen; then
    $(which doxygen) && cp -r asylo/docs/html/. "${SITE}/doxygen"
  fi
  # Find baseurl: in _config.yml to replace in links, since the Doxygen
  # html is uninterpreted by Jekyll
  local CONFIG_BASEURL=$(grep baseurl "${SITE}/_config.yml" | awk '{ print $2 }')
  if [[ "${CONFIG_BASEURL}" = "/" ]]; then
    CONFIG_BASEURL=""
  fi
  find "${SITE}/doxygen" \( -name '*.html' -o -name '*.js' -o -name '*.map' \) -exec sed -i \
    -e "s!href=\"${BASE_URL}!href=\"${CONFIG_BASEURL}!g" \
    -e "s/SGXLoader/SimLoader/g" \
    -e "s/sgxloader/simloader/g" {} \;
  find "${SITE}/doxygen" -name '*SGXLoader*' \
    -exec sh -c 'mv {} $(sed -e 's/SGXLoader/SimLoader/g' <<< {})' \;

  # Fix the links from the GitHub README.
  local GITHUB=https://github.com/google/asylo
  sed -i -e "s#href=\"asylo/#href=\"${GITHUB}/tree/master/asylo/#g" \
    -e "s#href=\"INSTALL\.md#href=\"${GITHUB}/blob/master/INSTALL.md#" \
    "${SITE}/doxygen/index.html"
  
  if [[ -n "${GIT_ADD}" ]]; then
    (cd "${SITE}"; git add "${SITE}/doxygen/*")
  fi
}

function build_prose_docs() {
  # Relocate the prose documentation.
  local readonly MANIFEST="$1"
  while read path outdir; do
    if [[ -n "${path}" ]]; then
        relocate_file "${path}" "${SITE}"
    fi
  done < <(sed -e 's/#.*//' "${MANIFEST}")
}

function build_docs() {
  cd "${ASYLO_LOCATION}"

  if [[ -z "${NO_DOXYGEN}" ]]; then
    build_doxygen_docs
  fi

  if [[ -z "${NO_PROTOS}" ]]; then
    build_proto_docs "${PROTO_MANIFEST_PATH}"
  fi

  if [[ -z "${NO_BAZEL}" ]]; then
    build_bazel_docs "${BAZEL_MANIFEST_PATH}"
  fi

  if [[ -n "${DOCS_MANIFEST}" ]]; then
    build_prose_docs "${DOCS_MANIFEST}"
  fi
}

if [[ -z "${NO_DOCS}" ]]; then
  # Build documentation for the given Asylo archive.
  # An archive can be either a tag or a commit hash.
  build_docs
fi

if [[ -z "${NO_JEKYLL}" ]]; then
  # Build and serve the website locally.
  docker run --rm --label=jekyll \
    --volume=${SITE}:/srv/jekyll \
    -v ${SITE}/_site:${SITE}/_site \
    -it -p 4000:4000 \
    jekyll/jekyll:3.6.0 \
    sh -c "bundle install && rake test && bundle exec jekyll serve --incremental"
fi
