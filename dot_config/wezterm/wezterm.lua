local wezterm = require("wezterm")
local config = wezterm.config_builder()
local keybinds = require("keybinds")
local autocmd = require("autocmd")

-- 設定のホットリロード
config.automatically_reload_config = true

-- 日本語入力を出来るようにする
config.use_ime = true

-- キーバインドを設定
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables
config.leader = keybinds.leader

-- マウス操作の挙動設定
config.mouse_bindings = {
	-- 右クリックでクリップボードから貼り付け
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

config.color_schemes = {
	["Tokyo Night"] = {
		background = "black",
	},
}

-- フォント設定
config.font = wezterm.font_with_fallback({
	{
		family = "Moralerspace Argon HWNF",
	},
	"MonaspiceAr NF",
})
config.font_size = 13

-- Launcher Menu
config.launch_menu = {
	{
		label = "WSL:Ubuntu",
		domain = { DomainName = "WSL:Ubuntu" },
	},
	{
		label = "PowerShell",
		args = { "pwsh", "-nol", "-wd", "~" },
		domain = { DomainName = "local" },
	},
}
config.wsl_domains = {
	{
		name = "WSL:Ubuntu",
		distribution = "Ubuntu",
		default_cwd = "~",
		default_prog = { "zsh" },
	},
}
-- デフォルト起動ドメインの設定
config.default_domain = "WSL:Ubuntu"
-- デフォルト起動シェルの設定
config.default_prog = { "pwsh", "-nol", "-wd", "~" }

-- 背景の透明度
config.window_background_opacity = 0.80

-- ウィンドウを閉じる確認をしない
config.window_close_confirmation = "NeverPrompt"

-- タブの見た目
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.status_update_interval = 500

-- 自動実行
for _, cmd in pairs(autocmd) do
	wezterm.on(cmd.event_name, cmd.callback)
end

return config
