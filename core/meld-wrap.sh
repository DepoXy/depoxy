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
# Fortunately you can stay current with Meld via flatpak.
meld () {
  # Prefer flatpak meld.
  # - If you want your own meld, uninstall flatpak's.

  # - SAVVY: Just check dir., as flatpak-info is slower. E.g., not:
  #
  #     if command -v "flatpak" > /dev/null 2>&1; then
  #       # CXREF: ${HOME}/.local/share/flatpak/app/org.gnome.meld
  #       if flatpak info org.gnome.meld > /dev/null 2>&1; then
  #         ...
  if [ -d "${HOME}/.local/share/flatpak/app/org.gnome.meld" ] \
    || [ -d "/var/lib/flatpak/app/org.gnome.meld" ] \
  ; then
    flatpak run org.gnome.meld "$@"
  elif type -f "meld" > /dev/null 2>&1; then
    # `type -f` ignores functions, i.e., don't match the function we're in.

    # We don't need ourselves again.
    unset -f meld

    /usr/bin/env meld "$@"
  else
    echo "ERROR: Cannot locate meld (via flatpak or on PATH)"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  :
}

main "$@"
unset -f main

