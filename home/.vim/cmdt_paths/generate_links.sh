#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=sh
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# This command makes links to important files and dirs in a cmdt search root.

# FIXME/2021-08-23: Is the next comment true? If so, add git-add/-commit herein?
# (To be honest, I haven't used Command-T in a long while.)
# - If true, *don't* commit to DXY, but commit to new CmdT-specific repo, or to DXC.

# ===================================================================== #
# NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE #
#
# You must check these symlinks into the ~/.depoxy/ambers repo, because
# Command-T uses `git ls-files` to find files to add (as opposed to `find`).
# See:
#
#  let g:CommandTFileScanner = "git"
#
# NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE #
# ===================================================================== #

DUBS_VIM_CMDT_PATH="${DEPOXYAMBERS_DIR:-${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers}/home/.vim/cmdt_paths/symlinks"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # Load: error, notice, info, debug, etc.
  . "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger/bin/logger.sh"

  LOG_LEVEL=${LOG_LEVEL_TRACE}
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

remove_existing_links () {
  # Remove existing links, before recreating anew.
  # - We could instead GNU `ln -sfn` or BSD `ln -sfh` to avoid adding links
  #   to the previously linked directories; but we also want to start fresh,
  #   in case previously linked targets were (re)moved.
  find . -maxdepth 1 -type l -exec rm {} +
}

dubs_vim_file_finder_cmdt_path_generate_links () {
  # Tell .vimprojects not to descend into the links directory.
  touch -- ".dubs_project.vim-ignore"

  remove_existing_links

  # Ignore searching subdirectories symlinked herein.
  if [ ! -e ".ignore" ]; then
    # NOTE: '*' is a glob, not regex (like '.*') so won't match 'X.X',
    #       e.g., this file, generate_links.sh, will not be ignored.
    echo "*" > ".ignore"
  fi

  if [ -f "${HOME}/.vimrc" ]; then
    /bin/ln -s "${HOME}/.vimrc" "home-vimrc"
  fi

  /bin/ln -s "${HOMEFRIES_DIR:-${HOME}/.homefries}" "home-fries"

  # FIXME/2021-08-23: What about linking DepoXy Ambers? OMR? Shoilerplate?
  # - FIXME/2021-08-23: Or what about reusing ~/.projlns/depoxy-deeplinks?

  # FIXME/2022-12-24: Move each symlink below to that project's
  #                   OMR `infuse` task.
  #                   - Test CmdT first on @biz b/c been forever since you used it.
  #
  # CRUMB/2021-08-23: YOU: Add Client/Work/@biz project paths here.
  warn "HEY! Please set up Command-T paths (and remove this warning)."
  if [ -e "${HOME}/work/division1" ]; then
    # FIXME/2021-08-23: You could get the list of client work projects
    # from the DepoXy Client OMR, ~/.depoxy/stints/XXXX/_mrconfig-XXXX
    # and then parse it like `mredit` does (looks for [paths] and run
    # each path through `eval` and `realpath`, to resolve environs and
    # to use absolute paths here).
    /bin/ln -sf "${HOME}/work/division1/project-AA" "work--division1--project-AA"
    /bin/ln -sf "${HOME}/work/projectZ/superflycool" "work--projectZ--superflycool"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  set -e

  source_deps

  local before_cd="$(pwd -L)"

  mkdir -p "${DUBS_VIM_CMDT_PATH}"

  cd "${DUBS_VIM_CMDT_PATH}"

  dubs_vim_file_finder_cmdt_path_generate_links

  cd "${before_cd}"
}

main "$@"

