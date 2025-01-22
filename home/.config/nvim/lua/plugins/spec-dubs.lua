-- vim:tw=0:ts=2:sw=2:et:ai:ft=lua
-- Author: Landon Bouma <https://tallybark.com/>
-- Project: https://github.com/DepoXy/depoxy#🍯
-- License: MIT

-- ------------------------------------------------------------

-- USYNC/2025-01-21: This file matches related config project order:
--
--   meld ~/.depoxy/ambers/home/.config/nvim/lua/plugins/spec-dubs.lua \
--     ~/.vim/plugs/DepoXy/start/vim-depoxy/autoload/depoxy/plug_dubs.vim &
--
--   meld ~/.depoxy/ambers/home/.config/nvim/lua/plugins/spec-dubs.lua \
--     ~/.depoxy/ambers/home/.vim/_mrconfig-dubs &

-- ------------------------------------------------------------

plugns = {}

if true then
  table.insert(plugns, { dir = "~/.vim/plugs/DepoXy/start/vim-clip-expand-path" })
  table.insert(plugns, { dir = "~/.vim/plugs/DepoXy/start/vim-depoxy-coc-defaults" })
end

-- *** ~/.vim/plugs/landonb

if true then
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/ansible-vim" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_after_dark" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_appearance" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_edit_juice" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_ftype_mess" })
  table.insert(plugns, {
    dir = "~/.vim/plugs/landonb/start/dubs_grep_steady",
    -- So that pathogen#split works when LoadUsersGrepProjects run when sourced
    --   ~/.vim/plugs/landonb/start/dubs_grep_steady/plugin/dubs_grep_steady.vim
    dependencies = {
      dir = "~/.vim/plugs/tpope/opt/vim-pathogen",
    },
  })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_html_entities" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_mescaline" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_project_tray" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_quickfix_wrap" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_style_guard" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/dubs_toggle_textwrap" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/QFEnter" })
end

-- *** ~/.vim/plugs/embrace-vim (and promotable plugs/landonb)

if true then
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-async-map" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-better-file-changed-prompt" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-blinky-search" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-buffer-delights" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-buffer-ring" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-classic-taglist" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-command-line-clock" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-fullscreen-toggle" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-goto-file-sh" })
  table.insert(plugns, { dir = "~/.vim/plugs/thirsty-vim/opt/vim-goto-file-sh" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-lcd-project-root" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-mkspell-when-stale" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-netrw-cfg-split-explorer" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-netrw-explore-map" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-netrw-link-resolve" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-ovm-easyescape-kj-jk" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-ovm-seven-of-spines" })
end

if true then
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-reSTfold" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-reST-highdefs" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-reST-highfive" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-reST-highline" })
end

if true then
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-select-mode-stopped-down" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-source-reloader" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-surround" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-title-bar-time-of-day" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-tmux-navigator" })
  table.insert(plugns, { dir = "~/.vim/plugs/landonb/start/vim-unimpaired" })
  table.insert(plugns, { dir = "~/.vim/plugs/embrace-vim/start/vim-webopen" })
end

-- ISOFF/2025-01-21: Disabled plugins:
--
--   table.insert(plugns, { dir = "~/.vim/plugs/landonb/opt/vim-markdown" })

return plugns

