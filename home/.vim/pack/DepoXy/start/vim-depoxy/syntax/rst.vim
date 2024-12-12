" vim:tw=0:ts=2:sw=2:et:norl
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"   Copyright © 2024 Landon Bouma.
" Summary: Custom reStructuredText highlights.

" SAVVY: `syn keyword` matches are simple and fast.
" - See also `syn match`, which uses regex, slower.

" SILLY/2024-12-12: So I can leave cd-style breadcrumbs without
" needing a code block, etc.
" - CXREF: function cdd ():
"   ~/.kit/sh/home-fries/lib/alias/alias_cd_pushd_popd.sh
" - CXREF: SlashPathNoSpell highlight group:
"   ~/.vim/pack/landonb/start/vim-reST-highdefs/after/syntax/rst.vim
syn keyword SlashPathNoSpell cdd

