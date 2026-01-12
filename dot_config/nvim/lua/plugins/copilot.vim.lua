
return {
	{
		"https://github.com/github/copilot.vim",
		event = "VeryLazy",
		init = function()
			vim.g.copilot_filetypes = {
				yaml = true,
				markdown = true,
				gitcommit = true,
				sh = false,
			}
			-- disable default copilot mappings
			vim.g.copilot_no_maps = true

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sh" },
				callback = function()
					if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "%.env") then
						-- disable for .env files
						vim.b.copilot_enabled = false
						return
					end
					vim.b.copilot_enabled = true
					return
				end,
			})
		end,
		config = function()
			vim.keymap.set("i", "<M-l>", "copilot#AcceptWord()", { silent = true, expr = true })
			vim.keymap.set("i", "<M-C-l>", "copilot#AcceptLine()", { silent = true, expr = true })
		end,
	},
}
