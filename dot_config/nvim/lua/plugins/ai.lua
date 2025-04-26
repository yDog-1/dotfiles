for _, spec in ipairs({
	{ "AI", "<Leader>a", "󰧑 ", "red" },
	{ "Aider", "<Leader>aI", " ", "green" },
	{ "Avante", "<Leader>av", "󰧑 ", "red" },
	{ "CodeCompanion", "<Leader>ac", " ", "purple" },
}) do
	require("plugins.which-key.spec").add({
		mode = { "n", "v" },
		{ spec[2], group = spec[1], icon = { icon = spec[3], color = spec[4] } },
	})
end

local openrouter_api_key = "OPENROUTER_API_KEY"

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

local system_prompt = [[
あなたは「CodeCompanion」という名前のAIプログラミングアシスタントです。現在、ユーザーのマシン上のNeovimテキストエディタに接続されています。

あなたの主な任務には以下が含まれます：
- プログラミングに関する一般的な質問に回答する。
- Neovimバッファ内のコードの動作を説明する。
- Neovimバッファ内の選択されたコードをレビューする。
- 選択されたコードに対するユニットテストを生成する。
- 選択されたコード内の問題に対する修正案を提案する。
- 新しいワークスペース用のコードの骨組みを作成する。
- ユーザーの質問に関連するコードを見つける。
- テスト失敗に対する修正案を提案する。
- Neovimに関する質問に答える。
- ツールを実行する。

あなたは以下のルールに従う必要があります：
- ユーザーの要件を注意深く、文字通りに従ってください。
- 特にユーザーのコンテキストがあなたの主要タスク以外の場合、回答は簡潔で個人的ではない形式を保ってください。
- 説明が必要な場合を除き、余分な文章は最小限にしてください。
- 回答ではMarkdown形式を使用してください。
- 各Markdownコードブロックの先頭にプログラミング言語名を含めてください。
- コードブロック内に行番号を含めないでください。
- 回答全体をトリプルバッククォートで囲まないでください。
- タスクに直接関連するコードのみを返してください。解決策に必要のないコードは省略しても構いません。
- 回答でH1およびH2ヘッダーを使用しないでください。
- 回答では実際の改行を使用してください。リテラルなバックスラッシュと「n」を表示したい場合にのみ「\n」を使用してください。
- コード以外のテキスト応答はすべて日本語で書かれなければなりません。
]]

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
				model = "claude-3.7-sonnet",
			},
			vendors = {
				["openrouter"] = {
					__inherited_from = "openai",
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = openrouter_api_key,
					model = "deepseek/deepseek-r1",
				},
				["openrouter-free"] = {
					__inherited_from = "openai",
					disable_tools = true,
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = openrouter_api_key,
					model = "deepseek/deepseek-r1:free",
				},
			},
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
				if hub then
					return hub:get_active_servers_prompt()
				else
					return system_prompt -- 元のシステムプロンプトを返す
				end
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
			{ "<Leader>aca", "<cmd>CodeCompanionActions<CR>", mode = "n", desc = "Action palette" },
			{ "<Leader>aco", "<cmd>CodeCompanionChat<CR>", desc = "Chat" },
			{ "<Leader>aci", "<cmd>CodeCompanion<CR>", desc = "Inline assistant" },
			{ "<Leader>gg", "<Cmd>CodeCompanion /commit<CR>", desc = "Generate a commit message" },
			{
				"<Leader>acp",
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
				openrouter = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "https://openrouter.ai/api",
							api_key = openrouter_api_key,
							chat_url = "/v1/chat/completions",
						},
						schema = {
							model = {
								default = "google/gemini-2.5-flash-preview",
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
				system_prompt = system_prompt,
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
			{ "<leader>aIo", "<cmd>AiderRun<CR>", desc = "Run" },
			{ "<leader>aIa", "<cmd>AiderAddCurrentFile<CR>", desc = "Add current file" },
			{ "<leader>aIr", "<cmd>AiderAddCurrentFileReadOnly<CR>", desc = "Add current file as read-only" },
			{
				"<leader>aIw",
				function()
					local register_content = vim.fn.getreg("+")
					vim.cmd("AiderAddWeb " .. register_content)
				end,
				desc = "Add web reference from clipboard",
			},
			{ "<leader>aIx", "<cmd>AiderExit<CR>", desc = "Exit" },
			{ "<leader>aIi", "<cmd>AiderAddIgnoreCurrentFile<CR>", desc = "Add current file to ignore" },
			{ "<leader>aII", "<cmd>AiderOpenIgnore<CR>", desc = "Open ignore settings" },
			{ "<leader>aIp", "<cmd>AiderPaste<CR>", desc = "Paste" },
			{ "<leader>aIh", "<cmd>AiderHide<CR>", desc = "Hide" },
			{
				"<leader>aIv",
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
