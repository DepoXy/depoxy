#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:spell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

DEPOXY_PROJLNS="${DEPOXY_PROJLNS:-${HOME}/.projlns}"

DEPOXY_PROJLNS_DEPOXY="${DEPOXY_PROJLNS_DEPOXY:-${DEPOXY_PROJLNS}/depoxy-deeplinks}"

DEPOXY_PROJLNS_USRDOC="${DEPOXY_PROJLNS_USRDOC:-${DEPOXY_PROJLNS}/docs-and-backlog}"

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
  /bin/ln -s "${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.projlns/depoxy-deeplinks/.ignore"

  /bin/ln -s "${HOMEFRIES_DIR:-${HOME}/.homefries}"
  /bin/ln -s "${HOME}/.vim"
  /bin/ln -s "${HOME}/.vim/pack/landonb" ".vim-pack-landonb"

  /bin/ln -s "${DEPOXYAMBERS_DIR:-${ambers_path}}" ".depoxy-ambers"

  if [ -d "${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/stints" ]; then
    /bin/ln -s "${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/stints" ".depoxy-stints"
  fi

  # *** ~/.kit/ Dopp Kit Git scaffolding.

  # 2020-12-16: Unnecessary: There's a symlink at:
  #   ${DEPOXY_PROJLNS_DEPOXY}/depoxy-ambers -> ~/.depoxy/ambers
  #
  #  /bin/ln -s "${DEPOXYAMBERS_DIR:-${ambers_path}}}/home/.kit/.gitignore" \
  #              "kit-.gitignore-dxy"
  #  /bin/ln -s "${DEPOXYAMBERS_DIR:-${ambers_path}}}/home/.kit/README.md" \
  #              "kit-README.md"

  # *** ~/.kit/[sh]oilerplate library projects

  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-ask-yesnoskip"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-print-nanos-now"

  # *** ~/.kit/[sh]oilerplate feature projects

  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/dot-inputrc"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/feature-coverage-report"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/fries-findup"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/gvim-open-kindness"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe"
  /bin/ln -s "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-sensible-open"

  # Make one directory of symlinks to all sh-* project binaries.
  # This is for showing in the Vim project tray (.vimprojects),
  # so we can show a short list of all shell scripts, and not
  # have to use multiple directory listings.
  populate_links_directory "sh-lib" "infuse_create_symlinks_core_sh_lib"

  # *** ~/.kit/git projects

  /bin/ln -s "${GITSMARTPATH:-${GITREPOSPATH:-${HOME}/.kit/git}/git-smart}"

  /bin/ln -s "${GITREPOSPATH:-${HOME}/.kit/git}/git-bump-version-tag"
  /bin/ln -s "${GITREPOSPATH:-${HOME}/.kit/git}/git-my-merge-status"
  /bin/ln -s "${GITREPOSPATH:-${HOME}/.kit/git}/git-put-wise"
  /bin/ln -s "${GITREPOSPATH:-${HOME}/.kit/git}/git-veggie-patch"
  /bin/ln -s "${GITREPOSPATH:-${HOME}/.kit/git}/tig-newtons"

  # *** (oh)myrepos

  # MAYBE/2019-10-23: Remove this link?
  # - 2020-02-13: Or do I like it? It hardly has gotten in the way, never see its hits!
  /bin/ln -s "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos"

  /bin/ln -s "${OHMYREPOS_DIR:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos}" 'ohmyrepos'

  /bin/ln -s "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command"

  # *** ~/.kit/js projects

  /bin/ln -s "${DOPP_KIT:-${HOME}/.kit}/js/pampermonkey"

  # *** ~/.kit/mOS projects

  /bin/ln -s "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/Karabiner-Elephants"
  /bin/ln -s "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-onboarder"

  # *** ~/.kit/txt projects

  /bin/ln -s "${DOPP_KIT:-${HOME}/.kit}/txt/emoji-lookup"
  /bin/ln -s "${DOPP_KIT:-${HOME}/.kit}/txt/spellfile.txt"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_create_symlinks_core_sh_lib () {
  find ${SHOILERPLATE:-${HOME}/.kit/sh}/sh-*/bin/ -type f -exec ln -s {} \;
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
      /bin/ln -s "${subdir_path}/docs" "client-${subdir_name}-docs"
    fi
    if [ -d "${subdir_path}/notes" ]; then
      /bin/ln -s "${subdir_path}/notes" "client-${subdir_name}-notes"
    fi
  done
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  set -e

  source_deps

  infuse_projects_links_core
  infuse_projects_links_docs
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Only run when executed; no-op when sourced.
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi

