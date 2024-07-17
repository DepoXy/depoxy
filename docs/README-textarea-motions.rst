@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
macOS ``textarea`` motion bindings
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.. Jump to the cheatsheet:

  https://github.com/DepoXy/depoxy/blob/release/docs/README-textarea-motions.rst#cheatsheet

########
Overview
########

On macOS, the Chrome ``textarea`` motions for moving the cursor
and selecting text are not quite the same as on Linux.

- This document describes those bindings.

- The author had originally tried a
  `Tampermonkey <https://www.tampermonkey.net/>`__
  *userscript* to make the motions more like Linux,
  but just learning the built-in bindings is better:

  - Tampermonkey adds a security risk I'd rather not
    worry about.

  - Setting up Tampermonkey is a little tedious, and
    not entirely automatable.

  - Given that DepoXy sets up macOS almost identical
    to Linux (Mint MATE), it's not a big deal if just
    this one feature is slightly different between the
    two OSes.

#####
Setup
#####

The bindings below assume you've used
`Karabiner-Elements <https://karabiner-elements.pqrs.org/>`__
(KE) to swap ``<Ctrl-Right>`` and ``<Ctrl-Left>``
with ``<Alt-Right>`` and ``<Alt-Left>``, so
that these bindings are at least *more* like
they work on Linux.

- See:

  https://github.com/DepoXy/Karabiner-Elephants/blob/release/complex_modifications/0170-apphoc-ctl-and-alt-lr.json

  Which you can find in a DepoXy environment at::

    ~/.kit/mOS/Karabiner-Elephants/complex_modifications/0170-apphoc-ctl-and-alt-lr.json

  Provided by 
  `Karabiner-Elephants <https://github.com/DepoXy/Karabiner-Elephants#🐘>`__

########
Bindings
########

(Jump below to the cheatsheet_ for a quick reference.)

- You can use ``<Cmd-Up>`` and ``<Cmd-Down>`` on macOS to
  jump to the start and end of a ``textarea`` without also
  scrolling the whole page!

  - Well, the page may scroll a little so that the whole
    ``textarea`` is in view.

  - On Linux, the author is used to using ``<Ctrl-Home>`` and
    ``<Ctrl-End>`` instead. But on macOS, pressing ``<Ctrl-Home>``
    or ``<Ctrl-End>`` (or just ``<Home>`` or ``<End>``) scrolls
    the ``textarea`` but doesn't move the cursor (and will eventually
    scroll the page, possibly scrolling the ``textarea`` out of view,
    if you press again).

    - This is one annoying behavior the author wants to avoid
      (and why I created this document).

- You can use ``<Cmd-Right>`` and ``<Cmd-Left>`` to
  jump to the start and end of a line in an input box or
  text area.

  - Also ``<Alt-Right>`` and ``<Alt-Left>`` do the same.

  - On Linux, you can use ``<Home>`` and ``<End>`` to move
    the cursor to the start or end of the line. But on macOS,
    ``<Home>`` and ``<End>`` don't move the cursor; they scroll
    the ``textarea`` if it has focus, and then the window, or
    they'll just scroll the window if a single-line input field
    has focus.

    - This is another annoying behavior the author wants to avoid.

  .. In normal macOS: ``<Ctrl-Right>`` and ``<Ctrl-Left>``
     do the same, not ``<Alt-Right>`` and ``<Alt-Left>``.

  .. SAVVY: reST comments highlight default macOS bindings.

     - DepoXy swaps <Ctrl-Right>/<Ctrl-Left> and
       <Alt-Right>/<Alt-Left> to match Linux bindings.

    - See the author's Karabiner Elements modifications
      that remap macOS bindings to be more like Linux:

        https://github.com/DepoXy/Karabiner-Elephants#🐘

- Though note if the cursor is *not* in an input field,
  ``<Cmd-Up>`` and ``<Cmd-Down>`` *will* scroll the page to
  the bottom or top.

  - And ``<Cmd-Right>`` and ``<Cmd-Left>`` will navigate history
    (change the URL). Also ``<Alt-Right>`` and ``<Alt-Left>``
    (like Linux, assuming you're enabled the KE modifications
    mentioned above).

    .. In normal macOS: It's ``<Ctrl-Right>`` and ``<Ctrl-Left>``
       instead of ``<Alt-Right>`` and ``<Alt-Left>``

- In Chrome on macOS, ``<PageUp>`` and ``<PageDown>`` scroll the
  text area first, then the screen, and don't move the cursor at all.

  - This is the third annoying behavior the author wants to avoid.

    - On Linux, ``<PageUp>`` and ``<PageDown>`` only move the cursor
      when the input has focus.

  - So you still might be caught off-guard using ``<PageUp>`` and
    ``<PageDown>`` (especially if you're used to Linux behavior).

  - However, ``<Alt-PageUp>`` and ``<Alt-PageDown>`` move
    the cursor by the page-ful.

    - But those bindings also scroll the window slightly, too.

      - And at the top of bottom of the text area, those bindings
        will then scroll the whole page.

    - Oh well, can't win 'em all, I suppose.

  - (As an aside: ``<Ctrl-PageUp>`` and ``<Ctrl-PageDown>``
    change tabs backwards and forwards.)

- To select by the page-ful, use ``<Shift-PageUp>`` and
  ``<Shift-PageDown>``.

  - Thankfully, these won't scroll the window if you press again after
    the cursor reaches the top or the bottom of the text area.

  - (As an aside: ``<Shift-Alt-PageUp>`` and ``<Shift-Alt-PageDown>``
    work like normal ``<Alt-PageUp>`` and ``<Alt-PageDown>``, i.e., without
    selecting text. And ``<Shift-Ctrl-PageUp>`` and ``<Shift-Ctrl-PageDown>``
    *move* the current Chrome tab backwards and forwards in the tab list.)

  - You can also use ``<Shift-Cmd-Up>`` and ``<Shift-Cmd-Down>``
    to similarly select all text from the cursor to the top or
    bottom of the document without scrolling the window once
    the cursor reaches the top or bottom of the input area.
    (And if you want to select all text, use one, then the
    other; though ``<Cmd-A>`` does the same in half the strokes.)

- In the author's experience (as a developer), it's
  really only writing, editing, and replying to
  GitHub PRs that I use text areas in Chrome.

  - And oftentimes I'll prepare text in my favorite text
    editor first, and then I'll paste to the text area.

##########
Cheatsheet
##########

.. MAYBE: If you need a better cheatsheet, consider making a table.

- To move the cursor by the page-ful, use::

    <Alt-PageUp>
    <Alt-PageDown>

  Or::

    <Shift-Alt-PageUp>
    <Shift-Alt-PageDown>

- To select text by the page-ful, use::

    <Shift-PageUp>
    <Shift-PageDown>

- To move the cursor to the top or bottom of the input area, use::

    <Cmd-Up>
    <Cmd-Down>

- To select text to the top or bottom of the input area, use::

    <Shift-Cmd-Up>
    <Shift-Cmd-Down>

- To move the cursor to the start of end of a line, use::

    <Cmd-Left>
    <Cmd-Right>

  Or::

    <Alt-Left>
    <Alt-Right>

- To select text to the start of end of a line, use::

    <Shift-Cmd-Left>
    <Shift-Cmd-Right>

  Or::

    <Shift-Alt-Left>
    <Shift-Alt-Right>

- To move the cursor one word left or right, use::

    <Ctrl-Left>
    <Ctrl-Right>

- To select the word to the left or right, use::

    <Shift-Ctrl-Left>
    <Shift-Ctrl-Right>

- To change tabs backwards or forwards, use::

    <Ctrl-PageUp>
    <Ctrl-PageDown>

- To move the current tab backwards or forwards, use::

    <Shift-Ctrl-PageUp>
    <Shift-Ctrl-PageDown>

- Note that ``<Alt>`` is probably ``<Option>`` to most users,
  but the author is more familiar with Linux and doesn't have
  an Apple keyboard. (So I call it ``<Alt>``.)

.. In normal macOS (* Starred items are different than normal macOS bindings):

  - To move the cursor by the page, use::

      <Alt-PageUp>
      <Alt-PageDown>

    Or::

      <Shift-Alt-PageUp>
      <Shift-Alt-PageDown>

  - To select text by the page-ful, use::

      <Shift-PageUp>
      <Shift-PageDown>

  - To move the cursor to the top or bottom of the input area, use::

      <Cmd-Up>
      <Cmd-Down>

  - To select text to the top or bottom of the input area, use::

      <Shift-Cmd-Up>
      <Shift-Cmd-Down>

  - To move the cursor to the start of end of a line, use::

      <Cmd-Left>
      <Cmd-Right>

    Or::

      * <Ctrl-Left>
      * <Ctrl-Right>

  - To select text to the start of end of a line, use::

      <Shift-Cmd-Left>
      <Shift-Cmd-Right>

    Or::

      * <Shift-Ctrl-Left>
      * <Shift-Ctrl-Right>

  - To move the cursor one word left or right, use::

      * <Alt-Left>
      * <Alt-Right>

  - To select the word to the left or right, use::

      * <Shift-Alt-Left>
      * <Shift-Alt-Right>

  - To change tabs backwards or forwards, use::

      <Ctrl-PageUp>
      <Ctrl-PageDown>

  - To move the current tab backwards or forwards, use::

      <Shift-Ctrl-PageUp>
      <Shift-Ctrl-PageDown>

#####
Legal
#####

Tampermonkey® is a registered trademark of Jan Biniok.
https://tsdr.uspto.gov/#caseNumber=79186543&caseSearchType=US_APPLICATION&caseType=DEFAULT&searchType=statusSearch

