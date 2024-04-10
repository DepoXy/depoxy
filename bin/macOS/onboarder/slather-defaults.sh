#!/usr/bin/env bash
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
#   cd ~/.depoxy/ambers/bin/macOS/onboarder
#
#   # On fresh macOS, run it:
#   ./slather-defaults.sh
#
#   # To see list of reminders, and to test script runs, dry-run it
#   # (works from Linux: to print OMR 'echoInstallHelp' checklist):
#   ./slather-defaults.sh --dry-run

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

depoxy_configure () {
  print_at_end+=("\

🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩
🧩  𝝙 𝝣 𝝦 𝝧 𝞆 𝝪   𝓻 𝓮 𝓶 𝓲 𝓷 𝓭 𝓮 𝓻 𝓼   🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩
")

  # ***

  depoxy_configure_remind_task_create_depoxy_client
  depoxy_configure_remind_task_setup_github_app_token_and_start_first_client_pretzel
  depoxy_configure_remind_task_hydrate_personal_notes

  # ***

  depoxy_configure_remind_task_install_omr_projects

  # ***

  depoxy_configure_remind_task_infuse_and_wireRemotes

  # ***

  # USAGE: See next note abote how to add your own (private) reminders.
  depoxy_configure_private
}

# USAGE: If you'd like to add your own private reminders, add this file:
#   ~/.depoxy/ambers/bin/macOS/onboarder/slather-defaults--PRIVATE.sh
# and create this function:
#   depoxy_configure_private
depoxy_configure_private () {
  :
}

# ***

depoxy_configure_remind_task_create_depoxy_client () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local ambers_root="${DEPOXYAMBERS_DIR:-${ambers_path}}"

  local archetype_path="${DEPOXYARCHETYPE_DIR:-${ambers_root}/archetype}"

  print_at_end+=("\
🔳 DepoXy: DXC: Create DepoXy Client on @biz host::

     cd ${archetype_path}
     # Customize deploy-archetype.sh and make 'PRIVATE:' commits as necessary.
     ./deploy-archetype.sh
")
}

depoxy_configure_remind_task_setup_github_app_token_and_start_first_client_pretzel () {
  local dxc_dir="${DEPOXYDIR_STINTS_FULL:-${HOME}/.depoxy/stints}/${DEPOXY_CLIENT_ID}"

  print_at_end+=("\
🔳 DepoXy: DXC: Setup GitHub authenticated remote application token and push project:

    - Logon GitHub from @home host and create application token.

    - Transfer token to @biz host:

      - You could do so visually, and manually enter.

      - You could email it to your work account, e.g., using put-wise
        command to encrypt it::

          # @home (MAYBE: Retool encrypt_asset to write to stdout):
          encrypt_asset \"__RAW_TOKEN__\" \"?\" | base64
          # @biz:
          decrypt_asset \"\$(base64 -d \"__ENC_TOKEN__\")\"

    - Use token to set remote URL (note the \"Gitputwise\" name can be anything)::

        # cdps → cd \"\${PW_PATCHES_REPO}\" → cd ${PW_PATCHES_REPO}
        cdps
        git remote add entrust https://Gitputwise:__APP_TOKEN__@github.com/__GH_USER__/patchz.git

    - Archive the client (run OMR autocommit, cd active DXC/, put-wise --archive)::

        # aci    → mr -d / autocommit -y
        # cxc    → cd \"\${DEPOXYDIR_STINTS_FULL:-\${HOME}/.depoxy/stints}/\${DEPOXY_CLIENT_ID}\" → cd ${dxc_dir}
        # pw out → git-put-wise --archive
        aci
        cxc
        pw out

    - Publish the client::

        cdps
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

    - Refresh the put-wise tunnel repo @home::

        cdps
        git p

    - Unpack the new client *patchkage*::

        cdps
        pw apply

      - FIXME/2022-12-25: I've never tested --apply on project
        that doesn't exist locally. So I'm not expecting this to work.
        - I bet you can git-init a new repo, make an empty first commit,
          and then apply patches.

    - Incorporate previous stint's notes, something like this::

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
        pw pout  # Aka: pw out && cdps && git push -f && popd

      - Complete the pretzel back @biz::

        cxc
        pw pin   # Aka: cdps && git p && popd && pw in
")
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

depoxy_configure_remind_task_install_omr_projects () {
  depoxy_configure_remind_task_install_omr_all_projects_hint

  depoxy_configure_remind_task_install_omr_projects_print_all
}

# ***

depoxy_configure_remind_task_install_omr_all_projects_hint () {
  print_at_end+=("\
⚠️  DepoXy: Feeling fearless?

   *UNSUGGESTED*: You *could* install all OMR projects from source at once.

   - E.g., you *could* run a blanket install::

       # mr -d / install

   - But we advise that you 'install' each project individually instead.

   - This is because 'install' actions are somewhat brittle:

     - When setting up DepoXy on a different OS or a more recent OS than
       before, you might find that system library versions have changed,
       and that an 'install' action needs to be updated.

     - Or, you might find that the latest upstream source has changed the
       installation requirements or how to install that project (and some
       'install' actions themselves will git-fetch and git-rebase against
       the latest upstream version, without having you bump the version
       manually).

   - Additionally, 'install' tasks can be slow. So best not to entertain
     using \`mr -d / install\` if it's likely you'll have to run it again
     (and again).

   - Alternatively, you could use myrepos' interactive mode, e.g.,

       # mr -d / -i install

     This stops in a subshell if any 'install' action fails, which allows
     you to investigate and resolve any problems. This way you won't have
     to re-run all installs, and can repair any broken installs along the
     way. But you still might want to just run each install individually.

   - *SUGGESTED*: Instead, perform each install manually, copy-pasting the
     following the per-project 'install' actions.
")
}

# ***

depoxy_configure_remind_task_install_omr_projects_print_all () {
  if ! command -v mr > /dev/null; then
    local err_msg="ERROR: Please install \`mr\` form from https://github.com/landonb/myrepos"

    print_at_end+=("${err_msg}")

    return 0
  fi

  printf "Gathering copy-pasta..."

  print_at_end+=("$(mr -d / -M echoInstallHelp)")

  printf "\r"

  # DUNNO: Even though the final `echoInstallHelp` includes a blank line,
  # it's not printed. So add one here.
  print_at_end+=("")
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

depoxy_configure_remind_task_infuse_and_wireRemotes () {
  print_at_end+=("\
🔳 DepoXy: OMR: Run 'infuse' and 'wireRemotes' actions to complete OMR setup::

    # Verify the set of repos:
    MR_INCLUDE=entrusted mr -d / run /bin/bash -c 'echo "${MR_REPO}"'

    # Setup all the repo remotes:
    MR_INCLUDE=entrusted mr -d / wireRemotes

    # Infuse all the project wiring:
    MR_INCLUDE=entrusted mr -d / infuse
")
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

slather_macos_defaults () {
  local print_at_end=()  # 🔳 ◻

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # Run the core `defaults` slatherer.
  #
  # CXREF: ~/.kit/mOS/macOS-onboarder/slather-defaults.sh
  "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-onboarder/slather-defaults.sh" "$@" \
    || exit 1

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  depoxy_configure

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  os_is_macos () {
    [ "$(uname)" = 'Darwin' ]
  }

  [ -z "${print_at_end}" ] || (
    # If macOS-onboarder ran, it printed a bunch of stuff, so add blank line.
    ! os_is_macos \
      || echo

    echo "CPYST: Please perform the following tasks manually (DepoXy):"

    for print_ln in "${print_at_end[@]}"; do
      echo -e "${print_ln}"
    done
  )
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  local ambers_path="${DEPOXYDIR_BASE_FULL:-${HOME}/.depoxy}/ambers"
  local ambers_root="${DEPOXYAMBERS_DIR:-${ambers_path}}"
  # USAGE: See note atop depoxy_configure_private if you'd like to
  # supply your private reminders, which you'll add to this file.
  local private_slather_defaults="${ambers_root}/bin/macOS/onboarder/slather-defaults--PRIVATE.sh"

  if [ -f "${private_slather_defaults}" ]; then
    . "${private_slather_defaults}"
  fi

  # ***

  slather_macos_defaults "$@"
}

if ! $(printf %s "$0" | grep -q -E '(^-?|\/)(ba|da|fi|z)?sh$' -); then
  # Being executed.
  main "$@"
else
  echo "Run me, don't source me, you heard me"

  return 1
fi

