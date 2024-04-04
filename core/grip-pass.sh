# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2024 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_grip_pass_insist_ready () {
  local ready=true

  if ! command -v grip > /dev/null; then
    >&2 echo "ERROR: Missing grip: Try \`pipx install grip\`"

    ready=false
  fi

  # ***

  insist_environ_non_empty () {
    local environ_name="$1"

    if eval "test -z \"\$${environ_name}\""; then
      >&2 echo "ERROR: Missing ${environ_name} environ"

      ready=false
    fi
  }

  # E.g.,
  #   export GRIP_PASS_ADDY="localhost:6419"
  GRIP_PASS_ADDY="${GRIP_PASS_ADDY:-localhost:6419}"

  # E.g.,
  #   export GRIP_PASS_PATH="pass/path/to/github/token"
  insist_environ_non_empty "GRIP_PASS_PATH"

  # ***

  if ! ${ready}; then
    return 1
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

grip-pass () {
  if [ $# -eq 0 ]; then
    >&2 echo "ERROR: Please specify a Markdown path"

    return 1
  fi

  if ! _grip_pass_insist_ready; then

    return 1
  fi

  # Pass pre-flight, so user's password is cached.
  if ! pass "${GRIP_PASS_PATH}" > /dev/null; then
    >&2 echo "ERROR: Failed: \`pass ${GRIP_PASS_PATH}\`"

    return 1
  fi

  # SAVVY/2020-04-16: The browser window pops up around the same time
  # as pinentry, causing latter to lose focus. We can sleep around it
  # (but then pipentry loses focus, maybe after user starts typing to
  #  it! Oh, well, can't win 'em all).
  # OUTPUTs, e.g.,
  #   Opening in existing browser session.
  /bin/bash -c "sleep 2; sensible-open 'http://${GRIP_PASS_ADDY}/' > /dev/null 2>&1" &

  # Note that `grip --pass <path>` opens a new browser tab, even though
  # docs suggest that only happens when --browser specified.

  # USAGE, e.g.,:
  #   grip-pass docs/history-ci.md
  command grip \
    --pass $(pass "${GRIP_PASS_PATH}" | head -1) \
    "${@}" \
    "${GRIP_PASS_ADDY}"
}

