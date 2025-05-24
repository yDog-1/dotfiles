for _, spec in ipairs({
	{ "AI", "<Leader>a", "󰧑 ", "red" },
	{ "Avante", "<Leader>av", "󰧑 ", "red" },
}) do
	require("plugins.which-key.spec").add({
		mode = { "n", "v" },
		{ spec[2], group = spec[1], icon = { icon = spec[3], color = spec[4] } },
	})
end

local copilotModels = "claude-sonnet-4"
local openrouter_endpoint = "https://openrouter.ai/api/v1"
local openrouter_api_key = "OPENROUTER_API_KEY"

local openrouterModels = {
	[ [[gemini_flash_OR]] ] = {
		model = "google/gemini-2.5-flash-preview-05-20",
		displey_name = "openrouter/gemini-2.5-flash",
	},
	[ [[gemini_pro_OR]] ] = {
		model = "google/gemini-2.5-pro-preview-05-20",
		displey_name = "openrouter/gemini-2.5-pro",
	},
	[ [[deepseek_OR]] ] = {
		model = "deepseek/deepseek-chat-v3-0324",
		displey_name = "openrouter/deepseek-v3",
	},
	[ [[deepseek_free_OR]] ] = {
		model = "deepseek/deepseek-chat-v3-0324:free",
		displey_name = "openrouter/deepseek-v3-free",
	},
	[ [[claude-sonnet-4_OR]] ] = {
		model = "anthropic/claude-sonnet-4",
		display_name = "openrouter/claude-sonnet-4",
	},
	[ [[openai_gpt-4o-mini_OR]] ] = {
		model = "openai/gpt-4o-mini",
		display_name = "openrouter/gpt-4o-mini",
	},
}

vim.api.nvim_create_autocmd("filetype", {
	pattern = "Avante",
	callback = function()
		vim.cmd("Markview enable")
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
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		-- comment the following line to ensure hub will be ready at the earliest
		event = "BufEnter",
		cmd = "MCPHub", -- lazy load by default
		build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
		-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
		-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
		config = function()
			require("mcphub").setup({
				auto_approve = false,
				extensions = {
					avante = {},
					codecompanion = {
						show_result_in_chat = true, -- Show tool results in chat
						make_vars = true, -- Create chat variables from resources
						make_slash_commands = true, -- make /slash_commands from MCP server prompts
					},
				},
			})
		end,
	},
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
		---@module "avante"
		---@type avante.Config
		opts = {
			provider = "copilot",
			copilot = {
				model = copilotModels,
			},
			vendors = (function()
				local vendors = {}
				for key, model in pairs(openrouterModels) do
					vendors[key] = vim.tbl_deep_extend("force", {
						__inherited_from = "openai",
						endpoint = openrouter_endpoint,
						api_key_name = openrouter_api_key,
					}, model)
				end
				return vendors
			end)(),
			behaviour = {
				auto_suggestions = false,
			},
			mappings = {
				ask = "<Leader>ava",
				edit = "<leader>ave",
				refresh = "<leader>avr",
				focus = "<leader>avf",
				stop = "<leader>avS",
				toggle = {
					default = "<leader>avt",
					debug = "<leader>avd",
					hint = "<leader>avh",
					suggestion = "<leader>avs",
					repomap = "<leader>avR",
				},
				files = {
					add_current = "<leader>avc",
					add_all_buffers = "<leader>avB",
				},
				select_model = "<leader>av?",
				select_history = "<leader>avh",
			},
			file_selector = {
				provider = "telescope",
				provider_opts = {},
			},
			--
			-- mcphub関連の設定
			--
			-- mcpとコンフリクトするため、無効にする
			disabled_tools = {
				"list_files", -- Built-in file operations
				"search_files",
				"read_file",
				"create_file",
				"rename_file",
				"delete_file",
				"create_dir",
				"rename_dir",
				"delete_dir",
				"bash", -- Built-in terminal access
			},
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
		},
	},
	{
		"olimorris/codecompanion.nvim",
		lazy = true,
		dependencies = {
			"j-hui/fidget.nvim",
		},
		keys = {
			{ "<Leader>ac", "<cmd>CodeCompanionChat<CR>", desc = "codecompanion Chat" },
			{ "<Leader>gg", "<Cmd>CodeCompanion /commit<CR>", desc = "Generate a commit message" },
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
								default = copilotModels,
							},
						},
					})
				end,
				openrouter = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://openrouter.ai/api",
							api_key = openrouter_api_key,
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								default = openrouterModels["Gemini_flash_OR"],
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
					tools = {
						["mcp"] = {
							-- Prevent mcphub from loading before needed
							callback = function()
								return require("mcphub.extensions.codecompanion")
							end,
							description = "Call tools and resources from the MCP Servers",
						},
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
		"atusy/aibou.nvim",
		keys = {
			{
				"<M-i>",
				function()
					require("aibou.codecompanion").start()
				end,
				desc = "Start aibou",
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
				suggestion = {
					auto_trigger = true,
				},
			})
		end,
	},
	{
		"nekowasabi/aider.vim",
		dependencies = "vim-denops/denops.vim",
		keys = {
			{ "<leader><leader>", "<cmd>AiderRun<CR>", desc = "Run" },
			{ "<leader>aa", "<cmd>AiderAddCurrentFile<CR>", desc = "Add current file" },
			{ "<leader>ar", "<cmd>AiderAddCurrentFileReadOnly<CR>", desc = "Add current file as read-only" },
			{
				"<leader>aw",
				function()
					local register_content = vim.fn.getreg("+")
					vim.cmd("AiderAddWeb " .. register_content)
				end,
				desc = "Add web reference from clipboard",
			},
			{ "<leader>ax", "<cmd>AiderExit<CR>", desc = "Exit" },
			{ "<leader>ai", "<cmd>AiderAddIgnoreCurrentFile<CR>", desc = "Add current file to ignore" },
			{ "<leader>aI", "<cmd>AiderOpenIgnore<CR>", desc = "Open ignore settings" },
			{ "<leader>ap", "<cmd>AiderPaste<CR>", desc = "Paste from clipboard into Aider" },
			{
				"<leader>ap",
				"<cmd>AiderVisualTextWithPrompt<CR>",
				mode = "v",
				desc = "Send prompt to Aider",
			},
			{
				"<leader>aa",
				"<cmd>AiderAddPartialReadonlyContext<CR>",
				mode = "v",
				desc = "Add selected text to Aider",
			},
		},
		config = function()
			-- Gitルートディレクトリで、Aiderを実行する
			vim.g.aider_command = "cd $(git rev-parse --show-toplevel) && aider --watch-files"
			vim.g.aider_buffer_open_type = "floating"
			vim.g.aider_floatwin_width = 200
			vim.g.aider_floatwin_height = 40

			vim.api.nvim_create_autocmd("User", {
				pattern = "AiderOpen",
				callback = function(args)
					local set = vim.keymap.set
					set("t", "<Esc>", "<C-\\><C-n>", { buffer = args.buf })
					set("t", "jj", "<Esc>", { buffer = args.buf })
					set("n", "q", "<cmd>AiderHide<CR>", { buffer = args.buf })

					-- バッファ名をaiderに変更
					-- プラグインは、`aider `と空白より左側に`aider`と付くかどうかで判定している。
					vim.cmd("file aider ")

					local optl = vim.opt_local
					optl.number = false
					optl.relativenumber = false
					optl.buflisted = false
					optl.filetype = "aider"
				end,
			})
			require("denops-lazy").load("aider.vim", { wait_load = true })
		end,
	},
}
