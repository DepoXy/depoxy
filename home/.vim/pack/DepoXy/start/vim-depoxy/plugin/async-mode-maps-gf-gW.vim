" vim:tw=0:ts=2:sw=2:et:norl:
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" Summary: Async insert and visual mode maps for `gf`, `gW`, etc.
" License: GPLv3

" -------------------------------------------------------------------

" USAGE: Unlet var (or nix finish) & press <F9> to reload this plugin.
" USING: https://github.com/landonb/vim-source-reloader#↩️
"
" silent! unlet g:loaded_vim_depoxy_plugin_async_mode_maps

if exists("g:loaded_vim_depoxy_plugin_async_mode_maps") || &cp

  finish
endif

let g:loaded_vim_depoxy_plugin_async_mode_maps = 1

" -------------------------------------------------------------------

" An autoload function does not exist until called, or unless explicitly
" loaded. Using `runtime` to load it, however, smells of an anti-pattern:
"
"   'This is definitively not the expected use case.' — Luc Hermitte
"
" https://vi.stackexchange.com/questions/38490/how-to-check-if-an-autoload-function-exists-without-calling-it#comment70364_38494
"
" - Alternatively, we could try-except each function call, e.g.,
"
"     try
"       call g:embrace#amapper#register_insert_mode_map('gf', 'gF)
"     catch /^Vim\%((\a\+)\)\=:E117:/
"       " - I.e., embrace-vim/vim-async-mapper is not installed.
"       endif
"     endtry
"
"   but we're going to need the function anyway, and I'd rather not
"   use try/endtry throughout this script.

function! s:check_deps() abort
  runtime autoload/embrace/amapper.vim

  if !exists("*embrace#amapper#register_insert_mode_map")
    echom "ALERT: Please install embrace-vim/vim-async-mapper to enable async mode maps"

    finish
  endif

  return 1
endfunction

call s:check_deps()

" -------------------------------------------------------------------

" Add async 2-character insert mode map so you can run `gW` from insert
" mode (and use async plugin so it doesn't cause input to briefly pause,
" which is how a naïve `imap gW gW` would behave).

function! s:setup_bindings_insert_mode_gW() abort
  " - TIMED: When it's as easy mapping, like 'kj' or 'jk', it's easy to
  "   press the two keys quickly, within 100 msec.
  "   - But the 'gW' keypress is a little trickier, and author finds it
  "     taking ~165 msec. sometimes. So set a longer timeout specifically
  "     for this particular sequence.
  let timeout = 250

  call g:embrace#amapper#register_insert_mode_map("gW", "gW", timeout)
endfunction

" Also wire visual mode `gW`.
" - CXREF:
"   ~/.vim/pack/embrace-vim/start/vim-web-hatch/autoload/embrace/browser.vim @ 267
function! s:setup_bindings_visual_mode_gW() abort
  " [y]ank selected text to `"` register, then paste `"` contents as fcn. arg.
  vnoremap gW y:call embrace#browser#web_open_url('<C-r>"', 0)<CR>
endfunction

function! s:setup_bindings_two_modes_gW() abort
  call s:setup_bindings_insert_mode_gW()
  call s:setup_bindings_visual_mode_gW()
endfunction

" -------------------------------------------------------------------

" I originally had an abbreviation for quickly creating a reST header
" using the current time as the title, and over- and underlining with
" pound symbols (`#`) as the delimiter.
"
" - E.g., given this iabbrev:
"
"     iabbrev <expr> 3t '################<CR>' . strftime("%Y-%m-%d %H:%M") . '<CR>################<CR>'
"
"   If you'd type `3t<CR>`, you'd get:
"
"     ################
"     2024-12-11 02:06
"     ################
"
"     {cursor}
"
"   But I broke the abbreviation with a CoC <CR> binding:
"
"     inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : '\<CR>'
"
"   And then the `3t` iabbrev would no longer complete with <CR>.
"
"   - You could use <Ctrl-Enter> instead, but my brain didn't like this.
"
"     Or you could type a space or punctuation, but then you'd have to
"     clean up the extra character. Also, the cursor would be on the
"     line directly under the underline, and not after a blank line.
"
" - Fortunately, I made the `vim-async-mapper` recently, just a few days
"   after I fiddled with the CoC config, and now, a few days after creating
"   the async mode mapper plugin, I realized I can use it to solve the
"   problem I created!
"
"   - As an added bonus, the new map works *without* a carriage return!
"
"     (Though hopefully I won't keep hitting return anyway!=)
"
" So here it is, the glorious `3t` iabbrev reborn as an async map sequence!

function! s:setup_bindings_insert_mode_3t() abort
  call g:embrace#amapper#register_insert_mode_map(
  \   "3t",
  \   "i################\<CR>\<C-R>=strftime('%Y-%m-%d %H:%M')\<C-M>\<CR>################\<CR>\<CR>"
  \ )
endfunction

" -------------------------------------------------------------------

" Set a reasonable default async mapper timeout.
" - SAVVY: The plugin alerts and hints at fixes if Python 3 not available,
"   which is required to set a timeout under 2,000 msecs.
let g:vim_async_mapper_timeout = 100

" Enable `gf` insert and visual mode maps.
" - CXREF:
"   ~/.vim/pack/embrace-vim/start/vim-goto-file-sh/after/plugin/async-mode-maps.vim
let g:vim_goto_file_add_insert_mode_map = 1
let g:vim_goto_file_add_visual_mode_map = 1
" (Don't) Use `gf` (instead of `gF`)
let g:vim_goto_file_use_simple_gf = 0

" Enable `gW` insert and visual mode maps.
call s:setup_bindings_two_modes_gW()

" Author's reST header injector (like an abbrev/snippet).
call s:setup_bindings_insert_mode_3t()

