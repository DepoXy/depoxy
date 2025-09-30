# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2025 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# UCASE: Open restview live HTML in *new* browser window, and front.
# - BECUZ: `restview --browser`, the default, opens tab in existing
#   window, and doesn't front (GNOME).

# Normally listens on random port, e.g.:
#
#   $ restview foo.rst
#   Listening on http://localhost:43177/
#   ...
#
# - We'll always use the same port.
# - Then running `restview` command when already running
#   will simply open a new browser window.
# - Pick a port from the Dynamic Ports range, 49152–65535 (2^15+2^14 to 2^16−1),
#   dynamic or private ports that cannot be registered with IANA.
#   - REFER: https://superuser.com/questions/956226/
#       what-are-the-differences-between-the-3-port-types
#   - We'll pick 51920 for the "est" in alpha-numbered
#     "restview" — 18/5/19/20/22/9/5/23
DEPOXY_RESTVIEW_PORT=${DEPOXY_RESTVIEW_PORT:-51920}

restview() {
  if [ $# -eq 1 ] && [ "$1" != "--help" ]; then
    local listener
    # REFER: `ss -lntH` → `ss --listening --numeric --tcp --no-header`,
    # respectively.
    listener="$(ss -lntH sport = ${DEPOXY_RESTVIEW_PORT:-51920})"

    if [ -z "${listener}" ]; then
      command restview --no-browser -l ${DEPOXY_RESTVIEW_PORT:-51920} "$@" &
      # sleep 0.01
    fi

    sensible-open "http://localhost:${DEPOXY_RESTVIEW_PORT:-51920}/"
  else
    command restview "$@" &
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
