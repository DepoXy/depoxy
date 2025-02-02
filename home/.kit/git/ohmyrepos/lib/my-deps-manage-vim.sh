#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# ========================================================================
# ------------------------------------------------------------------------

# CXREF/2025-01-22: For notes on update-faithful and updateDeps, see:
#
#   ~/.depoxy/ambers/home/.kit/git/ohmyrepos/lib/my-deps-manage-shoilerplate.sh

# ========================================================================
# ------------------------------------------------------------------------

update_deps_vim () {
  local vim_packpath="${VIM_PACKPATH:-${HOME}/.kit/nvim/}"

  update_faithful_finish_signed () {
    local sourcerer="https://github.com/DepoXy/depoxy/blob/release/home/.kit/git/ohmyrepos/lib/my-deps-manage-shoilerplate.sh"

    update_faithful_finish "${sourcerer}"
  }

  update_deps_vim_pack_junegunn_vim_plug () {
    local pack_subpath="$1"

    [ -f ".vim/deps/${pack_subpath}" ] || return 0

    local plugin_root="${vim_packpath}/${pack_subpath}"

    export UPDEPS_CANON_BASE_ABSOLUTE="${plugin_root}"

    update_faithful_file \
      ".vim/deps/${pack_subpath}" \
      "$(basename -- "${pack_subpath}")"

    update_faithful_finish_signed
  }

  update_deps_vim_pack_junegunn_vim_plug () {
    update_deps_vim_pack_plugin "junegunn/start/vim-plug/plug.vim"
  }

  update_deps_vim_pack_tpope_vim_pathogen () {
    update_deps_vim_pack_plugin "tpope/opt/vim-pathogen/autoload/pathogen.vim"
  }

  # Ensure symlinks exist.
  mr -d . -n infusePostRebase

  update_deps_vim_pack_junegunn_vim_plug
  # update_deps_vim_pack_tpope_vim_pathogen
}

# ========================================================================
# ------------------------------------------------------------------------

link_hard_dep_vim_pack_junegunn_vim_plug () {
  link_hard "${VIM_PACKPATH:-${HOME}/.kit/nvim}/junegunn/start/vim-plug/plug.vim" \
    ".vim/deps/junegunn/start/vim-plug/plug.vim"
}

link_hard_dep_vim_pack_tpope_vim_pathogen () {
  link_hard "${VIM_PACKPATH:-${HOME}/.kit/nvim}/tpope/opt/vim-pathogen/autoload/pathogen.vim" \
    ".vim/deps/tpope/start/vim-pathogen/autoload/pathogen.vim"
}

# ========================================================================
# ------------------------------------------------------------------------

