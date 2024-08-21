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

  if [ ! -f "${db_path}" ]; then
    echo "CHORE: Please create (or mount) ${db_path} (or set LOCATEDB_PATH)"

    command ${locate_cmd} "$@"

    return $?
  fi

  # On Linux, if the database is on a gocryptfs path (or possibly any
  # fuse mount), mlocate and plocate fail, "Permission denied".
  # - At least mlocate can take db on stdin.
  # - But plocate cannot take it on the in. And don't hope you can use
  #   process substitution instead, because <(cat ${db_path}) also fails,
  #   complaining, "pread: Illegal seek".
  # REFER: E.g., mlocate --version  # mlocate 0.26
  #              plocate --version  # plocate 1.1.15
  #              glocate --version  # locate (GNU findutils) 4.10.0
  if ! \
    command ${locate_cmd} --database "${db_path}" "$@" 2> /dev/null \
  ; then
    local locate_vers
    locate_vers="$(command ${locate_cmd} --version)"

    if [[ "${locate_vers}" = "mlocate"* ]]; then
      cat "${db_path}" | command ${locate_cmd} -d- "$@"
    elif [[ "${locate_vers}" = "plocate"* ]]; then
      # OPSEC/2024-07-31: Not the perfectist approach, but the command
      # is still fast. Alternative is for user to move the db off the fuse.
      local tmp_db="$(mktemp --suffix=".db" --tmpdir "_hf_locate-XXXXXXX")"
      command cp -- "${db_path}" "${tmp_db}"
      command ${locate_cmd} --database "${tmp_db}" "$@"
      command rm -- "${tmp_db}"
    else
      # Probably glocate, which can access db on APFS path.
      # - So unexpected path.
      # Run again, this time with stderr.
      command ${locate_cmd} --database "${db_path}" "$@"
    fi
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

