require("plugins.which-key.spec").add({
	mode = { "n", "v" },
	{ "<Leader>a", group = "AI", icon = { icon = "󰧑 ", color = "red" } },
})

local openrouter_api_key = vim.fn.trim(vim.fn.system("head -n 1 ~/.config/llm/openrouter"))
if vim.v.shell_error ~= 0 then
	print("Error reading OpenRouter API key")
	openrouter_api_key = ""
end

return {
	{
		"olimorris/codecompanion.nvim",
		lazy = true,
		dependencies = {
			"j-hui/fidget.nvim",
		},
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
		config = function (_, opts)
			require("plugins.ai.fidget-spinner"):init()
			require("codecompanion").setup(opts)
		end,
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
				openrouter_gemini = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://openrouter.ai/api",
							api_key = openrouter_api_key,
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								default = "google/gemini-2.5-pro-exp-03-25:free",
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
					roles = {
						llm = function(adapter)
							return "  CodeCompanion (" .. adapter.formatted_name .. ")"
						end,
						user = "  Me",
					},
				},
			},
			display = {
				action_palette = {
					provider = "telescope",
				},
				chat = {
					auto_scroll = false,
					window = {
						position = "right",
						width = 0.25,
					},
				},
			},
			opts = {
				language = "日本語",
			},
		},
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
