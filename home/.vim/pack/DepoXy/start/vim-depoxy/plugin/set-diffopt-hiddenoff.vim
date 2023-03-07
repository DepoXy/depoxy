" set diffopt+=hiddenoff, and a hyper comment.
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2020 Landon Bouma.

" ########################################################################

" DEV: Uncomment the 'unlet', then <F9> to reload this file.
"       https://github.com/landonb/vim-source-reloader
"  silent! unlet g:loaded_set_diffopt_hiddenoff

if exists("g:loaded_set_diffopt_hiddenoff") || &cp
  finish
endif
let g:loaded_set_diffopt_hiddenoff = 1

" ########################################################################

" One dev's :Gdiffsplit discovery story...
"
" 2021-02-16: Since having fixed the diff colors in dubs_after_dark
" yesterday, and since having learned Vimdiff by way of vim-mergetool,
" also yesterday, I instinctively reached for `:Gdiffsplit {commit}:%`
" when I wanted to extract bits from a WIP branch to make a feature
" branch to PR. Specifically, I had a WIP version of a file, with lots
" of trace statements and a few debugger breakpoints, but also with the
" solution to the problem I'd been tackling. So I made a new feature
" branch from trunk, and used :Gdiffsplit so that I could grab just the
" few lines of code that I needed after an afternoon of investigating.
" What a quick, easy way to turn a mess of code into a PR masterpiece!
" (Before this, I'd usually run `git diff` in the terminal and clean out
" my development code. Or, I'd copy the file, and `git checkout -- {file}`
" the version from HEAD, then use meld to pull changes from the copy. So
" tedious! I love this new method!!)

" USAGE:
"
"   1 Close all but one file window (or make enough room so :Vimdiff
"     opens vertically, if that's your preference):
"       <Alt-w c>, :q, or <Ctrl-w c>, to name a few.
"   2 Open the file you want to diff.
"       :e ...
"   3 Start the diff, passing the {commit} reference to diff against:
"       :Gdiffsplit {commit}:%
"   4 I like to diff right to left, but Vimdiff opens the newer file
"     on the right, so I prefer to swap the two windows:
"       Ctrl-w x (swap windows)
"
" - That sets up a diff with the working file on the left,
"   and the file version at {commit} on the right.
" - The cursor will be on the left,
"   and you can type `do` to diff-obtain hunks.
" - Close either file (hiddenoff) or
"   close either window (closeoff) to
"   end the diff, or run `:diffoff`.

" Other :Gdiffsplit variants (that I haven't had a use for):
"
"   :Gdiffsplit! {object}  Like :Gdiffsplit, but keeps focus on current window.
"   :Gvdiffsplit [object]  Like :Gdiffsplit, but always splits vertically.

" Some interesting options (also the defaults):
"
"   internal  Use the internal diff library. [Default]
"   filler    Shows filler lines. Keeps text synchronized btw. windows.
"             Useful with scrollbind. [Default]
"   closeoff  Calls :diffoff in last window if others all closed. [Default]
"
"   hiddenoff Do not use diff mode for a buffer when it becomes hidden.
"
"   context:{n}     Show {n} lines between changes and folds Defaults 6.
"   foldcolumn:{n}  Sets 'foldcolumn' to {n} when starting diff mode. D's 2.
"
"   horizontal  Start diff mode with horizontal splits.
"   vertical    Start diff mode with vertical splits.
"
" Note that forcing 'vertical' or 'horizontal' is generally unnecessary
" because vimdiff prefers 'vertical' when there's enough room, which is
" probably your preference, too (no offense if not, I've just never met
" a horizontal differ).
"
" These other option Might be handy sometimes (opt-in/ad-hoc):
"
"   iblank    Ignore changes where lines are all blank.
"   icase     Ignore changes in case of text.
"   iwhite    Ignore changes in amount of white space.
"   iwhiteall Ignore all white space changes.
"   iwhiteeol Ignore white space changes at end of line.

" Default options:
"
"   set diffopt=internal,filler,closeoff
"
" 2021-02-16: I like the hiddenoff option for stopping the diff. I use two
" windows side-by-side normally while developing, so closeoff is not not
" as useful to me -- I'd rather use run `:diffoff`. But hiddenoff makes it
" even easier -- just close either file under diff, and it's all over!
set diffopt+=hiddenoff

" ########################################################################

