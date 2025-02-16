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
			{ [[<c-\>]], desc = "Toggle terminal" },
			{ [[<c-¥>]], desc = "Toggle terminal" },
		},
		opts = function()
			return {
				direction = "float",
				open_mapping = { [[<c-\>]], [[<c-¥>]] },
			}
		end,
	},
}
