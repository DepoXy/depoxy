#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # Load: logger.sh, and colors.sh, for link_deep.
  # CXREF: ~/.kit/sh/sh-logger/bin/logger.sh
  . "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger/bin/logger.sh"
  
  # Load: _vendorfs_path_running_client_print.
  # - CXREF: ~/.depoxy/ambers/core/depoxy_fs.sh
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  . "${DEPOXYAMBERS_DIR:-${ambers_path}}/core/depoxy_fs.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

init_spellssh () {
  SPF_SPELLS="${SPELLFILE_DIR:-${DOPP_KIT:-${HOME}/.kit}/txt/spellfile.txt}/bin/spells.sh"

  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  # E.g., ~/.depoxy/ambers/home/.vim/spell/en.utf-8.add--private
  DEPOXY_SPELLS="${ambers_path}/home/.vim/spell/en.utf-8.add--personal"
}

# ***

# Compiles multiple spell files: DepoXy Ambers's spell file, the
# DepoXy Client spell file, plus whatever else gets passed in.
# - Note the passed args are passed first, because the compiled
#   spell file is created in first path's path.
# - As wired from DepoXy 'infuse' task, which does not pass any
#   args, the main public spell:
#     ~/.kit/txt/spellfile.txt/spell/private
#   is merged with the DepoXy's published spell:
#     ~/.depoxy/ambers/home/.vim/spell/private
#   is merged with the user's private spell:
#     ~/.depoxy/running/home/.vim/spell/private
#   and the compiled spell file is created at:
#     ~/.depoxy/running/home/.vim/spell/compiled
#   because "~/.depoxy/running/home" (client_homeish
#   below) is first arg passed to upstream compile-spells.

compile_spells () {
  local client_homeish=""
  local client_basedir="$(_print_client_basedir)"
  if [ -n "${client_basedir}" ]; then
    # E.g., ~/.depoxy/running/home
    client_homeish="${client_basedir}/home"
  fi

  "${SPF_SPELLS}" compile-spells "$@" "${client_homeish}" "${DEPOXY_SPELLS}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_print_client_basedir () {
  client_basedir="$(_vendorfs_path_running_client_print)"

  if [ $? -eq 0 ]; then
    printf "%s" "${client_basedir}"
  else
    >&2 echo "ERROR: Unable to determine DepoXy Client spell path"

    return 1
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

dispatch_command () {
  local command="$1"
  shift

  case ${command} in
    compile-spells)
      compile_spells "$@"
      ;;
    *)
      # Forward request upstream.
      "${SPF_SPELLS}" "${command}" "$@"
      ;;
  esac
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  source_deps

  init_spellssh

  dispatch_command "$@"
}

# Only run when executed; no-op when sourced.
if [ "$0" = "${BASH_SOURCE}" ]; then
  main "$@"
fi

