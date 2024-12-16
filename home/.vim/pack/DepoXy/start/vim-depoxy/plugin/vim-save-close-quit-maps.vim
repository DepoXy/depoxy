" vim:tw=0:ts=2:sw=2:et:norl
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"   Copyright © 2024 Landon Bouma.

" -------------------------------------------------------------------

function! s:CreateMaps()
  " LATER/2024-12-13 14:33: But will you use this instead of <M-f>c?
  nnoremap <Leader>dc :Bdelete<CR>
  inoremap <Leader>dc <C-o>:Bdelete<CR>

  " CXREF: <M-f>l → s:RecreateDubsVimMappings()
  "        <M-f>e → s:RecreateDubsVimMappings()
  "        <M-f>x → s:RecreateBuiltinMenuMappings_File()
  " ~/.vim/pack/landonb/start/dubs_appearance/plugin/mimic_menu_keymap.vim
  noremap <Leader>dq :wa<CR>:only<CR>:enew<CR>:BufOnly<CR>:qa<CR>
  inoremap <Leader>dq <C-o>:wa<CR><C-O>:only<CR><C-O>:enew<CR><C-O>:BufOnly<CR><C-O>:qa<CR>
endfunction

call s:CreateMaps()

