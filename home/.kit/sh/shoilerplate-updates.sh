#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# CXREF:
# ~/.kit/sh/sh-source-deps-template/lib/shoilerplate.m4.sh
# ~/.kit/sh/sh-source-deps-template/lib/shoilerplate-update.sh

SHUPDATER="${SHUPDATER:-${SHOILERPLATE:-${HOME}/.kit/sh}/sh-source-deps-template/lib/shoilerplate-update.sh}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

shoilerplate_updates () {
  # git/git-my-merge-status
  ${SHUPDATER} \
    "${GITREPOSPATH:-${HOME}/.kit/git}/git-my-merge-status/bin/git-my-merge-status" \
    _git_my_merge_status_ \
    "$(cat <<'EOF'
  # Load git_* funcs (e.g., git_branch_name), vars (GITNUBS_RE_VERSPARTS), etc.
  #  https://github.com/landonb/sh-git-nubs
  _git_my_merge_status__source_file "${prefix}" "../deps/sh-git-nubs/lib" "git-nubs.sh"
EOF
    )"

  # ***

  # git/ohmyrepos/lib/any-action-runtime.sh
  # CALSO: "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib/any-action-runtime.sh"
  ${SHUPDATER} \
    "${OHMYREPOS_LIB:-${HOME}/.ohmyrepos/lib}/any-action-runtime.sh" \
    _any_action_runtime_sh_ \
    "$(cat <<'EOF'
  # Load the log library, which includes `warn`, etc.
  # - As a side-effect, this also loads the stream-injectable
  #   color/style library, colors.sh.
  # - And, because this file is the first `include` from this
  #   project's .mrconfig-omr, the libraries sourced here will
  #   be available to all the other ohmyrepos/lib/*.sh scripts.
  # - Lastly, the .mrconfig-omr file sets, e.g., `lib = PATH=...`
  #   which enables the path-less source logger.sh here to work.
  # Load the logger library, from github.com/landonb/sh-logger.
  _any_action_runtime_sh__source_file "${prefix}" "../deps/sh-logger/bin" "logger.sh"

  # Load `print_nanos_now`.
  _any_action_runtime_sh__source_file "${prefix}" "../deps/sh-print-nanos-now/bin" "print-nanos-now.sh"
EOF
    )"

  # git/ohmyrepos/lib/git-auto-commit.sh
  # CALSO: "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib/git-auto-commit.sh"
  ${SHUPDATER} \
    "${OHMYREPOS_LIB:-${HOME}/.ohmyrepos/lib}/git-auto-commit.sh" \
    _git_auto_commit_sh_ \
    "$(cat <<'EOF'
  # Load the logger library, from github.com/landonb/sh-logger.
  # - Includes print commands: info, warn, error, debug.
  _git_auto_commit_sh__source_file "${prefix}" "../deps/sh-logger/bin" "logger.sh"

  _git_auto_commit_sh__source_file "${prefix}" "" "overlay-symlink.sh"
EOF
    )"

  # git/ohmyrepos/lib/git-my-merge-status.sh
  # CALSO: "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib/git-my-merge-status.sh"
  ${SHUPDATER} \
    "${OHMYREPOS_LIB:-${HOME}/.ohmyrepos/lib}/git-my-merge-status.sh" \
    _git_my_merge_status_sh_ \
    "$(cat <<'EOF'
  # Only source deps when not included by OMR.
  # - This supports user sourcing this file directly,
  #   and it helps OMR avoid re-sourcing the same files.
  if [ -z "${MR_CONFIG}" ]; then
    # Load the logger library, from github.com/landonb/sh-logger.
    _git_my_merge_status_sh__source_file "${prefix}" "../deps/sh-logger/bin" "logger.sh"

    # Load `print_nanos_now`.
    _git_my_merge_status_sh__source_file "${prefix}" "../deps/sh-print-nanos-now/bin" "print-nanos-now.sh"
  fi

  # Load: mr_process_id, is_multiprocessing
  _git_my_merge_status_sh__source_file "${prefix}" "" "mr-process-id.sh"
EOF
    )"

  # git/ohmyrepos/lib/link-private-exclude.sh
  # CALSO: "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib/link-private-exclude.sh"
  ${SHUPDATER} \
    "${OHMYREPOS_LIB:-${HOME}/.ohmyrepos/lib}/link-private-exclude.sh" \
    _link_private_exclude_sh_ \
    "$(cat <<'EOF'
  # Load: symlink_*.
  _link_private_exclude_sh__source_file "${prefix}" "" "overlay-symlink.sh"
EOF
    )"

  # git/ohmyrepos/lib/link-private-ignore.sh
  # CALSO: "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib/link-private-ignore.sh"
  ${SHUPDATER} \
    "${OHMYREPOS_LIB:-${HOME}/.ohmyrepos/lib}/link-private-ignore.sh" \
    _link_private_ignore_sh_ \
    "$(cat <<'EOF'
  # Load: symlink_*.
  _link_private_ignore_sh__source_file "${prefix}" "" "overlay-symlink.sh"
EOF
    )"

  # git/ohmyrepos/lib/overlay-symlink.sh
  # CALSO: "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib/overlay-symlink.sh"
  ${SHUPDATER} \
    "${OHMYREPOS_LIB:-${HOME}/.ohmyrepos/lib}/overlay-symlink.sh" \
    _overlay_symlink_sh_ \
    "$(cat <<'EOF'
  # Load the logger library, from github.com/landonb/sh-logger.
  # - This also implicitly loads the colors.sh library.
  _overlay_symlink_sh__source_file "${prefix}" "../deps/sh-logger/bin" "logger.sh"

  # Load: print_unresolved_path, realpath_s
  _overlay_symlink_sh__source_file "${prefix}" "" "print-unresolved-path.sh"
EOF
    )"

  # git/ohmyrepos/lib/sorted-commit.sh
  # CALSO: "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib/sorted-commit.sh"
  ${SHUPDATER} \
    "${OHMYREPOS_LIB:-${HOME}/.ohmyrepos/lib}/sorted-commit.sh" \
    _sorted_commit_sh_ \
    "$(cat <<'EOF'
  # Load the logger library, from github.com/landonb/sh-logger.
  # - Includes print commands: info, warn, error, debug.
  _sorted_commit_sh__source_file "${prefix}" "../deps/sh-logger/bin" "logger.sh"
EOF
    )"

  # git/ohmyrepos/lib/sync-travel-remote.sh
  # CALSO: "${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib/sync-travel-remote.sh"
  ${SHUPDATER} \
    "${OHMYREPOS_LIB:-${HOME}/.ohmyrepos/lib}/sync-travel-remote.sh" \
    _sync_travel_remote_sh_ \
    "$(cat <<'EOF'
  # Load the logger library, from github.com/landonb/sh-logger.
  # - Includes print commands: info, warn, error, debug.
  _sync_travel_remote_sh__source_file "${prefix}" "../deps/sh-logger/bin" "logger.sh"

  # Load: mr_process_id, is_multiprocessing
  _sync_travel_remote_sh__source_file "${prefix}" "" "mr-process-id.sh"

  # Load: print_homebrew_prefix
  _sync_travel_remote_sh__source_file "${prefix}" "" "print-homebrew-prefix.sh"
EOF
    )"

  # ***

  # odd/git-rebase-tip
  ${SHUPDATER} \
    "${GITREPOSPATH:-${HOME}/.kit/git}/git-rebase-tip/bin/git-rebase-tip" \
    _git_rebase_tip_ \
    "$(cat <<'EOF'
  # Runs: _grtcommon_source_deps
  _git_rebase_tip__source_file "${prefix}" "../lib" "git-rebase-tip-common.sh"
EOF
    )"

  # ***

  # odd/biblio-gpg
  ${SHUPDATER} \
    "${DOPP_KIT:-${HOME}/.kit}/odd/321open/lib/biblio-gpg" \
    _biblio_gpg_ \
    "$(cat <<'EOF'
  # Load: highlight, infuse_symlink_from_home_to_paddock_unless_conflict
  _biblio_gpg__source_file "${prefix}" "" "biblio.321"
EOF
    )"

  # odd/biblio-ssh
  ${SHUPDATER} \
    "${DOPP_KIT:-${HOME}/.kit}/odd/321open/lib/biblio-ssh" \
    _biblio_ssh_ \
    "$(cat <<'EOF'
  # Load: highlight, infuse_symlink_from_home_to_paddock_unless_conflict
  _biblio_ssh__source_file "${prefix}" "" "biblio.321"

  # Load: verify_environment, verify_or_start_agent, ssh_add_key_with_passphrase.
  # - CXREF: ~/.kit/odd/321open/bin/ssh-agent-kick
  _biblio_ssh__source_file "${prefix}" "../bin" "ssh-agent-kick"

  # Load: ssh_agent_kill
  # - CXREF: ~/.kit/odd/321open/bin/ssh-agent-kill
  _biblio_ssh__source_file "${prefix}" "../bin" "ssh-agent-kill"
EOF
    )"

  # odd/biblio.321
  ${SHUPDATER} \
    "${DOPP_KIT:-${HOME}/.kit}/odd/321open/lib/biblio.321" \
    _biblio_321_ \
    "$(cat <<'EOF'
  # Load: error, notice, info, debug, etc., and colors.sh.
  # - CXREF: ~/.kit/sh/sh-logger/bin/logger.sh
  #     https://github.com/landonb/sh-logger#🎮🐸
  # - CXREF: ~/.kit/sh/sh-colors/bin/colors.sh
  #     https://github.com/landonb/sh-colors#💥
  _biblio_321__source_file "${prefix}" "../deps/sh-logger/bin" "logger.sh"
  LOG_LEVEL=${LOG_LEVEL_DEBUG}

  # Load: apfs_mount, print_apfs_volume_id, print_volume_mountpoint, etc.
  # - CXREF:~/.kit/odd/321open/deps/macOS-disktools/bin/apfs-mount
  #     https://github.com/DepoXy/macOS-disktools#⚱️
  _biblio_321__source_file "${prefix}" "../deps/macOS-disktools/bin" "apfs-mount"

  # Load: dmg_mount, print_disk_image_mountpoint, DMG_IMAGE_SUFFIX, etc.
  # - CXREF: ~/.kit/odd/321open/deps/macOS-disktools/bin/dmg-mount
  #     https://github.com/DepoXy/macOS-disktools#⚱️
  _biblio_321__source_file "${prefix}" "../deps/macOS-disktools/bin" "dmg-mount"
EOF
    )"

  # odd/key_paddock.sh
  ${SHUPDATER} \
    "${DOPP_KIT:-${HOME}/.kit}/odd/321open/lib/key_paddock.sh" \
    _key_paddock_sh_ \
    "$(cat <<'EOF'
  # Load: infuse_symlinks_paddock_gpg, remove_symlinks_paddock_gpg
  _key_paddock_sh__source_file "${prefix}" "" "biblio-gpg"

  # Load: infuse_symlinks_paddock_ssh, remove_symlinks_paddock_ssh
  _key_paddock_sh__source_file "${prefix}" "" "biblio-ssh"

  # Load: infuse_symlinks_paddock_home_subdir, remove_symlinks_paddock_home_subdir
  _key_paddock_sh__source_file "${prefix}" "" "biblio.321"
EOF
    )"

  # ***

  # sh/feature-coverage-report
  ${SHUPDATER} \
    "${SHOILERPLATE:-${HOME}/.kit/sh}/feature-coverage-report/bin/feature-coverage-report" \
    _feature_coverage_report_ \
    "$(cat <<'EOF'
  # https://github.com/landonb/sh-colors
  _feature_coverage_report__source_file "${prefix}" "../deps/sh-colors/bin" "colors.sh"
  _feature_coverage_report__source_file "${prefix}" "../deps/sh-logger/bin" "logger.sh"
  # Load `print_nanos_now`.
  _feature_coverage_report__source_file "${prefix}" "../deps/sh-print-nanos-now/bin" "print-nanos-now.sh"
  # Load `git_branch_name`, `git_HEAD_commit_sha`, etc.
  _feature_coverage_report__source_file "${prefix}" "../deps/sh-git-nubs/lib" "git-nubs.sh"

  # The spinners file is not a dependency, per se, but we load it here
  # so that feature-coverage-report can execute through a symlink.
  _feature_coverage_report__source_file "${prefix}" "../spin" "cli-spinners.sh"

  LOG_LEVEL=${LOG_LEVEL_WARNING}
EOF
    )"

  # sh/salvage-fiefdom
  ${SHUPDATER} \
    "${SHOILERPLATE:-${HOME}/.kit/sh}/salvage-fiefdom/bin/salvage-fiefdom" \
    _salvage_fiefdom_ \
    "$(cat <<'EOF'
  # Load `print_nanos_now`.
  _salvage_fiefdom__source_file "${prefix}" "../deps/sh-print-nanos-now/bin" "print-nanos-now.sh"
EOF
    )"

  # sh/logger.sh
  ${SHUPDATER} \
    "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-logger/bin/logger.sh" \
    _sh_logger_sh_ \
    "$(cat <<'EOF'
  # https://github.com/landonb/sh-colors
  _sh_logger_sh__source_file "${prefix}" "../deps/sh-colors/bin" "colors.sh"
EOF
    )"

  # sh/rm_safe
  ${SHUPDATER} \
    "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-rm_safe/bin/rm_safe" \
    _rm_safe_ \
    "$(cat <<'EOF'
  # https://github.com/landonb/sh-colors
  _rm_safe__source_file "${prefix}" "../deps/sh-colors/bin" "colors.sh"

  _rm_safe__source_file "${prefix}" "." "path_device"
EOF
    )"

  # sh/sensible-open/bin/_sensibleopen-format-open-command
  ${SHUPDATER} \
    "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-sensible-open/bin/_sensibleopen-format-open-command" \
    __sensibleopen_format_open_command_ \
    "$(cat <<'EOF'
  __sensibleopen_format_open_command__source_file "${prefix}" "./" "_sensibleopen-browser-nickname"
EOF
    )"

  # sh/sensible-open/bin/sensible-open
  ${SHUPDATER} \
    "${SHOILERPLATE:-${HOME}/.kit/sh}/sh-sensible-open/bin/sensible-open" \
    _sensible_open_ \
    "$(cat <<'EOF'
  _sensible_open__source_file "${prefix}" "./" "_sensibleopen-format-open-command"
  # In lieu of the previous command calling its source_deps,
  # which it only does when executed (not sourced), do here:
  _sensible_open__source_file "${prefix}" "./" "_sensibleopen-browser-nickname"
EOF
    )"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  set -e

  shoilerplate_updates
}

main "$@"

