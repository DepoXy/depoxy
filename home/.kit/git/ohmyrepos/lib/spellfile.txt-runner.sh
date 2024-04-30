#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# CXREF: https://github.com/DepoXy/spellfile.txt#🧙
#
#   ~/.kit/txt/spellfile.txt/bin/spells.sh
#
#   ~/.depoxy/ambers/bin/spells.sh

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Sort the spell file, for easy diff'ing, or merging/meld'ing.
# - Your .vimrc code should remake the .spl file when you restart Vim.
commit_sorted_spells_and_alert_if_conflicts () {
  local active_spell="home/.vim/spell/en.utf-8.add"

  # If user standing up a new DXC, or if ~/.vim/spell/en.utf-8.add
  # not linked back to this project, the spell file might be absent.
  if [ ! -f "${active_spell}" ]; then
    touch -- "${active_spell}"
  fi

  sort_file_then_commit "${active_spell}"

  # E.g., ~/.depoxy/ambers/home, or ~/.depoxy/running/home
  local homeish_path="${MR_REPO}/home"

  # Assumes ~/.depoxy/ambers/bin/spells.sh on PATH. Should be.
  local compiled_spells
  compiled_spells="$(spells.sh compile-spells "${homeish_path}")"

  debug "$(fg_mintgreen)$(attr_emphasis)cast spellfile$(attr_reset)" \
    "$(fg_lightblue)${compiled_spells}$(attr_reset)"

  # If Vim's spell file is empty, assume user is standing up a new
  # Vim install. The compiled file was made from existing sources,
  # so there are no new words to commit. We can copy the compiled
  # file to the active file, and commit it.
  if [ ! -s "${active_spell}" ]; then
    command cp -- "${compiled_spells}" "${active_spell}"

    git_auto_commit_one "${active_spell}"
  fi

  local n_lines_diff=0
  n_lines_diff="$(spells.sh print-num-unsynced-changes "${homeish_path}")"

  if [ "${n_lines_diff}" -gt 0 ]; then
    warn "Spell Work: There are ${n_lines_diff} spell changes to process"
    warn "- HINT: See previous log message, and check for sync helpers:"
    warn "    \$ ls -la $(dirname -- "${compiled_spells}")/sync-spells--*"

    ls -la $(dirname -- "${compiled_spells}")/sync-spells--*
  fi
}

