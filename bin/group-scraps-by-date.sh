#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright © 2025 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# THANX: Stéphane Chazelas
# https://unix.stackexchange.com/questions/319365/get-list-of-files-group-by-date

# Prints, e.g.,
#   mkdir 'Dec_25' && mv
#     './scrap 2024-12-25 at 18.00.11.png'
#     './scrap 2024-12-25 at 18.00.38.png'
#     ...
#     'Dec_25'

# USAGE:
# # Review script
# ~/.depoxy/ambers/bin/group-scraps-by-date.sh
# # Run script
# ~/.depoxy/ambers/bin/group-scraps-by-date.sh | /bin/sh

group_scraps_by_date() {
  # find . ! -name . -prune ! -name '.*' -printf '%Tb_%Td:%p\0' |
  find . ! -name . -prune ! -name '.*' -printf '%TY-%Tm-XX:%p\0' |
    awk -v RS='\0' -F : -v q=\' '
      function quote(s) {
        gsub(q, q "\\" q q, s)
        return q s q
      }
      {
        # print "date: " $1
        date=$1
        sub(/[^:]*:/, "", $0)
        files[date] = files[date] " " quote($0)
      }
      END {
        for (date in files)
          # print "tar zcvf " quote(date ".tar.gz") files[date]
          print "mkdir " quote(date) " && mv " files[date] " " quote(date)
      }'
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

PROG_NAME="group-scraps-by-date.sh"

main() {
  group_scraps_by_date
}

# Run the command unless being sourced.
if [ "$(basename -- "$(realpath -- "$0")")" = "${PROG_NAME}" ]; then
  main "$@"
fi

unset -f main
