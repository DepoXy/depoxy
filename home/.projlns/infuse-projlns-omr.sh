#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# USAGE: Called by infuse_symlinks_home_projlns:
#
#   ~/.depoxy/ambers/home/infuse-user-home

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

MREDIT_CONFIGS="${MREDIT_CONFIGS:-${DEPOXY_PROJLNS:-${HOME}/.projlns}/mymrconfigs}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # B/c overlay-symlink.sh expects its root on PATH (I know, right).
  local omr_lib="${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}"
  PATH="${PATH}:${omr_lib}"
  # Load: infuser_prepare (and by side-effect: logger.sh, and colors.sh;
  #                        used by this file, and dep upon by link_deep).
  # CXREF: ~/.ohmyrepos/lib/overlay-symlink.sh
  . "${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}/overlay-symlink.sh"

  # Load: link_deep, and remove_symlink_hierarchy_safe. Requires logger.sh.
  # CXREF: ~/.kit/git/myrepos-mredit-command/lib/link_deep.sh
  . "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command/lib/link_deep.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_projects_links_omr_config () {
  local before_cd="$(pwd -L)"

  mkdir -p "${MREDIT_CONFIGS}"

  cd "${MREDIT_CONFIGS}"

  info "$(fg_mintgreen)$(attr_emphasis)Creating links$(attr_reset)" \
    "$(fg_lightorange)$(pwd)$(attr_reset)"

  infuse_create_symlinks_omr_entrypoint

  infuse_create_symlinks_omr_scattered "$@"

  cd "${before_cd}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Usually the root ~/.mrconfig is a symlink elsewhere, but just in
# case it's not, we'll deep-link it.
infuse_create_symlinks_omr_entrypoint () {
  local home_mrconfig="${HOME}/.mrconfig"

  if [ -f "${home_mrconfig}" ] && [ ! -h "${home_mrconfig}" ]; then
    link_deep "${home_mrconfig}"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Dig through DepoXy sources (projects) are create deep-links to all
# *mrconfig* files.
#
# - SAVVY: `find -type f` does not include symlinks.
#
# - NOTED/2024-06-15: We don't search VENDOR_HOME_HOME, e.g., ~/work
#   - Generally, user keeps their vendor-specific _mrconfig within the
#     DepoXy Client, under ~/.depoxy/running, so shouldn't be an issue.
#
# - NOTED: link_deep doesn't realpath; it'll use the path you give it.

# USAGE: Pass-through args: Additional search directories.

infuse_create_symlinks_omr_scattered () {
  # USYNC: Similar ignore lists (in different DepoXy projects):
  #   ~/.depoxy/ambers/home/.kit/git/ohmyrepos/lib/infuse-personal-projlns.sh
  #   ~/.depoxy/ambers/home/.projlns/infuse-projlns-omr.sh
  #   ~/.homefries/lib/alias/alias_fd.sh
  #   ~/.vim/pack/landonb/start/dubs_project_tray/plugin/dubs_project.vim
  # - MAYBE: DRY the -prune list.
  # - The prune below also includes the ~/.kit/git/mrepos project sources,
  #   because a number of files therein include "mrconfig" in their name.
  while IFS= read -r path; do
    link_deep "${path}"
  done < <( \
    find \
      "${HOME}/.depoxy" \
      "${HOME}/.kit" \
      "$@" \
      \
      \( \
        -name "TBD-*" -o -name "*-TBD" \
        \
        -o -name ".git" \
        -o -name "htmlcov" \
        -o -name "node_modules" \
        -o -name ".nyc_output" \
        -o -name "__pycache__" \
        -o -name ".pytest_cache" \
        -o -name "site-packages" \
        -o -name ".tox" \
        -o -name ".trash" \
        -o -name ".venv" \
        -o -path "*.venv-*" \
        -o -name ".vscode" \
        \
        -o -name ".archived" \
        -o -name ".whilom" \
        \
        -o -name "myrepos" \
      \) -prune -o \
      -name "*mrconfig*" \
      -type f \
      -print
  )
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  set -e

  source_deps

  # ***

  # Set by link_deep
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

  infuse_projects_links_omr_config "$@"

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

