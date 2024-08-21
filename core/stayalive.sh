# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Use case: Prevent unchageable Enterprise (e.g., Jamf) settings from
# logging you off (e.g., when taking a short bio break).
#
# USAGE: Enable from your private Bashrc, e.g.,
#
#   # Enable only caffeinate (this is all you need).
#   export DEPOXY_ENABLE_KEEP_ALIVE_CAFFEINATE=true
#
#   # Enable only pmset (deprecated; caffeinate should work instead).
#   export DEPOXY_ENABLE_KEEP_ALIVE_PMSET=true
#
#   # Enable both caffeinate and pmset.
#   export DEPOXY_ENABLE_KEEP_ALIVE=true

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# CXREF: man 8 caffeinate
_dxy_start_background_apps_macos_caffeinate () {
  [ "$(uname)" = "Darwin" ] || return

  ${DEPOXY_ENABLE_KEEP_ALIVE:-false} ||
  ${DEPOXY_ENABLE_KEEP_ALIVE_CAFFEINATE:-false} ||
    return 0

  if ! type caffeinate > /dev/null 2>&1; then
    >&2 echo
    >&2 echo "ERROR: Please install ‘caffeinate’"

    return 1
  fi

  # 2021-04-26: See comment above re: pgrep vs. pkill.
  #   pgrep -f "caffeinate -du -t 1860000" > /dev/null 2>&1 && return
  pkill caffeinate

  mkdir -p "${HOME}/.noise"
  nohup caffeinate -du -t 1860000 > "${HOME}/.noise/caffeinate_history" 2>&1 &
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# CXREF: man pmset
# SAVVY: To see current settings (shows what caffeinate prevents): pmset -g
# DEPRECATED: Per `man pmset`:
#   noidle ... is deprecated in favor of caffeinate(8).
#     Please use caffeinate(8) instead.
_dxy_start_background_apps_macos_pmset () {
  [ "$(uname)" = "Darwin" ] || return

  ${DEPOXY_ENABLE_KEEP_ALIVE:-false} ||
  ${DEPOXY_ENABLE_KEEP_ALIVE_PMSET:-false} ||
    return 0

  if ! type pmset > /dev/null 2>&1; then
    >&2 echo
    >&2 echo "ERROR: Please install ‘pmset’"

    return 1
  fi

  # 2021-04-26: I had this set just to return:
  #   pgrep -f "pmset noidle -u" > /dev/null 2>&1 && return
  # but then you have to wait until one exits to be able to
  # just open a terminal to reset the keep-alives, so kill't
  # instead.
  pkill pmset

  mkdir -p "${HOME}/.noise"
  nohup pmset noidle -u > "${HOME}/.noise/pmset_history" 2>&1 &
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_start_background_apps_macos_keep_awake () {
  _dxy_start_background_apps_macos_pmset
  unset -f _dxy_start_background_apps_macos_pmset

  _dxy_start_background_apps_macos_caffeinate
  unset -f _dxy_start_background_apps_macos_caffeinate
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  unset -f main

  _dxy_start_background_apps_macos_keep_awake
  unset -f _dxy_start_background_apps_macos_keep_awake
}

main "$@"

