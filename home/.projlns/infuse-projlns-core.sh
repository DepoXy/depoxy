#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

DEPOXY_PROJLNS="${DEPOXY_PROJLNS:-${HOME}/.projlns}"

DEPOXY_PROJLNS_DEPOXY="${DEPOXY_PROJLNS_DEPOXY:-${DEPOXY_PROJLNS}/depoxy-deeplinks}"

DEPOXY_PROJLNS_USRDOC="${DEPOXY_PROJLNS_USRDOC:-${DEPOXY_PROJLNS}/docs-and-backlog}"

DEPOXY_PROJLNS_SH_LIB="${DEPOXY_PROJLNS_SH_LIB:-${DEPOXY_PROJLNS}/sh-lib}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # Load: infuser_prepare (and by side-effect: logger.sh, and colors.sh;
  #                        for this file, and for link_deep).
  # CXREF: ~/.ohmyrepos/lib/overlay-symlink.sh
  . "${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}/overlay-symlink.sh"

  # Load: _vendorfs_path_stints_basedir_print
  . "$(dirname "$(realpath "$0")")/../../core/depoxy_fs.sh"

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

infuse_projects_links_core () {
  populate_links_directory \
    "${DEPOXY_PROJLNS_DEPOXY}" \
    "infuse_create_symlinks_core"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_create_symlinks_core () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"

  # 2020-03-01: Top-level file data ignore rules.
  /bin/ln -s \
    "${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.projlns/depoxy-deeplinks/_ignore" \
    ".ignore"

  link_deep "${HOMEFRIES_DIR:-${HOME}/.homefries}"

  link_deep "${HOME}/.vim"
  # Note that ~/.vim/.ignore skips ~/.vim/pack, so that search
  # doesn't include third-party plugs.
  # - As such, we cannot simply call:
  #     link_deep "${HOME}/.vim/pack/landonb"
  #   because ${DEPOXY_PROJLNS_DEPOXY}/home/user/.vim -> ~/.vim,
  #   meaning ${DEPOXY_PROJLNS_DEPOXY}/home/user/.vim/pack/landonb is
  #   actual ~/.vim/pack/landonb. So specify a different target path.
  # - Note that deep_link sub's "${HOME}" for user-agnostic "/home/user",
  #   so that ~/.projlns/depoxy-deeplinks/.ignore doesn't have to be
  #   customized with the active user name (nor have to care if macOS
  #   /Users/<user> or Linux /home/<user>).
  link_deep "${HOME}/.vim/pack/landonb" "home/user/_vim/pack/landonb"

  link_deep "${DEPOXYAMBERS_DIR:-${ambers_path}}"

  if [ -d "${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/stints" ]; then
    link_deep "${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/stints"
  fi

  # *** ~/.kit/ Dopp Kit Git scaffolding.

  # 2020-12-16: Unnecessary: There's a symlink at:
  #   ${DEPOXY_PROJLNS_DEPOXY}/depoxy-ambers -> ~/.depoxy/ambers
  #
  #  link_deep "${DEPOXYAMBERS_DIR:-${ambers_path}}}/home/.kit/.gitignore"
  #  link_deep "${DEPOXYAMBERS_DIR:-${ambers_path}}}/home/.kit/README.md"

  # *** ~/.kit/sh aka shoilerplate projects

  # **** ~/.kit/sh library projects

  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-ask-yesnoskip"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-print-nanos-now"

  # **** ~/.kit/sh feature projects

  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/dot-inputrc"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/feature-coverage-report"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/fries-findup"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/gvim-open-kindness"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe"
  link_deep "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-sensible-open"

  # *** ~/.kit/git projects

  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/git-bump-version-tag"
  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/git-my-merge-status"
  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/git-put-wise"
  link_deep "${GITSMARTPATH:-${GITREPOSPATH:-${HOME}/.kit/git}/git-smart}"
  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/git-update-faithful"
  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/git-veggie-patch"
  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/tig-newtons"
  #
  # **** (oh)myrepos
  #
  # 2023-10-26/2020-02-13/2019-10-23: Not my project, but also never seen hit on #9 grep.
  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos"
  link_deep "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command"
  link_deep "${OHMYREPOS_DIR:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos}"

  # *** ~/.kit/js projects

  link_deep "${DOPP_KIT:-${HOME}/.kit}/js/pampermonkey"

  # *** ~/.kit/mOS projects

  link_deep "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/Karabiner-Elephants"
  link_deep "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-onboarder"

  # *** ~/.kit/txt projects

  link_deep "${DOPP_KIT:-${HOME}/.kit}/txt/emoji-lookup"
  link_deep "${DOPP_KIT:-${HOME}/.kit}/txt/spellfile.txt"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

infuse_projects_links_docs () {
  populate_links_directory \
    "${DEPOXY_PROJLNS_USRDOC}" \
    "infuse_create_symlinks_docs"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_create_symlinks_docs () {
  # E.g., ~/.depoxy/stints
  local clients_path="$(_vendorfs_path_stints_basedir_print)"

  if [ ! -d "${clients_path}" ]; then
    return
  fi

  find "${clients_path}" -mindepth 1 -maxdepth 1 -type d \
    | while read subdir_path; \
  do
    local subdir_name="$(basename "${subdir_path}")"

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

infuse_create_symlinks_core_sh_lib () {
  find ${SHOILERPLATE:-${HOME}/.kit/sh}/sh-*/bin/ -type f -exec ln -s {} \;
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  set -e

  source_deps

  infuse_projects_links_core
  infuse_projects_links_docs
  infuse_projects_links_sh_lib
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Only run when executed; no-op when sourced.
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi

