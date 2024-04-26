#!/usr/bin/osascript
# vim:tw=0:ts=2:sw=2:et:norl:ft=applescript
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2022 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# To determine what values to use, position and size a window how you
# like, and then get its properties.
#
# - E.g., after sizing and positioning the MacVim window, query it:
#
#     $ osascript
#     tell application "System Events" to get properties of window 1 of application process "MacVim"
#     ^D
#     ...
#      position:0, 28,
#      size:1921, 1052,
#     ...
#
#   ALTLY:
#
#     osascript -e 'tell application "System Events" to get properties of window 1 of application process "Google Chrome"'
#
#   Or for just the 'size':
#
#     osascript \
#       -e 'tell application "System Events" to tell process "Google Chrome"' \
#       -e "size of window 1" \
#       -e "end tell"
#
# - And then plug the values into set-the-bounds:
#
#     set the bounds ... to {x-posit, y-posit, width, height}

# SAVVY: Note You're settings *bounds*,
# not x,y,w,h, but the corners.

# Ugh, it sometimes seems like everything requires a work-around.
#
# - I tried using the values I saw in the properties, e.g.,
#
#     set the bounds of the first window to {0, 28, 1920, 1052}
#
#   but for some reason this sizes the window slightly shorter:
#
#     position:0, 28
#     size:1920, 1024
#
#   So resize to full screen size (1920 x 1080) instead, and then
#   macOS will make it shorter based on the position you specify.
#   E.g., setting height to 1080 and y-position to 28 will result
#   in actual height we want, 1052.

tell application (path to frontmost application as text)
  set the bounds of the first window to {0, 28, 1920, 1080}
end tell

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

