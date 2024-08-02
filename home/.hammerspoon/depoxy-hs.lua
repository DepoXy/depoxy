-- vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=lua
-- Author: Landon Bouma <https://tallybark.com/>
-- Project: https://github.com/DepoXy/depoxy#🍯
-- License: MIT

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- CXREF:
--
--   ~/.kit/mOS/macOS-Hammyspoony/.hammerspoon/init.lua
--
--   ~/.depoxy/running/home/.hammerspoon/client-hs.lua

-- Uncomment to verify this file gets loaded:
--   hs.alert.show("DEPOXY Reporting!")

-------

-- Opens a path in GVim using `gvim-open-kindness`.
--
-- - The `. depoxyrc` lets us honor user environs,
--   like DOPP_KIT.
--
-- - We don't quote path, e.g.,
--
--     "]] .. path .. [["
--
--   so that tilde paths work, e.g.,
--
--     gvim_open_kindness("~/foo/bar")
--
-- CXREF: ~/.kit/sh/gvim-open-kindness/bin/gvim-open-kindness

gvim_open_kindness = function(path)
  local task = hs.task.new(
    "/bin/dash",
    nil,
    function() return false end,
    {
      '-c',
      [[
        [ -f ~/.config/depoxy/depoxyrc ] \
        && . ~/.config/depoxy/depoxyrc \
        && "${SHOILERPLATE:-${DOPP_KIT:-${HOME}/.kit}/sh}/gvim-open-kindness/bin/gvim-open-kindness" \
          ]] .. path .. [[
      ]],
    }
  )
  task:start()
end

-------

-- MacVim Docs — Systemwide — Open Unicode One-Sheet (Cmd-u)
-- - CXREF: ~/.kit/txt/emoji-lookup/emoji-lookup.rst

-- BNDNG: <Cmd-U>
hs.hotkey.bind({"cmd"}, "U", function()
  gvim_open_kindness("${DOPP_KIT:-${HOME}/.kit}/txt/emoji-lookup/emoji-lookup.rst")
end)

-- Systemwide — Foreground “dob” window (Cmd-d)
-- - CXREF: ~/.depoxy/ambers/bin/macOS/launchers/alacritty-front-window-dob.osa

-- BNDNG: <Cmd-D>
hs.hotkey.bind({"cmd"}, "D", function()
  -- MAYBE: Write function like `gvim_open_kindness` that sources depoxyrc,
  -- so could honor user path environs, e.g.,
  --
  --   depoxy_applescript_runner(
  --     "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}/bin/macOS/launchers/alacritty-front-window-dob.osa"
  --   )
  --
  -- For now, the path is hard-coded.
  hs.osascript.applescriptFromFile(
    os.getenv("HOME") .. "/.depoxy/ambers/bin/macOS/launchers/alacritty-front-window-dob.osa"
  )
end)

-- skhdrc config
-- - CXREF: ~/.kit/mOS/macOS-skhibidirc/.config/skhd/skhdrc
--
-- ISOFF/2024-07-24: `skhdrc` is (mostly) deprecated.
-- - It's useful for at least <Cmd-Tab> binding, which Hammerspoon won't let you hook.
--
--     hs.hotkey.bind({"shift", "cmd"}, "R", function()
--       gvim_open_kindness("${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-skhibidirc/.config/skhd/skhdrc")
--     end)

-- Meta (main macOS-Hammyspoony config)
--
-- - CXREF: ~/.kit/mOS/macOS-Hammyspoony/.hammerspoon/init.lua

-- BNDNG: <Shift-Alt-R>
hs.hotkey.bind({"shift", "alt"}, "R", function()
  gvim_open_kindness("${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-Hammyspoony/.hammerspoon/init.lua")
end)

-- More meta (this file)

-- BNDNG: <Shift-Cmd-R>
hs.hotkey.bind({"shift", "cmd"}, "R", function()
  gvim_open_kindness("${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}/home/.hammerspoon/depoxy-hs.lua")
end)

-- Client config
--
-- - CXREF: ~/.depoxy/running/home/.hammerspoon/client-hs.lua

-- BNDNG: <Shift-Ctrl-R>
hs.hotkey.bind({"shift", "ctrl"}, "R", function()
  gvim_open_kindness("${DEPOXYDIR_RUNNING_FULL:-${HOME}/.depoxy/running}/home/.hammerspoon/client-hs.lua")
end)


-------

