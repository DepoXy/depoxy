#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2024 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# (Surprisingly, perhaps) this path is not environ-overrideable.
NOT_NOT_VIB_DIR="notable-notes--vibrant"
NOT_NOT_WOO_DIR="notable-notes--woodlot"

# CPYST: To resolve Unicode escapes in normal `ls`, echo it, e.g.,
#   command ls      # shows, e.g., '05☞☞☞☞☞☞'$'\360\237\247\275''☞☞...'
#   echo "$(ll)"    # shows, e.g., '05☞☞☞☞☞☞🧽☞☞☞☞☞☞☞☞☞☞☞☞☞☞☞☞☞☞☞☞☞...'

print_placeholders__vibrant () {
  cat << EOF
01⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂👈⠂⠂⠂⠂⠂⠂⠂⠂
02⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
03⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
04⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂🐍⠂
05⠂⠂⠂⠂⠂⠂🧽⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
06⠂⠂⠂⠂⠂⠂🍌⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
07⠂⠂⠂⠂⠂⠂🐥⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
08⠂⠂⠂⠂⠂⠂🍱⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
09⠂⠂⠂⠂⠂⠂🧀⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
10⠂⠂⠂⠂⠂⠂🦲⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
11⠂⠂⠂⠂⠂⠂🍋⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
12⠂⠂⠂⠂⠂⠂🌮⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
13⠂⠂⠂⠂⠂⠂🌔⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
14⠂⠂⠂⠂⠂⠂👝⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
15⠂⠂⠂⠂⠂⠂😰⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
16⠂⠂⠂⠂⠂⠂🍯⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
17⠂⠂⠂⠂⠂⠂🥟⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
18⠂⠂⠂⠂⠂⠂🧈⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
19⠂⠂⠂⠂⠂⠂🥪⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
20⠂⠂⠂⠂⠂⠂🐝⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
21⠂⠂⠂⠂⠂⠂🏵⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
22⠂⠂⠂⠂⠂⠂🍰⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
23⠂⠂⠂⠂⠂⠂🥯⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
24⠂⠂⠂⠂⠂⠂👃⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
25⠂⠂⠂⠂⠂⠂🥧⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
26⠂⠂⠂⠂⠂⠂🏚⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
27⠂⠂⠂⠂⠂⠂🌼⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
28⠂⠂⠂⠂⠂⠂👑⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
29⠂⠂⠂⠂⠂⠂🪤⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
30⠂⠂⠂⠂⠂⠂🎾⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂⠂
EOF
}

print_placeholders__woodlot () {
  cat << EOF
01
02
03
04
05
06
07
08
09
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
EOF
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

manage_netrw_placeholders () {
  insist_not_not_dir_exists "${NOT_NOT_VIB_DIR}"
  insist_not_not_dir_exists "${NOT_NOT_WOO_DIR}"

  (
    cd "${NOT_NOT_VIB_DIR}"
    print_placeholders__vibrant | revive_or_die_placeholder_assets
  )

  (
    cd "${NOT_NOT_WOO_DIR}"
    print_placeholders__woodlot | revive_or_die_placeholder_assets
  )
}

insist_not_not_dir_exists () {
  local not_not_dir="$1"

  if [ -d "${not_not_dir}" ]; then

    return 0
  fi

  >&2 echo "ERROR: Please \`cd\` to or specify docs directory path"
  >&2 echo "- No such directory: $(pwd)/${docs_dir}"

  exit 1
}

# ***

revive_or_die_placeholder_assets () {
  local line
  while read -r line; do
    local prefix="$(echo "${line}" | sed 's/^\([0-9]\+\).*/\1/')"

    # Allow easy renaming: remove any file with same prefix (we'll recreate
    # it if necessary; or leave it removed if corresponding symlink exists).
    find . -maxdepth 1 -type f -iname "${prefix}*" -exec git rm -- {} +
    find . -maxdepth 1 -type f -iname "${prefix}*" -exec rm -- {} +

    if test -n "$(find . -maxdepth 1 -type l -iname "${prefix}*")"; then
      >&2 echo "${prefix}: Removed placeholder(s)"
    else
      touch -- "${line}"

      >&2 echo "${prefix}: Created placeholder"
    fi
  done
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

insist_tidy () {
  if ! git diff --cached --quiet; then
    >&2 echo "ERROR: Please commit or cleanup staged changes first"

    exit 1
  fi

  if [ -n "$(git_status_porcelain)" ]; then
    >&2 echo "ERROR: Please commit or cleanup unstaged changes first"

    exit 1
  fi
}


git_status_porcelain () {
  git status --porcelain=v1
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

commit_notable_notes_changes () {
  # Commit files staged by `git-rm`
  PRIVATE_ACI="${PRIVATE_ACI:-PRIVATE: autoci*}"
  git commit -m "${PRIVATE_ACI}: Docs: Remove old notable-notes placeholder(s)"

  # Commit new files
  git add .
  git commit -m "${PRIVATE_ACI}: Docs: Insert new notable-notes placeholder(s)"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  local docs_dir="${1:-.}"

  cd "${docs_dir}"

  insist_tidy

  manage_netrw_placeholders

  commit_notable_notes_changes
}

# Run iff executed.
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  main "$@"
fi

