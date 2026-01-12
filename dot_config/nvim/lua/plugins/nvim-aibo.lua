local open_codex_cmd = [[<cmd>Aibo -opener=botright\ vsplit -stay -toggle codex<CR>]]

return {
	"lambdalisue/nvim-aibo",
	lazy = false,
	dependencies = {
		"https://github.com/Shougo/ddc.vim",
	},
	keys = {
		{ "<leader>aa", open_codex_cmd, desc = "Aibo Codex" },
		{
			"<leader>as",
			function()
				local aibo_console = require("aibo.internal.console_window")
				local bufname = vim.fn.bufname("%")
				-- pwd .. file path
				local filename_from_pwd = vim.fn.fnamemodify(bufname, ":p:.")
				local codex = aibo_console.find_info_globally({ cmd = "codex" }) or { winid = -1 }
				local ret = ""
				if codex.winid == -1 then
					ret = open_codex_cmd
				end
				return ret .. [[<cmd>AiboSend -input -prefix="]] .. filename_from_pwd .. [[\n\n"<CR>]]
			end,
			desc = "Aibo Send to Codex",
			expr = true,
		},
	},
	config = function()
		---@diagnostic disable-next-line: redundant-parameter
		require("aibo").setup({
			disable_startinsert_on_insert = false,
			disable_startinsert_on_startup = true,
			prompt_height = 20,
			prompt = {
				on_attach = function(bufnr)
					vim.o.hidden = true

					local opts = { buffer = bufnr, nowait = true, silent = true }
					vim.keymap.set({ "n" }, "<CR>", "<Plug>(aibo-submit)", opts)
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
					vim.keymap.set({ "n" }, "<C-C>", "<Plug>(aibo-send)<Esc>", opts)
					vim.keymap.set({ "n" }, "<F5>", "<Plug>(aibo-submit)<Cmd>q<CR>", opts)
					vim.keymap.set({ "n" }, "<C-CR>", "<Plug>(aibo-submit)<Cmd>q<CR>", opts)
					vim.keymap.set({ "n" }, "<C-G><C-O>", "<Plug>(aibo-send)", opts)

					-- for ddc.vim
					vim.fn["ddc#custom#patch_buffer"]("specialBufferCompletion", true)
				end,
			},
			console = {
				on_attach = function(bufnr)
					vim.o.hidden = true

					local opts = { buffer = bufnr, nowait = true, silent = true }
					vim.keymap.set({ "n" }, "<C-K>", "<Plug>(aibo-send)<Up>", opts)
					vim.keymap.set({ "n" }, "<C-J>", "<Plug>(aibo-send)<Down>", opts)
					vim.keymap.set({ "n" }, "<PageDown>", "<Plug>(aibo-send)<PageDown>", opts)
					vim.keymap.set({ "n" }, "<PageUp>", "<Plug>(aibo-send)<PageUp>", opts)
					vim.keymap.set({ "n" }, "<End>", "<Plug>(aibo-send)<End>", opts)
					vim.keymap.set({ "n" }, "<Home>", "<Plug>(aibo-send)<Home>", opts)
					vim.keymap.set({ "n" }, "<Up>", "<Plug>(aibo-send)<Up>", opts)
					vim.keymap.set({ "n" }, "<Down>", "<Plug>(aibo-send)<Down>", opts)
					vim.keymap.set({ "n" }, "<C-P>", "<Plug>(aibo-send)<C-P>", opts)
					vim.keymap.set({ "n" }, "<C-N>", "<Plug>(aibo-send)<C-N>", opts)
					vim.keymap.set({ "n" }, "<C-L>", "<Plug>(aibo-send)<C-L>", opts)
					vim.keymap.set({ "n" }, "<C-C>", "<Plug>(aibo-send)<Esc>", opts)
					vim.keymap.set({ "n" }, "<F5>", "<Plug>(aibo-submit)", opts)
					vim.keymap.set({ "n" }, "<C-CR>", "<Plug>(aibo-submit)", opts)
					vim.keymap.set({ "n" }, "<C-G><C-O>", "<Plug>(aibo-send)", opts)
				end,
			},
		})
	end,
}
