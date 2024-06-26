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
#       # CXREF: ~/.depoxy/ambers/home/.kit/git/ohmyrepos/lib/depoxy-client-print-alt-remote-path.sh
#       . "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}/home/.kit/git/ohmyrepos/lib/depoxy-client-print-alt-remote-path.sh"
#       print_depoxy_client_alt_remote_path \
#         "${_client_id:-1234}" \
#         "${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}/${_client_id:-2417}/${MR_DXC_HOME_SHADOW:-home/.home}" \
#         "${MR_REMOTE_HOME:-${MR_HOME:-${HOME}}}" \
#         "${_mr_order:-567}" \
#         "${_mr_exclusive:-home}"
#         

print_depoxy_client_alt_remote_path () {
  local client_id="$1"
  local remote_path="$2"
  # Order after the client project, because we hide this project
  # inside the client repo.
  local mr_order="${3:-999}"
  local skip_list="$4"

  local skip=""
  if [ -n "${skip_list}" ]; then
    skip="skip = mr_exclusive ${skip_list}"
  fi

  cat <<EOF
lib =
  use_remote_home_if_depoxy_client_matches () {
    local client_id="\$1"
    #
    local ret
    if ret=\$(is_remote_depoxy_client_same "\${client_id}" 2> /dev/null); then
      MR_REMOTE_PATH="${remote_path}"
    fi
    # If ! \${ret}, e.g., "No remote specified by MR_REMOTE", but we'll
    # let 'ffssh' fail if MR_REMOTE not set, so that other actions don't
    # fail, e.g., \`mr -d . -n run sh -c 'echo \$MR_SECTION_CONFIG'\`
    # - Nope:
    #   # # errexit if is_remote_depoxy_client_same encountered error.
    #   # \${ret}
  }
  use_remote_home_if_depoxy_client_matches "${client_id}"
  # Prints twice:
  #  debug "MR_REMOTE_PATH: \${MR_REMOTE_PATH}"
order = ${mr_order}
${skip}
lib =
  # Clone to a different local name than the remote name
  # - For when MR_REMOTE_PATH set and ends in different basename than MR_REPO.
  remote_set_private "\$(basename -- "\${MR_REPO}")"
EOF
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

