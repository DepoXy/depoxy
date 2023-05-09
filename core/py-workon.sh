# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Finds and sources venv `activate` script.
# - `workon` name inspired by retired virtualenvwrapper project.
# - Simple approach is to use conventional venv directory name, e.g.,
#     afile=".venv/bin/activate"
# - A little more flexible approach is use conventional dir prefix,
#   and then pick the most recently created one:
#     afile="$(/bin/ls -t1 .venv*/bin/activate 2> /dev/null | head -1)"
# - Even more flexible is to look for pyvenv.cfg files, and assume
#   those are the venvs.
#     afile="$(/bin/ls -t1 $(fd pyvenv.cfg | xargs dirname | sed 's#$#/bin/activate#'))"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

workon () {
  local venv_num="$1"

  # Combine three afile approaches listed above: Look for `activate` at
  # conventional .venv* path; but also identify pyenv venv directories.
  # - We'll also cull duplicates so user can specify specific venv.
  local afiles

  afiles="$( \
    /bin/ls -t1 \
      .venv*/bin/activate \
      $(fd pyvenv.cfg | xargs dirname | sed 's#$#/bin/activate#') \
    | uniq
  )"

  if [ -z "${afiles}" ]; then
    echo "ERROR: None of the directories in this directory looks like a venv"

    return 1
  fi

  # ***

  local num_afiles=$(echo "${afiles}" | wc -l)

  if [ -z "${venv_num}" ]; then
    venv_num=1

    if ! ${WORKON_QUIET:-false} && [ ${num_afiles} -gt 1 ]; then
      echo "Hint: Call \`workon <index>\` to specify the venv:"
      echo "${afiles}" | awk 'BEGIN { ind = 1; } { print "  [" ind "] " $0; ind++; }'
    fi
  fi

  if [ ${venv_num} -lt 1 ] || [ ${venv_num} -gt ${num_afiles} ]; then
    echo "ERROR: Please try a different index value"

    return 1
  fi

  # ***

  local theafile="$(echo "${afiles}" | head -${venv_num} | tail -1)"

  if [ -z "${theafile}" ]; then
    # Unreachable.
    echo "ERROR: Impossible branch"

    return 1
  fi

  # ***

  workon_deactivate () {
    local deactivatable=false
    command -v deactivate >/dev/null 2>&1 \
      && deactivatable=true

    if [ -n "${VIRTUAL_ENV}" ] || ${deactivatable}; then
      # Remove leading path directories and show only final two dirs
      # (e.g., <proj-name>/<venv-name>).
      local nseps=$(echo "${VIRTUAL_ENV}" | tr -d -c '/' | awk '{ print length; }')
      local deact="$(echo "${VIRTUAL_ENV}" | cut -d'/' -f${nseps}-)"

      ${WORKON_QUIET:-false} \
        || echo "Deactivated ${deact}"

      ${deactivatable} \
        && deactivate
    fi
  }
  workon_deactivate

  # ***

  ${WORKON_QUIET:-false} \
    || echo "Sourcing ${theafile} [${venv_num}]"

  . ${theafile}
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  :
}

main "$@"
unset -f main

