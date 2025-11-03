require("plugins.which-key.spec").add({
	mode = { "n", "v" },
	{ "<Leader>c", group = "code" },
})

local nix_utils = require("utils.nix")

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
	-- "lua_ls",
	"emmylua_ls",
	"gopls",
	"golangci_lint_ls",
	"sqls",
	"graphql",
	"jsonls",
	"yamlls",
	"terraformls",
	"taplo",
	"astro",
	-- "tailwindcss",  -- 未設定
	"cssls",
	"nixd",
	"pylsp",
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
			local capabilities = require("ddc_source_lsp").make_client_capabilities()

			-- 保存時にフォーマット
			local lsp_group = vim.api.nvim_create_augroup("ydog.lsp", {})
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = lsp_group,
				callback = function(o)
					-- `:w!` で強制保存した場合はフォーマットしない
					if vim.v.cmdbang == 1 then
						return
					end
					format(o.buf)
				end,
			})

			-- ts_ls denols
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				callback = function(ctx)
					if vim.fn.findfile("package.json", ".;") ~= "" then
						vim.lsp.start(vim.lsp.config.ts_ls, { bufnr = ctx.buf })
					else
						vim.lsp.start(vim.lsp.config.denols, { bufnr = ctx.buf })
					end
				end,
			})

			---@diagnostic disable-next-line: param-type-mismatch
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			---@diagnostic disable-next-line: param-type-mismatch
			vim.lsp.config("emmylua_ls", {
				settings = {
					Lua = {
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			})

			---@diagnostic disable-next-line: param-type-mismatch
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			---@diagnostic disable-next-line: param-type-mismatch
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

			---@diagnostic disable-next-line: param-type-mismatch
			vim.lsp.config("denols", {
				settings = {
					single_file_support = true,
				},
			})

			local username = os.getenv("USER") or os.getenv("USERNAME") or vim.fn.system("whoami"):gsub("\n", "")
			---@diagnostic disable-next-line: param-type-mismatch
			vim.lsp.config("nixd", {
				command = { "nixd" },
				filetypes = { "nix" },
				settings = {
					nixd = {
						nixpkgs = {
							expr = string.format(
								'(builtins.getFlake "%s/.config/home-manager").inputs.nixpkgs.legacyPackages.%s',
								os.getenv("HOME"),
								nix_utils.get_system()
							),
						},
						options = {
							home_manager = {
								expr = string.format(
									'(builtins.getFlake "%s/.config/home-manager").homeConfigurations."%s".options',
									os.getenv("HOME"),
									username
								),
							},
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
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		event = { "BufReadPre" },
		keys = {
			{ "K", "<cmd>Lspsaga hover_doc<CR>", desc = "see document" },
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
	-- Zed inspired fuzzy picker for LSP
	{
		"https://github.com/bassamsdata/namu.nvim",
		keys = {
			{ "<leader>cs", "<cmd>Namu symbols<cr>", desc = "Jump to LSP symbol" },
			{ "<leader>cS", "<cmd>Namu workspace<cr>", desc = "LSP symbols - Workspace" },
		},
		opts = {
			global = {
				movement = {
					close = { "<Esc>", "<C-c>" },
				},
			},
			namu_symbols = {
				options = {},
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
