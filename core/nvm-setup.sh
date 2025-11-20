# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USYNC: Lazy installers below are proactively installed via OMR:
#   installNPMPackages, isInstalledNPMPackages
# ~/.depoxy/ambers/home/.kit/js/_mrconfig

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_nvm_locate_and_set_nvm_dir_environ() {
  if [ -d "${HOME}/.nvm" ]; then
    NVM_DIR="${HOME}/.nvm"
  elif [ -d "${DOPP_KIT:-${HOME}/.kit}/js/nvm" ]; then
    NVM_DIR="${DOPP_KIT:-${HOME}/.kit}/js/nvm"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_nvm_source_nvm_and_completion() {
  [ -d "${NVM_DIR}" ] || return 0

  # These are the 3 steps from nvm/install.sh, which it tacks onto
  # ~/.bashrc; and also what's in README.rst, under "Git install".
  # E.g., if you ran
  #  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

  export NVM_DIR

  # Load `nvm`.
  if [ -s "${NVM_DIR}/nvm.sh" ]; then
    . "${NVM_DIR}/nvm.sh"
  fi

  # Load its completioner.
  if [ -n "${BASH}" ] && [ -s "${NVM_DIR}/bash_completion" ]; then
    . "${NVM_DIR}/bash_completion"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_nvm_use_latest_node() {
  nvm use node > /dev/null
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

svgo() {
  if ! (unset -f svgo && type -p svgo > /dev/null); then
    svgo_prepare || return 1
  fi

  command svgo "$@"
}

svgo_install() {
  _dxy_nvm_use_latest_node || return 1

  npm install -g svgo
}

svgo_prepare() {
  _dxy_nvm_use_latest_node || return 1

  if [ -z "$(unset -f svgo && type -p svgo)" ]; then
    >&2 echo "ERROR: Missing \`svgo\`"
    >&2 echo "- Install it:"
    >&2 echo "  svgo_install"

    return 1
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# REFER:
# https://www.claude.com/product/claude-code
claude() {
  _dxy_nvm_use_latest_node || return 1

  if ! (unset -f claude && type -p claude > /dev/null); then
    echo "Installing claude-code..."

    npm install -g @anthropic-ai/claude-code || return 1
  fi

  command claude "$@"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# REFER:
# https://ampcode.com/
#
# - ALTLY:
#   curl -fsSL https://ampcode.com/install.sh | bash
amp() {
  _dxy_nvm_use_latest_node || return 1

  if ! (unset -f amp && type -p amp > /dev/null); then
    echo "Installing amp..."

    npm install -g @sourcegraph/amp@latest || return 1
  fi

  command amp "$@"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# `nvm` lazy-loader. Saves ~0.09 secs. on session standup! #profiling
nvm() {
  unset -f nvm

  _dxy_nvm_locate_and_set_nvm_dir_environ
  unset -f _dxy_nvm_locate_and_set_nvm_dir_environ

  _dxy_nvm_source_nvm_and_completion
  unset -f _dxy_nvm_source_nvm_and_completion

  nvm "$@"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main() {
  unset -f main

  # Startup using latest installed Node.
  _dxy_nvm_use_latest_node
  # - And keep the func. for continued usage:
  #  unset -f _dxy_nvm_use_latest_node
}

main "$@"
