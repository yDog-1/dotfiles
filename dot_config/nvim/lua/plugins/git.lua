require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>g", group = "Git" },
})

require("plugins.which-key.spec").add({
	mode = "n",
	{ "<C-g>", proxy = "<Leader>g" },
})

require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>gt", group = "Toggle" },
})

return {
	{
		"sindrets/diffview.nvim",
		lazy = true,
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open diffview" },
		},
		opts = {
			keymaps = {
				view = {
					{ "n", "<C-q>", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
				},
				file_panel = {
					{ "n", "<C-q>", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
				},
			},
		},
	},
	{
		"lambdalisue/vim-gin",
		lazy = true,
		cmd = {
			"Gin",
			"GinBuffer",
			"GinBranch",
			"GinBrowse",
			"GinCd",
			"GinLcd",
			"GinTcd",
			"GinChaperon",
			"GinDiff",
			"GinEdit",
			"GinLog",
			"GinPatch",
			"GinStatus",
		},
		keys = {
			{ "<Leader>gp", "<cmd>Gin push<CR>", desc = "Push" },
			{ "<Leader>gP", "<cmd>Gin pull --autostash<CR>", desc = "Pull" },
			{ "<leader>gs", "<Cmd>GinStatus<Cr>", desc = "Status" },
			{ "<leader>gb", "<Cmd>GinBranch<Cr>", desc = "Branch" },
			{ "<leader>gl", "<Cmd>GinLog<Cr>", desc = "Log" },
			{ "<leader>gc", "<Cmd>Gin commit<Cr>", desc = "Commit" },
			{ "<leader>gf", ":Gin fetch ", desc = "Fetch" },
			{ "<leader>gm", ":Gin merge ", desc = "Merge" },
			{ "<leader>g<C-r>", ":Gin rebase --autostash ", desc = "Rebase" },
		},
		init = function()
			-- git での確認をスキップ
			vim.g["gin_proxy_apply_without_confirm"] = 1
			-- エディタの開き方
			vim.g["gin_proxy_editor_opener"] = "split"
		end,
		config = function()
			require("denops-lazy").load("vim-gin", { wait_load = false })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "gin-diff", "gin-log", "gin-status" },
				callback = function()
					local keymap = vim.keymap.set
					local opts = function(o)
						for k, v in pairs({ buffer = true, noremap = true }) do
							o[k] = v
						end
						return o
					end
					keymap({ "n" }, "c", "<Cmd>Gin commit<Cr>", opts({ desc = "Commit" }))
					keymap({ "n" }, "s", "<Cmd>GinStatus<Cr>", opts({ desc = "Status" }))
					keymap({ "n" }, "L", "<Cmd>GinLog --graph --oneline<Cr>", opts({ desc = "Log" }))
					keymap({ "n" }, "d", "<Cmd>GinDiff --staged<Cr>", opts({ desc = "Diff" }))
					keymap({ "n" }, "q", "<Cmd>bdelete<Cr>", opts({ desc = "Close" }))
					keymap(
						{ "n" },
						"p",
						[[<Cmd>lua vim.notify("Gin push")<Cr><Cmd>Gin push<Cr>]],
						opts({ desc = "Push" })
					)
					keymap(
						{ "n" },
						"P",
						[[<Cmd>lua vim.notify("Gin pull")<Cr><Cmd>Gin pull<Cr>]],
						opts({ desc = "Pull" })
					)
					keymap({ "n" }, "if", "<Plug>(gin-action-fixup:instant-fixup)", opts({ desc = "Fixup" }))
					keymap({ "n" }, "ir", "<Plug>(gin-action-fixup:instant-reword)", opts({ desc = "Reword" }))
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "gin-status",
				callback = function()
					local keymap = vim.keymap.set
					local opts = function(o)
						for k, v in pairs({ buffer = true, noremap = true }) do
							o[k] = v
						end
						return o
					end
					keymap({ "n" }, "h", "<Plug>(gin-action-stage)", opts({ desc = "Stage" }))
					keymap({ "n" }, "l", "<Plug>(gin-action-unstage)", opts({ desc = "Unstage" }))
				end,
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		keys = function()
			local gitsigns = require("gitsigns")
			return {
				{
					"]c",
					function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end,
					desc = "Next hunk",
				},
				{
					"[c",
					function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end,
					desc = "Previous hunk",
				},
				-- Actions
				{ "<leader>ga", gitsigns.stage_hunk, desc = "Stage hunk" },
				{ "<leader>gr", gitsigns.reset_hunk, desc = "Reset hunk" },
				{
					"<leader>ga",
					function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
					mode = "v",
					desc = "Stage hunk",
				},
				{
					"<leader>gr",
					function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end,
					mode = "v",
					desc = "Reset hunk",
				},
				{ "<leader>gA", gitsigns.stage_buffer, desc = "Stage buffer" },
				{ "<leader>gR", gitsigns.reset_buffer, desc = "Reset buffer" },
				{ "<leader>gp", gitsigns.preview_hunk, desc = "Preview hunk" },
				{ "<leader>gi", gitsigns.preview_hunk_inline, desc = "Preview hunk inline" },
				{
					"<leader>g<C-b>",
					function()
						gitsigns.blame_line({ full = true })
					end,
					desc = "Blame on the current line",
				},
				{ "<leader>gq", gitsigns.setqflist, desc = "Open hunks list" },
				{
					"<leader>gQ",
					function()
						gitsigns.setqflist("all")
					end,
					desc = "Open all hunks list",
				},
				-- Toggles
				{ "<leader>gtb", gitsigns.toggle_current_line_blame, desc = "Blame" },
				{ "<leader>gtd", gitsigns.toggle_deleted, desc = "Deleted" },
				{ "<leader>gtw", gitsigns.toggle_word_diff, desc = "Word diff" },
				-- Text object
				{ "ih", gitsigns.select_hunk, mode = { "o", "x" }, desc = "inner hunk" },
			}
		end,
		opts = {
			current_line_blame = true,
			current_line_blame_opts = {
				delay = 200,
			},
		},
	},
}
