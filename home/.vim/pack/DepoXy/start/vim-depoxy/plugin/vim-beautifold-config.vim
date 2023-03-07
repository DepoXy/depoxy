" vim-beautifold user config.
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2020 Landon Bouma.

" ########################################################################

" DEV: Uncomment the 'unlet', then <F9> to reload this file.
"       https://github.com/landonb/vim-source-reloader
"  silent! unlet g:loaded_vim_beautifold_config

if exists("g:loaded_vim_beautifold_config") || &cp
  finish
endif
let g:loaded_vim_beautifold_config = 1

" ########################################################################

" My convention is that content starts one blank after the title,
" and a blank follows content, so that's a minimum 3 lines of content
" (which allows for a 5-line design fold, e.g., one `..` comment
" immediately following title header, then a blank line).
" Defaults: 2
let g:restfold_weldable_min_content_lines = 3

" Configure reSTfold to use whitespace padding after short fold titles.
"   https://github.com/landonb/vim-reSTfold
" Open a reST file and press <F5> to generate folds using this option.
"
let g:restfold_min_title_width = 93

" 2021-02-20: I have some files that use 8 PREFIXES, some with leading
" emoji, and some with 3 leading spaces, and don't always conform to
" the typical (for me) `FIXED/YYYY-MM-DD: reSTfold topic title` format.
" E.g., sometimes it's `DONT_FIX/YYYY-MM-DD: ...`.
let g:restfold_weldable_max_lead_spaces = 3

" 2021-03-11: Disable Unicode design fold test, so that my old-style headers, e.g.,
"     ┃ YYYY-MM-DD: FIXME: Foo ┃
" are pipe-prefixed like other open tasks.
" - So now if you don't want such titles pipe-prefixed,
"   just ensure they have 2 or fewer lines of content,
"   e.g., see judge design folds mostly by
"     g:restfold_weldable_min_content_lines = 3
let g:restfold_weldable_unicode_enable_all = 1

" ########################################################################

