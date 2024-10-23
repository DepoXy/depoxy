@@@@@@@@@@@@@@@@@@@@@@
GeekTool geeklet setup
@@@@@@@@@@@@@@@@@@@@@@

REFER:

- *GeekTool*

  https://www.tynsoe.org/geektool/

- *GeekTool Documentation*

  https://www.tynsoe.org/geektool/documentation/

-------

SETUP:

- Create 1 Shell geeklet for the clock time, to stand in for the menu bar
  clock when the menu bar is hidden:

  - Name: ``MENU_DATE``

  - Command::

       date '+%a %Y-%m-%d %H:%M'

  - Refresh every: 1 s.

  - Font and style:

    - Font:

      - English > *Skia* > Bold > 18 pt

        - It should fit under auto-hiding menu bar.

    - Color: Whitish

      - To set, click where it says *Click here to set font & color...*.

      - Grayscale slider color > 87% brightness

        - Click the left button, which looks like its for background color,
          (at least to me). The button on its right looks like font color
          icon. The both seem to affect the font color similarly, though.

    - Set the text center-aligned and then position the window.

       - (I tried right-aligned, but even with spaces at the end, the last
         character from the clock was clipped by the *GeekTool* window.)

  - Position: Place the geeklet in the upper-right of the display, where
    the macOS menubar clock appears when the menubar is visible.

- SAVVY: Use a Hammerspoon *Spoon* to temporarily show an on-demand clock
  on top of your display.

  - Press ``<Ctrl-Alt-C>`` to show the Hammerspoon ``AClock`` clock,
    which appears centered on your screen atop everything else.

  - REFER:

    https://github.com/DepoXy/macOS-Hammyspoony/blob/1.2.6/.hammerspoon/init.lua#L578-L591

    - The keybinding definition can be found locally (within a DepoXy environment) at::

      ~/.kit/mOS/macOS-Hammyspoony/.hammerspoon/init.lua

-------

SETUP:

- Create 1 Shell geeklet for weather, to the left of the "menubar" clock.

  - Menu bar weather

    - Name: ``MENU_WX``

    - Command::

        /Users/user/.depoxy/running/bin/weather-mpls

    - Refresh every: 900 s.

    - Font and style:

      - Font:

        - English > *Skia* > Regular > 18 pt

          - Make the same size as the clock, but not bold.

      - Color: Same 87% Grayscale slider color as ``MENU_DATE``.

      - Setup: Right-aligned, with its right edge positioned
        just left of the clock.

    - CXREF: See also the weather script that ``weather-mpls`` calls:

      https://github.com/DepoXy/depoxy/blob/1.3.1/bin/weather.sh

      - Found locally at::

        ~/.depoxy/ambers/bin/weather.sh

- SAVVY: Press ``<Shift-Ctrl-Alt-C>`` to show the Notification Center,
  which has a weather forecast widget — at least if you setup the
  Notification Center as recommended by the macOS ONBRD document:

  https://github.com/DepoXy/depoxy/blob/1.3.1/docs/README-macOS-onboarding.rst#onbrd-configure-notification-center-add-and-remove-widgets

  - Found locally at::

    ~/.depoxy/ambers/docs/README-macOS-onboarding.rst @ 2411

-------

- SAVVY: You can ``<Ctrl-Alt-D>`` show-desktop to more easily move geeklet widgets around.

  - SAVVY: Or ``<Shift-Ctrl-Cmd-W>`` to hide all windows (as wired by *Hammyspoony*).

- SAVVY: Use the eyedropper to match the second widget font color to the first widget.

- SAVVY: On Quit, choose ["No, Never Ask"] when asked if GeekTool should disable itself.

- BWARE: I think GeekTool geeklets disappear after OS update (at least hours
  after updating 14.4.1 -> 14.5 author noticed geeklets were missing)

-------

That's it! Have fun *geeking out!!* 🤓

