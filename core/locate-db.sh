#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** Override findutils' `locate` to use our private locate.db.
#
# - REFER: You'll find extensive notes in the README:
#
#     ~/.depoxy/ambers/home/Library/LaunchAgents/README.rst
#
# - CXREF: See also the `updated` runner:
#
#     ~/.depoxy/ambers/bin/daily-updatedb
#
#   - Also the launchd plist:
#
#     ~/.depoxy/ambers/home/Library/LaunchAgents/com.tallybark.daily-updatedb.plist

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_locate () {
  alias locate="_hf_locate"
}

# ***

_hf_locate () {
  # USAGE: User can set custom db path any time before calling `locate`.
  local db_path="${LOCATEDB_PATH:-${HOME}/.cache/locate/locate.db}"

  if [ -f "${db_path}" ]; then
    if command -v plocate > /dev/null; then
      # Linux
      command plocate --database "${db_path}" "$@"
    elif command -v glocate > /dev/null; then
      # macOS
      command glocate --database "${db_path}" "$@"
    else
      echo "CHORE: Please install \`plocate\` (Linux) or \`glocate\` (macOS)"

      command locate "$@"
    fi
  else
    echo "CHORE: Please create (or mount) ${db_path} (or set LOCATEDB_PATH)"

    command locate "$@"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_alias_locate
  unset -f _dxy_wire_alias_locate
}

main "$@"
unset -f main

