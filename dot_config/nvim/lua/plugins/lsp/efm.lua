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
			{
				kind = "formatters",
				name = "gofmt",
				settings = {
					default = true,
				},
			},
			{
				kind = "formatters",
				name = "goimports",
				settings = {
					default = true,
				},
			}
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
			{
				kind = "formatters",
				name = "deno_fmt",
				settings = {
					default = true,
					options = {
						rootMarkers = {
							"deno.json",
							"deno.jsonc",
						},
						requireMarker = true,
					},
				},
			},
			{
				kind = "formatters",
				name = "dprint",
				settings = {
					default = true,
					options = {
						requireMarker = true,
					},
				},
			},
			{
				kind = "linters",
				name = "eslint",
				settings = {
					default = true,
					options = {
						requireMarker = true,
					},
				},
			},
			{
				kind = "formatters",
				name = "prettier",
				settings = {
					default = true,
					options = {
						requireMarker = true,
					},
				},
			},
		},
		sql = {
			{
				kind = "linters",
				name = "sqlfluff",
				settings = {
					default = true,
					options = {
						lintCommand = "sqlfluff lint --format github-annotation-native -n --disable-progress-bar ${INPUT}",
						rootMarkers = { ".sqlfluff" },
					},
				},
			},
			{
				kind = "formatters",
				name = "sqlfluff",
				settings = {
					default = false,
					options = {
						formatCommand = "sqlfluff fix -n --disable-progress-bar -",
						formatStdin = true,
						rootMarkers = { ".sqlfluff" },
					},
				},
			},
		},
		yaml = {
			{
				kind = "linters",
				name = "yamllint",
				settings = {
					default = true,
				},
			},
			{
				kind = "formatters",
				name = "yq",
				settings = {
					default = true,
				},
			},
		},
		toml = {
			kind = "formatters",
			name = "taplo",
			settings = {
				default = true,
			},
		},
		markdown = {
			{
				kind = "linters",
				name = "markdownlint",
				settings = {
					default = true,
				},
			},
		},
	},
})

return efm_config
