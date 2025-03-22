# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2025 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** Neovim GUI (e.g., Neovide) and Gvim/gVim file openers

# SETUP: A few different DepoXy commands that open Neovim use the same
# socket suffix ($NVIM_OPEN_SOCKETNAME) or --servername (if you're still
# running Vim; see $GVIM_OPEN_SERVERNAME), so that the same app instance
# is targeted by those commands.
#
# - It doesn't matter too much what you name the server/socket, but it
#   should be unique among all window titles, and it should be written
#   to the Neovim `titlestring` (there's a plugin for that).
#
#   This enables the tooling to find and front the appropriate window
#   (using the appropriate DE app, e.g., xdotool, Hammerspoon, etc.).

# SETUP: The functions below assume that `gvim-open-kindness` is on PATH.
#
# - We expect the user to have "installed" it (symlinked it from
#   ~/.local/bin, and ~/.local/bin is on PATH), using the myrepos
#   action, e.g.:
#
#   mr -d ~/.kit/sh/gvim-open-kindness install
#
# - This lets us avoid using its full path, e.g.:
#
#   ${SHOILERPLATE:-${DOPP_KIT:-${HOME}/.kit}/sh}/gvim-open-kindness/bin/gvim-open-kindness

# SETUP: Ensure GVIM_OPEN_PREFER_NVIM=true so that gvim-open-kindness
# launches Neovim, not Vim. See:
#
#   ~/.kit/sh/gvim-open-kindness/bin/gvim-open-kindness
#   ~/.depoxy/running/home/.config/depoxy/depoxyrc
#
# - (I named `gvim-open-kindness` long before I added Neovim support,
#   but it's there, despite the app name!)

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE: The `fs` command is just easy to type, starts with 'f' (for 'file',
# I suppose), and so far it doesn't conflict with anything popular that I
# know about (unlike, say, `fd`).
#
# - I regularly run `fs`, `fs {file}`, or `fs <Alt-.>` when I want to edit
#   a file.

# SAVVY: Note this doesn't work to pass empty string args:
#
#   claim_alias_or_warn "fs" "gvim-open-kindness '' '' ''"
#
# - So we use a simple function instead of an alias.

# SAVVY: Note that `fs` uses the ~/.config/nvim_lazyb Neovim config,
#         and that `fa` uses the ~/.config/nvim_depoxy Neovim config.
#
# - nvim_lazyb is my new Neovim environment, based on LazyVim.
#
# - nvim_depoxy is my old Neovim environment, based on 15 years of Vim.

fs() {
  # REFER:
  # - Uses --server/socket ID: $NVIM_OPEN_SOCKETNAME.
  # - NVIM_APPNAME=nvim_lazyb refers to ~/.config/nvim_lazyb
  #     aka ~/.kit/nvim/landonb/nvim-lazyb/
  NVIM_OPEN_FILE_ON_SPAWN= \
    NVIM_APPNAME=nvim_lazyb \
    gvim-open-kindness "${NVIM_OPEN_SOCKETNAME:-🧸}" "" "" "$@"
}

# USAGE: The `fa` command was originally added so you could open
# an editor instance separate from your main instance.
# - But now it opens the author's *older* Neovim config, aka nvim-depoxy.
# - If you want to run a separate instance of whichever environment you
#   prefer, use the newer `fss` command instead (see below).
fa() {
  # REFER:
  # - Uses --server/socket ID: $DEPOXY_NVIM_ALTERNATE.
  # - NVIM_APPNAME=nvim_depoxy refers to ~/.config/nvim_depoxy
  #     aka ~/.kit/nvim/nvim-depoxy/.config/nvim/
  NVIM_APPNAME=nvim_depoxy \
    gvim-open-kindness "${DEPOXY_NVIM_ALTERNATE:-🦢}" "" "" "$@"
}

# USAGE: Run plain/stock/vanilla Neovide.
neovide--no-plugin() {
  neovide -- --listen "/tmp/nvim.socket-${DEPOXY_GVIM_NOPLUGIN:-🙅}" --noplugin &
}

# ***

# REFER: You can easily switch between Neovim distros using NVIM_APPNAME.
#
# - For instance, if you want to demo NvChad and LazyVim, you could run:
#
#   # install
#   git clone https://github.com/NvChad/NvChad   ~/.config/nvchad -d1
#   git clone https://github.com/LazyVim/starter ~/.config/lazyvim -d1
#   # run
#   NVIM_APPNAME=nvchad   nvim
#   NVIM_APPNAME=lazynvim nvim
#
# - THANX: I learned about NVIM_APPNAME from *funbike*
#          (I still haven't read all the Neovim docs!):
#   https://www.reddit.com/r/neovim/comments/1b0llw7/comment/ks8uqw6/
#   https://www.reddit.com/r/neovim/comments/1b0llw7/nvchad_vs_lazyvim/
#
# REFER: I've also added an NVD_PROFILE environ to nvim-depoxy that
# controls which plugins to load or not. (Such a feature might be
# useful if you're hunting a performance issue and aren't quite sure
# which plugin is the culprit; or maybe you want to use the same config
# for both normal development (full IDE) but also want something that's
# quicker to start (a minimal instance for, e.g., git-commit).)
#
# - This feature uses lazy.nvim to control which plugins are loaded by
#   using a table of plugin name keys and true|false values.
#
#   In the config, you'll see it used to set the `lazy` field, e.g.,
#
#     -- From ~/.config/nvim_depoxy/lua/specs/telescope.lua
#     return {
#       {
#         "nvim-telescope/telescope.nvim",
#         lazy = not lazy_profile["telescope.nvim"],
#         ...
#
# - Then pick which "profile" you want when you start Neovim, e.g.,
#
#     NVD_PROFILE=minimal gvim-open-kindness ...
#     NVD_PROFILE=complete gvim-open-kindness ...

# USAGE: The `fss` command takes 1 argument, either a file path, or
# a profile name.
#
#   fss lazy
#   # Runs: NVIM_APPNAME=nvim_lazyb nvim ...
#
#   fss
#   # Runs: NVIM_APPNAME=nvim_depoxy nvim ...
#
#   fss {path}
#   # Runs: NVIM_APPNAME=nvim_depoxy nvim {path}
#
#   fss minimal
#   # Runs: NVIM_APPNAME=nvim_depoxy NVD_PROFILE=minimal nvim ...
#
# - The `fss` command currently uses the same socket/server name
#   whenever it's run. But it could be used to start separate
#   instances each time

fss() {
  local file_or_profile="$1"

  # ISOFF: The `fss` command originally used a different socket ID
  # each time it was run. But that behavior is now opt-in. (I mostly
  # use `fss` to test config changes, e.g., I'll run `fs` to start
  # an instance for development, and then I'll run `fss lazy` to
  # test changes I make to the config (that I can't otherwise reload
  # at runtime into the `fs` instance).)
  local server_id="${DEPOXY_NVIM_TRICHOTOMY:-🐝}"
  if ${DEPOXY_NVIM_FSS_UNIQUE:-false}; then
    # REFER: Server ID is used to format gvim-open-kindness socket:
    #   printf "/tmp/nvim.socket-%s" "${server_id}"
    # DUNNO: Using 💩 or 🤡 raises same instance running as 🦢...
    # - E.g., these all raise the same Neovide instance:
    #   hs.application("🦢"):setFrontmost()
    #   hs.application("💩"):setFrontmost()
    #   hs.application("🤡"):setFrontmost()
    local server_ids="👹👺👻👽👾🤖"

    _dxy_fss_print_server_id() {
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

    server_id="$(_dxy_fss_print_server_id)"
  fi

  # USAGE: If you installed the stable and HEAD Neovim releases via
  # Homebrew, set DEPOXY_NVIM_STABLE=1 to run the latest stable release —
  # which in early 2025 is quite stale compared to the nightlies [I
  # haven't run the stable release recently, and you probably don't
  # need to, either].
  # - CALSO: Bob Neovim version manager [I haven't used Bob]:
  #   https://github.com/MordechaiHadad/bob
  # - SETUP: Don't worry about this if you only have one Neovim instance
  #   installed, or if you don't have any issues with the nightly release.
  #   Otherwise, this assumes you installed the stable release via Homebrew
  #   first, and then you unlinked it and installed the HEAD release (so
  #   that homebrew-autoupdate keeps the nightly release up to date).
  local nvim_bin=""
  if [ -n "${DEPOXY_NVIM_STABLE}" ]; then
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
    _dxy_kludge_treesitter_lib() {
      # This worked until brew-update removed the old tree-sitter version:
      #   local prev="0.24.7/lib/libtree-sitter.0.24.dylib"
      # But we can just reference the current library using the old version
      # name... and hope that there aren't any breaking changes in the API...
      local prev="0.25.3/lib/libtree-sitter.0.25.dylib"
      local curr="0.25.3/lib/libtree-sitter.0.24.dylib"
      local base="${HOMEBREW_PREFIX:-/opt/homebrew}/Cellar/tree-sitter"

      if ! [ -e "${curr}" ]; then
        command ln -sfn -- "${base}/${prev}" "${base}/${curr}"
      fi
    }
    _dxy_kludge_treesitter_lib
    nvim_bin="$(_dxy_nvim_release_bin)"
  fi

  # - Bare `fss` runs "Dubs Classic" and the DepoXy Client startup script:
  #     ~/.depoxy/running/home/vim-trap/after/plugin/startup-state.vim
  # - `fss lazy` opens newer LazyVim env. and shows snacks.nvim dashboard.
  # - `fss "[Scratch]"` runs classic config and starts with a scratch buffer.
  local open_file=""
  local profile="${file_or_profile}"
  if [ -e "${file_or_profile}" ] || [ "${file_or_profile}" = "[Scratch]" ]; then
    open_file="${file_or_profile}"
    profile=""
  fi

  # REFER:
  #   nvim_depoxy — older "Dubs Vim" config.
  #   nvim_lazyb  — newer LazyVim w/ DepoXy.
  local nvim_cfg="nvim_depoxy"
  if [ "${profile}" = "lazy" ]; then
    nvim_cfg="nvim_lazyb"
  fi

  if ${NVIM_OPEN_ECHO:-false}; then
    (
      cat << EOF
  NVD_PROFILE="${profile}" \
  NEOVIM_BIN="${nvim_bin}" \
  NVIM_OPEN_FILE_ON_SPAWN="${open_file}" \
  NVIM_APPNAME="${nvim_cfg}" \
    gvim-open-kindness "${server_id}" "" ""
EOF
    ) | sed "s/\s\+/ /g" | sed "s/^ \+//" | sed "s/\+$//"
  fi
  echo "Launching ${server_id}"

  NVD_PROFILE="${profile}" \
    NEOVIM_BIN="${nvim_bin}" \
    NVIM_OPEN_FILE_ON_SPAWN="${open_file}" \
    NVIM_APPNAME="${NVIM_APPNAME:-${nvim_cfg}}" \
    gvim-open-kindness "${server_id}" "" ""

  unset -f _dxy_fss_print_server_id
  unset -f _dxy_kludge_treesitter_lib
}

# - REFER/2025-02-22:
#   $ brew install neovim  # v0.10.4
#   # /opt/homebrew/Cellar/neovim/0.10.4/bin/nvim
#   $ brew install --HEAD neovim  # v0.11.0-dev-{sha}-Homebrew
#   # /opt/homebrew/Cellar/neovim/HEAD-228fe50_1/bin/nvim
_dxy_nvim_release_bin() {
  nvim_bin="$(
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

_dxy_alias_vim_wire_vim_minimal() {
  local nvimd="${NEOVIM_REPOS:-${DOPP_KIT:-${HOME}/.kit}/nvim}/nvim-depoxy"

  claim_alias_or_warn "vim.minimal" "${nvimd}/bin/editor-vim-0-0-insert-minimal"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases() {
  _dxy_alias_vim_wire_vim_minimal
  unset -f _dxy_alias_vim_wire_vim_minimal
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main() {
  _dxy_wire_aliases
  unset -f _dxy_wire_aliases
}

main "$@"
unset -f main
