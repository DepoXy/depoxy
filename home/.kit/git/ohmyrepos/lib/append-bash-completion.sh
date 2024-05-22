# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# CXREF/2023-05-14: ~/.bash_completion is sourced by /etc/bash_completion
#   /etc/bash_completion -> /usr/share/bash-completion/bash_completion
#   # @macOS:
#   /opt/homebrew/share/bash-completion/bash_completion
#     -> ../../Cellar/bash-completion@2/2.14.0/share/bash-completion/bash_completion
append_bash_completion () {
  local add_line="$1"

  local target_path="${HOME}/.bash_completion"

  # CXREF/2024-04-03:
  #   ~/.kit/git/ohmyrepos/lib/line-in-file.sh
  line_in_file "${add_line}" "${target_path}"
}

