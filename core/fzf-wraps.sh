# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2025 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# FZF Pipeline commands that make it easy to
# pick a path to copy to the clipboard, or to
# open.
#
# - These commands are named according to a
#   simple convention, generally XXp and XXo.
#
#   - The XX is a shared prefix, oftentimes
#     itself a simple version of the command
#     that doesn't pipe to FZF. (E.g., XX
#     might be the base `fd` command.)
#
#   - The XXp commands copy the result to the
#     clipboard.          ↓        ↓
#     - Think "p" as in copy or clip.
#
#   - The XXo commands open the result (using
#     the `fs` command, so assumes result is
#     a file path you want opened in your GUI
#     editor).          ↓
#     - Think "o" as in open.
#
#   - NAMES: For example:
#              fdp & fdo (`fd`)
#              stp & sto (`st`, aka git-status)
#              rpp       (`rp`, aka realpath, copy only,
#                               defined by Homefries)

_dxy_wire_aliases_fd_fzf() {
  # REFER: On macOS: fdp: *filter for drawing undirected graphs*
  # - I don't use built-in fdp... will anyone care or will I
  #   ever be future-confused if I claim that command name?
  # MAYBE/2025-09-16: This query might be costly, or at least
  # the first time I ran `fdp --help` it took a few seconds.
  # REFER:
  #   @macOS $ fdp -V
  #   fdp - graphviz version 9.0.0 (20230911.1827)
  local force=false
  if [ "$(type -t /opt/local/bin/fdp)" = "file" ] \
    && fdp -V 2>&1 | grep -q -e "^fdp - graphviz" \
    ; then

    force=true
  fi
  # Copies picked path from `fd` results.
  claim_alias_or_warn "fdp" "_dxy_fdfind_clip_path" ${force}

  # Opens picked path from `fd` results (using `fs`).
  claim_alias_or_warn "fdo" "_dxy_fdfind_open_path"
}

_dxy_wire_aliases_st_fzf() {
  # Copies picked path from `git status` results.
  claim_alias_or_warn "stp" "_dxy_git_status_clip_path"
  # Opens picked path from `git status` results (using `fs`).
  claim_alias_or_warn "sto" "_dxy_git_status_open_path"
}

_dxy_wire_aliases_ad_fzf() {
  # If no args, `add`, will git-add picked path(s) from
  # `git status` results, or if one path, auto-add. If
  # args specified, skips FZF and passes args to git-add.
  claim_alias_or_warn "add" "_dxy_git_status_git_add_path"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# CXREF: See `fd` commands in Homefries:
#
#   ~/.kit/sh/home-fries/lib/alias/alias_fd.sh
#
# - [Author] I thought've adding these funcs
#   therein except the fd-open command calls
#   `fs` and I didn't want to plumb anything
#   more configurable... (such as an environ
#   like EDITOR, but for GUI editing; MAYBE:
#   add new environ, say, EDITOR_GUI, that's
#   an EDITOR complement... or GUI_EDITOR?).
#   - FTREQ: Make these functions easier for
#     any user to incorporate into their env
#     (then publish separately from DepoXy)?
#     - E.g. use GUI_EDITOR to replace `fs`.

_dxy_fdfind_clip_path() {
  local path
  if ! path="$(_dxy_fd_prompt_paths "$@")"; then

    return 1
  fi

  if test -n "${path}"; then
    printf "%s" "${path}" | _hf_clip
  fi
}

# SAMEZ: Similar to _dxy_git_status_open_path (below).
_dxy_fdfind_open_path() {
  local path
  if ! path="$(_dxy_fd_prompt_paths "$@")"; then

    return 1
  fi

  if test -n "${path}"; then
    # INERT: Should this fcn. also copy the path?
    #  printf "%s" "${path}" | _hf_clip

    # CXREF: `fs` func:
    # ~/.depoxy/ambers/core/alias-vim.sh
    # - MAYBE: Make the EDITOR choice more configurable,
    #   e.g., GUI_EDITOR.
    fs "${path}"
  fi
}

# SAMEZ: Similar to _dxy_git_status_prompt_paths (below).
_dxy_fd_prompt_paths() {
  if ! _wf_fzf_command > /dev/null; then

    return 1
  fi

  local paths
  paths="$(fd "$@" | xargs realpath | sort | uniq | tilde_for_home)"

  if test "$(echo "${paths}" | wc -l)" -eq 1; then
    # Only one result, so return it without prompting.
    echo "${paths}" | tr -d "\n"
  else
    echo "${paths}" | _wf_fzf | tr -d "\n"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_git_status_clip_path() {
  if test -z "$(git status --porcelain=v1)"; then

    return 0
  fi

  local path
  path="$(_dxy_git_status_prompt_paths_single)"

  if test -n "${path}"; then
    printf "%s" "${path}" | _hf_clip
  fi
}

# CALSO: <Ctrl-F> FZF-prompts file to open from those under current path.
# SAMEZ: Similar to _dxy_fdfind_open_path (above).
_dxy_git_status_open_path() {
  if test -z "$(git status --porcelain=v1)"; then

    return 0
  fi

  local path
  path="$(_dxy_git_status_prompt_paths_single)"

  if test -n "${path}"; then
    # INERT: Should this fcn. also copy the path?
    #  printf "%s" "${path}" | _hf_clip

    # CXREF: `fs` func:
    # ~/.depoxy/ambers/core/alias-vim.sh
    # - MAYBE: Make the EDITOR choice more configurable,
    #   e.g., GUI_EDITOR.
    fs "${path}"
  fi
}

# SAMEZ: Similar to _dxy_fd_prompt_paths (above).
_dxy_git_status_prompt_paths() {
  local path_filter="${1:-tilde_for_home}"
  local extra_fzf_args="$2"

  if ! _wf_fzf_command > /dev/null; then

    return 1
  fi

  if test -z "$(git status --porcelain=v1)"; then

    return 0
  fi

  # Return files changed in working tree,
  # but ignore index (staged) changes.
  # - Include unstaged and untracked files:
  #     local filter="^\( \|?\)[^ ]"
  # Include all files:
  local filter="^\(M\|U\|?\| \)\(M\|U\|?\| \)"

  local paths
  paths="$(
    git status --porcelain=v1 \
      | grep -e "${filter}" \
      | cut -c3- \
      | xargs realpath \
      | ${path_filter}
  )"

  if test "$(echo "${paths}" | wc -l)" -eq 1; then
    echo "${paths}"
  else
    echo "${paths}" | _wf_fzf "${extra_fzf_args}"
  fi
}

_dxy_git_status_prompt_paths_single() {
  local path_filter="tilde_for_home"
  local extra_fzf_args=""

  _dxy_git_status_prompt_paths "${path_filter}" "${extra_fzf_args}" \
    | tr -d "\n"
}

_dxy_git_status_prompt_paths_multi() {
  local path_filter="cat"
  local extra_fzf_args="--multi"

  _dxy_git_status_prompt_paths "${path_filter}" "${extra_fzf_args}"
}

# ***

# UCASE: Author normally git-add's with tig,
# except when I'm resolving rebase conflicts.

_dxy_git_status_git_add_path() {
  if test -z "$(git status --porcelain=v1)"; then

    return 0
  fi

  if test $# -eq 0; then
    _dxy_git_status_prompt_paths_multi | xargs git add --
  else
    git add "$@"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_wf_fzf_command() {
  if ! command -v "${HOMEFRIES_FZF:-fzf}" \
    && ! command -v "${HOMEFRIES_FZF:-fzy}" \
    ; then

    >&2 echo "ERROR: Missing \`fzf\` or \`fzy\` or bad \$HOMEFRIES_FZF"

    return 1
  fi
}

# DUNNO/2025-09-13: Author doesn't have a pref. fzf vs. fzy.
# - Both are easily dismissed with <Escape>.
# - Both fzf and fzy show matches under the prompt line
#   (shifting it up to show more picker entries).
# - And while their default layouts are a *titch*
#   different, fzf is very customizable.
#   - By default, fzf is a little different than fzy:
#     - fzf shows the prompt below the list with results
#       reverse-ordered upward above it.
#       - fzy shows the prompt above the list instead.
#    - fzf displays an additional separator line between
#      the picker list and the prompt (and it also shows
#      the number of results on the separator line).
#     - fzy doesn't show a separator.
#   - To make fzf look more like fzy, you can hide the
#     results count with --info=hidden, and you can hide
#     the separator line altogether w/ --no-separator
#     (without --info-hidden, fzf still uses a whole
#     line for the count, sorta like a blank separator).
#     And you can move the prompt to the top of the list
#     with --layout=reverse.
#     - Now they look very similar, although fzf uses a
#       two-column pad to the left of the results, e.g.,
#         $ HOMEFRIES_FZF=fzf fd README | _wf_fzf
#         > █
#         ▒ README.md
#         ▒ docs/README-Install.md
#       etc., using a grayscale box char. and a space.
#     - So now author guesses they like `fzy` layout
#       with `fzf` padding (also future-proofing any
#       changes in taste, and preferring `fzf` because
#       it's very customizable (and we could make it
#       easy for user to tailor `fzf` to their tastes)).

_wf_fzf() {
  local extra_fzf_args="$1"

  if [ "${HOMEFRIES_FZF:-fzf}" = "fzf" ]; then
    # Rather than use a full-screen overlay, put
    # picker below cursor, and use just enough
    # rows to show all choices.
    fzf --height=~100% --info=hidden --no-separator --layout=reverse ${extra_fzf_args}
  elif [ "${HOMEFRIES_FZF:-fzy}" = "fzy" ]; then
    fzy
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main() {
  unset -f main

  _dxy_wire_aliases_fd_fzf
  unset -f _dxy_wire_aliases_fd_fzf

  _dxy_wire_aliases_st_fzf
  unset -f _dxy_wire_aliases_st_fzf

  _dxy_wire_aliases_ad_fzf
  unset -f _dxy_wire_aliases_ad_fzf
}

main "$@"
