for _, spec in ipairs({
	{ "Aibo", "<Leader>a", "󰧑 ", "red" },
}) do
	require("plugins.which-key.spec").add({
		mode = { "n", "v" },
		{ spec[2], group = spec[1], icon = { icon = spec[3], color = spec[4] } },
	})
end

local opencode = "opencode"

return {
	"lambdalisue/nvim-aibo",
	lazy = false,
	dependencies = {
		"https://github.com/Shougo/ddc.vim",
	},
	keys = {
		{
			"<leader>aa",
			string.format("<cmd>Aibo -opener=botright\\ vsplit -focus %s<CR>", opencode),
			desc = "Chat with OpenCode",
		},
		{
			"<leader>as",
			"<cmd>AiboSend -input",
			desc = "Send to Aibo",
			mode = "n",
		},
		{
			"<leader>as",
			":AiboSend -input",
			desc = "Send to Aibo",
			mode = "v",
		},
	},
	config = function()
		require("aibo").setup({
			disable_startinsert_on_insert = false,
			disable_startinsert_on_startup = true,
			prompt_height = 20,
			prompt = {
				no_default_mappings = true,
				on_attach = function(bufnr)
					vim.o.hidden = true

					local opts = { buffer = bufnr, nowait = true, silent = true }
					vim.keymap.set({ "n" }, "q", "<Cmd>q<CR>", opts)
					vim.keymap.set({ "n" }, "g<C-C>", "<Plug>(aibo-send)<C-C>", opts)
					vim.keymap.set({ "n" }, "<C-K>", "<Plug>(aibo-send)<Up>", opts)
					vim.keymap.set({ "n" }, "<C-J>", "<Plug>(aibo-send)<Down>", opts)
					vim.keymap.set({ "n" }, "<PageDown>", "<Plug>(aibo-send)<PageDown>", opts)
					vim.keymap.set({ "n" }, "<PageUp>", "<Plug>(aibo-send)<PageUp>", opts)
					vim.keymap.set({ "n" }, "<End>", "<Plug>(aibo-send)<End>", opts)
					vim.keymap.set({ "n" }, "<Home>", "<Plug>(aibo-send)<Home>", opts)
					vim.keymap.set({ "n" }, "<Up>", "<Plug>(aibo-send)<Up>", opts)
					vim.keymap.set({ "n" }, "<Down>", "<Plug>(aibo-send)<Down>", opts)
					vim.keymap.set({ "n" }, "<C-L>", "<Plug>(aibo-send)<C-L>", opts)
					vim.keymap.set({ "n" }, "<CR>", "<Plug>(aibo-submit)<Cmd>q<CR>", opts)
					vim.keymap.set({ "n" }, "<F5>", "<Plug>(aibo-submit)<Cmd>q<CR>", opts)
					vim.keymap.set({ "n", "i" }, "<C-CR>", "<Plug>(aibo-submit)<Cmd>q<CR>", opts)
					vim.keymap.set({ "n" }, "<C-G><C-O>", "<Plug>(aibo-send)", opts)

					-- for ddc.vim
					vim.fn["ddc#custom#patch_buffer"]("specialBufferCompletion", true)
				end,
			},
			console = {
				no_default_mappings = true,
				on_attach = function(bufnr)
					vim.o.hidden = true

					local opts = { buffer = bufnr, nowait = true, silent = true }
					vim.keymap.set({ "n" }, "<C-K>", "<Plug>(aibo-send)<Up>", opts)
					vim.keymap.set({ "n" }, "<C-J>", "<Plug>(aibo-send)<Down>", opts)
					vim.keymap.set({ "n" }, "<PageDown>", "<Plug>(aibo-send)<PageDown>", opts)
					vim.keymap.set({ "n" }, "<PageUp>", "<Plug>(aibo-send)<PageUp>", opts)
					vim.keymap.set({ "n" }, "<C-U>", "<Plug>(aibo-send)<PageUp>", opts)
					vim.keymap.set({ "n" }, "<C-D>", "<Plug>(aibo-send)<PageDown>", opts)
					vim.keymap.set({ "n" }, "<End>", "<Plug>(aibo-send)<End>", opts)
					vim.keymap.set({ "n" }, "<Home>", "<Plug>(aibo-send)<Home>", opts)
					vim.keymap.set({ "n" }, "<Up>", "<Plug>(aibo-send)<Up>", opts)
					vim.keymap.set({ "n" }, "<Down>", "<Plug>(aibo-send)<Down>", opts)
					vim.keymap.set({ "n" }, "<Right>", "<Plug>(aibo-send)<Right>", opts)
					vim.keymap.set({ "n" }, "<Left>", "<Plug>(aibo-send)<Left>", opts)
					vim.keymap.set({ "n" }, "l", "<Plug>(aibo-send)<Right>", opts)
					vim.keymap.set({ "n" }, "h", "<Plug>(aibo-send)<Left>", opts)
					vim.keymap.set({ "n" }, "<C-P>", "<Plug>(aibo-send)<C-P>", opts)
					vim.keymap.set({ "n" }, "<C-N>", "<Plug>(aibo-send)<C-N>", opts)
					vim.keymap.set({ "n" }, "<C-L>", "<Plug>(aibo-send)<C-L>", opts)
					vim.keymap.set({ "n" }, "<C-C>", "<Plug>(aibo-send)<C-C>", opts)
					vim.keymap.set({ "n" }, "<Esc>", "<Plug>(aibo-send)<Esc>", opts)
					vim.keymap.set({ "n" }, "<BS>", "<Plug>(aibo-send)<BS>", opts)
					vim.keymap.set({ "n" }, "<Tab>", "<Plug>(aibo-send)<Tab>", opts)
					vim.keymap.set({ "n" }, "/", "<Plug>(aibo-send)/", opts)
					vim.keymap.set({ "n" }, "<C-G><C-O>", "<Plug>(aibo-send)", opts)
					vim.keymap.set({ "n" }, "<CR>", "<Plug>(aibo-submit)", opts)
					vim.keymap.set({ "n" }, "<F5>", "<Plug>(aibo-submit)", opts)
					vim.keymap.set({ "n" }, "<C-CR>", "<Plug>(aibo-submit)", opts)
				end,
			},
		})
	end,
}
