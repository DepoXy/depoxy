# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2025 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps() {
  # ISOFF/2025-10-01: Uncomment to support running independently
  # (vs. assuming running with DepoXy environment).
  #
  # # Load: debug, info, notice, warn, error, attr_*.
  # . "${SHOILERPLATE:-${DOPP_KIT:-${HOME}/.kit}/sh}/sh-logger/bin/logger.sh"
  :
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

prepare_ssh_keys() {
  # MAYBE: Define SSH_SECRETS in DepoXy.
  # - Currently this env. is set by author's private DXC.
  #   - It's used by 321open to ssh-add keys.
  # - When this func. was in my private DXC, I'd complain
  #   if not set, but that doesn't work for DepoXy because
  #   321open is an opt-in feature.
  #
  #   if [ -z "${SSH_SECRETS}" ]; then
  #     # Reset cursor in case HOMEFRIES_LOADINGDOTS.
  #     printf '\r'
  #     warn "Not set: SSH_SECRETS"
  #   elif [ ! -d "${SSH_SECRETS}" ]; then
  #     ...
  if [ -n "${SSH_SECRETS}" ] && [ ! -d "${SSH_SECRETS}" ]; then
    printf '\r'
    # warn "Not mounted: SSH_SECRETS=${SSH_SECRETS}"
    echo "  $(attr_underline)Oh hi$(attr_reset)" \
      "$(attr_emphasis)please run$(attr_reset)" \
      "$(attr_bold)321open$(attr_reset)"
    echo "⣀⣀⣀⣐⣔⣒⣔⣳⣒⣴⣶⣾⣿⣽⣿⣺⣽⣷⢵⣥⣔⣄⣑⣁⣃⣄⣀🐌"
  else
    _dxy_mindencfs_source_ssh_environs
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Create a `321open` shell shim so user doesn't have to start new
# session (or source ~/.ssh/environment) after running `321open`.
321open() {
  if ! type -f 321open > /dev/null 2>&1; then
    >&2 echo "ERROR: 321open not on PATH"

    return 1
  fi

  local exit_val=0

  command 321open \
    || exit_val=$?

  if [ ${exit_val} -eq 0 ]; then
    _dxy_mindencfs_source_ssh_environs
  fi

  return ${exit_val}
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# ADDED/2024-03-16: Source new SSH_* environs after 321open.
# - I don't think this is usually necessary.
#   - If there's only one ssh-agent running, you don't need to set
#     SSH_AUTH_SOCK and/or SSH_AGENT_PID. E.g., git-push will use
#     the only ssh-agent running.
# - But if you end up with two agents running, you need to set
#   SSH_AUTH_SOCK and/or SSH_AGENT_PID.
#   - I got into this state when testing 321open, after running
#     23skidoo and then 321open again. E.g.,
#       @debian $ ps aux | grep ssh
#       user    75159  Mar10   0:00 /usr/bin/ssh-agent
#       user  1891369  Mar11   0:00 /usr/bin/ssh-agent -D -a /run/user/1000/keyring/.ssh
#     - But I didn't start the second process, at least not directly.
#       - Some calls will automatically start ssh-agent.
#         - E.g., on fresh boot:
#           $ ps aux | grep ssh-agent
#           $ ssh -T git@github.com
#           git@github.com: Permission denied (publickey).
#           $ ps aux | grep ssh-agent
#           user  ...  /usr/bin/ssh-agent -D -a /run/user/1000/keyring/.ssh
#   - I've since added ssh-agent-kill to 321open, and I now source the
#     SSH_* environs when starting a new terminal (this function), so
#     I'll hopefully avoid this state in the future.
# - CXREF:
#     # MAYBE: Add (author's private) bin/321open to DepoXy Archetype?
#     ~/.depoxy/running/bin/321open  # Optional; not in DXA
#     ~/.homefries/bin/ssh-agent-kill
#     ~/.ssh/environment
_dxy_mindencfs_source_ssh_environs() {
  local ssh_environs="${HOMEFRIES_SSH_ENV:-${HOME}/.ssh/environment}"

  if [ -f "${ssh_environs}" ]; then
    . "${ssh_environs}"
  else
    warn "ALERT: Missing ‘${ssh_environs}’ — Try running \`321open\`"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main() {
  unset -f main

  source_deps
  unset -f source_deps

  prepare_ssh_keys
  unset -f prepare_ssh_keys
}

main "$@"
