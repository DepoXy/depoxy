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
  local brew_path=""

  # Apple Silicon (M1 Mac/arm64/AArch64) brew path is /opt/homebrew.
  [ -x "${brew_path}" ] || brew_path="/opt/homebrew/bin/brew"

  # Otherwise on Intel Macs it's under /usr/local.
  [ -x "${brew_path}" ] || brew_path="/usr/local/bin/brew"

  # DepoXy insists that Homebrew is installed on macOS, but it's
  # not a requirment on Linux.
  # - 2024-11-12: DepoXy Linux now installs Homebrew for *lazydocker*,
  #   but Homebrew on Linux in still a soft requirement (unlike macOS).
  if [ ! -x "${brew_path}" ] && os_is_macos; then
    >&2 echo "ERROR: Where's the \`brew\` executable?"

    return 1
  fi

  printf "%s" "${brew_path}"
}

# Set Homebrew environs:
#   HOMEBREW_PREFIX       (e.g., /opt/homebrew)
#   HOMEBREW_CELLAR       (DepoXy does not explicitly use)
#   HOMEBREW_REPOSITORY   (DepoXy does not explicitly use)
#   PATH
#   MANPATH
#   INFOPATH
#
# ALERT: `brew` calls `sudo --reset-timestamp`, so if you
# rely on the sudo password being cached, it won't be after
# this call.
_depoxy_infuse_brew_shellenv () {
  local brew_path="$(_depoxy_print_homebrew_path)"

  if [ -e "${brew_path}" ]; then
    eval "$(${brew_path} shellenv)"
  elif os_is_macos; then
    >&2 echo "ERROR: Could not suss Homebrew path"

    return 1
  fi
}

# Defined by ~/.kit/sh/home-fries/lib/distro_util.sh
# but (re-)defined here to support usage from outside
# user's shell (e.g., via cron/launchd).
os_is_macos () {
  [ "$(uname)" = "Darwin" ]
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  # Avoid `brew shellenv` unless necessary, because `brew` command
  # calls `sudo --reset-timestamp`, and `mr -d / infuse` needs sudo
  # to fix /var/select/sh
  #   ~/.depoxy/ambers/home/infuse-platform-macOS
  # So we'll assume if HOMEBREW_PREFIX defined that `brew shellenv`
  # already called.
  if [ -z "${HOMEBREW_PREFIX}" ]; then
    _depoxy_infuse_brew_shellenv
  fi
}

if [ -n "${BASH_SOURCE}" ] && [ "$0" != "${BASH_SOURCE[0]}" ]; then
  # Being sourced into the caller's Bash shell, or being reused by
  # some other script.
  main "$@"
# else, being sourced by not Bash, or being executed.
fi

unset -f main

