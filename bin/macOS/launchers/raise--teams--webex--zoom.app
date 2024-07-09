#!/usr/bin/osascript
# vim:tw=0:ts=2:sw=2:et:norl:ft=applescript
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2022 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Try each app and tell it to raise. Aka *throwing spaghetti*.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# For readability, I had wanted to use application names, e.g.,
#
#   set videoApplNames to {"Webex Meetings", "Microsoft Teams", "zoom.us"}
#
# But I couldn't find an approach to determine if an application is running
# that works with the application name. But works if we use Bundle IDs.

set videoBundleIDs to {"com.webex.meetingmanager", "com.microsoft.teams", "us.zoom.xos"}

# BWARE/2022-12-06: Zoom app is untested (author does not have Zoom installed).
# - I assume this script works with Zoom, but maybe not, so if it doesn't, at
#   least you're not wondering what broke.
# - LATER: Remove this comment after confirming works with Zoom.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

repeat with bundleId in videoBundleIDs
  set processIsRunning to false
  tell application "System Events"
    set processIsRunning to ((bundle identifier of processes) contains bundleId)
    # Note you cannot `tell application` using variables within an outer `tell`
    # (not sure why; and I couldn't confirm online, just something I experienced),
    # so end-tell first, and then tell-application.
  end tell
  if processIsRunning
    tell application id bundleId to activate
  end if
end repeat

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

