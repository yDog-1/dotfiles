return {
	-- 日本語ドキュメント
	{
		"vim-jp/vimdoc-ja",
		event = "VeryLazy",
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
