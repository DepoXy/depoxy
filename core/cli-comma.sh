# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# MAYBE/2020-09-14: Stand up using completion mechanism instead:
# - Whatever is in ~/.kit/sh/home-fries/bin/completions/ is sourced,
#   so we could create symlink from there to commacd.bash.
#   - However, this command is technically *not* a completion, so...
#     (well, if there were other instances of files being sourced
#     from our bashrc, we could create another location, say,
#     ~/.kit/sh/home-fries/.bashrc-bin/start/, and auto-source its files
#     on startup. Just a thought).

# commacd enables directory nagivation with , ,, ,,, !!!
#   https://github.com/shyiko/commacd
#   http://shyiko.com/2014/10/10/commacd/
wire_commacd () {
  COMMACD_CD="_dxy_command_cd"

  # CXREF: ~/.kit/sh/commacd/commacd.sh
  #        ~/.kit/sh/commacd/commacd.bash
  if [ -e ${SHOILERPLATE:-${HOME}/.kit/sh}/commacd/commacd.sh ]; then
    . ${SHOILERPLATE:-${HOME}/.kit/sh}/commacd/commacd.sh
  elif [ -e ${SHOILERPLATE:-${HOME}/.kit/sh}/commacd/commacd.bash ]; then
    . ${SHOILERPLATE:-${HOME}/.kit/sh}/commacd/commacd.bash
  fi
}

# ***

# COMMACD_CD override, to use `pushd` not `cd`
_dxy_command_cd () {
  local dir=$1 IFS=$' \t\n'

  if [[ "$PWD" != "$dir" ]]; then
    builtin pushd "$dir" > /dev/null && pwd
  else
    echo "_dxy_command_cd: no matches found" >&2
    return 1
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  wire_commacd
  unset -f wire_commacd
}

main "$@"
unset -f main

