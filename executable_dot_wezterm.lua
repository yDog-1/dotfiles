-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- 日本語入力を出来るようにする
config.use_ime = true

-- Changing the color scheme:
config.color_scheme = 'Andromeda'

-- フォント設定
config.font = wezterm.font_with_fallback ({
  { family='Moralerspace Argon HWNF' },
})
config.font_size = 13

-- Launcher Menu
config.launch_menu = {
  {
    label = 'WSL2 Ubuntu',
    args = { 'wsl.exe', '-d', 'Ubuntu', '--cd', '~' }
  },
  {
    label = 'PowerShell',
    args = { 'pwsh', '-nol', '-wd', '~' }
  }
}

-- デフォルト起動シェルの設定
config.default_prog = { 'wsl.exe', '-d', 'Ubuntu', '--cd', '~' }
-- 背景の透明度
config.window_background_opacity = 0.80

-- ウィンドウを閉じる確認
config.window_close_confirmation = 'NeverPrompt'

-- マウス操作の挙動設定

config.mouse_bindings = {
-- 右クリックでクリップボードから貼り付け
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}
-- キーコンフィグ
config.keys = {
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.ShowLauncher,
  },
  {
    key = 'UpArrow',
    mods = 'CTRL',
    action = wezterm.action.ScrollToTop,
  },
  {
    key = 'DownArrow',
    mods = 'CTRL',
    action = wezterm.action.ScrollToBottom,
  }
}

-- and finally, return the configuration to wezterm
return config
