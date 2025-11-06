return {
	{
		"https://github.com/olimorris/onedarkpro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("onedarkpro").setup({
				styles = {
					comments = "italic",
					keywords = "bold,italic",
					functions = "bold",
					strings = "italic",
					variables = "bold,italic",
					constants = "bold",
					types = "bold",
					parameters = "italic",
				},
				options = {
					cursorline = true,
					terminal_colors = false,
					highlight_inactive_windows = true,
				},
			})
			vim.cmd.colorscheme("onedark_dark")
		end,
	},
}
