-- vim:tw=0:ts=2:sw=2:et:ai:ft=lua
-- Author: Landon Bouma <https://tallybark.com/>
-- Project: https://github.com/DepoXy/depoxy#🍯
-- License: MIT

-- COPYD: https://lazy.folke.io/installation

-- USAGE: Create plugin specs in ~/.config/nvim/lua/plugins/
--
-- - Each file returns a table with the plugins to install.
--
-- - CXREF:
--
--    ~/.config/nvim/lua/plugins/spec.lua
--    ~/.config/nvim/lua/plugins/spec-dubs.lua
--
-- REFER: ~/.config/nvim per: :echo stdpath('config')

-- SETUP: After installation, run:
--
--    :checkhealth lazy

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  -- REFER: On macOS (& prob. Linux), installs to:
  --   ~/.local/share/nvim/lazy/lazy.nvim/
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- REFER: https://github.com/ntk148v/habamax.nvim
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

