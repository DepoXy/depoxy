Parade of Karabiner-Elements Modifications
==========================================

## SEE ALSO

  - CXREF:

      /kit/working/mOS/Karabiner-Elephants/README.md

## JSON FILES

### Chrome bindings

  - [0310-depoxy-chrome.json](0310-depoxy-chrome.json)

    Chrome-specific bindings.

    - *#0311.y — Google Chrome — New Window (Cmd-y)*

      Systemwide: &lt;`Cmd-y`&gt; opens new Chrome window

    - *#0313 — Google Chrome — Systemwide — *Inspect* Window Foreground (Cmd-r) *ALT MAPPING**

      Systemwide: &lt;`Cmd-r`&gt; fronts any Chrome window running DevTools

    - *#0318 — Google Chrome — Customize Ctrl-PageUp/PageDown (originally cycles tabs, just like Ctrl-Tab/Ctrl-Shift-Tab; but we want textarea motion userscript to process)*

      Chrome: Forwards &lt;`Left-Ctrl-PageUp`&gt; → &lt;`Left-Alt-PageUp`&gt;

      Chrome: Forwards &lt;`Left-Ctrl-PageDown`&gt; → &lt;`Left-Alt-PageDown`&gt;

      Used by https://github.com/DepoXy/pampermonkey#💆 Tampermonkey `textarea`
      userscript.

### Chrome bindings

  - [0320-applcn-chrome-calendar.json](complex_modifications/0320-applcn-chrome-calendar.json)

    - *#0321 — Chrome — Systemwide — 'Calendar' tab — Foreground (Shift-Ctrl-Cmd-D)*

      Systemwide: &lt;`Shift-Ctrl-Cmd-D`&gt; brings Chrome 'Calendar' tab to front

### Outlook bindings

  - [0430-depoxy-outlook-or-tab.json](0430-depoxy-outlook-or-tab.json)

    - *#0431.a — Google Chrome — Systemwide — 'Mail' tab — Foreground (Shift-Ctrl-Cmd-A)*

      Systemwide: &lt;`Shift-Ctrl-Cmd-A`&gt; brings Chrome 'Mail' tab to foreground

### Teams/Webex/Zoom foregrounder

  - [0510-depoxy-webex-teams-zoom.json](0510-depoxy-webex-teams-zoom.json)

    - *#0511.a — Teams/Webex/Zoom — Systemwide — Foreground (Shift-Ctrl-Cmd-W)*

      Systemwide: &lt;`Shift-Ctrl-Cmd-W`&gt; brings Teams/Webex/Zoom to foreground

### Systemwide window resizer

  - [0610-curapp-wilson-resizer.json](0610-curapp-wilson-resizer.json)

    - *#0611 — Curr Appl — Resize and Position Almost Fully — (Shift-Ctrl-Alt-R)*

