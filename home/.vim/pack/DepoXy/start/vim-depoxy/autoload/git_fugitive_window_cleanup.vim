" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2023 Landon Bouma.

" -------------------------------------------------------------------

if exists("g:autoloaded_vim_depoxy_git_fugitive_window_cleanup")
  finish
endif
let g:autoloaded_vim_depoxy_git_fugitive_window_cleanup = 1

" -------------------------------------------------------------------

function! git_fugitive_window_cleanup#close_git_windows() abort
  let l:orig_winnr = winnr()
  " let l:orig_line = line('.')
  let l:adjust_nr = 0

  " ***

  let l:curr_winnr = 1
  let l:last_winnr = winnr('$')

  while l:curr_winnr <= l:last_winnr
    let l:bufnr = winbufnr(l:curr_winnr)

    if s:IsVimFugitiveWindow(l:bufnr)
      if l:curr_winnr < l:orig_winnr
        let l:adjust_nr += 1
      endif
    endif

    let l:curr_winnr += 1
  endwhile

  " ***

  let l:best_win = l:orig_winnr - l:adjust_nr

  windo if (&filetype == 'git' || &filetype == 'fugitiveblame' || &previewwindow) | q | endif

  " Note that :windo leaves cursor in last window, so regardless of l:adjust_nr
  " (figuring out where to move cursor if it's in a Git window being closed),
  " we'd probably need to restore cursor anyway (unless it was already in the
  " last window).
  if winnr() != l:best_win
    execute l:best_win . "wincmd w"

    " call cursor(l:orig_line, 1)
  endif
endfunction

" ***

function! s:IsVimFugitiveWindow(bufnr)
  let l:ftype = getbufvar(a:bufnr, "&ft")

  " Not sure why, but this not reporting 1 for preview window for me.
  " - But if I `:windo echom "&previewwindow: " . &previewwindow` then it
  "   prints 1 for preview window (or if you `:exe '1wincmd w'` I assume).
  " - Fortunately, the Git-blame preview window reports ft=git.
  let l:pview = getbufvar(a:bufnr, "&previewwindow")

  if 0
    \ || l:ftype == 'git'
    \ || l:ftype == 'fugitiveblame'
    \ || l:pview

    return 1
  endif

  return 0
endfunction

