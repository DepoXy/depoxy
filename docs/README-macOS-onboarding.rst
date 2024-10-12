@@@@@@@@@@@@@@@@@@@@@@@@
DepoXy macOS ONBRD STEPS
@@@@@@@@@@@@@@@@@@@@@@@@

As Applied to macOS Sequoia ~ 15.0.1
####################################

.. vim:rdt=19999:tw=0:ts=2:sw=2:et
.. contents:: T/O/C
   :depth: 1

####################################
INTRO: macOS Onboarding Step-by-Step
####################################
.. 2024-04-11
  - SAVVY: Dates you see commented below each § header
    indicate when the § was originally added to this document.

**STEPS**: Follow this document from top-to-bottom when setting up a new Mac.

- We've automated as much of the setup as possible; what's below are
  the manual steps that have not been automated (usually because they
  can't, or sometimes because it's too much work and not enough payoff).

-------

*Is DepoXy right for you?*
==========================

- The author uses (and developed) DepoXy because they live the contract
  life, sometimes with commitments as short as 6 months, and they need
  to ensure that they can onboard a new vendor MacBook in a day or two,
  replete with all their favorite (must-have!) dev tools and config.

- So while you might not like some of the particulars of DepoXy, or it
  might lack some tools you insist upon, or perhaps you disagree with
  some of the ways DepoXy configures the OS or apps, it might provide
  you with a good starting position for developing *your own* onboarding
  tool.

  - *Whatever it takes to hit the ground running when you start a new
    contract!*

- DepoXy also includes *all* my dev tools and config (well, except
  private config I can't share with you, which is minimal).

  - So you might also think of DepoXy as my *Awesome list*. And whether
    you're a seasoned (salty?) dev, or just getting your sea legs, maybe
    it's got some tricks you didn't know about.

-------

###########################################
INTRO: Definitions and Document conventions
###########################################
.. 2024-07-19

SAVVY: This document is best viewed in Vim using the ``vim-reSTfold``
plugin, which lets you fold reST sections. It's sort of like showing you
a living table of contents, and it makes it easier to navigate the document:

  https://github.com/landonb/vim-reSTfold.git #🙏

- REFER: Once installed, you can collapse all reST folds using ``<F5>`` (or
  using whatever binding you want for the reSTfold command). And then you
  can use normal Vim folding commands, e.g., ``za`` will fold or unfold a
  single section.

-------

WORDS: This document uses so-called *FIVERs*, five-letter, capitalized words
followed by a colon, that are used to categorize content.

- E.g., *SAVVY* is used to note something *interesting*, or to provide a *hint*.

- *STEPS* is used to document something you should *do*, like run a script.

- *UCASE* is used to highlight the *use case* for a particular setting, or
  why you might want to configure your Mac as described in this document.

- *HSTRY* is short for *history* and might describe the genesis of a setting.
  E.g.,:

  - HSTRY: The reason the author chose five-letter words is because of a
    very popular tag that programmers often use, "*FIXME*".

- *REFER* is used to describe how something *works*. It's often followed by
  text copied from a ``man`` page, or a link to a web page that goes into
  further detail.

  - REFER: In Vim, if you have ``dubs_web_hatch`` installed, you can type
    ``gW`` when the cursor is over a URL, and it will be opened in your
    favorite browser:

    https://github.com/landonb/dubs_web_hatch #🐣

- *CXREF* is similar to *REFER*, except it refers to *files* you'll find
  on your local host (often the files are installed and available after
  you run the steps below).

  - SAVVY: In Vim, you can type ``gf`` or ``gF`` when the cursor is over
    a path, and that file will be opened. So *CXREF* is regularly used to
    make it easy to jump to other files.

- *ADHOC* is used in this document as an alternative to *STEPS* for
  something you should do when appropriate, or when you feel like it,
  but might not be necessary when mentioned, or might be something you
  can skip.

- *ONBRD*, short for *onboard(ing)*, is used for § titles that include
  *STEPS* to follow/run.

Besides FIVERs, this document generally avoids abbreviations, but the
Section sign, "*§*", is specially used to refer to sections of this
document. I.e., this whole *INTRO* is a § of this document.

And for purposes of HTML findability, this document emphasizes both
**STEPS** and **ADHOC** in boldface. While this means that, in the
raw reST doc these will *not* be highlighted colorful, they'll be
more noticeable to our web audience.

-------

REFER: If you're viewing this document in Vim, these plugins will
enable highlighting special features of this document.

- Add colorful *FIVER* highlighting:

  https://github.com/landonb/vim-reST-highfive #🖐

- Highlight name@email.com addresses, @hostnames, #tags,
  <Ctrl-and-other-bindings>, and more:

  https://github.com/landonb/vim-reST-highdefs #🎨

- Highlight lines of repeated characters:

  https://github.com/landonb/vim-reST-highline #➖

(If you follow the *STEPS* below, these plugins will be installed
when you run ``install-ohmyrepos.sh clone``.)

When viewing this document in Vim, FIVERs make it easy to quickly
skim the document, to look for what's important.

- E.g., if you just want to setup a machine as quick as possible,
  looks for *STEPS* content, and ignore everything else!

And while five-letter, capitalized words might not look that good
in a web browser, they *do* look good in Vim. And they align nicely,
if you appreciate columnarly-aligned text. =)

-------

HSTRY: The term "DepoXy" is a play on the acronym "DX", as in,
"Developer Experience".

- REFER: DepoXy (aka DXY) is composed of essentially four components:

  - Project config for hundreds of Git repos (managed by the veritable
    `myrepos <https://myrepos.branchable.com/>`__ multi-repo Git
    controller).

  - Bash config that doesn't belong in another repo, because it relies
    on specifics of the DepoXy environment, or it "knows too much" and
    cannot be generalized for use outside of DepoXy.

  - Other config, often referred to as *opinionated config*. E.g.,
    DepoXy-specific key bindings for the
    `skhd <https://github.com/koekeishiya/skhd>`__ hotkey daemon.

  - And, finally, *your* config, which you can add to your own
    *DepoXy Client* (aka DXC).

    - DepoXy can load your own ``myrepos`` projects, Bash config,
      other config, etc. Everything is mostly automated, so all
      you need to do is write the code or config, and DepoXy will
      load it.

    - A fresh, new DepoXy Client will be created for you as you
      follow along the *STEPS* below. This repo is intended for
      you to keep for yourself, and not to publish publicly.

      However, if you find yourself adding code or config that
      others might find useful, you are encouraged to *promote*
      it to DepoXy (or to whatever project it best belongs in,
      or maybe to a new project).

      Oftentimes the author will use their own Client as a testing
      ground for new features. Eventually, that code or config
      will be moved ("promoted") to another project and published.

-------

*Have you had enough of me rambling?*

**Then let's get started!!**

-------

########################
⋰ ⋱ ⋰ ⋱  ONBRDs  ⋰ ⋱ ⋰ ⋱
########################

##################################
ONBRD: Adjust Screensaver Settings
##################################
.. 2024-04-13

UCASE: It's annoying to have to enter your password whenever resuming
from the screen saver, especially if you work remotely, or if you're
setting up a personal machine at home. Also you should be just in the
habit of locking your machine when appropriate.

- Note, too, we reserve most System Settings tweaks for the ``defaults``
  script, run later, but none of these settings is ``defaults``-settable.

- So let's relax the Lock Screen rules so you're not prompted to unlock
  after the screensaver runs.

.. ASIDE: Oddly, *Start Screen Saver when inactive* is 20 minutes by
   default, but *Turn display off when inactive* is 10 minutes. And the
   first option shows a warning triangle and text saying the display
   will turn off before the screen saver is activated. (Kind of a weird
   design choice...)

-------

**STEPS**: macOS System Settings > Lock Screen:

- *Start Screen Saver when inactive*: For 10 minutes

- *Turn display off when inactive*: For 1 hour

- *Require password after screen saver begins or display is turned off*:

  - "After 8 hours", just in case you forgot to lock.

    - E.g., if you're putzing around home, you might not interact with
      the machine for a while. But if you, e.g., leave home or go to
      sleep, you'll probably appreciate the host locking itself (if you
      try to practice solid OPSEC).

    - I had originally set this to "Never", but having since changed it
      to 8 hours, I've never found the host unexpectedly (or annoyingly)
      locked when I'm just doing chores, cooking, whatever, but haven't
      left home.

.. You will be password-prompted for both *Turn display off...* and *Require password...*.

-------

########################################
ONBRD: Install Apple CLI Developer Tools
########################################
.. 2024-04-11

UCASE: The first time you run ``git`` (and other commands), a dialog
pops up, prompting:

- *The “git” command requires the command line developer tools.*

  *Would you like to install the tools now? <Cancel> <Install>*

You can easily install that way, or you can take it to the CLI.

-------

**STEPS**: Open a terminal window:

- Press ``<Cmd-Space>`` to open Spotlight search,
  enter "*terminal*", and open ``Terminal.app``.

- If you're on a corporate machine, you may need to
  run *AdminAccess* or equivalent to elevate privileges.

  (And that's the last time we'll mention *AdminAccess*.)

**STEPS**: Install Apple Developer Tools::

  xcode-select --install

-------

################################
ONBRD: Clone ``macOS-onboarder``
################################
.. 2024-04-11

**STEPS**: Clone the macOS-onboarder repo::

  mkdir -p ~/.kit/mOS
  cd ~/.kit/mOS
  git clone -o publish https://github.com/DepoXy/macOS-onboarder.git

- CXREF: https://github.com/DepoXy/macOS-onboarder

-------

SAVVY: The Terminal.app defaults to Z shell.

- We'll eventually update ``/etc/shells`` and call ``chsh`` so that
  Homebrew Bash (v5) is the default shell.

**ADHOC**: But until then, you'll want to run ``bash`` explicitly after
opening a new Terminal.

-------

########################################
ONBRD: Enable Terminal.app file accesses
########################################
.. 2024-04-11

UCASE: Running certain commands will prompt for various permissions, e.g.::

  $ defaults-domains-list
  # POPUP: “Terminal” would like to access data from other apps.

  $ defaults-domains-dump
  # POPUP: “Terminal” would like to access your contacts.

  $ ls ~/Desktop
  # POPUP: “Terminal” would like to access files in your Desktop folder.

  $ ls ~/Documents
  # POPUP: “Terminal” would like to access files in your Documents folder.

  $ ls ~/Downloads
  # POPUP: *“Terminal” would like to access files in your Downloads folder.

-------

**ADHOC**: Allow access whenever you see such a popup::

  <Don't Allow> *<Allow>*

-------

REFER: A little more about macOS access permissions:

.. |Apple-TCC-Article| replace:: *Transparency, Consent, and Control*
.. _Apple-TCC-Article: https://support.apple.com/guide/security/controlling-app-access-to-files-secddd1d86a6/web

- These are called *TCC prompts*, and refer to Apple's |Apple-TCC-Article|_
  model (discussed in a later §).

- ALTLY: You can proactively run these commands to trigger the popups::

    bash

    mkdir ~/Documents/defaults--00--before-the-rodeo
    cd ~/Documents/defaults--00--before--the-rodeo

    . ~/.kit/mOS/macOS-onboarder/lib/macOS-defaults-commands.sh

    defaults-domains-list
    defaults-domains-dump

    ls ~/Desktop
    ls ~/Documents
    ls ~/Downloads

  But it's probably easier to just click *Allow* when prompted.

- ALTLY: You can also enable permissions via System Settings, e.g.:

  - *Privacy & Security* > *Files and Folders* > *Terminal.app*

  - SAVVY: The only permission you *must* set via System Settings
    is for *Full Disk Access*. (We'll do that later, after
    discussing the security implications.)

    - Otherwise macOS will prompt you for permissions as necessary.

- BWARE: If you *Don't Allow* the popup, it disappears forever,
  and you'll have to use System Settings to change it.

  - E.g.::

      $ ls ~/Documents
      # Click <Don't Allow>
      $ ls ~/Documents
      ls: /Users/user/Downloads: Operation not permitted

  - You can recover from this via System Settings:

    *Privacy & Security* > *Files and Folders* > *Terminal* (expand)::

      Allow the applications below to access file and folders.
      v 🖥️ Terminal
         Desktop Folder     ✅
         Documents Folder   ✅
         Downloads Folder   ✅

  - ALTLY: You can also reset the TCC settings for the app, which is
    probably more annoying, e.g.::

      # Identify the app's Bundle ID:
      osascript -e 'id of app "Name of App"'

      # Reset the app's TCC settings
      sudo tccutil reset All <Bundle ID>
      
  - SAVVY: To avoid these prompts altogether, you could empower
    Terminal.app with *Full Disk Access*, and then not worry about it.

    But I'd suggest *not* granting those permissions to Terminal.app
    (specifically to Terminal.app).

    - REFER: See below for a discussion of *Full Disk Access* (FDA):

        `ONBRD: Grant Full Disk Access to your terminal app`_

      - Seasoned developers will generally enable FDA for their
        terminal applications (e.g., Terminal.app, iterm.app,
        Alacritty.app, etc.). If you know what you're doing, this is
        generally fine, but there are a few security implications
        to consider first.

- SAVVY: You must quit Terminal.app to realize the change via System Settings,
  but this is not required when granting permissions via the popup.

- SAVVY: The remainder of your user's home directories shouldn't popup
  any access requests::

    $ ls ~/Library ~/Movies ~/Music ~/Pictures ~/Public

-------

#####################################
ONBRD: Create a ``defaults`` snapshot
#####################################
.. 2024-04-11

UCASE: Keep a copy of the original ``defaults`` settings for your Mac
(before we *slather* all over them).

-------

**STEPS**::

  bash

  mkdir ~/Documents/defaults--01--fresh-Sonoma-14.4.1
  cd ~/Documents/defaults--01--fresh-Sonoma-14.4.1

  . ~/.kit/mOS/macOS-onboarder/lib/macOS-defaults-commands.sh

  defaults-domains-dump --all
  defaults-domains-dump

-------

- CXREF:

  file://~/.kit/mOS/macOS-onboarder/lib/macOS-defaults-commands.sh

-------

####################################################
ONBRD: Install Brew apps (`bin/install-homebrew.sh`)
####################################################
.. 2024-04-11

UCASE: Brew-install all the apps that can be brew-installed.

- SAVVY: You can run this from Z shell if you want, or Bash.

-------

**STEPS**: Adjust the opt-in/opt-out environs as necessary,
and run the following::

  cd ~/.kit/git/macOS-onboarder

  # USAGE: Adjust these environs to taste

  BREW_EXCLUDE_SLACK=false \
  \
  BREW_INCLUDE_COLIMA=false \
  BREW_INCLUDE_DOCKER_DESKTOP=true \
  BREW_INCLUDE_VIRTUALBOX=true \
  \
  BREW_INCLUDE_DROPBOX=true \
  BREW_INCLUDE_P4MERGE=false \
  \
  BREW_INCLUDE_SPOTIFY=true \
  BREW_INCLUDE_MEDIA_PLAYERS=true \
  \
  BREW_INCLUDE_PENCIL=true \
  \
  BREW_INCLUDE_DIGIKAM=true \
  BREW_INCLUDE_GNUCASH=true \
  \
    ./bin/install-homebrew.sh

-------

**STEPS**: Un-quarantine untrusted apps (e.g., Easy Move+Resize, MacDown)::

  . ~/.kit/mOS/macOS-onboarder/lib/macOS-defaults-commands.sh

  quarantine-liberate-apps

-------

- SAVVY:

  - The apps that prompt for your sudo password are run first:

    - Homebrew

    - Karabiner-Elements (KE)

  - You'll see toast notification(s) reporting when background items are added.

    - Note that KE reports itself as *Fumihiko Takayama*.

- CXREF: Consult the source for what apps are installed:

  https://github.com/DepoXy/macOS-onboarder/blob/release/bin/install-homebrew.sh

.. - LOCLY: file://~/.kit/mOS/macOS-onboarder/bin/install-homebrew.sh

-------

**STEPS**: (FIXME: This might be unnecessary):

- Enable background items via System Settings:

  - General > Login Items > Allow in the Background

    - ✓ *Fumihiko Takayama* "8 items: 3 items affect all users" [toggle on]

    - ✓ *Karabiner-Elements Non-Privileged Agents* [confirm enabled]

    - ✓ *Karabiner-Elements Privileged Daemons* [toggle on]

  - The author has *all* items listed thereunder enabled, including:

    - AltTab.app, borders, brew_autoupdate, daily-updatedb, Docker,
      Docker Inc, Docker.app, Dropbox, Fumihiko Takayama, Google LLC,
      skhd, Spotify.app, Wireshark Foundation.

-------

**OPTLY**: You can optionally run the installer again and capture its output,
to save it for future reference.

- It prints all the Brew-install *Caveats* that you may want to review::

    cd ~/.kit/git/macOS-onboarder

    ./bin/install-homebrew.sh \
      > ~/Documents/Brew-install-Caveats--install-homebrew.sh.out

**ONBRD**: Application-specific notes:

- **ADHOC**: Many apps require additional permissions, and macOS will
  prompt you when you run them; or when you run certain commands within
  an app; or when you try to access certain filesystem paths.

  - Just deal with them as they come (and we won't bother documenting).

- **ADHOC**: If you installed ``digiKam.app``, when you run it for the
  first time, you may want to *Download* (another gig) of features,
  including Face Detection, Aesthetic Detection, and Auto Tags Assignment
  (whatever the latter two are).

-------

#############################################
REFER: Full Disk Access security implications
#############################################
.. 2024-07-19

SAVVY: There are no *STEPS* in this §, it's just informatory.

-------

HSTRY: The author has, for years, just enabled FDA for the terminal
apps and not worried about it further.

- I trust all the apps I install, so I've never been that concerned
  that something I run from the terminal would abuse those permissions.

- I'm sure other devs do and feel the same.

- And if you don't enable FDA, seemingly bizarre errors occur.

  - Like, you can't even look at your own trash!

    E.g.::

      $ /bin/ls ~/.Trash
      ls: /Users/user/.Trash: Operation not permitted

      $ sudo /bin/ls ~/.Trash
      Password:
      ls: /Users/user/.Trash: Operation not permitted

      # WTF?! 🤯

-------

SAVVY: Full Disk Access is about security and privacy.

- It prevents apps from accessing certain "protected"
  paths and resources, such as data from other apps,
  files in users' trash bins (including the user's own,
  which forces them to use Finder to access their trash),
  and some system settings.

ASIDE: Interestingly, you can probe specific paths:

- E.g.::

    $ sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db
    Error: unable to open database "/Users/user/Library/Application Support/com.apple.TCC/TCC.db": authorization denied

    $ /bin/ls -le ~/Library/Application\ Support/com.apple.TCC/TCC.db
    -rw-r--r--  1 user  staff  98304 Jul 19 18:19 /Users/user/Library/Application Support/com.apple.TCC/TCC.db

- Even if you can't access the parent directory itself::

    $ /bin/ls -le ~/Library/Application\ Support/com.apple.TCC/
    total 0
    ls: /Users/user/Library/Application Support/com.apple.TCC/: Operation not permitted

SAVVY: Note that apps cannot probe for FDA permissions, so they're not
likely to tell you about it. That's why you'll see less-than-helpul
error messages like *Operation not permitted*, instead of being told
to grant FDA permissions for the command to succeed.

BWARE: Most seasoned devs don't think twice about FDA, but read
on for some interesting security implications (that maybe you
hadn't realized!).

-------

So what's the risk?
===================

*So what's the big deal with TCC if I'm the only one who runs apps
from the terminal?* you might ask.

- Firstly, if you *share* your host with other users, be it co-workers,
  or perhaps family members, you may have glossed over the fine print
  in System Settings (seriously, I didn't notice this until 2024!):

  - *Allow the applications below to access data like Mail, Messages,
    Safari, Home, Time Machine backups, and certain administrative
    settings* **for all users on this Mac.**

  - In other words, if you grant FDA to Terminal.app, then *any user*
    on the machine can open Terminal.app —

    - And any user *can view your files*.

- But more frighteningly is that *any app can run scripts through
  Terminal.app*.

  - Suppose I installed a malicious app, or if an app changed
    developers and the new developer introduced an exploit,
    the app could run any script through Terminal.app, and
    *Terminal will happily, silently run it*.

    - E.g.::

        open -a /System/Applications/Utilities/Terminal.app evil-script.sh

  - Note, however, that not all terminal apps are so acquiescent.

  - For comparison, when you try the same exploit with iTerm, it
    at least prompts you.

    - E.g., if you run::

        open -a /Applications/iTerm.app evil-script.sh

    - Then iTerm prompts you:

      *Warning: OK to run “/Users/user/path/to/evil-script.sh”?*

    - BWARE: I did not test this from an actual app, but only from
      the command line. But I assume the same prompt happens if an
      app tries this.

  - Even better is Alacritty, which flatly refuses!

    - E.g.::

        open -a /Applications/Alacritty.app evil-script.sh

    - It shows a modal dialog with the following message:

      *The document “evil-script.sh” could not be opened.*

      *Alacritty cannot open files in the “shell script” format.*

    - BWARE: I have not tested other attack vectors or
      shell extensions. But, at least with ``.sh`` scripts,
      Alacritty is locked down tight.

      - Does this mean Alacritty can only run scripts that you
        tell it run? I don't want to emphatically say yes, but
        I trust it more than Terminal.

  - ASIDE: Note that double-clicking a ``.sh`` file from Finder,
    whether executable or not, should open it in your text editor
    (or at least on the author's host, it defaults to MacVim.app;
    and I don't remember setting this default explicitly).

    - Anecdotally, some users prefer to run shell scripts when
      double-clicked from Finder, but I... just can't fathom.

-------

Final thoughts
==============

- Considering all this, and because I don't want to be
  inconvenienced — or confused — by FDA access issues, I
  choose (with proper education why I made this choice) to grant
  Full Disk Access to Alacritty, but not to iTerm or Terminal.

  - Alacritty is also my preferred terminal; I almost never use any other.

-------

REFER: Some articles on TCC:

- *Controlling app access to files in macOS*

  https://support.apple.com/guide/security/controlling-app-access-to-files-secddd1d86a6/web

- *Terminal and Full Disk Access* — An interesting discussion by
  (who I assume are) security professionals

  https://mjtsai.com/blog/2022/09/22/terminal-and-full-disk-access

-------

##################################################
ONBRD: Grant Full Disk Access to your terminal app
##################################################
.. 2024-07-19

UCASE: Grant *Full Disk Access* to your favorite terminal app,
*so that you can do all the things*.

- See previous § for details.

The author prefers to give only Alacritty FDA permissions,
and not iTerm nor Terminal.

- Though feel free to do as you please.

  The author had given FDA to iTerm and to Terminal for years
  without issue. And you probably won't have an issue, either,
  well, if you're a confident, competent power user or developer.

  But consider the security implications discussed in the previous
  § before deciding, I'd suggest.

-------

**STEPS**: Grant FDA to Alacritty:

- System Settings > Privacy & Security > Full Disk Access:

  - ✓ Alacritty

  - ✗ iTerm

  - ✗ Terminal

-------

#################################
ONBRD: Configure Full Disk Access
#################################
.. 2024-07-19
.. onbrd-configure-full-disk-access

UCASE: While we're on the topic of FDA, let's also configure FDA for the
other apps that need it.

-------

.. Full_Disk_Access:

**STEPS**: Grant FDA to three apps: your terminal app (e.g., Alacritty),
to ``gfind`` (used by ``updatedb``), and to the SSHd app (for SSH users).

You might also see the other apps listed below (or you should after you
open them for the first time), but none of the other apps should need FDA.

- System Settings > Privacy & Security > Full Disk Access:

  - ✓ Alacritty

    - As discussed above, this seems like the least exploitable
      terminal app to grant FDA to, and it lets you work freely
      in the shell without impediment.

  - ✗ Dropbox

  - ✓ gfind

    - Allow Brew's ``find`` command full disk access.

      - This command is used by the DepoXy ``updatedb`` mechanism so
        it can catalog the whole disk (see `setup updatedb §`_ below).

      - Note you won't see ``gfind`` until you setup ``updatedb``.

  - ✗ Google Chrome

  - ✗ GoogleUpdater

  - ✗ iTerm

  - ✗ Slack

  - ✓ sshd-keygen-wrapper

    - Allows ssh clients to have full disk access (i.e., when you
      logon remotely).

      - Assumes you've got you host locked tight with SSH keys
        so presumably you'll be the only SSH user, ever.

        Otherwise maybe you want to leave this disabled.

  - ✗ Terminal

.. _setup updatedb §: #onbrd-setup-updatedb-for-locate-command

-------

##########################################
ONBRD: Change default browser to “Finicky”
##########################################
.. 2024-04-13

UCASE: So that opening links from Slack, the shell, etc., open in
a new browser window, and don't raise an existing window and open
in a new tab, use Finicky.

- This just makes life easier, IMO.

  E.g., you can open a link, view the page, then close the window
  and go back to what you were doing.

  But if a link opens in an *existing* window, after you close
  the tab, you're still looking at the browser window, and are
  not returned to what you were working on previously.

  Furthermore, if you open links in a new tab in an *existing*
  window, it might raise a hidden or minimized window, or might
  pollute the tabs of an existing window with an unrelated tab.
  And who wants that.

.. SAVVY: Do this now, otherwise ``infuse`` reports failure (in a few §s).

-------

**STEPS**:

- Open Finicky::

    open /Applications/Finicky.app/

- When prompted, click <Open>::

    “Finicky” is an app downloaded from the Internet.
    Are you sure you want to open it?

      [XXX] <[Open]>

- When prompted, click <Use “Finicky”>::

    Do you want to change your default web browser to
    “Finicky” or keep using “Safari”?

      [Keep “Safari”] <[Use “Finicky”]>

-------

#####################
ONBRD: Clone 'depoxy'
#####################
.. 2024-04-13

UCASE: This is the main DepoXy repo!

- We use the ``myrepos`` config it contains to clone all
  the other repos we need (as of 2024, about 200 of them!).

SAVVY: DepoXy uses a few conventional paths:

- ``~/.depoxy`` holds the main DepoXy repo, and your
  DepoXy Client(s).

- ``~/.kit`` holds all the other Git repos that DepoXy
  clones.

- You can choose alternative paths, if you want, but
  you'll need to set the proper shell ENVIRONs to tell
  it where to look.

  - E.g., perhaps you prefer ``~/src`` instead of ``~/.kit``.

  - Using alternative paths is not documented further
    in this file, but it is in the DepoXy sources.

    - CXREF: See the ENVIRONs config:

      https://github.com/DepoXy/depoxy-archetype/blob/release/home/.config/depoxy/depoxyrc.EVAL

    - Your DepoXy Client will contain a hydrated version of this
      file, filled with the settings you choose when you run the
      ``deploy-archetype.sh`` script (documented in another §
      below).

  - BWARE: The author has not tested using other paths, but they
    *should* work.

    So it's best to stick with the conventional paths, at least
    if you're demoing DepoXy for the first time.

-------

**STEPS**::

  mkdir ~/.depoxy

  cd ~/.depoxy

  git clone -o publish https://github.com/DepoXy/depoxy.git ambers

-------

#########################################################
ONBRD: Clone all the Git repos (``install-ohmyrepos.sh``)
#########################################################
.. 2024-04-13

UCASE: Download and *wire* all the Git repos.

- SAVVY: The ``clone`` action runs ``git-clone`` on each
  repo defined by the ``myrepos`` config.

  - There are about 200 such repos (circa 2024).

- SAVVY: The ``infuse`` action *wires* these projects.

  - "Wiring" basically means adding symlinks where necessary
    to enable these projects to work:

    - Add links to config files from ``~/.comfig``, e.g.,
      the ``tig-newtons`` project creates a symlink at
      ``~/.config/tig/config`` that points to its ``tig`` config.

    - Add links to executables from ``~/.local/bin``, e.g.,
      the ``myrepos-mredit-command`` creates a symlink at
      ``~/.local/bin/mropen`` so that you can run the ``mropen``
      command. (The ``mropen`` command opens the ``myrepos``
      config file for the current working directory's Git project.)

    - Adds links to private ``.ignore`` rules, and ``.git/info/exclude``
      files.

    - The ``infuse`` command also performs a few other tasks, but it's
      mostly symlinks, and nothing that requires building code or doing
      any heavy lifting.

  - The ``infuse`` command is quite verbose, and reports every
    change it makes.

- SAVVY: Note that these commands use ``myrepos`` to run the
  indicated action on every Git project registered with it,
  visiting each project directory sequentially.

  If you're new to ``myrepos``, these commands should demonstrate
  just how awesomely convenient and powerful the tool is!

- SAVVY: The reason we run both ``clone`` and ``infuse`` twice
  is because the first ``infuse`` action wires additional ``myrepos``
  config. So you need to run ``clone`` again to fetch those repos,
  and then ``infuse`` again to wire the freshly fetched repos.

-------

**STEPS**: Run two clone-infuse cycles::

  cd ~/.depoxy/ambers/bin/onboarder

  ./install-ohmyrepos.sh clone

  ./install-ohmyrepos.sh infuse

  ./install-ohmyrepos.sh clone

  ./install-ohmyrepos.sh infuse

-------

CHECK: A third clone-infuse should no-op::

  cd ~/.depoxy/ambers/bin/onboarder

  ./install-ohmyrepos.sh clone
  # OUTPUT, e.g.,:
  # ...
  # (2.5 secs.) mr checkout: finished (173 skipped)

  ./install-ohmyrepos.sh infuse
  # OUTPUT, e.g.,:
  # ...
  # (14.6 secs.) mr infuse: finished (161 ok; 12 skipped)

- Though you might see '1 failed' if you haven't wired
  Finicky yet (which we did a previous STEPS/§ above).

CXREF:
file://~/.depoxy/ambers/bin/onboarder/install-ohmyrepos.sh

USAGE: These are all the script commands you could run::

  cd ~/.depoxy/ambers/bin/onboarder

  ./install-ohmyrepos.sh

  ./install-ohmyrepos.sh help
  ./install-ohmyrepos.sh --help

  ./install-ohmyrepos.sh echo

  ./install-ohmyrepos.sh clone

  ./install-ohmyrepos.sh infuse

-------

#############################################################
ONBRD: Configure permissions for the newly installed projects
#############################################################
.. 2024-04-13

UCASE: Now that Alacritty and all the other apps are installed,
let's get permissions setup out of the way.

-------

**STEPS**: 

- Press ``<Cmd-Space>``

- Enter ``Alacritty.app`` to open a new terminal

- Run ``bash``

- Then a bunch of permissions dialogs will popup in succession

**STEPS**:

- System Settings > Privacy & Security > Accessibility:

  - *Allow the applications below to control your computer.*

    - ✓ AltTab

    - ✓ Easy Move+Resize [See more below]

    - ✓ Rectangle

- System Settings > Privacy & Security > Screen & System Audio Recording:

  - Screen & System Audio Recording

    - Click ``+``

    - Enter your password

    - Find ``/Applications/AltTab``

      - Click [Open]

      - Click *Quit and Reopen* AltTab on the popup

    - ✓ AltTab [click the slider to enable it]

- System Settings > Privacy & Security > Input Monitoring:

  - ✓ ``karabiner_grabber``

  - ✓ ``karabiner_observer``

- System Settings > Privacy & Security > Security:

  - Look for *“Easy Move+Resize” was blocked from use because
    it is not from an identified developer*.

  - Click *Open Anyway*

  - Another popup says *“Easy Move+Resize” can't be opened
    because Apple cannot check it for malicious software.*

  - SAVVY: Apple says this about many of the open source
    software that DepoXy uses, because those developers
    opted not to pay the fee and go to the trouble of
    signing their apps. But it's usually fine — *provided
    that you trust the project.*

    - But trust can be very subjective.

      It's up to you to trust the project.

      In my experience, if a project has lots of users,
      and has been around for a while, it's *probably*
      trustworthy.

      (Though writing this makes me wonder what people
      think of DepoXy, which is not widely known nor
      used. But you can always audit my code or contact
      me directly!)

  - REFER: Here's a link to Easy Move+Resize if you
    want to audit its code or to see how popular it
    is (which might persuade you that it's safe to
    install and use):

    https://github.com/dmarcotte/easy-move-resize

  - Click *Open*

  - An *Accessibility Access* dialog will popup and declare:

     - “Easy Move+Resize” would like to control this computer
       using accessibility features.

  - Click *Open System Settings*

  - System Settings > Privacy & Security > Accessibility:

    - *Allow the applications below to control your computer.*

    - ✓ Easy Move+Resize [click the slider to allow it]

      - In fact, we'll just stop telling you to "click the slider":

        Whenever you see a ✓ checkmark is this document, it means
        to enable a slider or to click a checkbox.

        And whenever you see an ✗ (the so-called "Ballot X" glyph)
        it means to disable a slider or checkbox.

- System Settings > Privacy & Security > Security:

  - Look for *System software from application
    “.Karabiner-VirtualHIDDevice-Manager” was blocked from loading.*

    - Click *Allow*

    - Enter your password

    - Dismiss the *Keyboard Setup Assistant* popup

- System Settings > Notifications:

  - Most apps will request Notifications permissions, but not
    Hammerspoon:

    - Click *Hammerspoon*

    - ✓ Allow notifications

- For the *Welcome to Rectangle* popup:

  - Click *Recommended* (not *Spectacle*)

-------

SAVVY: *Allow* Alacritty.app permissions:

- If you didn't enable FDA for Alacritty.app you may need
  to enable Alacritty permissions:

  - Open Alacritty.app and run::

      eval "$(/opt/homebrew/bin/brew shellenv)"

      ls ~/Desktop
      ls ~/Documents
      ls ~/Downloads

-------

SAVVY: If you're using iTerm.app, you'll need to
allow terminals to clear *scrollback* history:

- Open an iTerm terminal window

- Type <Ctrl-L> to clear the terminal

- Click *Always Allow (⌥A)* in the alert bar at the top of the terminal:

  - A popup declares, *A control sequence attempted to clear
    scrollback history.*

    *Allow this in the future?*

  - Click <Always Allow> (or press <Alt-A>)

-------

**STEPS**: Unblock MacDown (a live Markdown renderer):

- Run MacDown.app via Spotlight (<Cmd-Space>)

- System Settings > Privacy & Security > Security:

  - Look for *“MacDown.app” was blocked from use because it is
    not from an identified developer.*

  - Click <Open Anyway>

-------

**STEP**: Allow terminal notifications:

- Open a terminal and run::

    terminal-notifier -message foo

- In the permissions notification popup,
  expand the dropdown and click <Allow>.

  The dialog reads:

  - “terminal-notifier” Notifications
    Notifications may include alerts, sounds,
    and icon badges.

  - On hover you'll see the "Options" dropdown appear,
    with two choices: Allow / Don't Allow

- See also: System Settings... > Notifications > terminal-notifier > Allow notifications

-------

#####################################
ONBRD: Create a ``defaults`` snapshot
#####################################
.. 2024-04-14

UCASE: Optional: Create another ``defaults`` snapshot since we
fiddled with a bunch of System Settings (though lots of the
permissions settings we changed won't necessarily appear therein).

- You can use the ``defaults`` snapshots to compare changes we've
  made as we setup macOS.

-------

**STEPS**:

- Open an Alacritty terminal and run the following::

    eval "$(/opt/homebrew/bin/brew shellenv)"
    bash

    mkdir ~/Documents/defaults--02--before-slather-defaults
    cd ~/Documents/defaults--02--before-slather-defaults

    . ~/.kit/mOS/macOS-onboarder/lib/macOS-defaults-commands.sh

    defaults-domains-dump --all
    defaults-domains-dump

- *Allow* two more permissions:

  - Access to other apps

  - And to something else

    - FIXME: Document what this "something else" is.

-------

##########################################
ONBRD: Set user's default shell to Bash v5
##########################################
.. 2024-04-14

UCASE: Use Bash v5 as the user shell whenever you open a new terminal.

- Also use Bash v5 whenever you SSH into your host.

SAVVY: Note that the ``infuse`` action you ran in a previous § wires
the Alacritty config:

- Locally at:

  file://~/.depoxy/ambers/home/.config/alacritty/alacritty.toml

- Or online at:

  https://github.com/DepoXy/depoxy/blob/release/home/.config/alacritty/alacritty.toml

and that Alacritty will run Bash v5 as the shell when you open a new terminal.

- But here we tell macOS to *always* use Bash v5 as the login shell,
  regardless of the terminal (Terminal, iTerm, Alacritty, etc.).

- And more importantly, here we tell macOS to use Bash v5 as the
  login shell for SSH clients.

  I.e., when you ``ssh <host>`` into your machine, it'll drop you
  in a Bash v5 shell (and not the default macOS Z Shell).

- This is also different from the ``bash`` command that previous
  §s had you run, which is the built-in macOS Bash v3. Bash v3
  is *archaic* — it's 20 years old at this point (2024), and it
  has some odd nuances that differ from POSIX, such as
  ``ENV=foo cmd`` changing ``ENV`` after!

  - E.g.::

      $ /bin/bash --posix -c 'unset -v FOO; foo () { :; }; bar () {
        FOO=123 foo; echo FOO=$FOO; local baz; FOO=abc foo; echo FOO=$FOO;
      }; bar'
      FOO=
      FOO=abc

  - Vs.::

      $ /opt/homebrew/bin/bash --posix -c 'unset -v FOO; foo () { :; }; bar () {
        FOO=123 foo; echo FOO=$FOO; local baz; FOO=abc foo; echo FOO=$FOO;
      }; bar'
      FOO=
      FOO=

-------

SAVVY/2024-08-23: The following steps are automated by DepoXy ``infuse`` task.

- CXREF::

    # infuse_macOS_verify_chsh
    ~/.depoxy/ambers/home/infuse-platform-macOS

REFER: Tell macOS that Brew Bash is a usable shell::

  sudo sh -c "echo /opt/homebrew/bin/bash >> /etc/shells"

REFER: Set user's default shell to Brew Bash::

  chsh -s /opt/homebrew/bin/bash
  # OUTPUT:
  # Changing shell for user.
  # Password for user: [Enter your password]

From here on out, you won't have to run ``bash`` when you open
a new terminal window (or need to set a default terminal command).

- To revert::

    chsh -s /bin/bash

-------

REFER: See these ``man`` pages for more on the above commands::

  man chsh
  man 8 DirectoryServices
  man 8 opendirectoryd

AUDIT: Verify the default shell:

- You can show the user's default shell using these
  macOS-specific commands::

    dscl . -read /Users/${LOGNAME} UserShell
    # OUTPUT (fresh macOS default):
    #   UserShell: /bin/zsh
    # OUTPUT (after running `chsh` above):
    #   UserShell: /opt/homebrew/bin/bash

    # For the current macOS user:
    dscl . -read ~/ UserShell

    # To parse the path inline using sed:
    dscl . -read ~/ UserShell | sed 's/UserShell: //'

- Or for Linux::

    @Linux $ cat /etc/passwd | grep -e "${LOGNAME}" | awk -F  ':' '{print $NF}'
    /bin/bash

- REFER: Thanks to this post for cluing me into ``dscl``:

  https://stackoverflow.com/a/41553295

-------

###################################################
ONBRD: Wire ``fs`` (install ``gvim-open-kindness``)
###################################################
.. 2024-04-14

USAGE: The ``fs`` command is a DepoXy Bash alias that
runs ``gvim`` with a specific ``--servername``, so that
files are always opened in the same GVim window, and not
in a new instance.

- SAVVY: The ``cdks`` command used below is a DepoXy alias
  that ``cd``'s to the ``~/.kit/sh`` directory.

  - DepoXy defines a number of ``cdXX`` aliases to make
    it easy to ``cd`` to different project directories.

  - This is the author's preferred means of moving around projects,
    and one reason I don't really have a need for Z Shell (or
    *Oh My Repos*, which has its own "smart" ``cd`` methodology
    to help you avoid typing (or TAB-completing, or remembering)
    long directory paths).

    - Granted, you still have to remember DepoXy's ``cd`` aliases,
      but they should be pretty intuitive.

      - E.g., ``cdk`` will ``cd`` to the ``~/.kit`` path.

      - And ``cdks`` will ``cd`` to the ``~/.kit/sh`` path.

      - As another example, ``cdgt`` will ``cd`` to ``~/.kit/git/tig``.

      - But for ``gvim-open-kindness``, which is *very* stable at this
        point, there is no ``cdXX`` alias for it, because this is
        probably the only time you'll have to ``cd`` to it...

SAVVY: ``mr`` is the ``myrepos`` command.

- And ``mr -d . n install`` tells ``mr`` to run the 'install'
  action on that specific directory (the ``-n`` tells ``mr``
  not to run the 'install' action on sub-directory Git projects,
  though not that there are any).

-------

**STEPS**::

  cdks
  cd gvim-open-kindness
  mr -d . -n install

-------

PROBE: You can test that ``fs`` is working properly by opening a file.

- E.g., you could ``cd`` to the ``macOS-onboarder`` project and open
  the ``defaults`` runner with these commands::

    cdmo
    fs bin/slather-defaults.sh

-------

##################################
ONBRD: Cognominate your @host name
##################################
.. 2024-04-13

UCASE: Unless your vendor sets the hostname for you, you may want
to pick your own hostname.

- In UNIX tradition, you might choose to name your host after
  characters or names of Greek mythology.

  - E.g., if your like waterways and the underworld, you could
    name your host after one of the
    `rivers of Hades <https://en.wikipedia.org/wiki/Greek_underworld#Rivers>`__,
    such as ``@lethe``.

SAVVY: By default, Apple names your host using your Apple ID account
followed by the model name of the machine, e.g., ``@User's Mac mini``.

- How bland!

SAVVY: DepoXy uses the hostname in the shell command prompt, e.g.::

  user@hostnme:current-directory 🍄 $

- DepoXy includes an emoji character to let you know the shell context:

  - For a new terminal window, you'll see one such character: 🍄

  - If you're running a shell within a shell, which you might do if
    you edit your Bashrc scripts but don't want to close and reopen
    the terminal window, you'll see: 🍅

    - Seeing this emoji lets you know that ``exit`` won't close
      the terminal window!

  - If the shell is running over SSH, you'll see: 💀

  - These emoji are easily configurable, but that's a tale for another
    README.

    (Or you could just configure your own ``PS1`` prompt using
    your private DepoXy Client Bashrc.)

-------

**STEPS**: Pick a <hostname> and deem it your host:

- Change the local host name, and also set two related values::

    sudo scutil --set ComputerName <hostname>
    sudo scutil --set LocalHostName <hostname>
    sudo scutil --set HostName <hostname>

-------

REFER: See ``man scutil`` re: the three names::

  ComputerName    The user-friendly name for the system.

  LocalHostName   The local (Bonjour) host name.

  HostName        The name associated with hostname(1)
                    and gethostname(3).

-------

####################################################
ONBRD: Securely install LAN SSH keys on the new host
####################################################
.. 2024-04-14

**BWARE**: If you're on a vendor machine, you'll probably
want to skip this section. Unless you'll be remoting into
your new host for some reason, you should need to worry
about SSH (and I.T. will probably-hopefully have locked
it down tight already).

-------

UCASE: If you use multiple hosts and want to SSH between them,
you should setup SSH keys to connect between them. (And then
in the next step we'll disable SSH password authentication
to harden security, before firing up the SSH daemon.)

- I call these *LAN SSH keys* because they enable you to
  interconnect between all the hosts that you own.

  - *LAN* keys because they should only work on
    your side of a personal, home-based router.

    - They should not work from outside your home.

    - In fact, you many want to disallow SSH connections
      from the WAN through your router.

    - If you want to connect to a personal host from outside
      your home, i.e., a WAN connection, you can add a route
      through your router to one of your hosts for SSH access.
      But I'll leave that exercise for you to figure out.

      - And I would insist that you use a unique SSH key
        for external connections, preferably using
        elliptic curve cryptography (ECC) for the key.

        Also, you might want to obfuscate the SSH port number.

        But note that Apple makes it tricky to change the SSH port
        number, because their built-in SSHd does not honor
        changing the ``Port`` number setting in ``sshd_config``.
        From what I've read (I have not tried it), you have to
        install a separate SSH daemon and manage it yourself.

  - For instance, I have, ugh, one desktop machine, two laptops,
    and a NAS host, and I can connect between them all.

    - My desktop machine has the largest hard drive, otherwise
      I'd probably retire it. It's basically my backup host.

    - And I have two laptops, one older, and one newer, but I
      like to keep them both up to date in case the newer one
      (that I carry around in my backpack while traveling or
      commuting by bike) were to take a blow.

      I don't want *any* downtime, if ya feel me.

    - In any case, each machine shares the same *LAN SSH*
      private key, so that I can interconnect between them
      all when I'm at home.

- You have a few options to setup SSH keys, but it depends on
  your environment.

  - Here are some of the methods you could use to copy keys:

    - Copy them to a USB device from an existing host,
      and then copy them to your new Mac from that device.

    - Or, enable SSH password authentication temporarily
      so you can copy them between hosts without additional
      hardware.

    - Or, encrypt them and transfer them between hosts using
      email.

    - Or, encrypt them and transfer them between hosts using
      a private GitHub (or comparable) repo.

If you're using a vendor machine, I *highly* recommend you
skip this section — Unless you've already done so on a
vendor machine you already have, then read on for why I
think this is a Bad Idea.

- Like, don't even bother reading what I've written below.

  Just scroll down, please.

  You don't need to — nor should you want to — transfer any
  personal secrets (SSH keys or passwords) to the employer
  machine.

- However, if you've already setup you own apps and accounts
  on *an employer's laptop*, sure, please read on and learn
  why I think that's so, *so dumb*.

- And I'm not talking from personal experience here.

  I've just seen coworkers who have done it, because they
  screen-casted to me, and I could see their Dock was full
  of their own apps, email, games, etc., and I felt it very,
  very *stupid*.

-------

SAVVY: Here are my feelings about SSH between your hosts and
an employer's host:

- Basically, don't do it!

But here are my thoughts nonetheless:

- Oftentimes, a vendor will inhibit mounting USB devices, which
  is probably the easiest method:

  - Plug a USB device into your existing host, copy your LAN
    SSH keys (public and private) to the USB device, then
    plug the USB device into your macOS host and install
    those keys.

  - But if you're using a vendor machine (like a MacBook they
    gave you), you *should not* be SSH'ing between your personal
    machines and the vendor machine!

    *Don't do it!!*

    Not only are you probably violating your employer-vendor's
    policies, but this creates a security risk for both you and
    the vendor:

    - If anything leaks from your machine to their machine,
      you're hosed.

    - And if they see you SSHing into their host from a machine
      outside their purview, they're gonna think you're *pulling
      a Snowden*. (Albeit, without using a USB device hidden in
      a Rubik's Cube.)

  - If you really need to transfer sensitive data (keys, passwords)
    from a personal machine to a vendor machine, send it through
    their corporate email, using ``gpg -e`` to encrypt it before
    emailing, and ``gpg -d`` later to decrypt it.

    - You could instead use a private GitHub repo to push/pull it,
      but I'd also implore that you encrypt/decrypt it, as well.

    - At least in this case you have some plausible deniability
      as to your intent, because you weren't trying to hide
      anything from them. *You were using the systems in place
      that they authorized you to use.*

  - Basically, treat the vendor machine as *their* machine, and
    *don't poke the beast.*

    Give them *nothing* to blame you for playing fast and loose.

    Play by the book.

    You don't need to access personal email, Spotify, or whatever,
    from their machine. Use your own phone to check personal email
    or to listen to music if you're on-site. Or buy a dual-input
    monitor if you work remote, and switch between your laptop
    and their laptop when you need to bop over to personal concerns.

  - I think I've made my point...

    Basically, skip this section if the machine you're setting
    up is *not your machine*. You don't need SSH access to the
    vendor machine they sent your to do development work *on
    their code*.

That said, if you're setting up a *personal* host, read on.

- Otherwise, skip ahead to the next §, please.

-------

**STEPS**: Here's how you might copy SSH keys from an old host
to new host using SSH:

- Edit the old host's ``~/.ssh/config``, if necessary:

  - Add a new ``Host`` section with your new host's name,
    and possibly it's LAN address.

- In the next §, you'll disallow password authentication, because
  SSH keys are much more secure.

  But in case that's already done, you'll need to edit your new
  host's ``/private/etc/ssh/sshd_config``:

  - You'll need to change::

      PasswordAuthentication no

    to::

      PasswordAuthentication yes

    in this file on your new host::

      /private/etc/ssh/sshd_config

- Then you can copy the two keys (public and private)
  from your old host to the new host, e.g.::

    @old-host $ scp -p ~/.ssh/<id_lan_key>* <new-host>:/Users/user/.ssh/

- Test it::

    # Connect @control → @managed
    @old-host $ ssh <new-host>

    # Connect @control → @managed → @control
    @new-host $ ssh <old-host>

- Then revert the changes to ``/private/etc/ssh/sshd_config``.

-------

SAVVY: Note that flash devices historically do not support ``shred``,
in the sense that writ data cannot be faithfully scrambled,
though newer devices might allow better data eradication.

- In other words, once written to a flash device, it's difficult
  to eradicate data.

- So, if you're paranoid (or just excited) about data security,
  you'll want to encrypt sensitive data before slamming it onto
  a flash drive.

- Here we use ``gpg`` to encrypt data before copying it to the
  USB device, in case we cannot rely on ``shred`` to faithfully
  erase it.

**STEPS**: Here's how you might copy SSH keys from an old host
to a new host using a USB drive.

- From the old host::

    # @old-host

    mkdir -p /tmp/foo
    cd /tmp/foo

    gpg -o "<id_lan_key>" --cipher-algo AES256 -c "~/.ssh/<id_lan_key>"
    # Prompts for a one-time password you'll need to decrypt it

    # SAVVY: On @Linux, /<mount> might be /media; or on @macOS, /Volumes
    mkdir -p /<mount>/<usb-device>/.ssh/

    cp <id_lan_key> /<mount>/<usb-device>/.ssh/

    # Also copy the public key to the USB device
    cp ~/.ssh/<id_lan_key>.pub /<mount>/<usb-device>/.ssh/

    # Eradicate the encrypted private key from /tmp
    shred <id_lan_key>

- Decrypt and install the SSH key pair onto the new host
  (i.e., after reconnecting the USB device from the old
  host to the new host)::

    # @new-host

    mkdir -p ~/.ssh

    # - Click *Allow* access to "/Volumes", if prompted
    # - Enter the password you used from the previous gpg command
    gpg -q -d /Volumes/<usb-device>/.ssh/<id_lan_key> \
      > ~/.ssh/<id_lan_key>

    cp /Volumes/<usb-device>/.ssh/<id_lan_key>.pub \
      > ~/.ssh/<id_lan_key>.pub

    # Whether or not `shred` is effective, might as well use it
    shred -u /Volumes/<usb-device>/.ssh/<id_lan_key>
    shred -u /Volumes/<usb-device>/.ssh/<id_lan_key>.pub

    cat ~/.ssh/<id_lan_key>.pub >> ~/.ssh/authorized_keys

    chmod 2750 ~/.ssh
    chmod 400 ~/.ssh/config*
    chmod 400 ~/.ssh/<id_lan_key>
    chmod 440 ~/.ssh/<id_lan_key>.pub
    chmod 640 ~/.ssh/authorized_keys

-------

**STEPS**: The third option for transferring keys is to email it to yourself.

- E.g., encrypt the private key per the *STEPS* above, and
  send it an email address you can access on the new host,
  and decrypt and install it accordingly.

-------

##########################################
ONBRD: Disable SSH password authentication
##########################################
.. 2024-04-14

UCASE: Passwords are inherently less secure than SSH keys.

- Here we lock down the SSH daemon so it disallows password
  authentication and only allows hosts to connect with a
  stronger SSH private key.

SAVVY: You could edit the ``sshd_config`` manually, but
here were use the ``ohmyrepos`` project's ``line_in_file``
function, which is a simple replicate of the Ansible
`lineinfile <https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html>`__
module. It ensures that the target file contains the
specified line in its config, writing it if necessary,
or skipping the operation if the line is already present.

-------

**BWARE**: If you're on a vendor machine, you may want to skip
or not worry about this step, or maybe check with I.T. first?

- On the other hand, you are probably making the device more
  secure. But you could also be blocking I.T. processes from
  working (though I have no idea).

-------

SAVVY/2024-08-23: Now automated via DepoXy 'infuse' task.

HSTRY: Something like this will run on ``infuse``::

  infuse_macOS_configure_sshd_config_update () {

    target=/private/etc/ssh/sshd_config

    sudo cp -- "${target}" "${target}--orig"

    . "${HOME}/.kit/git/ohmyrepos/lib/line-in-file.sh"

    OMR_BECOME=sudo line_in_file "${target}" \
      "^PasswordAuthentication " \
      "PasswordAuthentication no"

    OMR_BECOME=sudo line_in_file "${target}" \
      "^ChallengeResponseAuthentication " \
      "ChallengeResponseAuthentication no"

    # For good measure, add ITERM_SESSION_ID hook for window titling
    OMR_BECOME=sudo line_in_file "${target}" \
      "^AcceptEnv ITERM_SESSION_ID$" \
      "AcceptEnv ITERM_SESSION_ID"

    diff "${target}--orig" "${target}"

    # SAVVY: Save to user dir, in case macOS update overwrites /private/etc/ssh/
    mkdir -p ~/Documents/sshd
    cp -- "${target}" "${target}--orig" ~/Documents/sshd/
  }

- SAVVY: If ``sshd`` is running, changes take effect immediately.

-------

#################
ONBRD: Start SSHd
#################
.. 2024-04-14

**BWARE**: You'll probably want to skip this section if
you're setting up a vendor machine (and if you skipped
the two previous §s).

-------

**STEPS**: Enable SSH remote logon::

  # ADHOC: *Allow* "Full Disk Access" via GUI popup prompt

  sudo systemsetup -setremotelogin on

  # OUTPUT, maybe:
  # setremotelogin: Turning Remote Login on or off requires Full Disk Access privileges.

PROBE: Verify::

  ssh localhost

-------

REFER: See FDA Settings:

- System Settings > Privacy & Security > Full Disk Access

CXREF: See also Full_Disk_Access *STEPS*, above.

-------

SAVVY: How to find ``sshd`` logs::

  log stream --level debug | grep ssh

-------

######################################
ONBRD: Run ``DXY/slather-defaults.sh``
######################################
.. 2024-04-13

OVIEW: Apply ``defaults`` settings and wire basic Keyboard Shortcuts

- The slather file runs quick, but it's sorta fragile: If Apple
  or an app developer changes ``defaults`` key names or values,
  it could "break" the customization.

  - It's not harmful to write a ``defaults`` key value that's
    ignored, but you might not notice that a particular setting
    is no longer working.

    So when upgrading to a new macOS major version, you might
    want to audit this script as you run it.

-------

**STEPS**:

- OPTLY: One option is to just run the script.

  It'll most likely work, especially if you've run it against a
  similar macOS version (or if the author has kept it up to date)::

    cd ~/.depoxy/ambers/bin/onboarder

    ./slather-defaults.sh --dry-run

    # KBOOM: Run this when you're ready!:

    ./slather-defaults.sh

- OPTLY: Another option is to run the script piecemeal.

  This might be a good idea after upgrading to a new major OS version.

  Open the script in a text editor, source it into your shell, and then
  copy-paste code or individual commands to audit each setting or
  collection of settings::

    cd ~/.kit/mOS/macOS-onboarder
    fs bin/slather-defaults.sh
    . bin/slather-defaults.sh
    <commands>

  - SAVVY: When fiddling with System Settings manually, you can easily
    tell what changed:

    - Run ``defaults-domains-dump`` first.

    - Change some settings.

    - Run ``defaults-domains-dump`` again.

    - Finally, use ``meld-last-two-dumps`` to inspect the changes.

-------

- CXREF: Consult the source for all the ``defaults`` changes:

  https://github.com/DepoXy/macOS-onboarder/blob/release/bin/slather-defaults.sh

  - As of *2024-04-30*, there are 103 ``defaults write`` calls across
    21 domains, and 87 "reminders" printed (manually tasks not automated).

-------

#####################################
ONBRD: Run OMR `infuse` and `install`
#####################################
.. 2024-08-02

**STEPS**: The ``slather-defaults.sh`` output from the previous §
prints out a list of manual tasks to complete.

- If you want to avoid calling the individual ``mr -d <path> -n install``
  commands, you could call them all at once::

    mr -d / install

- CPYST: Run this to regenerate the manual task reminders::

    mr -d / -M echoInstallHelp

-------

**STEPS**: Run the project infuser (mostly creates/maintains symlinks)::

    mr -d / infuse

  which DepoXy also defines a convenience function for::

    infuse

- SAVVY: Run ``infuse .`` to infuse the current project directory
  (i.e., it's a shortcut for ``mr -d . -n infuse``).

- ADHOC: You'll find yourself running ``infuse`` frequently when
  you're working on ``mrconfig`` files.

-------

######################################
ONBRD: Run ``DXY/deploy-archetype.sh``
######################################
.. 2024-04-22

UCASE: Create a "DepoXy Client" for your host.

- The Client is where you make private config and code changes
  to apps that DepoXy orchestrates.

  - E.g., you can add your own Hammerspoon keybindings in a
    private file that ``~/.hammerspoon/init.lua`` looks for
    at::

      ~/.depoxy/stints/${DXY_DEPOXY_CLIENT_ID}/home/.hammerspoon/client-hs.lua

  - The ``deploy-archetype.sh`` script is essentially a boilerplate
    maker. It uses a bunch of environment values as inputs to generate
    files from templates.

    - The script also makes a symlinks directory that makes it easy
      to diff or compare (or Meld) changes between your Client and
      the Archetype templates.

    - This lets you easily merge changes back and forth between
      your Client and the Archetype project, depending on if you're
      consuming Archetype changes from upstream, or if you want to
      merge new features or changes into the Archetype templates.

  - Note there's another path to the Client you might see::

      ~/.depoxy/running/

    Which is simply a symlink to the active client::

      ~/.depoxy/stints/${DXY_DEPOXY_CLIENT_ID}/

    And allows you to have multiple clients installed.

-------

**STEPS**: Set general options and ``cd`` to the Archetype directory::

  # CPYST: If you want to regenerate the project:
  #   # mv ~/.depoxy/stints/${DXY_DEPOXY_CLIENT_ID} ~/.depoxy/stints/${DXY_DEPOXY_CLIENT_ID}--OFF
  # - Or `rm` it.
  #   # rm ~/.depoxy/stints/${DXY_DEPOXY_CLIENT_ID}

  # ALWYS: Always make the links directory, you'll want it:
  DXA_MAKE_LNS="-h"     # Aka --make-lns [DXY_RUN_MAKE_LNS_OPT]

  # OPTIN: If you just want to rebuild the symlinks:
  DXA_LNS_ONLY="-H"     # Aka --lns-only [DXY_RUN_LNS_ONLY_OPT]
  # When done:
  unset -v DXA_LNS_ONLY

  # ISOFF: This is noisy, it emits all called commands and evals:
  #  DXA_VERBOSE="-v"   #                [DXY_OUTPUT_VERBOSE]

  # BUGGN: Test individual file:
  #  export DXY_TEST_FILE=home/bashrc.VENDOR_NAME.EVAL.sh
  #  # Run test...
  #  # Cleanup:
  #  unset -v DXY_TEST_FILE

  # Aka: cd ~/.depoxy/ambers/archetype
  cxa

  # ID defaults: echo "$(date +%y)$(date -d"sunday" +%U)"
  # E.g., 18th week of 2024 is 2417 (1st week is "2400"):
  DXY_DEPOXY_CLIENT_ID=2417

  # The emoji messes up readline history when part of the command,
  # so setting this environ is separated out.
  DXY_DEPOXY_GVIM_SERVERNAME=🦢

**STEPS**: Edit these environs for yourself, and generate the Client.

- Be sure to set previous environs first::

    DXY_DEPOXY_CLIENT_ID=${DXY_DEPOXY_CLIENT_ID} \
    DXY_DEPOXY_CLIENT_REMOTE=git@github_user:user/${DXY_DEPOXY_CLIENT_ID}.git \
    \
    DXY_VENDOR_NAME_PROPER=ACME \
    DXY_VENDOR_DOMAIN=acme.tld \
    DXY_VENDOR_NAME=acme \
    DXY_VENDOR_HOME="${HOME}/work" \
    DXY_VENDOR_NPM_REGISTRY_URL= \
    DXY_VENDOR_ISSUE_TRACKER_URL='https://github.com/user/flast.sh/issues' \
    \
    DXY_VENDOR_GITCONFIG_HUB_HOST=github.com \
    DXY_VENDOR_GITCONFIG_USER_NAME="First Last" \
    DXY_VENDOR_GITCONFIG_USER_EMAIL=username@domain.com \
    DXY_VENDOR_GITSERVER_USER_NAME="user" \
    DXY_HEADER_AUTHOR="Author: First Last <https://domain.com/>" \
    DXY_VENDOR_DOTFILES_NAME="flast.sh" \
    DXY_VENDOR_ACMESH_NAME="acme.sh" \
    DXY_VENDOR_ACMESH_CMD="acme" \
    \
    DXY_PERSON_GITCONFIG_USER_NAME="First Last" \
    DXY_PERSON_GITCONFIG_USER_EMAIL=user@users.noreply.github.com \
    \
    DXY_DEPOXY_CVS_ALIAS_VIM_PLUG_ORG=user \
    DXY_DEPOXY_GVIM_SERVERNAME="${DXY_DEPOXY_GVIM_SERVERNAME}" \
    \
    DXY_PW_OPTION_PASS_NAME=path/to/clients/${DXY_DEPOXY_CLIENT_ID}/gpw \
    \
    DRY_RUN=true \
    \
      ./deploy-archetype.sh ${DXA_MAKE_LNS:--h} ${DXA_LNS_ONLY} ${DXA_VERBOSE}

- **STEPS**: Copy-paste, confirm arguments, then run again without ``DRY_RUN``.

- CXREF: Consult the source for the inner workings:

  https://github.com/DepoXy/depoxy-archetype/blob/release/deploy-archetype.sh

-------

- OPTNS::

    # Let script compute the headers:
    #   DXY_DEPOXY_HUMAN_NAME
    #   DXY_HEADER_AUTHOR
    #   DXY_HEADER_PROJECT
    #   DXY_HEADER_LICENSE
    #
    # You can often let the script compute the DXC ID:
    #   DXY_DEPOXY_CLIENT_ID=2417 \
    # We'll set:
    #   DXY_DEPOXY_CLIENT_REMOTE=git@github_user:user/depoxy.git
    #
    # We'll set:
    #   DXY_VENDOR_NAME_PROPER
    #   DXY_VENDOR_DOMAIN
    #   DXY_VENDOR_NAME
    #   DXY_VENDOR_HOME
    #   DXY_VENDOR_NPM_REGISTRY_URL
    #   DXY_VENDOR_ISSUE_TRACKER_URL
    #
    # We'll set business client values:
    #   DXY_VENDOR_GITCONFIG_HUB_HOST
    #   DXY_VENDOR_GITCONFIG_USER_NAME
    #   DXY_VENDOR_GITCONFIG_USER_EMAIL
    #   DXY_VENDOR_GITSERVER_USER_NAME
    #   DXY_VENDOR_DOTFILES_NAME
    #   # DXY_VENDOR_DOTFILES_URL
    #   DXY_VENDOR_ACMESH_NAME
    #   # DXY_VENDOR_ACMESH_URL
    #   DXY_VENDOR_ACMESH_CMD
    # We'll set personal user values:
    #   DXY_PERSON_GITCONFIG_USER_NAME
    #   DXY_PERSON_GITCONFIG_USER_EMAIL
    # Let script format the "Project:" header:
    #   DXY_HEADER_DOTFILES=github.com/user/depoxy-client#🥗
    #   DXY_HEADER_DOTPROJECT
    #
    # We'll set:
    #   DXY_DEPOXY_CVS_ALIAS_VIM_PLUG_ORG
    #   DXY_DEPOXY_GVIM_SERVERNAME
    #
    # Maybe for a future client we would set these:
    #   DXY_VENDOR_ORG01_NAME="soylent"
    #   DXY_VENDOR_ORG01_PROJ01_NAME="soylent-red"
    #   DXY_VENDOR_ORG01_PROJ01_ABBREV="sr"
    #   DXY_VENDOR_ORG02_NAME="globex"
    #   DXY_VENDOR_ORG02_PROJ01_NAME="hammock-district"
    #   DXY_VENDOR_ORG02_PROJ01_ABBREV="hd"
    #   DXY_VENDOR_ORG02_PROJ02_NAME="cypress-creek-running"
    #   DXY_VENDOR_ORG02_PROJ02_ABBREV="cc"
    #   DXY_VENDOR_ORG02_PROJ02_ABBREV3="ccr"
    #
    # Let script compute these:
    #   DXY_USERNAME"$(id -un)"
    #   DXY_HOSTNAME="$(hostname)"
    #   DXY_USER_HOME="${HOME}"
    #   DXY_USER_CONFIG_FULL="$( \
    #     os_is_macos \
    #     && echo "${HOME}/Library/Application Support" \
    #     || echo "${HOME}/.config")"
    #
    # Use script defaults:
    #   DXY_DEPOXYDIR_BASE_FULL
    #   DXY_DEPOXYDIR_STINTS_NAME
    #   DXY_DEPOXYDIR_RUNNING_FULL
    #   DXY_DEPOXYDIR_RESERVABLE_FULL
    #   DXY_DEPOXY_HOSTNAMES_NAME
    #   DXY_MAKE_LNS_NAME
    #
    #   DXY_DEPOXYAMBERS_DIR
    #   DXY_DEPOXYARCHETYPE_DIR
    #   DXY_DEPOXY_PROJLNS
    #   DXY_DEPOXY_PROJLNS_EXCLUDE_RULE
    #   DXY_DEPOXY_PROJLNS_DIR_TILDE
    #   DXY_DEPOXY_PROJLNS_DIR__HOME_
    #   DXY_DEPOXY_SCREENCAPS_DIR
    #   DXY_DEPOXY_SCREENCAPS_DIR__HOME_
    #   DXY_DEPOXY_SCREENCAPS_EXCLUDE_RULE
    #   DXY_HOMEFRIES_DIR_NAME
    #   DXY_DOPP_KIT_NAME
    #
    #   DXY_PW_PATCHES_REPO
    #   DXY_PW_OPTION_PASS_NAME

-------

########################################################
ONBRD: Create Encrypted APFS & DMG Volumes (``321open``)
########################################################
.. 2024-05-29

OVIEW: Create and mount 3 file systems

- 1.) An encrypted, case-insensitive APFS Volume that will not
      auto-mount (otherwise prompts for the passphrase when you
      log on), and that mounts via ``321open``::

        APFS_ENCFS_VOLUME_NAME="fantasm"

- 2.) An encrypted, case-sensitive DMG sparse image and/or sparse bundle.

      - A sparse image is akin to a Linux ``tomb``, a single-file,
        fixed-size (or max-sized) encrypted file-system-in-a-file.

      - A sparse bundle is akin to ``gocryptfs`` or other encrypted
        file systems that use multiple encrypted files to back the
        sources (though some are 1:1 with plaintext files, and others
        obfuscate the number of files and directories).

      ::

        # Set size to zero or empty string to disable sparse bundle.
        DMG_ENCFS_BUNDLE_NAME="vestige"
        DMG_ENCFS_BUNDLE_SIZE="50m"

        # Set size non-zero to enable sparse image.
        DMG_ENCFS_IMAGE_NAME="vestige"
        DMG_ENCFS_IMAGE_SIZE="0m"


- 3.) There's also a plain, unencrypted, case-sensitive APFS Volume that
      auto-mounts, but you probably won't use this, because case-sensitive::

        APFS_PLAIN_VOLUME_NAME="artless"

- CXREF: Use the config file to change the file systems profile:

    https://github.com/DepoXy/depoxy-archetype/blob/release/home/.config/depoxy/321open.EVAL.cfg

.. LOCLY: file://~/.depoxy/stints/2417/home/.config/depoxy/321open.cfg

-------

**STEPS**: Create the file systems::

  # USAGE: Adjust environs discussed above to customize, otherwise
  #        run `321open` to accept the defaults.

  321open

**STEPS**: Create the volume wiring::

  wire_volume () {
    local vol_name="$1"
    local home_dir="$2"

    ln -sfn "${HOME}/.mrinfuse" "/Volumes/${vol_name}/.mrinfuse"

    mkdir -- "/Volumes/${vol_name}/${home_dir}"
    ln -sfn "/Volumes/${vol_name}/${home_dir}" "${HOME}/${home_dir}"
  }

  wire_volume "fantasm" ".elsewhere"

  # CXREF: USER_LUNCHBOX_DIR, USER_LUNCHBOX_TUNA
  #  # wire_volume "vestige" ".lunchbox"  # Naw, use vestige for .clench/ only
  wire_volume "fantasm" ".lunchbox"

-------

- SAVVY: Be aware how you use the separate mount(s):

  - You cannot create hard links between devices.

    - So you cannot put ``~/.kit`` on a separate file system
      than ``$HOME`` because a number of the projects therein
      use hard links (``link_hard``) to wire other user home
      locations. (At least not without moving projects around,
      which you don't want to do.)

- SAVVY: You also don't want to use a case-sensitive file system,
  which won't catch case-clash issues that could then affect other
  developers (on other Macs) if you, e.g., commit case-clashed paths
  to a repo and another dev tries to view those changes.

-------

#################################################
ONBRD: Customize Finder, and add Finder Favorites
#################################################
.. 2024-07-04

**STEPS**: Finder > View > Show View Options:

- ✓ Always open in list view

  - ✓ Browse in list view

- Click [ Use as Defaults ]

-------

**STEPS**: Adjust Finder (<Cmd-F>) Favorites:

- REFER: Default Finder Favorites:

  - AirDrop, *Recents*, Applications, Desktop, Documents, Downloads, <user>

- STEPS: Open a Finder window, and then:

- STEPS: Right-click each and *Remove from Sidebar*:

  - AirDrop

- STEPS: Find commonly used directories, and drag under *Favorites*, e.g.,::

    ~/.kit
    ~/Dropbox
    /tmp
    etc.

-------

- BWARE: The *Rename* option in the Favorites context menu
  renames the source directory, not the Favorite, ha.

-------

#######################################################
ONBRD: Configure Sounds: Choose Alert and Output device
#######################################################
.. 2024-05-20

**STEPS**:

- macOS > System Settings... > Sound > Sound Effects >

  - Alert sound: *Crystal*
    (seems the gentlest, least likely to startle-est)

  - Play sound effects through: <*Choose the appropriate device, e.g.,
    if you want to play sounds through your monitor speakers*>

- macOS > System Settings... > Sound > Output & Input >

  - *Click*:

    - *External Headphones*, when you have external speakers connected.

-------

############################################################
ONBRD: Configure Notification Center: Add and Remove Widgets
############################################################
.. 2024-10-02

**STEPS**:

- Open the Notification Center:

  - Click the Clock in the macOS menu bar;

    Or press <Shift-Ctrl-Alt-C> (wired by ``slather-defaults.sh``)

  - Click *Edit Widgets...* at the bottom

- Customize the widgets:

  - I like to remove everything and start over with a few basic widgets:

    - First row, side-by-side:

      - *Weather > Sunrise and Sunset* [1×1 size]

      - *Calendar > Month* [1×1 size]

        - Doesn't show events, just month day numbers

        - If you use Google Calendar and would like to wire that into macOS
          so you can use the other Calendar widgets and see your events,
          refer to:

          - *Add Google Calendar events to Apple Calendar*

            https://support.google.com/calendar/answer/99358

    - Second row:

      - *Weather > Forecase* [2×2 size]

        - Pick the largest widget [2×2], which shows the current
          weather and the 5-day forecast.

    - Third row:

      - *Screen Time > Daily Activity* [1×2 size]

        - Pick the medium-sized widget [1×2] that shows a bar graph
          with a slightly wider x-axis, and includes an abbreviated
          (condensed) app. time display (icons but not app. names).

-------

###########################################################################
ONBRD: Install and enable ``updatedb`` launch agent, for ``locate`` command
###########################################################################
.. 2024-08-09
.. onbrd-setup-updatedb-for-locate-command

.. CXREF: ~/.depoxy/ambers/home/Library/LaunchAgents/README.rst
.. |LaunchAgents/README.rst| replace:: ``LaunchAgents/README.rst``
.. _LaunchAgents/README.rst: https://github.com/DepoXy/depoxy/tree/release/home/Library/LaunchAgents/README.rst

UCASE: So you can find files quickly with the ``locate`` command.

**STEPS**::

  mr -d "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}" -n install

  launchctl enable gui/501/com.tallybark.daily-updatedb

- REFER: See |LaunchAgents/README.rst|_ for more details.

.. Full_Disk_Access

**STEPS**: Configure FDA for ``gfind``.

- REFER: See `Configure Full Disk Access`_ above.

.. _Configure Full Disk Access: #onbrd-configure-full-disk-access

-------

############################################################################
ONBRD: Install and enable ``check-sshd_config`` launch agent, for monitoring
############################################################################
.. 2024-08-23

UCASE: Because macOS clobber-reverts ``/private/etc/ssh/sshd_config`` on
every OS update.

**STEPS**::

  mr -d "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}" -n install

  launchctl enable gui/501/com.tallybark.check-sshd_config

- REFER: See |LaunchAgents/README.rst|_ for more details.

.. FIXME Remove unless also necessary
..
.. .. Full_Disk_Access
..
.. **STEPS**: Configure FDA for ``gfind``.
..
.. - REFER: See `Configure Full Disk Access`_ above.
..
.. .. _Configure Full Disk Access: #onbrd-configure-full-disk-access

-------

#########################################
OPTLY: Install ``sshfs``, and ``macFUSE``
#########################################
.. 2024-09-05

UCASE: Mount network path locally over SSH.

**STEPS**:

- Install macFUSE (this may require a password)::

    brew install --cask macfuse

- Download and install ``osxfuse-sshfs``

  https://github.com/osxfuse/sshfs/

  - E.g.,
    https://github.com/osxfuse/sshfs/releases/tag/osxfuse-sshfs-2.5.0

  - Run wizard (and accept EULA), e.g.,::

      open sshfs-2.5.0.pkg

-------

USAGE: E.g.,::

  sshfs -o follow_symlinks host:/path/on/remote/host ~/path/to/local/mountdir

  # To unmount, use `umount -f`, not `fusermount -u`
  umount -f ~/path/to/local/mountdir

-------

########################
⋰ ⋱ ⋰ ⋱  ADHOCs  ⋰ ⋱ ⋰ ⋱
########################

##################################################################
ADHOC: Run ``infuse`` to undo file changes — After upgrading macOS
##################################################################
.. 2024-08-23

UCASE: macOS resets files and options after (some/most/all?) OS updates.

- E.g., after updating to macOS Sonoma 14.6.1 (Aug, 2024), macOS reset
  SSH options::

    /private/etc/ssh/sshd_config

  And it also reverted the default non-interactive shell::

    /var/select/sh -> /bin/bash

**STEPS**: After every macOS OS upgrade, especially after a necessary
reboot, run ``infuse`` to undo the damage::

  infuse

-------

##################################################################
ADHOC: Sign in Apple ID account            — After upgrading macOS
##################################################################
.. 2024-04-10

INERT/2024-08-23: I haven't needed to do this recently (and
not after rebooting for macOS Sonoma 14.6.1).

**STEPS**: System Settings > Update Apple ID Settings:

- *Some account services require you to sign in again.* <Continue>

-------

- SAVVY: Upgrading to Sonoma 14.5, I was not prompted for the password.

  There was a few second delay, then *Update Apple ID Settings* disappeared
  from the sidebar.


##################################################################
ADHOC: Re-run ``xcode-select --install``   — After upgrading macOS
##################################################################
.. 2023-01-13

INERT/2024-08-23: I haven't needed to do this recently (and
not after rebooting for macOS Sonoma 14.6.1).

WRKLG/2023-01-13: After updating to macOS Ventura::

  $ tig
  tig: Not a git repository

  $ git log
  xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools),
    missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun

SOLUN::

  xcode-select --install

-------

###########################################################
ADHOC: When any popup asks *Automatically Update*, click it
###########################################################
.. 2024-04-14

**STEPS**: Oftentimes when you first open an application, it will ask if
you want it to automatically search for, download, and install updates.

- Go for it.

-------

##############################################
ADHOC: Download Animated Wallpaper Backgrounds
##############################################
.. 2024-07-09

**STEPS**: You can download Animated Wallpaper Backgrounds:

  System Settings > Wallpaper

- I like the mountainous, snowy, and icy Landscape wallpapers.

-------

- BWARE: These take up a lot of space!

  - You'll see the space used reported by ``/usr/bin/du`` (not ``gdu``)::

      /usr/bin/du -d 2 -g /System/Volumes/Data/

    TRCKY: Apparently the Finder doesn't include the wallpaper files
    in its disk size calculation, because it auto-deletes those files
    when the drive passes a certain fullness threshold.

    - A weird little sleight of hand to not freak out its customers?

  - CPYST: You'll see the files themselves at::

      ll "/System/Volumes/Data/Library/Application Support/com.apple.idleassetsd/Customer/4KSDR240FPS"/*.mov

-------

##########################################################################
ADHOC: Run OMR `wireRemotes` to change project remotes — https:// → ssh://
##########################################################################
.. 2024-07-12

**STEPS**: DXY OMR config uses ``https://`` remotes by default,
but if you installed an SSH GH key, you'll want to change those
to ``ssh://`` remotes. Something like this::

  # USAGE: Set both MR_REMOTE= and MR_REMOTE_HOME= if necessary
  mr -d / wireRemotes

-------

#############################################
ADHOC: Configure Chrome Settings & Extensions
#############################################
.. 2024-07-18

Google Chrome settings and extensions are generally *synced*,
unless you're setting up a new vendor host and you're not
using your personal Google account to configure it. So follow
along.

-------

**STEPS**: Open Settings and configure *On startup*:

- Press ``Command-,`` in Chrome to bring up the settings,

  or find *Settings* in the Chrome browser window menu,

  or invoke *Chrome > Settings...* from the menubar.

  - Find *On startup* in the left-hand sidebar and choose:

    - On startup > ✓ *Continue where you left off*

**STEPS**: Open Settings and configure *Downloads*:

- Find *Downloads* in the left-hand sidebar and choose:

  - Downloads > ✓ *Ask where to save each file before downloading*

**STEPS**: Linux full screen generally removes title bar,
which you can emulate in macOS Chrome with following menu option:

- View > ✗ Always Show Toolbar in Full Screen (<Shift-Cmd-F>)

**STEPS**: Disable new Tab Groups feature.

  - Visit: chrome://flags

  - Search for *Tab Groups Save UI Update*.

  - Enable it.

  - Restart Chrome.

  - Right-click the Bookmarks Bar on the right (but not on the
    Tab Groups icon) and deselect *Show Tab Groups*.

  - HSTRY: Circa 2024-10-03, Chrome shows a new Tab Groups feature on the
    left of the Bookmarks Bar, but you cannot hide it.

    - It's four square icons using different colors, then a "»" dropdown
      with addition tab groups.

    - For me, it turned all my Android Chrome tabs into tab groups that I
      see on macOS Chrome — and I have so many tabs open on Android that
      the "»" dropdown extends past the bottom of my monitor. (And it's
      just a long list of colorful square icons, not very helpful! You
      have to right-click each one to see what pages are in each group!)

    - While you can right-click each *effin* icon and select *Delete Group*,
      you didn't ask for such a pointless, repetitive chore!

    - Fortunately, there's an easier way: enable the hidden feature,
      *Tab Groups Save UI Update*.

    - This replaces the four square icons and "»" dropdown with a single
      icon which looks like a grid of 4 small squares (2×2).

    - It also adds a new option to the Bookmarks Bar context menu:
      *✓ Show Tab Groups*, that you can now disable (to hide the
      4-small-squares icon).

    - Thanks for wasting a half-hour of my life, Chrome.... (I know Chrome
      is free, and otherwise it's a great product, but every once in a
      while some experimental "feature" appears in my browser that's
      more hindrance or annoying than helpful, and there's almost never
      an obvious way to disable it. Furthermore, searching for a solution
      is difficult, both trying to pick the right search words, and also
      because the issue is so new, there's often little or no content on
      it, or the content won't be surfaced in the results because it's so
      fresh. So then I end up flipping bits in chrome://flags, restarting
      Chrome a bunch, and hoping I can eventually figure it out.) /GRIPE

-------

ONBRD: EQUIP: Browser Extension: Toolbar Clocks
===============================================
.. 2024-07-18

Digital clocks
--------------

- Separate Hours and Minutes

  - *Just a Clock - the Hours*

    https://chromewebstore.google.com/detail/just-a-clock-the-hours/agglgohcegmeeaccikjfmehncfomccpg?hl=en

  - *Just a Clock - the Minutes*

    https://chromewebstore.google.com/detail/just-a-clock-the-minutes/pgmgkfgcnigcopcjhilfabbdgmjmkogj?hl=en

  - Settings: Chose White text

  - I like this idea, but I don't like how far apart the two parts are.

-------

Analog clocks
-------------

- *Showtime: Analog Clock for Google Chrome -TM*

  https://chromewebstore.google.com/detail/showtime-analog-clock-for/gmijbecoabidbcpmdmjliomhiajakgfc

- *Clock for Google Chrome*

  https://chromewebstore.google.com/detail/clock-for-google-chrome/emakkfldeggiinnfcdjkakdfcppbfhdg

  - Includes option to show digital time instead,
    but it's pretty small, and there's no colon.

  - Analogue clock settings: Custom color hands: White

  - 2024-07-18 23:15: I trying just this clock for now,
    seems the easiest to read...

-------

Other Google Chrome Extensions
==============================

- Bitmoji

  https://chromewebstore.google.com/detail/bitmoji/bfgdeiadkckfbkeigkoncpdieiiefpig

- Go Back With Backspace [developed by Google]

  https://chromewebstore.google.com/detail/go-back-with-backspace/eekailopagacbcdloonjhbiecobagjci

- Google Docs Offline 1.78.1 [developed by Google]

  https://chromewebstore.google.com/detail/google-docs-offline/ghbmnnjooekpmoecnnnilnnbdlolhkhi

- React Developer Tools 5.3.1 (7/3/2024) [from Meta]

  https://chromewebstore.google.com/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi

  - Leave all settings disabled

- Regex Search 1.8

  https://chromewebstore.google.com/detail/regex-search/bcdabfmndggphffkchfdcekcokmbnkjl

  - *Pin to toolbar*

  - Default Keyboard shortcuts:

    - <Shift-Alt-F> — Activate the extension

    - <Shift-Alt-N> — Go to the next search result

    - <Shift-Alt-P> — Go to the previous search result

- Reload All Tabs 5.0.0

  https://chromewebstore.google.com/detail/reload-all-tabs/midkcinmplflbiflboepnahkboeonkam

  - *Pin to toolbar*

  - Default Keyboard shortcuts:

    - Not set — Activate the extension

    - <Shift-Cmd-R> — Toggle reload

-------

#####################################
ADHOC: Configure Chrome User Profiles
#####################################
.. 2024-07-18

STEPS:

- Chrome > ⋮ > [Username] > Add New Profile

- Chrome > ⋮ > Settings (``<Cmd-,>``) > Appearance > ✗ Show bookmarks bar

  ``chrome://settings/appearance``

- Setup extensions you might want.

  - REFER: See previous §: *ADHOC: WEB: STEPS: Google Chrome Settings & Extensions*

-------

################################################
ADHOC: DFLTS: Configure Chrome Devtools Settings
################################################
.. 2024-07-18

STEPS: Open Devtools, then <F1> brings up Settings

- Edit Shortcuts:

  - Search in panel: Edit <Cmd-F> → <Ctrl-F>, and ✗ Delete <F3>, then click ✓

  - Find next result: Leave <Ctrl-G>, and add <F3>

  - Find previous result: Leave <Shift-Ctrl-G>, and add <Shift-F3>

-------

#######################################################
ADHOC: Configure postfix to relay local emails to Gmail
#######################################################

STEPS: Update ``/etc/postfix/main.cf``

- SAVVY: On @macOS, ``/etc`` -> ``/private/etc``

- Create backup.

  - STEPS::

      sudo cp -a /etc/postfix/main.cf /etc/postfix/main.cf--$(date "+%Y-%m-%d")

  - See also related files::

      /private/etc/postfix/main.cf.default
      /private/etc/postfix/main.cf.proto

- Add custom ``myhostname``.

  - STEPS: Pick your own hostname, e.g., DepoXy users might use ``VENDOR_DOMAIN``::

      sudo bash -c 'echo -e "\nmyhostname = $(hostname).${VENDOR_DOMAIN:-acme.com}" >> /etc/postfix/main.cf'

  - Or simply::

      sudo bash -c 'echo -e "\nmyhostname = ${MYHOSTNAME:-myhost.acme.com}" >> /etc/postfix/main.cf'

- Comment out existing ``message_size_limit = 10485760`` line, so that
  large emails are not rejected.

  - STEPS::

    . ~/.kit/git/ohmyrepos/lib/line-in-file.sh

    # SAVVY: line_in_file uses `tac`, so reverse order of replacement "line"'s lines.

    line_in_file \
      main.cf \
      "^message_size_limit = ([0-9]+)$" \
      "# message_size_limit = ([0-9]+)" \
      "#  message_size_limit = \\\1\n# DepoXy: Disable the message_size_limit restriction (see below's = 0)"

- Add our custom settings to the postfix config.

  - STEPS::

      sudo bash -c 'echo "
      # Use Gmail SMTP
      #  relayhost = [smtp.gmail.com]:587
      relayhost = smtp.gmail.com:587
      # Enable SASL authentication in the Postfix SMTP client.
      smtp_sasl_auth_enable = yes
      smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
      smtp_sasl_security_options = noanonymous
      smtp_sasl_mechanism_filter = plain
      # Enable Transport Layer Security (TLS), i.e. SSL.
      smtp_use_tls = yes
      smtp_tls_security_level = encrypt
      # Remove the message_size_limit restriction (defaults 10240000)
      message_size_limit = 0
      # Location of CA certificates:
      #  smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
      # Should already be set above:
      #  tls_random_source = dev:/dev/urandom
      # Add for more trace:
      #  debug_peer_list = smtp.gmail.com
      #  debug_peer_level = 3
      " >> /etc/postfix/main.cf'

-------

STEPS: Configure your Gmail app password.

- Cache your Gmail app password.

  - STEPS: E.g.,::

      sudo bash -c 'echo "smtp.gmail.com:587 your_username@gmail.com:your_password" \
        > /etc/postfix/sasl_passwd'

- Create the hash db file for Postfix.

  - STEPS::

      # Creates /etc/postfix/sasl_passwd.db
      sudo postmap /etc/postfix/sasl_passwd

      # Restrict both files to root.
      sudo chmod 600 /etc/postfix/sasl_passwd*

- MAYBE: You may need to enable the Gmail option, "Access for less secure
  apps", otherwise you may get the error: ``SASL authentication failed``.

  - TRACK/2024-09-17: Next time I set this up from scratch, I'll check.

-------

STEPS: Configure the postfix daemon.

- Copy the postfix master ``plist`` out of System folder.

  - STEPS::

      sudo cp /System/Library/LaunchDaemons/com.apple.postfix.master.plist \
        /Library/LaunchDaemons/org.postfix.custom.plist

      sudo vim /Library/LaunchDaemons/org.postfix.custom.plist

- Change the label value from ``com.apple.postfix.master`` to ``org.postfix.custom``.

  - STEPS: Change to::

      <string>org.postfix.custom</string>

- Remove two lines to prevent exiting after 60 seconds.

  - STEPS: Remove the two lines::

      <string>-e</string>
      <string>60</string>

- Add two settings to keep service alive, and to run at load.

  - STEPS: Add these lines before ``</dict>``::

      <key>KeepAlive</key>
      <true/>
      <key>RunAtLoad</key>
      <true/>

- (Re)launch the daemon.

  - STEPS::

      sudo launchctl unload /Library/LaunchDaemons/org.postfix.custom.plist
      # If not loaded, errors:
      #   Unload failed: 5: Input/output error
      #   Try running `launchctl bootout` as root for richer errors.

      # Use launchctl to start the service.
      # - Compare to Debian:
      #   sudo /etc/init.d/postfix reload

      sudo launchctl load /Library/LaunchDaemons/org.postfix.custom.plist
      # No output

- Check that daemon has started.

  - STEPS::

      sudo launchctl list | grep org.postfix

-------

STEPS: Configure email forwarding.

- E.g.::

    echo "your_username@gmail.com" > ~/.forward

-------

USAGE:

- Test it::

    # Delivers with "To: your_username@gmail.com"
    echo "Test postfix — username@gmail.com" | mail -s "Test Postfix" your_username@gmail.com

    # Delivers with "To: $(id -un)@${MYHOSTNAME:-myhost.acme.com}"
    echo "Test postfix — $(id -un)" | mail -s "Test Postfix" $(id -un)

    # Delivers with "To: $(id -un)@${MYHOSTNAME:-myhost.acme.com}"
    echo "Test postfix — $(id -un)@${MYHOSTNAME:-myhost.acme.com}" \
      | mail -s "Test Postfix" $(id -un)@${MYHOSTNAME:-myhost.acme.com}

    # Won't be delivered if $(hostname) doesn't match 'myhostname'
    #  echo "Test postfix — $(id -un)@$(hostname)" | mail -s "Test Postfix" $(id -un)@$(hostname)
    # Won't be delivered
    #  echo "Test postfix — $(id -un)@127.0.0.1" | mail -s "Test Postfix" $(id -un)@127.0.0.1

- View mail queues::

    mail
    mailq
    sendmail -bp
    postqueue -j
    postqueue -p

    cat /var/mail/$(id -un)

    # E.g., before starting postfix:
    #   $ mailq
    #   postqueue: fatal: Queue report unavailable - mail system is down

- View mail log::

    log stream --level debug | grep mail

    tail -f /var/log/mail.log

- View delete queue::

    # Deleted mail possibly at:
    sudo tree /var/spool/postfix/defer

    # And not at:
    sudo ls -la /var/spool/mqueue/
    # which is empty.

    # Aha!
    sudo postsuper -d ALL deferred

- Show open (listening) ports (and look for port 25)::

    sudo lsof -i -P | grep -i "listen"

-------

REFER/THANX:

- *Configure postfix as relay for macOS Sierra – Sonoma*

  https://gist.github.com/loziju/66d3f024e102704ff5222e54a4bfd50e

- *How to Install Mail Server on Mac OSX*

  https://budiirawan.com/install-mail-server-mac-osx/

-------

###################################
ADHOC: DEFTS: Configure LibreOffice
###################################
.. 2024-10-02

STEPS: Disable LibreOffice *AutoCorrect*:

- LibreOffice menu bar > Tools > *AutoCorrect* > ✗ *While Typing*

- ALTLY: Tools > *AutoCorrect* > *AutoCorrect Options...* > Options:
  - ✗ *Capitalize first letter of every sentence*
  - ✗ *Correct TWo INitial CApitals*
  - Etc.

STEPS: Enable LibreOffice spell checking (underlines misspelled words):

- LibreOffice menu bar > Tools > ✓ Automatic Spell Checking

-------

##############################################
ADHOC: DFLTS: Configure *Adobe Acrobat Reader*
##############################################
.. 2024-10-07

STEPS: Adobe Acrobat menu bar > Preferences > General:

- ✗ Show offline storage when saving files

-------

UCASE: The Save As dialog is blank! (Seriously!!)

- REFER: *Blank Save As dialog box in Acrobat*

  https://helpx.adobe.com/acrobat/kb/blank-save-as-dialog-mac.html

-------

########################
⋰ ⋱ ⋰ ⋱  REFERs  ⋰ ⋱ ⋰ ⋱
########################

#############################################################################
REFER: macOS Chrome textarea motion cheatsheet (try ``<Cmd>-Arrow`` bindings)
#############################################################################
.. 2024-04-25

REFER/CXREF:

  file://~/.depoxy/ambers/docs/README-textarea-motions.rst @ 169

- Jump to the cheatsheet:

  https://github.com/DepoXy/depoxy/blob/release/docs/README-textarea-motions.rst#cheatsheet

-------

#############################################################
REFER: Use ``<Cmd-.>`` to stop MacVim grep (not ``<Ctrl-C>``)
#############################################################
.. 2024-07-17

SAVVY: Note that ``<Ctrl-C>`` in macOS MacVim won't stop long-running grep
(or cancel any long-running command) like it does in terminal Vim, or
on Linux (where ``<Ctrl-C>`` works in both GVim and command line vim).

- SAVVY: You must use (non-remappable) ``<Cmd-.>`` to stop system calls in MacVim.

- REFER: From ``:h macvim-shortcuts``::

    Cmd-.   Interrupt Vim.              *Cmd-.* *<D-.>*

            Unlike Ctrl-C which is sent as normal keyboard input
            (and hence has to be received and then interpreted)
            this sends a SIGINT signal to the Vim process.

            This Cmd-key combination cannot be unmapped.

- I think this is the only MacVim binding you cannot change. So remember it well!

-------

################################################################
REFER: Use ``<Shift-Cmd-.>`` in open dialog to view hidden files
################################################################
.. 2024-10-10

SAVVY: Even if there's no context menu or other option to show hidden files,
``<Shift-Cmd-Period>`` should always show hidden files in an open dialog.

-------

################################################################
REFER: Use ``log stream`` to view ``sshd`` and other system logs
################################################################
.. 2024-04-14

CPYST: Run ``log stream`` to view macOS system logs, e.g.::

  log stream --level debug | grep ssh

REFER: https://stackoverflow.com/questions/43382825/where-to-find-sshd-logs-on-macos-sierra

- BEGER: https://www.google.com/search?q=macos+ssh+auth+log

-------

###############################################################
REFER: ``<Command-Alt-Escape>`` brings up macOS Force-Quit menu
###############################################################
.. 2024-09-18

SAVVY: ``<Command-Alt-Escape>`` brings up macOS Force-Quit menu.

-------

############################
⋰ ⋱ ⋰ ⋱  *All done*  ⋰ ⋱ ⋰ ⋱
############################

*Thanks for reading!* 🦘

💪

