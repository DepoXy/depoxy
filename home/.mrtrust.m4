# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=config

# SYNC_ME: See KIT_MRCONFIGS in .vimprojects.

# SETUP/WIRING:
#
#   m4 \
#     --define=USER_HOME=${HOME} \
#     --define=DOPP_KIT=${DOPP_KIT:-${HOME}/.kit} \
#     --define=GITREPOSPATH=${GITREPOSPATH:-${HOME}/.kit/git} \
#     .mrtrust.m4 > ~/.mrtrust

# *** Trust OMR behavior profile.

GITREPOSPATH/ohmyrepos/.mrconfig-omr

# *** Trust topmost OMR config.

# - We symlink from ~/.mrconfig to ~/.mrinfuse/.mrconfig, which is
#   ~/.depoxy/ambers/.home/.mrconfig, so inherently trusted.
#   - That is, This-
#     is Not necessary:
#       USER_HOME/.depoxy/ambers/.home/.mrconfig
#     and Neither is This:
#       USER_HOME/.mrconfig

# *** Trust Dubs Vim config.

# - Note that myrepos is symlink-aware, so trust a file only
#   once, even if it's symlinked from elsewhere.
#
#   For instance, we only need to trust one of these paths:
#
#     USER_HOME/.vim/_mrconfig
#     USER_HOME/.depoxy/ambers/home/.vim/_mrconfig
#
#   and do not need to list both.

USER_HOME/.vim/.mrconfig

USER_HOME/.vim/.mrconfig-3rdp
USER_HOME/.vim/.mrconfig-dubs
USER_HOME/.vim/.mrconfig-lsp

# *** Trust the git/ and sh/ config that DepoXy Ambers manages.

# It's actually not necessary to list these, as they are cat'ed,
# but I feel compelled to be verbose.

DOPP_KIT/_mrconfig

DOPP_KIT/git/_mrconfig-git-core
DOPP_KIT/git/_mrconfig-git-smart
DOPP_KIT/go/_mrconfig
DOPP_KIT/js/_mrconfig
DOPP_KIT/mOS/_mrconfig
DOPP_KIT/odd/_mrconfig
DOPP_KIT/py/_mrconfig
DOPP_KIT/sh/_mrconfig-bash
DOPP_KIT/sh/_mrconfig-shell
DOPP_KIT/txt/_mrconfig

# *** Trust DepoXy Client config.

USER_HOME/.depoxy/running/_mrconfig
# Reserveable short-term trusted path, used
# by deploy-archetype.sh during standup.
USER_HOME/.depoxy/.adscititious/_mrconfig

# *** Private client mrconfig can be appended, but not necessary,
#     as cat files are inherently trusted. But also listing here
#     could be helpful if you want a complete list of all mrconfig.

