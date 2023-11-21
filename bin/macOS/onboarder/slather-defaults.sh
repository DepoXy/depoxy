# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2023 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# CXREF:
#
#   ~/.kit/mOS/macOS-onboarder/slather-defaults.sh

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE:
#
#   # On fresh macOS, run it:
#   cd ~/.depoxy/ambers/bin/macOS/onboarder
#   ./slather-defaults.sh
#
#   # To see list of reminders, and to test script runs, dry-run it:
#   ./slather-defaults.sh --dry-run
#   # Or:
#   ./bin/macOS/onboarder/slather-defaults.sh --dry-run

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

depoxy_configure () {
  depoxy_configure_remind_task_create_depoxy_client
  depoxy_configure_remind_task_setup_github_app_token_and_start_first_client_pretzel
  depoxy_configure_remind_task_hydrate_personal_notes
  depoxy_configure_remind_task_vim_helptags

  # ***

  depoxy_configure_remind_task_install_omr_projects
}

depoxy_configure_remind_task_create_depoxy_client () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local ambers_root="${DEPOXYAMBERS_DIR:-${ambers_path}}"

  local archetype_path="${DEPOXYARCHETYPE_DIR:-${ambers_root}/archetype}"

  print_at_end+=("\
🔳 DepoXy: DXC: Create DepoXy Client on @biz host:

     cd ${archetype_path}
     # Customize deploy-archetype.sh and make 'PRIVATE:' commit.
     ./deploy-archetype.sh")
}

depoxy_configure_remind_task_setup_github_app_token_and_start_first_client_pretzel () {
  print_at_end+=("\
🔳 DepoXy: DXC: Setup GitHub authenticated remote application token and push project:

    - Logon GitHub from @home host and create application token.

    - Transfer token to @biz host:

      - You could do so visually, and manually enter.

      - You could email it to your work account, e.g., using put-wise
        command to encrypt it:

          # @home (MAYBE: Retool encrypt_asset to write to stdout):
          encrypt_asset \"__RAW_TOKEN__\" \"?\" | base64
          # @biz:
          decrypt_asset \"\$(base64 -d \"__ENC_TOKEN__\")\"

    - Use token to set remote URL (note the \"DepoXy\" text can be anything):

        cdpr
        git remote add entrust https://Gitputwise:__APP_TOKEN__@github.com/__GH_USER__/patchz.git

    - Archive the client (run OMR autocommit, cd active DXC/, put-wise --archive):

        aci
        cxc
        pw out

    - Publish the client:

        cdpr
        # Bare \`pw\` from patches repo pushes it if local more recently changed.
        # - Really this is just being lazy. Calling \`pw\` equivalent to:
        #     git push entrust HEAD:refs/heads/scoping
        #   (Except when it's not, and it calls \`git pull --rebase --autosquash\` instead.)
        pw
")
}

depoxy_configure_remind_task_hydrate_personal_notes () {
  print_at_end+=("\
🔳 DepoXy: DXC: Setup Personal notes:

    - Refresh the put-wise tunnel repo @home:

        cdpr
        git p

    - Unpack the new client patchkage:

      - FIXME/2022-12-25: I've never tested --apply on project
        that doesn't exist locally. So I'm not expecting this to work.
        - I bet you can git-init a new repo, make an empty first commit,
          and then apply patches.

        cdpr
        pw apply

    - Incorporate previous stint's notes, something like this:

        # Prepare ~/.depoxy/running/private/docs
        cxx
        mkdir -p running/private/docs

        # Change to the previous stint's directory and move docs.
        cd stints/XXXX/
        cp -ar private/docs/* ../../running/private/docs/
        git rm -f private/docs
        git ci -m \"Docs: Relocate private/docs/ to new stint ${DEPOXY_CLIENT_ID}.\"

        # Install to the new client and complete the pretzel.
        cxc
        git add private/docs
        git ci -m \"Confide: Docs: Move private/docs from old stint XXXX.\"

        # Keep twisting:
        cxc
        pw pout  # Aka: pw out && cdpr && git push -f && popd

      - Complete the pretzel back @biz:
        cxc
        pw pin   # Aka: cdpr && git p && popd && pw in
")
}

# ***

depoxy_configure_remind_task_vim_helptags () {
  print_at_end+=("🔳 DepoXy: Generate Vim help docs: Run Vim, then:
   :Helptags")
}

# ***


depoxy_configure_remind_task_install_omr_projects () {
  depoxy_configure_remind_task_install_omr_all_projects

  # ***

  depoxy_configure_remind_task_install_omr_projects_vim_parT
  depoxy_configure_remind_task_install_omr_projects_vim_vim
  depoxy_configure_remind_task_install_omr_projects_vim_coc
  depoxy_configure_remind_task_install_omr_projects_vim_nerd_commenter
  depoxy_configure_remind_task_install_omr_projects_vim_lsp_typescript

  depoxy_configure_remind_task_install_omr_projects_tag
  depoxy_configure_remind_task_install_omr_projects_fzf

  depoxy_configure_remind_task_install_omr_projects_git_itself
  depoxy_configure_remind_task_install_omr_projects_git_extras
  depoxy_configure_remind_task_install_omr_projects_git_interactive_rebase_tool
  depoxy_configure_remind_task_install_omr_projects_git_hub
  depoxy_configure_remind_task_install_omr_projects_git_cli
  depoxy_configure_remind_task_install_omr_projects_git_put_wise
  depoxy_configure_remind_task_install_omr_projects_myrepos_mredit_command

  depoxy_configure_remind_task_install_omr_projects_feature_coverage_report
  depoxy_configure_remind_task_install_omr_projects_fries_findup
  depoxy_configure_remind_task_install_omr_projects_gvim_open_kindness

  depoxy_configure_remind_task_install_omr_projects_complete_alias

  depoxy_configure_remind_task_install_omr_projects_homebrew_autoupdate

  depoxy_configure_remind_task_install_omr_projects_finicky
  depoxy_configure_remind_task_install_omr_projects_geektool

  depoxy_configure_remind_task_install_omr_projects_python_pyenv
  depoxy_configure_remind_task_install_omr_projects_python_pyenv_virtualenv
  depoxy_configure_remind_task_install_omr_projects_python_birdseye

  depoxy_configure_remind_task_install_omr_projects_nvm
  depoxy_configure_remind_task_install_omr_projects_lens

  depoxy_configure_remind_task_install_omr_projects_docker_desktop

  depoxy_configure_remind_task_install_omr_projects_aws_cli

  depoxy_configure_remind_task_install_omr_projects_via_nativia
  depoxy_configure_remind_task_install_omr_projects_zsa_wally
}

# ***

# CPYST/2022-12-25: Here's how to identify OMR projects that
# have an install task:
#
# - Naive and tedious (requires visiting matches to see project name):
#
#     # E.g., using ~/.projlns/mymrconfigs/
#     rg "install =" ${MREDIT_CONFIGS:-${DEPOXY_PROJLNS:-${HOME}/.projlns}/mymrconfigs}/
#
# - Hacker-approved:
#
#   - Add pre-action to config lib. Easiest to just append to an
#     existing file, e.g., open the `infuse` *no-oper*:
#
#       ~/.ohmyrepos/lib/infuse-no-op
#
#   - And add this failing pre-install action::
#
#       pre_install = echo "Has \`install\` task: $(fg_green)${MR_REPO}$(attr_reset)" && false
#
#   - Then run `install` on all projects to see list of `install`'able projects:
#
#       mr -d / install
#
#   - Finally (obvi), revert changes.

# ***

depoxy_configure_remind_task_install_omr_projects_vim_parT () {
  print_at_end+=("🔳 DepoXy: Install \`parT\` from source:
   mr -d \"${SHOILERPLATE:-${HOME}/.kit/sh}/parT\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_vim_vim () {
  print_at_end+=("🔳 DepoXy: Install \`vim\` from source:
   mr -d \"${SHOILERPLATE:-${HOME}/.kit/sh}/vim\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_vim_coc () {
  print_at_end+=("🔳 DepoXy: Install CoC:
   mr -d \"${HOME}/.vim/pack/neoclide/start/coc.nvim\" -n install")

  print_at_end+=("🔳 DepoXy: Install \`vim-lsp-typescript\`:
   mr -d \"${HOME}/.vim/pack/ryanolsonx/opt/vim-lsp-typescript\" -n install")

  print_at_end+=("🔳 DepoXy: Install LSPs: Run Vim, then:
   :CocInstall coc-pyright coc-json coc-tsserver")
}

# ***

depoxy_configure_remind_task_install_omr_projects_vim_nerd_commenter () {
  print_at_end+=("🔳 DepoXy: Install NERD Commenter:
   mr -d \"${HOME}/.vim/pack/preservim/start/nerdcommenter\" -n install")
}

# ***

# 2023-01-04: Included here so you don't see OMR project install task and
# think it's missing a reminder, but disabling because not necessary (see
# *2020-09-23* comment: ~/.depoxy/ambers/home/.vim/_mrconfig-lsp:72).
depoxy_configure_remind_task_install_omr_projects_vim_lsp_typescript () {
  false && (
    print_at_end+=("🔳 DepoXy: Install TypeScript Node projects:
     mr -d \"${HOME}/.vim/pack/ryanolsonx/opt/vim-lsp-typescript\" -n install")
   )
}

# ***

depoxy_configure_remind_task_install_omr_projects_tag () {
  print_at_end+=("🔳 DepoXy: Install \`tag\` from source:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/go/aykamko-tag\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_fzf () {
  # If installed via Homebrew, user doesn't need to install from sources.
  # (Currently, install-homebrew.sh confirmed on @macOS; but it might
  #  someday be tested on and certified for @linux, in which case this
  #  install step and the fzf OMR project might be disappeared completely.)
  if [ ! -e "${HOMEBREW_PREFIX}/bin/fzf" ]; then
    print_at_end+=("🔳 DepoXy: Install \`fzf\` from source:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/go/fzf\" -n install")
  fi
}

# ***

depoxy_configure_remind_task_install_omr_projects_git_itself () {
  print_at_end+=("❌ DepoXy: Build yer own \`git\` (SKIP: macOS Git is *adequate*):
   mr -d \"${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git\" -n install")
}

# ***

# Installs git-show-tree, et al.
depoxy_configure_remind_task_install_omr_projects_git_extras () {
  print_at_end+=("🔳 DepoXy: Install \`git-extras\`:
   mr -d \"${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-extras\" -n install")
}

# ***

# 2023-01-01: I rarely use this tool. Prefer editing todo via Vim.
depoxy_configure_remind_task_install_omr_projects_git_interactive_rebase_tool () {
  # 2023-01-04: Oh, this is installed via Homebrew.
  false && (
    print_at_end+=("🔳 DepoXy: Install \`git-interactive-rebase-tool\`:
     mr -d \"${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-interactive-rebase-tool\" -n install")
  )
}

# ***

depoxy_configure_remind_task_install_omr_projects_git_hub () {
  print_at_end+=("🔳 DepoXy: Install \`hub\` (if necessary for your @biz client):
   mr -d \"${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/hub\" -n install")
}

depoxy_configure_remind_task_install_omr_projects_git_cli () {
  print_at_end+=("🔳 DepoXy: Install \`cli\` (if necessary for your @biz client):
   mr -d \"${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/cli\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_git_put_wise () {
  print_at_end+=("🔳 DepoXy: Install \`git-put-wise\`:
   mr -d \"${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/git-put-wise\" -n install")
}

depoxy_configure_remind_task_install_omr_projects_myrepos_mredit_command () {
  print_at_end+=("🔳 DepoXy: Install \`myrepos-mredit-command\`:
   mr -d \"${GITREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/git}/myrepos-mredit-command\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_feature_coverage_report () {
  print_at_end+=("🔳 DepoXy: Install \`feature-coverage-report\`:
   mr -d \"${SHOILERPLATE:-${HOME}/.kit/sh}/feature-coverage-report\" -n install")
}

depoxy_configure_remind_task_install_omr_projects_fries_findup () {
  print_at_end+=("🔳 DepoXy: Install \`fries-findup\`:
   mr -d \"${SHOILERPLATE:-${HOME}/.kit/sh}/fries-findup\" -n install")
}

depoxy_configure_remind_task_install_omr_projects_gvim_open_kindness () {
  print_at_end+=("🔳 DepoXy: Install \`gvim-open-kindness\`:
   mr -d \"${SHOILERPLATE:-${HOME}/.kit/sh}/gvim-open-kindness\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_complete_alias () {
  print_at_end+=("🔳 DepoXy: Install \`complete-alias\`:
   mr -d \"${SHOILERPLATE:-${HOME}/.kit/sh}/complete-alias\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_homebrew_autoupdate () {
  print_at_end+=("🔳 DepoXy: Install \`homebrew-autoupdate\`:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/mOS/homebrew-autoupdate\" -n install")

  print_at_end+=("🔳 DepoXy: Configure \`homebrew-autoupdate\`:
   System Preferences... > Notifications & Focus > Notifications > *brew-autoupdate*: ✓ Allow Notifications")
}

# ***

depoxy_configure_remind_task_install_omr_projects_finicky () {
  print_at_end+=("🔳 DepoXy: Install Finicky:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/mOS/finicky\" -n infuse")
}

# ***

depoxy_configure_remind_task_install_omr_projects_geektool () {
  print_at_end+=("🔳 DepoXy: Install GeekTool:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/mOS/GeekTool\" -n install")

  print_at_end+=("🔳 DepoXy: Configure GeekTool:
   System Preferences... > GeekTool > ✓ Automatically launch at login")

  print_at_end+=("🔳 DepoXy: Configure GeekTool:
   System Preferences... > GeekTool > Check for updates: ✓ Automatic")

  print_at_end+=("🔳 DepoXy: Create GeekTool *geeklets*:

   - Create new *Shell* geeklet to stand in for menu bar clock when menu bar is hidden:
     - Name: CTRDATE
     - Command:

          date '+%a %Y-%m-%d %H:%M'

     - Refresh every: 1 s.
     - Font: *Herculanum* 36pt Green (GUI doesn't show Hex code, just picker).
       - To set, click *Click here to set font & color...*.
     - I set text center-aligned, and then positioned the window.
        - I tried right-aligned, but even with spaces at the end, the last
          character from the clock was clipped by the *GeekTool* window.

   - Create new *Shell* geeklet to be visible on desktop on show-desktop:
     - Use case: You wanna know the time but can't see it.
       - The geeklet lets you show-desktop, read time, and un-show desktop to resume work.
     - Configure similarly to menu bar clock, but center this widget on the desktop,
       so that you can see if when you look straight ahead.

   - SAVVY: You can Ctrl-Alt-D show-desktop to more easily move geeklet widgets around.

   - SAVVY: Use the eyedropper to match the second widget font color to the first widget.")
}

# ***

depoxy_configure_remind_task_install_omr_projects_python_pyenv () {
  print_at_end+=("🔳 DepoXy: Install \`pyenv\` Python versions:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/py/pyenv\" -n installpythons")
}

# ***

depoxy_configure_remind_task_install_omr_projects_python_pyenv_virtualenv () {
  print_at_end+=("🔳 DepoXy: Install \`pyenv-virtualenv\` (or not, really, it’s disabled):
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/py/pyenv-virtualenv\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_python_birdseye () {
  print_at_end+=("🔳 DepoXy: Install \`birdseye\`:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/py/birdseye\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_nvm () {
  print_at_end+=("🔳 DepoXy: Install \`nvm\`:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/js/nvm\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_lens () {
  print_at_end+=("🔳 DepoXy: Install \`lens\`:
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/js/lens\" -n install")

  print_at_end+=("🔳 DepoXy: Configure OpenLens icons:
   # Pick an icon for each cluster.
   ll ~/.depoxy/ambers/home/.kube/*.png
   # See the README.rst if you want to generate more icons
   fs ~/.depoxy/ambers/home/.kube/README.rst")
}

# ***

depoxy_configure_remind_task_install_omr_projects_docker_desktop () {
  print_at_end+=("🔳 DepoXy: Install Docker Desktop (if that‘s something you'll use):
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/mOS/Docker-Desktop-Omr-installer\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_aws_cli () {
  print_at_end+=("🔳 DepoXy: Install AWS CLI (if that‘s something you'll use):
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/py/aws-cli\" -n install")
}

# ***

depoxy_configure_remind_task_install_omr_projects_via_nativia () {
  print_at_end+=("🔳 DepoXy: Install VIA (for you mechanical keyboard lubbers):
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/odd/via-nativia\" -n install")
}

depoxy_configure_remind_task_install_omr_projects_zsa_wally () {
  print_at_end+=("🔳 DepoXy: Install Wally (for you ZSA mechanical keyboard owners):
   mr -d \"${DOPP_KIT:-${HOME}/.kit}/odd/wally\" -n install")
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

slather_macos_defaults () {
  local print_at_end=()  # 🔳 ◻

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # Run the core `defaults` slatherer.
  #
  # CXREF: ~/.kit/mOS/macOS-onboarder/slather-defaults.sh
  "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-onboarder/slather-defaults.sh" "$@"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  depoxy_configure

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  [ -z "${print_at_end}" ] || (
    echo
    echo "ALERT: Please perform the following tasks manually:"
    echo

    for print_ln in "${print_at_end[@]}"; do
      echo -e "${print_ln}"
    done
  )
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  slather_macos_defaults "$@"
}

if ! $(printf %s "$0" | grep -q -E '(^-?|\/)(ba|da|fi|z)?sh$' -); then
  # Being executed.
  main "$@"
else
  echo "Run me, don't source me, you heard me"

  return 1
fi

