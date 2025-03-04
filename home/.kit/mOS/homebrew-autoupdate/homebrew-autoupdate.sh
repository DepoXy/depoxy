#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE/2025-02-14: Called via injected fork code:
#
# - CXREF: This script normally called daily via injected fork code:
#
#     ~/.kit/mOS/homebrew-autoupdate/lib/autoupdate/start.rb @ 105
#
# - CPYST: Or you can run the upgrade manually:
#
#     # Similar to `brew upgrade`, but also calls this script.
#     ~/Library/Application\ Support/com.github.domt4.homebrew-autoupdate/brew_autoupdate
#
#   - ALTLY: Add the `--immediate` option to run the upgrade now:
#
#       OMR_IMMEDIATE=yes mr -d ~/.kit/mOS/homebrew-autoupdate install
#
#     - CXREF: See OMR 'install' task:
#
#       ~/.depoxy/ambers/home/.kit/mOS/_mrconfig @ 193
#
#   - To avoid sudo prompt, if there is one:
#
#     SUDO_ASKPASS=foo ~/Library/Application\ Support/com.github.domt4.homebrew-autoupdate/brew_autoupdate
#
#     - (I tried other approaches, but none of these worked:)
#
#         ... </dev/null
#         : | ...
#         ( exec 0</dev/null ; ... )
#         ( exec 0<&- ; ... )

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE/2024-12-28: Reinstall generated shim after editing this file:
#
#   cd ~/.kit/mOS/homebrew-autoupdate
#   mr -d . -n install
#
# NTHEN: Verify the generated code looks good:
#
#   ~/Library/Application\ Support/com.github.domt4.homebrew-autoupdate/brew_autoupdate

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# SAVVY: Caller (start.rb) stubs `git` via a PATH prefix:
#
#   #{HOMEBREW_SHIMS_PATH/"shared"}
#
# which our 1-commit fork removes from PATH before calling this script.
#
# - The brew shims/ path:
#
#     /opt/homebrew/Library/Homebrew/shims/shared
#
#   is used to disable /usr/bin/git, among other things.
#
#   https://github.com/Homebrew/brew/blob/cbfdb734af180/Library/Homebrew/brew.rb#L57
#
#   - (To the caller, this is #{HOMEBREW_SHIMS_PATH/"shared"}/git, which, when
#      called, prints: "git: This shim is internal and must be run via brew.")
#
# - CPYST: You can run this from caller to see the path array:
#
#     PATH.new(env_path).reject { |path| STDERR.puts path }
#
# - Note the caller uses `start_with?`, not `.eql?`, to identify the
#   shims paths to remove (but dunno why it has to, perhaps newlines?).
#
# - Original PATH (caller's context) is user's PATH when they call `brew`
#   command, so includes whatever changes DepoXy or Homefries made to it;
#   or it's launchd's PATH and includes none of that.
#
# - CXREF: See how the `dxy_path` variable is defined for more:
#
#     ~/.kit/mOS/homebrew-autoupdate/lib/autoupdate/start.rb

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Run the ubiquitous OMR 'infuse' command, and email the user if it
# fails, or if the caller's `brew upgrade` command returned nonzero.
#
# - Use MR_LOG_LEVEL and --quiet to keep the log file trim.
#
#   - CXREF:
#     ~/Library/Logs/com.github.domt4.homebrew-autoupdate/com.github.domt4.homebrew-autoupdate.out
#
# - In a full DepoXy environment, the 'infuse' action might run for a
#   while, e.g., 15 mins.
#
#   - CPYST: Find the running process:
#       ps aux | grep infuse

dxy_homebrew_autoupdate () {
  local core_logs="$1"
  local core_name="$2"
  local update_status="$3"

  retcode=0
  OHMYREPOS_LIB="${OHMYREPOS_LIB:-${GITREPOSPATH:-${HOME}/.kit/git}/ohmyrepos/lib}" \
    MR_LOG_LEVEL=30 \
      mr -d / --quiet --stats infuse \
    || retcode=$?

  if [ ${retcode} -ne 0 ] || [ ${update_status} -ne 0 ]; then
    local what_failed="<ul>"
    local rerun_hint=""
    if [ ${retcode} -ne 0 ]; then
      what_failed="<br/>
<li>\`<tt class=\"mono\">mr</tt>\` failed!! (exit: ${retcode})</li>"
    fi
    if [ ${update_status} -ne 0 ]; then
      what_failed="
<li>\`<tt class=\"mono\">brew_autoupdate</tt>\` failed!! (exit: ${update_status})</li>"
      rerun_hint="
<ul><li>Try running manually (it might just need sudo):</li>
<ul><li><tt class=\"mono\">brew upgrade</tt></li></ul></ul>"
    fi

    SEND_EMAIL_TO="${SEND_EMAIL_TO:-$(id -un)}"
    SEND_EMAIL_TO_FRIENDLY="$(id -un)@$(hostname)"
    SEND_EMAIL_FROM="${SEND_EMAIL_FROM:-\"homebrew-autoupdate\" <$(basename -- "$0")@$(hostname)>}"
    subject="homebrew-autoupdate failure ❌"
    # REFER: log_out (from start.rb):
    #   log_out = "#{Autoupdate::Core.logs}/#{Autoupdate::Core.name}.out"
    AUTOUPDATE_LOG="${core_logs}/${core_name}.out"
    sendmail -oi "${SEND_EMAIL_TO}" \
<<EOF
From: ${SEND_EMAIL_FROM}
To: ${SEND_EMAIL_TO_FRIENDLY}
Subject: ${subject}
Content-Type: text/html

<style>
  .mono { font-family: 'Hack Nerd Font', 'Hack', 'DejaVu Sans Mono', 'monospace', 'Andale Mono'; font-size: 13px }
</style>

<p style="color:black">
Hey bedhead! 🤦${what_failed}${rerun_hint}</ul>
</p>

<p style="color:black">
Check the *bottom* of the logfile for details: 🆘
</p>

<p style="color:black">
<tt class="mono">${AUTOUPDATE_LOG}</tt>
</p>
EOF
  fi
}

main () {
  dxy_homebrew_autoupdate "$@"
}

main "$@"

