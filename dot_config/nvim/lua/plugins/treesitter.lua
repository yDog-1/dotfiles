return {
	-- syntax highlightなどをいい感じにするプラグイン
	{
		-- 何もしなくても vim-polyglot といい感じに連携してくれる
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			-- treesitter を利用した textobject を追加する
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				textobjects = {
					swap = {
						enable = true,
						swap_next = {
							["g>"] = "@parameter.inner",
						},
						swap_previous = {
							["g<"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]]"] = { query = "@class.outer", desc = "Next class start" },

							-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
							["]o"] = "@loop.*",
							-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }

							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})

			-- 折り畳みの設定
			local opt = vim.opt
			opt.foldmethod = "expr"
			opt.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	},
}
