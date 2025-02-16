return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = function()
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				direction = "float",
				hidden = true,
			})

			local function lazygit_toggle()
				lazygit:toggle()
			end

			vim.keymap.set("n", "<leader>g", lazygit_toggle, { noremap = true, silent = true, desc = "lazygit" })
			return {
				direction = "float",
				open_mapping = { [[<c-\>]], [[<c-¥>]] },
			}
		end,
	},
}
