#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:spell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# YOU: This is how you might wire your own ~/.projlns project symlinks.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

DEPOXY_PROJLNS="${DEPOXY_PROJLNS:-${HOME}/.projlns}"

DEPOXY_PROJLNS_EXAMPLE="${DEPOXY_PROJLNS_EXAMPLE:-${DEPOXY_PROJLNS}/work.example}"

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
  local before_cd="$(pwd -L)"

  mkdir -p "${DEPOXY_PROJLNS_EXAMPLE}"

  cd "${DEPOXY_PROJLNS_EXAMPLE}"

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
  set -e

  source_deps

  infuser_prepare "${DEPOXY_PROJLNS_EXAMPLE}"

  infuse_projects_links_work
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Only run when executed; no-op when sourced.
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi

