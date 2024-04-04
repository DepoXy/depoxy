# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# CXREF/2023-05-14: ~/.bash_completion is sourced by /etc/base_completion
#   /etc/bash_completion -> /usr/share/bash-completion/bash_completion
append_bash_completion () {
  local add_line="$1"

  local target="${HOME}/.bash_completion"

  # SAVVY: -q quiet, -x match the whole line, -F pattern is a plain string
  if [ -f "${target}" ] && grep -qxF "${add_line}" "${target}"; then
    info "Verified $(fg_lightorange)~/.bash_completion$(attr_reset)"
  else
    if [ ! -e "${target}" ]; then
      info "Creating $(fg_lightorange)~/.bash_completion$(attr_reset)"
    else
      info "Updating $(fg_lightorange)~/.bash_completion$(attr_reset)"
    fi

    echo "${add_line}" >> "${target}"
  fi
}

