#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash

# USAGE: Call this script from a Karabiner-Elements rule.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  local dxc_path="$1"

  [ -f "${HOME}/.config/depoxy/depoxyrc" ] && . "${HOME}/.config/depoxy/depoxyrc"

  local dxc_running="${DEPOXYDIR_RUNNING_FULL:-${HOME}/.depoxy/${DEPOXYDIR_RUNNING_NAME:-running}}"

  # Open, e.g., ~/.depoxy/running/${dxc_path}
  "${SHOILERPLATE:-${DOPP_KIT:-${HOME}/.kit}/sh}/gvim-open-kindness/bin/gvim-open-kindness" \
    "${dxc_running}/${dxc_path}"
}

# Run the function iff being executed.
SCRIPT_NAME="gvim-open-DepoXy-Client-path.sh"
if [ "$(basename -- "$(realpath -- "$0")")" = "${SCRIPT_NAME}" ]; then
  main "$@"
fi

