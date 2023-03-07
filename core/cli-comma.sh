# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# MAYBE/2020-09-14: Stand up using completion mechanism instead:
# - Whatever is in ~/.homefries/bin/completions/ is sourced,
#   so we could create symlink from there to commacd.bash.
#   - However, this command is technically *not* a completion, so...
#     (well, if there were other instances of files being sourced
#     from our bashrc, we could create another location, say,
#     ~/.homefries/.bashrc-bin/start/, and auto-source its files
#     on startup. Just a thought).

# commacd enables directory nagivation with , ,, ,,, !!!
#   https://github.com/shyiko/commacd
#   http://shyiko.com/2014/10/10/commacd/
wire_commacd () {
  if [ -e ${SHOILERPLATE:-${HOME}/.kit/sh}/commacd/commacd.sh ]; then
    . ${SHOILERPLATE:-${HOME}/.kit/sh}/commacd/commacd.sh
  elif [ -e ${SHOILERPLATE:-${HOME}/.kit/sh}/commacd/commacd.bash ]; then
    . ${SHOILERPLATE:-${HOME}/.kit/sh}/commacd/commacd.bash
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  wire_commacd
  unset -f wire_commacd
}

main "$@"
unset -f main

