# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** Gvim/gVim file openers

# A few different DepoXy commands that open Vim all use the same
# servername (SAMPI), so that the same instance of GVim is targeted by
# those commands. The name doesn't matter (too much; you'll see it in
# the window title bar), but it should be unique among all windows for
# xdotool to identify it (so on macOS you don't have to worry).
#
# Note that `fs` and `fa` assume that `gvim-open-kindness` will be
# found on PATH. Otherwise we could specify it more completely, e.g.,
#     ${SHOILERPLATE:-${DOPP_KIT:-${HOME}/.kit}/sh}/gvim-open-kindness/bin/gvim-open-kindness
# - But we expect user called `mr -d ~/.kit/sh/gvim-open-kindness install`.

# ***

# The `fs` command is just easy to type, starts with 'f' (for 'file',
# I suppose), and so far it doesn't conflict with anything popular of
# which I know (unlike, say, `fd`). I type `fs` or `fs {file}` (or
# `fs <Alt-.>`) a lot when I want to start editing in GVim.
fs () {
  # NOTE: The servername appears in the window title bar, so you are
  #       encouraged to personalize it accordingly!
  gvim-open-kindness "${GVIM_OPEN_SERVERNAME:-SAMPI}" "" "" "$@"
}

# The `fa` command exists should you want to open a second instance
# of GVim. (I cannot remember the last time I used this command, but
# it happens.)
fa () {
  gvim-open-kindness "${DEPOXY_GVIM_ALTERNATE:-ALPHA}" "" "" "$@"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

