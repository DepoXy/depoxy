#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:spell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

DEPOXY_PROJLNS="${DEPOXY_PROJLNS:-${HOME}/.projlns}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # Load: infuser_prepare.
  . "${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}/overlay-symlink.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Returns a full path to the script being executed. Use this to create a
# symlink to the script from the target directory (which could be anywhere,
# which is why we need a full path). This makes it obvious when the user
# looks inside the target directory to know what script to run or to edit
# to rebuild the directory.
#
# SAVVY: Checking not-a-file was added to verify that the new-at-the-time
#        `readlink_f` function produced a reasonable value.
#        - I've since removed `readlink_f` and replaced it with the `realpath`
#          built-in, and added the requirement that users are now expected to
#          Homebrew and `brew install bash`. (Specifically, I added readlink_f
#          so I could run Bash scripts on macOS before installing Homebrew,
#          but I realized there's no need. Just require Homebrew first.)
infuse_script_suss_fullpath () {
  local script_fullpath=$(realpath -- "${0}")
  if [ ! -f "${script_fullpath}" ]; then
    >&2 echo "UNEXPECTED: ‘$0’ not a file: ‘${script_fullpath}’"
    exit 1
  fi
  printf %s "${script_fullpath}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Leaves a breadcrumb to indicate how the directory was populated.
infuse_project_drop_breadcrumb_dxy () {
  local script_fullpath="$1"
  /bin/ln -sf "${script_fullpath}" "CXREF.depoxy"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  source_deps

  local script_fullpath
  script_fullpath="$(infuse_script_suss_fullpath)" || return 1

  local before_cd="$(pwd -L)"
  /bin/mkdir -p "${DEPOXY_PROJLNS}"
  cd "${DEPOXY_PROJLNS}"

  infuser_prepare "${DEPOXY_PROJLNS}" "${@}"

  infuse_project_drop_breadcrumb_dxy "${script_fullpath}"

  cd "${before_cd}"
}

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  set -e
  main "$@"
fi

