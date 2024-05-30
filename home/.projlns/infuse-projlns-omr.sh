#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

MREDIT_CONFIGS="${MREDIT_CONFIGS:-${DEPOXY_PROJLNS:-${HOME}/.projlns}/mymrconfigs}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # Load: infuser_prepare (and by side-effect: logger.sh, and colors.sh;
  #                        for this file, and for link_deep).
  # CXREF: ~/.ohmyrepos/lib/overlay-symlink.sh
  . "${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}/overlay-symlink.sh"

  # Load: link_deep, and remove_symlink_hierarchy_safe.
  # CXREF: ~/.kit/git/myrepos-mredit-command/lib/link_deep.sh
  . "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command/lib/link_deep.sh"

  # Load: _vendorfs_path_running_client_print.
  # - CXREF: ~/.depoxy/ambers/core/depoxy_fs.sh
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  . "${DEPOXYAMBERS_DIR:-${ambers_path}}/core/depoxy_fs.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_projects_links_omr_config () {
  local before_cd="$(pwd -L)"

  mkdir -p "${MREDIT_CONFIGS}"

  cd "${MREDIT_CONFIGS}"

  info "$(fg_mintgreen)$(attr_emphasis)Creating links$(attr_reset)" \
    "$(fg_lightorange)$(pwd)$(attr_reset)"

  infuse_create_symlinks_omr_home

  infuse_create_symlinks_omr_ohmyrepos

  infuse_create_symlinks_omr_vim

  infuse_create_symlinks_omr_kit_root

  infuse_create_symlinks_omr_kit_projects

  infuse_create_symlinks_omr_client

  infuse_create_symlinks_omr_stints

  cd "${before_cd}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** ${HOME}

infuse_create_symlinks_omr_home () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local home_cfg_root="${DEPOXYAMBERS_DIR:-${ambers_path}}/home"

  link_deep "${home_cfg_root}/_mrconfig"
}

# *** ${GITREPOSPATH}/ohmyrepos/.mrconfig-omr

infuse_create_symlinks_omr_ohmyrepos () {
  local omr_cfg_root="${OHMYREPOS_DIR:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos}"

  link_deep "${omr_cfg_root}/.mrconfig-omr"
  # Just FYI (we don't need to put it under search), the example config:
  #  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/.mrconfig.example"
}

# *** ${HOME}/.vim

infuse_create_symlinks_omr_vim () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local vim_cfg_root="${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.vim"

  link_deep "${vim_cfg_root}/_mrconfig"
  link_deep "${vim_cfg_root}/_mrconfig-3rdp"
  link_deep "${vim_cfg_root}/_mrconfig-dubs"
  link_deep "${vim_cfg_root}/_mrconfig-lsp"
}

# *** ${DOPP_KIT:-${HOME}/.kit}

infuse_create_symlinks_omr_kit_root () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local kit_cfg_root="${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.kit"

  link_deep "${kit_cfg_root}/_mrconfig"
}

# *** ${DOPP_KIT:-${HOME}/.kit}/**

infuse_create_symlinks_omr_kit_projects () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local kit_cfg_root="${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.kit"

  link_deep "${kit_cfg_root}/git/_mrconfig-git-core"
  link_deep "${kit_cfg_root}/git/_mrconfig-git-smart"
  link_deep "${kit_cfg_root}/go/_mrconfig"
  link_deep "${kit_cfg_root}/js/_mrconfig"
  link_deep "${kit_cfg_root}/mOS/_mrconfig"
  link_deep "${kit_cfg_root}/mOS/_mrconfig-excess"
  link_deep "${kit_cfg_root}/odd/_mrconfig"
  link_deep "${kit_cfg_root}/py/_mrconfig"
  link_deep "${kit_cfg_root}/sh/_mrconfig-bash"
  link_deep "${kit_cfg_root}/sh/_mrconfig-shell"
  link_deep "${kit_cfg_root}/txt/_mrconfig"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** ${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}/${DEPOXY_CLIENT_ID}
#
#   Look for *mrconfig* in current Client directory, e.g., ~/.depoxy/stints/2321/

# THOTS: How best to while-loop.
#
# - Is there a preferred way to loop over `find` results?
#   Is one more POSIX-compliant, or backwards-compatible?
#
# - Here's a loop using a here document:
#
#     while read -r mrconfig_path; do
#       echo "mrconfig_path=$mrconfig_path"
#     done <<< $(find "${client_basedir}" -type f -regex '.*mrconfig.*')
#
# But perhaps putting the find before the while is more readable.

infuse_create_symlinks_omr_client () {
  local client_basedir
  client_basedir="$(_vendorfs_path_running_client_print)" || return 0

  local mrconfig_path
  while read -r mrconfig_path; do
    link_deep "${mrconfig_path}"
  done < <(find "${client_basedir}" -type f -regex '.*mrconfig.*')
}

# ***

# Optional ~/.depoxy/stints/_mrconfig
infuse_create_symlinks_omr_stints () {
  local stints_basedir
  stints_basedir="$(_vendorfs_path_stints_basedir_print)" || return 0
  # ALTLY:
  #   client_basedir="${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}"

  local mrconfig_path="${stints_basedir}/_mrconfig"

  if [ -f "${mrconfig_path}" ]; then
    link_deep "${mrconfig_path}"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  set -e

  source_deps

  # ***

  INFUSE_SYMLINKS_CNT=0
  INFUSE_SYMLINKS_NOK=0

  # ***

  local before_cd="$(pwd -L)"

  mkdir -p "${MREDIT_CONFIGS}"

  cd "${MREDIT_CONFIGS}"

  info "$(fg_mintgreen)$(attr_emphasis)Creating links$(attr_reset)" \
    "$(fg_lightorange)$(pwd)$(attr_reset)"

  remove_symlink_hierarchy_safe

  infuser_prepare "${MREDIT_CONFIGS}"

  infuse_projects_links_omr_config

  cd "${before_cd}"

  # ***

  local nok_msg=""
  [ ${INFUSE_SYMLINKS_NOK} -eq 0 ] || nok_msg=" (${INFUSE_SYMLINKS_NOK} broken)"
  info "- Created ${INFUSE_SYMLINKS_CNT} symlinks total${nok_msg}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Only run when executed; no-op when sourced.
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi

