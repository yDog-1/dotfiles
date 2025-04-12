for _, spec in ipairs({
	{ "AI", "<Leader>a", "󰧑 ", "red" },
	{ "Aider", "<Leader>ai", " ", "green" },
	{ "Avante", "<Leader>av", "󰧑 ", "red" },
	{ "CodeCompanion", "<Leader>ac", " ", "purple" },
}) do
	require("plugins.which-key.spec").add({
		mode = { "n", "v" },
		{ spec[2], group = spec[1], icon = { icon = spec[3], color = spec[4] } },
	})
end

local openrouter_api_key = vim.fn.trim(vim.fn.system("head -n 1 ~/.config/llm/openrouter"))
if vim.v.shell_error ~= 0 then
	print("Error reading OpenRouter API key")
	openrouter_api_key = ""
end

vim.api.nvim_create_autocmd("filetype", {
	pattern = "Avante",
	callback = function()
		require("markview")
	end,
})

local function get_current_os()
	local os = {
		"mac",
		"linux",
		"unix",
		"sun",
		"bsd",
		"win32",
		"win64",
		"wsl",
	}
	for _, v in ipairs(os) do
		if vim.fn.has(v) == 1 then
			return v
		end
	end
end

local avante_build = (function()
	local os = get_current_os()
	if os == "win32" or os == "win64" then
		return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
	else
		return "make"
	end
end)()

return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = avante_build,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
			"ibhagwan/fzf-lua",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
		},
		version = false,
		keys = {
			{ "<Leader>ava", "<cmd>AvanteAsk<CR>", desc = "Ask" },
		},
		---@module "avante"
		---@type avante.Config
		opts = {
			provider = "copilot",
			copilot = {
				model = "claude-3.7-sonnet",
			},
			behaviour = {
				auto_suggestions = false,
				auto_set_keymaps = false,
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		lazy = true,
		dependencies = {
			"j-hui/fidget.nvim",
		},
		keys = {
			{ "<Leader>aca", "<cmd>CodeCompanionActions<CR>", mode = "n", desc = "Action palette" },
			{ "<Leader>aco", "<cmd>CodeCompanionChat<CR>", desc = "Chat" },
			{ "<Leader>aci", "<cmd>CodeCompanion<CR>", desc = "Inline assistant" },
			{ "<Leader>gg", "<Cmd>CodeCompanion /commit<CR>", desc = "Generate a commit message" },
			{
				"<Leader>aca",
				"<cmd>CodeCompanionChat Add<CR>",
				mode = "v",
				desc = "Add selected text to the chat",
			},
			{ "<Leader>aca", "<cmd>CodeCompanionActions<CR>", mode = "v", desc = "Action palette" },
			{
				"<Leader>ace",
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
		config = function(_, opts)
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
	{
		"nekowasabi/aider.vim",
		dependencies = "vim-denops/denops.vim",
		keys = {
			{ "<leader>aio", "<cmd>AiderRun<CR>", desc = "Run" },
			{ "<leader>aia", "<cmd>AiderAddCurrentFile<CR>", desc = "Add current file" },
			{ "<leader>air", "<cmd>AiderAddCurrentFileReadOnly<CR>", desc = "Add current file as read-only" },
			{
				"<leader>aiw",
				function()
					local register_content = vim.fn.getreg("+")
					vim.cmd("AiderAddWeb " .. register_content)
				end,
				desc = "Add web reference from clipboard",
			},
			{ "<leader>aix", "<cmd>AiderExit<CR>", desc = "Exit" },
			{ "<leader>aii", "<cmd>AiderAddIgnoreCurrentFile<CR>", desc = "Add current file to ignore" },
			{ "<leader>aiI", "<cmd>AiderOpenIgnore<CR>", desc = "Open ignore settings" },
			{ "<leader>aip", "<cmd>AiderPaste<CR>", desc = "Paste" },
			{ "<leader>aih", "<cmd>AiderHide<CR>", desc = "Hide" },
			{
				"<leader>aiv",
				"<cmd>AiderVisualTextWithPrompt<CR>",
				mode = "v",
				desc = "Send prompt",
			},
		},
		config = function()
			vim.g.aider_command = "aider --watch-files"
			vim.g.aider_buffer_open_type = "vsplit"

			vim.api.nvim_create_autocmd("User", {
				pattern = "AiderOpen",
				callback = function(args)
					local set = vim.keymap.set
					set("t", "<Esc>", "<C-\\><C-n>", { buffer = args.buf })
					set("t", "jj", "<Esc>", { buffer = args.buf })
					set("n", "q", "<C-w>q", { buffer = args.buf })

					local optl = vim.opt_local
					optl.number = false
					optl.relativenumber = false
					optl.buflisted = false

					vim.cmd("wincmd L")
				end,
			})
			require("denops-lazy").load("aider.vim", { wait_load = true })
		end,
	},
}
