vim.g.chezmoidir = os.getenv("HOME") .. "/.local/share/chezmoi"
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
			"ChezmoiReAdd",
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
						-- バッファが有効かチェック
						if vim.api.nvim_buf_is_valid(bufnr) then
							require("chezmoi.commands.__edit").watch(bufnr)
						end
					end
					-- より安全なタイミングで実行
					vim.defer_fn(edit_watch, 100) -- 100ms後に実行
				end,
			})

			-- ChezmoiReAdd コマンドを作成
			vim.api.nvim_create_user_command("ChezmoiReAdd", function()
				vim.fn.system("chezmoi re-add")
				vim.notify("Executed: chezmoi re-add", vim.log.levels.INFO)
			end, { desc = "Execute chezmoi re-add" })

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
		keys = {
			{ "<Leader>ss", ":SessionSave ", desc = "Save session" },
			{ "<Leader>sf", "<cmd>SessionSearch<CR>", desc = "Search session" },
			{ "<Leader>sd", "<cmd>Autosession delete<CR>", desc = "Delete session" },
			{ "<Leader>sr", "<cmd>SessionRestore<CR>", desc = "Restore session" },
		},
		opts = function()
			local add = require("plugins.which-key.spec").add
			add({
				mode = "n",
				{ "<Leader>s", group = "session" },
			})

			-- localoptionsを保存するようにし、ファイルタイプ等を復元できるようにする
			vim.opt.sessionoptions:append("localoptions")

			return {
				auto_save = true,
				suppressed_dirs = {
					"~/",
				},
				close_unsupported_windows = true,
				bypass_save_filetypes = {
					"codecompanion",
					"aider",
					"help", -- lazy loadingでプラグインが読み込まれる前にhelpは開けないので
				},
				use_git_branch = true,
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
	-- CTRL-A, CTRL-X の強化
	{
		"monaqa/dial.nvim",
		event = "BufReadPost",
		keys = {
			{
				"<C-a>",
				function()
					require("dial.map").manipulate("increment", "normal")
				end,
				desc = "Increment",
			},
			{
				"<C-x>",
				function()
					require("dial.map").manipulate("decrement", "normal")
				end,
				desc = "Decrement",
			},
			{
				"g<C-a>",
				function()
					require("dial.map").manipulate("increment", "gnormal")
				end,
				desc = "Increment",
			},
			{
				"g<C-x>",
				function()
					require("dial.map").manipulate("decrement", "gnormal")
				end,
				desc = "Decrement",
			},
			{
				"<C-a>",
				function()
					require("dial.map").manipulate("increment", "visual")
				end,
				mode = "v",
				desc = "Increment",
			},
			{
				"<C-x>",
				function()
					require("dial.map").manipulate("decrement", "visual")
				end,
				mode = "v",
				desc = "Decrement",
			},
			{
				"g<C-a>",
				function()
					require("dial.map").manipulate("increment", "gvisual")
				end,
				mode = "v",
				desc = "Increment",
			},
			{
				"g<C-x>",
				function()
					require("dial.map").manipulate("decrement", "gvisual")
				end,
				mode = "v",
				desc = "Decrement",
			},
		},
		config = function()
			local augend = require("dial.augend")
			local config = require("dial.config")
			local default = require("dial.config").augends:get("default")
			config.augends:register_group({
				default = vim.list_extend(default, {
					augend.constant.alias.bool,
					augend.paren.alias.quote,
				}),
			})
			config.augends:on_filetype({
				markdown = {
					augend.misc.alias.markdown_header,
				},
			})
		end,
	},
}
