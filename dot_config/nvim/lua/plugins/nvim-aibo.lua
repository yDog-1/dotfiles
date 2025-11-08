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
					vim.api.nvim_create_autocmd("VimLeavePre", {
						group = vim.api.nvim_create_augroup("AiboClose", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.cmd("bwipeout! " .. bufnr)
						end,
					})

					-- for ddc.vim
					vim.fn["ddc#custom#patch_buffer"]("specialBufferCompletion", true)
				end,
			},
			console = {
				on_attach = function(bufnr)
					vim.api.nvim_create_autocmd("VimLeavePre", {
						group = vim.api.nvim_create_augroup("AiboClose", { clear = true }),
						buffer = bufnr,
						callback = function()
							vim.o.hidden = true
							vim.cmd("bwipeout! " .. bufnr)
						end,
					})
				end,
			},
		})
	end,
}
