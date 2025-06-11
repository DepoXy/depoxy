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
-- CXREF: Runs gvim or nvim (See: GVIM_OPEN_PREFER_NVIM=true):
-- ~/.kit/sh/gvim-open-kindness/bin/gvim-open-kindness
-- ~/.depoxy/running/home/.config/depoxy/depoxyrc

gvim_open_kindness = function(path)
  -- stylua: ignore
  local task = hs.task.new("/bin/dash", nil, function()
    return false
  end, {
    "-c",
    [[
      [ -f ~/.config/depoxy/depoxyrc ] \
      && . ~/.config/depoxy/depoxyrc \
      && "${SHOILERPLATE:-${DOPP_KIT:-${HOME}/.kit}/sh}/gvim-open-kindness/bin/gvim-open-kindness" \
        -- "]] .. path .. [["
    ]],
  })
  task:start()
end

-------

-- MacVim Docs — Systemwide — Open Unicode One-Sheet (Cmd-u)
-- - CXREF: ~/.kit/txt/emoji-lookup/emoji-lookup.rst

-- BNDNG: <Cmd-U>
local cmd_u = hs.hotkey.bind({ "cmd" }, "U", function()
  gvim_open_kindness("${DOPP_KIT:-${HOME}/.kit}/txt/emoji-lookup/emoji-lookup.rst")
end)

-------

-- Systemwide — Foreground “dob” window (Cmd-d)
-- - CXREF: ~/.depoxy/ambers/bin/macOS/launchers/alacritty-front-window-dob.osa

-- BNDNG: <Cmd-D>
local cmd_d = hs.hotkey.bind({ "cmd" }, "D", function()
  local dob_window = hs.window.find("dob edit")

  if not dob_window then
    -- SAVVY: The window title is controlled by Homefries:
    --   tmux_conf_theme_terminal_title='#T ┇ #{=3:session_name}'
    -- - CXREF: ~/.kit/sh/home-fries/.tmux.conf.local
    dob_window = hs.window.find("┇ ham")
  end

  if dob_window then
    local front_win = hs.window.frontmostWindow()

    -- See also: front_win:id() ~= dob_window:id()
    if front_win ~= dob_window then
      dob_window:raise():focus()
    else
      front_win:minimize()
    end
  end
end)

-------

-- skhdrc config
-- - CXREF: ~/.kit/mOS/macOS-skhibidirc/.config/skhd/skhdrc
--
-- ISOFF/2024-07-24: `skhdrc` is (mostly) deprecated.
-- - It's useful for at least <Cmd-Tab> binding, which Hammerspoon won't let you hook.
--
--     hs.hotkey.bind({"shift", "cmd"}, "R", function()
--       gvim_open_kindness("${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-skhibidirc/.config/skhd/skhdrc")
--     end)

-- *** Hammerspoon config files

-- Meta (main macOS-Hammyspoony config)
--
-- - CXREF: ~/.kit/mOS/macOS-Hammyspoony/.hammerspoon/init.lua

-- BNDNG: <Shift-Alt-R>
local shift_alt_r = hs.hotkey.bind({ "shift", "alt" }, "R", function()
  gvim_open_kindness(
    "${MOSREPOSPATH:-${DOPP_KIT:-${HOME}/.kit}/mOS}/macOS-Hammyspoony/.hammerspoon/init.lua"
  )
end)

-- More meta (CXREF: this file)

-- BNDNG: <Shift-Cmd-R>
local shift_cmd_r = hs.hotkey.bind({ "shift", "cmd" }, "R", function()
  gvim_open_kindness(
    "${DEPOXYAMBERS_DIR:-${HOME}/.depoxy/ambers}/home/.hammerspoon/depoxy-hs.lua"
  )
end)

ignore_hotkey_slack(shift_cmd_r)

-- Client config
--
-- - CXREF: ~/.depoxy/running/home/.hammerspoon/client-hs.lua

-- BNDNG: <Shift-Ctrl-R>
local shift_ctrl_r = hs.hotkey.bind({ "shift", "ctrl" }, "R", function()
  gvim_open_kindness(
    "${DEPOXYDIR_RUNNING_FULL:-${HOME}/.depoxy/running}/home/.hammerspoon/client-hs.lua"
  )
end)

ignore_hotkey_slack(shift_ctrl_r)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- KLUGE: Enable <Shift-Ctrl> MacVim bindings.
-- - Aka: Hammerspoon substitutions for MacVim.
-- - Normally MacVim, like most terminals, doesn't distinguish
--   between <Ctrl-{key}> and <Shift-Ctrl-{key}>, but we can
--   replace <Shift-Ctrl> bindings with special Unicode characters
--   that we can then capture in Vim using `map` commands.
-- - Super esoteric, but lets you map <Shift-Ctrl> keys, ha.
-- - CXREF: See Alacritty substitutions for terminal `vim`:
--     ~/.depoxy/ambers/home/.config/alacritty/alacritty.toml
-- - CXREF: See associated Vim maps:
--     ~/.kit/nvim/DepoXy/start/vim-depoxy/plugin/vim-shift-ctrl-bindings.vim

local neovide_macvim_get_eventtap = function()
  return hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
    -- USAGE: Uncomment to debug/pry (see Hammyspoony for tableJoin def):
    --    local unmodified = false
    --    hs.alert.show("CHARS: " .. e:getCharacters(unmodified))
    --    hs.alert.show("FLAGS: " .. tableJoin(e:getFlags(), ", "))
    --    hs.alert.show("KEYCD: " .. e:getKeyCode())

    -- Returns true to delete original event, followed by the new event.
    if e:getFlags():containExactly({ "shift", "ctrl" }) then
      if false then

        -- Note that generating a new key event using the integer
        -- character value doesn't work, e.g., where 0xE003 = 57347:
        --    return true, {hs.eventtap.event.newKeyEvent(57347, true)}  -- WRONG
        -- Fortunately we can setUnicodeString() on the current event
        -- using the literal character, and then return it.

        -- <Shift-Ctrl-D> Indent line (Insert mode, to match <Ctrl-D> dedent;
        --                             Normal mode <C-d> pages down)
      elseif e:getKeyCode() == hs.keycodes.map["d"] then
        -- Use user Unicode character 0xE003
        -- - Then in Vimrc, e.g.,
        --    inoremap  <C-O>:call ...
        return true, { e:setUnicodeString("") }

      -- <Shift-Ctrl-E> Scrolls up one character (both modes)
      elseif e:getKeyCode() == hs.keycodes.map["e"] then
        -- Use user Unicode character 0xE014
        return true, { e:setUnicodeString("") }

      -- <Shift-Ctrl-S> Save File w/out Formatting (both modes)
      elseif e:getKeyCode() == hs.keycodes.map["s"] then
        -- Use user Unicode character 0xE012
        return true, { e:setUnicodeString("") }

      -- <Shift-Ctrl-U> Scrolls down one page (both modes)
      elseif e:getKeyCode() == hs.keycodes.map["u"] then
        -- Use user Unicode character 0xE014
        return true, { e:setUnicodeString("") }

      -- <Shift-Ctrl-W> Delete-to-beginning-of-line (both modes)
      elseif e:getKeyCode() == hs.keycodes.map["w"] then
        -- Use user Unicode character 0xE016
        return true, { e:setUnicodeString("") }

      -- <Shift-Ctrl-\> (Neo)vim MRU window (both modes)
      elseif e:getKeyCode() == hs.keycodes.map["\\"] then
        -- Use user Unicode character 0xE01C
        return true, { e:setUnicodeString("") }
      end
    elseif e:getFlags():containExactly({ "ctrl" }) then
      if false then

      -- <Ctrl-;> :BufferRingBackward
      elseif e:getKeyCode() == hs.keycodes.map[";"] then
        -- Use PUA Unicode character 0xE01A
        return true, { e:setUnicodeString("") }

      -- <Ctrl-'> :BufferRingForward
      elseif e:getKeyCode() == hs.keycodes.map["'"] then
        -- Use PUA Unicode character 0xE01B
        return true, { e:setUnicodeString("") }
      end
    end

    -- Return false to propagate event.
    return false
  end)
end

appTapAttach:registerApptap("MacVim", neovide_macvim_get_eventtap)

appTapAttach:registerApptap("neovide", neovide_macvim_get_eventtap)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Application blocklist: Blanket hotkey disablement for select apps.

local allHotkeys = {
  -- Individual hs.hotkey.bind() objects from above
  cmd_u,
  cmd_d,
  shift_alt_r,
  shift_cmd_r,
  shift_ctrl_r,
}

appTapDisableHotkeys:registerHotkeys(allHotkeys)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
