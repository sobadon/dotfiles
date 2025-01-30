local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font 'UDEV Gothic 35NF'
config.font_size = 14.0

config.keys = {
  -- Command + W -> Command + Shift + W
  {
    key = 'w',
    mods = 'CMD',
    action = 'DisableDefaultAssignment',
  },
  {
    key = 'w',
    mods = 'CMD|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

return config
