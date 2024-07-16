# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2024 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# SAVVY/2024-05-21: Here's what MacPorts GUI install appends to ~/.profile:
#
#   ##
#   # Your previous /Users/user/.profile file was backed up as
#   #   /Users/user/.profile.macports-saved_2024-05-21_at_00:42:45
#   ##
#
#   # MacPorts Installer addition on 2024-05-21_at_00:42:45: adding
#   #   an appropriate PATH variable for use with MacPorts.
#   export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
#   # Finished adapting your PATH environment variable for use with MacPorts.

infuse_port_shellenv () {
  path_prefix "/opt/local/sbin"
  path_prefix "/opt/local/bin"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  infuse_port_shellenv
  unset -f infuse_port_shellenv
}

if [ "$(basename -- "$0")" = "portskies.sh" ]; then
  >&2 echo "ERROR: Trying sourcing the file instead: . $0" && exit 1
else
  main "$@"
fi

unset -f main

