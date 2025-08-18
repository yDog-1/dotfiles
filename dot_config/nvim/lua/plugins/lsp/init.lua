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

-- LSP servers managed by Nix
local servers = {
	"efm",
	"lua_ls",
	"ts_ls",
	"denols",
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
	"cssls",
	"nil_ls",
}

return {
	-- Neovim での LSP 設定を提供
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"creativenull/efmls-configs-nvim",
			"Shougo/ddc-source-lsp",
			"b0o/schemastore.nvim",
		},
		event = { "BufReadPre" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- 保存時にフォーマット
			local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = lsp_fmt_group,
				callback = function(o)
					-- `:w!` で強制保存した場合はフォーマットしない
					if vim.v.cmdbang == 1 then
						return
					end
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

			vim.lsp.config("ts_ls", {
				root_markers = { "package.json" },
				workspace_required = true,
			})

			vim.lsp.config("denols", {
				root_markers = {
					"deno.json",
					"deno.jsonc",
					"deps.ts",
				},
				workspace_required = true,
			})

			vim.lsp.config("nil_ls", {
				settings = {
					["nil"] = {
						nix = {
							flake = {
								-- flakeの入力を自動評価
								autoEvalInputs = true,
							},
							-- evakuationのメモリを4GiBに設定
							maxMemoryMB = 4096,
						},
					},
				},
			})

			vim.lsp.enable(servers)
		end,
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
