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
# SAVVY: Builds two executables, e.g.:
#   ./build-release/showmethekey-cli/showmethekey-cli
#   ./build-release/showmethekey-gtk/showmethekey-gtk
# - And installs both under ~/.local/bin.
#
# SAVVY: Running `showmethekey-gtk` prompts for admin
# password when user enables the output window.
# - Docs say you can add user to `wheel` group to avoid
#   the prompt (but this author suggests you not, unless
#   you understand what other processes run as `wheel`
#   group, and I do not).

installLinux() {
  # User args.
  #
  # Use --force to always build, regardless of git-fetch.
  local force_build=false
  # The 'starter' remote is a DepoXy convention for what most devs might
  # consider the 'origin' remote. (So that that remote is unambiguous:
  # It's the original project, and not, e.g., a user fork.)
  local remote_name="${REMOTE_NAME:-starter}"
  local branch_name="${BRANCH_NAME:-master}"
  # DOPP_KIT is a DepoXy environ (and ~/.kit is a DepoXy convention).
  local project_dir="${DOPP_KIT:-${HOME}/.kit}/odd/gnome-shell/showmethekey"
  # Note the XDG Specification says "User-specific executable files may be
  # stored in $HOME/.local/bin", but does not define an XDG_-prefixed environ.
  local prefix_dir="${HOME}/.local"
  # Buildtypes: 'plain', 'debug', 'debugoptimized', 'release', 'minsize', 'custom'.
  # - REFER:
  #   https://mesonbuild.com/Running-Meson.html#configuring-the-build-directory
  local build_type="release"
  local build_dir="build-${build_type}"

  parse_args "$@"

  # ***

  cd -- "${project_dir}"

  local old_version="$(print_version)"

  if ! git_merge_ff_only; then
    # HEAD unchanged; assume already built.
    echo "showmethekey still version ${old_version}"

    exit_0
  fi

  # ***

  install_deps

  meson_build

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
          >&2 echo "ERROR: No such --path dir: ${project_dir}"

          print_usage

          exit_1
        fi
        ;;
      --prefix)
        prefix_dir="$2"
        if ! shift 2; then
          >&2 echo "ERROR: Missing --prefix path"

          print_usage

          exit_1
        elif ! test -d "${prefix_dir}"; then
          >&2 echo "ERROR: No such --prefix dir: ${project_dir}"

          print_usage

          exit_1
        fi
        ;;
      --buildtype)
        build_type="$2"
        if ! shift 2; then
          >&2 echo "ERROR: Missing --buildtype build type"

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
  >&2 echo "USAGE: $(basename -- "$0") [--force] [--remote {remote}] [--branch {branch}] [--path {path}] [--prefix {prefix}]"
}

# REFER: Per https://github.com/AlynxZhou/showmethekey —
#   libevdev
#   udev (or systemd)
#   libinput
#   glib2 (the dev package may also be needed)
#   gtk4
#   libadwaita
#   json-glib
#   cairo
#   pango
#   libxkbcommon
#   polkit
#   meson
#   ninja
#   gcc
install_deps() {
  # Support running without privileges.
  # - UCASE: Nightly builds.
  if sudo -n -v 2> /dev/null; then
    sudo apt install -y \
      meson \
      libevdev-dev \
      libudev-dev \
      libinput-dev \
      libgio-2.0-dev \
      libgtkmm-4.0-0 \
      libadwaita-1-dev \
      libjson-glib-dev \
      libcairo2-dev \
      libxkbregistry-dev \
      meson \
      ninja-build \
      gcc

    # These packages were already installed on author's host,
    # so unsure if these are the proper package names.
    sudo apt install -y \
      libcairo2-dev \
      libpango1.0-dev \
      libxkbcommon-dev \
      libpolkit-agent-1-0 \
      libpolkit-gobject-1-0
  fi
}

# COPYD: (I.e., not DRY):
# ~/.depoxy/ambers/home/.kit/nvim/neovide/installLinux.sh
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

  if ! ${force_build:-false} \
    && [ -x "./${build_dir}/showmethekey-gtk/showmethekey-gtk" ] \
    && test "${new_head}" = "${old_head}" \
    ; then

    echo "Skipping build because nothing new fetched (use --force to build anyway)"

    return 1
  fi
}

# REFER:
# https://mesonbuild.com/
#
# ALTLY: Instead of `mkdir build && cd build && meson setup . ..`,
# `meson setup build` will also create and prepare the build dir.
#
# ALTLY: Instead of running from within the 'build' dir., we could
# instead use -C arg: `meson {cmd} -C build`.
#
# ALTLY: Instead of --buildtype debug, use --debug, or omit.
#
# SIZED/2025-10-26: Just FYI:
#   $ ll build*/showmethekey-gtk/showmethekey-gtk
#   300K Oct 26  2025 build-debug/showmethekey-gtk/showmethekey-gtk
#   131K Oct 26  2025 build-release/showmethekey-gtk/showmethekey-gtk
#
# SMPLY: Make a --debug build:
#   mkdir build &&
#     cd build &&
#     meson setup --prefix=~/.local . .. &&
#     meson compile &&
#     meson install
meson_build() {
  local clean=""
  if ${force_build:-false}; then
    clean="--clean"
  fi

  mkdir -p "${build_dir}"
  cd -- "${project_dir}/${build_dir}"

  local builddir="."
  local sourcedir=".."

  meson setup --buildtype "${build_type}" --prefix="${prefix_dir}" "${builddir}" "${sourcedir}"
  meson compile ${clean}
  # SAVVY: At least for this project:
  #   $ meson test
  #   No tests defined.
  meson install
}

# ***

# COPYD: (I.e., not DRY):
# ~/.kit/sh/sh-git-nubs/lib/git-nubs.sh
git_HEAD_commit_sha() {
  git rev-parse HEAD
}

print_version() {
  if ! git-bump-version-tag --cur - 2> /dev/null; then
    if ! ./build/showmethekey-gtk/showmethekey-gtk -v 2> /dev/null; then
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
