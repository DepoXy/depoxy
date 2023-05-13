# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2022-2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_python_wire_aliases () {
  # CXREF: Defer to the Makefile task:
  #   ~/.depoxy/ambers/archetype/home/.config/work/Makefile.python-generic
  # - Calls black, flake8, and isort.
  claim_alias_or_warn "lint" "make lint"

  claim_alias_or_warn "off" "type deactivate >/dev/null 2>&1 && deactivate"

  claim_alias_or_warn "py-site-packages-clip" "_depoxy_python_site_packages_path_print_and_clip"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Prints the path to the virtualenv site-packages directory,
# and copies the path to the clipboard.
#
# - E.g., for pyenv-managed venv on macOS:
#
#     /Users/user/.pyenv/versions/3.9.5/envs/my-project-venv/lib/python3.9/site-packages
#
# - Or for user-managed `python -m venv` venv on Linux, e.g.:
#
#     /home/user/path/to/project/.venv/lib/python3.10/site-packages

_depoxy_python_site_packages_path_print_and_clip () {
  _depoxy_python_must_find_python_virtualenvwrapper () {
    command -v virtualenvwrapper_get_site_packages_dir > /dev/null \
      && return

    >&2 echo "ERROR: Please install (or source) virtualenvwrapper.sh:"
    >&2 echo "  https://github.com/landonb/virtualenvwrapper"
    >&2 echo "Or the original:"
    >&2 echo "  https://github.com/python-virtualenvwrapper/virtualenvwrapper"

    return 1
  }

  _depoxy_python_must_find_python_virtualenvwrapper \
    || return 1

  local os_clip=""

  # Adjust for macOS (pbcopy) and X11 (xclip).
  command -v pbcopy > /dev/null \
    && os_clip="pbcopy" \
    || os_clip="xclip -selection c"

  # Caller prints `distutils.sysconfig.get_python_lib()`
  # - Equivalent to: `site.getsitepackages()[0]`
  virtualenvwrapper_get_site_packages_dir | tee >(tr -d "\n" | ${os_clip})
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_python_lazy_load_virtualenvwrapper () {
  local virtualenvwrappersh
  local wrapper_source_lazy

  # Prefer bleeding-edge.
  virtualenvwrappersh="${DOPP_KIT:-${HOME}/.kit}/py/virtualenvwrapper/virtualenvwrapper.sh"
  wrapper_source_lazy="${DOPP_KIT:-${HOME}/.kit}/py/virtualenvwrapper/virtualenvwrapper_lazy.sh"

  if [ ! -f "${virtualenvwrappersh}" ] || [ ! -f "${wrapper_source_lazy}" ]; then
    # Fallback on what's on PATH (from `pip install virtualenvwrapper`).
    virtualenvwrappersh="$(which virtualenvwrapper.sh)"
    wrapper_source_lazy="$(which virtualenvwrapper_lazy.sh)"
  fi

  if [ -f "${virtualenvwrappersh}" ] && [ -f "${wrapper_source_lazy}" ]; then
    VIRTUALENVWRAPPER_SCRIPT="${virtualenvwrappersh}"

    . "${wrapper_source_lazy}"
  # else, it's up to the user to find out it wasn't loaded.
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  _depoxy_python_wire_aliases
  unset -f _depoxy_python_wire_aliases

  # Don't unset:
  #   _depoxy_python_site_packages_path_print_and_clip

  _depoxy_python_lazy_load_virtualenvwrapper
  unset -f _depoxy_python_lazy_load_virtualenvwrapper
}

main "$@"
unset -f main

