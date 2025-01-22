-- vim:tw=0:ts=2:sw=2:et:ai:ft=lua
-- Author: Landon Bouma <https://tallybark.com/>
-- Project: https://github.com/DepoXy/depoxy#🍯
-- License: MIT

-- ------------------------------------------------------------

-- USYNC/2025-01-21: This file matches related config project order:
--
--   meld ~/.depoxy/ambers/home/.config/nvim/lua/plugins/spec-lsp.lua \
--     ~/.vim/plugs/DepoXy/start/vim-depoxy/autoload/depoxy/plug_lsp &
--
--   meld ~/.depoxy/ambers/home/.config/nvim/lua/plugins/spec-lsp.lua \
--     ~/.depoxy/ambers/home/.vim/_mrconfig-lsp &

-- ------------------------------------------------------------

return {
  -- { dir = "~/.vim/plugs/prabirshrestha/opt/vim-lsp" },
  -- { dir = "~/.vim/plugs/prabirshrestha/opt/async.vim" },
  -- { dir = "~/.vim/plugs/mattn/opt/vim-lsp-settings" },
  -- { dir = "~/.vim/plugs/prabirshrestha/opt/asyncomplete.vim" },
  -- { dir = "~/.vim/plugs/prabirshrestha/opt/asyncomplete-lsp.vim" },
  -- { dir = "~/.vim/plugs/ryanolsonx/opt/vim-lsp-typescript" },
  -- { dir = "~/.vim/plugs/ryanolsonx/opt/vim-lsp-javascript" },
  { dir = "~/.vim/plugs/neoclide/start/coc.nvim" },
  { dir = "~/.vim/plugs/neoclide/start/coc-tsserver" },
  { dir = "~/.vim/plugs/neoclide/start/coc-json" },
}

