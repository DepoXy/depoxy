# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

__dxy_nvm_locate_and_set_nvm_dir_environ () {
  if [ -d "${HOME}/.nvm" ]; then
    NVM_DIR="${HOME}/.nvm"
  elif [ -d "${DOPP_KIT:-${HOME}/.kit}/js/nvm" ]; then
    NVM_DIR="${DOPP_KIT:-${HOME}/.kit}/js/nvm"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

__dxy_nvm_source_nvm_and_completion () {
  [ -d "${NVM_DIR}" ] || return 0

  # These are the 3 steps from nvm/install.sh, which it tacks onto
  # ~/.bashrc; and also what's in README.rst, under "Git install".
  # E.g., if you ran
  #  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

  export NVM_DIR

  # Load `nvm`.
  [ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"

  # Load its completioner.
  [ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# `nvm` lazy-loader. Saves ~0.09 secs. on session standup! #profiling
nvm () {
  unset -f nvm

  __dxy_nvm_locate_and_set_nvm_dir_environ
  unset -f __dxy_nvm_locate_and_set_nvm_dir_environ

  __dxy_nvm_source_nvm_and_completion
  unset -f __dxy_nvm_source_nvm_and_completion

  nvm "$@"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  unset -f main
}

main "$@"

