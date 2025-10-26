local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font configuration
config.font = wezterm.font('Hack')
config.font_size = 18.0
config.max_fps = 120

-- Color scheme - Tokyo Night theme
config.color_scheme = 'Tokyo Night Storm'

-- Window and appearance
config.window_decorations = "TITLE | RESIZE"
config.macos_window_background_blur = 0
config.cursor_blink_rate = 0
config.native_macos_fullscreen_mode = true


-- Tab bar configuration
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.colors = {
  tab_bar = {
    background = '#1a1b26',
    active_tab = {
      bg_color = '#7aa2f7',
      fg_color = '#1a1b26',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#32344a',
      fg_color = '#9ece6a',
    },
    inactive_tab_hover = {
      bg_color = '#32344a',
      fg_color = '#9ece6a',
    },
    new_tab = {
      bg_color = '#1a1b26',
      fg_color = '#9ece6a',
    },
    new_tab_hover = {
      bg_color = '#32344a',
      fg_color = '#9ece6a',
    },
  },
}

-- Disable audio bell
config.audible_bell = "Disabled"

-- Window padding and borders
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Mouse
config.hide_mouse_cursor_when_typing = true

-- Scrollback
config.scrollback_lines = 10000

-- Performance
config.max_fps = 120
config.animation_fps = 60

-- Key bindings
local act = wezterm.action
-- config.leader = { key = 'a', mods = 'CMD', timeout_milliseconds = 1000 }

config.disable_default_key_bindings = true
config.keys = {
  -- Clipboard
  { key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },

  -- Scrolling
--   { key = 'k', mods = 'CMD', action = act.ScrollByLine(-1) },
--   { key = 'j', mods = 'CMD', action = act.ScrollByLine(1) },

  -- Window management
  { key = 'Enter', mods = 'CMD', action = act.SpawnWindow },
  { key = 'n', mods = 'CMD', action = act.SpawnWindow },
  { key = ']', mods = 'CMD', action = act.ActivatePaneDirection 'Next' },
  { key = '[', mods = 'CMD', action = act.ActivatePaneDirection 'Prev' },
  { key = 'f', mods = 'CMD', action = act.RotatePanes 'Clockwise' },
  { key = 'b', mods = 'CMD', action = act.RotatePanes 'CounterClockwise' },

  -- Window selection by number
  { key = '1', mods = 'CMD', action = act.ActivateTab(0) },
  { key = '2', mods = 'CMD', action = act.ActivateTab(1) },
  { key = '3', mods = 'CMD', action = act.ActivateTab(2) },
  { key = '4', mods = 'CMD', action = act.ActivateTab(3) },
  { key = '5', mods = 'CMD', action = act.ActivateTab(4) },
  { key = '6', mods = 'CMD', action = act.ActivateTab(5) },
  { key = '7', mods = 'CMD', action = act.ActivateTab(6) },
  { key = '8', mods = 'CMD', action = act.ActivateTab(7) },
  { key = '9', mods = 'CMD', action = act.ActivateTab(8) },
  { key = '0', mods = 'CMD', action = act.ActivateTab(9) },

  -- Tab management
  { key = 'l', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
  { key = 'h', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = '.', mods = 'CMD|SHIFT', action = act.MoveTabRelative(1) },
  { key = ',', mods = 'CMD|SHIFT', action = act.MoveTabRelative(-1) },
  { key = 't', mods = 'CMD|SHIFT', action = act.PromptInputLine {
    description = 'Enter new name for tab',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},

  -- Layout management
  { key = 's', mods = 'CMD', action = act.PaneSelect },

  -- Font size
  { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
  { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
  { key = 'Backspace', mods = 'CMD', action = act.ResetFontSize },
}

return config
