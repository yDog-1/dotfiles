require("plugins.which-key.spec").add({
	mode = { "n", "v" },
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
	"terraform-ls",
	"taplo",
	"markdown-oxide",

	-- Linter
	"gitlint",
	"golangci-lint",
	"hadolint",
	"tflint",
	"eslint",
	"sqlfluff",
	"yamllint",
	"markdownlint",

	-- Formatter
	"stylua",
	"biome",
	"dprint",
	"prettier",
	"yq",
	"goimports",

	-- Tool
	"gomodifytags",
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
			vim.cmd("MasonToolsInstall")

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local nvim_lsp = require("lspconfig")

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
									disable = {
										"missing-fields",
									},
								},
							},
						},
					})
				end,

				["markdown_oxide"] = function()
					require("lspconfig")["markdown_oxide"].setup({
						capabilities = vim.tbl_deep_extend("force", capabilities, {
							workspace = {
								didChangeWatchedFiles = {
									dynamicRegistration = true,
								},
							},
						}),
					})
				end,

				efm = function()
					require("lspconfig").efm.setup(vim.tbl_extend("force", require("plugins.lsp.efm"), {
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
		"dnlhc/glance.nvim",

		keys = {
			{ "<Leader>cd", "<cmd>Glance definitions<CR>", desc = "show definitions" },
			{ "<Leader>ct", "<cmd>Glance type_definitions<CR>", desc = "show type definitions" },
			{ "<Leader>ci", "<cmd>Glance implementations<CR>", desc = "show implementations" },
		},
		opts = {
			border = {
				enable = true,
			},
			theme = {
				mode = "darken",
			},
		},
		config = function(_, opts)
			require("glance").setup(opts)

			local color = {
				ctermbg = 236,
				guibg = "#363944",
			}

			local highlights = {
				"GlancePreviewNormal",
				"GlanceListCursorLine",
				"GlancePreviewMatch",
				"GlancePreviewLineNr",
				"GlancePreviewCursorLine",
				"GlancePreviewBorderBottom",
				"GlanceListBorderBottom",
				"GlanceBorderTop",
				"GlanceFoldIcon",
				"GlanceIndent",
				"GlanceWinBarTitle",
				"GlanceWinBarFilepath",
				"GlanceWinBarFilename",
				"GlanceListFilepath",
				"GlanceListNormal",
			}

			for _, hl in ipairs(highlights) do
				vim.cmd("highlight " .. hl .. " guibg=" .. color.guibg .. " ctermbg=" .. color.ctermbg)
			end
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
			{ "K", "<cmd>Lspsaga hover_doc<CR>", desc = "see document" },
			{ "<Leader>cs", "<cmd>Lspsaga finder<CR>", desc = "fuzy find cursor word" },
			{ "<Leader>cD", "<cmd>Lspsaga peek_definition<CR>", desc = "peek definition" },
			{ "<Leader>cT", "<cmd>Lspsaga peek_type_definition<CR>", desc = "peek type definition" },
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
