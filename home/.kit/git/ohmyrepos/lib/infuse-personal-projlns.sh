# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# ***

# USAGE: Creates symlinks under ~/.projlns to all your personal projects.
#
# UCASE: So you can quickly search through all your projects using RipGrep
#        (`rg`), or using the author's Vim grep-steady plugin (what
#        https://github.com/landonb/dubs_grep_steady wires at <Leader>g),
#        or using `grep`, `ag` (The Silver Searcher), etc.
#
# USAGE: OMR config options:
#
#  Set OMR_INFUSE_PROJLNS_TOGGLE_OFF=true to always skip a project
#    (after logging a message)
#
#  Set OMR_INFUSE_PROJLNS_ROOT=true to always use a single deep-link
#    to the project root
#
#  Set OMR_INFUSE_PROJLNS_FILES=true to always uses individual
#    deep-links to each project file (from git-ls-files)
#  - This lets you omit files you don't want under search.
#  - Uses $@ to deep-link the specified list of files.
#

DEPOXY_PROJLNS_DEPOXY="${DEPOXY_PROJLNS_DEPOXY:-${DEPOXY_PROJLNS}/depoxy-deeplinks}"

# ***

# USAGE: Uncomment TRACE="echo " to perform a dry run with commands echoed.
TRACE=""
# TRACE="echo "

# ***

_infuse_personal_projlns_source_deps () {
  # Load: link_deep, and remove_symlink_hierarchy_safe.
  # CXREF: ~/.kit/git/myrepos-mredit-command/lib/link_deep.sh
  . "${GITREPOSPATH:-${HOME}/.kit/git}/myrepos-mredit-command/lib/link_deep.sh"
}

# ***

# USAGE: Pass-through args to specify which files to symlink,
# otherwise symlinks project root if personal and doesn't
# contain projects within (no .git/ sub-sub-directories),
# or symlinks each of ls-files if contains embedded .git/.

infuse_projlns_if_personal_project () {
  verify_environment

  prepare_projlns_depoxy_if_infuse_all

  infuse_personal_projlns "$@"
}

# ***

verify_environment () {
  if false \
    || [ -z "${MR_REPO}" ] \
    || [ -z "${MR_ORDER}" ] \
    || [ -z "${MR_SWITCHES}" ] \
    ; then
    >&2 echo "ERROR: Missing MR_* environs: Try calling this script from mrconfig"

    exit 1
  fi
}

# ***

prepare_projlns_depoxy_if_infuse_all () {
  mkdir -p ${DEPOXY_PROJLNS_DEPOXY}

  # Only if `-d / infuseProjlns` or `--directory / infuseProjlns`
  if is_first_project && is_infuse_all; then
    # Print common "Infusing <path> [for ‘<script>’]" message.
    # - Same as what `infuser_prepare "${DEPOXY_PROJLNS_DEPOXY}"`
    #   would print, but cannot call direct because this script
    #   sourced, no executed, so $0 would be incorrect.
    info "Infusing $(repo_highlight ${DEPOXY_PROJLNS_DEPOXY})" \
      "[for ‘infuse-personal-projlns.sh’]"

    reset_personal_projlns_if_infuse_all
    infuse_create_symlinks_core
    log_intro_message_if_infuse_all
  fi
}

# Prepare ~/.projlns so projects can symlink thereunder
reset_personal_projlns_if_infuse_all () {
  debug "Removing past infused symlinks: ${DEPOXY_PROJLNS_DEPOXY}"

  # Depopulate:
  #
  #   ~/.projlns/depoxy-deeplinks/
  (
    cd "${DEPOXY_PROJLNS_DEPOXY}"

    ${TRACE} remove_symlink_hierarchy_safe
  )
}

infuse_create_symlinks_core () {
  # 2020-03-01: Top-level file data ignore rules.
  infuse_create_symlinks_core_ignore \
    "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}/home/.projlns/depoxy-deeplinks/_ignore"
}

infuse_create_symlinks_core_ignore () {
  local source="$1"

  local target="${DEPOXY_PROJLNS_DEPOXY}/.ignore"

  command ln -sfn "${source}" "${target}"

  info " $(fg_lightcyan)Created$(attr_reset)" \
    "$(attr_emphasis)root$(attr_reset) symlink" \
    "$(fg_lightorange)${target}$(attr_reset)"
}

log_intro_message_if_infuse_all () {
  debug                       "+------------------------------+---+--------------+\n" \
  "                            | Decision-making              |or-| MR_REPO      |\n" \
  "                            |   process                    |der|   path       |\n" \
  "                            +------------------------------+---+--------------+"
}

# Assumes $HOME is first project, with order = 1
is_first_project () {
   [ "${MR_REPO}" = "${HOME}" ] \
    && [ "${MR_ORDER}" -eq 1 ]
}

# Returns true if `-d / infuse` or `--directory / infuse`
is_infuse_all () {
  echo "${MR_SWITCHES}" | grep -q "\(\s\|^\)\(\-d\|\-\-directory\) \+\/\(\s\|$\)"
}

# ***

infuse_personal_projlns () {
  local branch
  if ! branch="$(git_branch_name)"; then
    error "${MR_REPO}: Skipping — no active branch"

    return 1
  fi

  local order="$(printf "%3s" "${MR_ORDER}")"

  if ${OMR_INFUSE_PROJLNS_TOGGLE_OFF:-false}; then
    debug "Is Disabled — Explicitly skipd: ${order} $(font_personal_toggled_off ${MR_REPO})"

    return 0
  fi

  if ! is_personal_project; then

    return 0
  fi

  add_project_deep_links "$@"
}

# ***

is_personal_project () {
  local is_personal=false

  # CXREF: ~/.kit/git/git-put-wise/lib/common_put_wise.sh
  local private_branch="${LOCAL_BRANCH_PRIVATE:-private}"
  local release_remote
  release_remote="$(dirname -- \
    "${REMOTE_BRANCH_RELEASE:-publish/${LOCAL_BRANCH_RELEASE:-release}}"
  )"

  # ***

  if git_remote_exists "${release_remote}"; then
    is_personal=true
    debug "Is Personal — “${release_remote}” remote: ${order} $(font_personal_publish ${MR_REPO})"
  fi

  # Look for git@, git:, or https:// remotes — if none found, assume no remotes,
  # or only ssh:// remotes, meaning it's personal.
  if ! git remote -v | cut -f2 | grep -q -e "^\(git\|https\?\)\(:\|@\)"; then
    is_personal=true
    debug "Is Personal — No “github.com”s: ${order} $(font_personal_no_gh ${MR_REPO})"
  fi

  if git_branch_exists "${private_branch}"; then
    is_personal=true
    debug "Is Personal — “${private_branch}” branch: ${order} $(font_personal_private ${MR_REPO})"
  fi

  if ! ${is_personal}; then
    debug "Not Personal — No signals IDed: ${order} $(font_not_personal ${MR_REPO})"

    return 1
  fi

  return 0
}

# CXREF: OMR loads logger.sh and color.sh (or if you source this file
#         into your shell, assumes your shell has sourced 'em)
# CXREF: See also familiar OMR highlights, repo_highlight, font_info_*:
#         ~/.git/ohmyrepos/lib/overlay-symlink.sh

repo_highlight () {
  echo "$(fg_mintgreen)${1}$(attr_reset)"
}

font_personal_publish () {
  echo "$(fg_mintgreen)${1}$(attr_reset)"
}

font_personal_no_gh () {
  echo "$(fg_lightcyan)${1}$(attr_reset)"
}

font_personal_private () {
  echo "$(fg_lavender)${1}$(attr_reset)"
}

font_personal_has_git_interiorly () {
  echo "$(fg_lightred)${1}$(attr_reset)"
}

font_not_personal () {
  echo "$(fg_lightyellow)${1}$(attr_reset)"
}

font_personal_toggled_off () {
  echo "$(fg_lightorange)${1}$(attr_reset)"
}

font_personal_limit_links () {
  echo "$(fg_skyblue)${1}$(attr_reset)"
}

# ***

# COPYD/2024-06-16: Poached from git-nubs.sh:
#   ~/.kit/sh/sh-git-nubs/lib/git-nubs.sh

git_branch_exists () {
  local branch_name="$1"

  git rev-parse --verify --end-of-options "refs/heads/${branch_name}" > /dev/null 2>&1
}

git_branch_name () {
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

git_remote_exists () {
  local remote="$1"

  git remote get-url ${remote} > /dev/null 2>&1
}

# ***

add_project_deep_links () {
  local infuse_root=false
  local infuse_files=false

  if [ $# -eq 0 ]; then
    local first_git_path="$(find_one_git_directory)"

    if [ -z "${first_git_path}" ]; then
      infuse_root=true
    else
      # This repo contains other repos/projects we don't know about,
      # and might not be personal (e.g., the top-level $HOME repo,
      # or sometimes the ~/.kit repo if you made one), so we deep-link
      # individual files versus just the root directory.
      infuse_files=true
    fi
  fi

  if ${OMR_INFUSE_PROJLNS_ROOT:-false}; then
    infuse_root=true
    infuse_files=false
  elif ${OMR_INFUSE_PROJLNS_FILES:-false}; then
    infuse_root=false
    infuse_files=true
  fi

  # ***

  (
    cd "${DEPOXY_PROJLNS_DEPOXY}"

    if [ $# -gt 0 ]; then
      debug "Limit — User-suppl'd deeplinks: ${order} $(font_personal_limit_links ${MR_REPO}) [$#]"

      local fname
      for fname in "$@"; do
        ${TRACE} link_deep "${MR_REPO}/${fname}"
      done
    fi

    if ${infuse_root}; then
      ${TRACE} link_deep "${MR_REPO}"
    elif ${infuse_files}; then
      local n_files="$(cd "${MR_REPO}" && git ls-files | wc -l)"
      debug "Noisy — Deep-linking reg files: ${order}" \
        "$(font_personal_has_git_interiorly ${MR_REPO}) [${n_files}]"

      # Ideally we'd run the while loop like this:
      #   while IFS= read -r -d $'\0' fname; do
      #     ...
      #   done < <(cd "${MR_REPO}" && git ls-files -z)
      # But the redirection isn't POSIX.
      # - We could make this file a Bash executable, as opposed to
      #   sourcing into the `mr` runtime.
      # - Or we can make the loop POSIX-friendly, with at least one
      #   caveat: the `while` runs in a subprocess (because piped).
      #   - I also assumed the following would break input on
      #     whitespace in path names, but they seem to work fine.
      ( cd "${MR_REPO}" && git ls-files ) \
      | while IFS= read -r fname; do
        # NOTED: Can we assume symlinks are duplicates?
        # - IFNOT: We'll change this if necessary.
        # - XCEPT: Keep .ignore files in place (since those aren't
        #   searched by `rg`, but rather serve to config `rg`).
        if [ -h "${MR_REPO}/${fname}" ] \
          && [ "$(basename -- "${fname}")" != ".ignore" ] \
        ; then

          continue
        fi

        ${TRACE} link_deep "${MR_REPO}/${fname}"
      done
    fi
  )
}

# ***

# Find the first .git/ directory.
# - The command is essentially:
#     find . -mindepth 2 -name .git -type d -print -quit
#   but with a common prune.
find_one_git_directory () {
  # USYNC: Similar ignore lists (in different DepoXy projects):
  #   ~/.depoxy/ambers/home/.kit/git/ohmyrepos/lib/infuse-personal-projlns.sh
  #   ~/.depoxy/ambers/home/.projlns/infuse-projlns-omr.sh
  #   ~/.kit/sh/home-fries/lib/alias/alias_fd.sh
  #   ~/.vim/pack/landonb/start/dubs_project_tray/plugin/dubs_project.vim
  # - MAYBE: DRY the -prune list.
  find \
    . \
    -mindepth 2 \
    \
    \( \
      -name "TBD-*" -o -name "*-TBD" \
      \
      -o -name "htmlcov" \
      -o -name "node_modules" \
      -o -name ".nyc_output" \
      -o -name "__pycache__" \
      -o -name ".pytest_cache" \
      -o -name "site-packages" \
      -o -name ".tox" \
      -o -name ".trash" \
      -o -name ".venv" \
      -o -path "*.venv-*" \
      -o -name ".vscode" \
      \
      -o -name ".archived" \
      -o -name ".whilom" \
    \) -prune -o \
    \
    -name ".git" \
    -type d \
    \
    -print \
    -quit
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_infuse_personal_projlns_source_deps

