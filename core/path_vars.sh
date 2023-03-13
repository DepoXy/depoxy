# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_export_path_var_depoxy_ambers () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"

  if [ -d "${DEPOXYAMBERS_DIR:-${ambers_path}}" ]; then
    export DEPOXYAMBERS_DIR="${DEPOXYAMBERS_DIR:-${ambers_path}}"
  elif [ -n "${DEPOXYAMBERS_DIR}" ]; then
    >&2 echo "UNSUSSABLE: DEPOXYAMBERS_DIR incorrect: ‘${DEPOXYAMBERS_DIR}’."
  else
    >&2 echo "UNSUSSABLE: DEPOXYAMBERS_DIR not set and indeterminable."
  fi
}

_dxy_export_path_var_dopp_kit () {
  if [ -d "${DOPP_KIT:-${HOME}/.kit}" ]; then
    export DOPP_KIT="${DOPP_KIT:-${HOME}/.kit}"
  elif [ -n "${DOPP_KIT}" ]; then
    >&2 echo "UNSUSSABLE: DOPP_KIT incorrect: ‘${DOPP_KIT}’."
  else
    >&2 echo "UNSUSSABLE: DOPP_KIT not set and indeterminable."
  fi
}

_dxy_export_path_var_shoilerplate () {
  if [ -d "${SHOILERPLATE:-${HOME}/.kit/sh}" ]; then
    export SHOILERPLATE="${SHOILERPLATE:-${HOME}/.kit/sh}"
  elif [ -n "${SHOILERPLATE}" ]; then
    >&2 echo "UNSUSSABLE: SHOILERPLATE incorrect: ‘${SHOILERPLATE}’"
  else
    >&2 echo "UNSUSSABLE: SHOILERPLATE not set and indeterminable."
  fi
}

_dxy_export_path_var_git_basedir () {
  if [ -d "${GITREPOSPATH:-${HOME}/.kit/git}" ]; then
    export GITREPOSPATH="${GITREPOSPATH:-${HOME}/.kit/git}"
  elif [ -n "${GITREPOSPATH}" ]; then
    >&2 echo "UNSUSSABLE: GITREPOSPATH incorrect: ‘${GITREPOSPATH}’."
  else
    >&2 echo "UNSUSSABLE: GITREPOSPATH not set and indeterminable."
  fi
}

_dxy_export_path_var_ohmyrepos_lib () {
  local omr_dir="${OHMYREPOS_DIR:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos}"

  if [ -d "${omr_dir}" ]; then
    export OHMYREPOS_DIR="${omr_dir}"
    export OHMYREPOS_LIB="${OHMYREPOS_DIR}/lib"
  elif [ -n "${OHMYREPOS_DIR}" ]; then
    >&2 echo "UNSUSSABLE: OHMYREPOS_DIR incorrect: ‘${OHMYREPOS_DIR}’."
  else
    >&2 echo "UNSUSSABLE: OHMYREPOS_DIR not set and indeterminable."
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_depoxy_path_environs () {
  local environ

  for environ in \
    DEPOXYAMBERS_DIR \
    DOPP_KIT \
    SHOILERPLATE \
    GITREPOSPATH \
    OHMYREPOS_LIB \
  ; do
    echo "${environ}=$(fg_mintgreen)${!environ}$(attr_reset)"
  done
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_cmdpath () {
  # Add special path variables to user's environment.

  # *** Export path environs.

  _dxy_export_path_var_depoxy_ambers
  unset -f _dxy_export_path_var_depoxy_ambers

  _dxy_export_path_var_dopp_kit
  unset -f _dxy_export_path_var_dopp_kit

  _dxy_export_path_var_shoilerplate
  unset -f _dxy_export_path_var_shoilerplate

  _dxy_export_path_var_git_basedir
  unset -f _dxy_export_path_var_git_basedir

  _dxy_export_path_var_ohmyrepos_lib
  unset -f _dxy_export_path_var_ohmyrepos_lib
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_cmdpath
  unset -f _dxy_wire_cmdpath
}

main "$@"
unset -f main

