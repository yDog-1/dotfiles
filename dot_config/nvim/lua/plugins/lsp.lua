require("plugins.which-key.spec").add({
	mode = "n",
	{ "<Leader>c", group = "code" },
})

local format = function()
	vim.lsp.buf.format({ name = "efm" })
end

local ensure_installed = {
	-- LS
	"efm",
	"lua_ls",
	"ts_ls",
	"gopls",
	"sqls",
	"graphql",
	"jsonls",
	"yamlls",

	-- Linter
	"biome",
	"commitlint",
	"golangci-lint",
	"hadolint",

	-- Formatter
	"stylua",
}

return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"creativenull/efmls-configs-nvim",
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

			local stylua = require("efmls-configs.formatters.stylua")
			local languages = {
				lua = { stylua },
			}

			local efmls_config = {
				filetypes = vim.tbl_keys(languages),
				settings = {
					rootMarkers = { ".git/" },
					languages = languages,
				},
				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true,
				},
			}

			-- 保存時にフォーマット
			local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = lsp_fmt_group,
				callback = function(ev)
					local efm = vim.lsp.get_clients({ name = "efm", bufnr = ev.buf })

					if vim.tbl_isempty(efm) then
						return
					end

					format()
				end,
			})

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

				efm = function()
					require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {
						cabilities = capabilities,
					}))
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
	},
	-- efm Language Server と nvim-lspconfig の連携
	{
		"creativenull/efmls-configs-nvim",
		version = "v1.x.x",
		lazy = true,
		keys = {
			{ "<Leader>cf", format, desc = "format current file" },
		},
		dependencies = { "neovim/nvim-lspconfig" },
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = true,
		opts = {
			auto_update = true,
			ensure_installed = ensure_installed,
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
			{ "K", "<cmd>Lspsaga hover_doc<CR>", desc = "see document" },
			{ "<Leader>cs", "<cmd>Lspsaga finder<CR>", desc = "fuzy find cursor word" },
			{ "<Leader>cd", "<cmd>Lspsaga peek_definition<CR>", desc = "peek definition" },
			{ "<Leader>ct", "<cmd>Lspsaga peek_type_definition<CR>", desc = "peek type definition" },
			{ "<Leader>cr", "<cmd>Lspsaga rename<CR>", desc = "rename" },
			{ "<Leader>co", "<cmd>Lspsaga outline<CR>", desc = "show outline" },
			{ "<Leader>cc", "<cmd>Lspsaga incoming_calls<CR>", desc = "incoming calls" },
			{ "<Leader>cC", "<cmd>Lspsaga outgoing_calls<CR>", desc = "outgoing calls" },
			{ "<Leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "code action" },
			{ "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "next diagnostic" },
			{ "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "next diagnostic" },
		},
		opts = {
			lightbulb = {
				enable = false,
			},
		},
	},
}
