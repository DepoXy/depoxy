# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2022-2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases () {
  # DUNNO/2022-12-05:
  # - SPIKE: Is this on PATH @home?
  #  claim_alias_or_warn "pw" "putwisely --is-client ${DEPOXY_IS_CLIENT}"
  claim_alias_or_warn "pw" \
    "${HOME}/.kit/git/git-put-wise/bin/putwisely --is-client ${DEPOXY_IS_CLIENT}"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_aliases
  unset -f _dxy_wire_aliases
}

main "$@"
unset -f main

