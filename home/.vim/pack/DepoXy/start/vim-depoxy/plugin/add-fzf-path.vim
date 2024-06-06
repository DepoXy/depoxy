" fzf wiring
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2011-2021 Landon Bouma.

" ***

" YOU: Uncomment and <F9> to source/reload.
"  silent! unlet g:plugin_add_fzf_path

if exists("g:plugin_add_fzf_path") || &cp
  finish
endif
let g:plugin_add_fzf_path = 1

" ***

" See elsewhere:
"
"   Add user gopath bin to path.
"
" (so that Vim find fzf; amon'go other things).

" Configure fzf.

function! s:SetFzfDefaultCommandsFd()
  if !executable("fd")
    return
  endif
  let $FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  let $FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --exclude .git"
endfunction

function! s:SetFzfDefaultCommandsRg()
  if !executable("rg")
    return
  endif
  " http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/
  "
  " MAYBE/2020-02-13: Not sure I want --no-ignore.
  " - 2021-01-29: Only recently started (I'm trying) to use FZF more,
  "               and I haven't noticed --no-ignore including files I
  "               don't want to see included... but I'll keep a looko.
  " MAYBE/2020-02-13: Is there reason to prefer `rg` over `fd`?
  " - Note that FZF (fzf#vim#grep) uses `rg` to show only files that
  "   match a term being searched. It works as an alternative to `fd`,
  "   helping to narrow your search, and to show you a little context
  "   for each file, displaying the matched line after the file name.
  let g:rg_command = '
    \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
    \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
    \ -g "!{.git,node_modules,vendor}/*" '

  " The `:F {term}` command is pretty nifty, it'll search in files for
  " the term, and then give you a fuzzy finder prompt to narrow down
  " the matches *by filename* to find the exact file you want.
  " (2021-01-29: Well, it seems nifty -- I respect innovative commands,
  "  no matter how esoteric -- but it remains to be seen how useful I'll
  "  find this feature personally. Especially because this feature is not
  "  so unique; as there are many other ways to search for a file to open,
  "  and I tend to prefer using dubs_greps_steady (`\g`) and perusing
  "  results in the quickfix. Whether using the quickfix or FZF is quicker,
  "  well, that might be what drives me to use one of the other.)
  " USAGE: :F {file-contents-search-term}
  command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
endfunction

function! s:WireStartFzfFromProjectRootForFileMap()
  " Use Tim Pope's fugitive to set the working directory to the Git root
  " of the current file, then opens the FZF file fuzzy finder window.
  " (Vim doesn't cd as you open files and change buffers, so up to us.
  "  Similar to using expand("%:p") but then figures out the base project
  "  directory, gotta love Fugitive. Well, and FZF. And to be honest, I
  "  mostly use Fugitive for :Gblame. But it was a relief building this
  "  map just now to not have to do any heavy lifting myself; just wire
  "  two things together and presto.
  " - Set the working directory to the Git root of the current file,
  "   then open FZF fuzzy find window.
  map <silent> <leader>f :Glcd<CR>:FZF<CR>
endfunction

call s:SetFzfDefaultCommandsRg()

call s:SetFzfDefaultCommandsFd()

call s:WireStartFzfFromProjectRootForFileMap()

" ***

