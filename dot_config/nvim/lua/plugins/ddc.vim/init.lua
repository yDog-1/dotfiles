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
			vim.keymap.set({ "i", "c" }, "<C-n>", "<Cmd>call pum#map#insert_relative(+1, 'loop')<CR>")
			vim.keymap.set({ "i", "c" }, "<C-p>", "<Cmd>call pum#map#insert_relative(-1, 'loop')<CR>")
			vim.keymap.set({ "i", "c" }, "<C-y>", "<Cmd>call pum#map#confirm()<CR>")
			vim.keymap.set({ "i", "c" }, "<C-e>", "<Cmd>call pum#map#cancel<CR>")
			vim.fn["ddc#enable"]()
		end,
	},
	"https://github.com/Shougo/pum.vim",
	"https://github.com/Shougo/ddc-ui-pum",
	"https://github.com/Shougo/ddc-source-lsp",
	"https://github.com/Shougo/ddc-source-around",
	"https://github.com/tani/ddc-fuzzy",
}
