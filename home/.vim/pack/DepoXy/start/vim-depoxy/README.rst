###############################
Vim Plugin |em_dash| Vim-DepoXy
###############################

.. |em_dash| unicode:: 0x2014 .. em dash

About This Plugin
=================

This plugin configures Vim plugins specially for the DepoXy
development environment.

Configure FZF
=============

Wires ``junegunn``'s ``fzf.vim`` plugin into the DepoXy Ambers experience,
and sets a few commands, such as ``FZF`` and ``F``.

Configure NERD Commenter
========================

Sets NERD Commenter options just the way we want.

Installation
============

This plugin is installed by DepoXy.

``async-mode-maps-gf-gW-3t.vim``
================================

===========================  ============================  ==============================================================================
 Key Mapping                  Description                   Notes
===========================  ============================  ==============================================================================
 ``gf``                       Open file under cursor        When in insert mode, ``gf`` opens the file path under the cursor,
                              or selected                   or when text is selected, opens the file path for editing.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``gW``                       Open URL under cursor         When in insert mode, ``gW`` opens the URL under the cursor,
                              or selected                   or when text is selected, opens the text as a URL in the browser.
---------------------------  ----------------------------  ------------------------------------------------------------------------------
 ``3t``                       Insert today's date           Insert #-delimited reST header titled with time, e.g.,::

			                                                        ################
			                                                        YYYY-MM-DD HH-MM
			                                                        ################

			                                                      Because implemented using async mode mapper,
			                                                      completes immediately upon typing `3t`, if
			                                                      you type both characters within 100 msec.

===========================  ============================  ==============================================================================


