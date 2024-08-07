" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2024 Landon Bouma.

" ########################################################################

" DEV: Uncomment the 'unlet', then <F9> to reload this file.
"       https://github.com/landonb/vim-source-reloader
"  silent! unlet g:loaded_after_vim_minimal_sometimes

if exists("g:loaded_after_vim_minimal_sometimes") || &cp
  finish
endif
let g:loaded_after_vim_minimal_sometimes = 1

" ########################################################################

" Determine if Vim running as EDITOR for specific commands,
" and wire fast <Ctrl-S> save-and-quit (e.g., :wq).
"
" - This tediously checks the grand-parent command and args
"   to determine the situation.
"
" SAVVY: Note there's a much simpler solution if you can use
" an environ, e.g.,
"
"   $ VIM_EDIT_JUICE_EXIT_ON_SAVE=1 vim
"
" will wire the same <C-s> bindings you see below.
"
" - CXREF: You'll find the easier solution wired in dubs_edit_juice:
"
"   ~/.vim/pack/landonb/start/dubs_edit_juice/after/plugin/dubs_after_juice.vim
"
" - MAYBE/2024-08-07: We could remove this plugin if we devise an
"   environ approach for `dob edit`.
"
"   - We could write a dob() function in Bash to capture and
"     preprocess calls to it.
"
"     - See `cis_pass` for a single wrapper that sets
"       VIM_EDIT_JUICE_EXIT_ON_SAVE=1 for the `pass edit` command:
"
"       ~/.depoxy/stints/1509/home/.kit/sh/home-fries/.bashrc-bin/bashrc.private.pass-edit.sh
"
"   - But this Vim plugin works just as well, I'd say. (Unless there's
"     a performance issue with it on load (doubt it), might as well
"     keep it....)

" SAVVY: Note the system() call itself runs in a subprocess, so `$$`
" within system() is not the Vim process. The Vim process is `$PPID`.
"
" That said, here are some of the process trees you might see:
"
" - Vim process ('system()' parent process) is always MacVim:
"   - MacVim.app: /Applications/MacVim.app/Contents/MacOS/Vim
"   - Terminal `vim`: /Applications/MacVim.app/Contents/MacOS/Vim
"   - Command `pass edit`: /Applications/MacVim.app/Contents/MacOS/Vim -c startinsert ...
"
"   echom system('ps -o command= -p ${PPID}')
"
" - Vim parent process ('system()' grand-parent) varies by context, e.g.:
"   - MacVim parent: /sbin/launchd (aka PID 1)
"   - Terminal `vim` parent: /opt/homebrew/bin/bash
"   - `pass edit` parent: bash /Users/user/.kit/sh/home-fries/bin/editor-vim-0-0-insert \
"       /var/folders/4r/vs_plqd91h9dclfh5c020cdh0000gn/T//pass.fS3PYHKq1ZkXu/70KsFD-foo-bar.rst
"
"   echom system('gpid="$(ps -o ppid= -p ${PPID} | tr -d " ")" ; ps -o command= -p ${gpid}')
"
" - Finally, the Vim grand-parent ('system()' g/g/p) tells us the app calling Vim, e.g.:
"   - MacVim g/p: Nothing
"   - `vim` g/p: /opt/homebrew/bin/bash
"   - `pass edit` g/p: bash /Users/user/.local/bin/pass edit --ext=rst zyx/foo
"
"   echom system('
"     \ gpid="$(ps -o ppid= -p ${PPID} | tr -d " ")" ;
"     \ ggpid="$(ps -o ppid= -p ${gpid} | tr -d " ")" ;
"     \ ps -o command= -p ${ggpid}
"     \ ')

function! s:MapCtrlSSaveAndExitForSpecialApps()
  " Check if `dob edit` or `pass edit` is grand-parent process.
  call system('
    \ gpid="$(ps -o ppid= -p ${PPID} | tr -d " ")";
    \ ggpid="$(ps -o ppid= -p ${gpid} | tr -d " ")";
    \ ps -o command= -p ${ggpid} | grep -q -e "^bash .*\/pass edit " \
    \   || ps -o command= -p ${ggpid} | grep -q -e "\/python .*\/dob edit$";
    \ ')

  if !v:shell_error
    " Ctrl-s to save and exit from any mode.
    noremap <C-s> :wq<CR>
    vnoremap <C-s> <Esc>:wq<CR>
    inoremap <C-s> <Esc>:wq<CR>
  endif
endfunction

call s:MapCtrlSSaveAndExitForSpecialApps()

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "

