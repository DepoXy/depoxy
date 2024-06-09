# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

is_remote_depoxy_client_same () {
  local client_id="${1:-${DEPOXY_CLIENT_ID}}"

  if [ -z "${MR_REMOTE}" ]; then
    >&2 warn "No remote specified by MR_REMOTE"

    echo "false"
    return 1
  fi

  # ***

  local remote_cache_key="_DEPOXY_CLIENT_ID_${MR_REMOTE}"

  # Not Bash, so can't do this the easy way:
  #   ${!remote_cache_key}
  local remote_cache_id="$(eval printf "%s" "\${${remote_cache_key}}")"
  if [ -n "${remote_cache_id}" ]; then
    echo "true"
    [ "${remote_cache_id}" = "${client_id}" ] \
      && return 0 \
      || return 1
  fi

  # ***

  # Per ~/.depoxy/ambers/core/depoxy_fs.sh, sourced
  # by `lib` in ~/.depoxy/ambers/home/_mrconfig.
  local local_running_rel
  local_running_rel="$( \
    echo "${DEPOXYDIR_RUNNING_FULL:-${HOME}/.depoxy/running}" \
    | sed -E "s@^${HOME}/@@"
  )"

  local remote_running="${MR_REMOTE_RUNNING:-${MR_REMOTE_HOME:-${HOME}}/${local_running_rel}}"

  local remote_id
  remote_id="$( \
    ssh ${MR_REMOTE} "basename -- \"\$(realpath -- '${remote_running}')\""
  )"

  >&2 verbose "remote_id: ${remote_id} / remote_running: ${remote_running}"

  # ***

  # If remote_running absent, remote_id is its basename, e.g., "running".
  if [ "${remote_id}" = "$(basename -- "${remote_running}")" ]; then
    >&2 warn "Remote not running DepoXy? Nothing at ${MR_REMOTE}:${remote_running}"

    eval "${remote_cache_key}=off"

    echo "false"
    return 1
  fi

  eval "${remote_cache_key}=${remote_id}"

  echo "true"

  if [ "${remote_id}" = "${client_id}" ]; then
    >&2 verbose "Remote ID ${remote_id} matches"

    return 0
  else
    >&2 verbose "Remote ID ${remote_id} is not ${client_id}"

    return 1
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

