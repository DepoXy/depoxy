# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_completion_pass () {
  # In lieu of needing to update the path occassionally, e.g.,
  #     pass_complete="/usr/local/Cellar/pass/1.7.3/etc/bash_completion.d/pass"
  # glob our way to completion.
  local pass_complete="/${HOMEBREW_CELLAR}/pass/*/etc/bash_completion.d/pass"

  if [ -z "$(eval ls "${pass_complete}" 2> /dev/null)" ]; then
    return;
  fi

  eval . "${pass_complete}"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_completion_pass
  unset -f _dxy_wire_completion_pass
}

main "$@"
unset -f main

