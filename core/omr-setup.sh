# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Assign sf-* and st-* aliases:
# - sf-client sf-work sf-home sf-user sf-vim sf-sh sf-git sf-kit
# - st-client st-work st-home st-user st-vim st-sh st-git st-kit
_dxy_wire_aliases_omr_status () {
  # NOTE: "sf-*" are fancy status mappings.
  # HINT: "st-" is unique prefix, type `st-<TAB>` to list options.
  for omr_group in "client" "work" "home" "user" "vim" "sh" "git" "kit"; do
    claim_alias_or_warn "sf-${omr_group}" "MR_INCLUDE=${omr_group} OMR_MYSTATUS_FANCY=true mr -d / mystatus"
    claim_alias_or_warn "st-${omr_group}" "MR_INCLUDE=${omr_group} OMR_MYSTATUS_FANCY=false mr -d / mystatus"
  done
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_omr_status_snip_cd () {
  # For copy-paste printed by:
  #   ~/.kit/git/ohmyrepos/lib/git-my-merge-status.sh
  #   ~/.kit/git/ohmyrepos/lib/sync-travel-remote.sh
  export OMR_CPYST_CD='cdd'
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_check_if_omr_infuse_run_since_latest_macos_update () {
  if ! os_is_macos; then

    return 0
  fi

  local ambers_hidden_bin="${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}/home/.depoxy/ambers/bin"
  # CXREF: ~/.depoxy/ambers/home/.depoxy/ambers/bin/verify-cache-macos-version
  local verify_cache_macos_version="${ambers_hidden_bin}/verify-cache-macos-version"

  if ! "${verify_cache_macos_version}"; then
    # Reset cursor in case HOMEFRIES_LOADINGDOTS.
    printf '\r'
    echo "$(attr_emphasis)Please run$(attr_reset)" \
      "\`$(attr_bold)sudo -v; infuse$(attr_reset)\`" \
      "$(attr_emphasis)given that$(attr_reset) macOS $(attr_emphasis)was $(attr_reset)"
    echo "          " \
      "   三       三   " \
      "$(attr_underline)recently updated$(attr_reset) 🔔"
    echo "              三       三        ᕕ( ᐛ )ᕗ"
    echo "$(attr_emphasis)Or expressly:$(attr_reset)"
    echo "           " \
      "$(attr_bold)sudo -v; ~/.depoxy/ambers/home/infuse-platform-macOS$(attr_reset)"
  fi
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_aliases_omr_status
  unset -f _dxy_wire_aliases_omr_status

  _dxy_wire_omr_status_snip_cd
  unset -f _dxy_wire_omr_status_snip_cd

  _dxy_check_if_omr_infuse_run_since_latest_macos_update
  unset -f _dxy_check_if_omr_infuse_run_since_latest_macos_update
}

main "$@"
unset -f main

