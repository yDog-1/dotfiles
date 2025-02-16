local lsp_servers = {
	"lua_ls",
	"ts_ls",
}

require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>c", group = "code" },
})

return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		lazy = true,
		opts = true,
	},
	-- Neovim での LSP 設定APIを提供
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"Shougo/ddc-source-lsp",
		},
		event = { "BufReadPre" },
		cmd = "Mason",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local nvim_lsp = require("lspconfig")

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					nvim_lsp[server_name].setup({
						capabilities = capabilities,
					})
				end,
				-- 個別設定
				----------------------------------------------
				["lua_ls"] = function()
					require("lspconfig")["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = {
										"vim",
										"client",
									},
								},
							},
						},
					})
				end,
			})
		end,
	},
	-- mason.nvim と nvim-lspconfig の連携
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		lazy = true,
		opts = {
			ensure_installed = lsp_servers,
		},
	},
	-- UI/UXを改善
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		event = { "BufReadPre" },
		keys = {
			{ "K", "<cmd>Lspsaga hover_doc<CR>", desc = "ホバー" },
			{ "<Leader>fc", "<cmd>Lspsaga finder<CR>", desc = "宣言を一覧表示" },
			{ "<Leader>cd", "<cmd>Lspsaga peek_definition<CR>", desc = "定義を確認" },
			{ "<Leader>ct", "<cmd>Lspsaga peek_type_definition<CR>", desc = "型定義を確認" },
			{ "<Leader>cn", "<cmd>Lspsaga rename<CR>", desc = "リネーム" },
			{ "<Leader>co", "<cmd>Lspsaga outline<CR>", desc = "アウトラインを表示" },
			{ "<Leader>cc", "<cmd>Lspsaga incoming_calls<CR>", desc = "呼び出し元を表示" },
			{ "<Leader>cC", "<cmd>Lspsaga outgoing_calls<CR>", desc = "呼び出し先を表示" },
			{ "<Leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "コードアクション" },
			{ "<Leader>cn", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "次の diagnostic" },
			{ "<Leader>cp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "前の diagnostic" },
		},
		opts = {
			lightbulb = {
				enable = false,
			},
		},
	},
}
