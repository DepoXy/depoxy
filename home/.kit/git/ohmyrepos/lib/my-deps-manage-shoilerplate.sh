#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# ========================================================================
# ------------------------------------------------------------------------

# CXREF/2023-10-25:
#
#   ~/.kit/git/git-update-faithful/bin/render-faithful-file
#   ~/.kit/git/git-update-faithful/bin/update-faithful-begin
#   ~/.kit/git/git-update-faithful/bin/update-faithful-file
#   ~/.kit/git/git-update-faithful/bin/update-faithful-finish
#
#   ~/.kit/git/git-update-faithful/lib/update-faithful.sh

# ========================================================================
# ------------------------------------------------------------------------

# HINT: Run DXY's `updateDeps .` to run updateDeps then infusePostRebase,
#       e.g., it'll call both:
#         mr -d . -n updateDeps
#         mr -d . -n infusePostRebase
#       This is useful because update-faithful breaks hard-links,
#       but it doesn't remake them.
#
# NOTE: If you've added link_hard_dep_* calls to infusePostRebase
#       but haven't added the files to the repo yet, you either
#       need to call `updateDeps` *twice*, or you need to make
#       a call sandwich, e.g., 
#         mr -d . -n infusePostRebase
#         mr -d . -n updateDeps
#         mr -d . -n infusePostRebase
#       So that the first 'infusePostRebase' creates the deps/
#       hard links, the 'updateDeps' adds-commits them to the repo,
#       and the second 'infusePostRebase' re-creates the hard links.
#       - MAYBE: Perhaps `updateDeps` shell command can do the sandwich,
#         but I wonder if the infusePostRebase might fail where updateDeps
#         wouldn't (because updateDeps understands GPW scoped commits, but
#         OMR's hard_link only knows HEAD).

update_deps_shoilerplate () {
  local gitsmart_path="${GITSMARTPATH:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-smart}"

  update_faithful_finish_signed () {
    local sourcerer="https://github.com/DepoXy/depoxy/blob/release/home/.kit/git/ohmyrepos/lib/my-deps-manage-shoilerplate.sh"

    update_faithful_finish "${sourcerer}"
  }

  update_deps_git_smart_git_abort () {
    [ -f "deps/git-smart/bin/git-abort" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${gitsmart_path}"

    update_faithful_file \
      "deps/git-smart/bin/git-abort" \
      "bin/git-abort"

    update_faithful_finish_signed
  }

  update_deps_git_smart_git_fup () {
    [ -f "deps/git-smart/bin/git-fup" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${gitsmart_path}"

    update_faithful_file \
      "deps/git-smart/bin/git-fup" \
      "bin/git-fup"

    update_faithful_finish_signed
  }

  update_deps_git_update_faithful () {
    [ -d "deps/git-update-faithful" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-update-faithful"

    update_faithful_file \
      "deps/git-update-faithful/lib/update-faithful.sh" \
      "lib/update-faithful.sh"

    update_faithful_finish_signed
  }

  update_deps_sh_ask_yesnoskip () {
    [ -d "deps/sh-ask-yesnoskip" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-ask-yesnoskip"

    update_faithful_file \
      "deps/sh-ask-yesnoskip/bin/ask-yesnoskip.sh" \
      "bin/ask-yesnoskip.sh"

    update_faithful_finish_signed
  }

  update_deps_sh_colors () {
    [ -d "deps/sh-colors" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors"

    update_faithful_file \
      "deps/sh-colors/bin/colors.sh" \
      "bin/colors.sh"

    update_faithful_finish_signed
  }

  update_deps_sh_git_nubs () {
    [ -d "deps/sh-git-nubs" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs"

    update_faithful_file \
      "deps/sh-git-nubs/lib/git-nubs.sh" \
      "lib/git-nubs.sh"

    update_faithful_finish_signed
  }

  update_deps_sh_logger_and_colors () {
    [ -d "deps/sh-logger/deps/sh-colors" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger"

    update_faithful_file \
      "deps/sh-logger/deps/sh-colors/bin/colors.sh" \
      "deps/sh-colors/bin/colors.sh"

    # Chain the next update_deps, and let it call `update_faithful_finish_signed`.
    update_deps_sh_logger
  }

  update_deps_sh_logger () {
    [ -d "deps/sh-logger" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger"

    update_faithful_file \
      "deps/sh-logger/bin/logger.sh" \
      "bin/logger.sh"

    update_faithful_finish_signed
  }

  update_deps_sh_pather () {
    [ -d "deps/sh-pather" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather"

    update_faithful_file \
      "deps/sh-pather/bin/pather.sh" \
      "bin/pather.sh"
    update_faithful_file \
      "deps/sh-pather/bin/path_prefix" \
      "bin/path_prefix"
    update_faithful_file \
      "deps/sh-pather/bin/path_suffix" \
      "bin/path_suffix"

    update_faithful_finish_signed
  }

  update_deps_sh_print_nanos_now () {
    [ -d "deps/sh-print-nanos-now" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-print-nanos-now"

    update_faithful_file \
      "deps/sh-print-nanos-now/bin/print-nanos-now.sh" \
      "bin/print-nanos-now.sh"

    update_faithful_finish_signed
  }

  update_deps_sh_rm_safe () {
    [ -d "deps/sh-rm_safe" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe"

    update_faithful_file \
      "deps/sh-rm_safe/bin/path_device" \
      "bin/path_device"
    update_faithful_file \
      "deps/sh-rm_safe/bin/rmrm" \
      "bin/rmrm"
    update_faithful_file \
      "deps/sh-rm_safe/bin/rm_rotate" \
      "bin/rm_rotate"
    update_faithful_file \
      "deps/sh-rm_safe/bin/rm_safe" \
      "bin/rm_safe"

    update_faithful_finish_signed
  }

  # Ensure symlinks exist.
  mr -d . -n infusePostRebase

  update_deps_git_smart_git_abort
  update_deps_git_smart_git_fup
  update_deps_git_update_faithful
  update_deps_sh_ask_yesnoskip
  update_deps_sh_colors
  update_deps_sh_git_nubs
  update_deps_sh_logger_and_colors
  update_deps_sh_logger
  update_deps_sh_pather
  update_deps_sh_print_nanos_now
  update_deps_sh_rm_safe
}

# ========================================================================
# ------------------------------------------------------------------------

link_hard_dep_git_smart_git_abort () {
  link_hard "${GITSMARTPATH:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-smart}/bin/git-abort" \
    "deps/git-smart/bin/git-abort"
}

link_hard_dep_git_smart_git_fup () {
  link_hard "${GITSMARTPATH:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-smart}/bin/git-fup" \
    "deps/git-smart/bin/git-fup"
}

link_hard_dep_git_update_faithful () {
  link_hard "${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-update-faithful/lib/update-faithful.sh" \
    "deps/git-update-faithful/lib/update-faithful.sh"
}

link_hard_dep_sh_ask_yesnoskip () {
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-ask-yesnoskip/bin/ask-yesnoskip.sh" \
    "deps/sh-ask-yesnoskip/bin/ask-yesnoskip.sh"
}

link_hard_dep_sh_colors () {
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors/bin/colors.sh" \
    "deps/sh-colors/bin/colors.sh"
}

link_hard_dep_sh_git_nubs () {
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs/lib/git-nubs.sh" \
    "deps/sh-git-nubs/lib/git-nubs.sh"
}

link_hard_dep_sh_logger () {
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger/bin/logger.sh" \
    "deps/sh-logger/bin/logger.sh"
}

link_hard_dep_sh_logger_and_colors () {
  link_hard_dep_sh_logger
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger/deps/sh-colors/bin/colors.sh" \
    "deps/sh-logger/deps/sh-colors/bin/colors.sh"
}

link_hard_dep_sh_pather () {
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather/bin/pather.sh" \
    "deps/sh-pather/bin/pather.sh"
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather/bin/path_prefix" \
    "deps/sh-pather/bin/path_prefix"
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather/bin/path_suffix" \
    "deps/sh-pather/bin/path_suffix"
}

link_hard_dep_sh_print_nanos_now () {
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-print-nanos-now/bin/print-nanos-now.sh" \
    "deps/sh-print-nanos-now/bin/print-nanos-now.sh"
}

link_hard_dep_sh_rm_safe () {
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe/bin/path_device" \
    "deps/sh-rm_safe/bin/path_device"
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe/bin/rmrm" \
    "deps/sh-rm_safe/bin/rmrm"
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe/bin/rm_rotate" \
    "deps/sh-rm_safe/bin/rm_rotate"
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe/bin/rm_safe" \
    "deps/sh-rm_safe/bin/rm_safe"
}

# ========================================================================
# ------------------------------------------------------------------------

