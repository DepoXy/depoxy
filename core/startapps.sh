# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2021 Landon Bouma. All Rights Reserved.

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

# Meh, there's not a better file under core/*.sh for this setup,
# and I don't want to make another file (I secretly blame having
# to source so many Bash scripts on startup as the cause of the
# 5 sec. startup time; at least when I use the HOMEFRIES_PROFILING
# switch or the completely unscientific HOMEFRIES_LOADINGDOTS prog.,
# it really seems there's just a large overhead using the `.` command.
# - Anyway, long story short, this fcn. feels a little misplaced here,
#   but this file *does* deal with startup "apps", and zoxide *is*" an
#   application... though not a macOS GUI application, whatever.

# COPYD: As deposited in ~/.bashrc by `lazyman.sh` install:
#   https://github.com/doctorfree/nvim-lazyman
_dxy_source_shell_goodies_nvim_Lazyman () {
  # ISOFF/2025-02-24: Load nvim-Lazyman manually if you care...

  # CXREF: nvim-Lazyman installs nvm to its default ~/.nvm location,
  # but DepoXy includes nvm at ~/.kit/js/nvm, so this is unnecessary
  # (see core/nvm-setup.sh).
  if ${HECK_NO:-false}; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  fi

  # ISOFF/2025-02-24: (lb): This nvim-Lazyvim shell file overwrites some
  # core commands with new aliases, e.g., `tree` and `ls` and aliased to
  # `lsd` commands. The file also uses unprefixed function names and defines
  # global vars. (e.g., $have_lsd and $fzfver, which persist in your shell).
  # - Re: `alias' setter: it changes `tree` to `lsd` (with icons, ew), it
  #   changes `ls` to `lsd` (I like my simple `ls`! and I find `lsd` more
  #   distracting), it changes `less` to `bat` (which doesn't use the
  #   pager so pollutes the terminal history, and it's also more
  #   distracting than less, e.g., it prints line numbers and horiz/vert.
  #   border lines), etc.
  # - I made some edits, like adding function prefixes (`__lazyman`),
  #   and disabling some of the alias changes. But it seems silly to
  #   add something with such grubby fingers to the mix... especially
  #   something I wouldn't run except possibly rarely to demo different
  #   Neovim distros, and even then it might just be easier to clone and
  #   call them manually, e.g.,
  #       NVIM_APPNAME=~/.config/LazyVim nvim
  #   but I do like the appeal of using Lazyman to mass-install 100+ distros
  #   to demo... though also I don't have time to demo everything! So it does
  #   probably make more sense to just do things manually when you care...
  if ${HECK_NO:-false}; then
    # Source the Lazyman shell initialization for aliases and nvims selector
    # shellcheck source=.config/nvim-Lazyman/.lazymanrc
    [ -f ~/.config/nvim-Lazyman/.lazymanrc ] && source ~/.config/nvim-Lazyman/.lazymanrc
  fi

  # ISOFF/2025-02-24: (lb): Wires <Ctrl-n> to `neovides`, or `nvims`.
  if ${HECK_NO:-false}; then
    # Source the Lazyman .nvimsbind for nvims key binding
    # shellcheck source=.config/nvim-Lazyman/.nvimsbind
    [ -f ~/.config/nvim-Lazyman/.nvimsbind ] && source ~/.config/nvim-Lazyman/.nvimsbind
  fi
}

# REFER:
# https://github.com/ajeetdsouza/zoxide#configuration
#
# --cmd
#   - Default commands are `z` and `zi`:
#       eval "$(zoxide init bash --cmd z)"
#   - ALTLY: Replace `cd`, and add `cdi`:
#       eval "$(zoxide init bash --cmd cd)"
#
# --hook <HOOK>
#   - none — Never increment directory's score
#   - prompt — At every shell prompt
#   - pwd (default) — Whenever the directory is changed
#
# --no-cmd
#   - Don't define `z` and `zi`.
#   - See: __zoxide_z, __zoxide_zi
#
# _ZO_DATA_DIR
#   - Default:
#       ~/.local/share
#       ~/Library/Application\ Support
#
# _ZO_ECHO
#   - "When set to 1, z will print the matched dir before navigating to it"
#
# _ZO_EXCLUDE_DIRS
#   - Colon-separated globs list
#   - Defaults to "$HOME"
#
# _ZO_FZF_OPTS
#   - Custom options for fzf
#
# _ZO_MAXAGE
#   - Configure the "aging algorithm", max db entries, defaults 10,000.
#
# _ZO_RESOLVE_SYMLINKS
#   - "When set to 1, z will resolve symlinks before adding dirs to the db"
_dxy_source_shell_goodies_zoxide () {
  if command -v zoxide >/dev/null; then
    eval "$(zoxide init bash)"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

_dxy_run_background_openers () {
  # *** "System tray" (Notification area) items

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

_dxy_source_shell_goodies () {
  _dxy_source_shell_goodies_nvim_Lazyman
  unset -f _dxy_source_shell_goodies_nvim_Lazyman

  _dxy_source_shell_goodies_zoxide
  unset -f _dxy_source_shell_goodies_zoxide
}

main () {
  unset -f main

  # DUNNO: I'd expect this to print the job ID, e.g.,
  #   foo () { :; }
  #   $ foo &
  #   [1] 10846
  # but it's silent.
  # - PFILE/2025-02-23: Not calling this took 0.2s off an over 5 sec.
  #   startup time... not significant considering the overall time.
  #   We can at least run in the background since it's just `open`
  #   calls.
  _dxy_run_background_openers &
  unset -f _dxy_run_background_openers

  _dxy_source_shell_goodies
  unset -f _dxy_source_shell_goodies
}

main "$@"

