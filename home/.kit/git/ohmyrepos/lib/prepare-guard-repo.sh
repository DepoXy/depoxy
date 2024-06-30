# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
#   Guard repos.

# Note that we might need to tell Git commit the email address.
#
# - If not specified or not set by ~/.gitconfig, git-commit tries to
#   determine the user.name and user.email. If you're onboarding a new
#   machine, that file might not be placed yet.
# - The name is probably always obtainable. On Linux and macOS, I see
#   that Git always finds the user's full name, e.g.,:
#
#     # Linux
#     full_name=$(getent passwd $(id -un) | cut -d ':' -f 5 | cut -d ',' -f 1)
#
#     # macOS
#     full_name=$(id -P $(stat -f%Su /dev/console) | cut -d : -f 8)
#
#   Refs:
#     https://stackoverflow.com/questions/833227/
#       whats-the-easiest-way-to-get-a-users-full-name-on-a-linux-posix-system
#
#     https://apple.stackexchange.com/questions/269066/
#       how-can-i-obtain-the-full-name-of-the-currently-logged-in-user-via-terminal-when
#
# - As such, we only need to check that an email is specified, otherwise
#   Git is likely to fail with a message such as:
#
#     $ git commit -m "Testing"
#     Author identity unknown
#     ...
#     fatal: unable to auto-detect email address (got 'username@hostname.(none))
#
#   Which is silly, because you can successfully commit with
#   an empty email address if you're explicit about it, e.g.,
#
#     $ git -c user.email="" commit -m "Fooled you!"
#
#   which results in a git log that shows no email, e.g.,
#
#     Author: username <>
#
#   which basically makes our job a lot easier than it took the time you
#   you to read this comment.

# LOPRI/2022-10-13: Break prepare_guard_repo out to its own lib file.

prepare_guard_repo () {
  local reppath="${1:-"${MR_REPO}"}"

  mkdir -p "${reppath}"

  if [ ! -e "${reppath}/.git" ]; then
    # Specify email, even if it's not set yet (because later-order
    # 'infuse' might have yet to wire user's .gitconfig) to stop
    # Git from otherwise complain-failing.
    local user_email="$(git config user.email)"
    if [ -z "${user_email}" ]; then
      user_email="too-soon"
    fi

    # Tell Git init how to name the initial branch, otherwise it prints a
    # long hint about how the default branch name is subject to change.
    local init_branch="private"

    cd "${reppath}"

    git -c init.defaultBranch="${init_branch}" init .

    git -c user.email="${user_email}" commit --allow-empty -m \
      "💂Guard💂Repo💂 — 🚧 This is an unmanaged (🚫💼) facility 🚧"
  fi
}

