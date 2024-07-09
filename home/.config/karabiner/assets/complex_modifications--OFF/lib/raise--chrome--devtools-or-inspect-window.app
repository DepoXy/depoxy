#!/usr/bin/osascript
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020 Landon Bouma. All Rights Reserved.

tell application "Google Chrome"
  repeat with w in windows
    tell w
      repeat with t in tabs
        if title of t is equal to "DevTools" then
          set index to 1
          tell application "System Events" to tell process "Google Chrome"
            perform action "AXRaise" of window 1
            set frontmost to true
          end tell
          return
        end if
      end repeat
    end tell
  end repeat
  repeat with w in windows
    tell w
      repeat with t in tabs
        if title of t is equal to "Inspect with Chrome Developer Tools" then
          set index to 1
          tell application "System Events" to tell process "Google Chrome"
            perform action "AXRaise" of window 1
            set frontmost to true
          end tell
          return
        end if
      end repeat
    end tell
  end repeat
  repeat with w in windows
    tell w
      if title of w starts with "devtools://" then
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

