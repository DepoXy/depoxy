@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
``launchd`` Notes, and Using ``locate`` on macOS and Linux
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.. contents:: T/O/C
   :depth: 1

#####################
``launchd`` Reference
#####################

REFER::

  man launchd.plist

  man launchctl

  man launchd

REFER:

- *Daemons and Agents (Technical Note TN2083)*:

  https://developer.apple.com/library/archive/technotes/tn2083/_index.html

- This is also a nice article (last updated 2024):

  https://alvinalexander.com/mac-os-x/mac-osx-startup-crontab-launchd-jobs/

- And here's a ``plist`` generator (but it's probably easier to just copy
  an existing ``plist`` unless you need something fancier):

  https://launched.zerowidth.com/

Terminology: From the ``man`` pages:

- A *daemon* is a (single) system-wide service for all clients.

- An *agent* is a service that runs on a per-user basis.

  - This document talks about DepoXy agents.

-------

#######################
DepoXy launchd agent(s)
#######################

This document describes the first (and currently only) DepoXy agent,
a script that runs ``updatedb`` to index user files for the ``locate``
command.

- Technically, because Homebrew, the two commands are ``gupdatedb``
  and ``glocate``, but for simplicity we'll use the canonical Linux
  names.

- (Note that on Linux ``locate`` has been superseded by ``plocate``.)

-------

##################################
Install custom ``updatedb`` caller
##################################

USAGE: Create a symlink to install the DepoXy ``updatedb`` agent
(you could also copy it, but DepoXy installs symlinks to its
assets whenever possible).

- The agent will index your user home files, and it'll store the
  ``locate.db`` under user home (or at a path you can specify via
  its ``LOCATEDB_PATH`` environ (see below)).

- You could install the agent manually with ``ln``::

    ln -sfn \
      ~/.depoxy/ambers/home/Library/LaunchAgents/com.tallybark.daily-updatedb.plist \
      ~/Library/LaunchAgents/com.tallybark.daily-updatedb.plist

- You can also call the DepoXy OMR 'install' action to install it::

    mr -d "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}" -n install

- Note you'll see a popup telling you *Background Items Added*,
  and that you can manage the new agent from System Settings.

  - The new agent should be ready to be enabled by default.

  - AFAIK, you don't (or at least the author didn't) need to
    ``bootstrap`` the item::

      # Shouldn't be necessary:
      #
      #   launchctl bootstrap gui/501/ \
      #     "${HOME}/Library/LaunchAgents/com.tallybark.daily-updatedb.plist"

USAGE: Enable the item::

  launchctl enable gui/501/com.tallybark.daily-updatedb

- SAVVY: Both ``bootstrap`` and ``enable`` replace legacy ``launchctl load``,
  if you're familiar with ``load`` (and ``unload``) subcommands, or see them
  referenced in old articles you might find online.

-------

###############################
Some other ``launchd`` Commands
###############################

- Check ``launchd`` item status::

    launchctl print gui/501/com.tallybark.daily-updatedb

  - The legacy subcommand is ``list``, just FYI, e.g.::

    # Use the newer 'print' subcommand instead:
    #
    #  launchctl list | head -1 ; launchctl list | grep com.tallybark.daily-updatedb

- Run the item immediately (otherwise you'll have to wait 24 hours (per the
  ``StartInterval`` value in the ``plist``) until it's scheduled to run next)::

    launchctl kickstart gui/501/com.tallybark.daily-updatedb

  - The legacy subcommand is ``start``, e.g.::

    # Use 'kickstart' subcommand instead:
    #
    #  launchctl start "${HOME}/Library/LaunchAgents/com.tallybark.daily-updatedb.plist"

- Run the ``plist`` linter to verify the file format::

    plutil -lint "${HOME}/Library/LaunchAgents/com.tallybark.daily-updatedb.plist"

    # OUTPUT:
    # /Users/user/Library/LaunchAgents/com.tallybark.daily-updatedb.plist: OK

-------

#############################
Debugging ``updatedb`` caller
#############################

CXREF: You'll find logs at the following location(s)::

  ~/Library/Logs/com.tallybark.daily-updatedb/daily-updatedb.out

  ~/Library/Logs/com.tallybark.daily-updatedb/daily-updatedb.err

- The agent doesn't print to ``stdout``, so only the ``.err`` file
  might have content, if something isn't wired correctly on your
  host.

-------

#####################
Explaining ``locate``
#####################

DepoXy creates a ``locate`` alias that uses the private ``locate.db``
that the ``updatedb`` agent creates.

- You'll find the ``locate`` alias defined in a Bash startup file::

    ~/.depoxy/ambers/core/locate-db.sh

- The private database is stored at ``~/.cache/locate/locate.db``.

  - You can override the default location using the ``LOCATEDB_PATH``
    environ.

    - See ``321open.cfg`` for a good place to customize this value::

      ~/.config/depoxy/321open.cfg

    - This file is generated from a DepoXy Archetype template file::

      ~/.depoxy/ambers/archetype/home/.config/depoxy/321open.EVAL.cfg

- The system ``updatedb`` does not include user home files, because
  any user can access the system locate database.

  So don't use the system database, otherwise you'll expose your
  private filenames to other users.

- You'll need to run ``updatedb`` yourself, ideally on a scheduled
  basis.

  - That's what the ``updatedb`` runner does::

      ~/.depoxy/ambers/bin/daily-updatedb

  - Which is scheduled to run via the agent ``plist`` file::

      ~/.depoxy/ambers/home/Library/LaunchAgents/com.tallybark.daily-updatedb.plist

  - The DepoXy OMR 'install' action (documented above) installs the agent
    on macOS::

      mr -d "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}" -n install

  - On Linux, you can simply link the ``updatedb`` script from your
    ``anacron`` directory, e.g.,::

      ln -sfn \
        ~/.depoxy/ambers/bin/daily-updatedb \
        ~/.anacron/daily/daily-updatedb

    And then ``anacron`` will run ``updatedb`` at most once daily
    (or as soon as you boot or resume, if it hasn't run in over a
    day).

- As previously mentioned, ``locate`` is the legacy implementation on
  Linux, which is replaced by ``plocate``. (There's also ``mlocate``, but
  that's just a transitional package.) On macOS, use Brew's ``glocate``.

  - On Debian, ``apt install plocate`` installs ``plocate``

    - On Linux, the DepoXy ``locate`` alias calls ``plocate``.

  - On macOS, ``brew install findutils`` installs ``glocate``

    - On macOS, the Depoxy ``locate`` alias calls ``glocate``.

    - There's also a Rust re-write,
      ``brew install uutils-findutils``

        https://github.com/uutils/findutils

      Though it doesn't (yet [2024-07-15]) implement
      ``locate`` and ``updatedb``:

        https://github.com/uutils/findutils/issues/60

    - See also the ``plocate`` project

        https://plocate.sesse.net/

      But there doesn't seem to be a macOS installation.

      Fortunately, in the author's experience, Brew's ``locate``
      works fast enough.

  - On macOS, there's a similar tool, ``mdfind``, but the author
    couldn't suss how to configure it like we do ``locate``, so
    it's not quite comparable.

    - The ``mdfind`` command is an Apple Spotlight interface.

      But the author has been unable to determine how to index their
      home directory files using Spotlight. (And gurgling the answer
      doesn't yield good results. Mostly comments about using
      ``find / -name <foo>`` or ``fd <foo> /``, but neither of those
      is very fast, and neither are the results ordered as nicely as
      the results from ``locate``.)

      Spotlight also doesn't index hidden (dot) files or enter hidden
      directories (and the author also could not figure out how to
      configure the Spotlight database to index so-called hidden paths).

-------

The ``locate`` command has some nuances we work around in order to
use our custom ``locate.db`` stored at our chosen path.

- You might use a mounted path so you can store the database on an
  encrypted volume, if you want another layer of security.

- Specifically, here are the steps to use our custom ``locate.db``:

  1.  Use stdin to specify (feed) the database to locate, and not
      (don't use) the ``-d``/``--database`` argument.

      The ``locate`` command has a ``-d``/``--database`` option, or
      equivalently ``LOCATE_PATH``, that you can set to add your own
      database — but note that ``locate`` just appends your database
      to its list, e.g.::

        @debian $ LOCATE_PATH=~/.cache/locate/locate.db locate -S
        Database /var/lib/mlocate/mlocate.db:
          ...
        Database /home/user/.cache/locate/locate.db:
          ...

      But with multiple database inputs, you might end up with
      duplicate results.

      - On macOS, ``/var/db/locate.database`` is the system database.

        - You can generate the system database by running:
          ``sudo /usr/libexec/locate.updatedb``

      However, trying to create a user database without duplicate
      results is difficult unless all user files are under the user's home
      directory (because then you can just call ``updatedb -U "${HOME}"``).

      - But the author has files elsewhere (e.g., under ``/media/${LOGNAME}``
        on Linux, and under ``/Volumes`` on macOS) that I want to index.

      And as mentioned earlier, if you use two databases, you'll
      probably see duplicate entries for system items.

      E.g.::

        @macOS $ glocate fsck_apfs.log
        /private/var/log/fsck_apfs.log
        /private/var/log/fsck_apfs.log

      Anyway, tl;dr, send the database over stdin; problem solved. (On stdin,
      ``locate`` will ignore the system db, as well as ``LOCATE_PATH``.)

      E.g.::

        @macOS $ cat ~/.cache/locate/locate.db | glocate -S -d-
        Database <stdin> is in the GNU LOCATE02 format.
        ...

  2.  We also use stdin to feed database, as ``-d``/``--database``
      cannot see all mounts.

      E.g., if the database is on a separate mount, you might see::

        @debian $ LOCATE_PATH=/media/user/mount/.cache/locate/locate.db locate -S
        Database /var/lib/mlocate/mlocate.db:
          ...
        locate: can not stat () `/media/user/mount/.cache/locate/locate.db': Permission denied

      But it works using stdin (by specifying ``-d`` with the "``-``" argument)::

        @debian $ cat /media/user/mount/.cache/locate/locate.db | locate -S -d-
        Database -:
          ...

      - DUNNO/2024-07-14: The author discovered ``locate -S`` on Linux years
        ago, but that option is not (no longer?) an option.

        - However, macOS ``glocate`` (from ``brew install findutils``)
          has the ``-S`` option.

-------

#######
Caveats
#######

Note that ``launchd`` is more like ``cron`` than it is like ``anacron``:

- If the host is off or sleeping, when it's booted or resumes again,
  it won't run the job until the next scheduled time.

  - This is unlike ``anacron``, which runs a missed job when the host
    is booted or resumes.

- However, if we used ``StartCalendarInterval`` (to schedule a job at
  a specific time, like ``cron``) rather than using ``StartInterval``
  to schedule the job to run at a regular interval, then the job
  *should* run after the host resumes (though not if the host was
  shutdown; only if it was sleeping).

  - See *Effects of Sleeping and Powering Off*:

    "If the system is turned off or asleep, ``cron`` jobs do not execute; they
    will not run until the next designated time occurs.

    "If you schedule a ``launchd`` job by setting the ``StartCalendarInterval``
    key and the computer is asleep when the job should have run, your job will
    run when the computer wakes up. However, if the machine is off when the job
    should have run, the job does not execute until the next designated time
    occurs.

    "All other ``launchd`` jobs are skipped when the computer is turned off
    or asleep; they will not run until the next designated time occurs.

    "Consequently, if the computer is always off at the job’s scheduled time,
    both ``cron`` jobs and ``launchd`` jobs never run. For example, if you
    always turn your computer off at night, a job scheduled to run at 1 A.M.
    will never be run."

    - The previous text was copied from *Scheduling Timed Jobs*:

      https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/ScheduledJobs.html

  - Also, per ``man launchd.plist``:

    - ``StartInterval <integer>``

      "This optional key causes the job to be started every N seconds.
      If the system is asleep during the time of the next scheduled interval
      firing, that interval will be missed due to shortcomings in ``kqueue(3)``."

- There are obviously ways around this.

  E.g., you could use ``RunAtLoad`` (though ``man launchd.plist`` warns
  that "speculative job launches have an adverse effect on system-boot
  and user-login scenarios").

  Or you could load a second agent that runs at a shorter interval (e.g.,
  every five minutes), or (likewise) using ``StartCalendarInterval``.

  - This second agent could check the ``locate.db`` timestamp and
    immediately regenerate it if it's older than the ``StartInterval``
    value.

  See also this Q/A, with a response that says:

  - "You could try scheduling a repeating 'Start up or wake' event in
    *System Preferences > Energy Saver > Schedule* just prior to the
    scheduled launch agent is due to execute."

    https://apple.stackexchange.com/questions/214696/launchctl-starts-my-plist-job-much-later-than-startcalendarinterval#comment259468_214825

  But for our purposes (and because I've already spent enough time
  writing this README!, and because I don't feel like testing
  ``StartCalendarInterval`` or ``RunAtLoad``), we'll just assume the
  current behavior is acceptable.

  - If it's not acceptable and you'd like to help us out, feel
    free to code such a solution, and send us a PR. We'd love
    that!

- Also note that, given all this, and the added complexity of the ``plist``
  file and running ``launchd`` commands, it might make more sense (or at
  least it'd be easier) to just use ``cron`` to schedule the ``updatedb``
  script.

  - But per Apple: "Although it is still supported, ``cron`` is not a
    recommended solution. It has been deprecated in favor of ``launchd``."

    - Albeit it still works fine, and I'd be surprised if Apple ever
      stops supporting it. But you never know! It's definitely more
      future-proof to use ``launchd``.

-------

See also the Session Type ``plist`` option, ``LimitLoadToSessionType``.

- E.g.::

    <key>LimitLoadToSessionType</key>
    <string>Background</string>

- Per Apple, "If you don't specify the ``LimitLoadToSessionType`` property,
  ``launchd`` assumes a value of Aqua."

  https://developer.apple.com/library/archive/technotes/tn2083/_index.html

- These are the possible ``LimitLoadToSessionType`` values:

  +-------------------------+--------------+------------------------------------------------------------------------+
  | Name                    | Session Type | Notes                                                                  |
  +=========================+==============+========================================================================+
  | GUI launchd agent       | Aqua         | Has access to all GUI services; much like a login item.                |
  +-------------------------+--------------+------------------------------------------------------------------------+
  | non-GUI launchd agent   | StandardIO   | Runs only in non-GUI login sessions (most notably, SSH login sessions) |
  +-------------------------+--------------+------------------------------------------------------------------------+
  | per-user launchd agent  | Background   | Runs in a context that's the parent of all contexts for a given user   |
  +-------------------------+--------------+------------------------------------------------------------------------+
  | pre-login launchd agent | LoginWindow  | Runs in the loginwindow context                                        |
  +-------------------------+--------------+------------------------------------------------------------------------+

- So while we might want to use ``Background`` instead of ``Aqua``, because
  the agent doesn't need access to the GUI (AFAIK) the author has not tested
  this setting. (And I'd guess that it doesn't really matter.)

-------

#######
Thanks!
#######

I hope this article has been enlightening, and thanks for reading!

