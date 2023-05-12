# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2022-2022 Landon Bouma. All Rights Reserved.

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

_dxy_python_util_site_packages_path_print_and_clip () {
  local os_clip=""
  local po_prefix=""

  # Adjust for macOS (pbcopy) and X11 (xclip).
  command -v pbcopy > /dev/null \
    && os_clip="pbcopy" \
    || os_clip="xclip -selection c"

  command -v poetry > /dev/null && po_prefix="poetry run"

  ${po_prefix} python -c "import site; print(site.getsitepackages()[0])" \
    | tee >(tr -d "\n" | ${os_clip})

_dxy_python_util_must_find_python_virtualenvwrapper () {
  command -v virtualenvwrapper_get_site_packages_dir > /dev/null \
    && return

  >&2 echo "ERROR: Please install (or source) virtualenvwrapper.sh:"
  >&2 echo "  https://github.com/landonb/virtualenvwrapper"
  >&2 echo "Or the original:"
  >&2 echo "  https://github.com/python-virtualenvwrapper/virtualenvwrapper"

  return 1
}

_dxy_python_util_site_packages_path_print_and_clip_alias () {
  claim_alias_or_warn "py-site-packages-clip" "_dxy_python_util_site_packages_path_print_and_clip"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_core_wire_aliases () {
  # CXREF: Defer to the Makefile task:
  #   ~/.depoxy/ambers/archetype/home/.config/work/Makefile.python-generic
  # - Calls black, flake8, and isort.
  claim_alias_or_warn "lint" "make lint"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  _depoxy_core_wire_aliases
  unset -f _depoxy_core_wire_aliases

  _dxy_python_util_site_packages_path_print_and_clip_alias
  unset -f _dxy_python_util_site_packages_path_print_and_clip_alias
}

main "$@"
unset -f main

