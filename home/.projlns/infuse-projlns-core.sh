#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# USAGE: Called by infuse_symlinks_home_projlns:
#
#   ~/.depoxy/ambers/home/infuse-user-home

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

DEPOXY_PROJLNS="${DEPOXY_PROJLNS:-${HOME}/.projlns}"

DEPOXY_PROJLNS_USRDOC="${DEPOXY_PROJLNS_USRDOC:-${DEPOXY_PROJLNS}/docs-and-backlog}"

DEPOXY_PROJLNS_SH_LIB="${DEPOXY_PROJLNS_SH_LIB:-${DEPOXY_PROJLNS}/sh-lib}"

# REFER: See lib/infuse-personal-projlns.sh:
#  DEPOXY_PROJLNS_DEPOXY="${DEPOXY_PROJLNS_DEPOXY:-${DEPOXY_PROJLNS}/depoxy-deeplinks}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # B/c overlay-symlink.sh expects its root on PATH (I know, right).
  local omr_lib="${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}"
  PATH="${PATH}:${omr_lib}"
  # Load: infuser_prepare (and by side-effect: logger.sh, and colors.sh;
  #                        for this file, and for link_deep),
  #       path_to_mrinfuse_resolve
  # CXREF: ~/.ohmyrepos/lib/overlay-symlink.sh
  . "${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}/overlay-symlink.sh"

  # Load: _vendorfs_path_stints_basedir_print
  . "$(dirname -- "$(realpath -- "$0")")/../../core/depoxy_fs.sh"

  # ISOFF: Loaded by infuse-personal-projlns.sh:
  #
  # # Load: link_deep, and remove_symlink_hierarchy_safe.
  # # CXREF: ~/.kit/git/myrepos-mredit-command/lib/link_deep.sh
  # . "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command/lib/link_deep.sh"

  # Load: is_infuse_all, link_deep.sh, DEPOXY_PROJLNS_DEPOXY
  # CXREF: ~/.depoxy/ambers/home/.kit/git/ohmyrepos/lib/infuse-personal-projlns.sh
  . "$(dirname -- "$(realpath -- "$0")")/../.kit/git/ohmyrepos/lib/infuse-personal-projlns.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

populate_links_directory () {
  local lns_path="$1"
  local lns_func="$2"

  local before_cd="$(pwd -L)"

  mkdir -p "${lns_path}"

  cd "${lns_path}"

  infuser_prepare "${lns_path}"

  remove_symlink_hierarchy_safe

  eval "${lns_func}"

  cd "${before_cd}"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

# CXREF: ~/.depoxy/ambers/home/.kit/git/ohmyrepos/lib/infuse-personal-projlns.sh

infuse_projects_links_core () {
  # HSTRY/2024-06-16: This replicates historic behavior, but it's
  # a titch slow, and only needs to run when projects are added or
  # removed, or if user edits a project's infuseProjlns action.
  # - So we'll skip this, but leave a breadcrumb.
  #
  # MAYBE/2024-06-16: Enable this short-circuit:
  #  return 0

  # We can at least skip this when `mr -d ~/.depoxy/ambers -n infuse`
  # is run (which calls this script), i.e., only run on `mr -d / infuse`.
  if ! is_infuse_all; then

    return 0
  fi

  # Remove Ctags file, lest `remove_symlink_hierarchy_safe` fails:
  #   "Symlink hierarchy target exists but contains regular files"
  command rm -f -- "${DEPOXY_PROJLNS_DEPOXY}/tags"

  if ! mr -d / infuseProjlns; then
    warn
    warn
    warn "ALERT: \`mr -d / infuseProjlns\` failed"
    warn
    warn
  fi
}

# ***

# Run Ctags on ~/.projlns/depoxy-deeplinks:
#
# - Use --exclude to omit code that's not yours.
#   - USYNC: See similar exclude patterns:
#     ~/.depoxy/ambers/home/.projlns/infuse-projlns-core.sh
#     ~/.kit/sh/home-fries/lib/alias/alias_rg_tag.sh
#     ~/.vim/pack/landonb/start/dubs_file_finder/plugin/dubs_file_finder.vim
#     ~/.vim/pack/landonb/start/dubs_grep_steady/bin/vim-grepprg-rg-sort
#
# - Inhibit final summary using --totals=no.
#   - Omits, e.g.,
#     25458 files, 8613434 lines (513523 kB) scanned in 146.1 seconds (3513 kB/s)
#     861265 tags added to tag file
#     861265 tags sorted in 0.00 seconds

infuse_projects_links_core_generate_ctags () {
  # Use ctags wrapper to filter (delete afterwards) JavaScript false matches.
  # CXREF: ~/.kit/sh/home-fries/bin/ctags-groom.sh
  local ctags_groom="${HOMEFRIES_BIN:-${HOMEFRIES_DIR:-${HOME}/.kit/sh/home-fries}/bin}/ctags-groom.sh"

  if ! ctags --version 2> /dev/null | head -n 1 | grep -q -e "^Exuberant Ctags"; then
    warn "Skipping ~/.projlns Ctags, because Exuberant Ctags not found."

    return 0
  fi

  LOG_MSG_NO_NEWLINE=true info "Creating Exuberant Ctags file... "

  local time_0="$(date +%s.%N)"

  (
    cd "${DEPOXY_PROJLNS_DEPOXY}"

    ${ctags_groom} \
      --exclude=".git" \
      --exclude=".tox" \
      --exclude="node_modules" \
      --exclude=".venv*" \
      --totals=no \
      -R
  )

  if [ ${LOG_LEVEL:-${LOG_LEVEL_ERROR:-40}} -le ${LOG_LEVEL_INFO:-20} ]; then
    # Get the file size using st_size, aka `-f %z`
    local tags_size
    tags_size="$( \
      echo "scale=0; $(stat -f %z "${DEPOXY_PROJLNS_DEPOXY}/tags") / 1024 / 1024" | bc -l
    )"

    printf "%s (%s)\n" \
      "done!" \
      "$(print_elapsed_mins "${time_0}" "${time_n}") min., ${tags_size}M file"
  fi
}

print_elapsed_mins () {
  local time_0="$1"
  local time_n="${2:-$(date +%s.%N)}"

  # SAVVY: `bc -l` loads the math library, so scale=1 reduces precision.
  echo "scale=1; ($time_n - $time_0) / 60" | bc -l | xargs printf "%.2f"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

# Infuse DEPOXY_PROJLNS_USRDOC, e.g., ~/.projlns/docs-and-backlog
infuse_projects_links_docs () {
  populate_links_directory \
    "${DEPOXY_PROJLNS_USRDOC}" \
    "infuse_create_symlinks_docs"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USYNC: DXY_MAKE_LNS_NAME and infuse_create_symlinks_docs use same '.syml--' prefix.
infuse_create_symlinks_docs () {
  # E.g., ~/.depoxy/stints
  local clients_path="$(_vendorfs_path_stints_basedir_print)"

  if [ ! -d "${clients_path}" ]; then
    return
  fi

  populate_links_directory_optional_ignore

  # For each DepoXy Client (~/.depoxy/stints/XXXX),
  # symlink its docs/ and private/docs
  find "${clients_path}" -mindepth 1 -maxdepth 1 -type d \
    | while read subdir_path; \
  do
    local subdir_name="$(basename -- "${subdir_path}")"

    if [ "${subdir_name#.syml--}" != "${subdir_name}" ]; then
      # Ignore `.syml--XXXX' dirs (DXY_MAKE_LNS_NAME).
      continue
    fi

    if [ -d "${subdir_path}/docs" ]; then
      link_deep "${subdir_path}/docs" "client-${subdir_name}-docs"
    fi

    if [ -d "${subdir_path}/private/docs" ]; then
      link_deep "${subdir_path}/private/docs" "client-${subdir_name}-private-docs"
    fi
  done
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

# Make one directory of symlinks to all sh-* project binaries.
# This is for showing in the Vim project tray (.vimprojects),
# so we can show a short list of all shell scripts, and not
# have to use multiple directory listings.

# Infuse DEPOXY_PROJLNS_SH_LIB, e.g., ~/.projlns/sh-lib
infuse_projects_links_sh_lib () {
  populate_links_directory \
    "${DEPOXY_PROJLNS_SH_LIB}" \
    "infuse_create_symlinks_core_sh_lib"

  info " Created sh-lib links $(fg_lightorange)${DEPOXY_PROJLNS_SH_LIB}$(attr_reset)"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# SAVVY: If any sh-*/bin dirs contain same-named file, you'll see, e.g.,
#   ln: failed to create symbolic link './print-nanos-now.sh': File exists
infuse_create_symlinks_core_sh_lib () {
  populate_links_directory_optional_ignore

  find ${SHOILERPLATE:-${HOME}/.kit/sh}/sh-*/bin/ -type f -exec ln -s {} \;
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

# Look for optional private ~/.projlns/<subdir>/.ignore asset
# (using '_ignore' filename).
populate_links_directory_optional_ignore () {
  local sourcep
  if sourcep="$(path_to_mrinfuse_resolve "_ignore")" \
    && [ -f "${sourcep}" ] \
  ; then
    symlink_mrinfuse_file "_ignore" ".ignore"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  set -e

  # Unset MR_CONFIG so that the OMR/lib source_deps fcns run.
  MR_CONFIG= source_deps

  infuse_projects_links_core
  infuse_projects_links_core_generate_ctags

  infuse_projects_links_docs

  infuse_projects_links_sh_lib
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Only run when executed; no-op when sourced.
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi

