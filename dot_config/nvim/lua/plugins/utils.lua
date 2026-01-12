return {
	-- アイコンプラグイン
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	-- UIコンポーネントライブラリ
	{ "MunifTanjim/nui.nvim", lazy = true },
	-- 便利ライブラリ
	{ "nvim-lua/plenary.nvim", lazy = true },
	-- インデントを強調表示
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			chunk = {
				enable = true,
				duration = 0,
				delay = 0,
			},
			indent = {
				enable = true,
				delay = 0,
			},
		},
	},
	-- 通知を表示
	{
		"rcarriga/nvim-notify",
		config = function()
			---@diagnostic disable-next-line: assign-type-mismatch
			vim.notify = require("notify")
		end,
	},
	-- 存在しないディレクトリを自動で作成
	{
		"jghauser/mkdir.nvim",
		event = { "BufWritePre", "FileWritePre" },
	},
	-- 括弧などを自動で閉じる
	{
		"cohama/lexima.vim",
		event = "InsertEnter",
		init = function()
			vim.g.lexima_ctrlh_as_backspace = 1
			vim.g.lexima_no_default_rules = 1
		end,
	},
	-- 囲い文字を上手く扱えるように
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},
	-- 範囲選択を補助
	{
		"atusy/treemonkey.nvim",
		keys = {
			{
				"m",
				function()
					require("treemonkey").select({ ignore_injections = false })
				end,
				mode = { "x", "o" },
				desc = "Select block",
			},
		},
		lazy = true,
		config = function()
			require("denops-lazy").load("treemonkey.nvim")
		end,
	},
	-- バッファを正面に表示してくれる
	{
		"shortcuts/no-neck-pain.nvim",
		version = false,
		keys = {
			{ "<C-w>m", "<cmd>NoNeckPain<CR>", desc = "Move window to center" },
		},
	},
	{
		"thinca/vim-qfreplace",
		lazy = true,
		keys = {
			{ "<Leader>Q", "<cmd>Qfreplace<CR>", desc = "Replace in quickfix" },
		},
	},
	{
		"ysmb-wtsg/in-and-out.nvim",
		keys = {
			{
				"<M-m>",
				function()
					require("in-and-out").in_and_out()
				end,
				mode = "i",
			},
		},
	},
}
