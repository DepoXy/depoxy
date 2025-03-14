-- vim:tw=0:ts=2:sw=2:et:ai:ft=lua
-- Author: Landon Bouma <https://tallybark.com/>
-- Project: https://github.com/DepoXy/depoxy#🍯

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- COPYD:
-- ~/.kit/nvim/DepoXy/start/vim-depoxy/plugin/depoxy-config--set-tags.vim

-- Load ~~Exuberant~~ Universal Ctags tags file for DepoXy sources.
--
-- - I.e., for the dozens (100s?) of project symlinks under ~/.projlns:
--
--   ~/.projlns/depoxy-deeplinks (aka $DEPOXY_PROJLNS_DEPOXY)
--
-- Default |'tags'| values:
-- - Vim:
--     tags=./tags,tags
-- - Neovim:
--     tags=./tags;,tags
--   - DUNNO: Docs don't mention what the semicolon means.
-- - Per './tags', looks first for tags file adjacent to current file,
--   then per 'tags', a tags file in current working directory. Though
--   in normal DepoXy usage, you won't find either such file (unless
--   you add your own).
-- - DepoXy adds the ~/.projlns/depoxy/deep-links/tags file last.
--
-- CXREF: The ~/.projlns 'tags' file is created on `mr -d / infuse`:
--   infuse_projects_links_core_generate_ctags
--     ~/.depoxy/ambers/home/.projlns/infuse-projlns-core.sh
-- - Note that even with modern LSP tooling, the DepoXy tags file still has
--   merit, especially for intra-project shell and Vimscript functions.
--
function SetTagsProjlnsDepoxydeeplinks()
  local ctags_file = vim.env.HOME .. "/.projlns/depoxy-deeplinks/tags"

  local do_alert = false
  if vim.env.DEPOXY_PROJLNS_DEPOXY then
    ctags_file = vim.env.DEPOXY_PROJLNS_DEPOXY .. "/tags"

    do_alert = true
  end

  if vim.uv.fs_stat(ctags_file) then
    vim.opt.tags:append(ctags_file)
  elseif do_alert then
    -- LOPRI: Use newer notification system, vim.notify, etc.
    print("ALERT: Missing tags file (DEPOXY_PROJLNS_DEPOXY): " .. ctags_file)
  end
end

SetTagsProjlnsDepoxydeeplinks()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- CXREF: Optional private user config (i.e., from DepoXy Client):
-- ~/.depoxy/running/home/.kit/nvim/landonb/nvim-lazyb/lua/config/options-private.lua
pcall(function()
  require("config.options-private").setup()
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
