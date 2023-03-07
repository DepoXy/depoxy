#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:spell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# YOU: This is how you might wire your own ~/.projlns project symlinks.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

DEPOXY_PROJLNS="${DEPOXY_PROJLNS:-${HOME}/.projlns}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # Load: infuser_prepare.
  . "${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}/overlay-symlink.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

remove_existing_links () {
  find . -maxdepth 1 -type l -exec /bin/rm {} +
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_projects_links_work () {
  local lns_path="${DEPOXY_PROJLNS:-${HOME}/.projlns}/work.example"

  mkdir -p "${lns_path}"

  local before_cd="$(pwd -L)"

  cd "${lns_path}"

  remove_existing_links

  infuse_create_symlinks_work

  cd "${before_cd}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_create_symlinks_work () {
  # YOU: Replace this and customize with your own project paths.
  /bin/ln -s "${HOME}/work/division1/project-AA"
  /bin/ln -s "${HOME}/work/projectZ/superflycool"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  source_deps

  infuser_prepare "${MR_REPO}" "${@}"

  infuse_projects_links_work
}

set -e
main "$@"

