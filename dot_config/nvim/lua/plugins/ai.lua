require("plugins.which-key.spec").add({
	mode = { "n", "v" },
	{ "<Leader>a", group = "AI", icon = { icon = "󰧑 ", color = "red" } },
})

return {
	{
		"olimorris/codecompanion.nvim",
		lazy = true,
		keys = {
			{ "<Leader>aa", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "Action palette" },
			{ "<Leader>ao", "<cmd>CodeCompanionChat<CR>", desc = "Chat" },
			{ "<Leader>ai", "<cmd>CodeCompanion<CR>", desc = "Inline assistant" },
			{ "ga", "<cmd>CodeCompanionChat Add<CR>", desc = "Add selected text to the chat" },
			{ "<Leader>gG", "<Cmd>CodeCompanion /commit<CR>", desc = "Generate a commit message" },
			{
				"<Leader>ae",
				function()
					require("codecompanion").prompt("explain")
				end,
				mode = "v",
				desc = "Explain how code in a buffer works",
			},
			{
				"<Leader>tg",
				function()
					require("codecompanion").prompt("tests")
				end,
				mode = "v",
				desc = "Generate unit tests",
			},
			{
				"<Leader>cF",
				function()
					require("codecompanion").prompt("fix")
				end,
				mode = "v",
				desc = "Fix the code",
			},
			{
				"<Leader>ce",
				function()
					require("codecompanion").prompt("lsp")
				end,
				mode = "v",
				desc = "Explain the LSP diagnostics",
			},
		},
		opts = {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "copilot",
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "telescope",
							},
						},
						["file"] = {
							opts = {
								provider = "telescope",
							},
						},
						["symbols"] = {
							opts = {
								provider = "telescope",
							},
						},
					},
					inline = {
						adapter = "copilot",
					},
				},
			},
			display = {
				action_palette = {
					provider = "telescope",
				},
				chat = {
					window = {
						position = "right",
						width = 0.25,
					},
					show_settings = true,
				},
			},
			opts = {
				language = "日本語",
			},
		},
	},
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
				filetypes = {
					yaml = true,
					markdown = true,
					gitcommit = true,
				},
				suggestion = { enabled = false },
				pannel = { enabled = false },
			})
		end,
	},
}
