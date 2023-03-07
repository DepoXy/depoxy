#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

MREDIT_CONFIGS="${MREDIT_CONFIGS:-${DEPOXY_PROJLNS:-${HOME}/.projlns}/mymrconfigs}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # Load: logger.sh, and color.sh
  . "${OHMYREPOS_DIR:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos}/deps/sh-logger/bin/logger.sh"

  # Load: _vendorfs_path_running_client_print.
  # - CXREF: ~/.depoxy/ambers/core/depoxy_fs.sh
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  . "${DEPOXYAMBERS_DIR:-${ambers_path}}/core/depoxy_fs.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

remove_existing_links () {
  find . -maxdepth 1 -type l -exec /bin/rm {} +
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_projects_links_omr_config () {
  local before_cd="$(pwd -L)"

  mkdir -p "${MREDIT_CONFIGS}"

  cd "${MREDIT_CONFIGS}"

  info "$(fg_mintgreen)$(attr_emphasis)Creating links$(attr_reset)" \
    "$(fg_lightorange)$(pwd)$(attr_reset)"

  remove_existing_links

  infuse_create_symlinks_omr_home

  infuse_create_symlinks_omr_ohmyrepos

  infuse_create_symlinks_omr_vim

  infuse_create_symlinks_omr_kit_root

  infuse_create_symlinks_omr_kit_projects

  infuse_create_symlinks_omr_client

  cd "${before_cd}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** ${HOME}

infuse_create_symlinks_omr_home () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local home_cfg_root="${DEPOXYAMBERS_DIR:-${ambers_path}}/home"

  symlink "${home_cfg_root}/_mrconfig"
}

# *** ${GITREPOSPATH}/ohmyrepos/.mrconfig-omr

infuse_create_symlinks_omr_ohmyrepos () {
  local omr_cfg_root="${OHMYREPOS_DIR:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos}"

  symlink "${omr_cfg_root}/.mrconfig-omr"
  # Just FYI (we don't need to put it under search), the example config:
  #  symlink "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/.mrconfig.example" \
  #     "kit-omr-mrconfig.example"
}

# *** ${HOME}/.vim

infuse_create_symlinks_omr_vim () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local vim_cfg_root="${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.vim"

  symlink "${vim_cfg_root}/_mrconfig"
  symlink "${vim_cfg_root}/_mrconfig-3rdp"
  symlink "${vim_cfg_root}/_mrconfig-dubs"
  symlink "${vim_cfg_root}/_mrconfig-lsp"
}

# *** ${DOPP_KIT:-${HOME}/.kit}

infuse_create_symlinks_omr_kit_root () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local kit_cfg_root="${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.kit"

  symlink "${kit_cfg_root}/_mrconfig"
}

# *** ${DOPP_KIT:-${HOME}/.kit}/**

infuse_create_symlinks_omr_kit_projects () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local kit_cfg_root="${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.kit"

  symlink "${kit_cfg_root}/git/_mrconfig-git-core"
  symlink "${kit_cfg_root}/git/_mrconfig-git-smart"
  symlink "${kit_cfg_root}/go/_mrconfig"
  symlink "${kit_cfg_root}/js/_mrconfig"
  symlink "${kit_cfg_root}/mOS/_mrconfig"
  symlink "${kit_cfg_root}/odd/_mrconfig"
  symlink "${kit_cfg_root}/py/_mrconfig"
  symlink "${kit_cfg_root}/sh/_mrconfig-bash"
  symlink "${kit_cfg_root}/sh/_mrconfig-shell"
  symlink "${kit_cfg_root}/txt/_mrconfig"
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

  find "${client_basedir}" -type f -regex '.*mrconfig.*' |
    while read -r mrconfig_path; do
      symlink "${mrconfig_path}"
    done
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

symlink () {
  local source="$1"

  # Build the hierarchy.
  local relative_dir
  relative_dir="$(dirname "${source}" | sed 's#^/##')"

  mkdir -p "${relative_dir}"

  # Make the symlink.
  local config_file
  config_file="$(basename "${source}")"

  local target="${relative_dir}/${config_file}"

  # Not calling symlink_overlay_file, which dies on missing target.
  /bin/ln -s "${source}" "${target}"

  # `ln` happily makes symlink to non-existent target, which we
  # will allow (which is a Good Thing, e.g., `rg` complains on
  # broken links, which'll alert user to the problem). But we'll
  # also check ourselves, to be proactive.
  if [ -e "${source}" ]; then
    let 'INFUSE_SYMLINKS_CNT += 1'
  else
    let 'INFUSE_SYMLINKS_NOK += 1'

    >&2 warn "Phantom target symlinked: ${source}"
    >&2 warn "- Find broken symlink at: $(pwd)/${target}"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  INFUSE_SYMLINKS_CNT=0
  INFUSE_SYMLINKS_NOK=0

  source_deps

  infuse_projects_links_omr_config

  local nok_msg=""
  [ ${INFUSE_SYMLINKS_NOK} -eq 0 ] || nok_msg=" (${INFUSE_SYMLINKS_NOK} broken)"
  info "- Created ${INFUSE_SYMLINKS_CNT} symlinks total${nok_msg}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

set -e

# Only run when executed; no-op when sourced.
if [ "$0" = "${BASH_SOURCE}" ]; then
  main "$@"
fi

