# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2022-2022 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_core_wire_aliases_python () {
  # FIXME/2022-11-14: Move this to private Bashrc.
  claim_alias_or_warn "lint" "lint-py"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

lint-py () {
  # FIXME/2022-11-14: Do something about this hardcoded line-length.
  py3 -m black . ; py3 -m flake8 . ; py3 -m isort --profile black --line-length=72 .
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Prints the path to the virtualenv site-packages directory.
#
# - E.g., for pyenv-managed venv on macOS:
#
#     /Users/user/.pyenv/versions/3.9.5/envs/my-project-venv/lib/python3.9/site-packages
#
# - Or for user-managed `python -m venv` venv on Linux, e.g.:
#
#     /home/user/path/to/project/.venv/lib/python3.10/site-packages

# See also `poetry env info -p` output, e.g.,:
#
#   $ poetry env info --path
#   /home/user/path/to/project/.venv
#
# But this doesn't expand easily to the site-packages path,
# because you're missing the Python major.minor version.
# - You could hardcode the Python version, e.g.:
#     $(poetry env info -p)/lib/python3.9/site-packages
#   but this is is inelegant.
# - Or you could suss the Python version, but this means
#   calling Python, and if you're gonna call Python, you
#   might as well call site.getsitepackages() instead, as
#   we do here.

_dxy_python_util_site_packages_path_print_and_clip () {
  local os_clip=""
  local po_prefix=""

  # Adjust for macOS (pbcopy) and X11 (xclip).
  command -v pbcopy > /dev/null && os_clip="pbcopy" || os_clip="xclip -selection c"

  command -v poetry > /dev/null && po_prefix="poetry run"

  ${po_prefix} python -c "import site; print(site.getsitepackages()[0])" \
    | tee >(tr -d "\n" | ${os_clip})
}

_dxy_python_util_site_packages_path_print_and_clip_alias () {
  claim_alias_or_warn "py-site-packages-print" "_dxy_python_util_site_packages_path_print_and_clip"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_core_wire_aliases () {
  _depoxy_core_wire_aliases_python
  unset -f _depoxy_core_wire_aliases_python
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _depoxy_core_wire_aliases
  unset -f _depoxy_core_wire_aliases

  _dxy_python_util_site_packages_path_print_and_clip_alias
  unset -f _dxy_python_util_site_packages_path_print_and_clip_alias
}

main "$@"
unset -f main

