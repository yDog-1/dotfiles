local lsp_servers = {
	"lua_ls",
	"ts_ls",
}

local set = vim.keymap.set
-- カーソル下のシンボの情報をホバー表示
set("n", "K", vim.lsp.buf.hover)
-- カーソル下のシンボルの参照を一覧表示
set("n", "<Leader>cr", vim.lsp.buf.references)
-- 定義ジャンプ
set("n", "<Leader>cd", vim.lsp.buf.definition)
-- 型定義にジャンプ
set("n", "<Leader>ct", vim.lsp.buf.type_definition)
-- 宣言にジャンプ
set("n", "<Leader>cD", vim.lsp.buf.declaration)
-- カーソル下のシンボルの実装をクイックフィックスウィンドウにリスト...できてる？
set("n", "<Leader>ci", vim.lsp.buf.implementation)
-- 変数のリネーム
set("n", "<Leader>cR", vim.lsp.buf.rename)
-- VSCodeの電球的な
set("n", "<Leader>ca", vim.lsp.buf.code_action)
-- 電球箇所にジャンプ
set("n", "<Leader>cn", vim.diagnostic.goto_next)
set("n", "<Leader>cp", vim.diagnostic.goto_prev)

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
}
