#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash

# USAGE: Call this script from a Karabiner-Elements (KE) rule.
#
# NOTE: When run from as a launcher (from KE), none of the typical
#       user environment variables will be available,
#       because KE doesn't load your Bash environment.
#
#       Mostly this just means this script makes a few path assumptions.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Use case: This script is basically a shim so you don't have to use a
# really long, obtusely hard to read, and escaped shell command, e.g.,
#
#   "shell_command": "/usr/local/bin/bash -c '/usr/local/Cellar/macvim/latest/MacVim.app/Contents/bin/gvim --servername ${GVIM_OPEN_SERVERNAME:-SAMPI} --remote-send \"<ESC>:call SensibleOpenMoveCursorAvoidSpecial()<CR>\" --remote-silent ${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}/XXXX/docs/Backlog_Client_XXXX.rst'"

# Findability: The Karabiner-Elements shell_command that DepoXy Ambers sets (in, e.g.,
# home/.config/karabiner/assets/complex_modifications/1001-devlpr-docs-launchers.json)
# uses a Bash variable, DEPOXYAMBERS_DIR, which won't be defined. This is solely for
# findability, so that searching DEPOXYAMBERS_DIR reveals the usage in that file. E.g.,
#
#   "shell_command": "${DEPOXYAMBERS_DIR:-${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers}/bin/launchers/gvim-open-with-client-id.sh Backlog_Client_"

# Hint: To debug this script (or any launcher) use desktop notifs to communicate, e.g.,
#
#   # Darwin:
#   /usr/local/bin/terminal-notifier -message "PATH=$PATH"
#
#   # Linux:
#   notify-send "PATH=$PATH"
#   # - Be aware notify-send does nothing with long message, so trunate, e.g.,:
#   notify-send "PATH=$(expr substr "${PATH}" 1 200)"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  # Load optional custom user paths (like DEPOXYAMBERS_DIR).
  [ -f "${HOME}/.config/depoxy/depoxyrc" ] && . ${HOME}/.config/depoxy/depoxyrc

  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local ambers_core="${DEPOXYAMBERS_DIR:-${ambers_path}}/core"

  # Ensure _vendorfs_current_client_find_directory_and_print's `find` is `gfind`.
  # - If you notify from depoxy_fs.sh, e.g.,
  #     /usr/local/bin/terminal-notifier -message "$(type find)"
  #   you'll see it's the old macOS system find, /usr/bin/find.
  # - Fortunately, KE sets $HOME to our user's home, and the
  #   DepoXy Ambers environment has conveniently wired it up,
  #     ~/.local/bin/find -> /usr/local/bin/gfind
  # - Without this, the client name is the empty string. (And
  #   depoxy_fs only prints to stderr, which we don't see.)
  PATH="${HOME}/.local/bin:${PATH}"

  # Load: _vendorfs_path_running_client_print; also
  #       sources optional ~/.config/depoxy/depoxyrc for custom paths.
  . "${ambers_core}/depoxy_fs.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Set a few environment variables here for readability,
# and to keep other functions from being too noisy.
#
# User can set their own paths via ~/.config/depoxy/depoxyrc.

set_path_vars () {
  # CXREF: https://github.com/DepoXy/gvim-open-kindness#🐬
  #   ~/.kit/sh/gvim-open-kindness/bin/gvim-open-kindness
  local kindness_bin="${SHOILERPLATE:-${DOPP_KIT:-${HOME}/.kit}/sh}/gvim-open-kindness/bin"

  PATH="${kindness_bin}:${PATH}"

  # YOU: Just a reminder to set gvim's --servername if you prefer
  #      something different.
  # 
  #   GVIM_OPEN_SERVERNAME=${GVIM_OPEN_SERVERNAME:-SAMPI}
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

open_docs_file () {
  local doc_prefix="$1"

  # There's a function to get the DepoXy Client path, e.g.,
  #   local client_path="$(_vendorfs_path_running_client_print)"
  # but we need the client_name, too, so building path ourselves.

  local client_name="$(_vendorfs_resolve_client_name_underway)"

  local vendorfs_clients_base="$(_vendorfs_path_stints_basedir_print)"

  # Open, e.g., ~/.depoxy/stints/2241/docs/Backlog_Client_2241.rst
  local file_path="${vendorfs_clients_base}/${client_name}/docs/${doc_prefix}${client_name}.rst"

  gvim-open-kindness "${file_path}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  source_deps
  set_path_vars
  open_docs_file "$@"
}

# Run the function if being executed.
# Otherwise being sourced, so do not.
if ! $(printf %s "$0" | grep -q -E '(^-?|\/)(ba|da|fi|z)?sh$' -); then
  main "$@"
fi

