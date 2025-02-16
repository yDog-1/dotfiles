return {
	{
		-- ファイルブラウザ
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		keys = {
			-- ネオツリーを開く
			{ "<Leader>e", ":Neotree filesystem reveal left<CR>", desc = "Open neotree" },
		},
		cmd = "Neotree",
		opts = {
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
			},
		},
	},
}
