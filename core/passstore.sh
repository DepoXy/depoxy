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

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE: Set to control the default email for `pass gen <path>`:
# CXREF: ~/.depoxy/running/home/.config/depoxy/depoxyrc
PASS_GEN_DEFAULT_EMAIL="${PASS_GEN_DEFAULT_EMAIL}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

pass_safe() {
  if [ $# -ge 1 ] && [ "$1" = "edit" ]; then
    # User called `pass edit <path>`
    shift

    # ISOFF/2024-08-07: The minimal editor is not any quicker to start
    # than normal Vim; and then you won't get reST highlights. Not this:
    #   local nvimd="${NEOVIM_REPOS:-${DOPP_KIT:-${HOME}/.kit}/nvim}/nvim-depoxy}"
    #   EDITOR="${nvimd}/bin/editor-vim-0-0-insert-minimal" \
    #     VIM_EDIT_JUICE_EXIT_ON_SAVE=1 command pass edit --ext=rst "$@"

    VIM_EDIT_JUICE_EXIT_ON_SAVE=1 command pass edit --ext=rst "$@"
  elif [ $# -ge 1 ] && [ "$1" = "${PASS_GEN_CMD:-gen}" ]; then
    # User called `pass gen <path>`
    shift

    _pass_safe_generate "$@"
  elif [ $# -ge 1 ] && ([ "$1" = "help" ] || [ "$1" = "--help" ]); then
    # Note that $0 is "bash" (being called as an alias doesn't reveal the alias name).
    #   local PROGRAM="${0##*/}"
    local PROGRAM="pass"

    command pass "$@"

    cat <<- _EOF

Additional commands from DepoXy:
    $PROGRAM gen pass-name
        Generate a new password via prompts (for website URL, username, email, and logon URL).
        (Although note that tab completion not currently supported.)
_EOF
  else
    command pass "$@"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# The `pass gen` command.
_pass_safe_generate() {
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
  alias pass='pass_safe'
}

_dxy_wire_aliases() {
  _dxy_wire_aliases_pass
  unset -f _dxy_wire_aliases_pass
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main() {
  _dxy_wire_aliases
  unset -f _dxy_wire_aliases
}

main "$@"
unset -f main
