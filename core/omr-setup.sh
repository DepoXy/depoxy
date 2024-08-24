# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Assign sf-* and st-* aliases:
# - sf-client sf-work sf-home sf-user sf-vim sf-sh sf-git sf-kit
# - st-client st-work st-home st-user st-vim st-sh st-git st-kit
_dxy_wire_aliases_omr_status () {
  # NOTE: "sf-*" are fancy status mappings.
  # HINT: "st-" is unique prefix, type `st-<TAB>` to list options.
  for omr_group in "client" "work" "home" "user" "vim" "sh" "git" "kit"; do
    claim_alias_or_warn "sf-${omr_group}" "MR_INCLUDE=${omr_group} OMR_MYSTATUS_FANCY=true mr -d / mystatus"
    claim_alias_or_warn "st-${omr_group}" "MR_INCLUDE=${omr_group} OMR_MYSTATUS_FANCY=false mr -d / mystatus"
  done
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_omr_status_snip_cd () {
  # MAYBE/2020-02-14: Relocate to ~/.kit/sh/home-fries/lib/alias/alias_???.sh
  #   Near `alias dff`, in the *** Git section.
  #
  # 2020-02-13: gs is Ghostscript interpreter and previewer, which I never use.
  # - `git status` totally seems like an obvious thing to make more accessible,
  #   and definitely to customize, especially for my workflow (e.g., take into
  #   account branch and remote usage and naming conventions).
  # - You'll find this git command in git-smart:
  #     https://github.com/landonb/git-smart#💡
  # - Reasoning to not go with builtin status?
  #   - git status is rather verbose, feels like a newbie message,
  #     ``(use "git add" ...)`` it implores, etc. (Though also confuses
  #     newbies, because says something about being behind, which might
  #     not be obvious to green users.
  # - git status -s/--short is nice and concise, but I miss seeing the
  #   branch name. And once I started to write a little git function to
  #   show the branch name atop a short status, I realized that, with a
  #   little more effort, I could make a real bad ass status wrapper.
  # 2020-02-17: Some names I tossed around:
  #    claim_alias_or_warn "gs" "git-status-report"  # was named this for a few days, very begs.
  #    claim_alias_or_warn "gs" "git-mighty-status"  # never named it this.
  #    claim_alias_or_warn "gs" "git-shorty"         # for like, a split second; never named it this.
  #    claim_alias_or_warn "gs" "git-synopsis"       # named this for handful of days... until I
  #                                                  #   went looking for a more meaningful name.
  command -v git-my-merge-status > /dev/null || return 0
  #  local rem_origin="origin 👍 👆"
  #  local rem_travel="travel 💾 💾"
  #  local rem_cntrpt="$([[ $(hostname) == 'thea' ]] && echo lethe || echo thea) 💻 💻"
  # MAYBE/2020-02-15: travel and counterpart remotes not useful
  #                   to check because I rarely pull, so running merge-base
  #                   not gonna tell much, other than that remote will probably
  #                   always look behind.
  #  alias gs="git-my-merge-status ${rem_origin} ${rem_travel} ${rem_cntrpt}"
  # Just default to what the script dictates:
  #   GITSMART_MYST_DEFAULT_REMOTES_ICONS="origin 👍 👆 upstream 🌩 ⚡"

  # 2020-03-14: I dunno, I use `stt` way more than `gs`!
  #  alias gs="git-my-merge-status"

  export OMR_CPYST_CD='cdd'
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_aliases_omr_status
  unset -f _dxy_wire_aliases_omr_status

  _dxy_wire_omr_status_snip_cd
  unset -f _dxy_wire_omr_status_snip_cd
}

main "$@"
unset -f main

