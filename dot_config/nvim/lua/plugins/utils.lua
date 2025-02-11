return {
	-- 日本語ドキュメント
	{ "vim-jp/vimdoc-ja" },
	{
		-- アイコンプラグイン
		-- 前提ライブラリ
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},
	{
		-- UIコンポーネントライブラリ
		-- 前提ライブラリ
		"MunifTanjim/nui.nvim",
		lazy = true,
	},
	-- Vimの対応言語を増やし、ハイライト・インデント・ファイルタイプの検出機能を拡張するプラグイン
	{ "sheerun/vim-polyglot" },
	{
		-- syntax highlightなどをいい感じにするプラグイン
		-- vim-polyglotといい感じに併用してくれる
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})

			-- 折り畳みの設定
			local opt = vim.opt
			opt.foldmethod = "expr"
			opt.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	},
	{
		-- インデントを強調表示
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
	{
		-- ステータスラインをカスタマイズ
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "auto",
				disabled_filetypes = {
					"neo-tree",
				},
			},
		},
	},
	{
		-- 通知を表示
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
}
