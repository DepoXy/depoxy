" NERD Commenter settings
" Author: Landon Bouma <https://tallybark.com/>
" Project: https://github.com/DepoXy/depoxy#🍯
" License: https://creativecommons.org/publicdomain/zero/1.0/
"  vim:tw=0:ts=2:sw=2:et:norl:ft=vim
" Copyright © 2011-2021 Landon Bouma.

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "

" YOU: Uncomment next 'unlet', then <F9> to reload this file.
"      (Iff: https://github.com/landonb/vim-source-reloader)
"
"  silent! unlet g:loaded_plugin_setup_nerd_commenter

if exists('g:loaded_plugin_setup_nerd_commenter') || &cp || v:version < 800
  finish
endif

let g:loaded_plugin_setup_nerd_commenter = 1

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "

" -------------------------------------------------------------------------
" 2021-01-23: NERD Commenter
" -------------------------------------------------------------------------

" FIXME/2021-01-23: Belongs in a DepoXy Ambers trap file.

" https://github.com/preservim/nerdcommenter

" 'Create default mappings'
let g:NERDCreateDefaultMappings = 1

" 'Add spaces after comment delimiters by default'
let g:NERDSpaceDelims = 1

" 'Use compact syntax for prettified multi-line comments'
" - FIXME/2021-01-23: EXPLAIN:
"
"  let g:NERDCompactSexyComs = 1

" - MAYBE/2021-01-23: DEMO and EXPLAIN these:
"
" 'Align line-wise comment delimiters flush left instead of following code indentation'
" (lb): The code shows four options: 'none', 'start', 'left', 'both'.
" - Demoing DefaultAlign with the three comment commands reveals:
"   - Invert: - 'left', 'both', 'none' all seem same to me, and insert
"               comment after leading whitespace, but without adding
"               leading whitespace to match other lines, so might look
"               a little weird across blank lines;
"             - 'start' puts comments at start of line, looks nice.
"             - behavior consistent whether selecting partial or complete lines.
"   - Comment: - adds comment where selection starts, unlike Invert, which
"                puts first comment before selection, if necessary.
"              - 'start' puts comments on middle lines at start of line;
"                puts comment on first line where selection starts;
"                and puts comment on final line after leading whitespace.
"                Pretty not pretty.
"              - 'left' puts comments after leading whitespace --
"                and it'll *add leading whitespace to blank lines!*
"                which is vee nice.
"              - 'none' puts comments after leading whitespace
"                but does not add any to blank lines.
"              - 'both' is like 'left', as far as I can discern-tell.
"   - AlignLeft: - Bingo! This is the one I'll use. DefaultAlign doesn't matter.
"                  Adds comments after leading white, even on first and final
"                  selected line, regardless of where cursor starts or stops.
"                  - Only caveat is multiline select: If the last line's newline
"                    is included in the selection, the line *after* that final line
"                    is also commented. This is not too hard to workaround, and it
"                    won't be hard for me to remember to do, because it behaves
"                    similar to another feature I use, the <F2> parT command (found in
"                    dubs_edit_juice.vim) that also mistakes the final newline to mean
"                    including the line following it. And in any case, AlignLeft works
"                    more how (I think) I'd like to use this commenter, so I'm happy to
"                    live with this one CAVEAT.
"                    - MAYBE/2021-01-25: Make AlignLeft (and parT) chop final newline
"                                        from selection (or do whatever it takes) to
"                                        not accidentally involve line after selection.
let g:NERDDefaultAlign = 'left'
"
" 'Set a language to use its alternate delimiters by default'
"   let g:NERDAltDelims_java = 1
"
" 'Add your own custom formats or override the defaults'
"   let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
"
" - Notes:
"   - Heh? No Bash?!
"   - Not the dosini that I know:
"       \ 'dosini': { 'left': ';' },
"   - Adding 'config' 'cause I noticed /* */ being used in mrconfig files.
let g:NERDCustomDelimiters = {
  \ 'bash': { 'left': '#', },
  \ 'dosini': { 'left': '#' },
  \ 'config': { 'left': '#' },
  \ 'gitconfig': { 'left': '#' },
\ }

" 'Allow commenting and inverting empty lines (useful when commenting a region)'
let g:NERDCommentEmptyLines = 1

" 'Enable trimming of trailing whitespace when uncommenting'
" - Also trims trailing whitespace on blank lines commented b/c g:NERDCommentEmptyLines.
let g:NERDTrimTrailingWhitespace = 1

" 'Enable NERDCommenterToggle to check all selected lines is commented or not'
" - FIXME/2021-01-23: EXPLAIN:
"
"  let g:NERDToggleCheckAllLines = 1

" Dubs Vim does not use menus (albeit leaving at default, 3, does nothing).
let g:NERDMenuMode = 0

" DOCS
"
" When g:NERDCreateDefaultMappings = 1, sets following, per README::
"
"   Most of the following mappings are for normal/visual mode only.
"   The |NERDCommenterInsert| mapping is for insert mode only.
"
"   - Comment out the current line or text selected in visual mode.
"   
"     [count]<leader>cc |NERDCommenterComment|
"
"   - Same as cc but forces nesting.
"
"     [count]<leader>cn |NERDCommenterNested|
"
"   - Toggles the comment state of the selected line(s).
"     - If the topmost selected line is commented, all
"       selected lines are uncommented and vice versa.
"
"     [count]<leader>c<space> |NERDCommenterToggle|
"
"   - Comments the given lines using only one set of multipart delimiters.
"
"     [count]<leader>cm |NERDCommenterMinimal|
"
"   - Toggles the comment state of the selected line(s) individually.
"
"     [count]<leader>ci |NERDCommenterInvert|
"
"   - Comments out the selected lines with a pretty block formatted layout.
"
"     [count]<leader>cs |NERDCommenterSexy|
"
"   - Same as cc except that the commented line(s) are yanked first.
"
"     [count]<leader>cy |NERDCommenterYank|
"
"   - Comments the current line from the cursor to the end of line.
"
"     <leader>c$ |NERDCommenterToEOL|
"
"   - Adds comment delimiters to the end of line and goes into insert mode between them.
"
"     <leader>cA |NERDCommenterAppend|
"
"   - Adds comment delimiters at the current cursor position and inserts between. Disabled by default.
"
"     |NERDCommenterInsert|
"
"   - Switches to the alternative set of delimiters.
"
"     <leader>ca |NERDCommenterAltDelims|
"
"   - Same as |NERDCommenterComment| except that the delimiters are
"     aligned down the left side (<leader>cl) or both sides (<leader>cb).
"
"     [count]<leader>cl |NERDCommenterAlignLeft [count]<leader>cb |NERDCommenterAlignBoth
"
"   - Uncomments the selected line(s).
"
"     [count]<leader>cu |NERDCommenterUncomment|
"
"   Motions
"
"   While the plugin does not directly support motions, you can leverage its support
"   for selections to do something very similar.
"
"   - For example, to add motions to toggle comments on the paragraph text object you could use:
"
"     nnoremap <silent> <leader>c} V}:call nerdcommenter#Comment('x', 'toggle')<CR>
"     nnoremap <silent> <leader>c{ V{:call nerdcommenter#Comment('x', 'toggle')<CR>
"
" 2021-01-25: AFAICT: \c} will comment down to and including next blank line;
"                 and \c{ will comment up in the same fashion, including blank.
nnoremap <silent> <leader>c} V}:call nerdcommenter#Comment('x', 'toggle')<CR>
nnoremap <silent> <leader>c{ V{:call nerdcommenter#Comment('x', 'toggle')<CR>

" ***

" Following is Inspired by/Basec on NERD_commenter.vim CreateMaps().

function! s:ManageMapNERDCommenter(create, modes, target, combo)
  let l:plug = '<plug>NERDCommenter' . a:target
  let l:plug_start = 'noremap <silent> ' . l:plug . ' :call nerdcommenter#Comment("'
  let l:plug_end = '", "' . a:target . '")<CR>'
  for mode in (a:modes ==# '') ? [''] : split(a:modes, '\zs')
    if a:create == 1
      execute l:mode . l:plug_start . l:mode . l:plug_end
      if !hasmapto(l:plug, l:mode)
        let l:ctrl_o = ''
        if l:mode == 'i'
          let l:ctrl_o = '<C-o>'
        endif
        execute l:mode . 'map <leader>' . a:combo . ' ' . l:ctrl_o . l:plug
      endif
    else
      " Not a trivial way to check if specific keys are mapped,
      " so just clobber.
      " https://vi.stackexchange.com/a/17592  # re: lh#mapping#who_maps
      execute 'silent! ' . l:mode . 'unmap <leader>' . a:combo
    endif
  endfor
endfunction

" TL;DR/2021-01-25: At first I liked Invert the best, then Comment,
" but now I believe AlignLeft is the best one to use for most cases.
" - So you'll probably toggle comments alternating \cs and \cd.
" - All commands should work in Normal mode; most in Select modes;
"   and some in Insert mode.

" (lb): I added 'i' Insert mode map (and <C-o> to the ManageMap function).
" - Which I really like! Being able to comment from Insert mode, quite nice.

function! s:ManageMaps(create)
  " (lb): I changed default 'x' Visual mode to 'v' Select mode maps.
  " - The NERD Commenter defauls to 'Visual' mode maps ('x'), but
  "   Dubs Vim aka DepoXy Ambers Vim uses Select mode when selecting,
  "   so I changed those to 'Visual and Select' mode maps ('v'). (I at
  "   first tried just 's', for 'Select' mode, but that didn't work, FWR).
  call s:ManageMapNERDCommenter(a:create, 'nvi', 'Comment',    'cc')
  " - The ToEOL feature is kinda nice, or at least it's innovative, and it
  "   shows how well NERD Commenter covers all your commenting bases. Though
  "   it's not often (read: rarely) that I comment from the middle of a line.
  call s:ManageMapNERDCommenter(a:create, 'ni', 'ToEOL',       'c$')
  " - Invert seemed pretty useful at first -- a toggle in one mapping is all
  "   you need! -- but (per my observations annotated elsewhere), Invert does
  "   not handle commenting the first and last lines of the selection, nor
  "   blank lines, as well as I think the 'AlignLeft' command does.
  call s:ManageMapNERDCommenter(a:create, 'nvi', 'Invert',     'ci')
  " - So, like, 'Sexy' comments is not a term I like to say or think about.
  "   Not for something code related. If anything, all comments are sexy.
  "   But let's not sexualize code, even if it is just using the term itself
  "   and not actually describing anything, but it's still a messed up mnemonic
  "   for my brain. Like, I'll type <leader>c, and then I think, Oh, yeah, 's'
  "   is for Sexy. Which is not what I like to have to think when I code.
  "   So Let's not have that. - Default: Sexy: 'cs'
  " - Ideas: Use 'f': Fuller comments? Or 'l': multiLine comments? I guess 's'
  "   works if you think it means commentS (or multiple lineS). But I like 'b',
  "   which is near 'c' on a US deck, and has mnemonic 'comment block'.
  call s:ManageMapNERDCommenter(a:create, 'nvi', 'Sexy',       'cb')
  " LEARN/2021-01-25: Not sure what Yank does different than Comment.
  " Maybe something register-related, but I only use system clipboard.
  call s:ManageMapNERDCommenter(a:create, 'nvi', 'Yank',       'cy')
  " Append is kinda cool, innovative, but not sure I'll use: Starts EOL comment.
  call s:ManageMapNERDCommenter(a:create, 'ni',  'Append',     'cA')
  " (lb): I like 'AlignLeft' better than 'Comment' or 'Invert'.
  " - Unclear how AlignBoth any different.
  " - Defaults: AlignLeft: 'cl' / AlignBoth: 'cb'
  " - Make AlignLeft easy to type. 'cs' is pretty easy to type.
  "   mnemonic: 'comment selection', perhaps.
  " - Note that surroud.vim's Csurround is mapped to normal mode 'cs'.
  call s:ManageMapNERDCommenter(a:create, 'nvi', 'AlignLeft',  'cs')
  " - Just scooch AlignBoth to 'cB', to let the other map use 'cb'.
  call s:ManageMapNERDCommenter(a:create, 'nvi', 'AlignBoth',  'cB')
  " Most combos are conveniently on same (left) side of (US) keyboard,
  " but NERDCommenter defaults Uncomment to 'cu' (For the Mnemonic!).
  " - (lb): I first tried 'cx', like the standard ctrl-'x' Cut complement to
  "         ctrl-'c' Copy. Or, in parlance: <leader>c-'c' Comment, and the
  "         complementary <leader>c-'x' remove (niX) comment.
  " - But on 2d thought, if I plan to use 'AlignLeft' more so than 'Comment'
  "   or 'Invert', and 'AlignLeft' is mapped to 'cs', then, on a US keyboard,
  "   the adjacent-ish 'cd' mapping makes it easy to toggle comments back and
  "   forth (forever). And we also get the nice 'comment delete' mnemonic.
  " - Default: Uncomment: 'cu'
  call s:ManageMapNERDCommenter(a:create, 'nvi', 'Uncomment',  'cd')
  " AltDelims switches between // and /* */ in languages that do that.
  " You can get latter with Sexy comments, but changing AltDelims to
  " /* */ and selecting text in middle of a line let's you comment an
  " interior selection of code. Very specific use case, not something
  " I do very often (usually I split lines on list items if I need to
  " comment one out; or I duplicate a line and comment one of them, then
  " edit the other, if I need to make changes to the middle of a line.
  " 2021-01-25: tl;dr, Check back in 6 months and tell me if you've used
  " the AltDelims feature since demoing it today.
  call s:ManageMapNERDCommenter(a:create, 'ni',  'AltDelims',  'ca')
endfunction

function! s:CreateMaps()
  call s:ManageMaps(1)
endfunction

function! s:RemoveMaps()
  call s:ManageMaps(0)
endfunction

" Manage the mappings ourshells.
"
" (Note that NERDCommenter checks hasmapto() before setting map,
"  so setting default mappings zero is only necessary if you want
"  to only enable a few mappings; i.e., you can change mappings and
"  NERDCommenter won't clobber.)

" NOTE: This setting actually comes *too late* -- or at least we
" cannot control plugin load order, and on @macOS, NERDCommenter
" loads before this plugin.
" - As a solution, ~/.vimrc (the top-level, core Dubs Vim project)
"   also includes this setting (which is not ideal, because separation
"   of concerns, coupling, business logic, and all that jazz; but such
"   is life).
let g:NERDCreateDefaultMappings = 0

call s:RemoveMaps()
call s:CreateMaps()

" +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "

