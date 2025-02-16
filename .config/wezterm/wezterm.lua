local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font 'UDEV Gothic 35NF'
config.font_size = 14.0

-- SKK
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'

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

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- cp ~/.config/wezterm/wezterm.lua /mnt/c/Users/sbdn/.config/wezterm/
  config.default_domain = 'WSL:Debian'
  config.font_size = 10.0
  config.window_decorations = "RESIZE"
end

return config
