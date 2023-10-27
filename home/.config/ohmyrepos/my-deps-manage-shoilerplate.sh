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
# e.g., it'll call both:
#   mr -d . -n updateDeps
#   mr -d . -n infusePostRebase
# This is useful because update-faithful breaks hard-links,
# but it doesn't remake them.

update_deps_shoilerplate () {
  update_deps_git_update_faithful () {
    [ -d "deps/git-update-faithful" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-update-faithful"

    update_faithful_file \
      "deps/git-update-faithful/lib/update-faithful.sh" \
      "lib/update-faithful.sh"

    update_faithful_finish
  }

  update_deps_sh_colors () {
    [ -d "deps/sh-colors" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors"

    update_faithful_file \
      "deps/sh-colors/bin/colors.sh" \
      "bin/colors.sh"

    update_faithful_finish
  }

  update_deps_sh_logger_and_colors () {
    [ -d "deps/sh-logger/deps/sh-colors" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger"

    update_faithful_file \
      "deps/sh-logger/deps/sh-colors/bin/colors.sh" \
      "deps/sh-colors/bin/colors.sh"

    # Chain another update-deps, which will `update_faithful_finish`.
    update_deps_sh_logger
  }

  update_deps_sh_logger () {
    [ -d "deps/sh-logger" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger"

    update_faithful_file \
      "deps/sh-logger/bin/logger.sh" \
      "bin/logger.sh"

    update_faithful_finish
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

    update_faithful_finish
  }

  update_deps_sh_print_nanos_now () {
    [ -d "deps/sh-print-nanos-now" ] || return 0

    export UPDEPS_CANON_BASE_ABSOLUTE="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-print-nanos-now"

    update_faithful_file \
      "deps/sh-print-nanos-now/bin/print-nanos-now.sh" \
      "bin/print-nanos-now.sh"

    update_faithful_finish
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

    update_faithful_finish
  }

  update_deps_git_update_faithful
  update_deps_sh_colors
  update_deps_sh_logger_and_colors
  update_deps_sh_logger
  update_deps_sh_pather
  update_deps_sh_print_nanos_now
  update_deps_sh_rm_safe
}

# ========================================================================
# ------------------------------------------------------------------------

link_hard_dep_git_update_faithful () {
  link_hard "${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-update-faithful/lib/update-faithful.sh" \
    "deps/git-update-faithful/lib/update-faithful.sh"
}

link_hard_dep_sh_colors () {
  link_hard "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors/bin/colors.sh" \
    "deps/sh-colors/bin/colors.sh"
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

