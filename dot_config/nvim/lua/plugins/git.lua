require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>g", group = "Git" },
})

require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>gt", group = "Toggle" },
})

return {
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
				{ "<leader>gs", gitsigns.stage_hunk, desc = "Stage hunk" },
				{ "<leader>gr", gitsigns.reset_hunk, desc = "Reset hunk" },
				{
					"<leader>gs",
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
				{ "<leader>gS", gitsigns.stage_buffer, desc = "Stage buffer" },
				{ "<leader>gR", gitsigns.reset_buffer, desc = "Reset buffer" },
				{ "<leader>gp", gitsigns.preview_hunk, desc = "Preview hunk" },
				{ "<leader>gi", gitsigns.preview_hunk_inline, desc = "Preview hunk inline" },
				{
					"<leader>gb",
					function()
						gitsigns.blame_line({ full = true })
					end,
					desc = "Blame on the current line",
				},
				{ "<leader>gd", gitsigns.diffthis, desc = "Index diff" },
				{
					"<leader>gD",
					function()
						gitsigns.diffthis("~")
					end,
					desc = "HEAD diff",
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
