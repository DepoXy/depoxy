# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Implements a dotenv- or Direnv-like mechanism from Bash.
#
# - So you might ask yourself, Why not use .envrc, or Direnv?
#
#   Well, because those tools unload the project when you `cd` out of
#   the project directory, but I don't want that. I bounce around a
#   lot, and I'd like project-related features to still work. So I'd
#   like the unload to occur when I switch which project I'm working
#   on.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE: Create a function for each project. Start each function by
#        changing directories, that do any necessary setup, and
#        also define URL environments if you want `app-open` and
#        `app-stage` to work.
#
# E.g.,
#
#  cdmp () {
#    pushd "${HOME}/work/my-project" &> /dev/null
#
#    _work_env_prepare
#
#    # Set the URL to the 'test' environment. Open with `app-test`.
#    _work_env_define 'WORK_URL_TEST' 'https://test-my-project.domain.com/'
#
#    # Set the URL to the 'stage' environment. Open with `app-stage`.
#    _work_env_define 'WORK_URL_STAGE' 'https://stage-my-project.domain.com/'
#  }

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Call when your function loads, before calling _work_env_define. 

_work_env_prepare () {
  # Call previous environment's unloader.
  # Note that we might unload and reload the same environment, but whatever.
  if [ -n "${WORK_ENV_UNLOAD}" ]; then
    eval "${WORK_ENV_UNLOAD}"
    unset -v WORK_ENV_UNLOAD
  fi

  declare -a WORK_ENV_ENVIRONS=()

  # Note that callers can set their own cleanup if necessary
  # by setting a customer WORK_ENV_UNLOAD. But so far I have
  # not found a project where that's necessary.
  WORK_ENV_UNLOAD='_work_env_cleanup'
}

# ***

# Call to set environments that should be unset with the project is unloaded.

_work_env_define () {
  eval "$1=\"$2\""
  WORK_ENV_ENVIRONS+=("$1")
}

# ***

# This generic cleanup function is called automatically when another
# function calls _work_env_prepare. It merely unsets environs.

_work_env_cleanup () {
  ( [ -z ${WORK_ENV_ENVIRONS+x} ] || [ ${#WORK_ENV_ENVIRONS[@]} -eq 0 ] ) &&
    return 0

  local varname=""
  for ((i = 0; i < ${#WORK_ENV_ENVIRONS[@]}; i++)); do
    varname="${WORK_ENV_ENVIRONS[$i]}"
    eval "unset -v ${varname}"
  done

  unset -v WORK_ENV_ENVIRONS
}

# ***

# NOTE: Note that, usually, on calling `npm run run:dev`, webpack-dev-server
#       will open the browser to the local app test page. And you might also
#       have https://localhost:8080 and :9000 buttons in your bookmarks bar.
#       And you probably also have bookmarks to the online test and stage
#       servers and portals. I do, and I found myself always using the
#       browser shortcuts, and never these commands. Oh, well. These
#       might still be useful. At least I find them somewhat novel.

app-test () {
  [ -z "${WORK_URL_TEST}" ] &&
    >&2 echo "App URL not defined for this project." &&
    return 1

  sensible-open "${WORK_URL_TEST}"
}

# ***

# Call `app-stage` to open the stage portal.
#
# Or call `app-stage <portal>` to open a specific portal,
# using the same <portal> postfix you used to define the
# environment variable. E.g., if your function called
#
#   _work_env_define 'WORK_URL_STAGE_blue' 'https://stage-blue.domain.com/'
#
# Then you'd open that address by calling `app-stage blue`.
#
# But like I noted before `app-test`, if might be easier just to use
# browser bookmarks instead. Maybe it depends how many projects you
# manage, or maybe you'll find it quicker to open URLs this way from
# the command line.

app-stage () {
  local which="$1"

  [ -z "${WORK_URL_STAGE}" ] &&
    >&2 echo "Stage URL not defined for this project." &&
    return 1

  local stage_var
  if [ -z "${which}" ]; then
    stage_var='WORK_URL_STAGE'
  else
    # Append which parameter to base stage variable name and resolve.
    # Note that the which-stage parameter is converted to uppercase^^.
    stage_var="WORK_URL_STAGE_${which^^}"
  fi

  # Use Bash's *Names matching prefix* feature to perform introspection.
  sensible-open "${!stage_var}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

