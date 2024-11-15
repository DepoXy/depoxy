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

" USAGE: This plugin wires the following bindings:
"
"   \F       — Open FZF in Vim on paths under user home
"
"   \f       — Open FZF in Vim on paths in current Git project
"
"   :F <term> — Open FZF in Vim on files with matching <term>
"               in their contents
"
" CXREF: See more FZF ref. in the complementary shell file:
"
"   ~/.depoxy/ambers/core/fzf-setup.sh

" ***

" Configure fzf.
"
" USYNC: The FZF_DEFAULT_COMMAND string below was copied from a DepoXy shell:
"
"   echo "${FZF_DEFAULT_COMMAND}"
"
" CXREF: ~/.depoxy/ambers/core/fzf-setup.sh
"
" - ALTLY: We could actually omit the FZF_DEFAULT_COMMAND setting if you
"   start Vim from a DepoXy terminal. But embedding it ensures that FZF
"   still works if you start Vim from a Launcher, or Spotlight, etc.
"
" SAVVY: `fzf` must be found on PATH.
"
" - DepoXy installs a symlink at ~/.local/bin/fzf
"
" HSTRY: This previously used an `fd` command [2024-11-14], e.g.:
"
"   function! s:SetFzfEnvirons()
"     if !executable("fd")
"       return
"     endif
"     let $FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
"     let $FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
"   endfunction
"
" - But author now prefers `rg`, for whatever reason.
"   - See more comments in ~/.depoxy/ambers/core/fzf-setup.sh
"
" ALTLY: Rather than being exclusive, we could be inclusive, e.g.,:
"
"   \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
"
" - But author more likely knows which files they don't care about, and
"   less likely about which files they do/might care about. (E.g., if
"   you start working with a new language, e.g., Rust, I'd probably
"   forget to come here to add the ".rs" extension (or I'd be annoyed
"   that I had to).)

function! s:SetFzfEnvirons()
  if !executable("rg")
    return
  endif

  " USYNC: See comment above: Copy this string from your shell.

  let $FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs --no-ignore-parent -g '!**/{.git,.tox,node_modules,.bash_sessions,.grip/cache-*,.gnupg/openpgp-revocs.d,.gnupg/private-keys-v1.d,.zsh_sessions,.vim_backups,.crypt,.noise/home,.projlns,.trash,.trash0,.Trash,.Trash0}/**' -g '!**/{*.swp,.bash_history,*.bin,*.gif,*.gpg,*.jpg,*.Jpg,*.JPG,*.nib,*.odg,*.odt,*.pdf,*.Pdf,*.PDF,*.png,*.pyc,*.svg,.viminfo,*.xpm,*.zip}'"

  let $FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
endfunction

" ***

function! s:WireFzfFilesWithMatches()
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
  command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .. shellescape(<q-args>), 1, <bang>0)
endfunction

" ***

" \F — Search files under user home.
function! s:WireFzfAllFilesSearch()
  map <silent> <leader>F :lcd<CR>:FZF<CR>
endfunction

" ***

" \f — Search files under Git root of current file's project.
function! s:WireFzfGitRootSearch()
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

" ***

call s:SetFzfEnvirons()

call s:WireFzfFilesWithMatches()

call s:WireFzfAllFilesSearch()

call s:WireFzfGitRootSearch()

