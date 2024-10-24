# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_source_deps_pather () {
  # SAVVY: Homefries sources these (from its deps/):
  #   ~/.kit/sh/home-fries/.bashrc-bin/bashrc.core.sh

  # Source both path function scripts, so that, e.g., `path_prefix`
  # runs the function and not the script, because latter cannot
  # change current environment's PATH.
  . "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather/bin/path_prefix"
  . "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather/bin/path_suffix"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

user_path_add_home_local_node_modules_bin () {
  # Make Ansible Zoidy Pooh-installed Node/NPM executables available.
  path_prefix "${HOME}/.local/node_modules/.bin"
}

# ***

user_path_add_depoxyambers_bin () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  path_prefix "${DEPOXYAMBERS_DIR:-${ambers_path}}/bin"
}

# ***

user_path_add_git_smart () {
  # Prepend, so git-undo's is found before git-extras' /usr/bin/git-undo.
  path_prefix "${GITSMARTPATH:-${GITREPOSPATH:-${HOME}/.kit/git}/git-smart}/bin"
}

user_path_add_git_bump_version_tag () {
  path_prefix "${GITREPOSPATH:-${HOME}/.kit/git}/git-bump-version-tag/bin"
}

user_path_add_git_mr_merge_status () {
  path_prefix "${GITREPOSPATH:-${HOME}/.kit/git}/git-my-merge-status/bin"
}

user_path_add_git_rebase_tip () {
  path_prefix "${GITREPOSPATH:-${HOME}/.kit/git}/git-rebase-tip/bin"
}

user_path_add_git_veggie_patch () {
  path_prefix "${GITREPOSPATH:-${HOME}/.kit/git}/git-veggie-patch/bin"
}

# https://github.com/tj/git-extras
user_path_add_tj_git_extras () {
  # Append, so comes last and doesn't conflict with git-smart.
  path_suffix "${GITREPOSPATH:-${HOME}/.kit/git}/git-extras/bin"
}

# ***

user_path_add_omr_lib () {
  # This puts the `infuse` and `updateDeps` shortcuts on PATH.
  # - Both wrappers work similarly, e.g.,
  #   `updateDeps` same as `mr -d / updateDeps`, and
  #   `updateDeps .` same as `mr -d . -n updateDeps`.
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  path_prefix "${DEPOXYAMBERS_DIR:-${ambers_path}}/home/.kit/git/ohmyrepos/bin"
}

# ***

# FIXME/2022-10-11: Remove these PATH hacks, and this function.
# - Add OMR install commands for executables you want to call directly,
#   like sensible-open.

user_path_add_sh_bins () {
  #  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-ask-yesnoskip/bin"
  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors/bin"
  #  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-err-trap/lib"
  #  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs/lib"
  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger/bin"
  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather/bin"
  #  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-print-nanos-now/bin"
  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe/bin"
  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-sensible-open/bin"

  # These projects are installed via OMR install command (which
  # calls `make link` and creates symlinks under ~/.local/home).
  #   path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/feature-coverage-report/bin"
  #   path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/fries-findup/bin"
}

# ***

user_path_add_py_bins () {
  path_prefix "${DOPP_KIT:-${HOME}/.kit}/py/birdseye/bin"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_path_condense_colons () {
  # Completely unnecessary: Condense consecutive colons. But looks nice.
  PATH="$(echo $PATH | /usr/bin/env sed -E 's/:+/:/g')"
  export PATH
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Adds executable commands' directories to PATH.
user_path_extend () {

  # *** Update PATH environment variable.

  user_path_add_home_local_node_modules_bin
  unset -f user_path_add_home_local_node_modules_bin

  user_path_add_depoxyambers_bin
  unset -f user_path_add_depoxyambers_bin

  user_path_add_git_smart
  unset -f user_path_add_git_smart
  #
  user_path_add_git_bump_version_tag
  unset -f user_path_add_git_bump_version_tag
  #
  user_path_add_git_mr_merge_status
  unset -f user_path_add_git_mr_merge_status
  #
  user_path_add_git_rebase_tip
  unset -f user_path_add_git_rebase_tip
  #
  user_path_add_git_veggie_patch
  unset -f user_path_add_git_veggie_patch
  #
  user_path_add_tj_git_extras
  unset -f user_path_add_tj_git_extras

  user_path_add_omr_lib
  unset -f user_path_add_omr_lib

  user_path_add_sh_bins
  unset -f user_path_add_sh_bins

  user_path_add_py_bins
  unset -f user_path_add_py_bins

  # *** Cleanup PATH: Remove repetitious colons.

  _depoxy_path_condense_colons
  # Leave defined until _dxy_unset_functions_dxy so caller can use it.
  #   # unset -f _depoxy_path_condense_colons
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_path () {
  user_path_extend
  unset -f user_path_extend
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_source_deps_pather
}

if [ -n "${BASH_SOURCE}" ] && [ "$0" = "${BASH_SOURCE[0]}" ]; then
  # Being executed, so ensure (or refresh) deps.
  # - Otherwise when sourced, assume path_* cmds loaded.
  main "$@"
fi

_dxy_wire_path

unset -f main
unset -f _dxy_source_deps_pather
unset -f _dxy_wire_path

