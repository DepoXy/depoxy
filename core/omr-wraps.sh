#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=sh
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# An OMR autocommit wrapper that prompts if you're running this over SSH.
#
# My use case: Oftentimes when I run `aci`, I've been writing notes in Vim,
# and I quickly alt-tab and then blindly type `aci<CR>` and alt-tab back
# (so that I create a commit of my recent note edits). But sometimes that
# alt-tab brings me to a terminal that's SSH'ed to the remote host that I
# backup on -- and where I normally run `ff` to use OMR to pull changes
# from my main development machine. But if I run `aci`, some operations,
# like exporting Bookmarks, or writing a `tree`, will create commits on
# the backup machine that don't exist on the main development machine,
# and then the next time I try `ff`, I end up having to resolve conflicts.
#
# tl;dr: Use case: Sometimes I accidentally run ``aci`` when I mean to
#        run ``ff`` on @backup machine, and then I have to undo, e.g.,
#        the updates to the dconf dump in the Zoidy Pooh repo.

# 2021-05-15: Until today, the `aci` was a simple alias:
#
#  # Auto commit. Things like notes files, Vim spell file, .vimprojects, etc.
#  claim_alias_or_warn "aci" "mr -d / autocommit -y"

# Note: I'm not aware if it matters if we use SSH_CLIENT or SSH_TTY,
# e.g., from within a remote session, one might see:
#
#  $ echo ${SSH_CLIENT}
#  192.168.11.113 60138 26922
#
#  $ echo ${SSH_TTY}
#  /dev/pts/3
#
# whereas when run from a local terminal, neither of those environs are set.

aci () {
  local proj_path="${1:-/}"

  # ***

  local the_choice

  if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_TTY}" ]; then
    echo "This is an SSH connection. Really run autocommit on @$(hostname)?"
    # CXREF: ~/.homefries/lib/ask_yes_no_default.sh
    ask_yes_no_default 'n'
  else
    the_choice='Y'
  fi

  if [ ${the_choice} != 'Y' ]; then
    return 1
  fi

  # ***

  local no_recurse=""
  if [ "${proj_path}" != "/" ]; then
    no_recurse="-n"
  fi

  mr -d "${proj_path}" ${no_recurse} autocommit -y "$@"
}

# ***

# Local directory `aci.` and `infuse.`.
_dxy_aliases_wire_omr_wraps () {
  claim_alias_or_warn "aci." "mr -d . -n autocommit -y"
  # CALSO: `infuse .` works similarly.
  claim_alias_or_warn "infuse." "mr -d . -n infuse"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

function omr-is-registered () {
  (
    # CXREF: ~/.ohmyrepos/bin/omr-report
    . "${OHMYREPOS_DIR:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/ohmyrepos}/bin/omr-report"

    OMR_VERBOSE=true omr_is_registered "$@"
  )  
}

function omr-report () {
  (
    # CXREF: ~/.ohmyrepos/bin/omr-report
    . "${OHMYREPOS_DIR:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/ohmyrepos}/bin/omr-report"

    omr_report \
      "${HOME}" \
      "/TBD-*" -prune \
      "/*-TBD" -prune \
      "${HOME}/.downloads" -prune \
      "${HOME}/.gopath" -prune \
      "${HOME}/.trash*" -prune \
  )  
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_unset_f_omr_wraps () {
  unset -f main
  unset -f _dxy_aliases_wire_omr_wraps
  # So meta.
  unset -f _dxy_unset_f_omr_wraps
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_aliases_wire_omr_wraps

  _dxy_unset_f_omr_wraps
}

main "$@"

