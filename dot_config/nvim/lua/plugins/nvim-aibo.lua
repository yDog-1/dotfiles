return {
	"lambdalisue/nvim-aibo",
	lazy = false,
	keys = {
		{
			"<leader>aa",
			function()
				vim.api.nvim_command("Aibo -opener=botright\\ vsplit -toggle codex")
			end,
			desc = "Aibo Codex",
		},
	},
	config = function()
		require("aibo").setup()
	end,
}
