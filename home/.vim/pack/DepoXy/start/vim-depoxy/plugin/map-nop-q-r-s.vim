" Vim q: no-op.
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2020-2021 Landon Bouma.

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "

" YOU: Uncomment next 'unlet', then <F9> to reload this file.
"      (Iff: https://github.com/landonb/vim-source-reloader)
"
" silent! unlet g:loaded_plugin_map_nop_q_r_s

if exists('g:loaded_plugin_map_nop_q_r_s') || &cp || v:version < 800
  finish
endif

let g:loaded_plugin_map_nop_q_r_s = 1

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "

" 2020-04-21: Brilliant! I've been tripping on "q:" accidentally for years!
" - I've never use the command-line window, except accidentally,
"   and you can still see it -- and search it -- with "q/" or "q?".
" - So now I can fastly type ":q" and not worry if I get me keys crossed.
" Ref:
"   https://vi.stackexchange.com/questions/457/does-ex-mode-have-any-practical-use

map q: <Nop>

" Unmapping Q also suggested, but I don't have a problem with *this* Q.
"
"   nnoremap Q <nop>

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "

