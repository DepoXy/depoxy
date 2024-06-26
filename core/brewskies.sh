# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2021-2022 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# - BWARE: If you prepend the brew path too soon, it makes some commands
#   run really slowly, including the git-my-merge-status command from
#   another project I publish. I have no idea, and I did not investigate
#   further, I just got lucky reordering this call so that pyenv paths are
#   prepended after brew paths (so that pyenv `python3` is preferred
#   over brew's `python3`, and then I saw that some formerly slow
#   commands were running full tilt again (aka, I got lucky!)).
#   - AFAICT, macOS built-in Bash v3 fairly speedy, but Homebrew Bash v5
#     slow. It seems like Bash v5 is slow *sourcing* files. Which might
#     be a macOS thing, like opening and/or reading files from disk is
#     slow. It also be specific to Apple Silicon/AArch64/arm64/M1 Macs,
#     because I don't remember seeing this issue on older Intel MacBook.
#   - I also tried NixOS Bash, but NixOS Bash also slow. https://nixos.org

_depoxy_print_homebrew_path () {
  # Apple Silicon (M1 Mac/arm64/AArch64) brew path is /opt/homebrew.
  local brew_bin="/opt/homebrew/bin"

  # Otherwise on Intel Macs it's under /usr/local.
  [ -d "${brew_bin}" ] || brew_bin="/usr/local/bin"

  local brew_path="${brew_bin}/brew"

  [ -x "${brew_path}" ] || brew_path=""

  printf "%s" "${brew_path}"
}

# Set Homebrew environs: HOMEBREW_PREFIX, HOMEBREW_CELLAR,
# HOMEBREW_REPOSITORY, PATH, MANPATH, and INFOPATH.
infuse_brew_shellenv () {
  local brew_path="$(_depoxy_print_homebrew_path)"

  if [ -e "${brew_path}" ]; then
    eval "$(${brew_path} shellenv)"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  infuse_brew_shellenv
}

if [ -n "${BASH_SOURCE}" ] && [ "$0" != "${BASH_SOURCE[0]}" ]; then
  main "$@"
# else, being sourced, or executed by not Bash.
fi

unset -f main

