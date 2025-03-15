vim.g.chezmoidir = os.getenv("HOME") .. "/.local/share/chezmoi"
return {
	-- アイコンプラグイン
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	-- UIコンポーネントライブラリ
	{ "MunifTanjim/nui.nvim", lazy = true },
	-- 便利ライブラリ
	{ "nvim-lua/plenary.nvim", lazy = true },
	-- Vimの対応言語を増やし、ハイライト・インデント・ファイルタイプの検出機能を拡張するプラグイン
	{ "sheerun/vim-polyglot", event = { "BufReadPre", "BufNewFile" } },
	-- syntax highlightなどをいい感じにするプラグイン
	{
		-- 何もしなくても vim-polyglot といい感じに連携してくれる
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
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
	-- ステータスラインをカスタマイズ
	{
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
	-- 通知を表示
	{
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
				"<leader>fc",
				function()
					require("telescope").extensions.chezmoi.find_files()
				end,
				desc = "Find chezmoi files",
			},
		},
		cmd = {
			"Telescope chezmoi",
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

			return {
				edit = {
					watch = true,
				},
				telescope = {
					select = { "<CR>", "<C-v>" },
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
			set("n", "<Leader>fss", "<cmd>Autosession search<CR>", { desc = "Load session" })
			-- セッションの削除
			set("n", "<Leader>fsd", "<cmd>Autosession delete<CR>", { desc = "Delete session" })

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
				desc = "Search previous",
			},
			{
				"*",
				[[*<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Search word under cursor",
			},
			{
				"#",
				[[#<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Search word under cursor backward",
			},
			{
				"g*",
				[[g*<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Search word under cursor (whole word)",
			},
			{
				"g#",
				[[g#<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Search word under cursor backward (whole word)",
			},
		},
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
			require("denops-lazy").load("treemonkey")
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
