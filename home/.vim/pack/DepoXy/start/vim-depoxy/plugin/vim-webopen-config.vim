" vim:tw=0:ts=2:sw=2:et:norl
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"   Copyright © 2024 Landon Bouma.
" Summary: vim-webopen config.
"   https://github.com/embrace-vim/vim-webopen#🐣

" -------------------------------------------------------------------

" Option 1: Define individual global variables for each feature.
" - This option creates three maps for the specified key sequence,
"   one each in the three modes: normal, insert, and visual.
"   - See Option 2 for specifying the sequence for each mode separately.
" - Set to the empty string to inhibit the maps for the specified feature.
if 0
  " Similar to g:vim_webopen_maps, below, but without bonus 'gW' map.
  let g:vim_webopen_open_url_seq = "<Leader>T"
  let g:vim_webopen_google_define_seq = "<Leader>D"
  let g:vim_webopen_google_search_seq = "<Leader>W"
  " let g:vim_webopen_open_incognito_seq = "g!"
  let g:vim_webopen_open_incognito_seq = "<Leader>P"
endif

" Option 2: Define single global variable mapping.
" - This option supports different key sequences for the
"   different modes, and it lets you define multiple maps
"   using different key sequences for the same command.
" - To inhibit maps for a specific feature, set the top-level
"   value to an empty dictionary, e.g., to skip the open URL
"   feature, you could set:
"     { 'open': {} }
" - Or, to inhibit maps for a specific mode, set the nested
"   dictionary value to an empty string or an empty list, e.g.,
"     { 'open': { 'nmap': '', 'imap': [], 'vmap': '<Leader>T' } }
"   will only wire <Leader>T in visual mode to open URL, and
"   it will skip the normal and insert mode maps for open URL.
" - Note the plugin prefers using g:vim_webopen_maps, but
"   if a top-level key is not found, it'll fallback the Option 1
"   variable.
"   - And if the Option 1 variable isn't set, it'll fallback a
"     default key sequence if not already mapped to something
"     else (so the plugin is opt-out, not opt-in; but it won't
"     clobber existing maps).

" - HSTRY/2020-05-10: I (finally) learned about Vim's builtin `gf` (and `gF`)
"   (I know, I should seriously read the docs front to back) and now I'm
"   thinking that maybe `gW` makes sense ("go Web"), which is not mapped by Vim.
"   - So trying gW, but leaving historic \T sequence that's been wired for a spell,
"     especially because <Leader>T is wired in multiple modes modes.
"   - 2020-09-01: (lb): Unbound/Available: gS, gW, g!. Taken: gP, g@, g#...

if 1
  let g:vim_webopen_maps =
    \ {
    \   "open":
    \     {
    \       "nmap": [ "<Leader>T", "gW" ],
    \       "imap": "<Leader>T",
    \       "vmap": "<Leader>T",
    \     },
    \   "define": "<Leader>D",
    \   "search": "<Leader>W",
    \   "incognito": { "nmap": "g!" },
    \ }
endif

" ALTLY: You could instead build the Dictionary thusly.
if 0
  let g:vim_webopen_maps = {}

  let g:vim_webopen_maps.open = {}
  let g:vim_webopen_maps.define = {}
  let g:vim_webopen_maps.search = {}
  let g:vim_webopen_maps.incognito = {}

  let g:vim_webopen_maps.open.nmap = [ "<Leader>T", "gW" ]
  let g:vim_webopen_maps.open.imap = "<Leader>T"
  let g:vim_webopen_maps.open.vmap = "<Leader>T"

  let g:vim_webopen_maps.define.nmap = "<Leader>D"
  let g:vim_webopen_maps.define.imap = "<Leader>D"
  let g:vim_webopen_maps.define.vmap = "<Leader>D"

  let g:vim_webopen_maps.search.nmap = "<Leader>W"
  let g:vim_webopen_maps.search.imap = "<Leader>W"
  let g:vim_webopen_maps.search.vmap = "<Leader>W"

  let g:vim_webopen_maps.incognito.nmap = "g!"
endif

" If you'd like each URL to open in a new browser tab in an
" existing window instead of always opening in a new window,
" set g:vim_webopen_use_tab nonzero:
"
"   let g:vim_webopen_use_tab = 1


" If you'd like Chrome to use most recent user profile, and not 'Default',
" set g:vim_webopen_mru_profile nonzero:
"
"   let g:vim_webopen_mru_profile = 1

call g:embrace#webopen#CreateMaps()

