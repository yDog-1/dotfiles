require("plugins.which-key.spec").add({
	mode = { "n", "v" },
	{ "<Leader>c", group = "code" },
})

local format = function(bufnr)
	local efm = vim.lsp.get_clients({ name = "efm", bufnr = bufnr })
	if not vim.tbl_isempty(efm) then
		vim.lsp.buf.format({ name = "efm" })
		return
	end

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if vim.tbl_isempty(clients) then
		return
	end

	vim.lsp.buf.format()
end

local servers = {
	"efm",
	"lua_ls",
	"ts_ls",
	"gopls",
	"golangci_lint_ls",
	"sqls",
	"graphql",
	"jsonls",
	"yamlls",
	"terraformls",
	"taplo",
	"markdown_oxide",
	"astro",
	"tailwindcss",
}

local ensure_installed = {
	-- Linter
	"gitlint",
	"hadolint",
	"tflint",
	"eslint",
	"sqlfluff",
	"yamllint",
	"markdownlint",
	"golangci-lint",

	-- Formatter
	"stylua",
	"biome",
	"dprint",
	"prettier",
	"yq",
	"jq",
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
	-- Neovim での LSP 設定を提供
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"Shougo/ddc-source-lsp",
			"b0o/schemastore.nvim",
		},
		event = { "BufReadPre" },
		cmd = "Mason",
		config = function()
			vim.cmd("MasonToolsInstall")

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- 保存時にフォーマット
			local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = lsp_fmt_group,
				callback = function(o)
					format(o.buf)
				end,
			})

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
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

			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemaStore = {
							-- You must disable built-in schemaStore support if you want to use
							-- this plugin and its advanced options like `ignore`.
							enable = false,
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})

			vim.lsp.config("markdown_oxide", {
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				}),
			})

			vim.lsp.config("efm", {
				require("lspconfig").efm.setup(require("plugins.lsp.efm")),
			})

			vim.lsp.enable(servers)
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
			ensure_installed = servers,
			automatic_enable = true,
		},
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
	-- LuaLS setup
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				"lazy.nvim",
			},
		},
	},
}
