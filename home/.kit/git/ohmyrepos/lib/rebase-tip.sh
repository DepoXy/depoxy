# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

rebase_tip () {
  local resume_cmd="$1"
  shift 1
  # Followed by command args:
  #  local slug_name="$1"
  #  local remote_ref="$2"
  #  # Optional args, each with a non-empty default for TIP_COMMAND_ARGS.
  #  local liminal_ref="${3:--}"
  #  local local_name="${4:--}"
  #  local add_version_tag=${5:-false}
  #  local skip_rebase=${6:-false}

  local rebase_tip_cmd="git-rebase-tip"

  if ! command -v "${rebase_tip_cmd}" > /dev/null; then
    # CXREF: ~/.kit/git/git-rebase-tip/bin/git-rebase-tip
    rebase_tip_cmd="${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-rebase-tip/bin/${rebase_tip_cmd}"
  fi

  TIP_RESUME_CMD="${resume_cmd}" "${rebase_tip_cmd}" "$@"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

rebase_tip_push_liminal_tag () {
  # Force-push liminal branch.
  git put-wise push --force

  local tip_vers="$(largest_rebase_tip_vers)"

  # Publish the new version tag.
  git push "publish" "refs/tags/${tip_vers}"
}

# Because `<vers>+<dist>+<dist>` is a pre-release tag, it's less than `<vers>`.
# - So `git_largest_version_tag` and `git bump -s` identify the normal `<vers>`.
# - This, suss the latest special TIP tag. Note there may be multiple tags if
#   the remote adds commits but doesn't add new a tag, also if you add new
#   commits to TIP. E.g., the upstream remote version tag might be '1.2.3',
#   and there could be multiple local rebase tags such as '1.2.3+4+10',
#   '1.2.3+5+10', '1.2.3+5+11', etc. (where the first `+<dist>` is the
#   number of upstream commits after the latest upstream version tag
#   (between the upstream tag and upstream HEAD), and the second `+<dist>`
#   is the number of TIP commits (those between upstream HEAD and the local
#   (scoped) HEAD)).
largest_rebase_tip_vers () {
  git tag -l $(git_largest_version_tag)+* | sort | tail -1
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# COPYD: BRANCH_CONFIG from git-put-wise

# E.g., 'release'.
LOCAL_BRANCH_RELEASE="${LOCAL_BRANCH_RELEASE:-release}"
# E.g., 'publish/release'.
REMOTE_BRANCH_RELEASE="${REMOTE_BRANCH_RELEASE:-publish/${LOCAL_BRANCH_RELEASE}}"

# ***

rebase_tip_merge_release () {
  # The OMR config specifies the first three.
  local resume_cmd="$1"
  local rebase_ref="$2"
  local add_version_tag="$3"
  shift 3
  # Followed by command args propagated from rebase-todo:
  local _resume_cmd="$1"
  local _rebase_ref="$2"
  local _local_branch="$3"
  local _push_remote="${4:--}"
  local _add_version_tag=${5:-false}
  local scope_boundary="${6:--}"
  # >&2 echo "rebase_tip_merge_release ($#): $@"

  local rebase_tip_cmd="git-rebase-tip-merge"

  if ! command -v "${rebase_tip_cmd}" > /dev/null; then
    # CXREF: ~/.kit/git/git-rebase-tip/bin/git-rebase-tip-merge
    rebase_tip_cmd="${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-rebase-tip/bin/${rebase_tip_cmd}"
  fi

  TIP_RESUME_CMD="${resume_cmd}" \
    "${rebase_tip_cmd}" \
      "${rebase_ref}" \
      "${LOCAL_BRANCH_RELEASE}" \
      "${REMOTE_BRANCH_RELEASE}" \
      "${add_version_tag}" \
      "${scope_boundary}"
}

