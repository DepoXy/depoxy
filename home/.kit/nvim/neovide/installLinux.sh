#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2025 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE: See below:
#   print_usage
# - Or use --help.
#
# SAVVY: Installs to Cargo root:
#   ~/.cargo/bin/neovide
# - It's up to the user-caller to ensure ~/.cargo/bin on
#   PATH (or to, e.g., create symlink under ~/.local/bin).

# TRACK/2025-10-24: Author sometimes needs to force-kill Neovide
# because it freezes (once or twice a day, usually).
# - So run debug build and generate log for observability:
#     ./installLinux.sh --force --profile debug
#     neovide --log
# - SPIKE: Or I assume you need 'debug' build (I haven't tested yet).

installLinux() {
  # User args.
  #
  # Note that --force doesn't clean first; it just ensures cargo-install
  # is installed, but cargo-install skips the build if up to date.
  local force_build=false
  # The 'starter' remote is a DepoXy convention for what most devs might
  # consider the 'origin' remote. (So that that remote is unambiguous:
  # It's the original project, and not, e.g., a user fork.)
  local remote_name="${REMOTE_NAME:-starter}"
  local branch_name="${BRANCH_NAME:-main}"
  # DOPP_KIT is a DepoXy environ (and ~/.kit is a DepoXy convention).
  local project_dir="${DOPP_KIT:-${HOME}/.kit}/nvim/neovide/neovide"
  # Profiles: 'release', 'debug', 'profiling'.
  local profile_name=release

  parse_args "$@"

  # ***

  cd -- "${project_dir}"

  local old_version="$(print_version)"

  if ! git_merge_ff_only; then
    # HEAD unchanged; assume already built.
    echo "Neovide still version ${old_version}"

    exit_0
  fi

  # ***

  install_deps

  cargo_install

  # ***

  local new_version="$(print_version)"

  echo "Upgraded Neovide from ${old_version} → ${new_version}"
}

parse_args() {
  local print_help=false

  while [ "$1" != '' ]; do
    case $1 in
      --help)
        print_help=true
        shift
        ;;
      --force)
        force_build=true
        shift
        ;;
      --remote)
        remote_name="$2"
        if ! shift 2; then
          >&2 echo "ERROR: Missing --remote name"

          print_usage

          exit_1
        fi
        ;;
      --branch)
        branch_name="$2"
        if ! shift 2; then
          >&2 echo "ERROR: Missing --branch name"

          print_usage

          exit_1
        fi
        ;;
      --path)
        project_dir="$2"
        if ! shift 2; then
          >&2 echo "ERROR: Missing --path path"

          print_usage

          exit_1
        elif ! test -d "${project_dir}"; then
          >&2 echo "ERROR: Bad --path dir: ${project_dir}"

          print_usage

          exit_1
        fi
        ;;
      --profile)
        profile_name="$2"
        if ! shift 2; then
          >&2 echo "ERROR: Missing --profile name"

          print_usage

          exit_1
        fi
        ;;
      *)
        >&2 echo "ERROR: Unknown arg: $1"

        exit_1
        ;;
    esac
  done

  if ${print_help}; then
    print_usage

    exit_0
  fi
}

print_usage() {
  >&2 echo "USAGE: $(basename -- "$0") [--force] [--remote {remote}] [--branch {branch}] [--path {path}]"
}

install_deps() {
  # Support running without privileges.
  if sudo -n -v 2> /dev/null; then
    sudo apt install -y curl \
      gnupg ca-certificates git \
      gcc-multilib g++-multilib cmake libssl-dev pkg-config \
      libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
      libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
      libxcursor-dev
  fi
}

git_merge_ff_only() {
  local old_head
  old_head="$(git_HEAD_commit_sha)"

  if ! git fetch ${remote_name}; then
    >&2 echo "ERROR: Failed to fetch from remote: ${remote_name}"

    exit_1
  fi

  local new_head
  new_head="$(git_HEAD_commit_sha)"

  if ! git merge --ff-only ${remote_name}/${branch_name}; then
    >&2 echo "ERROR: Failed to merge from branch: ${remote_name}/${branch_name}"

    exit_1
  fi

  if ! ${force_build:-false} && test "${new_head}" = "${old_head}"; then
    echo "Skipping build because nothing fetched (use --force to build anyway)"

    return 1
  fi
}

# We'll build via cargo-install, but you can instead
# just built it.
#
# - To build without installing:
#
#   # Creates: ./target/debug/neovide (implies --debug)
#   cargo build --locked
#
# - Or specify a profile defined in Cargo.toml:
#
#   # Creates: ./target/release/neovide
#   # - Note Cargo finishes quickly if already built.
#   # - (Note that the final `neovide` is reproducable, e.g.,
#   #    if you ./target/release and re-build, it'll create
#   #    the exact same `neovide` as before.)
#   cargo build --profile release
#
#   # Creates: ./target/profiling/neovide
#   cargo build --profile profiling
#
# - SIZES: E.g.,
#
#   $ ll target/*/neovide
#   226M Oct 24  2025 target/debug/neovide*
#   119M Oct 24  2025 target/profiling/neovide*
#    34M Oct 24  2025 target/release/neovide*
#
# - ALTLY: Build some upstream sources:
#
#   cargo install --git https://github.com/neovide/neovide
#
# Note the cargo-install installation root is determined by the first
# value from: --root (arg), CARGO_INSTALL_ROOT (env), install.root
# (Cargo config value), CARGO_HOME (env), or falls-back ~/.cargo.
# - In DepoXy environment, neither environ defined, nor the config value,
#   so falls-back ~/.cargo, i.e., installs to ~/.cargo/bin/neovide.
cargo_install() {
  # By default (--profile release):
  # - Creates: ./target/release/neovide
  # Installs: ~/.cargo/bin/neovide
  cargo install --locked --path "${project_dir}" --profile "${profile_name}"
}

# ***

# COPYD: (I.e., not DRY):
# ~/.kit/sh/sh-git-nubs/lib/git-nubs.sh
git_HEAD_commit_sha() {
  git rev-parse HEAD
}

# CPYST: Probe neovide executables:
# ll ~/.cargo/bin/neovide ~/.local/bin/neovide ~/.kit/nvim/neovide/neovide/target/*/neovide
print_version() {
  if ! git-bump-version-tag --cur - 2> /dev/null; then
    if ! ./target/${profile_name}/neovide -V 2> /dev/null; then
      printf "%s" "N/a"
    fi
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

clear_traps() {
  trap - EXIT INT
}

set_traps() {
  trap -- trap_exit EXIT
  trap -- trap_int INT
}

exit_0() {
  clear_traps

  exit 0
}

exit_1() {
  clear_traps

  exit 1
}

trap_exit() {
  clear_traps

  # USAGE: Alert on unexpected error path, so you can add happy path.
  >&2 echo "ALERT: "$(basename -- "$0")" exited abnormally!"
  >&2 echo "- Hint: Enable \`set -x\` and run again..."

  exit 2
}

trap_int() {
  clear_traps

  exit 3
}

# ***

main() {
  set -e

  set_traps

  installLinux "$@"

  clear_traps
}

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  # Being executed.
  main "$@"
fi
