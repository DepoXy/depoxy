#!/bin/sh
cd "${DOPP_KIT:-${HOME}/.kit}/odd/x11/quicktile"
venv_name=".venv-quicktile"
. "${venv_name}/bin/activate"
exec python3 -m quicktile "$@"
