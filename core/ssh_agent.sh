#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=sh
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Rather than call `ssh-agent -k`, which (AFAIK, or just what I assume)
# only kills the agent with a matching SSH_AGENT_PID pid, use `ps` to
# find and kill all agents.

ssh-agent () {
  if [ $# -eq 1 ] && [ "$1" = '-k' ]; then
    # "Not by the hair of my shimmy-shim-shim!"
    if command -v ssh-agent-kill > /dev/null; then
      # On PATH
      ssh-agent-kill
    else
      # Look for OMR project
      local sak_path="${DOPP_KIT:-${HOME}/.kit}/odd/321open/bin/ssh-agent-kill"

      if [ -x "${sak_path}" ]; then
        "${sak_path}"
      else
        >&2 echo "ERROR: Unable to locate \`ssh-agent-kill\`"

        return 1
      fi
    fi
  else
    # Likely /usr/bin/ssh-agent
    command ssh-agent "$@"
  fi
}

