local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- キーコンフィグ
config.leader = {
	key = "Space",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

config.keys = {
	-- コマンドパレットを開く
	{
		mods = "LEADER",
		key = "p",
		action = act.ActivateCommandPalette,
	},
	-- 新しいタブを開く
	{
		mods = "LEADER",
		key = "o",
		action = act.ShowLauncher,
	},
	-- ランチャーメニューを開く
	{
		mods = "LEADER",
		key = "n",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- ペイン操作
	{
		mods = "LEADER",
		key = "s",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "v",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- ペインを移動
	{
		mods = "LEADER",
		key = "l",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "h",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = act.ActivatePaneDirection("Up"),
	},
	-- タブを移動
	{
		mods = "LEADER",
		key = "L",
		action = act.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "H",
		action = act.ActivateTabRelative(-1),
	},
	-- ペインを閉じる
	{
		mods = "LEADER",
		key = "c",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	-- タブを閉じる
	{
		mods = "LEADER|CTRL",
		key = "c",
		action = act.CloseCurrentTab({ confirm = false }),
	},
}
