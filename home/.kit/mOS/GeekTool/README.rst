@@@@@@@@@@@@@@@@@@@@@@
GeekTool geeklet setup
@@@@@@@@@@@@@@@@@@@@@@

CXREF: https://www.tynsoe.org/geektool/
https://www.tynsoe.org/geektool/documentation/

-------

- Create 2 *Shell* geeklets, one to stand in for the menu bar clock
  when the menu bar is hidden, and another centered on the desktop:

  - Names: ``MENU_DATE`` | ``CTRD_DATE``

  - Command::

       date '+%a %Y-%m-%d %H:%M'

  - Refresh every: 1 s.

  - Font and style:

    - For: ``MENU_DATE``:
      - Font:
        - English > *Skia* > Bold > 18 pt
          Should fit under auto-hiding menu bar
      - Color: Whitish
        - ~~Or maybe light gray, e.g., #D9D9D9.~~
        - To set, click where it says *Click here to set font & color...*.
        - ~~To set hex, click the color square, then click the Sliders icon,~~
          ~~then choose *RGB Sliders* from the dropdown.~~
        - Grayscale slider color > 87% brightness
          (click the left button, which looks like its for background color,
           I'd guess. The button on its right looks like font color icon.
           The both seem to affect the font color similarly, though)

    - For: ``CTRD_DATE``:
      - Font:
        ~~*Herculanum* 36pt mid-Green, #007F00.~~
        English > *Hack Nerd Font* > Regular > 30 pt
      - Color: Same 87% Grayscale slider color as ``MENU_DATE``

    - I set text center-aligned, and then positioned the window.
       - I tried right-aligned, but even with spaces at the end, the last
         character from the clock was clipped by the *GeekTool* window.

  - Setup: ``MENU_DATE``: Position upper-right, where the macOS menubar
    clock appears when the menubar is visible.

  - Setup: ``CTRD_DATE``: You wanna know the time but can't see it.
    - The geeklet lets you show-desktop, read time, and un-show desktop
      to resume work.
    - Configure similarly to menu bar clock, but center this widget on
      the desktop, so that you can see if when you look straight ahead.

- SAVVY: Press <Ctrl-Alt-C> to show the Hammerspoon ``AClock`` clock,
  which appears centered on your screen atop everything else.

-------

- Create 1 more geeklet for weather, to the left of the "menubar" clock.

  - Menu bar weather

    - Name: ``MENU_WX``

    - Command:

        /Users/user/.depoxy/running/bin/weather-mpls

    - Refresh every: 900 s.

    - Font and style:

      - Font:
        - English > *Skia* > Regular > 18 pt
          Same size as clock but not bold
      - Color: Same 87% Grayscale slider color as ``MENU_DATE``
      - Setup: Right-aligned, with its right edge positioned
        just left of the clock

    - CXREF: See also the weather script that ``weather-mpls`` calls:
      ~/.depoxy/ambers/bin/weather.sh

- SAVVY: Press <Shift-Ctrl-Alt-C> to show the Notification Center,
  which has a weather forecast widget — at least if you setup the
  Notification Center as recommended by the macOS ONBRD document:

  ~/.depoxy/ambers/docs/README-macOS-onboarding.rst @ 2411

-------

- SAVVY: You can <Ctrl-Alt-D> show-desktop to more easily move geeklet widgets around.
  - SAVVY: Or <Shift-Ctrl-Cmd-W> to hide all windows.

- SAVVY: Use the eyedropper to match the second widget font color to the first widget.

- SAVVY: On Quit, choose ["No, Never Ask"] when asked if GeekTool should disable itself.

- BWARE: I think GeekTool geeklets disappear after OS update (at least hours after
         updating 14.4.1 -> 14.5 author noticed geeklets are missing)

-------

