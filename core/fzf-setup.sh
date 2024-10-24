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
#   <Alt-C>  — Run FZF on directories under user home, and `cd`
#              into the selected directory
#
#              - Uses FZF_ALT_C_COMMAND or FZF_DEFAULT_COMMAND to
#                collect paths (using either `rg` or `fd`; see below)
#
# - CXREF: ~/.kit/go/fzf/shell/key-bindings.bash
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

main () {
  # Pre-cleanup.
  unset -f main

  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # Custom path resolution.
  # - The fzf/install uses /usr/local.
  # - Here we prefer source checkout first.
  #   - This looks for the conventional DepoXy path (under ~/.kit/go).
  # - We'll also check $(brew prefix), in case `brew install fzf`.
  fzf_base_path () {
    local system_prefix="$(fzf_usr_local_path)"

    for try_path in \
      "${DOPP_KIT:-${HOME}/.kit}/go/fzf" \
      "${system_prefix}/opt/fzf" \
    ; do
      if [ -d "${try_path}" ]; then
        echo "${try_path}"

        return
      fi
    done

    echo ""
  }

  fzf_usr_local_path () {
    if command -v brew > /dev/null; then
      brew --prefix
    else
      echo "/usr/local"
    fi
  }

  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # Global variable and Guard clause.
  local fzf_path="$(fzf_base_path)"

  [ -d "${fzf_path}" ] || return

  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # These three operations are copied from fzf/install's ~/.fzf.bash
  # but I replaced hard coded paths with the more versatile fzf_path.

  # Setup fzf
  # ---------
  fzf_update_path () {
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
  fzf_wire_completion () {
    # CXREF: ~/.kit/go/fzf/shell/completion.bash
    [[ $- == *i* ]] && . "${fzf_path}/shell/completion.bash" 2> /dev/null
  }

  # Key bindings
  # ------------
  fzf_wire_key_bindings () {
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

  fzf_wire_default_cmd_fd () {
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

  fzf_wire_default_cmd_rg () {
    if ${is_fzf_setup:-false} \
      || ${DEPOXY_FZF_PREFER_FD:-false} \
      ! command -v rg > /dev/null \
    ; then

      return
    fi

    # USYNC: Use the same flags as Homefries' `rg`:
    #   ~/.kit/sh/home-fries/lib/alias/alias_rg_tag.sh
    # - Plus: --files / Sans: --smart-case, --colors

    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs --no-ignore-parent -g "!**/{.git,.tox,node_modules,*.svg,*.xpm,.trash,.trash0,.Trash,.Trash0}/**" 2> /dev/null'

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

  fzf_wire_ctrl_f_cmd_fs () {
    __fzf_select_with_sort__ () {
      FZF_CTRL_T_OPTS="--bind 'ctrl-f:reload(${FZF_CTRL_T_COMMAND} | sort)'" __fzf_select__
    }

    bind -x '"\C-f": file="$(__fzf_select_with_sort__ | sed "s# \$##")" && fs "${file}";'
  }

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  # ALT-C - cd into directory picked from fzf prompt showing all dirs under home

  # REFER: bfs — Breadth-first search for your files
  #
  #   https://tavianator.com/projects/bfs.html

  fzf_wire_alt_c_cmd_bfs () {
    command -v bfs > /dev/null \
      || return

    export FZF_ALT_C_COMMAND="cd -- ${HOME}; bfs -type d | sed s#^\.#${HOME}#"
    # " # <-- Vim ft=bash syntax highlighting fix (kludge)
  }

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  fzf_wire () {
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

  fzf_unset_fs () {
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

tx () {
  local target_client_or_session="$1"

  local change

  if [ -n "${TMUX}" ]; then
    change="switch-client"
  else
    change="attach-session"
  fi

  if [ -n "${target_client_or_session}" ]; then
     tmux ${change} -t "${target_client_or_session}" 2>/dev/null \
       || (tmux new-session -d -s "${target_client_or_session}" \
       && tmux ${change} -t "${target_client_or_session}")

     return
  fi

  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) \
    && tmux ${change} -t "${session}" || echo "No sessions found"
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main "$@"

