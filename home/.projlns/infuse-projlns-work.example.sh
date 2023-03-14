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

  # Load: logger.sh, and colors.sh, for link_deep.
  # CXREF: ~/.kit/sh/sh-logger/bin/logger.sh
  . "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger/bin/logger.sh"

  # Load: link_deep, and remove_symlink_hierarchy_safe.
  # CXREF: ~/.kit/git/myrepos-mredit-command/lib/link_deep.sh
  . "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command/lib/link_deep.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_projects_links_work () {
  local before_cd="$(pwd -L)"

  mkdir -p "${DEPOXY_PROJLNS_EXAMPLE}"

  cd "${DEPOXY_PROJLNS_EXAMPLE}"

  remove_symlink_hierarchy_safe

  infuse_create_symlinks_work

  cd "${before_cd}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

infuse_create_symlinks_work () {
  # YOU: Replace this and customize with your own project paths.
  link_deep "${HOME}/work/division1/project-AA"
  link_deep "${HOME}/work/projectZ/superflycool"
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

