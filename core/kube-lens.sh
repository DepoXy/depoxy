# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2022-2022 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

NVM_VERS="v16.18.1"

_depoxy_run_or_front_electron_lens () {
  local lens_sources="${DEPOXY_LENS_REPO:-${DOPP_KIT:-${HOME}/.kit}/js/lens}"

  if [ ! -f "${lens_sources}/Makefile" ]; then
    >&2 echo "ERROR: No lens sources found at DEPOXY_LENS_REPO: ${lens_sources}"

    return 1
  fi

  must_insist_deps () {
    local success=true

    for dep in "make" "node" "yarn"; do
      if ! command -v "${dep}" > /dev/null; then
        error "Please install “${dep}”"
        success=false
      fi
    done

    # nvm is a bash injectable, so needs to be loaded by OMR.
    NVM_DIR="${NVM_DIR:-${HOME}/.nvm}"
    if [ ! -f "${NVM_DIR}/nvm.sh" ]; then
      error "Please install “nvm” or specify NVM_DIR (not at ${NVM_DIR})"
      success=false
    fi

    if ! ${success}; then
      if command -v brew > /dev/null && [ \
          "$(brew -v | head -1 | awk '{ print $1 }')" = "Homebrew" \
        ]; then
        error "HINT: \`brew install coreutils node yarn nvm\`"
      fi

      return 1
    fi

    return 0
  }

  must_insist_deps

  # ***

  export NVM_DIR
  . "${NVM_DIR}/nvm.sh"

  if ! nvm use "${NVM_VERS}" > /dev/null 2>&1; then
    nvm install "${NVM_VERS}" || exit 1
  fi
  nvm use "${NVM_VERS}" > /dev/null

  # Note that we don't check
  #   "lens/node_modules/electron/dist/Electron.app/Contents/MacOS/Electron"
  # which continues to run after you quit OpenLensDev.
  if ps aux | grep -q -e "/Library/Application Support/OpenLensDev" | grep -q -v " grep "; then
    osascript \
      -e 'tell application "Electron" to reopen' \
      -e 'tell application "Electron" to activate'
  elif false; then
    cd "${lens_sources}"
    make dev
  else
    # ISSUES? Try `killall "make"`  # Outstanding `make dev`
    echo "Hang on, starting up..."
    #( cd "${lens_sources}"; nohup make dev 2>&1 & )
    #( cd "${lens_sources}"; make dev )
    cd "${lens_sources}"
    local bgpid
    local tmpf="$(mktemp)"
    # I cannot get either of these quiet background commands to work:
    #   nohup make dev 2>&1 > "${tmpf}" &
    #   nohup make dev 2>&1 & > "${tmpf}"
    # They both eventually stop on their own:
    #   [2]+  Stopped                 nohup make dev 2>&1 > "${tmpf}"  (wd: ~/.kit/js/lens)
    # Here's the code that would follow:
    #   bgpid=$!
    #   ...
    #   echo "- Tail the log:"
    #   echo "    tail -F \"${tmpf}\""
    #   echo "- Kill the job:"
    #   echo "    kill -s 9 ${bgpid}"
    #   echo "    # Or: killall make"
    #   echo "    # Or: kill-lens [from this terminal]"
    #   echo "WARNING: You will probably have to finish killing jobs, e.g.,:"
    #   echo "    ps aux | grep lens"
    #   echo "    killall node"
    #   _depoxy_kill_lens () { kill -s 9 ${bgpid}; }
    #   alias kill-lens="kill -s 9 ${bgpid}; unalias kill-lens"
    # and then it's tedious to kill all the straggler processes.
    # - Fortunately I don't have any other node projects running,
    #   so I can `killall node`, but that won't always be an option.
    make dev
    cd - > /dev/null
    # killall "Electron Helper (Renderer)"
    # killall "Electron Helper (GPU)"
    # killall "Electron Helper"
    # killall "Electron"
    # killall node
  fi
}

_depoxy_wire_alias_electron_lens () {
  claim_alias_or_warn "lens" "_depoxy_run_or_front_electron_lens"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  unset -f main

  # Leave: _depoxy_run_or_front_electron_lens

  _depoxy_wire_alias_electron_lens
  unset -f _depoxy_wire_alias_electron_lens
}

main "$@"

