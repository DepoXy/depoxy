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
  shift || true

  # ***

  local the_choice

  if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_TTY}" ]; then
    echo "This is an SSH connection. Really run autocommit on @$(hostname)?"
    # CXREF: ~/.kit/sh/home-fries/lib/ask_yes_no_default.sh
    ask_yes_no_default 'n'
  else
    the_choice='Y'
  fi

  if [ ${the_choice} != 'Y' ]; then
    return 1
  fi

  # ***

  # Because -n[o-recurse], fails if run from project subdirectory.
  # - This check useful to ensure command is being run on the intended
  #   repo (i.e., without user verifying MR_REPO themselves).
  # - But autocommit command is harmless, so allow running from subdir.
  #   - Note if run from a project that's not registered with OMR, runs
  #     on parent project that is.
  # SAVVY/2024-08-09: There's an issue running `mr -d` without `-n`
  # from subdir: it identifies the project (MR_REPO) as the grand-parent
  # project. So cd to root (and still use `-n`).

  if [ "${proj_path}" = "/" ]; then
    mr -d / autocommit -y "$@"
  else
    local no_recurse="-n"

    (
      cd "$(git root)"

      mr -d "${proj_path}" ${no_recurse} autocommit -y "$@"
    )
  fi
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
    # CXREF: ~/.kit/git/ohmyrepos/bin/omr-report
    . "${OHMYREPOS_DIR:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/ohmyrepos}/bin/omr-is-registered"

    OMR_VERBOSE=true omr_is_registered "$@"
  )  
}

function omr-report () {
  (
    # CXREF: ~/.kit/git/ohmyrepos/bin/omr-report
    . "${OHMYREPOS_DIR:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/ohmyrepos}/bin/omr-report"

    _omr_report_source_deps

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

# For comparison to a full omr-report, e.g.,
#
#   # From ~/.depoxy/ambers/bin/weekly-omr-report
#   OMR_VERBOSE=true \
#   OMR_FORMAT_CONCISE=true \
#     weekly_omr_report "$@"
#
# you can print the list of registered (unskipped and skipped)
# projects to compare against.
#
# - This is useful to audit the auditor, e.g., to make sure you aren't
#   missing any paths passed to `omr_report` (see `omr-report`, above).

function omr-list-projects () {
  # DUNNO: How does this echo out-of-band? I cannot pipe the output...
  # - I.e., the `mr` command immediately emits output if you run
  #     `mr -d / -f run sh -c '...' 2>&1 | sed ...`
  #   and doesn't capture the output to pipe to sed.
  # - Fortunately, normal output capture works, so we'll use an
  #   intermediate file.
  local tmpf="$(mktemp)"

  mr -d / -f run sh -c '
    pholder_type="registered"
    [ ${MR_SKIPPED:-0} -eq 0 ] || pholder_type="skipped"
    if [ ! -d "${MR_REPO}/.git" ]; then
      echo "${MR_REPO} (${pholder_type}/placeholder)"
    elif [ ${MR_SKIPPED:-0} -eq 0 ]; then
      echo "${MR_REPO} (registered)"
    else
      echo "${MR_REPO} (skipped)"
    fi
  ' > "${tmpf}" 2>&1

  # COPYD: ~/.kit/git/ohmyrepos/bin/weekly-omr-report
  local CACHE_CAPTURE_DIR="${HOME}/.local/share/weekly-omr-report"
  local CACHE_CAPTURE="${CACHE_CAPTURE_DIR}/omr-report-$(hostname)"

  # *** Print helped context

  echo "HSTRY/$(TTTtt): Generated by \`${FUNCNAME}\`"
  echo "- Hint: Compare against \`weekly-omr-report\`:"
  echo "  - Expect this file to have unique (absent) and (<>/placeholder) lines"
  echo "  - Expect the omr-report file to have unique (unregistered) lines"
  echo "  - If any other lines don't match or are unique, something's amiss"
  echo "  - CPYST:"
  echo "      # Compare a copy of this file:"
  echo "      meld \"${CACHE_CAPTURE}\" \"\${PATH_TO_THIS_FILE}\" &"
  echo "      # Or directly from fresh run:"
  echo "      meld \"${CACHE_CAPTURE}\" <(omr-list-projects) &"
  echo "      # Or from omr-report temp file, but note Linux meld won't open /tmp files, e.g.,"
  echo "      meld <(cat \"/tmp/weekly-omr-report-QUvJURp.out\") \"\${PATH_TO_THIS_FILE}\" &"
  echo "      meld <(cat \"/tmp/weekly-omr-report-QUvJURp.out\") <(omr-list-projects) &"
  echo

  # *** Print sorted results

  # Sort alphabetically by path.
  # - Also reformat "mr run: failed to chdir to <path>/: ..."
  # - Note that macOS `head` does not support `head -n -1`,
  #   but we can use `sed '$d'` to print all but the last line.

  sed '$d' "${tmpf}" \
    | sed 's/^mr run: failed to chdir to \(.*\)\/: No such file or directory$/\1 (absent)/' \
    | sort -k1,1 -t' '

  tail -n 1 "${tmpf}"

  command rm -- "${tmpf}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# BWARE: This could be confusing!: Handle `install .` specially.
# - Preempts /usr/bin/install
# - Note this doesn't actually break anything:
#
#     $ command install .
#     usage: install [-bCcpSsUv] [-f flags] [-g group] [-m mode] [-o owner]
#     ...

install () {
  if [ $# -eq 1 ] && [ "$1" = "." ]; then
    mr -d . -n install
  else
    command install "$@"
  fi
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

