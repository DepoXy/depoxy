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

# ***

fss () {
  local profile="$1"

  # REFER: Server ID used to format gvim-open-kindness socket:
  #   printf "/tmp/nvim.socket-%s" "${server_id}"
  # DUNNO: Using 💩 or 🤡 raises instance running as 🦢...
  #   local server_ids="💩🤡"
  local server_ids="👹👺👻👽👾🤖"

  _dxy_fss_print_server_id () {
    local app_cfg_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/depoxy/ambers"
    local cfg_ids_file="${app_cfg_dir}/neovim.ids"

    mkdir -p -- "${app_cfg_dir}"

    if ! [ -e "${cfg_ids_file}" ] \
      || ! [ -s "${cfg_ids_file}" ] \
      || [ -z "$(cat -- "${cfg_ids_file}")" ] \
    ; then
      echo "${server_ids}" > "${cfg_ids_file}"
    fi

    local server_id
    server_id="$(cat "${cfg_ids_file}" | cut -c1)"

    cat "${cfg_ids_file}" | cut -c2- | sed '/\s/d' > "${cfg_ids_file}.tmp"

    command mv -f "${cfg_ids_file}"{.tmp,}

    printf "%s" "${server_id}"
  }

  # - REFER/2025-02-22:
  #   $ brew install neovim  # v0.10.4
  #   # /opt/homebrew/Cellar/neovim/0.10.4/bin/nvim
  #   $ brew install --HEAD neovim  # v0.11.0-dev-{sha}-Homebrew
  #   # /opt/homebrew/Cellar/neovim/HEAD-228fe50_1/bin/nvim
  _dxy_print_latest_bin_nvim_path () {
    nvim_bin="$( \
      find "${HOMEBREW_PREFIX}/Cellar/neovim/" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -not -name "HEAD*" \
        | sort -V \
        | tail -1
    )"

    if [ -z "${nvim_bin}" ]; then
      >&2 echo "ERROR: Latest nvim release not found under: ${HOMEBREW_PREFIX}/Cellar/neovim/"

      return
    fi

    printf "%s" "${nvim_bin}/bin/nvim"
  }

  # KLUGE/2025-02-22: There's gotta be a better way to do this...
  # - Or maybe I should just be thankful that this works!
  #
  #   $ neovide --neovim-bin /opt/homebrew/Cellar/neovim/0.10.4/bin/nvim \
  #     -- --listen /tmp/nvim.socket-👽
  #   ERROR [neovide::error_handling] Neovide just crashed :(
  #   This is the error that caused the crash. In case you don't know what
  #     to do with this, please feel free to report this on
  #     https://github.com/neovide/neovide/issues!
  #
  #   ERROR: Unexpected output from neovim binary:
  #     /opt/homebrew/Cellar/neovim/0.10.4/bin/nvim -v
  #   stdout:
  #   stderr: dyld[65588]: Library not loaded:
  #     /opt/homebrew/opt/tree-sitter/lib/libtree-sitter.0.24.dylib
  #     Referenced from: <5476F149-4D25-3E75-A787-A24715A11CD0>
  #       /opt/homebrew/Cellar/neovim/0.10.4/bin/nvim
  #     Reason: tried: '/opt/homebrew/opt/tree-sitter/lib/libtree-sitter.0.24.dylib'
  #       (no such file), '/System/Volumes/Preboot/Cryptexes/OS/opt/homebrew/...'...
  #
  #   Please check your shell configuration.
  #   $SHELL -lc '{bin} -v'
  # USYNC: ~/.depoxy/ambers/home/.kit/nvim/_mrconfig
  _dxy_kludge_treesitter_lib () {
    local prev="0.24.7/lib/libtree-sitter.0.24.dylib"
    local curr="0.25.2/lib/libtree-sitter.0.24.dylib"
    local base="${HOMEBREW_PREFIX:-/opt/homebrew}/Cellar/tree-sitter"

    if ! [ -e "${curr}" ]; then
      command ln -sfn -- "${base}/${prev}" "${base}/${curr}"
    fi
  }

  local server_id
  server_id="$(_dxy_fss_print_server_id)"

  # - Bare `fss` opens Dubs Classic and runs the startup script:
  #     ~/.depoxy/running/home/vim-trap/after/plugin/startup-state.vim
  # - `fss lazy` opens LazyVim to splash screen (whatever it's called).
  # - Another option might be a scratch buffer: open_file="[Scratch]"
  local nvim_bin=""
  local open_file=""
  if [ -z "${profile}" ]; then
    nvim_bin="$(_dxy_print_latest_bin_nvim_path)"
    open_file="${NVIM_OPEN_FILE_ON_SPAWN}"
    _dxy_kludge_treesitter_lib
  fi

  if false; then
    ( cat <<EOF
    NVD_PROFILE="${profile}" \
    NEOVIM_BIN="${nvim_bin}" \
    NVIM_OPEN_FILE_ON_SPAWN="${open_file}" \
      gvim-open-kindness "${server_id}" "" ""
EOF
    ) | sed "s/\s\+/ /g" | sed "s/^ \+//" | sed "s/\+$//"
  fi
  echo "Launching ${server_id}"

  NVD_PROFILE="${profile}" \
  NEOVIM_BIN="${nvim_bin}" \
  NVIM_OPEN_FILE_ON_SPAWN="${open_file}" \
    gvim-open-kindness "${server_id}" "" ""

  unset -f _dxy_fss_print_server_id
  unset -f _dxy_print_latest_bin_nvim_path
  unset -f _dxy_kludge_treesitter_lib
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

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

