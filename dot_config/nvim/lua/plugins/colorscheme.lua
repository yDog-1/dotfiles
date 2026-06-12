return {
	{
		-- カラースキーム
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.sonokai_transparent_background = 1
		end,
		config = function()
			vim.cmd.colorscheme("sonokai")
			-- post_colorscheme()
		end,
	},
}
