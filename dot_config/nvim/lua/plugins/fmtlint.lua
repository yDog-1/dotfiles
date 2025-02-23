local install_tools = {
	"stylua",
}
return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "n",
				desc = "format cuurent file",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
			default_format_opts = {
				-- フォーマッタが利用できないときにLSPを使う
				lsp_format = "fallback",
				timeout_ms = 500,
			},
			-- 保存時にフォーマットを有効化
			format_on_save = {},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = true,
		opts = {
			auto_update = true,
			ensure_installed = install_tools,
		},
	},
}
