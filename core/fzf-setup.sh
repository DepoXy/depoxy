# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2024 Landon Bouma. All Rights Reserved.

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
    command -v fd > /dev/null || return

    # (lb): Let's go with the suggested command, sounds about right to me!
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  }

  # ***

  fzf_wire () {
    # Setup fzf wiring
    fzf_update_path
    fzf_wire_completion
    fzf_wire_key_bindings
    fzf_wire_default_cmd_fd
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

    unset -f fzf_wire
    unset -f fzf_unset_fs
  }

  # ***

  fzf_wire

  fzf_unset_fs
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main "$@"

