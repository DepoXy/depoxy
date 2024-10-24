# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020, 2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# sobriquet, aka nickname;
# aliastown, a place where aliases live;
# pseudonym, a fictitious name;
# nomdplume, a pen name.

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

# *** Change directory conveniences for common paths.

# Note: See pushd_alias_or_warn in ~/.kit/sh/home-fries/lib/path_util.sh.

_dxy_wire_aliases_pushd_paths_cdprefixed () {
  # Convention: These aliases each start with `cd`.

  # *** ~/.kit/sh/home-fries — Homefries

  # Change to Home Fries directory.
  pushd_alias_or_warn "cdh" "${HOMEFRIES_DIR:-${DOPP_KIT:-${HOME}/.kit}/sh/home-fries}"
  pushd_alias_or_warn "cdhb" "${HOMEFRIES_DIR:-${DOPP_KIT:-${HOME}/.kit}/sh/home-fries}/.bashrc-bin"
  pushd_alias_or_warn "cdhl" "${HOMEFRIES_DIR:-${DOPP_KIT:-${HOME}/.kit}/sh/home-fries}/lib"

  # *** ~/.kit — Dopp Kit

  # Change to Dev Dopp Kit directory.
  # - Note I've got a different path on my personal machine.
  # - MAYBE/2021-08-12: Check `! type` on all aliases first.
  pushd_alias_or_warn "cdk" "${DOPP_KIT:-${HOME}/.kit}"

  # *** ~/.kit/clang — Clang

  pushd_alias_or_warn "cdcl" "${DOPP_KIT:-${HOME}/.kit}/clang"

  pushd_alias_or_warn "cdcv" "${DOPP_KIT:-${HOME}/.kit}/clang/vim"

  # *** ~/.kit/git — Git

  # Change to Git projects parent directory.
  pushd_alias_or_warn "cdg" "${GITREPOSPATH:-${HOME}/.kit/git}"
  # Two-letter Dopp Kit subsir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdgi" "${DOPP_KIT:-${HOME}/.kit}/git"

  # Change to Git project directory.
  pushd_alias_or_warn "cdgg" "${GITREPOSPATH:-${HOME}/.kit/git}/git"

  # SAVVY/2024-02-26: git/cli is the `gh` command, which supersedes `hub`.
  #
  # Change to hub project directory.
  #  pushd_alias_or_warn "cdgh" "${GITREPOSPATH:-${HOME}/.kit/git}/hub"
  # Change to cli project directory.
  pushd_alias_or_warn "cdgl" "${GITREPOSPATH:-${HOME}/.kit/git}/cli"

  # ** ~/.kit/git — Git commands

  pushd_alias_or_warn "cdgb" "${GITREPOSPATH:-${HOME}/.kit/git}/git-bump-version-tag"
  pushd_alias_or_warn "cdbu" "${GITREPOSPATH:-${HOME}/.kit/git}/git-bump-version-tag"

  # Change to git-my-merge-status project directory.
  pushd_alias_or_warn "cdgm" "${GITREPOSPATH:-${HOME}/.kit/git}/git-my-merge-status"
  pushd_alias_or_warn "cdmy" "${GITREPOSPATH:-${HOME}/.kit/git}/git-my-merge-status"

  # Change to git-rebase-tip project directory.
  pushd_alias_or_warn "cdgr" "${GITREPOSPATH:-${HOME}/.kit/git}/git-rebase-tip"
  pushd_alias_or_warn "cdrt" "${GITREPOSPATH:-${HOME}/.kit/git}/git-rebase-tip"

  # Change to git-update-faithful project directory.
  pushd_alias_or_warn "cdgu" "${GITREPOSPATH:-${HOME}/.kit/git}/git-update-faithful"

  # *** ~/.kit/git — Git collections/lib

  # Change to Git-Extras project directory (not my project, but overlaps).
  pushd_alias_or_warn "cdge" "${GITREPOSPATH:-${HOME}/.kit/git}/git-extras"

  # Change to Git-Smart project directory.
  pushd_alias_or_warn "cdgs" "${GITSMARTPATH:-${GITREPOSPATH:-${HOME}/.kit/git}/git-smart}"

  # Change to sh-git-nubs project directory.
  pushd_alias_or_warn "cdgn" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs}"

  # *** ~/.kit/git — GPW

  # Change to git-put-wise project directory.
  pushd_alias_or_warn "cdpw" "${GITREPOSPATH:-${HOME}/.kit/git}/git-put-wise}"

  # Change to DepoXy-defined put-wise patches repo directory.
  # - CXREF: ~/.depoxy/ambers/core/depoxy_fs.sh
  # - Avoid tab-complete clash with `cdproject`, aka don't use original choice:
  #     pushd_alias_or_warn "cdpr" "${PW_PATCHES_REPO}"
  pushd_alias_or_warn "cdps" "${PW_PATCHES_REPO}"

  # *** ~/.kit/git — OMR

  # Change to myrepos project directory.
  pushd_alias_or_warn "cdmr" "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos"

  # Change to Oh My Repos project directory.
  pushd_alias_or_warn "cdo" "${OHMYREPOS_DIR:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos}"

  # Change to myrepos-mredit-command project directory, aka mister-mister.
  pushd_alias_or_warn "cdmm" "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command"

  # *** ~/.kit/git — TGN

  # Change to tig project directory.
  pushd_alias_or_warn "cdgt" "${GITREPOSPATH:-${HOME}/.kit/git}/tig"

  # Change to tig-newtons project directory.
  pushd_alias_or_warn "cdtn" "${GITREPOSPATH:-${HOME}/.kit/git}/tig-newtons"

  # *** ~/.kit/go — Golang

  # Two-letter Dopp Kit subsir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdgo" "${DOPP_KIT:-${HOME}/.kit}/go"

  # Prefix not to be confused with ~/.kit/git projects
  pushd_alias_or_warn "cdgh" "${DOPP_KIT:-${HOME}/.kit}/go/hugo"

  # *** ~/.kit/js — JavaScript

  # Two-letter Dopp Kit subsir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdjs" "${DOPP_KIT:-${HOME}/.kit}/js"

  pushd_alias_or_warn "cdpm" "${DOPP_KIT:-${HOME}/.kit}/js/pampermonkey"

  # *** ~/.kit/ml — (Machine Learning)

  # Two-letter Dopp Kit subsir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdml" "${DOPP_KIT:-${HOME}/.kit}/ml"

  # *** ~/.kit/mOS — macOS

  # Two-letter Dopp Kit subsir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdm" "${DOPP_KIT:-${HOME}/.kit}/mOS"
  pushd_alias_or_warn "cdmO" "${DOPP_KIT:-${HOME}/.kit}/mOS"
  pushd_alias_or_warn "cdmos" "${DOPP_KIT:-${HOME}/.kit}/mOS"

  pushd_alias_or_warn "cdmd" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-disktools"

  pushd_alias_or_warn "cdmh" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-Hammyspoony"
  # 2024-09-27: I typed `cdhs` just now before remembering `cdmh`...
  pushd_alias_or_warn "cdhs" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-Hammyspoony"

  pushd_alias_or_warn "cdmo" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-onboarder"

  # SOBVI/2024-06-25 02:49: Ha, BEGET: *urbandictionary skh* suggested *skibidi*
  pushd_alias_or_warn "cdms" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-skhibidirc"

  pushd_alias_or_warn "cdke" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/Karabiner-Elephants"

  # *** ~/.kit/odd — Odd

  pushd_alias_or_warn "cdop" "${DOPP_KIT:-${HOME}/.kit}/odd/321open"

  # *** ~/.kit/py — Python

  # Two-letter Dopp Kit subsir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdpy" "${DOPP_KIT:-${HOME}/.kit}/py"

  # 2023-05-12: Completely unnecessary; unlikely to work on this much.
  pushd_alias_or_warn "cdve" "${DOPP_KIT:-${HOME}/.kit}/py/virtualenvwrapper"

  # *** ~/.kit/sh — Shell

  # Change to Shell project directories.
  # Two-letter Dopp Kit subsir jumper.  #2letter_cdjumper
  # - USYNC: These are all synonymous: cdsh, cdks, cdksh
  pushd_alias_or_warn "cdsh" "${SHOILERPLATE:-${HOME}/.kit/sh}"

  pushd_alias_or_warn "cddi" "${SHOILERPLATE:-${HOME}/.kit/sh}/dot-inputrc"

  pushd_alias_or_warn "cdok" "${SHOILERPLATE:-${HOME}/.kit/sh}/gvim-open-kindness"

  pushd_alias_or_warn "cdet" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-err-trap"

  pushd_alias_or_warn "cdrm" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe"

  # *** ~/.kit/txt — Text

  # Two-letter Dopp Kit subsir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdtx" "${SHOILERPLATE:-${HOME}/.kit/txt}"

  pushd_alias_or_warn "cdel" "${DOPP_KIT:-${HOME}/.kit}/txt/emoji-lookup"
  # Duplicate alias, because, ya know.
  pushd_alias_or_warn "cdej" "${DOPP_KIT:-${HOME}/.kit}/txt/emoji-lookup"

  pushd_alias_or_warn "cdsp" "${DOPP_KIT:-${HOME}/.kit}/txt/spellfile.txt"

  # *** ~/.downloads

  pushd_alias_or_warn "cddl" "${DXY_DOWNLOADS_DIR:-${HF_DOWNLOADS_DIR:-${HOME}/.downloads}}"

  # *** ~/.projlns

  # Changes to ripgrep corral. (Not that I go there very often,
  # but it's nice to quickly jump there when I notice a gap in
  # an .ignore file, i.e., to resolve duplicate search results.)
  pushd_alias_or_warn "cdpj" "${DEPOXY_PROJLNS:-${HOME}/.projlns}"
  pushd_alias_or_warn "cdpjd" \
    "${DEPOXY_PROJLNS_DEPOXY:-${DEPOXY_PROJLNS:-${HOME}/.projlns}/depoxy-deeplinks}"
  pushd_alias_or_warn "cdpjm" \
    "${MREDIT_CONFIGS:-${DEPOXY_PROJLNS:-${HOME}/.projlns}/mymrconfigs}"

  # *** ~/Documents/screencaps

  pushd_alias_or_warn "cdsc" "${DEPOXY_SCREENCAPS_DIR:-${HOME}/Documents/screencaps}"
}

_dxy_wire_aliases_pushd_paths_vim () {
  # Change to Vim directories.
  #
  # - These are redundant (see `cdv` and `cdvp`) but I find them more
  #   convenient. But I'm also not sure I want to remove the other
  #   variants -- the `cd`-prefix provides a decent mnemonic. I.e.,
  #   Change-Directory-Vim is easy to think of on the spot. And it
  #   feels complete to offer all the cd-prefixed aliases, rather
  #   than convert some to shorter aliases. We can do both, right?
  #
  # - These aliases try to follow a simple mnemonic:
  #   - Each alias at least starts with a `c`, for 'Change directory'.
  #   - The following letters in the alias try to match the first
  #     character of each word (or the first and last word) in the
  #     directory path.
  #   - E.g., `cvp` changes the directory to ~/.vim/pack
  #                                             ↑   ↑
  #   - E.g., `cvs` changes the directory to ~/.vim/pack/<user>/start
  #                                             ↑               ↑

  # `cv` would be the ideal mapping, but I use that for `git commit -v`,
  # which I use far more often than cd'ing to ~/.vim.
  #
  #  pushd_alias_or_warn "cv" "${HOME}/.vim"  # `cv` taken to match `git cv`
  #
  # DCIDE/2023-01-31: Demoing `cvi` and `cvv`. `cvi` makes more sense
  # mnemonically, but `cvv` gonna be easier to smash out on your keyboard.
  pushd_alias_or_warn "cvi" "${HOME}/.vim"
  pushd_alias_or_warn "cvv" "${HOME}/.vim"
  #
  pushd_alias_or_warn "cvp" "${HOME}/.vim/pack"

  # Are you a Vim plugin author? Here's a convenient pushd to your plugs.
  # - Just set the environ from your private Bashrc, e.g.,
  #     export DEPOXY_CVS_ALIAS_VIM_PLUG_ORG=yourusername
  local cvs_alias="cvs"
  if [ -n "${DEPOXY_CVS_ALIAS_VIM_PLUG_ORG}" ]; then
    pushd_alias_or_warn "${cvs_alias}" "${HOME}/.vim/pack/${DEPOXY_CVS_ALIAS_VIM_PLUG_ORG}/start"
  elif ! type "${cvs_alias}" > /dev/null 2>&1; then
    eval "alias ${cvs_alias}='echo \"Please set DEPOXY_CVS_ALIAS_VIM_PLUG_ORG to enable this alias\"'"
  else
    >&2 echo "WARNING: Cannot alias: “${cvs_alias}” already assigned"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# 2021-07-31: Extrapolating...
_dxy_wire_aliases_pushd_paths_kit () {
  pushd_alias_or_warn "cdkcl" "${DOPP_KIT:-${HOME}/.kit}/clang"
  pushd_alias_or_warn "cdkgit" "${GITREPOSPATH:-${HOME}/.kit/git}"
  pushd_alias_or_warn "cdkgo" "${DOPP_KIT:-${HOME}/.kit}/go"
  pushd_alias_or_warn "cdkjs" "${DOPP_KIT:-${HOME}/.kit}/js"
  pushd_alias_or_warn "cdkml" "${DOPP_KIT:-${HOME}/.kit}/ml"
  pushd_alias_or_warn "cdkmos" "${MOSREPOSPATH:-${HOME}/.kit/mOS}"
  pushd_alias_or_warn "cdkpy" "${DOPP_KIT:-${HOME}/.kit}/py"
  pushd_alias_or_warn "cdksh" "${SHOILERPLATE:-${HOME}/.kit/sh}"

  # See also: GITREPOSPATH
  #  pushd_alias_or_warn "cdka" "${DOPP_KIT:-${HOME}/.kit}/ansible"
  pushd_alias_or_warn "cdkg" "${GITREPOSPATH:-${HOME}/.kit/git}"
  # pushd_alias_or_warn "cdkg" "${DOPP_KIT:-${HOME}/.kit}/golang"
  pushd_alias_or_warn "cdkj" "${DOPP_KIT:-${HOME}/.kit}/js"
  #  pushd_alias_or_warn "cdkm" "${DOPP_KIT:-${HOME}/.kit}/ml"
  pushd_alias_or_warn "cdkm" "${MOSREPOSPATH:-${HOME}/mOS}"
  pushd_alias_or_warn "cdko" "${DOPP_KIT:-${HOME}/.kit}/odd"
  pushd_alias_or_warn "cdkp" "${DOPP_KIT:-${HOME}/.kit}/py"
  # - USYNC: These are all synonymous: cdsh, cdks, cdksh
  pushd_alias_or_warn "cdks" "${SHOILERPLATE:-${HOME}/.kit/sh}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_new_window_sensible_open () {
  # (lb): This is a simple alias named 'new-window' that calls 'sensible-open'.
  # - I just find it quicker to type new-<Tab> than to type sensi<Tab>ble-<Tab>.
  # - See 'sensible-open' from github.com/landonb/sh-sensible-open
  # - For an equivalent command on linux, run:
  #     sensible-browser --new-window "$location" --profile-directory=Default > /dev/null &
  #   On macOS, you can `open` without specifying a browser, e.g.,
  #     open -n --args --new-window --incognito "$location"
  #   but not for private/incognito, where the CLI is a tad diff, e.g.,
  #     open -na "Google Chrome" --args --new-window --incognito "$location"
  #     open -na "Firefox" --args --new-window --private-window "$location"
  #   So use 'sensible-open' to figure out the appropriate command for
  #   your user's default web browser to open the location in a new window,
  #   and possibly in an incognito aka private window. Also to use the
  #   default Chrome user profile, and not the most previously used one.
  claim_alias_or_warn "new-window" "sensible-open"
  # 2021-12-18: Totally forgot about `new-window`. Which is still a lot
  # to type, `new-<Tab>`. Maybe `ww` is the one I want.
  # - TRICK/2022-03-09: Save a URL to file, e.g., a "*.lnk" file, then
  #   open from terminal, e.g., `ww $(cat some.lnk)`.
  claim_alias_or_warn "ww" "sensible-open"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases_miscellaneous () {
  # Include ASCII.
  alias hexdump="hexdump -C"

  # Include .hidden files by default on `tree`.
  # Also include .git/ subdirectories.
  alias tree="tree -a -I '.git'"

  # On macOS, for `brew install --cask libreoffice` app.
  # - soffice -> /opt/homebrew/Caskroom/libreoffice/<version>/soffice.wrapper.sh
  # - Note on LM 21.3, both exists (and symlink the same target).
  if ! command -v libreoffice > /dev/null \
    && command -v soffice > /dev/null \
  ; then
    claim_alias_or_warn "libreoffice" "soffice"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases () {
  _dxy_wire_aliases_pushd_paths_cdprefixed
  unset -f _dxy_wire_aliases_pushd_paths_cdprefixed

  _dxy_wire_aliases_pushd_paths_vim
  unset -f _dxy_wire_aliases_pushd_paths_vim

  _dxy_wire_aliases_pushd_paths_kit
  unset -f _dxy_wire_aliases_pushd_paths_kit

  _dxy_wire_alias_new_window_sensible_open
  unset -f _dxy_wire_alias_new_window_sensible_open

  _dxy_wire_aliases_miscellaneous
  unset -f _dxy_wire_aliases_miscellaneous
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_aliases
  unset -f _dxy_wire_aliases
}

main "$@"
unset -f main

