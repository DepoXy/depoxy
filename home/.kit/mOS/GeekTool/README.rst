@@@@@@@@@@@@@@@@@@@@@@
GeekTool geeklet setup
@@@@@@@@@@@@@@@@@@@@@@

CXREF: https://www.tynsoe.org/geektool/
https://www.tynsoe.org/geektool/documentation/

- Create 2 *Shell* geeklets, one to stand in for the menu bar clock
  when the menu bar is hidden, and another centered on the desktop:

  - Name: MENU_DATE | CTRD_DATE

  - Command::

       date '+%a %Y-%m-%d %H:%M'

  - Refresh every: 1 s.

  - Font and style:

    - MENU_DATE:
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

    - CTRD_DATE:
      - Font:
        ~~*Herculanum* 36pt mid-Green, #007F00.~~
        English > *Hack Nerd Font* > Regular > 30 pt
      - Color: Same 87% Grayscale slider color as MENU_DATE

    - I set text center-aligned, and then positioned the window.
       - I tried right-aligned, but even with spaces at the end, the last
         character from the clock was clipped by the *GeekTool* window.

  - Setup: MENU_DATE: Position upper-right, where macOS menubar clock appears when showing.

  - Setup: CTRD_DATE: You wanna know the time but can't see it.
    - The geeklet lets you show-desktop, read time, and un-show desktop to resume work.
    - Configure similarly to menu bar clock, but center this widget on the desktop,
      so that you can see if when you look straight ahead.

- Create 2 more geeklets for weather, on to the left of the menu clock,
  and one centered below the middle-desktop clock.

  - Menu bar weather

    - Name: MENU_Wttr.in

    - Command::

         /Users/user/.depoxy/stints/2417/bin/weather-mpls

    - Refresh every: 900 s.

    - Font and style:

      - MENU_Wttr.in:
        - Font:
          - English > *Skia* > Regular > 18 pt
            Same size as clock but not bold
            (I think I bolded clock because wttr.in uses emoji,
            which are large, so well complemented by bold font)
        - Color: Same 87% Grayscale slider color as MENU_DATE
        - Setup: Right-aligned, with its right edge positioned
          just left of the clock

  - Desktop weather

    - Name: CTRD_Wttr.in

    - Command::

         ~/.depoxy/stints/2417/bin/time-and-weather-mpls

    - Refresh every: 900 s.

    - Font and style:

      - CTRD_Wttr.in:
        - Font:
          - English > *Hack Nerd Font* > Regular > 18 pt
            Same font but about 2/3 the size of the clock
        - Color: Same 87% Grayscale slider color as MENU_DATE
        - Setup: Centered, position centered and below the clock
          with a nice healthy tall line break

- SAVVY: You can Ctrl-Alt-D show-desktop to more easily move geeklet widgets around.
  - SAVVY: Or Shift-Ctrl-Cmd-W to hide all windows.

- SAVVY: Use the eyedropper to match the second widget font color to the first widget.

- SAVVY: On Quit, choose \"No, Never Ask\" when asked if GeekTool should disable itself.

- BWARE: I think GeekTool geeklets disappear after OS update (at least hours after
         updating 14.4.1 -> 14.5 author notices geeklets are missing)

