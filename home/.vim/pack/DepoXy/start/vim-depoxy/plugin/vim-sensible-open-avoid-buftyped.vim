" vim-beautifold user config.
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2020 Landon Bouma.

" ########################################################################

" DEV: Uncomment the 'unlet', then <F9> to reload this file.
"       https://github.com/landonb/vim-source-reloader
"  silent! unlet g:loaded_vim_sensible_open_avoid_buftyped

if exists("g:loaded_vim_sensible_open_avoid_buftyped") || &cp
  finish
endif
let g:loaded_vim_sensible_open_avoid_buftyped = 1

" ########################################################################

" DRY: See related in vim-buffer-ring: s:BufSurfTargetable() and s:BufSurfDisabled().

" #############################################
"
" FIXME/2022-01-27: Two other plugs use these commands:
"
"   FindNextWindowWithNormalBuffer
"
"   SensibleOpenMoveCursorAvoidSpecial
"
" I'm not sure the best way to resolve these dependencies.
"
" - I cannot think of any plugin I maintain that depends upon another plugin,
"   so there's no precedent.
"
" - I've installed other people's plugins in the past that relied upon
"   another plugin (usually from the same author), but I always thought
"   it was somewhat tedious to setup. Or maybe it was that I wouldn't
"   remember what some Vim library was installed, so I'd have to leave
"   a breadcrumb telling me that some library doesn't provide any enduser
"   features, but supports another plugin.
"
" - I don't anticipate dependencies being a huge issue, so the simpler
"   approach, though not the most robust, might be the best approach.
"
"   - FIXME: And that approach is to do like shoilerplate dependencies.
"
"     - Move these functions to separate files,
"       then duplicate in the other plugins that require them.
"
"       - Could I make a `deps/` subdirectory?
"
"       - Use hardlinks so that repo changes are automatic.
"
"       - Would I have to worry about name conflicts?
"         - What about an `autoload` file, then the plugin
"           name is used as a prefix, right?
"
" #############################################

function! FindNextWindowWithNormalBuffer()
  let l:found_winnr = 0

  let l:start_winnr = winnr()
  let l:final_winnr = winnr('$')

  let l:visit_winnr = l:start_winnr

  while l:visit_winnr <= l:final_winnr
    let l:bufnr = winbufnr(l:visit_winnr)

    if s:BufferIsNotSpecial(l:bufnr)
      " All good!
      let l:found_winnr = l:visit_winnr

      break
    endif

    " Didn't break, so window contains the project tray, help, quickfix, or
    " preview, etc. Skip current window and while again to test next window.
    let l:visit_winnr += 1

    " Check if we've passed the last window and should reset to first window.
    if l:visit_winnr > l:final_winnr
      let l:visit_winnr = 1
    endif

    " Check if we've wrapped around back to the start.
    if l:visit_winnr == l:start_winnr
      break
    endif
  endwhile

  return l:found_winnr
endfunction

function! SensibleOpenMoveCursorAvoidSpecial()
  let l:found_winnr = FindNextWindowWithNormalBuffer()

  " Check if there was only one window and it was special.
  if l:found_winnr == 0
    if &ft == 'qf'
      " Open new window, split horizontally.
      wincmd s
      " Note that this leaves the two windows 50-50, and I normally have
      " my quickfix at about 20% of the height. Or 80% of total height.
      execute "resize " . float2nr(winheight(0) * 2 * 0.8)
    else
      " Open new window, split vertically.
      wincmd v
    endif
  else
    " Otherwise, success! Move cursor to the identified window.
    execute l:found_winnr . 'wincmd w'
  endif
endfunction

" ***

function! s:BufferIsNotSpecial(bufnr)
  " !buflisted    / Matches 'help' and project tray buffer.
  " - But note project tray buffer is initially buflisted,
  "   in the first BufEnter callback.
  "
  " buftype != '' / Matches 'quickfix', 'help', 'nofile', etc.
  " - Which I don't think we need, e.g.,:
  "     \ || getbufvar(a:bufnr, "&buftype") != ""
  "
  " !bufexists    / Matches a bwipe'd buffer. Shouldn't need.
  " - Guessing not needed. E.g.,:
  "     \ || !bufexists(a:bufnr)
  " 
  " bufhidden == 'hide' / Should never be true on winbufnr().
  "     \ || getbufvar(a:bufnr, "&bufhidden") == 'hide'

  if 0
    \ || getbufvar(a:bufnr, "&ft") == 'qf'
    \ || getbufvar(a:bufnr, "&ft") == 'help'
    \ || getbufvar(a:bufnr, "&previewwindow")
    \ || !buflisted(a:bufnr)

    return 0
  endif

  return 1
endfunction

" ########################################################################

