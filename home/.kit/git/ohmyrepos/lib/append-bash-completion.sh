# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# CXREF/2024-04-03:
#   ~/.kit/git/ohmyrepos/lib/line-in-file.sh
append_bash_completion () {
  local add_line="$1"

  local target_path="${HOME}/.bash_completion"

  line_in_file "${add_line}" "${target_path}"
}

