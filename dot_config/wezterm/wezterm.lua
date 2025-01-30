local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 設定のホットリロード
config.automatically_reload_config = true

-- 日本語入力を出来るようにする
config.use_ime = true

config.color_schemes = {
	["Tokyo Night"] = {
		background = "black",
	},
}

-- フォント設定
config.font = wezterm.font_with_fallback({
	{ family = "Moralerspace Argon HWNF" },
})
config.font_size = 13

-- Launcher Menu
config.launch_menu = {
	{
		label = "WSL2 Ubuntu",
		args = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" },
	},
	{
		label = "PowerShell",
		args = { "pwsh", "-nol", "-wd", "~" },
	},
}

-- デフォルト起動シェルの設定
config.default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" }
-- 背景の透明度
config.window_background_opacity = 0.80

-- ウィンドウを閉じる確認をしない
config.window_close_confirmation = "NeverPrompt"

-- マウス操作の挙動設定
config.mouse_bindings = {
	-- 右クリックでクリップボードから貼り付け
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

-- タブの見た目
config.use_fancy_tab_bar = false
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		-- theme = "catppuccin-mocha",
		theme = "cyberpunk",
		-- theme = "Cobalt Neon",
		section_separators = {
			left = wezterm.nerdfonts.ple_upper_left_triangle,
			right = wezterm.nerdfonts.ple_lower_right_triangle,
		},
		component_separators = {
			left = wezterm.nerdfonts.ple_forwardslash_separator,
			right = wezterm.nerdfonts.ple_forwardslash_separator,
		},
		tab_separators = {
			left = wezterm.nerdfonts.ple_upper_left_triangle,
			right = wezterm.nerdfonts.ple_lower_right_triangle,
		},
		color_overrides = {
			tab = {
				active = { fg = "#091833", bg = "#59c2c6" },
			},
		},
	},
	sections = {
		tab_active = {
			"index",
			{ "process", padding = { left = 0, right = 1 } },
			"",
			{ "cwd", padding = { left = 1, right = 0 } },
			{ "zoomed", padding = 1 },
		},
		tab_inactive = {
			"index",
			{ "process", padding = { left = 0, right = 1 } },
			"󰉋",
			{ "cwd", padding = { left = 1, right = 0 } },
			{ "zoomed", padding = 1 },
		},
	},
})

return config
