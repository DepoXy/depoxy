" vim:tw=0:ts=2:sw=2:et:norl
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"   Copyright © 2024 Landon Bouma.
" Summary: vim-buffer-delights config.
"   https://github.com/embrace-vim/vim-buffer-delights#🍧

" -------------------------------------------------------------------

" CXREF:
" ~/.vim/pack/embrace-vim/start/vim-buffer-delights/autoload/embrace/windows.vim

function! s:CreateMaps()
  nnoremap <Leader>dg :call g:embrace#windows#CloseVimHelpWindow()<CR>
  inoremap <Leader>dg <C-o>:call g:embrace#windows#CloseVimHelpWindow()<CR>

endfunction

call s:CreateMaps()

