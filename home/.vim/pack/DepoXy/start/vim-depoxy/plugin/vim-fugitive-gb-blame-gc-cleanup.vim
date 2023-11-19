" vim-fugitive `gb` and `gc` aliases.
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2023 Landon Bouma.

" ***

" DEV: Uncomment and <F9> to source/reload.
"  silent! unlet g:loaded_vim_depoxy_vim_fugitive

if exists("g:loaded_vim_depoxy_vim_fugitive") || &cp
  finish
endif
let g:loaded_vim_depoxy_vim_fugitive = 1

" ***

" vim-fugitive maps 'gq' (Git quit) that closes the :Git blame window.
" - But 'gq' *only* closes the blame window, and not the commit window,
"   if you opened that.
" - And 'gq' *only* works from the blame window.
"
" So we'll add 'gc' (for Git close) that closes all vim-fugitive windows,
" and it works from any window/buffer.

" ***

" Note that vim-fugitive defines 'gc' already, but it's same as 'gC'.
" So we'll appropriate 'gc' for ourselves, but leave 'gC'.
" 
" - REFER: ~/.vim/pack/tpope/start/vim-fugitive/autoload/fugitive.vim @ 7950
"
"     call s:Map('n', 'gC', “:<C-U>exe 'Gpedit ' .
"       <SID>fnameescape(<SID>ContainingCommit())<CR>”, '<silent>')
"     call s:Map('n', 'gc', “:<C-U>exe 'Gpedit ' .
"       <SID>fnameescape(<SID>ContainingCommit())<CR>”, '<silent>')
"
" - Oddly, neither option appears documented:
"
"   ~/.vim/pack/tpope/start/vim-fugitive/doc/fugitive.txt
"
" - Also, the author cannot quite figure out what they're suppose to do.
"   If I run :Git blame and jump back to the source file, 'gc'/'gC' from
"   *any* line opens the *same* commit window, and it's on a commit from
"   last year, like, 40 commits ago. So I'm not even sure what 'gc'/'gC'
"   are suppose to do. So another way to put it: We're stomping on 'gc',
"   but we doubt you'll miss it. But note I am not a vim-fugitive power-
"   user. I use :Git blame, but all other Git work I do with tig-newtons.

" ***

" vim-fugitive buffer specs:
"
" - Git blame buffer is named, e.g., '353.fugitiveblame',
"   and has filetype=fugitiveblame
"
" - Git commit buffer is named, e.g., 'fugitive:///path/to/project/.git/<sha>,
"   and has filetype=git
"
" - Git show buffer is named, e.g.,
"   'fugitive:///path/to/project/.git//<sha>/proj/path/to/<source-file-basename>'
"   and has filetype= whatever source file is.

" ***

" Unmap `gc` if it's set, otherwise our binding won't work.
"
" - The commit buffer uses filetype=git, but hooking FileType won't work:
"
"     autocmd FileType git call <SID>MaybeUnmapGitBlameCleanupBinding('FileType')
"
"   Because the FileType hook only runs when filetype is set or changes,
"   which only happens once, and it's before git-fugitive applies its
"   `gc` binding. As such, using FileType won't work.
"
" - So we'll hook BufEnter/BufRead, but note they key off a path glob, e.g.,
"   you might see `autocmd BufEnter,BufRead *.py ...` for Python bindings,
"   but the commit buffer filename is the commit SHA.
"   
"   So we'll run the binding on all buffers, but we'll use a guard clause to
"   restrict by filetype, and add `gc` only to the vim-fugitive commit buffer.

" ***

" USAGE/2023-05-21: `gc` closes all vim-fugitive windows.
"
"                   Use `gc` after you inspect blame with `gb`.

function! s:MaybeUnmapGitBlameCleanupBindingGC(whence)
  if &filetype != 'git' | return | endif

  redir => message
  " Note that `nnoremap <silent> gc` is not silent.
  silent nnoremap gc
  redir END

  if message == ''
    nunmap <buffer> gc
  endif

  " This `nnoremap <silent>` works (unlike above), otherwise :call command is echoed.
  nnoremap <silent> <buffer> gc :call git_fugitive_window_cleanup#close_git_windows()<CR>
endfunction

" ***

" As discussed above, remove `gc` from commit buffer maps.
autocmd BufEnter,BufRead * call <SID>MaybeUnmapGitBlameCleanupBindingGC('FileType')

" Map `gc` everywhere, so you can easily close vim-fugitive windows from anywhere.
nnoremap <silent> gc :call git_fugitive_window_cleanup#close_git_windows()<CR>

" ***

" USAGE/2023-05-21: `gb` is `:Git blame` alias.

autocmd BufEnter,BufRead * nnoremap <silent> <buffer> gb :Git blame<CR>

