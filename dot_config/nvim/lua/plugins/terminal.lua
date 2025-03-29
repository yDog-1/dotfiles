local function lazygit_toggle()
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		direction = "float",
		hidden = true,
	})
	lazygit:toggle()
end

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<leader>gg", lazygit_toggle, silent = true, desc = "Lazygit" },
			{ [[<C-\>]], desc = "Toggle terminal" },
			{ [[<C-¥>]], desc = "Toggle terminal" },
		},
		opts = {
			direction = "horizontal",
			open_mapping = { [[<c-\>]], [[<c-¥>]] },
			start_in_insert = false,
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			-- `:wqa` でエラーを起こさずに閉じる設定
			vim.api.nvim_create_autocmd({ "TermEnter" }, {
				callback = function()
					for _, buffers in ipairs(vim.fn.getbufinfo()) do
						local filetype = vim.bo[buffers.bufnr].filetype
						if filetype == "toggleterm" then
							vim.api.nvim_create_autocmd({ "BufWriteCmd", "FileWriteCmd", "FileAppendCmd" }, {
								buffer = buffers.bufnr,
								command = "q!",
							})
						end
					end
				end,
			})
		end,
	},
}
