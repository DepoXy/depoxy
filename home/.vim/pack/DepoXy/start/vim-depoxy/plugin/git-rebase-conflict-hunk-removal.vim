" mergetool <leader>dx :substitute helps remove <<<<<<< ||||||| ======= >>>>>>>.
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2020 Landon Bouma.

" ########################################################################

" DEV: Uncomment the 'unlet', then <F9> to reload this file.
"       https://github.com/landonb/vim-source-reloader
"  silent! unlet g:loaded_conflict_marker_removal

if exists("g:loaded_conflict_marker_removal") || &cp
  finish
endif
let g:loaded_conflict_marker_removal = 1

" ########################################################################

" Bind <leader>dx to a substitute command that removes
" the <<< === >>> hunk delimiters.
"
" Thanks to a comment by tecfu for the substitute command below:
"   https://github.com/tpope/vim-fugitive/issues/1022
" also at:
"   https://vi.stackexchange.com/questions/10534/
"     is-there-a-way-to-take-both-when-using-vim-as-merge-tool
"
" Note that I first tried BufEnter, but it signals before &diff is set.
" - E.g.,
"     autocmd BufEnter * if &diff | ...
" - So hook DiffUpdated instead.
"   - Which means the if-&diff is probably unnecessary, but
"     that's the first time I've made a conditional map. So
"     keeping it for reference.
" - (I also tried FilterWritePre, as suggested by some posts.)
"
" Regarding the autocmd syntax:
" - The single \-delimiters are passed through to the substitute
"   command, but the double \\-delimiters are used before the pipe
"   characters (\\|) to not confuse Vim into thinking they're an
"   if-then-else delimiter.
" - None that the `endif` is optional, and it's not used here.
"   But if it were, ensure there's no space between the <CR>
"   and the final `|`, otherwise the map consumes that space.
"   - E.g. with `endif`, it'd look like this:
"       autocmd DiffUpdated * if &diff | nnoremap <leader>dx :.,$s/^\(...\).*\n//gc<CR>| endif

function! s:CreateConflictMarkerRemovalMaps()
  augroup conflict_marker_removal_autocommands
    au!

    autocmd DiffUpdated * if &diff | nnoremap <leader>dx
      \ :.,$s/^\(<\{7}\\|^\|\{7}\\|^=\{7}\\|^>\{7}\).*\n//gc<CR>
  augroup END
endfunction

if ! exists("g:conflict_marker_removal_disable") || ! g:conflict_marker_removal_disable
  call s:CreateConflictMarkerRemovalMaps()
endif

" ########################################################################

