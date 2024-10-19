" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2020 Landon Bouma.

" ########################################################################

" DEV: Uncomment the 'unlet', then <F9> to reload this file.
"       https://github.com/landonb/vim-source-reloader
"  silent! unlet g:loaded_vim_depoxy

if exists("g:loaded_vim_depoxy") || &cp
  finish
endif
let g:loaded_vim_depoxy = 1

" ########################################################################

" Load Exuberant Ctags tags file for ~/.projlns/depoxy-deeplinks (DEPOXY_PROJLNS_DEPOXY)
"
" CXREF: The 'tags' file is created on `mr -d / infuse`:
"   infuse_projects_links_core_generate_ctags
"     ~/.depoxy/ambers/home/.projlns/infuse-projlns-core.sh

function! s:SetTagsProjlnsDepoxydeeplinks()
  let l:ctags_file = $DEPOXY_PROJLNS_DEPOXY .. '/tags'

  if !filereadable(l:ctags_file)
    let l:ctags_file = $HOME .. '/.projlns/depoxy-deeplinks/tags'
  endif

  if filereadable(l:ctags_file)
    " Default tags='./tags,tags'
    exec 'set tags=' .. &tags .. ',' .. l:ctags_file
  endif
endfunction

call s:SetTagsProjlnsDepoxydeeplinks()

" ########################################################################

