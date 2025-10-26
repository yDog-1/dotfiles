local augroup = vim.api.nvim_create_augroup("ydog.ddc_vim", { clear = true })

---@diagnostic disable-next-line: unused-local
local cmdline_pre = function(mode)
	local buf = vim.api.nvim_get_current_buf()
	local buf_config = vim.fn["ddc#custom#get_buffer"]()
	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = "DDCCmdlineLeave",
		once = true,
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_call(buf, function()
					vim.fn["ddc#custom#set_buffer"](buf_config or vim.empty_dict())
				end)
			end
		end,
	})

	vim.fn["ddc#enable_cmdline_completion"]()
end

for _, lhs in ipairs({ "/", "?", ":" }) do
	vim.keymap.set({ "n", "x" }, lhs, function()
		cmdline_pre(lhs)
		return lhs
	end, { expr = true, noremap = true })
end

return {
	{
		"https://github.com/Shougo/ddc.vim",
		lazy = false,
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
				max_width = 80,
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
	"https://github.com/Shougo/ddc-source-cmdline",
	"https://github.com/Shougo/ddc-source-cmdline_history",
	"https://github.com/Shougo/ddc-source-input",
	"https://github.com/Shougo/ddc-source-shell_native",
	"https://github.com/tani/ddc-fuzzy",
	"https://github.com/Shougo/ddc-filter-sorter_lsp_kind",
	"https://github.com/Shougo/ddc-filter-sorter_rank",
	"https://github.com/Shougo/ddc-filter-converter_kind_labels",
	"https://github.com/Shougo/ddc-filter-matcher_length",
}
