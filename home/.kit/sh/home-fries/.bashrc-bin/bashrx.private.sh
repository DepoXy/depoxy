# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_source_script () {
  local ambers_file="$1"
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local ambers_core="${2:-${DEPOXYAMBERS_DIR:-${ambers_path}}/core}"
  local ambers_name="${3:-AMBERS}"

  local before_cd="$(pwd -L)"
  cd "${ambers_core}"

  _source_script () {
    local ambers_file="$1"
    if ! [ -f "${ambers_file}" ]; then
      >&2 echo "MISSING: Unable to locate: ‘${ambers_file}’"
      return 0
    fi
    local time_0=$(print_nanos_now)
    ${HOMEFRIES_TRACE} && echo "   . ${ambers_name}: ${ambers_file}"
    print_loading_dot
    . "${ambers_file}"
    let 'SOURCE_CNT += 1'
    print_elapsed_time "${time_0}" "Source: ${ambers_file}"
  }

  _source_script "${ambers_file}"

  cd "${before_cd}"
}

_dxy_source () {
  _dxy_source_script "$@"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

_source_scripts_preceding_homefries_dxy () {
  # ${HOMEFRIES_TRACE} && echo "Depoxy Ambers Preceding Homefries"

  # Use environment variables to store paths to other repos (Git, OMR,
  # sh libs, etc.) so user can easily use their own path layout.
  _dxy_source "path_vars.sh"

  # Vendor encfs paths, and identify if DepoXy Client.
  _dxy_source "depoxy_fs.sh"

  # Add paths to shoilerplate to PATH, otherwise Bashrc fails...
  _dxy_source "pathanova.sh"

  # Setup Homebrew on PATH.
  # BWARE: Do this now, so that `source_it "python_util.sh"`
  # runs later, ensuring that pyenv's .shims/ path is earlier
  # on PATH, so that pyenv `python3` is used, and not brew's.
  _dxy_source "brewskies.sh"

  # Setup MacPorts on PATH.
  _dxy_source "portskies.sh"

  LOG_LEVEL=0
  . "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger/bin/logger.sh"
  # LOG_LEVEL=${LOG_LEVEL_VERBOSE}
  # LOG_LEVEL=${LOG_LEVEL_DEBUG}
  LOG_LEVEL=${LOG_LEVEL_TRACE}
}

# A wrapper function, so private DepoXy Client can monkey patch the standup.
source_scripts_preceding_homefries () {
  _source_scripts_preceding_homefries_dxy
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_source_scripts_following_homefries_dxy () {
  # ${HOMEFRIES_TRACE} && echo "Depoxy Ambers Following Homefries"

  # GVim `fs` and `fa` commands.
  _dxy_source "alias-vim.sh"

  # DepoXy Ambers aliases (lots of `cd /some/path` aliases).
  _dxy_source "aliastown.sh"

  # Sourced earlier:
  #          "brewskies.sh"

  # Potentially useless dotenv/Direnv-like environment setup.
  _dxy_source "cdworkenv.sh"

  # Commacd.
  _dxy_source "cli-comma.sh"

  # Completion.
  _dxy_source "completes.sh"

  # Second sourcing, this time with deps (claim_alias_or_warn) loaded.
  _dxy_source "depoxy_fs.sh"

  # dob reports (brief me!).
  _dxy_source "dob-brief.sh"

  # Fuzzy finder wiring.
  _dxy_source "fzf-setup.sh"

  # Git command funky patch.
  _dxy_source "git-smart.sh"

  # grip wired to GH token.
  _dxy_source "grip-pass.sh"

  # Easy linting, you jest.
  _dxy_source "js-dev-up.sh"

  # Electron Lens k8s GUI.
  _dxy_source "kube-lens.sh"

  # A single make convenience.
  _dxy_source "make-itso.sh"

  # Backgrounds meld if you don't; avoids virtualenv 'gi' issue.
  _dxy_source "meld-wrap.sh"

  # nvm.
  _dxy_source "nvm-setup.sh"

  # Oh My Repos.
  _dxy_source "omr-alias.sh"
  _dxy_source "omr-setup.sh"
  _dxy_source "omr-wraps.sh"

  # Sourced earlier:
  #          "pathanova.sh"

  # Sourced earlier:
  #          "path_vars.sh"

  # Sourced earlier:
  #          "portskies.sh"

  # pw.
  _dxy_source "putwisely.sh"

  # Py py, py, py py py py.
  _dxy_source "pydevelop.sh"

  # ssh-agent-kill `ssh-agent -k` shim.
  _dxy_source "ssh_agent.sh"

  # Start those apps that don't start themselves.
  _dxy_source "startapps.sh"

  # Run background tasks to keep desktop session active.
  _dxy_source "stayalive.sh"

  # Just a symlink to this file:
  #          "wire-bash.sh"
}

# A wrapper function, so private DepoXy Client can monkey patch the standup.
source_scripts_following_homefries () {
  _source_scripts_following_homefries_dxy
  unset -f _source_scripts_following_homefries_dxy
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_source_scripts () {
  local time_outer_0=$(print_nanos_now)
  SOURCE_CNT=0

  if ${HOME_FRIES_PRELOAD:-true}; then
    source_scripts_preceding_homefries
  else
    source_scripts_following_homefries
  fi

  print_elapsed_time \
    "${time_outer_0}" \
    "Sourced ${SOURCE_CNT} files (_dxy_source_scripts)." \
    "PRIVATE: "
  unset SOURCE_CNT
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

_dxy_unset_functions_dxy () {
  unset -f _dxy_source_script
  unset -f _dxy_source

  unset -f _depoxy_path_condense_colons
  unset -f _source_scripts_preceding_homefries_dxy
  unset -f source_scripts_preceding_homefries

  unset -f _source_scripts_following_homefries_dxy
  unset -f source_scripts_following_homefries

  unset -f _dxy_source_scripts
}

_dxy_unset_functions () {
  _dxy_unset_functions_dxy
  unset -f _dxy_unset_functions_dxy

  # Self-destruct
  unset -f _dxy_unset_functions
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# The Homefries Private Bashrc loader calls this func. if it sees it.
_homefries_private_main () {
  DEBUG_TRACE=${DEBUG_TRACE:-false}
  _dxy_source_scripts
  _dxy_unset_functions
}

