#!/bin/sh
cd "${DOPP_KIT:-${HOME}/.kit}/odd/quicktile"
venv_name=".venv-quicktile"
. "${venv_name}/bin/activate"
exec python3 -m quicktile "$@"
