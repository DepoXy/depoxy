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
  claim_alias_or_warn "doc8" "_depoxy_python_doc8"

  claim_alias_or_warn "off" "type deactivate >/dev/null 2>&1 && deactivate"

  claim_alias_or_warn "py-site-packages-clip" "_depoxy_python_site_packages_path_print_and_clip"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_python_doc8 () {
  if type -P doc8 > /dev/null; then
    command doc8 "$@"
  elif make -n doc8 > /dev/null 2>&1; then
    make doc8
  else
    # Let shell emit failure.
    command doc8
  fi
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

# CXREF:
#   ~/.kit/py/virtualenvwrapper/virtualenvwrapper.sh

_depoxy_python_lazy_load_virtualenvwrapper () {
  local virtualenvwrappersh
  local wrapper_source_lazy

  # Use `pushd` instead of `cd`.
  export VIRTUALENVWRAPPER_PUSHD="1"

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

# PROPS/2023-05-10: Inspired by virtualenvwrapper user tip:
#
#   https://virtualenvwrapper.readthedocs.io/en/latest/tips.html#enhanced-bash-zsh-prompt
#
# Albeit simplified: We don't set VIRTUAL_ENV_DISABLE_PROMPT like the example
# suggests, otherwise we'd have to hook `activate` and `deactivate` to keep
# the prompt updated. Rather, we only change the prompt for a subshell started
# from a parent shell that's running a virtualenv. The reason is that our
# PS1 setting is only applied when the shell starts, and we won't know when
# `activate` or `deactivate` is called. Fortunately, the virtualenv will update
# PS1 in those cases. The case where it doesn't is when the user starts a
# new login shell within the existing virtualenv, in which case this file is
# reloaded and run, but the virtualenv is not notified. So we'll handle the
# last case — we can look for the VIRTUAL_ENV_PROMPT var. that `activate` sets,
# and that `deactivate` unsets, and if it's set, we'll prepend the prompt,
# just like `activate` does.
#
# - TL_DR: Mimic the typical virtualenv PS1 prompt when starting a new shell
#          within a shell that's running a virtualenv.

# Note that `activate` exports two vars we could use:
# VIRTUAL_ENV, and VIRTUAL_ENV_PROMPT.
# - The `activate` script sets the latter to the former:
#     VIRTUAL_ENV_PROMPT="($(basename "${VIRTUAL_ENV}") "
# - (Or using pure Bash):
#     VIRTUAL_ENV_PROMPT="${VIRTUAL_ENV##*/}"
# So unless we want to customize the prompt (e.g., use something other
# than parentheses), we can cue off and use only VIRTUAL_ENV_PROMPT.

_depoxy_python_prefix_PS1_with_venv_name () {
  _depoxy_python_format_PS1_venv_name() {
    [ -z "${VIRTUAL_ENV}" ] && return

    # Note that `activate` exports VARS, but not functions, so in the case
    # where VIRTUAL_ENV_PROMPT is defined but not the `deactivate` function,
    # we can deduce that this is a subshell.
    # - If not a subshell, `activate` already called and updated PS1 (and
    #   set VIRTUAL_ENV_PROMPT), so nothing to do.
    #   - Note that is currently not a reachable case, because we `unset`
    #     this file's functions below (i.e., none of these functions exist
    #     longer than shell startup, so user cannot call them).
    #   - If we disabled the `unset` calls below, then then user could call
    #     _hf_prompt_customize_shell_prompts_and_window_title directly, in
    #     which case we wouldn't want to inject the virtualenv name into PS1
    #     if `activate` already did it, which we deduce by testing `deactivate`.
    #   - See also VIRTUAL_ENV_DISABLE_PROMPT, but that's trickier to use,
    #     because then we would need to wire into activate and deactivate.
    if ! typeset -f deactivate >/dev/null; then
      # (Child) Shell within a shell.
      # - Format:
      #     (.venv) user@host:dir ⚓ $
      #  printf "%s" "${VIRTUAL_ENV_PROMPT}"
      # - Format: <.venv> user@host:dir ⚓ $
      printf "<%s> " "$(basename "${VIRTUAL_ENV}")"
    fi
  }

  _DEPOXY_OLD_PS1="${PS1}"

  PS1="$(_depoxy_python_format_PS1_venv_name)${PS1:-}"
  export PS1
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  _depoxy_python_wire_aliases
  unset -f _depoxy_python_wire_aliases

  # Don't unset:
  #   _depoxy_python_site_packages_path_print_and_clip

  _depoxy_python_lazy_load_virtualenvwrapper
  unset -f _depoxy_python_lazy_load_virtualenvwrapper

  _depoxy_python_prefix_PS1_with_venv_name
  unset -f _depoxy_python_prefix_PS1_with_venv_name
}

main "$@"
unset -f main

