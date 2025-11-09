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
  if [ "$1" = "--help" ]; then
    command restview "$@"
  else
    local listener
    # Find an unused port.
    # - REFER: `ss -lntH` → `ss --listening --numeric --tcp --no-header`,
    #   respectively.
    local port=""
    for ((port = ${DEPOXY_RESTVIEW_PORT:-51920}; port <= $((${DEPOXY_RESTVIEW_PORT:-51920} + 10)); port++)); do
      listener="$(ss -lntH sport = ${port})"

      if [ -z "${listener}" ]; then
        break
      fi
    done

    if [ -z "${port}" ]; then
      >&2 echo "ERROR: Could not find a free port to use"

      return 1
    elif [ "${port}" != "${DEPOXY_RESTVIEW_PORT:-51920}" ]; then
      >&2 echo "ALERT: At least one other restview instance is already running"
    fi

    (sleep 0.5 && sensible-open "http://localhost:${port}/") &

    command restview --no-browser -l ${port} "$@"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
