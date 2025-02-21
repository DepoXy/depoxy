# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# MSNOM: Misnomer: File named `alias-vim.sh` but better name is `funcs-vim.sh`
# - 2025-01-23: Or perhaps `boths-vim.sh` because now includes alias, too.

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
# CXREF: Runs gvim or nvim (See: GVIM_OPEN_PREFER_NVIM=true):
#   ~/.kit/sh/gvim-open-kindness/bin/gvim-open-kindness
#   ~/.depoxy/running/home/.config/depoxy/depoxyrc
#
# Note this doesn't work to pass empty string args:
#   claim_alias_or_warn "fs" "gvim-open-kindness '' '' ''"

fs () {
  # REFER: Uses --server/socket ID GVIM_OPEN_SERVERNAME.
  gvim-open-kindness "" "" "" "$@"
}

# Use the `fa` command when you want to open an editor instance
# separate from your main instance.
fa () {
  gvim-open-kindness "${DEPOXY_GVIM_ALTERNATE:-ALPHA}" "" "" "$@"
}

# CPYST: You can also run the GUI using the "minimal" plugin profile,
# e.g.,
#
#   GVIM_OPEN_INIT_VIMRC=~/.kit/nvim/nvim-depoxy/bin/editor-vim-0-0-insert-minimal.lua fs
#   GVIM_OPEN_INIT_VIMRC=~/.kit/nvim/nvim-depoxy/bin/editor-vim-0-0-insert-minimal.lua fa

# CXREF:
# ~/.kit/nvim/nvim-depoxy/bin/editor-vim-0-0-insert-minimal
# ~/.kit/nvim/nvim-depoxy/bin/editor-vim-0-0-insert-minimal.lua
# ~/.kit/nvim/nvim-depoxy/bin/editor-vim-0-0-insert-minimal.vimrc

_dxy_alias_vim_wire_vim_minimal () {
  local nvimd="${NEOVIM_REPOS:-${DOPP_KIT:-${HOME}/.kit}/nvim}/nvim-depoxy"

  claim_alias_or_warn "vim.minimal" "${nvimd}/bin/editor-vim-0-0-insert-minimal"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases () {
  _dxy_alias_vim_wire_vim_minimal
  unset -f _dxy_alias_vim_wire_vim_minimal
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_aliases
  unset -f _dxy_wire_aliases
}

main "$@"
unset -f main

