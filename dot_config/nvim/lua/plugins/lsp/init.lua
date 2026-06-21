require("plugins.which-key.spec").add({
	mode = { "n", "v" },
	{ "<Leader>c", group = "code" },
})

-- LSP servers available on PATH
local servers = {
	"lua_ls",
	"gopls",
	"golangci_lint_ls",
	"sqls",
	"graphql",
	"jsonls",
	"yamlls",
	"terraformls",
	"taplo",
	"astro",
	"tailwindcss",
	"nixd",
	"pylsp",
	"gdscript",
	"arduino_language_server",
}

return {
	-- Neovim での LSP 設定を提供
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"Shougo/ddc-source-lsp",
			"b0o/schemastore.nvim",
		},
		event = { "BufReadPre" },
		config = function()
			local capabilities = require("ddc_source_lsp").make_client_capabilities()

			-- ts_ls denols
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				callback = function()
					if vim.fn.findfile("package.json", ".;") ~= "" then
						vim.lsp.enable("ts_ls")
						vim.lsp.enable("denols", false)
					else
						vim.lsp.enable("denols")
						vim.lsp.enable("ts_ls", false)
					end
				end,
			})

			---@diagnostic disable-next-line: param-type-mismatch
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.enable(servers)
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		event = { "BufReadPre" },
		keys = {
			{ "<Leader>cr", "<cmd>Lspsaga rename<CR>", desc = "rename" },
			{ "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "next diagnostic" },
			{ "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "next diagnostic" },
		},
		opts = {
			lightbulb = {
				enable = false,
			},
		},
	},
	{
		"https://github.com/lewis6991/hover.nvim",
		keys = {
			{
				"K",
				function()
					require("hover").open()
				end,
				desc = "Hover",
			},
			{
				"gK",
				function()
					require("hover").enter()
				end,
				desc = "Hover (enter)",
			},
		},
		config = function()
			---@diagnostic disable-next-line: missing-fields, param-type-mismatch
			require("hover").config({
				providers = {
					{
						module = "hover.providers.lsp",
						priority = 200,
					},
					{
						module = "hover.providers.gh",
						priority = 150,
					},
					{
						module = "hover.providers.diagnostic",
						priority = 100,
					},
					{
						module = "hover.providers.highlight",
						priority = 80,
					},
					{
						module = "hover.providers.man",
						priority = 75,
					},
					{
						module = "hover.providers.dictionary",
						priority = 50,
					},
				},
			})
		end,
	},
	-- LSP progress notification
	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				window = {
					-- 背景を透過
					winblend = 0,
				},
			},
		},
	},
}
