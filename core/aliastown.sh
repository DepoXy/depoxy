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

_dxy_wire_aliases_pushd_paths_cdprefixed() {
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
  # Two-letter Dopp Kit subdir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdgi" "${DOPP_KIT:-${HOME}/.kit}/git"

  # Change to Git project directory.
  pushd_alias_or_warn "cdgg" "${GITREPOSPATH:-${HOME}/.kit/git}/git"
  pushd_alias_or_warn "cdkgg" "${GITREPOSPATH:-${HOME}/.kit/git}/git"

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

  # Two-letter Dopp Kit subdir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdgo" "${DOPP_KIT:-${HOME}/.kit}/go"

  # Prefix not to be confused with ~/.kit/git projects
  # - Mnemonic: cd Go Hugo
  # - MAYBE: `cdgh` (tho `cdg*` is generally Git projects)
  #          `cdhu`, `cdho`, `cdhg`, not `cdh` (home-fries)
  pushd_alias_or_warn "cdgh" "${DOPP_KIT:-${HOME}/.kit}/hugo/hugo"

  # On Netlify, Huge cache is at
  #   /opt/build/cache/hugo_cache/
  # https://gohugo.io/getting-started/configuration/#configure-cachedir
  local hugo_cache_dir=""
  if os_is_macos; then
    # Note that XDG_CACHE_CACHES is not a real thing, but we'll use
    # so it's findable if you search for XDG_.
    hugo_cache_dir="${XDG_CACHE_CACHES:-${HOME}/Library/Caches}/hugo_cache"
  else
    hugo_cache_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/hugo_cache"
  fi
  hugo_cache_dir="${HUGO_CACHEDIR:-${hugo_cache_dir}}"
  # SAVVY: 2024-11-08: At least how author has been using Hugo, the first
  # five directories each contain just one subdir. So link thereunder.
  pushd_alias_or_warn "cdhc" "${hugo_cache_dir}/modules/filecache/modules/pkg/mod"
  pushd_alias_or_warn "cdhcl" "${hugo_cache_dir}/modules/filecache/modules/pkg/mod/github.com/landonb"

  # *** ~/.kit/js — JavaScript

  # Two-letter Dopp Kit subdir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdjs" "${DOPP_KIT:-${HOME}/.kit}/js"

  pushd_alias_or_warn "cdpm" "${DOPP_KIT:-${HOME}/.kit}/js/pampermonkey"

  # *** ~/.kit/ml — (Machine Learning)

  # Two-letter Dopp Kit subdir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdml" "${DOPP_KIT:-${HOME}/.kit}/ml"

  # *** ~/.kit/mOS — macOS

  # Two-letter Dopp Kit subdir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdm" "${DOPP_KIT:-${HOME}/.kit}/mOS"
  pushd_alias_or_warn "cdmO" "${DOPP_KIT:-${HOME}/.kit}/mOS"
  pushd_alias_or_warn "cdmos" "${DOPP_KIT:-${HOME}/.kit}/mOS"

  pushd_alias_or_warn "cdmd" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-disktools"

  pushd_alias_or_warn "cdmh" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-Hammyspoony"
  # 2024-09-27: I typed `cdhs` just now before remembering `cdmh`...
  pushd_alias_or_warn "cdhs" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-Hammyspoony"

  # «Mwu-ha-ha-ha»
  pushd_alias_or_warn "cdmha" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/homebrew-autoupdate"

  # HSTRY/2026-02-11: Renamed macOS-onboarder → macOS-GNOME-onboarder.
  # - `cdmo` is historical abbrev. for original path: ~/.kit/mOS/macOS-onboarder
  # - MAYBE: Rename or find new alias. Some thoughts:
  #   - `cdgo` would be complementary, but already assigned: ~/.kit/go.
  #   - `cdmg` is available, but not very compelling.
  #     - TRYNG: We'll add `cdmg` and `cdmgo` for now, see if they get used.
  pushd_alias_or_warn "cdmo" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-GNOME-onboarder"
  pushd_alias_or_warn "cdmg" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-GNOME-onboarder"
  pushd_alias_or_warn "cdmgo" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-GNOME-onboarder"

  # SOBVI/2024-06-25 02:49: Ha, BEGET: *urbandictionary skh* suggested *skibidi*
  pushd_alias_or_warn "cdms" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-skhibidirc"

  pushd_alias_or_warn "cdke" "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/Karabiner-Elephants"

  # *** ~/.kit/nvim — Neovim and Vim plugins

  # DUPES: `cdn` and `cvp` (legacy), `cdkn`.
  pushd_alias_or_warn "cdn" "${DOPP_KIT:-${HOME}/.kit}/nvim"

  # *** ~/.kit/odd — Odd

  pushd_alias_or_warn "cdop" "${DOPP_KIT:-${HOME}/.kit}/odd/321open"

  # *** ~/.kit/py — Python

  # Two-letter Dopp Kit subdir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdpy" "${DOPP_KIT:-${HOME}/.kit}/py"

  # 2023-05-12: Completely unnecessary; unlikely to work on this much.
  pushd_alias_or_warn "cdve" "${DOPP_KIT:-${HOME}/.kit}/py/virtualenvwrapper"

  # *** ~/.kit/sh — Shell

  # Change to Shell project directories.
  # Two-letter Dopp Kit subdir jumper.  #2letter_cdjumper
  # - USYNC: These are all synonymous: cdsh, cdks, cdksh
  pushd_alias_or_warn "cdsh" "${SHOILERPLATE:-${HOME}/.kit/sh}"

  pushd_alias_or_warn "cddi" "${SHOILERPLATE:-${HOME}/.kit/sh}/dot-inputrc"

  pushd_alias_or_warn "cdgw" "${SHOILERPLATE:-${HOME}/.kit/sh}/gnome-window-calls"

  pushd_alias_or_warn "cdok" "${SHOILERPLATE:-${HOME}/.kit/sh}/gvim-open-kindness"

  pushd_alias_or_warn "cdrl" "${SHOILERPLATE:-${HOME}/.kit/sh}/raise-or-lower"

  pushd_alias_or_warn "cdet" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-err-trap"

  pushd_alias_or_warn "cdrm" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe"

  # OKILL/2025-11-12: Def. don't need all these... huh.
  pushd_alias_or_warn "cdshdi" "${SHOILERPLATE:-${HOME}/.kit/sh}/dot-inputrc"
  pushd_alias_or_warn "cdshfcr" "${SHOILERPLATE:-${HOME}/.kit/sh}/feature-coverage-report"
  pushd_alias_or_warn "cdshff" "${SHOILERPLATE:-${HOME}/.kit/sh}/fries-findup"
  pushd_alias_or_warn "cdshgwc" "${SHOILERPLATE:-${HOME}/.kit/sh}/gnome-window-calls"
  pushd_alias_or_warn "cdshgok" "${SHOILERPLATE:-${HOME}/.kit/sh}/gvim-open-kindness"
  pushd_alias_or_warn "cdshhf" "${SHOILERPLATE:-${HOME}/.kit/sh}/home-fries"
  pushd_alias_or_warn "cdshpt" "${SHOILERPLATE:-${HOME}/.kit/sh}/parT"
  pushd_alias_or_warn "cdshps" "${SHOILERPLATE:-${HOME}/.kit/sh}/password-store"
  # └─→ Related:
  pushd_alias_or_warn "cdpwd" "${HOME}/.password-store"
  pushd_alias_or_warn "cdshrol" "${SHOILERPLATE:-${HOME}/.kit/sh}/raise-or-lower"
  pushd_alias_or_warn "cdshrt" "${SHOILERPLATE:-${HOME}/.kit/sh}/reputed-tiler"
  pushd_alias_or_warn "cdshsf" "${SHOILERPLATE:-${HOME}/.kit/sh}/salvage-fiefdom"
  pushd_alias_or_warn "cdshask" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-ask-yesnoskip"
  pushd_alias_or_warn "cdshc" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors"
  pushd_alias_or_warn "cdshet" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-err-trap"
  pushd_alias_or_warn "cdshgn" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs"
  pushd_alias_or_warn "cdshhp" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-humble-prompt"
  pushd_alias_or_warn "cdshl" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger"
  pushd_alias_or_warn "cdshp" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-pather"
  pushd_alias_or_warn "cdshpnn" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-print-nanos-now"
  pushd_alias_or_warn "cdshrs" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe"
  pushd_alias_or_warn "cdshso" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-sensible-open"
  pushd_alias_or_warn "cdshsdt" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-source-deps-template"
  pushd_alias_or_warn "cdshsp" "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-spinners"
  pushd_alias_or_warn "cdshtm" "${SHOILERPLATE:-${HOME}/.kit/sh}/trust_me"

  # *** ~/.kit/txt — Text

  # Two-letter Dopp Kit subdir jumper.  #2letter_cdjumper
  pushd_alias_or_warn "cdtx" "${DOPP_KIT:-${HOME}/.kit}/txt}"

  pushd_alias_or_warn "cdej" "${DOPP_KIT:-${HOME}/.kit}/txt/emoji-lookup"
  # ISOFF/2026-02-12: Since creating 3 aliases for same path, author
  # finds they use `cdej` exclusively, and not `cdel` or `cdun`.
  # - We'll remove `cdun`, but not `cdel`, because the latter follows the
  #   typical `cd` alias convention (using the first letter of each word).
  #   - Aside: The "un" in `cdun` stands for Unicode (I think!).
  pushd_alias_or_warn "cdel" "${DOPP_KIT:-${HOME}/.kit}/txt/emoji-lookup"

  # LATER/2026-02-12: Adding 3 aliases, to see which one "sticks".
  # - While `cdnn` follows popular convention (using first letter
  #   of each word), I'd bet I'll use `cdno`.
  # - And don't really need `cdnom`, but it sounds fun.
  pushd_alias_or_warn "cdnn" "${DOPP_KIT:-${HOME}/.kit}/txt/noname-notes"
  pushd_alias_or_warn "cdno" "${DOPP_KIT:-${HOME}/.kit}/txt/noname-notes"
  pushd_alias_or_warn "cdnom" "${DOPP_KIT:-${HOME}/.kit}/txt/noname-notes"

  pushd_alias_or_warn "cdsp" "${DOPP_KIT:-${HOME}/.kit}/txt/spellfile.txt"

  # *** ~/.downloads

  pushd_alias_or_warn "cddl" "${DXY_DOWNLOADS_DIR:-${HF_DOWNLOADS_DIR:-${HOME}/.downloads}}"

  # *** ~/.local

  pushd_alias_or_warn "cdbin" "${HOME}/.local/bin"

  # *** ~/.projlns

  # Changes to ripgrep corral. (Not that I go there very often,
  # but it's nice to quickly jump there when I notice a gap in
  # an .ignore file, i.e., to resolve duplicate search results.)
  pushd_alias_or_warn "cdpj" "${DEPOXY_PROJLNS:-${HOME}/.projlns}"
  pushd_alias_or_warn "cdpjd" \
    "${DEPOXY_PROJLNS_DEPOXY:-${DEPOXY_PROJLNS:-${HOME}/.projlns}/depoxy-deeplinks}"
  pushd_alias_or_warn "cdpjm" \
    "${MREDIT_CONFIGS:-${DEPOXY_PROJLNS:-${HOME}/.projlns}/mymrconfigs}"
  # SKIPD: ~/.projlns/docs-and-backlog
  # SKIPD: ~/.projlns/sh-lib

  # *** ~/Documents/screencaps

  pushd_alias_or_warn "cdsc" "${DEPOXY_SCREENCAPS_DIR:-${HOME}/Documents/screencaps}"

  # *** macOS temp directory (with fallback Linux path)

  pushd_alias_or_warn "cdtmp" '${TMPDIR:-/tmp}'
}

_dxy_wire_aliases_pushd_paths_nvim() {
  # Change to Neovim directories.
  #
  # - These aliases try to follow a simple mnemonic:
  #
  #   - Each alias at least starts with a `c`, for 'Change directory'.
  #
  #   - And then two or three letters as they appear in sequence.
  #
  #   - E.g., `cnd` changes the directory to ~/.kit/nvim/nvim-depoxy
  #                 ↑                                    ↑    ↑
  #
  # - And though redundant, we also wire `cd`-prefix variants, to match
  #   many of the other cd-jumpers aliased in this file.

  # HSTRY/2025-01-30: Obsolete now that I've switched (finally!) to Neovim.
  #
  #  pushd_alias_or_warn "cvv" "${HOME}/.vim"

  pushd_alias_or_warn "cnd" "${DOPP_KIT:-${HOME}/.kit}/nvim/nvim-depoxy"

  # Modern Neovim config (managed by lazy.nvim, uses LazyVim as a base,
  #   incorporates select features from classic vim-depoxy).
  # `cnl` matches the `cn` prefix (">>c<<d ~/.kit/>>n<<vim").
  pushd_alias_or_warn "cnl" "${DOPP_KIT:-${HOME}/.kit}/nvim/landonb/nvim-lazyb"
  # `clz` is probably easier to remember mnemonically.
  pushd_alias_or_warn "clz" "${DOPP_KIT:-${HOME}/.kit}/nvim/landonb/nvim-lazyb"
  # "Race condition OK!" (The condition being a finger each on either hand
  #                       drilling for the 'l' and 'z' simultaneously.)
  pushd_alias_or_warn "czl" "${DOPP_KIT:-${HOME}/.kit}/nvim/landonb/nvim-lazyb"

  # Classic Vim plugin sink written in Vimscript. Still works!
  local dxy_plug="${HOME}/.kit/nvim/DepoXy/start/vim-depoxy/plugin"
  pushd_alias_or_warn "cvpd" "${dxy_plug}"
  pushd_alias_or_warn "cvd" "${dxy_plug}"
  pushd_alias_or_warn "cndp" "${dxy_plug}"

  # Are you a Vim plugin author? Here's a convenient pushd to your plugins.
  # - Just set the environ from your private Bashrc, e.g.,
  #     export DEPOXY_CD_ALIAS_NVIM_PLUG_ORG=yourusername
  # - Mnemonic: Cd Vim (user plugins) Start (directory)
  #   - Though because using Vim plugin manager (vim-pack, lazy.nvim),
  #     and no longer using ~/.vim/pack, the start/ directory doesn't
  #     technically matter. But idea is still valid, these are active,
  #     automatically loaded plugins.
  # HSTRY/2025-02-24: `cvs` is the old Vim mnemonic:
  #   - I.e., `cvs` changes the directory to ~/.vim/plug/<user>/start
  #                 ↑                           ↑               ↑
  #   local cd_alias="cvs"
  # - Let's try `cnu`, for ~/.nvim/<user>
  #              ↑            ↑     ↑
  local cd_alias="cnu"
  if [ -z "${DEPOXY_CD_ALIAS_NVIM_PLUG_ORG}" ]; then
    if ! type "${cd_alias}" > /dev/null 2>&1; then
      claim_alias_or_warn "${cd_alias}" \
        "echo 'Please set DEPOXY_CD_ALIAS_NVIM_PLUG_ORG to enable this alias'"
    else
      >&2 echo "WARNING: Cannot alias: “${cd_alias}” already assigned"
    fi
  else
    local user_plug="${HOME}/.kit/nvim/${DEPOXY_CD_ALIAS_NVIM_PLUG_ORG}"

    # Wire "cnu".
    pushd_alias_or_warn "${cd_alias}" "${user_plug}"
    # Wire "cdnu": for parity with cd-prefixed aliases.
    pushd_alias_or_warn "cdnu" "${user_plug}"
    # HSTRY/2025-02-27: Old alias, for muscle memory...
    pushd_alias_or_warn "cvs" "${user_plug}"
  fi

  # USAGE/2025-02-25: So you can search plugin sources as you learn LazyVim.
  #  pushd_alias_or_warn "cdsnl" "${HOME}/.local/share/nvim/lazy"
  #  pushd_alias_or_warn "cdsnl" "${HOME}/.local/share/nvim_depoxy/lazy"
  pushd_alias_or_warn "cdsnl" "${HOME}/.local/share/nvim_lazyb/lazy"
  pushd_alias_or_warn "cdnl" "${HOME}/.local/share/nvim_lazyb/lazy"
  pushd_alias_or_warn "cdlz" "${HOME}/.local/share/nvim_lazyb/lazy"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# 2021-07-31: Extrapolating...
_dxy_wire_aliases_pushd_paths_kit() {
  pushd_alias_or_warn "cdkcl" "${DOPP_KIT:-${HOME}/.kit}/clang"
  pushd_alias_or_warn "cdkgit" "${GITREPOSPATH:-${HOME}/.kit/git}"
  pushd_alias_or_warn "cdkgo" "${DOPP_KIT:-${HOME}/.kit}/go"
  pushd_alias_or_warn "cdkjs" "${DOPP_KIT:-${HOME}/.kit}/js"
  pushd_alias_or_warn "cdkml" "${DOPP_KIT:-${HOME}/.kit}/ml"
  pushd_alias_or_warn "cdkmos" "${MOSREPOSPATH:-${HOME}/.kit/mOS}"
  pushd_alias_or_warn "cdkpy" "${DOPP_KIT:-${HOME}/.kit}/py"
  pushd_alias_or_warn "cdkrs" "${DOPP_KIT:-${HOME}/.kit}/rust"
  pushd_alias_or_warn "cdksh" "${SHOILERPLATE:-${HOME}/.kit/sh}"

  # See also: GITREPOSPATH
  #  pushd_alias_or_warn "cdka" "${DOPP_KIT:-${HOME}/.kit}/ansible"
  pushd_alias_or_warn "cdkg" "${GITREPOSPATH:-${HOME}/.kit/git}"
  # pushd_alias_or_warn "cdkg" "${DOPP_KIT:-${HOME}/.kit}/golang"
  pushd_alias_or_warn "cdkj" "${DOPP_KIT:-${HOME}/.kit}/js"
  #  pushd_alias_or_warn "cdkm" "${DOPP_KIT:-${HOME}/.kit}/ml"
  pushd_alias_or_warn "cdkm" "${MOSREPOSPATH:-${HOME}/.kit/mOS}"
  # DUPES: `cdn` and `cvp` (legacy), `cdkn`.
  pushd_alias_or_warn "cdkn" "${DOPP_KIT:-${HOME}/.kit}/nvim"
  pushd_alias_or_warn "cdknv" "${DOPP_KIT:-${HOME}/.kit}/nvim/neovim/neovim"
  pushd_alias_or_warn "cdknd" "${DOPP_KIT:-${HOME}/.kit}/nvim/neovide/neovide"
  pushd_alias_or_warn "cdko" "${DOPP_KIT:-${HOME}/.kit}/odd"
  pushd_alias_or_warn "cdkge" "${DOPP_KIT:-${HOME}/.kit}/odd/gnome-extensions"
  pushd_alias_or_warn "cdkgn" "${DOPP_KIT:-${HOME}/.kit}/odd/gnome-extensions"
  pushd_alias_or_warn "cdkgs" "${DOPP_KIT:-${HOME}/.kit}/odd/gnome-shell"
  pushd_alias_or_warn "cdkof" "${DOPP_KIT:-${HOME}/.kit}/odd/fonts"
  pushd_alias_or_warn "cdkp" "${DOPP_KIT:-${HOME}/.kit}/py"
  pushd_alias_or_warn "cdkr" "${DOPP_KIT:-${HOME}/.kit}/rust"
  # - USYNC: These are all synonymous: cdsh, cdks, cdksh
  pushd_alias_or_warn "cdks" "${SHOILERPLATE:-${HOME}/.kit/sh}"
  # CALSO: `cdtx` (which author !remembers (are rarely goes there anyway)).
  pushd_alias_or_warn "cdkt" "${DOPP_KIT:-${HOME}/.kit}/txt}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_new_window_sensible_open() {
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
  # HSTRY/2026-04-20: I finally type `ww.` and not `ww .`, might as well support it.
  claim_alias_or_warn "ww." "sensible-open ."
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_batcat() {
  # ALTLY:
  #   if ! [ -e "${HOMEBREW_PREFIX}/bin/bat" ]; then
  if ! command -v bat > /dev/null; then
    claim_alias_or_warn "bat" "batcat"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# OWELL/2025-11-12: Not sure the best location for this low-value feature.
# - Neither Homefries nor DepoXy/core has a "miscellaneous" shell script.
# - This only really fits here because it's technically an alias, but it
#   could just as easily by a shell function, or its own DXY/bin command.

# SAVVY: `cat<Tab>` shows `cat`, and `catman` (from man-db APT package
# on GNU/Linux, or man-db Homebrew formula), so we'll claim `catfstab`
# which won't conflict with existing <Tab> completion options, but
# rather complements existing options.

# REFER: As inspired by `man column` itself, after author noticing that
# each row of /etc/fstab on fresh Debian 13 is so differently formatted
# (different number of spaces between columns).
# - Not that reading just a few lines of /etc/fstab is that difficult,
#   but author does appreciate formatting (and it gives me an excuse
#   to use `column`, which I don't think I've ever used before).

# REFER: A few ways to remove/trim leading and trailing whitespace:
#   | sed 's/^ \+//g' | sed 's/ \+$//g'  # My natural instinct
#   | sed 's/^ \+//g;s/ \+$//g'          # I always forget about;mushing
#   | awk '{$1=$1;print}'                # Oh, tricky awk...
#   | awk '{$1=$1};1'                    # ... so tricky! (least readable/obvious)
# - Close, but removes single- and double-quotes:
#   | xargs  # WRONG
# THANX:
# https://unix.stackexchange.com/questions/102008/
#   how-do-i-trim-leading-and-trailing-whitespace-from-each-line-of-some-output

_dxy_wire_alias_catfstab() {
  claim_alias_or_warn "catfstab" "$(
    echo "
      sed 's/#.*//' /etc/fstab \
        | column \
          --table \
          --table-columns SOURCE,TARGET,TYPE,OPTIONS,FREQ,PASS \
          --table-right FREQ,PASS" \
      | sed 's/ \+/ /g' | sed 's/^ \+//g;s/ \+$//g' \
      | xargs
  )"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# HSTRY/2026-05-12: These commands are really more of a demo than a test...
# (though one might run them to verify — aka test — that shell colors work).
# - In author's shell, `dem<Tab>` has no other hits than these aliases;
#   whereas `test<Tab>` has 7 completions (including coreutil's /bin/test).
# - Also complements (name-wise) the new (from today) demo-pygmentize script:
#
# REFER: ~/.kit/sh/sh-colors/bin/
_dxy_wire_alias_demo_colors() {
  # ALTLY: To not rely on PATH setup (and DepoXy core/ startup timing):
  #   local shcb="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-colors/bin"
  #   if [ -d "${shcb}" ]; then
  #     claim_alias_or_warn "demo-colors" "${shcb}/test-colors"
  #     claim_alias_or_warn "demo-truecolor" "${shcb}/test-truecolor"
  #   fi
  if command -v test-colors > /dev/null; then
    claim_alias_or_warn "demo-colors" "test-colors"
    claim_alias_or_warn "demo-truecolor" "test-truecolor"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_hexdump() {
  # Include ASCII.
  claim_alias_or_warn "hexdump" "hexdump -C" ${_force:-true}
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Wire LibreOffice aliases for macOS (`brew install --cask libreoffice`).
# - Note on LM 21.3, LibreOffice is installed by default, and both
#   `libreoffice` and `soffice` are on PATH (and both symlink the same
#   target).

# DUNNO/2024-11-05: I had LibreOffice symlinked from ~/.local/bin, e.g.:
#
#   _MOSON_SOFFICE="/Applications/LibreOffice.app/Contents/MacOS/soffice"
#   command ln -sfn '${_MOSON_SOFFICE}' '${HOME}/.local/bin/libreoffice'
#   command ln -sfn '${_MOSON_SOFFICE}' '${HOME}/.local/bin/soffice'
#
# But then calling `soffice` opens it but shows the Alacritty menubar!
#
# Thankfully, using an alias and calling the path directly seems to work.

_dxy_wire_alias_libreoffice() {
  if ! os_is_macos; then

    return 0
  fi

  local macOS_soffice="/Applications/LibreOffice.app/Contents/MacOS/soffice"

  claim_alias_or_warn "soffice" "${macOS_soffice}"

  claim_alias_or_warn "libreoffice" "${macOS_soffice}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# CXREF/2026-05-23:
# ~/.depoxy/ambers/bin/lipsum
_dxy_wire_alias_lorem_ipsum() {
  claim_alias_or_warn "lorem-ipsum" "lipsum"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# CXREF/2026-02-17:
# ~/.kit/sh/raise-or-lower/bin/lower-all
# ~/.kit/sh/raise-or-lower/bin/raise-all
_dxy_wire_alias_raise_lower() {
  claim_alias_or_warn "lower-all-chrome" "lower-all google-chrome"
  claim_alias_or_warn "raise-all-chrome" "raise-all google-chrome"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_tree() {
  # Include .hidden files by default on `tree`.
  # Also include .git/ subdirectories.
  claim_alias_or_warn "tree" "tree -a -I '.git'" ${_force:-true}
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# FEATR/2025-10-05: Just a silly countdown timer with toast on completion.
# - Note the toast lingers until dismissed.
# - UCASE: Author mostly uses this as reminder to unplug devices (phone,
#   headphones) charging on USB power, so I don't over-charge 'em.
# - REFER: `countdown` installed via install-homebrew.sh from mOSGo:
#     https://github.com/DepoXy/macOS-GNOME-onboarder#🏂
_dxy_wire_alias_wire_countdown_and_notify() {
  _dxy_countdown_and_notify() {
    local time="${1:-60s}"

    # REFER: https://www.dailyscript.com/scripts/A+Clockwork+Orange.pdf
    # local msg="${DEPOXY_COUNTDOWN_MESSAGE:-A nozh scrap any time you say.}"
    local msg="${DEPOXY_COUNTDOWN_MESSAGE:-Long time no viddy, droog. How goes? Surprised are you?}"

    countdown "${time}" \
      && notify "${msg}"
  }

  claim_alias_or_warn "timer" "_dxy_countdown_and_notify"
  # ALIAS/2026-02-03: I just ran `countdown`, because that seems more obvious,
  # and I forgot it was at `timer`, but `countdown` doesn't alert on finish.
  claim_alias_or_warn "countdown-alarm" "_dxy_countdown_and_notify"
  # MAYBE/2026-02-03: Ha, what about `alarm`? Or `alarm-countdown`?
  claim_alias_or_warn "alarm" "_dxy_countdown_and_notify"

  # UCASE: Teabagging.
  claim_alias_or_warn "2m" "_dxy_countdown_and_notify 2m"
  claim_alias_or_warn "4m" "_dxy_countdown_and_notify 4m"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_obs() {
  # ALTLY:
  #  claim_alias_or_warn "obsproject" "flatpak run com.obsproject.Studio"
  claim_alias_or_warn "obs" "flatpak run com.obsproject.Studio"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases() {
  _dxy_wire_aliases_pushd_paths_cdprefixed
  unset -f _dxy_wire_aliases_pushd_paths_cdprefixed

  _dxy_wire_aliases_pushd_paths_nvim
  unset -f _dxy_wire_aliases_pushd_paths_nvim

  _dxy_wire_aliases_pushd_paths_kit
  unset -f _dxy_wire_aliases_pushd_paths_kit

  _dxy_wire_alias_new_window_sensible_open
  unset -f _dxy_wire_alias_new_window_sensible_open

  _dxy_wire_alias_batcat
  unset -f _dxy_wire_alias_batcat

  _dxy_wire_alias_catfstab
  unset -f _dxy_wire_alias_catfstab

  _dxy_wire_alias_demo_colors
  unset -f _dxy_wire_alias_demo_colors

  _dxy_wire_alias_hexdump
  unset -f _dxy_wire_alias_hexdump

  _dxy_wire_alias_libreoffice
  unset -f _dxy_wire_alias_libreoffice

  _dxy_wire_alias_lorem_ipsum
  unset -f _dxy_wire_alias_lorem_ipsum

  _dxy_wire_alias_raise_lower
  unset -f _dxy_wire_alias_raise_lower

  _dxy_wire_alias_tree
  unset -f _dxy_wire_alias_tree

  _dxy_wire_alias_wire_countdown_and_notify
  unset -f _dxy_wire_alias_wire_countdown_and_notify

  _dxy_wire_alias_obs
  unset -f _dxy_wire_alias_obs
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main() {
  _dxy_wire_aliases
  unset -f _dxy_wire_aliases
}

main "$@"
unset -f main
