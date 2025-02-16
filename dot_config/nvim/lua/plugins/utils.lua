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
	-- chzmoi
	{
		"xvzc/chezmoi.nvim",
		lazy = true,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>.",
				function()
					vim.cmd("cd" .. vim.g.chezmoidir)
					require("telescope").extensions.chezmoi.find_files()
				end,
				desc = "Find chezmoi files",
			},
		},
		-- chezmoiのファイルを開いたらこのプラグインを読み込む
		event = "BufReadPre " .. vim.g.chezmoidir .. "/*",
		opts = function()
			-- chezmoiのファイルを開いたら編集モードにする
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = { vim.g.chezmoidir .. "/*" },
				callback = function(ev)
					local bufnr = ev.buf
					local edit_watch = function()
						require("chezmoi.commands.__edit").watch(bufnr)
					end
					vim.schedule(edit_watch)
				end,
			})

			-- telescope.nvim
			local telescope = require("telescope")
			telescope.load_extension("chezmoi")
			return {
				edit = {
					watch = true,
				},
			}
		end,
	},
	-- セッションを自動保存
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = function()
			local set = vim.keymap.set
			-- セッションの保存
			set("n", "<Leader>ss", ":SessionSave ", { desc = "Save session" })
			-- セッションの読み込み
			set("n", "<Leader>fss", ":Autosession search<CR>", { desc = "Load session" })
			-- セッションの削除
			set("n", "<Leader>fsd", ":Autosession delete<CR>", { desc = "Delete session" })

			local add = require("plugins.which-key.spec").add
			add({
				mode = "n",
				{ "<Leader>s", group = "session" },
			})
			add({
				mode = "n",
				{ "<Leader>fs", group = "session" },
			})
			return {
				allowed_dirs = {
					"~/dev",
				},
			}
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
		end,
	},
	-- 囲い文字を上手く扱えるように
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},
	-- 検索補助
	{
		"kevinhwang91/nvim-hlslens",
		keys = {
			{
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				desc = "Search next",
			},
			{
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			},
			{ "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
			{ "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
			{ "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
			{ "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
		},
		opts = {},
	},
}
