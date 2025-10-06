-- vim:tw=0:ts=2:sw=2:et:ai:ft=lua
-- Author: Landon Bouma <https://tallybark.com/>
-- Project: https://github.com/DepoXy/depoxy#🍯
-- THANX: https://patorjk.com/software/taag/#p=display&f=Isometric3&t=DPXYNVIM

--      _____          ___         ___                       ___                                    ___
--     /  /::\        /  /\       /__/|          ___        /__/\          ___        ___          /__/\
--    /  /:/\:\      /  /::\     |  |:|         /__/|       \  \:\        /__/\      /  /\        |  |::\
--   /  /:/  \:\    /  /:/\:\    |  |:|        |  |:|        \  \:\       \  \:\    /  /:/        |  |:|:\
--  /__/:/ \__\:|  /  /:/~/:/  __|__|:|        |  |:|    _____\__\:\       \  \:\  /__/::\      __|__|:|\:\
--  \  \:\ /  /:/ /__/:/ /:/  /__/::::\____  __|__|:|   /__/::::::::\  ___  \__\:\ \__\/\:\__  /__/::::| \:\
--   \  \:\  /:/  \  \:\/:/      ~\~~\::::/ /__/::::\   \  \:\~~\~~\/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/
--    \  \:\/:/    \  \::/        |~~|:|~~     ~\~~\:\   \  \:\  ~~~  \  \:\|  |:|     \__\::/  \  \:\
--     \  \::/      \  \:\        |  |:|         \  \:\   \  \:\       \  \:\__|:|     /__/:/    \  \:\
--      \__\/        \  \:\       |  |:|          \__\/    \  \:\       \__\::::/      \__\/      \  \:\
--                    \__\/       |__|/                     \__\/           ~~~~                   \__\/

return {
  -- vim-depoxy configures plugin settings (which is how author
  -- configured plugins before adopting a proper plugin manager).
  --
  -- LATER/2025-02-01: Integrate vim-depoxy into nvim-depoxy
  -- (using lazy.nvim and Lua conventions to setup maps, etc.).
  -- - Then remove vim-depoxy here, but keep for Vim instances...
  --   though remains to be seen how much I'll use Vim classic.
  {
    dir = "~/.kit/nvim/DepoXy/start/vim-depoxy",
    lazy = not lazy_profile["vim-depoxy"],
    dependencies = {
      -- { dir = "~/.kit/nvim/embrace-vim/start/vim-fullscreen-toggle" },
      { dir = "~/.kit/nvim/embrace-vim/start/vim-webopen" },
    },
    init = function()
      -- Inhibit vim-depoxy from wiring vim-fullscreen-toggle
      vim.g.loaded_vim_depoxy_fullscreen_toggle_config = 1

      -- Inhibit alert message.
      vim.g.loaded_vim_depoxy_async_map_config = 1
    end,
  },

  -- vim-trap is the user's private DepoXy Client plugin.
  -- - The DepoXy OMR `infuse` command creates the vim-trap symlink
  --   that targets user's ~/.depoxy/running/home/vim-trap/
  {
    dir = "~/.kit/nvim/DepoXy/start/vim-trap",
    lazy = not lazy_profile["vim-trap"],
    dependencies = {
      dir = "~/.kit/nvim/embrace-vim/start/vim-netrw-explore-map",
    },
  },
}
