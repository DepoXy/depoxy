# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2021 Landon Bouma. All Rights Reserved.

# MAYBE/2021-03-11: Run this file from Bashrc, rather than source,
# then you can remove the `unset -f` calls.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_start_background_apps_macos_alttab () {
  ${DEPOXYAMBERS_AUTO_START_ALTTAB:-true} || return 0

  local alttab_app="/Applications/AltTab.app"

  [ -d "${alttab_app}" ] || return

  # This works:
  #   ps x | grep -q -e " /Applications/AltTab.app/Contents/MacOS/AltTab$" && return
  # This is possibly more readable, and just as reliable in practice:
  pgrep "AltTab" > /dev/null 2>&1 && return

  open "${alttab_app}"
}

_dxy_start_background_apps_macos_easy_move_plus_resize () {
  ${DEPOXYAMBERS_AUTO_START_EASY_MOVE_PLUS_RESIZE:-true} || return 0

  local ezmove_app="/Applications/Easy Move+Resize.app"

  [ -d "${ezmove_app}" ] || return

  # This works:
  #   ps x | grep -q -e " /Applications/Easy Move+Resize.app/Contents/MacOS/Easy Move+Resize$" && return
  # This is possibly more readable, and just as reliable in practice:
  pgrep "Easy Move\+Resize" > /dev/null 2>&1 && return

  open "${ezmove_app}"
}

_dxy_start_background_apps_macos_karabiner_elements () {
  ${DEPOXYAMBERS_AUTO_START_KARABINER_ELEMENTS:-true} || return 0

  local ke_app="/Applications/Karabiner-Elements.app"

  [ -d "${ke_app}" ] || return

  # There are a number of KE components that run, e.g., I see 8 processes
  # when I run `ps ax | grep -i karabiner` (only half if just `ps x | ...`).
  #   /Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_grabber
  #   .../bin/karabiner_console_user_server
  #   .../Karabiner-NotificationWindow.app/Contents/MacOS/Karabiner-NotificationWindow
  #   .../Karabiner-Menu.app/Contents/MacOS/Karabiner-Menu
  #   etc.
  # This works:
  #   ps x | grep -q -e " /Library/Application Support/org.pqrs/Karabiner-Elements" && return
  # This is possibly more readable, and just as reliable in practice.
  # - Not that I know anything about the 8 separate processes, but I assume
  #   we can assume that either they're all running, or none are, so we only
  #   need to check one of them, and I choose the grabber, whatever that is.
  pgrep "karabiner_grabber" > /dev/null 2>&1 && return

  open "${ke_app}"
}

_dxy_start_background_apps_macos_rectangle () {
  ${DEPOXYAMBERS_AUTO_START_RECTANGLE:-true} || return 0

  local rectangle_app="/Applications/Rectangle.app"

  [ -d "${rectangle_app}" ] || return

  # This works:
  #   ps x | grep -q -e " /Applications/Rectangle.app/Contents/MacOS/Rectangle$" && return
  # This is possibly more readable, and just as reliable in practice:
  pgrep "Rectangle" > /dev/null 2>&1 && return

  open "${rectangle_app}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Use case: Get a quick overview of system usage by glancing at the Dock.
#
# USAGE: The Activity Monitor window comes to front when you start the first
# terminal session after a reboot (or after earlier quiting Activity Monitor).
# - Just close the window (click the red (x) in the title bar; or type Cmd-w).

_dxy_start_background_apps_macos_activity_monitor () {
  local actmon_app="/System/Applications/Utilities/Activity Monitor.app"

  [ -d "${actmon_app}" ] || return

  # Look for the process, e.g.:
  #   /System/Applications/Utilities/Activity Monitor.app/Contents/MacOS/Activity Monitor
  #   /System/Applications/Utilities/Activity Monitor.app/Contents/MacOS/Activity Monitor -psn_0_196656
  # This works:
  #   ps x | grep -q -e "MacOS/Activity Monitor\($\| \-\)" && return
  # This is possibly more readable, and just as reliable in practice:
  pgrep "Activity Monitor" > /dev/null 2>&1 && return

  open "${actmon_app}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  unset -f main

  # System tray items

  _dxy_start_background_apps_macos_alttab
  unset -f _dxy_start_background_apps_macos_alttab

  _dxy_start_background_apps_macos_easy_move_plus_resize
  unset -f _dxy_start_background_apps_macos_easy_move_plus_resize

  _dxy_start_background_apps_macos_karabiner_elements
  unset -f _dxy_start_background_apps_macos_karabiner_elements

  _dxy_start_background_apps_macos_rectangle
  unset -f _dxy_start_background_apps_macos_rectangle

  # *** Dock item(s)

  _dxy_start_background_apps_macos_activity_monitor
  unset -f _dxy_start_background_apps_macos_activity_monitor
}

main "$@"

