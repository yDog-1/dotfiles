for _, spec in ipairs({
	{ "AI", "<Leader>a", "󰧑 ", "red" },
}) do
	require("plugins.which-key.spec").add({
		mode = { "n", "v" },
		{ spec[2], group = spec[1], icon = { icon = spec[3], color = spec[4] } },
	})
end

return {
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
		},
		-- comment the following line to ensure hub will be ready at the earliest
		event = "BufEnter",
		cmd = "MCPHub", -- lazy load by default
		build = "bundled_build.lua",
		-- uncomment this if you don't want mcp-hub to be available globally or can't use -g
		-- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
		config = function()
			require("mcphub").setup({
				use_bundled_binary = true,
				auto_approve = false,
				extensions = {
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
		"olimorris/codecompanion.nvim",
		lazy = true,
		dependencies = {
			"j-hui/fidget.nvim",
		},
		cmd = { "CodeCompanion", "CodeCompanionChat" },
		keys = {
			{ "<Leader>aa", "<cmd>CodeCompanionChat<CR>", desc = "codecompanion Chat" },
			{ "<leader>ac", "<cmd>CodeCompanionActions<CR>", desc = "codecompanion Actions" },
			{ "<C-n>", ":CodeCompanion #{buffer}", mode = { "n", "v" }, desc = "codecompanion inline" },
			{ "<Leader>gg", "<Cmd>CodeCompanion /commit<CR>", desc = "Generate a commit message" },
		},
		config = function()
			require("plugins.ai.fidget-spinner"):init()
			require("codecompanion").setup({
				adapters = {
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "gpt-4.1",
								},
							},
						})
					end,
					openrouter = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								url = "https://openrouter.ai/api",
								api_key = "OPENROUTER_API_KEY",
								chat_url = "/v1/chat/completions",
							},
							schema = {
								model = {
									default = "openai/gpt-oss-120b",
								},
							},
						})
					end,
					opts = {
						show_defaults = false,
						show_model_choices = false,
					},
				},
				strategies = {
					chat = {
						adapter = "openrouter",
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
							variables = {
								-- 現在の関数コンテキストを取得
								current_function = {
									callback = function()
										-- Tree-sitterで現在の関数を取得する例
										local ts_utils = require("nvim-treesitter.ts_utils")
										local node = ts_utils.get_node_at_cursor()
										if node then
											-- 関数ノードを探す
											while node do
												if node:type():match("function") then
													return vim.treesitter.get_node_text(node, 0)
												end
												node = node:parent()
											end
										end
										return "関数が見つかりません"
									end,
									description = "現在の関数のコンテキスト",
									opts = { contains_code = true },
								},
							},
						},
						roles = {
							llm = function(adapter)
								return "  CodeCompanion (" .. adapter.formatted_name .. ")"
							end,
							user = "  Me",
						},
					},
					extensions = {
						mcphub = {
							callback = "mcphub.extensions.codecompanion",
							opts = {
								make_vars = true,
								make_slash_commands = true,
								show_result_in_chat = true,
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
					diff = {
						enavle = true,
						layout = "vertical",
					},
				},
				opts = {
					language = "日本語",
				},
				prompt_library = {
					-- コメント→関数生成専用プロンプト
					["function from comment"] = {
						strategy = "inline",
						description = "コメントから関数を生成する",
						opts = {
							short_name = "funfc",
							is_slash_cmd = true,
							auto_submit = true,
						},
						prompts = {
							{
								role = "system",
								content = [[あなたは経験豊富なプログラマーです。
与えられたコメントに基づいて、適切な関数を生成してください。
以下の点に注意してください：
1. コメントの意図を正確に理解する
2. 適切な関数名と引数を決める
3. エラーハンドリングを含める
4. ドキュメントコメントも追加する
5. 既存のコードスタイルに合わせる]],
							},
							{
								role = "user",
								content = function(context)
									return string.format(
										[[
プロジェクトタイプ: #{project_context}
現在のファイル: %s
選択されたコメント:
```%s
%s
```

このコメントに基づいて関数を実装してください。]],
										vim.api.nvim_buf_get_name(context.bufnr),
										context.filetype,
										require("codecompanion.helpers.actions").get_code(
											context.start_line,
											context.end_line
										)
									)
								end,
								opts = { contains_code = true },
							},
						},
					},

					-- ファイル解説専用プロンプト
					["explain the file"] = {
						strategy = "chat",
						description = "現在のファイルの詳細解説",
						opts = {
							short_name = "explain",
							is_slash_cmd = true,
						},
						prompts = {
							{
								role = "system",
								content = [[あなたはコードレビューの専門家です。
ファイルを解析して以下の観点で説明してください：
1. ファイルの目的と役割
2. 主要な関数/クラスの説明
3. 依存関係の分析
4. 改善点があれば指摘
5. 使用例があれば提示]],
							},
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(1, -1, context.bufnr)
									return string.format(
										[[<user_prompt>
以下のファイルを解説してください：

ファイル名: %s
プロジェクトタイプ: #{project_context}

```%s
%s
```</user_prompt>]],
										vim.api.nvim_buf_get_name(context.bufnr),
										context.filetype,
										code
									)
								end,
								opts = { contains_code = true },
							},
						},
					},

					-- リファクタリング提案
					["refactoring"] = {
						strategy = "inline",
						description = "選択したコードのリファクタリング提案",
						opts = {
							index = 3,
							short_name = "refactor",
							is_slash_cmd = true,
							modes = { "v" }, -- ビジュアルモードでのみ有効
							mapping = "<leader>cr",
						},
						prompts = {
							{
								role = "system",
								content = [[コードリファクタリングの専門家として、以下の観点でコードを改善してください：
1. 可読性の向上
2. パフォーマンスの最適化
3. 保守性の向上
4. バグの潜在リスクの軽減
5. ベストプラクティスの適用

改善されたコードのみを返してください。]],
							},
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)
									return string.format(
										[[
以下のコードをリファクタリングしてください：

ファイル: %s (%s)
現在の関数コンテキスト: #{current_function}

```%s
%s
```]],
										vim.api.nvim_buf_get_name(context.bufnr),
										context.filetype,
										context.filetype,
										code
									)
								end,
								opts = { contains_code = true },
							},
						},
					},

					-- 単体テスト生成
					["generate test"] = {
						strategy = "inline",
						description = "選択した関数の単体テストを生成",
						opts = {
							index = 4,
							short_name = "test",
							is_slash_cmd = true,
							modes = { "v" },
							placement = "new", -- 新しいバッファに生成
							mapping = "<leader>ct",
						},
						prompts = {
							{
								role = "system",
								content = [[テスト駆動開発の専門家として、包括的な単体テストを作成してください：
1. 正常系のテストケース
2. 異常系のテストケース  
3. エッジケースのテストケース
4. 適切なテスト名とコメント
5. モックが必要な場合は適切に使用]],
							},
							{
								role = "user",
								content = function(context)
									local code = require("codecompanion.helpers.actions").get_code(
										context.start_line,
										context.end_line
									)
									return string.format(
										[[
以下の関数に対する単体テストを生成してください：

ファイル: %s
プロジェクトタイプ: #{project_context}

```%s
%s
```]],
										vim.api.nvim_buf_get_name(context.bufnr),
										context.filetype,
										code
									)
								end,
								opts = { contains_code = true },
							},
						},
					},

					-- エラー診断・修正
					["fix errors"] = {
						strategy = "inline",
						description = "LSP診断に基づいてエラーを修正",
						opts = {
							index = 6,
							short_name = "fix",
							is_slash_cmd = true,
							auto_submit = true,
							mapping = "<leader>cx",
						},
						prompts = {
							{
								role = "system",
								content = [[エラー診断とデバッグの専門家として、以下の手順でエラーを修正してください：
1. エラーメッセージを分析
2. 根本原因を特定
3. 最適な修正方法を選択
4. 副作用がないか確認
5. 修正されたコードのみを提供]],
							},
							{
								role = "user",
								content = function(context)
									local diagnostics = vim.diagnostic.get(context.bufnr, {
										lnum = context.start_line - 1,
									})

									local diagnostic_text = ""
									for _, diagnostic in ipairs(diagnostics) do
										diagnostic_text = diagnostic_text
											.. string.format(
												"- %s: %s\n",
												diagnostic.source or "LSP",
												diagnostic.message
											)
									end

									local code =
										require("codecompanion.helpers").get_code(context.start_line, context.end_line)

									return string.format(
										[[
/lsp
以下のコードでエラーが発生しています：

エラー診断:
%s

コード:
```%s
%s
```

エラーを修正したコードを提供してください。]],
										diagnostic_text ~= "" and diagnostic_text or "診断情報なし",
										context.filetype,
										code
									)
								end,
								opts = { contains_code = true },
							},
						},
					},

					["ask a question"] = {
						strategy = "chat",
						description = "現在のコンテキストについて質問",
						opts = {
							index = 7,
							short_name = "ask",
							is_slash_cmd = true,
						},
						prompts = {
							{
								role = "system",
								content = [[簡潔で実用的なアドバイスを提供するコーディングアシスタントです。
質問に対して具体的で実践的な回答を心がけてください。]],
							},
							{
								role = "user",
								content = function(context)
									return string.format(
										[[
現在のコンテキスト:
ファイル: %s
言語: %s
プロジェクト: #{project_context}

何か質問があればどうぞ！]],
										vim.api.nvim_buf_get_name(context.bufnr),
										context.filetype
									)
								end,
							},
						},
					},
				},
			})
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
					sh = function()
						if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "%.env") then
							-- disable for .env files
							return false
						end
						return true
					end,
				},
				suggestion = {
					auto_trigger = true,
				},
			})
		end,
	},
}
