local efm_config = require("plugins.lsp.efm_config").setup({
	filetypes = {
		lua = {
			{
				kind = "formatters",
				name = "stylua",
				settings = {
					default = true,
				},
			},
		},
		gitcommit = {
			{
				kind = "linters",
				name = "gitlint",
				settings = {
					default = true,
				},
			},
		},
		go = {
			{
				kind = "linters",
				name = "golangci_lint",
				settings = {
					default = true,
				},
			},
		},
		dockerfile = {
			{
				kind = "linters",
				name = "hadolint",
				settings = {
					default = true,
				},
			},
		},
		terraform = {
			{
				kind = "formatters",
				name = "terraform_fmt",
				settings = {
					default = true,
				},
			},
		},
		alt_js = {
			{
				kind = "formatters",
				name = "biome",
				settings = {
					default = true,
				},
			},
		},
	},
})

return efm_config
