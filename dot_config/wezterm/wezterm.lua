local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = wezterm.config_builder()

config.font = wezterm.font({ family = 'Liga SFMono Nerd Font' })
config.font_size = 13

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.colors = {
  tab_bar = {
    background = '#111',
    inactive_tab = {
      bg_color = '#111',
      fg_color = '#999',
    },
    inactive_tab_hover = {
      bg_color = '#333',
      fg_color = '#ccc',
      italic = false,
    },
    new_tab = {
      bg_color = '#111',
      fg_color = '#999',
    },
    new_tab_hover = {
      bg_color = '#333',
      fg_color = '#ccc',
      italic = false,
    },
  }
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Enable Option key text insertion, see https://github.com/wez/wezterm/issues/3866
config.send_composed_key_when_left_alt_is_pressed = true

config.window_close_confirmation = 'NeverPrompt'

config.native_macos_fullscreen_mode = true

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

return config
