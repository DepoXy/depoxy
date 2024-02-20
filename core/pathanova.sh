# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps_pather () {
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

  # Add bin/client-bin/ after DXY/bin, so DepoXy Client has last
  # say and can overrule any command.
  # - Note there's also `_vendorfs_host_is_depoxy_client_id`,
  #   but that reports an error, and prints the DepoXy Client ID.
  # MAYBE: We could make a similar check in depoxy_fs.sh that
  #        returns true or false; then remove DEPOXY_IS_CLIENT.
  [ "${DEPOXY_IS_CLIENT}" = 'true' ] &&
    path_prefix "${DEPOXYAMBERS_DIR:-${ambers_path}}/bin/client-bin"
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

user_path_add_git_veggie_patch () {
  path_prefix "${GITREPOSPATH:-${HOME}/.kit/git}/git-veggie-patch/bin"
}

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
# - Ensure other commands that use these libraries also use `link_hard`
#   so that all the different projects' same dependencies are the same
#   filesystem file (refer to the same inode).
#
user_path_add_sh_bins () {
  #  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-ask-yesnoskip/bin"
  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors/bin"
  #  path_prefix "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs/bin"
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

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_path_condense_colons () {
  # Completely unnecessary: Condense consecutive colons. But looks nice.
  PATH="$(echo $PATH | /usr/bin/env sed -E 's/:+/:/g')"
  export PATH
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Adds executable commands' directories to PATH.
user_path_extend () {

  # *** Load PATH prefix and suffix functions.

  source_deps_pather
  unset -f source_deps_pather

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
  user_path_add_git_veggie_patch
  unset -f user_path_add_git_veggie_patch
  #
  user_path_add_tj_git_extras
  unset -f user_path_add_tj_git_extras

  user_path_add_omr_lib
  unset -f user_path_add_omr_lib

  user_path_add_sh_bins
  unset -f user_path_add_sh_bins

  # *** Cleanup PATH: Remove repetitious colons.

  _depoxy_path_condense_colons
  # Let caller unset this, in case they want to use it again:
  #  unset -f _depoxy_path_condense_colons
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  user_path_extend
  unset -f user_path_extend
}

main "$@"
unset -f main

