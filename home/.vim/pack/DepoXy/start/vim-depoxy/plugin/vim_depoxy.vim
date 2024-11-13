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
" Default `tags='./tags,tags'` which looks first for tags file
" adjacent to current file (./tags), then tags file in current
" working directory (tags). Though in normally DepoXy usage,
" you won't find either such file (unless you add your own).
" - Finally, search the DXY ~/.projlns 'tags' file last.
"
" CXREF: The ~/.projlns 'tags' file is created on `mr -d / infuse`:
"   infuse_projects_links_core_generate_ctags
"     ~/.depoxy/ambers/home/.projlns/infuse-projlns-core.sh

function! s:SetTagsProjlnsDepoxydeeplinks()
  let l:ctags_file = $DEPOXY_PROJLNS_DEPOXY .. '/tags'

  if !filereadable(l:ctags_file)
    let l:ctags_file = $HOME .. '/.projlns/depoxy-deeplinks/tags'
  endif

  if filereadable(l:ctags_file)
    exec 'set tags=./tags,tags,' .. l:ctags_file
  endif
endfunction

call s:SetTagsProjlnsDepoxydeeplinks()

" ########################################################################

