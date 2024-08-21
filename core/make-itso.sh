# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# DUNNO/2023-11-28: Where else does this belong? Homefries? Some
# other core/ file? Its own project? Suprised I couldn't find an
# existing module for this... snippet.
# - I'm also loathe to add a new file, b/c it affects startup time
#   (FIXEM: unless I start using a Bash compiler!), but I'm also
#   loathe to create a 'misc-fcns.sh' file, though maybe that's
#   where this belongs.

make-inspect-var () {
  local var_name="$1"

  make --eval="print-var: ; @echo \$(${var_name})" print-var
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

