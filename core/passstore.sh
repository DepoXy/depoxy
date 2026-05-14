# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE: `pass` command wrapper:
# - Wrap `pass edit <path>` command:
#   - Enable reST highlight by using .rst file extension for tmp file
#   - Enable <Ctrl-S> binding that calls `:wq`, i.e., fast save-exit.
# - Add `pass gen <path>` command, to create new password entries
#   using a conventional formatting.
# - Wrap default `pass` show command (but not `pass show`):
#   - Format terminal rst output (using pygmentize or bat).

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE: Set to control the default email for `pass gen <path>`:
# CXREF: ~/.depoxy/running/home/.config/depoxy/depoxyrc
PASS_GEN_DEFAULT_EMAIL="${PASS_GEN_DEFAULT_EMAIL}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_pass_safe() {
  if [ $# -ge 1 ] && [ "$1" = "edit" ]; then
    _dxy_pass_edit "$@"
  elif [ $# -ge 1 ] && [ "$1" = "${PASS_GEN_CMD:-gen}" ]; then
    __dxy_pass_generate "$@"
  elif [ $# -ge 1 ] && ([ "$1" = "help" ] || [ "$1" = "--help" ]); then
    _dxy_pass_help "$@"
  elif [ $# -ge 1 ] && [ "$1" = "version" ]; then
    _dxy_pass_version "$@"
  elif ([ $# -eq 1 ] && _dxy_pass_exists "$1"); then
    # Override `pass <pass-name>`, but not `pass show <pass-name>`,
    # so user can run latter for raw output.
    _dxy_pass_show "$@"
  else
    command pass "$@"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_pass_help() {
  # Note that $0 is "bash" (being called as an alias doesn't reveal the alias name).
  #   local PROGRAM="${0##*/}"
  local PROGRAM="pass"

  command pass "$@"

  # SAVVY/2026-05-13: Cannot source /usr/bin/pass to read environ(s)
  # (Ucase: For help text, e.g., ${PASSWORD_STORE_CLIP_TIME}),
  # because `pass` itself doesn't support it:
  #   # Runs when sourced, prints entire tree, then exits (hence subshell).
  #   $ (. ~/.local/bin/pass)
  #   ...
  # - DEBAR/FTREQ: You could make the pass fork sourceable, but really
  #   not worth the effort. / CXREF:
  #     ~/.local/bin/pass  # Copy-installed from:
  #     ~/.kit/sh/password-store/src/password-store.sh

  cat <<- _EOF

Additional 🙲 Enhanced commands from DepoXy:
    $PROGRAM pass-name
        Like pass-show, but formats output as reST. / Set PASS_FMTR to change formatter, e.g.:
            PASS_FMTR=pygmentize PASS_PYGSTYLE=nord-darker pass pass-name  # default formatter
            PASS_FMTR=bat        PASS_BATSTYLE=DarkNeon    pass pass-name
        Some other styles: PASS_PYGSTYLE=github-dark|paraiso-dark|zenburn|etc.
    $PROGRAM edit [--ext=extension,-e extension] pass-name
        Inserts a new password or edits an existing password using your preferred EDITOR
        (currently set to: ${EDITOR}).
        - Uses reST filetype (unless overridden via --ext) for syntax highlighting, etc.
        - If using DepoXy's EDITOR, wires Neovim to exit on save, etc.
    $PROGRAM gen pass-name
        Generates a new password via prompts (for website URL, username, email, and logon URL)
        using conventional DepoXy pass entry structure. (Tho note tab completion unsupported.)
    $PROGRAM open
        Opens URL from final line of output — if that line starts with \`sensible-open\`.
        - Requires sensible-open: https://github.com/landonb/sh-sensible-open#🪂
    $PROGRAM help
        Shows this text (including DepoXy enhancements).
    $PROGRAM version
        Shows version information (including DepoXy version).
    passcp pass-name
        Shows password entry and copies first line to clipboard, for limited time (per environ,
        PASSWORD_STORE_CLIP_TIME, which defaults to 45s).
    passo pass-name
        Shows password entry and opens web browser using URL from final line of output.
_EOF
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_pass_version() {
  command pass "$@"
  (
    # FIXME/2026-05-12: Srsly, there isn't a git-nubs or other util. fcn. to print SHA/HEAD dist?
    local gbvtdir="${GITREPOSPATH:-${HOME}/.kit/git}/git-bump-version-tag"
    cd -- "${gbvtdir}"
    # CXREF: ~/.kit/git/git-bump-version-tag/bin/git-bump-version-tag
    . "${gbvtdir}/bin/git-bump-version-tag"
    source_deps

    local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
    cd -- "${ambers_path}"

    local passstoresh_sha passstoresh_dat
    passstoresh_sha="$(git log -1 --pretty=format:%H -- core/passstore.sh)"
    # WRKLG: Compare git-log committer date formats:
    #   $ gnp log -1 \
    #     --pretty=format:"cd: %cd ‖ cD: %cD ‖ cr: %cr ‖ ct: %ct ‖ ci: %ci ‖ cI: %cI ‖ cs: %cs ‖ ch: %ch" \
    #     -- core/passstore.sh
    #   cd: Tue Nov 4 23:01:15 2025 -0600 ‖ cD: Tue, 4 Nov 2025 23:01:15 -0600
    #   cr: 6 months ago ‖ ct: 1762318875
    #   ci: 2025-11-04 23:01:15 -0600 ‖ cI: 2025-11-04T23:01:15-06:00 ‖ cs: 2025-11-04 ‖ ch: Nov 4 2025
    passstoresh_dat="$(git log -1 --pretty=format:%cs -- core/passstore.sh)"
    echo -e "_dxy_pass_safe version: $(print_head_dist_and_ref_name "${passstoresh_sha}") [${passstoresh_dat}]"
  )
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_pass_edit() {
  # User called `pass edit <path>`
  shift

  # ISOFF/2024-08-07: The minimal editor is not any quicker to start
  # than normal Vim; and then you won't get reST highlights. Not this:
  #   local nvimd="${NEOVIM_REPOS:-${DOPP_KIT:-${HOME}/.kit}/nvim}/nvim-depoxy"
  #   EDITOR="${nvimd}/bin/editor-vim-0-0-insert-minimal" \
  #     VIM_EDIT_JUICE_EXIT_ON_SAVE=1 command pass edit --ext=rst "$@"

  VIM_EDIT_JUICE_EXIT_ON_SAVE=1 command pass edit --ext=rst "$@"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_pass_exists() {
  test -e "${PASSWORD_STORE_BASE:-${HOME}/.password-store}/$1.gpg"
}

# Strip ASCII/term color escape sequence codes, e.g., \1b[38;2;165;214;255m.
# - USYNC: Same regex used by strip-colors:
#     strip_colors() {
#       /usr/bin/env sed -E "s/\x01?\x1B\[([0-9]{1,2}(;[0-9]{1,3})*)?[mGK]\x02?//g" "$@"
#     }
#   - CXREF:
#     ~/.kit/sh/sh-colors/bin/strip-colors @ 18
PASS_ESCSEQ=${PASS_ESCSEQ:-'\x01?\x1B\[([0-9]{1,2}(;[0-9]{1,3})*)?[mGK]\x02?'}
PASS_ESCSEQ_DBL_COLON="(${PASS_ESCSEQ})*:(${PASS_ESCSEQ})*:(${PASS_ESCSEQ})*"

_dxy_pass_strip_colors_blank_lines() {
  # Maybe: Remove all lines without any printables.
  # - It's probably safe.
  #   - I doubt pygmentize or bat span color codes across newlines.
  #  /usr/bin/env sed -E "s/^(${PASS_ESCSEQ})*\s+(${PASS_ESCSEQ})*$//g" "$@"

  /usr/bin/env sed -E "s/^(${PASS_ESCSEQ})+\s+(${PASS_ESCSEQ})+$//g" "$@"
}
#
# Prevy: Hardcoded:
_dxy_pass_strip_colors_blank_lines__HARDC() {
  local escseq="\x01?\x1B\[([0-9]{1,2}(;[0-9]{1,3})*)?[mGK]\x02?"
  /usr/bin/env sed -E "s/^${escseq}\s+${escseq}$//g" "$@"
}

_dxy_pass_remove_trailing_blank_line() {
  sed '${/^$/d;}'
}

# ***

# BWARE: Note that pygmentize is stricter than reST spec about code blocks.
#
# - KLUGE: For pygmentize, three (out-of-spec) kludges:
#   - †) A code-block is not recognized if `::` is on a bullet/list item line.
#   - ‡) A single-line `::` code block is not always recognized by pygmentize.
#   - ¶) A `::` and its code block must be separated *by exactly!* 1 blank ln.
#
# - On the contrary, unlike pygmentize:
#   - The `bat` formatter honors the reST code block spec better, e.g.:
#       echo -e "- WORKS::\n\n  This is a code block" | bat -l rst --style plain --theme DarkNeon
#       echo -e "WORKS ✓::\n\n  Also is a code block" | bat -l rst --style plain --theme DarkNeon
#   - It's technically too loose, however:
#       echo -e "WORKS!::\n Ope! A code block" | bat -l rst --style plain --theme DarkNeon
#     - I.e., it recognizes a code-block after `::` but without an intervening blank link.
#       - (This is actually what the author prefers, and is how the author's (Neo)Vim env.
#          is configured, to highlight code blocks after `::` without requiring blank line
#          between `::` and the code block. But it's against spec. (Though implementing said
#          behavior does not break anything else!))
#
# †) As mentioned above, `::` cannot end a list item line.
# - I.e., a bulleted `::` line *does not* work!? (Srsly, huh).
# - So this simpler code won't work, which ensures a blank line follows `::`:
#     awk 'BEGIN {on=1;}
#       /::$/{on=0; ln=$0; next}
#       /^$/{if (!on) {next;}}
#       {if (!on) {print ln; print ""}; on=1}
#       on'
# - E.g., this is not a code block to pygmentize:
#
#       - Wrong::
#
#         Not a code block
#
# - This works instead (`::` not bulleted):
#
#       Correct::
#
#         I'm a code block!
#
#   - (Ugh, pygmentize is so/too/overly strict!)
# - An example:
#     echo -e "- BROKN::\n\n  Why isn't this a code block??!\n " | pygmentize -l rst -O style=nord-darker
#   - So this won't work:
#     awk 'BEGIN {on=1;}
#       /::$/{on=0; ln=$0; next}
#       /^$/{if (!on) {next;}} {if (!on) {print ln; print ""}; on=1}
#       on'
#
# ‡) As also mentioned above, not all single-line code blocks are recognized correctly.
# - There must additional content, or *a line with a space*, after the single-line code block.
#   - (This is esp. a problem for the author, who pretty ends every pass entry with a code
#      block, specifically a copy-pasteable `sensible-open <URL>` snippet.)
# - E.g., this won't work:
#     echo -e "BROKN::\n\n  This *is not* a code block!?" | pygmentize -l rst -O style=nord-darker
#     echo -e "BROKN::\n\n  Nor is this a code block  \n" | pygmentize -l rst -O style=nord-darker
#     echo -e "BROKN::\n\n  Nor is this a code block\n\n" | pygmentize -l rst -O style=nord-darker
#   - But if you add a trailing space, it (magically!) works!:
#     echo -e "WORKS::\n\n  This is (*finally*) a code block\n " | pygmentize -l rst -O style=nord-darker
#   - Or making it not single-line:
#     echo -e "WORKS::\n\n  Adding a second line\n  also works" | pygmentize -l rst -O style=nord-darker

# REFER: See `_dxy_pass_rst_pad_blocks` removers/reverters:
#     ... |
#     _dxy_pass_strip_colors_blank_lines |
#     _dxy_pass_remove_trailing_blank_line |
#     _dxy_pass_restore_double_colon_code_block_leaders

# CPYST:
#   . ~/.depoxy/ambers/core/passstore.sh ; \
#     echo -e "foo bar buzz::\n\n\n XXX" |
#       _dxy_pass_rst_pad_blocks

_dxy_pass_rst_pad_blocks() {
  # KLUGE: †) Ensure `::` is on its own line (kludge for pygmentize; bat works fine without).
  # SAVVY: gsub() mutates the variable (ln), so just need to print it afterwards.
  # SAVVY: ¶) You'd think we only need to kludge when `::` follows text, e.g.:
  #            /[^^]${PASS_ESCSEQ_DBL_COLON}\$/ { on=0; ln=\$0; next }
  #          But also kludge `::`-only lines (/^::$/) to ensure `::` is
  #          *followed by only 1 blank line* to _appease_ pygmentize (/ugh).
  awk "
    BEGIN { on = 1; }
    /${PASS_ESCSEQ_DBL_COLON}\$/ { on = 0; ln = \$0; next; }
    /^\$/ { if (!on) { next; }; }
    { if (!on) {
        gsub(/${PASS_ESCSEQ_DBL_COLON}\$/, \"\", ln);
        print ln;
        print \"${PASS_CODEBLOCKMAGIC}::\";
        print \"\";
      };
      on = 1;
    }
    on"
  # KLUGE: ‡) So trailing single-line code blocks work.
  echo " "
}
#
# Prevy: Hardcoded:
_dxy_pass_rst_pad_blocks__HARDC() {
  # KLUGE: †) Ensure `::` is on its own line (for pygmentize; or use bat).
  awk '
    BEGIN { on = 1; }
    /::$/ { on = 0; ln = $0; next; }
    /^$/ { if (!on) { next; }; }
    { if (!on) { gsub(/::$/, "", ln); print "::"; print "" }; on = 1; }
    on'
  # KLUGE: ‡) So trailing single-line code blocks work.
  echo " "
}

# CPYST:
#   . ~/.depoxy/ambers/core/passstore.sh ; \
#     echo -e "\nfoo\n\nbar\n\nqux quux quuz\n${PASS_CODEBLOCKMAGIC}::\n\n\n XXX" |
#       _dxy_pass_restore_double_colon_code_block_leaders

PASS_CODEBLOCKMAGIC="${PASS_CODEBLOCKMAGIC:-Súper secreto mágico}"

_dxy_pass_restore_double_colon_code_block_leaders() {
  awk "
    BEGIN { first = 1; }
    /^(${PASS_ESCSEQ})*${PASS_CODEBLOCKMAGIC}${PASS_ESCSEQ_DBL_COLON}\$/ {
      print prev \"::\"; first = 1; next;
    }
    { if (!first) { print prev; }; prev = \$0; first = 0; next; }
    { print \"GAFFE: Unreachable\"; }
    END { if (prev) { print prev; }; }
  "
}

# ***

# Remove all blank lines following line ending with `::`,
# accounting for optional/possible color escape sequence.
#
# - E.g., remove the following characters (marked "!"):
#
#   $ echo "$(fg_orange)::$(attr_reset)" | hexdump
#   ... 6d) 3a 3a 1b 5b 30 6d 0a 0a (1b 5b ...
#   #        :  :  !  !  !  ! \n \n
#
# BWARE: You cannot awk /\x5b/ or /\x5c/ (or ~ "\x5b" or ~ "\x5c")
# because it'll error, e.g.:
#
#   $ echo "foo" | awk '/\x5a/ {print "matchd";}'
#
#   $ echo "foo" | awk '/\x5b/ {print "matchd";}'
#   awk: cmd. line:1: error: Invalid regular expression: /\/
#
#     # \x5b is "[", which is regex command, prob. why \x5b
#     # doesn't work; but using "[" produces diff. error:
#
#     $ echo "foo" | awk '/[/ {print "matchd";}'
#     awk: cmd. line:1: /[/ {print "matchd";}
#     awk: cmd. line:1:  ^ unterminated regexp
#
#   $ echo "foo" | awk '/\x5c/ {print "matchd";}'
#   awk: cmd. line:1: error: Trailing backslash: /\/
#
#     # \x5b is "\", which is regex escape, possibly why \x5c
#     # doesn't work.
#
#     # - This seems like expected error:
#     $ echo "foo" | awk '/\/ {print "matchd";}'
#     awk: cmd. line:1: /\/ {print "matchd";}
#     awk: cmd. line:1:  ^ unterminated regexp
#
#     $ echo "foo" | awk '/\\/ {print "matchd";}'
#     # No output/error.
#
#   $ echo "foo" | awk '/\x5d/ {print "matchd";}'
#
#     # Works.
#     # - So does using ASCII value for \x5d, "]", e.g.:
#     $ echo "foo" | awk '/]/ {print "matchd";}'
#     # No output/error.

_dxy_pass_rst_remove_codeblock_leading_blanks() {
  awk "
    BEGIN { on = 1; }
    /${PASS_ESCSEQ_DBL_COLON}\$/ { on = 0; print; next; }
    /^\$/ { if (!on) { next; }; }
    { on = 1; }
    on"
}
#
# Prevy: Hardcoded:
_dxy_pass_rst_remove_codeblock_leading_blanks__HARDC() {
  # USYNC: `strip_colors`:
  #   ~/.kit/sh/sh-colors/bin/strip-colors @ 18
  awk '
    BEGIN { on = 1; }
    /::\x01?\x1b\[([0-9]{1,2}(;[0-9]{1,3})*)?[mGK]\x02?$/ { on = 0; print; next; }
    /^$/ { if (!on) { next; }; }
    { on = 1; }
    on'
}

# ***

# Our pass-show wrapper formats the pass output as rst.
#
# - It defaults to using pygmentize, though neither pygmentize
#   nor bat is "perfect".
#
# - Some pygmentize styles print reST *italics* in italics,
#   but no bat styles do.
#
# - pygmentize is very particular about `::` code blocks,
#   whereas bat is very forgiving about `::` formatting.
#
# - REFER:
#
#  - Demo pygmentize styles:
#       INPUTF=/path/to/example.rst ~/.depoxy/ambers/bin/demo-pygmentize-styles
#
#    - See also:
#       . ~/.depoxy/ambers/bin/demo-pygmentize-styles
#       demo_pygmentize_styles_best_rst
#
#   - Test bat via pass-safe:
#     PASS_FMTR=pygmentize PASS_PYGSTYLE=nord-darker pass <pass-name>
#
#     - List pygmentize styles:
#       pygmentize -L styles
#
#   - Test bat directly:
#       cat some/file | pygmentize -l rst -O style=nord-darker
#
#   - Demo bat styles:
#       INPUTF=/path/to/example.rst ~/.depoxy/ambers/bin/demo-bat-styles
#
#   - Test bat via pass-safe:
#     PASS_FMTR=bat PASS_BATSTYLE=DarkNeon pass <pass-name>
#
#     - List bat styles:
#       bat --list-themes
#       # Less verbose:
#       bat --list-themes | cat
#
#   - Test bat directly:
#       cat some/file | bat -l -rst --style plain --theme DarkNeon --color always
#
# Note that DarkNeon is only bat theme that colors code blocks specially;
# and that no bat themes italicize *italics* (though most specially color).
#
# SAVVY: Our code herein mostly kludges the reST document before feeding it
# to pygmentize.
# - E.g., it'll ensure there's exactly one blank line between the double-colon
#   `::` line and the first line of a code block; otherwise pygmentize won't
#   highlight the code block, e.g., if there's no blank line after the `::`
#   line, or if there are two or more blank lines, then pygmentize won't
#   recognize the code block (the latter of which is not in the reST spec,
#   AFAIK; you should be allowed to use 1 or more blank lines after `::`).
# - BWARE: If you use a single-line code block not followed by a blank line,
#   pygementize *might not* highlight the code block (it *sometimes* works).
#   - The is the only kludge *not* implemented herein, AFAIK (because
#     determining the end of a code block, and afterwards deciding which
#     blank to remove after code blocks, sounds trickier than the other
#     kludges we've already implemented).

_dxy_pass_show() {
  local fmtr="${PASS_FMTR:-pygmentize}"
  # local fmtr="${PASS_FMTR:-bat}"

  if ! command -v ${fmtr} > /dev/null; then
    command pass "$@"

    >&2 echo -e "\nERROR: Missing PASS_FMTR command: ${fmtr}"

    return 0
  fi

  # Assume first line is password, 2nd blank, 3rd is (conventional) password entry
  # details (typically: date/URL/email/login/password), 4th is 🔺🔺🔺 underline or
  # blank, and 5th and subsequent lines may/may not be reStructuredText.
  local partial_head_n=4
  # E.g., partial_tail_n=5
  local partial_tail_n
  let 'partial_tail_n = partial_head_n + 1'

  local ptext=""
  if ptext="$(command pass "$@")"; then
    # USAGE:
    #   PASS_PYGSTYLE=github-dark pass foo
    #
    # local pygstyle="${PASS_PYGSTYLE:-github-dark}"
    local pygstyle="${PASS_PYGSTYLE:-nord-darker}"
    # local pygstyle="${PASS_PYGSTYLE:-paraiso-dark}"
    # local pygstyle="${PASS_PYGSTYLE:-zenburn}"
    #
    # - Assume lexer is: restructuredtext, rst, rest
    echo "${ptext}" | head -n ${partial_head_n}
    if [ "${fmtr}" = "pygmentize" ]; then
      echo "${ptext}" | tail -n +${partial_tail_n} \
        | _dxy_pass_rst_pad_blocks \
        | pygmentize -l ${PASS_PYGLEXER:-rst} -O style=${pygstyle} \
        | _dxy_pass_strip_colors_blank_lines \
        | _dxy_pass_remove_trailing_blank_line \
        | _dxy_pass_restore_double_colon_code_block_leaders \
        | _dxy_pass_rst_remove_codeblock_leading_blanks
    elif [ "${fmtr}" = "bat" ]; then
      # Savvy: Don't need :: followed by blank line for it to work,
      # unlike pygmentize, so skip _dxy_pass_rst_pad_blocks
      # and _dxy_pass_restore_double_colon_code_block_leaders.
      #
      # - This works from terminal:
      #     echo -e '::\n  foo' | bat -l rst --style plain --theme DarkNeon
      # - But not highlighted when same is piped from `pass` output.
      echo "${ptext}" | tail -n +${partial_tail_n} \
        | bat -l ${PASS_BATLEXER:-rst} --style plain --theme "${PASS_BATSTYLE:-DarkNeon}" --color always \
        | _dxy_pass_strip_colors_blank_lines \
        | _dxy_pass_remove_trailing_blank_line \
        | _dxy_pass_rst_remove_codeblock_leading_blanks
    else
      echo "${ptext}" | tail -n +${partial_tail_n}
      >&2 echo "ERROR: Unknown PASS_FMTR: ${fmtr}"
    fi
  else
    echo "${ptext}" | tail -n +${partial_tail_n}
    command pass "$@"
    >&2 echo "ERROR: Missing PASS_FMTR: ${fmtr}"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# The `pass gen` command.
__dxy_pass_generate() {
  # User called `pass gen <path>`
  shift

  local path="$1"

  if [ -z "${path}" ]; then
    >&2 echo "USAGE: pass gen <path>"

    return 1
  fi

  if pass show "${path}" > /dev/null 2>&1; then
    >&2 echo "ERROR: password exists: “${path}”"

    return 1
  fi

  local register_url=""
  local acct_uname=""
  local acct_email=""
  local logon_url=""

  local default_email="${PASS_GEN_DEFAULT_EMAIL}"

  local question="Website or new acct URL: https://"
  echo -n "${question}"
  read -e register_url
  # [ -n "${register_url}" ] || echo
  if ! echo "${register_url}" | grep -q "://"; then
    register_url="https://${register_url}"
  fi

  local question="Your user: "
  echo -n "${question}"
  read -e acct_uname
  # [ -n "${acct_uname}" ] || echo

  local question="Your email [${default_email}]: "
  echo -n "${question}"
  read -e acct_email
  if [ -z "${acct_email}" ]; then
    acct_email="${default_email}"
    # echo
  fi

  local question="Logon URL [${register_url}]: "
  echo -n "${question}"
  read -e logon_url
  if [ -z "${logon_url}" ]; then
    logon_url="${register_url}"
    # echo
  fi

  echo

  # ***

  local acct_passw
  # Aka, `pwgen23`. And replace double-quote for our echo.
  acct_passw="$(_hf_aliases_wire_pwgen_pwgen23 | sed "s/\"/'/")"

  # Highlight the password at the end of the details line.
  # - SAVVY: ${VAR//?/ } substitutes every character with a space.
  local pass_line_sans_pwd
  pass_line_sans_pwd="$(date +%Y-%m-%d) / ${register_url} / ${acct_uname} / ${acct_email} / "

  echo -n "${acct_passw}

${pass_line_sans_pwd}${acct_passw}
${pass_line_sans_pwd//?/ }🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺

::
  sensible-open ${logon_url}
" | pass insert -m "${path}"

  # ***

  echo
  pass show --clip "${path}"

  echo
  # Aka `pass "${path}"`
  pass show "${path}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases_pass() {
  claim_alias_or_warn "pass" "_dxy_pass_safe" ${_force:-true}

  # Print password (pass-show), then copy to clipboard (pass show -c).
  claim_alias_or_warn "passcp" '_f() { _dxy_pass_safe \"\$@\"; echo; _dxy_pass_safe show -c \"\$1\"; }; _f'
}

_dxy_wire_aliases() {
  _dxy_wire_aliases_pass
  unset -f _dxy_wire_aliases_pass
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main() {
  unset -f main

  _dxy_wire_aliases
  unset -f _dxy_wire_aliases
}

main "$@"
