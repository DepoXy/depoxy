# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_git_safe () {
  local git_safe_sh="${GITSMARTPATH:-${GITREPOSPATH:-${HOME}/.kit/git}/git-smart}/lib/git_safe.sh"
  if [ -f "${git_safe_sh}" ]; then
    . "${git_safe_sh}"
  else
    >&2 echo "UNPATCHED: git_safe.sh not found, you’re on your own!"
    >&2 echo "- Expected file at: ${git_safe_sh}"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_git_no_pager () {
  local gnp_alias="gnp"

  claim_alias_or_warn "${gnp_alias}" "git --no-pager"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Adds 2 aliases, `pwip` and `pp`, that both call `git pwip`, I know,
# all the ways.
_dxy_wire_alias_git_wip_pwip () {
  claim_alias_or_warn "wip" "git wip"
  claim_alias_or_warn "pwip" "git pwip"

  # 2023-01-14: Shorter!
  # 2023-01-16: @macOS: /usr/bin/pp - PAR Packager
  # - If we wanted to be thorough:
  #     head -1 /usr/bin/pp | grep -q -e perl
  #   But it's expensive to access files on Bash session startup.
  #   - Using command might also be expensive while boot strapping.
  if [ "$(command -v pp)" = "/usr/bin/pp" ]; then
    alias pp="git pwip"
  else
    claim_alias_or_warn "pp" "git pwip"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_git_cv () {
  local tnewtons="${TIGNEWTONSPATH:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/tig-newtons}"

  # Complement `git cv` with a plain `cv`.
  claim_alias_or_warn "cv" "EDITOR='${tnewtons}/bin/editor-vim-0-0-insert-minimal' git commit -v"
  # `cv` is so easy to type (and remember), I think it'll stick,
  # but I also considered these aliass:
  #
  #  claim_alias_or_warn "civ" "git commit -v"
  #  claim_alias_or_warn "gc" "git commit -v"
}

_dxy_wire_alias_git_cm () {
  local tnewtons="${TIGNEWTONSPATH:-${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/tig-newtons}"

  claim_alias_or_warn "cm" "EDITOR='${tnewtons}/bin/editor-vim-0-0-insert-minimal' git commit --amend"
}

_dxy_wire_alias_git_cn () {
  claim_alias_or_warn "cn" "git commit --amend --no-edit"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_git_rc () {
  claim_alias_or_warn "rc" "git rc"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Create l1..l9 aliases, e.g.,
#
#   claim_alias_or_warn "l1" "git --no-pager log -1"
_dxy_wire_alias_git_logX () {
  local ord

  for ord in {1..9}; do
    claim_alias_or_warn "l${ord}" "git --no-pager log -${ord}"
  done
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Create p1..p9 aliases, e.g.,
#
#   claim_alias_or_warn "p1" "git pop1"
_dxy_wire_alias_git_popX () {
  local ord

  if git help popn > /dev/null 2>&1; then
    for ord in {1..9}; do
      claim_alias_or_warn "p${ord}" "git pop${ord}"
    done
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Creates r2..r9 aliases, e.g.,
#
#   claim_alias_or_warn "r2" "git rebase -i --autosquash HEAD~2"
#
# NOTE: Both `git popX` and `git logX` have Bash alias equivalents,
#       `pX` and `lX`. But there is no `git riaX` equivalent.
#       Though not for a particular reason; only because I thought
#       of wanting a Bash alias first, straight to the chase (the
#       chase being the shortest reasonable command).
#
# CXREF: See also `git ria`: 'ria' is aliased to 'rebase -i --autosquash'.
# - git-ria is shortest alternative to these, e.g., `git ria @^^` is `r2`.
_dxy_wire_alias_git_riaX () {
  local ord

  for ord in {2..9}; do
    claim_alias_or_warn "r${ord}" "git rebase -i --autosquash HEAD~${ord}"
  done
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_alias_just_t_for_tig () {
  # 2023-01-15: This feels so intimate!!
  # - Are we really one a first-character basis now?
  #   - With this call I 't' alias.
  claim_alias_or_warn "t" "tig"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# https://github.com/landonb/sh-git-nubs#🌰
_dxy_add_on_demand_source_git_nubs () {
  local git_nubs="${SHOILERPLATE:-${HOME}/.kit/sh}/sh-git-nubs/bin/git-nubs.sh"
  local common_pw="${GITREPOSPATH:-${HOME}/.kit/git}/git-put-wise/lib/common_put_wise.sh"
  # source_dep "lib/dep_apply_confirm_patch_base.sh"
  # source_dep "lib/dep_ephemeral_branch.sh"
  # source_dep "lib/dep_tig_prompt.sh"

  if [ -f "${git_nubs}" ]; then
    eval "git-nubs-load () {
      . '${git_nubs}';
      . '${common_pw}';
    }"
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_configure_git_my_merge_status () {
  GITSMART_MYST_BRANCH_HIERARCHY="${GITSMART_MYST_BRANCH_HIERARCHY:-release develop proving}"
  GITSMART_MYST_REMOTE_HIERARCHY="${GITSMART_MYST_REMOTE_HIERARCHY:-release 👍 👆 protected 🌟 🌛}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_disable_git_completion_dwim_suggestions () {
  # 2021-02-16: Don't include remote branch names when auto-completing.
  # - E.g., if you have local 'foo' and there's also 'upstream/far', then
  #   `git co f<Tab>` shows both 'foo' and 'far'.
  #   - This is disruptive to me, as I'm not expecting the remote to be
  #     included. In my mind, it's name is 'upstream/far' (so typing
  #     `git co upstream/f<Tab>` is how I'd go about auto-completing it).
  #   - Also, in practice, I always clarify upstream branches by their
  #     remote prefix. E.g., I'd run `git co -b review-this upstream/review-this`
  #     and not `git co review-this`, although the latter will create
  #     the local branch if there's a remote with the same name. (About
  #     the only reason I checkout a remote branch is to review it, and
  #     then I'd use `git begin-review {PR#}`, which uses its own branch
  #     naming scheme).
  # - To ignore so-called "DWIM" suggestions in git-checkout completion
  #   (DWIM → "Do What I Mean" <https://en.wikipedia.org/wiki/DWIM>)
  #   you can either set the GIT_COMPLETION_CHECKOUT_NO_GUESS=1, or
  #   you can use --no-guess. The latter makes more sense for changing
  #   behavior of just a single command... except it doesn't work
  #   through a ~/.gitconfig alias... e.g., not this:
  #     co = checkout --no-guess
  #   so through a deep-state environ it is!
  #   - Ref:
  #       https://github.com/git/git/blob/006c5f7/contrib/completion/git-completion.bash#L46
  # - Thanks to VonC! https://stackoverflow.com/questions/6623649/
  #     disable-auto-completion-of-remote-branches-in-git-bash
  export GIT_COMPLETION_CHECKOUT_NO_GUESS=1
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# 2021-02-19: Enable `git t-bag` completion.

# I copied this from _git_branch and then removed the stuff dealing
# with options. This turned out to be the simplest case.
# Ref: ~/.homefries/bin/completions/git-completion.bash
_git_t_bag () {
  case "$cur" in
  --*)
    __gitcomp_builtin branch
    ;;
  *)
    # From _git_branch, this is the case:
    #  if [ $only_local_ref = "y" -a $has_r = "n" ]; then ...
    # i.e., only complete local branch names.
    __gitcomp_direct "$(__git_heads "" "$cur" " ")"
    ;;
  esac
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

main () {
  unset -f main

  _dxy_wire_alias_git_safe
  unset -f _dxy_wire_alias_git_safe

  _dxy_wire_alias_git_no_pager
  unset -f _dxy_wire_alias_git_no_pager

  _dxy_wire_alias_git_wip_pwip
  unset -f _dxy_wire_alias_git_wip_pwip

  _dxy_wire_alias_git_cv
  unset -f _dxy_wire_alias_git_cv

  _dxy_wire_alias_git_cm
  unset -f _dxy_wire_alias_git_cm

  _dxy_wire_alias_git_cn
  unset -f _dxy_wire_alias_git_cn

  _dxy_wire_alias_git_rc
  unset -f _dxy_wire_alias_git_rc

  _dxy_wire_alias_git_logX
  unset -f _dxy_wire_alias_git_logX

  _dxy_wire_alias_git_popX
  unset -f _dxy_wire_alias_git_popX

  _dxy_wire_alias_git_riaX
  unset -f _dxy_wire_alias_git_riaX

  _dxy_wire_alias_just_t_for_tig
  unset -f _dxy_wire_alias_just_t_for_tig

  _dxy_add_on_demand_source_git_nubs
  unset -f _dxy_add_on_demand_source_git_nubs

  _dxy_configure_git_my_merge_status
  unset -f _dxy_configure_git_my_merge_status

  _dxy_disable_git_completion_dwim_suggestions
  unset -f _dxy_disable_git_completion_dwim_suggestions
}

main "$@"

