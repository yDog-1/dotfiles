return {
	-- 日本語ドキュメント
	{
		"vim-jp/vimdoc-ja",
		event = "VeryLazy",
	},
	{
		"vim-skk/skkeleton",
		dependencies = {
			"vim-denops/denops.vim",
		},
		keys = {
			-- <C-j>, <C-k>でskkeletonの切り替え
			{ "<C-j>", "<Plug>(skkeleton-enable)", mode = { "i", "c", "t" } },
			{ "<C-k>", "<Plug>(skkeleton-disable)", mode = { "i", "c", "t" } },
		},
		lazy = true,
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "skkeleton-initialize-pre",
				desc = "skkeletonの初期設定",
				callback = function()
					vim.fn["skkeleton#config"]({
						globalDictionaries = {
							"~/.skk/SKK-JISYO.JIS2",
							"~/.skk/SKK-JISYO.JIS3_4",
							"~/.skk/SKK-JISYO.L",
							"~/.skk/SKK-JISYO.geo",
							"~/.skk/SKK-JISYO.jinmei",
							"~/.skk/SKK-JISYO.lisp",
							"~/.skk/SKK-JISYO.propernoun",
							"~/.skk/SKK-JISYO.station",
						},
						-- 候補選択メニューが出るまでの数
						showCandidatesCount = 2,
						-- Denoのインメモリキャッシュで高速化
						databasePath = "~/.cache/skkeleton/database.db",
						sources = { "deno_kv" },
						-- キャンセルの挙動
						immediatelyCancel = false,
					})
					vim.fn["skkeleton#register_kanatable"]("rom", {
						jj = "escape",
					})
				end,
			})
			require("denops-lazy").load("skkeleton", { wait_load = false })
		end,
	},
	-- skkeletonの入力中、右下にインジケータを表示
	{
		"delphinus/skkeleton_indicator.nvim",
		lazy = true,
		event = "User DenopsReady",
		branch = "v2",
		config = function()
			require("skkeleton_indicator").setup({
				zindex = 150,
			})
		end,
	},
	-- 日本語をローマ字で検索
	{
		"lambdalisue/vim-kensaku",
		dependencies = {
			"vim-denops/denops.vim",
		},
		lazy = true,
		config = function()
			require("denops-lazy").load("vim-kensaku", { wait_load = false })
		end,
	},
	-- 日本語対応モーション
	{
		"atusy/jab.nvim",
		dependencies = {
			"lambdalisue/vim-kensaku",
		},
		lazy = true,
		keys = {
			{
				";",
				function()
					return require("jab").jab_win()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"f",
				function()
					return require("jab").f()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"F",
				function()
					return require("jab").F()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"t",
				function()
					return require("jab").t()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
			{
				"T",
				function()
					return require("jab").T()
				end,
				mode = { "n", "x", "o" },
				expr = true,
			},
		},
	},
	-- W, E モーションを日本語対応

	{
		"atusy/budouxify.nvim",
		dependencies = {
			"atusy/budoux.lua",
		},
		keys = {
			{
				"W",
				function()
					local pos = require("budouxify.motion").find_forward({ head = true })
					if pos then
						vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
					end
				end,
				mode = { "n", "v" },
			},
			{
				"E",
				function()
					local pos = require("budouxify.motion").find_forward({ head = false })
					if pos then
						vim.api.nvim_win_set_cursor(0, { pos.row, pos.col })
					end
				end,
				mode = { "n", "v" },
			},
		},
	},
}
