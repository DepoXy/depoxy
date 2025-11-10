# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2024 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE: fzf wires the following (hardcoded) readline bindings:
#
#   <Ctrl-T> — Run FZF on paths under current directory, and paste
#              the selected file path into the command line
#
#              - Uses FZF_CTRL_T_COMMAND or FZF_DEFAULT_COMMAND to
#                collect paths (using either `rg` or `fd`; see below)
#
#   <Ctrl-R> — Run FZF on shell history, and paste the selected
#              command from history to the prompt
#
#   <Alt-C>  — Run FZF on directories under user home, and `pushd`
#              into the selected directory
#
#              - Uses FZF_ALT_C_COMMAND or FZF_DEFAULT_COMMAND to
#                collect paths (using either `rg` or `fd`; see below)
#
# - CXREF: ~/.kit/go/fzf/shell/key-bindings.bash
#
# - REFER:
#   https://github.com/junegunn/fzf/#key-bindings-for-command-line
#   https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
#
# Depoxy also adds its own binding(s):
#
#   <Ctrl-F> — Like <Ctrl-T> but opens selected file in gVim (runs
#              DepoXy's `fs` alias).
#
# - As well as a tmux utility function:
#
#   tx [client-or-session] — Attach to the named tmux client-or-session,
#                            or prompt user using `fzf`
#
# See also DepoXy Vim bindings:
#
#   \F       — Open FZF in Vim on paths under user home
#              (akin to running <Ctrl-T> from user home)
#
#   \f       — Open FZF in Vim on paths in current Git project
#              (akin to running <Ctrl-T> from `git root`)
#
#   :F <term> — Open FZF in Vim on files with matching <term>
#               in their contents
#
# - CXREF:
#   ~/.kit/nvim/DepoXy/start/vim-depoxy/plugin/fzf-config.vim
#
# Fuzzy completion for bash and zsh
#
#   # Files under the current directory (or [directory/]),
#   # matching optional [match].
#   # - You can select multiple items with TAB key.
#   nvim [directory/][match]**<TAB>
#
#   # Similar, change directory (single-selection).
#   cd [directory/][match]**<TAB>
#
#   # Kill process(es) by ID.
#   # - Can select multiple processes with <TAB> or <Shift-TAB> keys.
#   kill -9 **<TAB>
#
#   # Host names (from /etc/hosts and ~/.ssh/config).
#   ssh **<Tab>
#   telnet **<Tab>
#
#   # Environs & aliases.
#   unset **<Tab>
#   export **<Tab>
#   unalias **<Tab>
#
# - You can change the trigger sequence via an environ, e.g.:
#
#   # Use ~~ as the trigger sequence instead of the default **.
#   export FZF_COMPLETION_TRIGGER='~~'
#
# - You can modify other runtime characteristics, too, e.g.:
#
#   # Options to fzf command
#   export FZF_COMPLETION_OPTS='--border --info=inline'
#
#   # Options for path completion (e.g. vim **<TAB>)
#   export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
#
#   # Options for directory completion (e.g. cd **<TAB>)
#   export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'
#
#   # Advanced customization of fzf options via _fzf_comprun function
#   # - The first argument to the function is the name of the command.
#   # - You should make sure to pass the rest of the arguments ($@) to fzf.
#   _fzf_comprun() {
#     local command=$1
#     shift
#
#     case "$command" in
#       cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
#       export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
#       ssh)          fzf --preview 'dig {}'                   "$@" ;;
#       *)            fzf --preview 'bat -n --color=always {}' "$@" ;;
#     esac
#   }
#
# - SAVVY: To see which commands are wired for fuzzy completion, look for
#   `_fzf_`-prefixed commands.
#
#   complete | grep _fzf
#   # Show just the command names:
#   complete | grep _fzf | awk '{print $NF}' | sort
#
#   - You'll note that most commands use fzf for selecting file paths, and
#     that just a handful are more magical (e.g., cd, export, kill, printenv,
#     ssh, unalias, unset, etc.).
#
# - REFER:
#   https://github.com/junegunn/fzf/#fuzzy-completion-for-bash-and-zsh
#
# Examples
#
# - REFER: A plethora of interesting use cases and code, including:
#
#   - git
#     https://github.com/junegunn/fzf/wiki/Examples#git
#
#   - kubectl
#     https://github.com/junegunn/fzf/wiki/Examples#kubectl
#
#   - pass
#     https://github.com/junegunn/fzf/wiki/Examples#pass-and-pass-tomb
#
#   - Homebrew
#     https://github.com/junegunn/fzf/wiki/Examples#homebrew
#     https://github.com/junegunn/fzf/wiki/Examples#homebrew-cask
#
#   - Flatpak
#     https://github.com/junegunn/fzf/wiki/Examples#flatpak
#
#   - Conda
#     https://github.com/junegunn/fzf/wiki/Examples#conda
#
#   - Google Chrome (browsing history, bookmarks)
#     https://github.com/junegunn/fzf/wiki/Examples#google-chrome
#
#   - NPM
#     https://github.com/junegunn/fzf/wiki/Examples#npm
#
#   - locate
#     https://github.com/junegunn/fzf/wiki/Examples#locate
#
#   - readline (invoke readline funcs. by name)
#     https://github.com/junegunn/fzf/wiki/Examples#readline
#
#   - Vagrant
#     https://github.com/junegunn/fzf/wiki/Examples#vagrant
#
#   - Docker
#     https://github.com/junegunn/fzf/wiki/Examples#docker
#
#   - Man
#     https://github.com/junegunn/fzf/wiki/Examples#man-pages
#
#   - Emoji (emoji.txt)
#     https://github.com/junegunn/fzf/wiki/Examples#emoji
#       emojis=$(curl -sSL 'https://git.io/JXXO7')
#       selected_emoji=$(echo $emojis | fzf)
#       echo $selected_emoji
#     https://git.io/JXXO7 ->
#       https://gist.githubusercontent.com/keidarcy/128141ff30a8c3f9ddc0d6c3ecb5b334/raw/8fc6b9efe6b72e8a876639e239043d492e857746/emoji.txt
#     From:
#       https://gist.github.com/keidarcy/128141ff30a8c3f9ddc0d6c3ecb5b334
#
#   - CALSO: A collection of FZF scripts:
#     https://github.com/DanielFGray/fzf-scripts
#
# - REFER:
#   https://github.com/junegunn/fzf/wiki/Examples

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# HSTRY/2020-02-06: The basis for this file was generated by the `fzf`
# install script, then refactored into functions and commented.
#
#   https://github.com/junegunn/fzf/blob/master/install
#
# SAVVY/2024-10-19: Note that `install` has not been run since then,
# so any changes in the past 4+ years have not been integrated.
#
# SAVVY/2021-01-21: On macOS, `brew install fzf` does not call fzf/install.
# - And running fzf/install just creates ~/.fzf.bash, the essence of which
#   was incorporated into this file.
# - I.e., if you `brew install fzf`, you don't need to `fzf/install`.
#
# THANX: The additional <Alt-C> and <Ctrl-F> bindings, and the tx()
# function, were inspired by (dead link):
#
#   http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main() {
  # Pre-cleanup.
  unset -f main

  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # Custom path resolution.
  # - The fzf/install uses /usr/local.
  # - Here we prefer source checkout first.
  #   - This looks for the conventional DepoXy path (under ~/.kit/go).
  # - We'll also check $(brew prefix), in case `brew install fzf`.
  fzf_base_path() {
    local system_prefix="$(fzf_usr_local_path)"

    for try_path in \
      "${DOPP_KIT:-${HOME}/.kit}/go/fzf" \
      "${system_prefix}/opt/fzf"; do
      if [ -d "${try_path}" ]; then
        echo "${try_path}"

        return
      fi
    done

    echo ""
  }

  fzf_usr_local_path() {
    if command -v brew > /dev/null; then
      brew --prefix
    else
      echo "/usr/local"
    fi
  }

  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # Global variable and Guard clause.
  local fzf_path="$(fzf_base_path)"

  [ -d "${fzf_path}" ] || return 0

  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # These three operations are copied from fzf/install's ~/.fzf.bash
  # but I replaced hard coded paths with the more versatile fzf_path.

  # Setup fzf
  # ---------
  fzf_update_path() {
    # 2022-11-05: Prefer ~/.local/bin/fzf, which is how DepoXy wires
    # fzf using OMR `infuse` task.
    # - SAVVY: This block skipped in normal DepoXy environment,
    #   because ~/.local/bin/fzf already on PATH.
    if [ ! -e "${HOME}/.local/bin/fzf" ] && [[ ! "$PATH" == *${fzf_path}/bin* ]]; then
      # (lb): FZF defaults to after PATH, but put before,
      # so that local source found before /usr/local/bin.
      # - I.e., not this:
      #     export PATH="${PATH:+${PATH}:}${fzf_path}/bin"
      #   But this:
      #     export PATH="${fzf_path}/bin${PATH:+:${PATH}}"
      #   But also using our PATH utility:
      path_prefix "${fzf_path}/bin"
    fi
  }

  # Auto-completion
  # ---------------
  # Only apply if [i]nteractive shell.
  fzf_wire_completion() {
    # CXREF: ~/.kit/go/fzf/shell/completion.bash
    [[ $- == *i* ]] && . "${fzf_path}/shell/completion.bash" 2> /dev/null
  }

  # Key bindings
  # ------------
  fzf_wire_key_bindings() {
    # CXREF: ~/.kit/go/fzf/shell/key-bindings.bash
    . "${fzf_path}/shell/key-bindings.bash"
  }

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # <Ctrl-T> — Run fzf on files in the current directory.

  # This script defaults to using `rg`, but you can opt-in `fd` instead.
  local DEPOXY_FZF_PREFER_FD="${DEPOXY_FZF_PREFER_FD:-false}"

  local is_fzf_setup=false

  # REFER/2020-02-12: Here's an `fd` command crash course, courtesy junegunn:
  #
  #   https://github.com/junegunn/fzf#respecting-gitignore
  #
  #     # Feed the output of fd into fzf
  #     fd --type f --strip-cwd-prefix | fzf
  #
  #     # Setting fd as the default source for fzf
  #     export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
  #
  #     # Now fzf (w/o pipe) will use the fd command to generate the list
  #     fzf
  #
  #     # To apply the command to CTRL-T as well (CRUMB: <Ctrl-t> <C-t>)
  #     export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  #
  #     # If you want the command to follow symbolic links, and don't
  #     # want it to exclude hidden files, use the following command:
  #
  #     export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

  fzf_wire_default_cmd_fd() {
    if ${is_fzf_setup:-false} \
      || ! ${DEPOXY_FZF_PREFER_FD:-false} \
        ! command -v fd > /dev/null \
      ; then

      return
    fi

    # This is the suggested command from fzf/README.md
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

    is_fzf_setup=true
  }

  # ***

  # SAVVY/2024-10-19: In author's DepoXy environment, running the `fd`
  # and `rg` variants on user home produce different sets of results:
  # - With `rg`, <Ctrl-T> finds 377906 paths under home.
  # - With `fd`, <Ctrl-T> finds 228691 paths under home.
  # I have not investigated what's different, but we'll use the more
  # inclusive `rg` (they both run in about the same amount of time).
  # - If we later discover `rg` includes a lot of noise, perhaps it'll
  #   encourage us to tweak our .ignore rules.

  fzf_wire_default_cmd_rg() {
    if ${is_fzf_setup:-false} \
      || ${DEPOXY_FZF_PREFER_FD:-false} \
        ! command -v rg > /dev/null \
      ; then

      return
    fi

    # USYNC: Uses the same flags as Homefries' `rg`:
    #   ~/.kit/sh/home-fries/lib/alias/alias_rg_tag.sh
    # - Plus: --files / Sans: --smart-case, --colors
    # REFER: See similar rg --glob's (found locally at these paths within DepoXy environ):
    #   ~/.depoxy/ambers/core/fzf-setup.sh
    #   ~/.kit/sh/home-fries/lib/alias/alias_rg_tag.sh
    #   ~/.kit/nvim/landonb/dubs_grep_steady/bin/vim-grepprg-rg-sort
    #   ~/.kit/nvim/landonb/.whilom/dubs_file_finder/plugin/dubs_file_finder.vim

    # USYNC: Copy the final ${FZF_DEFAULT_COMMAND} to DepoXy Vim:
    #   ~/.kit/nvim/DepoXy/start/vim-depoxy/plugin/fzf-config.vim

    local dglobs=()
    local fglobs=()
    # Common dev tool directories
    dglobs+=(".git")
    dglobs+=(".tox")
    dglobs+=("node_modules")
    # Home directories
    # Vim's ~/.vim_backups/*.swp
    fglobs+=("*.swp")
    # Graphics, Document, and other files (you probably won't open in text)
    fglobs+=("*.3gp")
    fglobs+=(".bash_history")
    fglobs+=("*.bin")
    fglobs+=("*.dat")
    fglobs+=("*.gif")
    fglobs+=("*.gpg")
    fglobs+=("*.ithmb")
    fglobs+=("*.jpeg")
    fglobs+=("*.jpg")
    fglobs+=("*.Jpg")
    fglobs+=("*.JPG")
    fglobs+=(".localized")
    fglobs+=("*.nib")
    fglobs+=("*.odg")
    fglobs+=("*.odt")
    fglobs+=("*.otf")
    # SAVVY: `rg --ignore-case` doesn't seem to work on globs, so add permutations.
    fglobs+=("*.pdf")
    fglobs+=("*.Pdf")
    fglobs+=("*.PDF")
    fglobs+=("*.png")
    fglobs+=("*.pyc")
    fglobs+=("*.strings")
    fglobs+=("*.svg")
    fglobs+=("*.swp")
    fglobs+=("*.tagset")
    fglobs+=("*.ttf")
    fglobs+=(".viminfo")
    fglobs+=("*.xpm")
    fglobs+=("*.zip")
    # DepoXy-specific directories
    dglobs+=(".crypt")
    # Vim :Helptags tags files
    fglobs+=("doc/tags")

    local dir_globs=""
    local dglob
    for dglob in "${dglobs[@]}"; do
      [ -z "${dir_globs}" ] || dir_globs="${dir_globs},"
      dir_globs="${dir_globs}${dglob}"
    done

    local file_globs=""
    local fglob
    for fglob in "${fglobs[@]}"; do
      [ -z "${file_globs}" ] || file_globs="${file_globs},"
      file_globs="${file_globs}${fglob}"
    done

    export FZF_DEFAULT_COMMAND="$(
      echo "
        rg
          --files
          --hidden
          --follow
          --no-ignore-vcs
          --no-ignore-parent
          --glob '!**/{${dir_globs}}/**'
          --glob '!**/{${file_globs}}'
        2> /dev/null" \
        | tr -d '$\n' | sed 's/  \+/ /g' | sed 's/^ \+//'
    )"

    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

    is_fzf_setup=true
  }

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # SAVVY: By default, readline <Ctrl-F> moves the cursor forward one character.
  #
  #   $ bind -P | grep "C\-f"
  #   forward-char can be found on "\C-f", "\eOC", "\e[C".
  #   shell-forward-word can be found on "\e\C-f", "\e[1;6C".
  #
  # - Where "\C-f", "\eOC", "\e[C" are: <Ctrl-F>,
  #   <Right> (Keypad mode), <Right> (ANSI mode).

  # HSTRY: This command used to be bound to <Ctrl-P>, and it used to not
  # have the sort option:
  #
  #     bind -x '"\C-p": file="$(fzf)" && fs "${file}";'
  #
  # - Note that readline <Ctrl-P> pastes the previous command + args:
  #
  #     $ bind -P | grep -e "C\-p"
  #     previous-history can be found on "\C-p", "\eOA".
  #
  #   But it's also bound to "\eOA" (<Up>, which author uses all the time,
  #   as I'm sure do most folx).
  #
  #   - So reassinging <Ctrl-P> loses nothing except a redundant binding.
  #
  # (So noted just in case you later realize you want <Ctrl-F> forward-char back.)

  # SAVVY: Use && so user can <Ctrl-C> cancel, as opposed to using a
  # "simpler" syntax, e.g.,
  #   bind -x '"\C-p": fs $(fzf);'
  #   # Or:
  #   bind -x '"\C-p": vim $(fzf);'

  # SAVVY: Remove trailing space from __fzf_select__, which it inserts
  # as a convenience, I assume, because <Ctrl-T> is used to paste the
  # FZF selection to the prompt.

  # CALSO: <Ctrl-F> is similar to <Ctrl-T>, but it opens the picked file:
  # - \C-t pastes picked file to prompt
  # - \C-f opens picked file in gVim (via `fs`)

  # USAGE: After FZF starts, press <Ctrl-F> again to *sort* the list (which
  # re-runs the query, so maybe not something you want to do on a path with
  # lots of files beneath it).

  fzf_wire_ctrl_f_cmd_fs() {
    __fzf_select_with_sort__() {
      FZF_CTRL_T_OPTS="--bind 'ctrl-f:reload(${FZF_CTRL_T_COMMAND} | sort)'" __fzf_select__
    }

    bind -x '"\C-f": file="$(__fzf_select_with_sort__ | sed "s# \$##")" && fs "${file}";'
  }

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # ALT-C - pushd into directory picked from fzf prompt showing all dirs under home

  # REFER: bfs — Breadth-first search for your files
  #
  #   https://tavianator.com/projects/bfs.html

  # CXREF: Wired by junegunn/fzf, found locally in DepoXy environment at:
  #   ~/.kit/go/fzf/shell/key-bindings.bash

  fzf_wire_alt_c_cmd_bfs() {
    command -v bfs > /dev/null \
      || return 0

    # Run __fzf_cd__ on current dir., and convert relative paths to full.
    export FZF_ALT_C_COMMAND="bfs -type d | sed s#^\.#\$(pwd)#"
    # " # <-- (n)vim ft=bash syntax highlighting fix (kludge)

    # Defaults: `build cd -- %1`
    # - SAVVY: This environ is in landonb/fzf, fork of junegunn/fzf.
    export FZF_ALT_C_CD_COMMAND="builtin pushd -- %q > /dev/null"
  }

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  fzf_wire() {
    # Setup fzf wiring
    fzf_update_path
    fzf_wire_completion
    fzf_wire_key_bindings
    # This script defaults to using `rg`, but you can opt-in `fd` instead.
    fzf_wire_default_cmd_fd
    fzf_wire_default_cmd_rg
    # DepoXy binding: Open fzf-selected file in gVim.
    fzf_wire_ctrl_f_cmd_fs
    # Wire <Alt-C> `cd` convenience
    fzf_wire_alt_c_cmd_bfs
  }

  # ***

  # SAVVY: An outer function scope does not shadow functions, they
  # still pollute the shell, so unset 'em to keep your env. tidy.

  fzf_unset_fs() {
    unset -f fzf_base_path
    unset -f fzf_usr_local_path

    unset -f fzf_update_path
    unset -f fzf_wire_completion
    unset -f fzf_wire_key_bindings
    unset -f fzf_wire_default_cmd_fd
    unset -f fzf_wire_default_cmd_rg
    unset -f fzf_wire_ctrl_f_cmd_fs
    unset -f fzf_wire_alt_c_cmd_bfs

    unset -f fzf_wire
    unset -f fzf_unset_fs
  }

  # ***

  fzf_wire

  fzf_unset_fs
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE:
#
# `tx <session>` — attaches to the named session (if it exists), else creates it
#
# `tx` — opens fzf and lets you select the tmux session

# SAVVY: Try connecting to existing session to test, then <Ctrl-A>d to detach.

tx() {
  local target_client_or_session="$1"

  local change

  if [ -n "${TMUX}" ]; then
    change="switch-client"
  else
    change="attach-session"
  fi

  if [ -n "${target_client_or_session}" ]; then
    tmux ${change} -t "${target_client_or_session}" 2> /dev/null \
      || (tmux new-session -d -s "${target_client_or_session}" \
        && tmux ${change} -t "${target_client_or_session}")

    return
  fi

  session=$(tmux list-sessions -F "#{session_name}" 2> /dev/null | fzf --exit-0) \
    && tmux ${change} -t "${session}" || echo "No sessions found"
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main "$@"
