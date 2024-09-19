# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# The Meld project moves quicker than Ubuntu's or Mint's sources
# (which never updates Meld beyond the initial distro release, so
#  oftentimes the distro's Meld breaks on later distro updates,
#  ahem, Linux Mint 19).
#
# Fortunately you can stay current with Meld via flatpak.

meld () {
  # SAVVY: Just check dir., as flatpak-info is slower. E.g., not:
  #
  #   if command -v "flatpak" > /dev/null 2>&1; then
  #     # CXREF: ${HOME}/.local/share/flatpak/app/org.gnome.meld
  #     if flatpak info org.gnome.meld > /dev/null 2>&1; then
  #       ...
  is_meld_flatpak_installed () {
    [ -d "${HOME}/.local/share/flatpak/app/org.gnome.meld" ] \
      || [ -d "/var/lib/flatpak/app/org.gnome.meld" ]
  }

  meld_flatpak () {
    flatpak run org.gnome.meld "$@"
  }

  # ***

  # ALTLY: `open` could work, but fails on relative paths.
  #   open /Applications/Meld.app/ --args "$@"
  meld_application () {
    /Applications/Meld.app/Contents/MacOS/Meld "$@"
  }

  # ***

  meld_command () {
    /usr/bin/env meld "$@"
  }

  # ***

  # Prefer flatpak meld (Debian)
  # or Meld from sources (macOS).

  if is_meld_flatpak_installed; then
    meld_flatpak "$@"
  elif [ -d "/Applications/Meld.app/" ]; then
    meld_application "$@"
  elif type -f "meld" > /dev/null 2>&1; then
    # `type -f` ignores functions, i.e., don't match the function we're in.

    # We don't need ourselves again.
    unset -f meld

    meld_command "$@"
  else
    >&2 echo "ERROR: Cannot locate meld (via flatpak or on PATH)"

    return 1
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

