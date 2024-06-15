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

  cd "${before_cd}"
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

