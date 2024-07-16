# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Setup known paths to DepoXy Client resources.
# - Let user override the default values for:
#   - The base directory name (defaults ~/.depoxy); and
#   - The directories therein (defaults ambers, stints).

_vendorfs_define_environs () {
  # OPSEC: Is this a security risk we should care about,
  #        just blindly sourcing a file from user home?
  #        - I suppose this whole project is a secrisk.
  local client_dxyrc="${DEPOXY_CONFIG:-${XDG_CONFIG_HOME:-${HOME}/.config}/depoxy/depoxyrc}"
  if [ -f "${client_dxyrc}" ]; then
    . "${client_dxyrc}"
  fi

  # Also include `321open` config in user's shell.
  local client_321rc="${DEPOXY_CONFIG:-${XDG_CONFIG_HOME:-${HOME}/.config}/depoxy/321open.cfg}"
  if [ -f "${client_321rc}" ]; then
    . "${client_321rc}"
  fi

  # ***

  # The user can be explicit about the currently active client:
  #     DEPOXY_CLIENT_ID=XXXX
  # - E.g., by symlinking ~/.config/depoxy/depoxyrc to a specific
  #   ~/.depoxy/stints/XXXX depoxyrc file.
  # - But if it's not set, the client ID will be determined at runtime
  #   by looking in ${DEPOXYDIR_STINTS_FULL} (~/.depoxy/stints) and
  #   picking the largest numbers-only name.

  # The depoxyrc should set DEPOXY_IS_CLIENT as appropriate,
  # but here's an appropriate default.
  # E.g., "false"
  export DEPOXY_IS_CLIENT="${DEPOXY_IS_CLIENT:-false}"

  # ***

  # E.g., "~/.depoxy"
  export DEPOXYDIR_BASE_FULL="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}"

  # ***

  # E.g., "stints"
  export DEPOXYDIR_STINTS_NAME="${DEPOXYDIR_STINTS_NAME:-stints}"

  # E.g., "~/.depoxy/stints"
  export DEPOXYDIR_STINTS_FULL="${DEPOXYDIR_BASE_FULL}/${DEPOXYDIR_STINTS_NAME}"

  # ***

  # E.g., "running"
  export DEPOXYDIR_RUNNING_NAME="${DEPOXYDIR_RUNNING_NAME:-running}"

  # E.g., "~/.depoxy/running"
  export DEPOXYDIR_RUNNING_FULL="${DEPOXYDIR_BASE_FULL}/${DEPOXYDIR_RUNNING_NAME}"

  # ***

  # As an alternative to DEPOXY_IS_CLIENT, the client .hostnames file
  # can be used to identify whether the current host is client or not.

  # E.g., ".hostnames"
  export DEPOXY_HOSTNAMES_NAME="${DEPOXY_HOSTNAMES_NAME:-.hostnames}"

  # ***

  # The git-put-wise project needs a place to manage patch archives.
  # We keep them within the DepoXy hierarchy.
  # CXREF: ~/.kit/git/git-put-wise/bin/git-put-wise

  # E.g., "~/.depoxy/patchr"
  export PW_PATCHES_REPO="${PW_PATCHES_REPO:-${DEPOXYDIR_BASE_FULL}/${PW_PATCHES_NAME:-patchr}}"

  # See also: PW_OPTION_PASS_NAME
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# The 'X' in 'DepoXy' is a helpful mnemonic for these `cd` commands
# (rather than use the 'D' in 'DepoXy' and collide with, ahem, `cd`).
# - Note, too, that the `cx` and 'cdx` names and prefixes are unused
#   in stock Ubuntu. So we have free reign of cx* and cdx* namespace.
_dxy_wire_aliases_pushd_paths_depoxy () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local ambers_root="${DEPOXYAMBERS_DIR:-${ambers_path}}"

  local archetype_path="${DEPOXYARCHETYPE_DIR:-${ambers_root}/archetype}"

  # `cx` → [C]hange directory to Depo[X]y project.
  #
  # Go to ~/.depoxy/ambers (or ${DEPOXYAMBERS_DIR}), this file's project's root.
  pushd_alias_or_warn "cx" "${ambers_root}"

  # `cxa` → [C]hange directory to Depo[X]y [A]rchetype project.
  #
  # Go to ~/.depoxy/ambers/archetype (or ${DEPOXYARCHETYPE_DIR}).
  pushd_alias_or_warn "cxa" "${archetype_path}"

  # `cxx` → [C]hange directory to Depo[X]y radi[X] directory.
  #
  # Change to ~/.depoxy (or ${DEPOXYDIR_BASE_FULL}), the DepoXy home directory.
  # - Generally, you won't ever work from the DepoXy home directory, so not
  #   sure how useful this alias is, but it's here, and it completes us.
  pushd_alias_or_warn "cxx" "${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}"

  # DUNNO/2022-12-06: I had something at `cxcc` previously and still
  # sometimes type it... maybe that's DXC but using the running/ path.
  pushd_alias_or_warn "cxcc" \
    "${DEPOXYDIR_RUNNING_FULL:-${HOME}/.depoxy/${DEPOXYDIR_RUNNING_NAME:-running}}"
}

_dxy_wire_aliases_pushd_paths_client () {
  # `cxc` → [C]hange directory to Depo[X]y [C]lient alias.
  #
  # We'll use two aliases and two different implementations for changing
  # to the DepoXy Client directory, at least for NOW.
  # - This simple approach is nice in that it won't be wired if the
  #   DEPOXY_CLIENT_ID isn't set, which would be odd, and something
  #   the user would want to know about.
  [ -n "${DEPOXY_CLIENT_ID}" ] &&
    pushd_alias_or_warn "cxc" \
      "${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}/${DEPOXY_CLIENT_ID}"
  #
  # This more robust approach can try to suss out the DepoXy Client path
  # even if DEPOXY_CLIENT_ID is unset (thereby masking that issue, which
  # we don't necessarily want to hide from the user). It also prints a
  # more meaningful error message than pushd's "No such file or directory",
  # and it tells the user which environment variables to inspect to fix
  # any issues. So think of `cxc` as the normal alias you should use, but
  # then fallback to `cdcc` if `cxc` isn't working for some reason.
  # - LATER: We might eventually want to pick one alias name and only one
  #   implementation, but for now, since this code is still new, let's
  #   keep both, just in case we find one or the other more useful.
  claim_alias_or_warn "cdcc" "_vendorfs_path_running_client_pushd"

  # `cxs` → [C]hange directory to Depo[X]y [S]tints directory.
  #
  # We could use a naive implementation, e.g.,:
  #  pushd_alias_or_warn "cxs" "${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}"
  # but if the path is bad, user sees "No such file or directory" from pushd.
  # - So use our function that spews better error message with helpful hints.
  claim_alias_or_warn "cxs" "_vendorfs_path_stints_basedir_pushd"
  #
  # LATER/2022-11-05: I should remove this eventually. This is the old
  # mnemonic, [C]hange [D]irectory to [ST]ints basedir, that my brain
  # might still be wired to type.
  claim_alias_or_warn "cdst" "_vendorfs_path_stints_basedir_pushd"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# ================================================================= #
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Changes to the DepoXy Clients parent directory, aka ~/.depoxy/stints/.
#
# - E.g., cd ~/.depoxy/stints

_vendorfs_path_stints_basedir_pushd () {
  local stints_basedir
  stints_basedir="$(_vendorfs_path_stints_basedir_print)"

  # Look for the DXC parent directory at, e.g., "~/.depoxy/stints".
  if [ ! -d "${stints_basedir}" ]; then
    ${_VENDORFS_WARN_ON_ERROR:-true} && (
      >&2 echo "ERROR: Please create a private clients directory at “${stints_basedir}”"
    )

    return 1
  fi

  pushd "${stints_basedir}" &> /dev/null
}

# Prints the path to said directory.

_vendorfs_path_stints_basedir_print () {
  #_vendorfs_define_environs

  printf %s "${DEPOXYDIR_STINTS_FULL}"
}

# ----------------------------------------------------------

# Changes to the active (running) DepoXy Clients directory.
#
# - E.g., ~/.depoxy/stints/XXXX

_vendorfs_path_running_client_pushd () {
  local running_client
  running_client="$(_vendorfs_path_running_client_print)" || return 1

  if [ ! -d "${running_client}" ]; then
    ${_VENDORFS_WARN_ON_ERROR:-true} && (
      >&2 echo "ERROR: Please remount the DepoXy Client repo to “${running_client}”" &&
      >&2 echo "(and/or set \$DEPOXYDIR_STINTS_FULL and \$DEPOXY_CLIENT_ID appropriately)."
    )

    return 1
  fi

  pushd "${running_client}" &> /dev/null
}

# Prints the path to said directory.

_vendorfs_path_running_client_print () {
  #_vendorfs_define_environs

  # Determine the current client name.
  local client_name
  client_name="$(_vendorfs_resolve_client_name_underway)" || return 1

  # Look for the curr client at "~/.depoxy/stints/XXXX".
  local running_client="${DEPOXYDIR_STINTS_FULL}/${client_name}"

  printf %s "${running_client}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# ================================================================= #
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Find all directory names within the clients directory and sort numerically.
#
# - My approach is to name the client is a systematic manner so that neither
#   the actual client's identity is revealed by its DepoXy Client name, and
#   so that names are sortable numerical by when you began working with the
#   client.
#
#   - Because I work six-or-more month work orders, I chose to name each
#     client based on when I started the contract, using the last two digits
#     of the year, and the two-digit week number of the year to form a four-
#     digit, non-identifying name. E.g., my first client under my new
#     business is named Client 2033, because I started in mid-August, 2020.
#     I like that the name is obscure, and totally unemotional.
#
# Read contents of DEPOXYDIR_STINTS_FULL and print the highest numbered directory name.

_vendorfs_resolve_client_name_underway () {
  if [ -n "${DEPOXY_CLIENT_ID}" ]; then
    # Allows user to override/be explicit about active vendor.
    _vendorfs_current_client_verify_environ_and_print
  else
    # Determines path to latest client directory.
    _vendorfs_current_client_find_directory_and_print
  fi
}

_vendorfs_current_client_verify_environ_and_print () {
  local running_client="${DEPOXYDIR_STINTS_FULL}/${DEPOXY_CLIENT_ID}"

  if ! _vendorfs_must_verify_client_path_exists_and_nonempty "${running_client}"; then
    ${_VENDORFS_WARN_ON_ERROR:-true} && (
      >&2 echo "       Or you may need to fix one or both path variables:"
      >&2 echo "         \$DEPOXYDIR_STINTS_FULL:  ${DEPOXYDIR_STINTS_FULL:-<not set>}"
      >&2 echo "         \$DEPOXY_CLIENT_ID:       ${DEPOXY_CLIENT_ID:-<not set>}"
    )

    return 1
  fi

  echo "${DEPOXY_CLIENT_ID}"
}

_vendorfs_must_verify_client_path_exists_and_nonempty () {
  local running_client="$1"

  if [ ! -d "${running_client}" ] || [ -z "$(ls -A "${running_client}")" ]; then
    ${_VENDORFS_WARN_ON_ERROR:-true} && (
      >&2 echo "ERROR: The DepoXy Client project does not exist or is empty."
      >&2 echo "       You may need to mount or populate its directory:"
      >&2 echo "         ${running_client}"
    )

    return 1
  fi
}

# Note that the mechanism for automatically determing the current client
# directory is somewhat prescriptive, in that it assumes each client is
# named using numbers only, and the largest number is the latest/active
# (underway) client. If this doesn't work for you, use DEPOXY_CLIENT_ID.
# - So this find matches directories named with numbers only, found in
#   the clients basedir, and it picks the one with the largest number.
_vendorfs_current_client_find_directory_and_print () {
  #_vendorfs_define_environs

  if [ ! -d "${DEPOXYDIR_STINTS_FULL}" ]; then
    ${_VENDORFS_WARN_ON_ERROR:-true} && (
      >&2 echo "ERROR: Please ensure stints directory found at “${DEPOXYDIR_STINTS_FULL}”"
      >&2 echo "       Or you may need to fix the path variable:"
      >&2 echo "         \$DEPOXYDIR_STINTS_FULL:  ${DEPOXYDIR_STINTS_FULL:-<not set>}"
    )

    return 1
  fi

  local depoxy_client_id="$(
    find "${DEPOXYDIR_STINTS_FULL}" \
      -mindepth 1 \
      -maxdepth 1 \
      -type d \
      -regex '.*/[0-9]+' \
      -exec bash -c 'basename -- "{}"' \; \
      | sort -n \
      | tail -1
  )"

  if [ -z "${depoxy_client_id}" ]; then
    ${_VENDORFS_WARN_ON_ERROR:-true} && (
      >&2 echo "ERROR: Did not identify any DepoXy Clients in the stints directory:"
      >&2 echo "         \$DEPOXYDIR_STINTS_FULL:  ${DEPOXYDIR_STINTS_FULL:-<not set>}"
    )

    return 1
  fi

  local running_client="${DEPOXYDIR_STINTS_FULL}/${depoxy_client_id}"

  if ! _vendorfs_must_verify_client_path_exists_and_nonempty "${running_client}"; then
    ${_VENDORFS_WARN_ON_ERROR:-true} && (
      >&2 echo "       Otherwise check the contents of the stints directory:"
      >&2 echo "         \$DEPOXYDIR_STINTS_FULL:  ${DEPOXYDIR_STINTS_FULL:-<not set>}"
    )

    return 1
  fi

  echo "${depoxy_client_id}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Do a kindness (or is this assuming too much?) and
# put the client bin/ at the front of PATH.

_dxy_wire_client_bin_to_path_if_client_host () {
  # This function is run when being sourced by the shell, so generally
  # it'll prefer path_prefix from the user's session. But if the user
  # is standing up their machine, they might be using OMR to fetch
  # projects (other than myrepos and OMR itself, and core DepoXy).
  # So still prefer path_prefix, but offer simple substitution.
  if ! type path_prefix > /dev/null 2>&1; then
    path_prefix () {
      PATH="$1:${PATH}"
      export PATH
    }
  fi

  # Don't set PATH unless we're confident this is the client machine.

  # Hahaha, this is such a terrible programming style! Here's an
  # if-test with a side-effect of setting a local variable. But
  # it's one line less than setting the var. and then testing $?.
  if ! running_client="$(_vendorfs_host_is_depoxy_client_id)"; then
    return
  fi

  # Prefix client bin/ to path, so same-named executables therein override
  # DepoXy Ambers programs. E.g., client-specific 321open/23skidoo should
  # take precedence.
  path_prefix "${running_client}/bin"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_vendorfs_host_is_depoxy_client_id () {
  # Verify the running_client directory exists, or print an error.
  _vendorfs_path_running_client_pushd || return 1

  # Grab the path the easy way, given that we changed directories.
  # - Set same path as $(_vendorfs_path_running_client_print).
  local running_client="$(pwd -L)"

  # Restore the working directory before possibly short-circuiting.
  popd &> /dev/null

  local hostnames_path="${running_client}/${DEPOXY_HOSTNAMES_NAME}"

  if [ ! -f "${hostnames_path}" ]; then
    ${_VENDORFS_WARN_ON_ERROR:-false} &&
      _vendorfs_host_is_client_warn_no_file "${hostnames_path}"

    return 1
  fi

  if ! grep -e "^$(hostname)\$" -q "${hostnames_path}"; then
    ${_VENDORFS_WARN_ON_ERROR:-false} &&
      _vendorfs_host_is_client_warn_no_auth "${hostnames_path}"

    return 1
  fi

  # For convenience, print the path, so caller doesn't have to
  # then call $(_vendorfs_path_running_client_print).
  echo "${running_client}"
}

_vendorfs_host_is_depoxy_client_id_or_warn () {
  _VENDORFS_WARN_ON_ERROR=true _vendorfs_host_is_depoxy_client_id
}

_vendorfs_host_is_client_warn_no_file () {
  >&2 echo 'ERROR: Missing hostnames file!'
  >&2 echo
  >&2 echo "       Nothing found at: “${1}”"
  >&2 echo
  >&2 echo '       Hint: Populate that file with a list (one per line) of'
  >&2 echo '             acceptable hostnames on which this script may run.'
  >&2 echo
  >&2 echo '             E.g., to allow this script to run on this machine:'
  >&2 echo
  >&2 echo "               echo \"\$(hostname)\" >> \"${1}\""
}

_vendorfs_host_is_client_warn_no_auth () {
  >&2 echo 'ERROR: Unauthorized machine!'
  >&2 echo
  >&2 echo '       This script is not allowed to run on this machine.'
  >&2 echo
  >&2 echo '       Hint: Either do not run this script on this machine, or'
  >&2 echo '             add the name of this machine to the hostnames file:'
  >&2 echo
  >&2 echo "               echo \"\$(hostname)\" >> \"${1}\""
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_load_depoxy_fs () {
  if ${HOME_FRIES_PRELOAD:-true}; then
    _vendorfs_define_environs
    # Leave _vendorfs_define_environs defined.
  else
    # If the executable is a shell, this file is being sourced for the
    # user's environment, so setup aliases and put client bin/ on PATH.
    if $(printf %s "$0" | grep -q -E '(^-?|\/)(ba|da|fi|z)?sh$' -); then
      _dxy_wire_aliases_pushd_paths_depoxy
      unset -f _dxy_wire_aliases_pushd_paths_depoxy

      _dxy_wire_aliases_pushd_paths_client
      unset -f _dxy_wire_aliases_pushd_paths_client

      # Probably should not dump errors when merely being sourced.
      _VENDORFS_WARN_ON_ERROR=false \
        _dxy_wire_client_bin_to_path_if_client_host
      unset -f _dxy_wire_client_bin_to_path_if_client_host
    fi
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_load_depoxy_fs
  unset -f _dxy_load_depoxy_fs
}

main "$@"
unset -f main

