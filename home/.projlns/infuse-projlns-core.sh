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

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # B/c overlay-symlink.sh expects its root on PATH (I know, right).
  local omr_lib="${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}"
  PATH="${PATH}:${omr_lib}"
  # Load: infuser_prepare (and by side-effect: logger.sh, and colors.sh;
  #                        for this file, and for link_deep).
  # CXREF: ~/.ohmyrepos/lib/overlay-symlink.sh
  . "${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}/overlay-symlink.sh"

  # Load: _vendorfs_path_stints_basedir_print
  . "$(dirname -- "$(realpath -- "$0")")/../../core/depoxy_fs.sh"

  # Load: link_deep, and remove_symlink_hierarchy_safe.
  # CXREF: ~/.kit/git/myrepos-mredit-command/lib/link_deep.sh
  . "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command/lib/link_deep.sh"
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

  if ! mr -d / infuseProjlns; then
    warn
    warn
    warn "ALERT: \`mr -d / infuseProjlns\` failed"
    warn
    warn
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

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
  done
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

# Make one directory of symlinks to all sh-* project binaries.
# This is for showing in the Vim project tray (.vimprojects),
# so we can show a short list of all shell scripts, and not
# have to use multiple directory listings.

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
  find ${SHOILERPLATE:-${HOME}/.kit/sh}/sh-*/bin/ -type f -exec ln -s {} \;
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  set -e

  # Unset MR_CONFIG so that the OMR/lib source_deps fcns run.
  MR_CONFIG= source_deps

  infuse_projects_links_core
  infuse_projects_links_docs
  infuse_projects_links_sh_lib
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Only run when executed; no-op when sourced.
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi

