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

  local locate_cmd="$(_hf_locate_command)"

  if [ "${locate_cmd}" = "mlocate" ]; then
    echo "CHORE: Please install \`plocate\` (Linux) or \`glocate\` (macOS)"
  fi

  if [ -f "${db_path}" ]; then
    command ${locate_cmd} --database "${db_path}" "$@"
  else
    echo "CHORE: Please create (or mount) ${db_path} (or set LOCATEDB_PATH)"

    command ${locate_cmd} "$@"
  fi
}

# Linux uses `plocate` (old Lunux uses `mlocate`); Brew installs `glocate`.
# - Don't `command -v locate` which is the alias.
_hf_locate_command () {
  command -v plocate || command -v glocate || command -v mlocate || echo locate
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_alias_locate
  unset -f _dxy_wire_alias_locate
}

main "$@"
unset -f main

