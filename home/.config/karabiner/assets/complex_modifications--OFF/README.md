Retired of Karabiner-Elements Modifications
===========================================

## JSON FILES

### Chrome/iTerm2 binding

  - [0175-depoxy-apphoc-ctl-hyp-2-cmd-hyp.json](0175-depoxy-apphoc-ctl-hyp-2-cmd-hyp.json)

    - #0176 — Chrome/iTerm2 — Remap <Ctrl--> → <Cmd--> (to Zoom Out)

      Not sure why this used to be necessary (or if it was), but
      you can remap "Zoom In", "Zoom Out", and "Actual Size" using
      ``defaults`` and the ``NSUserKeyEquivalents`` key

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
      userscript

### Chrome bindings

  - [0320-applcn-chrome-calendar.json](complex_modifications/0320-applcn-chrome-calendar.json)

    - *#0321 — Chrome — Systemwide — 'Calendar' tab — Foreground (Shift-Ctrl-Cmd-D)*

      Systemwide: &lt;`Shift-Ctrl-Cmd-D`&gt; brings Chrome 'Calendar' tab to front

### Outlook bindings

  - [0430-depoxy-outlook-or-tab.json](0430-depoxy-outlook-or-tab.json)

    - *#0431.a — Google Chrome — Systemwide — 'Mail' tab — Foreground (Shift-Ctrl-Cmd-A)*

      Systemwide: &lt;`Shift-Ctrl-Cmd-A`&gt; brings Chrome 'Mail' tab to foreground

### Systemwide window resizer

  - [0610-curapp-wilson-resizer.json](0610-curapp-wilson-resizer.json)

    - *#0611 — Curr Appl — Resize and Position Almost Fully — (Shift-Ctrl-Alt-R)*

### Bindings that were moved to `skhdrc`:

  - [1210-depoxy-misc-charms.json](1210-depoxy-misc-charms.json)

    - <Cmd-u> opens Unicode/Emojis lookup in GVim

    - <Cmd-d> foregrounds Dob development terminal window

    - <Cmd--> puts date in clipboard

    - <Cmd-p> opens PowerThesaurus in Chrome

  - [9110-devlpr-docs-launchers.json](9110-devlpr-docs-launchers.json)

    - <Cmd-e> opens Vendor backlog file in GVim

    - <Ctrl-Cmd-e> opens Vendor woodlot file in GVim

  - [chrome-wip-new-window.json](chrome-wip-new-window.json)

    - <Cmd-t> opens new Chrome window

### Broken (probably never worked) modifications:

  - [0140-systemwide-alt-space-n-minimize.json](0140-systemwide-alt-space-n-minimize.json)

    - Was trying to map <Alt-Space+N> to minimize, like Linux

  - [0190-system-alt-spce-n-min.json](0190-system-alt-spce-n-min.json)

    - Compromised on <Ctrl-Alt-M> to minimize window, but most
      apps minimize on <Cmd-N>, so not more convenient

    - Also some other test modifications author used while learning
      Karabiner Elements (I think)

### Chrome bindings

  - [chrome-wip-button1-fail.json](chrome-wip-button1-fail.json)

    - Remaps <Ctrl-Click> to <Cmd-Click>, but duplicates Karabiner Elephants modification

  - [chrome-wip-edit-commands.json](chrome-wip-edit-commands.json)

    - Remaps <Ctrl>-edit bindings to <Cmd>-edit bindings

    - Specifically, <Ctrl-X>, <Ctrl-C>, <Ctrl-V>, <Ctrl-A>

    - These are now remapped system-wide by Karabiner Elements modifications

  - [chrome-wip-swap-cmd-ctrl.json](chrome-wip-swap-cmd-ctrl.json)

    - Swaps <Cmd> and <Ctrl> keys, but it remaps bindings you probably
      don't want swapped. It's better to just remap those specific
      <Cmd-key>/<Ctrl-key> bindings that you care about

  - [example-ke-vi-mode.json](example-ke-vi-mode.json)

    - Something about `vi_mode`. I don't remember what this was suppose
      to do.

