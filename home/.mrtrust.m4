# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=config
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# ====================================================================

# BWARE: Make sure you're editing the template / USYNC:
#
#   meld ~/.depoxy/ambers/home/.mrtrust.m4 ~/.depoxy/ambers/home/.mrtrust &

# ====================================================================

# SETUP/WIRING:
#
#   m4 \
#     --define=USER_HOME=${HOME} \
#     --define=DOPP_KIT=${DOPP_KIT:-${HOME}/.kit} \
#     .mrtrust.m4 > ~/.mrtrust
#
# Use changecom, otherwise m4 ignores lines with leading `#` characters.
changecom()dnl
# Let user ref template vars in comments with super-quotes.
changequote('[[[', ']]]')dnl

# ====================================================================

# USAGE: List '.mrconfig' files loaded via `chain = true`
#
# - It is not necessary to list those files in .mrtrust that
#   are loaded via `include = mr_cat <path>`
#
# - Note that myrepos is symlink-aware, so you can trust a
#   file only once, even if it's symlinked from elsewhere

USER_HOME/.vim/.mrconfig

