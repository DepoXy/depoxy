-- vim:tw=0:ts=2:sw=2:et:ai:ft=lua
-- Author: Landon Bouma <https://tallybark.com/>
-- Project: https://github.com/DepoXy/depoxy#🍯
-- THANX: https://patorjk.com/software/taag/#p=display&f=Isometric3&t=DPXYNVIM

local obj = {}

---@param string? ...
-- profile = "maximal", ---@type "minimal" | "midimal" | "maximal"
function obj:profile(profile)
  print("obj:profile: profile-client: " .. profile)

  local minimal = profile == "minimal"
  local midimal = profile == "midimal"
  local maximal = profile == "maximal"

  local lazy_profile = {
    ["vim-depoxy"] = not minimal,
    ["vim-trap"] = not minimal,
  }

  return lazy_profile
end

return obj
