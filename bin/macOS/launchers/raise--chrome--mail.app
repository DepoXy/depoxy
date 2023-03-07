#!/usr/bin/osascript
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2022 Landon Bouma. All Rights Reserved.

tell application "Google Chrome"
  repeat with w in windows
    tell w
      if title of w starts with "Mail - " then
        set index to 1
        tell application "System Events" to tell process "Google Chrome"
          perform action "AXRaise" of window 1
          set frontmost to true
        end tell

        return
      end if
    end tell
  end repeat
  # Or maybe you've been logged out of Outlook.
  repeat with w in windows
    tell w
      if title of w starts with "Sign in to Outlook" then
        set index to 1
        tell application "System Events" to tell process "Google Chrome"
          perform action "AXRaise" of window 1
          set frontmost to true
        end tell

        return
      end if
    end tell
  end repeat
  # Or maybe Outlook says that you signed out of your account.
  repeat with w in windows
    tell w
      if title of w starts with "Sign out" then
        set index to 1
        tell application "System Events" to tell process "Google Chrome"
          perform action "AXRaise" of window 1
          set frontmost to true
        end tell

        return
      end if
    end tell
  end repeat
end tell

