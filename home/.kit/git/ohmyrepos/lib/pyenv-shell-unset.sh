# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

pyenv_shell_unset() {
  if ! command -v pyenv > /dev/null; then
    >&2 error "ERROR: Where's \`pyenv\`?"

    return 1
  fi

  eval "$(pyenv init -)"

  pyenv shell --unset
}
