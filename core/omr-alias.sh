# vim:tw=0:ts=2:sw=2:et:norl:ft=sh
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

home_fries_aliases_wire_git () {
  # See also functions below: `sf`, `sff`, `st`, `stt`.

  # 2022-11-11: I use `g` occassionally (added 2020-03-25, but only
  # recently rediscovering), but I'd forgot about `gb` and `gr`.
  # MAYBE: Remove `gb` and `gr`.
  # - 2023-01-13: Yeah, if you're okay with verbosity of the `g` command,
  #   just use `g`, and you won't need `git br` or `git r` again...
  #
  #  claim_alias_or_warn "gb" "git br"
  #  claim_alias_or_warn "gr" "git r"

  # 2022-11-14: Life used to be so simple back then:
  #   claim_alias_or_warn "g" "git r && git br && sf"
  claim_alias_or_warn "g" "_hf_git_print_summary_g"
}

_hf_git_print_summary_g () {
  sf

  # The '*' marking current branch is redundant: it's also a different color.
  git_brs_no_star_and_indented () {
    local new_indent="${1:-    }"

    git branch --color=always | sed "s/^../${new_indent}/"
  }

  # git-re aka `git r`.
  git_remotes_indented () {
    local new_indent="$1"

    git-re | sed "s/^/${new_indent}/"
  }

  git_latest_commit_message () {
    git --no-pager log --format=%s -1 HEAD
  }

  printf "🔀" &&
    git_brs_no_star_and_indented " " | head -1
  git_brs_no_star_and_indented "   " | tail +2

  printf "📠 " && git_remotes_indented "" | head -1
  git_remotes_indented "   " | tail +2

  printf "👆 " && _hf_git_tracking_branch

  printf "🗣  " && git_latest_commit_message
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# The `stt` and `stf` commands show a one-line report for all your repos
# that indicates if each repo is tidy, or has work to be done.
# - The `stt` variant runs quicker but shows only tidiness.
# - The `stf` variant runs about 5-10x slower but shows remote chores.
#
# You can specify myrepos groups (defined with the mr_exclusive command)
# by appending the group name to any of the commands, e.g., `st foo`.
#
# Note that we really need to use the root directory `/` to report on all
# projects because `mr` excludes any projects not under the -d path,
# regardless of being referenced from a .mrconfig file or not.
# - E.g., if ~/.mrconfig references a path outside user home, such as:
#     $ head -n 2 ~/.mrconfig
#     [/foo/bar]
#   then running `mr` command on user home will exclude that project, e.g.,
#     $ mr -d / ls
#   shows the project, but this would not show the project:
#     $ mr -d ~ ls
#   - Well, not unless /foo/bar was really a symlink to a directory under ${HOME}!
#
# And, yup, two of these are straight-up two-character commands, `st` and `sf`.
# - I use them all the time!

# The `stf` command (alias) shows a fancier, more information-dense one-line
# report for all your repos, indicating not only if each project is tidy or
# not, but what sort of remote branch work might also need to be done. Note
# the fancy report takes 5-10 times as long as a plain, is-it-tidy-or-not
# report.
# - Anecdotally, for the author's 265 repos: plain, non-fancy just ran in
#   ~12 secs, while a fancy report ran in ~78 secs, 6.5 times longer.
# So here's that report as its own cmd, like `st`, but with a little `f`ancy.
#
# `sf` alone shows just local repo's fancy report;
# `sff` alone shows all project fancy report one-liners;
# `sf <>` or `sff <>` shows fancy report on group <>.
sf () {
  [ -n "$1" ] && OMR_MYSTATUS_FANCY=true stt "$@" || git my-merge-status
}

sff () {
  OMR_MYSTATUS_FANCY=true stt "$@"
}

# `st` alone shows just local repo's fancy report;
# `stt` alone shows all repos quick tidiness report;
# `st <>` or `stt <>` shows quick tidiness report on group <>.
st () {
  [ -n "$1" ] && OMR_MYSTATUS_FANCY=false stt "$@" || git my-merge-status
}

# Use `stt` to print the fancy report one-liner for the current repo,
# followed by the porcelain status.
# - Note, if you use github.com/landonb/git-smart, these 3 commands are the same:
#   $ stt                  # github.com:landonb/home-fries
#   $ git st               # github.com:landonb/git-my-merge-status/.gitconfig.example
#   $ git my-merge-status  # github.com:landonb/git-my-merge-status/bin/git-my-serve-status
# - There's also a `git stt` alias (from git-my-merge-status) which (despite
#   its name) is not exactly like this `stt` alias. It shows a column-aligned
#   fancy status like the `st` and `sf` reports show (where the spacing might
#   look a little weird for a single line, when not appearing alongside others).
stt () {
  local exclusive_or_path="$1"

  local exclusive=""
  local proj_path="/"

  if [ -d "${exclusive_or_path}" ]; then
    local proj_path="${exclusive_or_path}"
  elif [ -n "${exclusive_or_path}" ]; then
    exclusive="MR_INCLUDE=${exclusive_or_path}"
  fi

  local no_recurse=""
  if [ "${proj_path}" != "/" ]; then
    no_recurse="-n"
  fi

  local jobs="-j 10"

  eval " \
    SHCOLORS_OFF=false \
    ${exclusive} \
    OMR_MYSTATUS_FANCY=${OMR_MYSTATUS_FANCY:-false} \
    mr -d "${proj_path}" ${no_recurse} ${jobs} mystatus
  "

  true
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

unset_f_alias_ohmyrepos () {
  unset -f main
  unset -f home_fries_aliases_wire_git
  # So meta.
  unset -f unset_f_alias_ohmyrepos
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  home_fries_aliases_wire_git

  unset_f_alias_ohmyrepos
}

main "$@"
unset -f main

