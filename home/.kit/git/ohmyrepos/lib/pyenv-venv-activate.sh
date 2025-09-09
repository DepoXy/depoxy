# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

pyenv_venv_activate() {
  local venv_name="$1"
  local python_vers="${2:-${DEPOXY_PYENV_PYVERS:-3.12.8}}"

  if test -z "${venv_name}"; then
    >&2 error "ERROR: Missing virtualenv name (pyenv_venv_activate)"

    return 1
  fi

  if ! command -v pyenv > /dev/null; then
    >&2 error "ERROR: Where's \`pyenv\`?"

    return 1
  fi

  test "$(command -v deactivate)" = "deactivate" && deactivate

  eval "$(pyenv init -)"

  # Assumes previously installed, e.g.:
  #   pyenv install -s ${DEPOXY_PYENV_PYVERS:-3.12.8}
  pyenv shell ${python_vers}

  local venv_path="${WORKON_HOME:-${HOME}/.virtualenvs}/${venv_name}"

  [ -d "${venv_path}" ] || python3 -m venv "${venv_path}"
  . "${venv_path}/bin/activate"
}
