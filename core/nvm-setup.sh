# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

__dxy_nvm_locate_and_set_nvm_dir_environ() {
  if [ -d "${HOME}/.nvm" ]; then
    NVM_DIR="${HOME}/.nvm"
  elif [ -d "${DOPP_KIT:-${HOME}/.kit}/js/nvm" ]; then
    NVM_DIR="${DOPP_KIT:-${HOME}/.kit}/js/nvm"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

__dxy_nvm_source_nvm_and_completion() {
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

svgo() {
  (
    if [ -z "$(unset -f svgo && type -p svgo)" ]; then
      svgo_prepare || return 1

      >&2 echo -e "HINT: Change env to speedup svgo: nvm use \$(nvm_latest_version)\n"
    fi

    command svgo "$@"
  )
}

svgo_activate_env() {
  # See also: nvm use --lts
  # - Though note --lts is not necessarily latest, e.g.,
  #   --lts will pick v22.19.0, even when v24.7.0 installed.
  local nvm_vers
  if ! nvm_vers="$(nvm_latest_version)"; then

    return 1
  fi

  nvm use ${nvm_vers} > /dev/null
}

svgo_install() {
  svgo_activate_env

  npm install -g svgo
}

svgo_prepare() {
  svgo_activate_env || return 1

  if [ -z "$(unset -f svgo && type -p svgo)" ]; then
    >&2 echo "ERROR: Missing \`svgo\`"
    >&2 echo "- Install it:"
    >&2 echo "  svgo_install"

    return 1
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

nvm_latest_version() {
  if ! command -v nvm > /dev/null; then
    >&2 echo "ERROR: Missing \`nvm\`"
    >&2 echo "- Repo not found at:"
    >&2 echo "  ${NVM_DIR}"

    return 1
  elif test $(nvm ls v | wc -l) -le 1; then
    # E.g.,
    #   $ nvm ls v
    #          v20.19.5
    #          v22.19.0
    #           v24.7.0
    #   ->       system
    >&2 echo "ERROR: Missing user-space \`npm\`"
    >&2 echo "- Install 'em:"
    >&2 echo "  mr -d ${DOPP_KIT:-${HOME}/.kit}/js/nvm -n installNVMNodes"

    return 1
  fi

  nvm ls v --no-colors \
    | sed 's/^\(\->\)\?\s\+//g' \
    | sed 's/\s\+\*\?$//g' \
    | grep -v system \
    | sort -V \
    | tail -1 \
    | sed 's/^\s\+\(.*\)\( .*\)/\1/g'
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# `nvm` lazy-loader. Saves ~0.09 secs. on session standup! #profiling
nvm() {
  unset -f nvm

  __dxy_nvm_locate_and_set_nvm_dir_environ
  unset -f __dxy_nvm_locate_and_set_nvm_dir_environ

  __dxy_nvm_source_nvm_and_completion
  unset -f __dxy_nvm_source_nvm_and_completion

  nvm "$@"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
