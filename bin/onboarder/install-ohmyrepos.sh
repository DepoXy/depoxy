# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2021-2024 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** (oh)myrepos paths

# We tell OMR where to find its dependencies, because we install OMR to a
# non-standard path, ~/.kit/git/ohmyrepos, and not the default ~/.ohmyrepos.
# (An infuser eventually makes a ~/.ohmyrepos symlink, but this script runs
#  before then, and this script avoids doing (duplicating) any work mrconfig
#  tasks perform (such as making said symlink). Further, OMR runs in a POSIX
#  shell ($0 = "sh") so it cannot even suss its own path (to find its libs).)

# But first, declare the two parts of the path that are used to build the
# OMR path. These are the default paths that DepoXy uses, but we need the
# path variables to generate the ~/.mrtrust file that `mr` requires.
DOPP_KIT="${DOPP_KIT:-${HOME}/.kit}"
GITREPOSPATH="${GITREPOSPATH:-${DOPP_KIT}/git}"

# We don't run ohmyrepos directly, but rather wire it from our mrconfig,
# which uses the OHMYREPOS_LIB environ, e.g., ~/.kit/git/ohmyrepos/lib.
OHMYREPOS_LIB="${OHMYREPOS_LIB:-${GITREPOSPATH}/ohmyrepos/lib}"

# myrepos is good to go as soon as it's on PATH, or if called directly.
# - A `mr infuse` task will eventually symlink it from ~/.local/bin.
# - But for now, from herein, we'll call `mr` directly.
MR="${GITREPOSPATH}/myrepos/mr"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

BREW_PATH=""

init_homebrew_or_exit_unless_not_macos () {
  if ! os_is_macos; then

    return 0
  fi

  # E.g., /opt/homebrew/bin/brew
  if ! BREW_PATH="$(print_homebrew_prefix)/bin/brew"; then

    exit 1
  fi

  if [ ! -e "${BREW_PATH}" ]; then
    >&2 echo "ERROR: Where's Homebrew?"

    exit 1
  fi

  eval "$(${BREW_PATH} shellenv)"
}

print_homebrew_prefix () {
  local brew_prefix="${HOMEBREW_PREFIX}"

  # Apple Silicon (arm64) brew path is /opt/homebrew
  [ -d "${brew_prefix}" ] || brew_prefix="/opt/homebrew"

  # Otherwise on Intel Macs it's under /usr/local
  [ -d "${brew_prefix}" ] || brew_prefix="/usr/local/Homebrew"

  if [ ! -d "${brew_prefix}" ]; then
    >&2 echo "ERROR: Where's HOMEBREW_PREFIX?"

    exit 1
  fi

  printf "%s" "${brew_prefix}"
}

os_is_macos () {
  [ "$(uname)" = 'Darwin' ]
}

# ***

# HSTRY/2024-04-13: This check archaic; `realpath` added to macOS 13 (Ventura).
insist_realpath_or_exit () {
  if ! command -v realpath > /dev/null; then
    >&2 echo "ERROR: Where's realpath?"

    exit 1
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** Clone ((oh)my)repos

clone_myrepos () {
  if [ -d "${GITREPOSPATH}/myrepos/.git" ]; then
    echo "Clone: myrepos is already cloned"

    return 0
  fi
  echo "Clone: myrepos"
  echo

  mkdir -p "${GITREPOSPATH}"

  cd "${GITREPOSPATH}"

  git clone -o publish 'https://github.com/landonb/myrepos.git' 'myrepos'

  echo
}

clone_ohmyrepos () {
  local omr_path="$(dirname -- "${OHMYREPOS_LIB}")"
  local omr_name="$(basename -- "${omr_path}")"
  local omr_root="$(dirname -- "${omr_path}")"

  if [ -d "${omr_path}/.git" ]; then
    echo "Clone: OH MY REPOS is already cloned"
    return 0
  fi
  echo "Clone: OH MY REPOS"
  echo

  mkdir -p "${omr_root}"

  cd "${omr_root}"

  git clone -o publish 'https://github.com/landonb/ohmyrepos.git' "${omr_name}"

  echo
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# *** Prepare myrepos assets

# Wire the bare minimum to make myrepos (and OMR) happy enough to run.
# Note that both these symlinks and the generated .mrtrust file will be
# recreated by a `mr infuse` task, but `mr` does not run unless these
# assets exist, so, twist my arm, we'll get the ball rolling for `mr`.
prepare_mrconfig () {
  cd "${HOME}"

  prepare_mrtrust

  # Wire the main mrconfig (~/.mrconfig) and its allowlist (~/.mrtrust).
  #
  # - CXREF: See ~/.depoxy/ambers/home/infuse-config-omr,
  #          which also ensures these files are symlinked.

  # Symlink the .mrconfig that we curate and is saved to the repo.
  ln -sf "${DEPOXYAMBERS_DIR}/home/_mrconfig" ".mrconfig"

  # Make a symlink for ~/.mrtrust before we generate the file, so
  # that the generated file is saved to ~/.depoxy/ambers/home.
  ln -sf "${DEPOXYAMBERS_DIR}/home/.mrtrust" ".mrtrust"
}

# Generate the myrepos trust file.
# - USYNC: mrtrust_generators
prepare_mrtrust () {
  $(m4_kludge) \
    --define=USER_HOME=${HOME} \
    --define=DOPP_KIT=${DOPP_KIT} \
    --define=GITREPOSPATH=${GITREPOSPATH} \
    ${DEPOXYAMBERS_DIR}/home/.mrtrust.m4 \
    > ${DEPOXYAMBERS_DIR}/home/.mrtrust
}

# BUGGY/2024-04-13: I'm skeptical that I really found a bug in Xcode,
# but it seems that way!:
#
# - After `xcode-select --install`, running `m4` brings up familiar
#   popup to request Xcode install, e.g.,:
#
#     The “m4” command requires the command line developer tools.
#     Would you like to install the tools now?
#
#   And on the command line you'll see, e.g.,:
#
#     xcode-select: Failed to locate 'm4', requesting installation of command line developer tools.
#
# - If you run `xcode-select --install`, it reports already installed.
#
# - If you click the popup's <Install> button, it'll happily download and
#   install Xcode again, on top of itself.
#
# - Note that `type -a m4` prints `/usr/bin/m4`, and that file is just a shim.
#   In the author's case (Ventura 14.4.1), there are 76 `/usr/bin/<cmd>` files
#   that share the same inode. They appear to shim to the actual files under
#   the Xcode directory, e.g., at
#
#     /Library/Developer/CommandLineTools/usr/bin
#
# - However, the `m4` file is missing!:
#
#     /Library/Developer/CommandLineTools/usr/bin/m4  # Missing!
#
# - There is, fortunately, `gm4`, which is the `m4` command.
#
#   - (DUNNO: This may or may not be similar to the Homebrew convention
#      that uses a `g`-prefix to avoid breaking the user's environment.
#      But I don't know if that's the case here, because there are no
#      other `g`-prefixed Xcode commands.)
#
# NLGTN: Assumes if `gm4` exists, to use that (there is no `gm4`
# Aptitude package (Debian), nor any common `gm4` Linux command
# that the author knows).

m4_kludge () {
  command -v gm4 || command -v m4
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

parse_command () {
  case $1 in

    # If no command or 'help', show the help
    '')
      print_help
      # Don't shift (no parms) lest nonzero exit and errexit.
      #  shift

      exit
      ;;
    help|--help)
      print_help
      shift

      exit
      ;;

    list)
      mr_command=list
      shift
      single_dir="$1"
      ;;

    # Supports either 'checkout' or 'clone'.
    #  - 'checkout' matches the myrepos command that calls git-clone
    #               or svn-checkout, etc.
    #  - 'clone'    matches git-clone, because myrepos git-checkout
    #               (and its SVN complement, svn-copy) do something
    #               completely different, and `mr checkout` might be
    #               confusing to some.
    #               - CXREF: DepoXy wires `mr clone` checkout alias:
    #                   ~/.depoxy/ambers/home/_mrconfig:27
    checkout)
      mr_command=checkout
      shift
      single_dir="$1"
      ;;
    clone)
      mr_command=checkout
      shift
      single_dir="$1"
      ;;

    # After cloning all the repos, infuse them, and then you should
    # be ready to call `mr` directly from your terminal, without
    # needing to use this script anymore.
    infuse)
      mr_command=infuse
      shift
      single_dir="$1"
      ;;

    # If you want to run of `mr` commands, rather than letting you
    # specify any random command on the command line, you can echo
    # the `mr` command this script calls, so you can copy-paste it
    # and modify it how you want.
    echo)
      mr_command=
      shift
      ;;

    *)
      >&2 echo "ERROR: Unexpected command: $1"
      >&2 echo
      >&2 echo "HINT: If that's really the command you want, run:"
      >&2 echo "        $(basename -- "$0") echo"
      >&2 echo "      then copy-paste that output to your terminal"
      >&2 echo "      and then you can run any command you want."
      >&2 echo
      >&2 print_help

      exit 1
      ;;
  esac
}

print_help () {
  echo "This script can run \`mr\` before it's wired into your environment,"
  echo "but it only recognizes a subset of available \`mr\` commands."
  echo
  echo "USAGE: $(basename -- "$0") {command} [{directory}]"
  echo
  echo "You can specify one of the following commands:"
  echo
  echo "    clone | checkout    Clone all the repos - run this first"
  echo "    infuse              Perform an infusion - run this second"
  echo "    help                Show this help text"
  echo "    list                Print all the repos"
  echo "    echo                Print copy-paste mr"
  echo
  echo "You can also specificy an optional directory path if you want"
  echo "to run either \`clone\` or \`infuse\` on only one project."
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

run_mr_command () {
  local work_on_dir

  # So that OMR actions can call `mr`
  PATH="${PATH}:$(dirname -- "${MR}")"

  [ -z "${single_dir}" ] || work_on_dir="-d ${single_dir} -n "

  local the_cmd="\
OHMYREPOS_LIB=${OHMYREPOS_LIB} \\
DEPOXYAMBERS_DIR=${DEPOXYAMBERS_DIR} \\
  ${MR} ${work_on_dir}${mr_command}"

  [ -n "${mr_command}" ] || (
    echo "You can copy-paste these commands to run any command you want:"
    echo
    echo "eval \"\$(${BREW_PATH} shellenv)\""
    echo
  )

  echo "${the_cmd}"
  echo

  [ -z "${mr_command}" ] || eval "${the_cmd}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  set -e

  # This script's repo root is up two levels from bin/onboarder/
  # - USYNC: <repo-root>/bin/onboarder/install-ohmyrepos.sh
  local basedir_relative="$(dirname -- "$(realpath "$0")")/../.."
  local DEPOXYAMBERS_DIR="$(realpath -- "${basedir_relative}")"

  # Sets BREW_PATH
  init_homebrew_or_exit_unless_not_macos
  insist_realpath_or_exit

  local mr_command
  local single_dir
  parse_command "$@"

  clone_myrepos
  clone_ohmyrepos
  echo

  prepare_mrconfig

  # Caller uses mr_command, single_dir
  run_mr_command
}

# Run the installer iff being executed.
if ! $(printf %s "$0" | grep -q -E '(^-?|\/)(ba|da|fi|z)?sh$' -); then
  main "$@"
fi

