# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Slightly awkward approach to backup remote DXC $HOME, when $HOME is DXC-
# specific and remote DXC is a different Client ID (i.e., its $HOME is not
# our $HOME).
# - In a bare DepoXy Client, the ${HOME} repo (as well as the ~/.kit repo)
#   is generally meant *not* to be changed by the user, but for long-running
#   DXC 2417 (@Charon) I plan to make a few changes, and to want them
#   backed up (via `ffssh` and `travel`).

# USAGE: Call this from OMR config for the other DXC Client, e.g.:
#
#     # I.e.,
#     # [${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}/1234/home/.home]
#     # - Ha, this won't work with `mredit`/`mropen`, sorry!
#     include =
#       # CXREF: ~/.depoxy/ambers/home/.kit/git/ohmyrepos/lib/depoxy-client-print-home-shadow-project.sh
#       . "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}/home/.kit/git/ohmyrepos/lib/depoxy-client-print-home-shadow-project.sh"
#       print_depoxy_client_home_shadow_project "${_client_id:-1234}" "${_mr_order:-567}"

print_depoxy_client_home_shadow_project () {
  local client_id="$1"
  # Order after the client project, because we hide this project
  # inside the client repo.
  local mr_order="${2:-999}"

  cat <<EOF
[${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}/${client_id}/${MR_DXC_HOME_SHADOW:-home/.home}]
lib =
  use_remote_home_if_depoxy_client_matches () {
    local client_id="\$1"
    #
    local ret
    if ret=\$(is_remote_depoxy_client_same "\${client_id}"); then
      MR_REMOTE_PATH="\${MR_REMOTE_HOME:-\${MR_HOME:-\${HOME}}}"
    fi
    # errexit if is_remote_depoxy_client_same encountered error.
    \${ret}
  }
order = ${mr_order}
skip = mr_exclusive "home"
lib =
  use_remote_home_if_depoxy_client_matches "${client_id}"
  debug "MR_REMOTE_PATH: \${MR_REMOTE_PATH} [lib:depoxy-client-print-home-shadow-project.sh]"
  remote_set_private "\$(basename -- "\${MR_DXC_HOME_SHADOW:-home/.home}")"
ffssh =
  use_remote_home_if_depoxy_client_matches "${client_id}"
  debug "MR_REMOTE_PATH: \${MR_REMOTE_PATH} [ffssh:depoxy-client-print-home-shadow-project.sh]"
  git_merge_ffonly_ssh_mirror "\$@"

[DEFAULT]
EOF
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

