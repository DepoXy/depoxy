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
# - Or from sources, because there are no working Apple Silicon
#   builds for macOS circa 2024-09-18.

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

  # Aka ${HOMEBREW_PREFIX}
  local brew_home="/opt/homebrew"
  # Otherwise on Intel Macs it's under /usr/local.
  [ -d "${brew_home}" ] || brew_home="/usr/local"

  local user_meld="${DOPP_KIT:-${HOME}/.kit}/py/meld"

  # USYNC: DEPOXY_PYENV_PYVERS
  local py_vers="${DEPOXY_MELD_PYVERS:-${DEPOXY_PYENV_PYVERS:-3.12.1}}"
  local py_path="/opt/homebrew/lib/python${py_vers%.*}/site-packages"

  is_meld_sources_installed () {
    [ -x "${user_meld}/bin/meld" ] \
      && [ -x "${brew_home}/bin/meld" ] \
      && [ -d "${py_path}/meld" ]
  }

  # ALTLY: Because of #!/usr/bin/python3 in brew executable,
  # we could instead call brew module via python3 directly:
  #   PYTHONPATH="${py_path}" python3 ${brew_home}/bin/meld "$@"
  meld_sources () {
    # Avoid same-named Homebrew executable with `command` preflight.
    test "$(command -v deactivate)" = "deactivate" && deactivate
    eval "$(pyenv init -)"

    # Shouldn't be necessary/wouldn't make sense here:
    #   pyenv install -s ${py_vers}
    pyenv shell ${py_vers}

    PYTHONPATH="${py_path}" ${user_meld}/bin/meld "$@"
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
  elif is_meld_sources_installed; then
    meld_sources "$@"
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

  # Overkill, but author doesn't like shell bleed, or stuff
  # messing up my completion hints.
  unset -f is_meld_flatpak_installed
  unset -f meld_flatpak
  unset -f is_meld_sources_installed
  unset -f meld_sources
  unset -f meld_application
  unset -f meld_command
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

