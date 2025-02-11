return {
	{
		-- nvim-cmp source
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				pannel = { enabled = false },
			})
		end,
	},
}
