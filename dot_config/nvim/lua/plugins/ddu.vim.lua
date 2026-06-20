return {
	{
		"https://github.com/Shougo/ddu.vim",
		lazy = false,
		dependencies = {
			"vim-denops/denops.vim",
		},
		config = function()
			vim.fn["ddu#custom#patch_global"]({
				ui = "ff",
				sourceOptions = {
					_ = {
						ignoreCase = true,
						matchers = { "matcher_fzf" },
						sorters = { "sorter_fzf" },
					},
				},
				kindOptions = {
					file = {
						defaultAction = "open",
					},
					help = {
						defaultAction = "open",
					},
					keymap = {
						defaultAction = "type",
					},
				},
				uiParams = {
					ff = {
						-- styling
						split = "tab",
						previewSplit = "vertical",
						previewWidth = "&columns / 2",
						-- behavior
						startAutoAction = true,
						autoAction = {
							name = "preview",
							delay = 2,
							sync = false,
						},
						previewDebounceMs = 0,
					},
				},
				sourceParams = {
					rg = {
						highlights = {
							path = "Directory",
							lineNr = "WarningMsg",
							word = "ErrorMsg",
						},
					},
				},
				filterParams = {
					matcher_fzf = {
						highlightMatched = "ErrorMsg",
					},
					matcher_kensaku = {
						highlightMatched = "ErrorMsg",
					},
				},
			})
			vim.fn["ddu#custom#patch_local"]("file", {
				sources = {
					{
						name = "file_external",
						options = {
							matchers = {
								"matcher_kensaku",
							},
							converters = {
								"converter_hl_dir",
								"converter_devicon",
							},
						},
						params = {
							cmd = { "fd", ".", "-H", "-t", "f" },
						},
					},
				},
			})
			vim.fn["ddu#custom#patch_local"]("buffer", {
				sources = {
					{
						name = "buffer",
						options = {
							matchers = {
								"matcher_kensaku",
							},
							converters = {
								"converter_hl_dir",
								"converter_devicon",
							},
						},
					},
				},
			})
			vim.fn["ddu#custom#patch_local"]("rg", {
				sources = {
					{
						name = "rg",
						options = {
							matchers = {},
							volatile = true,
							converters = {
								"converter_hl_dir",
								"converter_devicon",
							},
						},
					},
				},
				sourceParams = {
					rg = {
						inputType = "migemo",
						args = { "--column", "--no-heading", "--color=never", "--ignore-case" },
					},
				},
				uiParams = {
					ff = {
						ignoreEmpty = false,
						autoResize = false,
					},
				},
			})
			vim.fn["ddu#custom#patch_local"]("recent_file", {
				sources = {
					{
						name = "mr",
						sorters = { "sorter_mtime" },
						options = {
							matchers = {
								"matcher_kensaku",
							},
							converters = {
								"converter_hl_dir",
								"converter_devicon",
							},
						},
					},
				},
			})
			vim.fn["ddu#custom#patch_local"]("recent_dir", {
				sources = {
					{
						name = "mr",
						params = {
							kind = "mrd",
						},
						sorters = { "sorter_mtime" },
						options = {
							matchers = {
								"matcher_kensaku",
							},
						},
					},
				},
				kindOptions = {
					file = {
						defaultAction = "cd",
					},
				},
				uiParams = {
					ff = {
						startAutoAction = false,
					},
				},
			})
			vim.fn["ddu#custom#patch_local"]("help", {
				sources = {
					"help",
				},
			})
			vim.fn["ddu#custom#patch_local"]("keymap", {
				sources = {
					"keymap",
				},
			})

			local file_ui_names = {
				"file",
				"buffer",
				"rg",
				"recent_file",
			}

			-- TODO: call コマンドを lua vim.fn.ddu#start に置き換える
			vim.keymap.set("n", "<leader>ff", [[<Cmd>call ddu#start({'name': 'file'})<CR>]], { desc = "Find file" })
			vim.keymap.set("n", "<leader>fb", [[<Cmd>call ddu#start({'name': 'buffer'})<CR>]], { desc = "Find buffer" })
			vim.keymap.set("n", "<leader>fg", [[<Cmd>call ddu#start({'name': 'rg'})<CR>]], { desc = "Find in files" })
			vim.keymap.set(
				"n",
				"<leader>fr",
				[[<Cmd>call ddu#start({'name': 'recent_file'})<CR>]],
				{ desc = "Find recent file" }
			)
			vim.keymap.set(
				"n",
				"<leader>fd",
				[[<Cmd>call ddu#start({'name': 'recent_dir'})<CR>]],
				{ desc = "Find recent directory" }
			)
			vim.keymap.set("n", "<leader>fh", [[<Cmd>call ddu#start({'name': 'help'})<CR>]], { desc = "Find help" })
			vim.keymap.set("n", "<leader>fk", [[<Cmd>call ddu#start({'name': 'keymap'})<CR>]], { desc = "Find keymap" })

			local grp = vim.api.nvim_create_augroup("ydog-1.ddu", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "ddu-ff",
				group = grp,
				callback = function()
					local opts = { buffer = true }
					vim.keymap.set("n", "q", [[<Cmd>call ddu#ui#do_action('quit')<CR>]], opts)
					vim.keymap.set("n", "<Cr>", [[<Cmd>call ddu#ui#do_action('itemAction')<CR>]], opts)
					vim.keymap.set("n", "i", [[<Cmd>call ddu#ui#do_action('openFilterWindow')<CR>]], opts)
					vim.keymap.set("n", "a", [[<Cmd>call ddu#ui#do_action('openFilterWindow')<CR>]], opts)
					vim.keymap.set("n", "A", [[<Cmd>call ddu#ui#do_action('chooseAction')<CR>]], opts)
					if vim.b.ddu_ui_name == "help" then
						vim.keymap.set(
							"n",
							"<C-S>",
							[[<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open'})<CR>]],
							opts
						)
						vim.keymap.set(
							"n",
							"<C-V>",
							[[<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'vsplit'})<CR>]],
							opts
						)
					end
					for _, kind in ipairs(file_ui_names) do
						if vim.b.ddu_ui_name == kind then
							vim.keymap.set(
								"n",
								"<C-S>",
								[[<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open', params: #{ command: 'split +edit' }})<CR>]],
								opts
							)
							vim.keymap.set(
								"n",
								"<C-V>",
								[[<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open', params: #{ command: 'vsplit +edit' }})<CR>]],
								opts
							)
							vim.keymap.set(
								"n",
								"<C-T>",
								[[<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open', params: #{ command: 'tabnew +edit' }})<CR>]],
								opts
							)
							break
						end
					end
					if vim.b.ddu_ui_name == "gin-action" then
						vim.keymap.set("n", "<CR>", [[<Cmd>call ddu#ui#async_action('itemAction')<CR>]], opts)
					end
				end,
			})
		end,
	},
	-- ui
	"https://github.com/Shougo/ddu-ui-ff",
	-- source
	"https://github.com/matsui54/ddu-source-file_external",
	"https://github.com/shun/ddu-source-buffer",
	{ "https://github.com/shun/ddu-source-rg", dependencies = { "https://github.com/lambdalisue/vim-kensaku" } },
	{ "https://github.com/kuuote/ddu-source-mr", dependencies = { "https://github.com/lambdalisue/vim-mr" } },
	"https://github.com/matsui54/ddu-source-help",
	"https://github.com/kamecha/ddu-source-keymap",
	"https://github.com/Shougo/ddu-source-action",
	-- filter
	"https://github.com/yuki-yano/ddu-filter-fzf",
	"https://github.com/kuuote/ddu-filter-sorter_mtime",
	{ "https://github.com/Milly/ddu-filter-kensaku", dependencies = { "https://github.com/lambdalisue/vim-kensaku" } },
	-- kind
	"https://github.com/Shougo/ddu-kind-file",
	-- converter
	"https://github.com/kyoh86/ddu-filter-converter_hl_dir",
	"https://github.com/uga-rosa/ddu-filter-converter_devicon",
}
