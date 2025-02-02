local wezterm = require("wezterm")
local act = wezterm.action

return {
	-- Ctrl-Spaceをリーダーキーに設定
	leader = {
		key = "Space",
		mods = "CTRL",
		timeout_milliseconds = 2000,
	},

	keys = {
		-- コマンドパレットを開く
		{ mods = "LEADER", key = "p", action = act.ActivateCommandPalette },
		-- 新しいタブを開く
		{ mods = "LEADER", key = "o", action = act.ShowLauncher },
		-- ランチャーメニューを開く
		{ mods = "LEADER", key = "n", action = act.SpawnTab("CurrentPaneDomain") },
		-- ペイン操作
		{ mods = "LEADER", key = "s", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ mods = "LEADER", key = "v", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		-- ペインを移動
		{ mods = "LEADER", key = "l", action = act.ActivatePaneDirection("Right") },
		{ mods = "LEADER", key = "h", action = act.ActivatePaneDirection("Left") },
		{ mods = "LEADER", key = "j", action = act.ActivatePaneDirection("Down") },
		{ mods = "LEADER", key = "k", action = act.ActivatePaneDirection("Up") },
		-- タブを移動
		{ mods = "LEADER|CTRL", key = "l", action = act.ActivateTabRelative(1) },
		{ mods = "LEADER|CTRL", key = "h", action = act.ActivateTabRelative(-1) },
		-- ペインを閉じる
		{ mods = "LEADER", key = "c", action = act.CloseCurrentPane({ confirm = false }) },
		-- タブを閉じる
		{ mods = "LEADER|CTRL", key = "c", action = act.CloseCurrentTab({ confirm = false }) },
    -- スクロールモードに移行
		{ mods = "LEADER", key = "S", action = act.ActivateKeyTable({
        name = "scroll",
        one_shot = false,
      })
    },
	},

  key_tables = {
    -- スクロールモードで
    scroll = {
      { key = "u", action = act.ScrollByPage(-0.5) },
      { key = "d", action = act.ScrollByPage(0.5) },
  }
  },
}
