local function lazygit_toggle()
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		direction = "float",
		hidden = true,
		on_open = function()
			vim.cmd("startinsert")
		end,
	})
	lazygit:toggle()
end

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<leader>gG", lazygit_toggle, silent = true, desc = "Lazygit" },
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
			local grp = vim.api.nvim_create_augroup("ToggleTermClose", { clear = true })
			vim.api.nvim_create_autocmd({ "TermOpen" }, {
				group = grp,
				callback = function()
					for _, buffers in ipairs(vim.fn.getbufinfo()) do
						local filetype = vim.bo[buffers.bufnr].filetype
						if filetype == "toggleterm" then
							local quitTermGrp =
								vim.api.nvim_create_augroup("QuitTerm: " .. tostring(buffers.bufnr), { clear = true })
							vim.api.nvim_create_autocmd({ "VimLeavePre", "ExitPre" }, {
								group = quitTermGrp,
								command = "quit! " .. buffers.bufnr,
							})
						end
					end
				end,
			})
		end,
	},
}
