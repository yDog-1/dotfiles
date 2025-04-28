return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		branch = "main",
		keys = {
			{ "<Leader>lm", "<cmd>Markview toggle<CR>", { desc = "Toggle Markview" } },
		},
		---@module "markview"
		---@type mkv.config
		opts = {
			preview = {
				enable = false,
				filetypes = { "markdown", "codecompanion", "Avante" },
				ignore_buftypes = {},
				icon_provider = "devicons",
			},
			markdown = {
				list_items = {
					shift_width = function(buffer, item)
						--- Reduces the `indent` by 1 level.
						---
						---         indent                      1
						--- ------------------------- = 1 ÷ --------- = new_indent
						--- indent * (1 / new_indent)       new_indent
						---
						local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)

						return item.indent * (1 / (parent_indnet * 2))
					end,
					marker_minus = {
						---@diagnostic disable-next-line: assign-type-mismatch
						add_padding = function(_, item)
							return item.indent > 1
						end,
					},
				},
			},
		},
		---@param opts mkv.config
		config = function(_, opts)
			local preset = require("markview.presets")

			---@type mkv.config
			local style_opts = {
				markdown = {
					headings = preset.headings.marker,
					horizontal_rule = preset.horizontal_rules.thin,
					tables = preset.tables.single,
				},
			}

			opts = vim.tbl_deep_extend("force", opts, style_opts)

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = [[*CodeCompanion*]],
				callback = function()
					vim.cmd("Markview enable")
				end,
			})

			require("markview").setup(opts)
		end,
	},
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		config = function(_, opts)
			local otter = require("otter")
			otter.setup(opts)

			vim.api.nvim_create_autocmd("filetype", {
				pattern = "markdown",
				callback = function()
					otter.activate(nil, true, false)
				end,
			})
		end,
	},
}
