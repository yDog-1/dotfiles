return {
	{
		"https://github.com/Shougo/ddc.vim",
		dependencies = {
			"vim-denops/denops.vim",
		},
		config = function()
			vim.fn["ddc#custom#load_config"](
				vim.fs.joinpath(vim.fs.dirname(debug.getinfo(1, "S").source:sub(2)), "init.ts")
			)
			vim.fn["ddc#enable"]()
		end,
	},
	{
		"https://github.com/Shougo/pum.vim",
		dependencies = { "cohama/lexima.vim" },
		config = function()
			vim.fn["pum#set_option"]({
				border = "single",
				max_height = 15,
				scrollbar_char = "",
			})

			vim.fn["lexima#set_default_rules"]()
			vim.keymap.set({ "i", "c" }, "<C-n>", "<Cmd>call pum#map#insert_relative(+1, 'loop')<CR>")
			vim.keymap.set({ "i", "c" }, "<C-p>", "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>")
			vim.keymap.set({ "i", "c" }, "<C-y>", "<Cmd>call pum#map#confirm()<CR>")
			vim.keymap.set("i", "<CR>", function()
				if vim.fn["pum#visible"]() and vim.fn["pum#entered"]() then
					return vim.fn["pum#map#confirm"]()
				else
					return "<C-r>=lexima#expand('<LT>CR>', 'i')<CR>"
				end
			end, { expr = true })
			vim.keymap.set("c", "<CR>", function()
				if vim.fn["pum#visible"]() and vim.fn["pum#entered"]() then
					return vim.fn["pum#map#confirm"]()
				else
					return "<CR>"
				end
			end, { expr = true })
			vim.keymap.set({ "i", "c" }, "<C-e>", "<Cmd>call pum#map#cancel<CR>")
		end,
	},
	"https://github.com/Shougo/ddc-ui-pum",
	"https://github.com/Shougo/ddc-source-lsp",
	"https://github.com/Shougo/ddc-source-around",
	"https://github.com/matsui54/ddc-source-buffer",
	"https://github.com/LumaKernel/ddc-source-file",
	"https://github.com/tani/ddc-fuzzy",
	"https://github.com/Shougo/ddc-filter-sorter_lsp_kind",
	"https://github.com/Shougo/ddc-filter-sorter_rank",
	"https://github.com/Shougo/ddc-filter-converter_kind_labels",
	"https://github.com/Shougo/ddc-filter-matcher_length",
}
