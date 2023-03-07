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
  if command -v "flatpak" > /dev/null 2>&1; then
    if flatpak info org.gnome.meld > /dev/null 2>&1; then
      flatpak run org.gnome.meld "$@"
    fi
  else
    # We don't need ourselves again.
    unset -f meld

    /usr/bin/env meld "$@"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  :
}

main "$@"
unset -f main

