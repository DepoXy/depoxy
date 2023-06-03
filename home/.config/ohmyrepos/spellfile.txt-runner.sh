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

  sort_file_then_commit "${active_spell}"

  # E.g., ~/.depoxy/ambers/home, or ~/.depoxy/running/home
  local homeish_path="${MR_REPO}/home"

  # Assumes ~/.depoxy/ambers/bin/spells.sh on PATH. Should be.
  local compiled_spells
  compiled_spells="$(spells.sh compile-spells "${homeish_path}")"

  debug "$(fg_mintgreen)$(attr_emphasis)cast spellfile$(attr_reset)" \
    "$(fg_lightblue)${compiled_spells}$(attr_reset)"

  local n_lines_diff=0
  n_lines_diff="$(spells.sh print-num-unsynced-changes "${homeish_path}")"

  if [ "${n_lines_diff}" -gt 0 ]; then
    warn "Spell Work: There are ${n_lines_diff} spell changes to process"
    warn "- HINT: See previous log message, and check for sync helpers:"
    warn "    \$ ls -la $(dirname -- "${compiled_spells}")/sync-spells--*"

    ls -la $(dirname -- "${compiled_spells}")/sync-spells--*
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

