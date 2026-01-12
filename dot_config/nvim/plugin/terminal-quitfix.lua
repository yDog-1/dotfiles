local augroup = vim.api.nvim_create_augroup("ydog.terminal_quitfix", { clear = false })

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function(args)
		vim.bo[args.buf].bufhidden = "wipe"

		local quit_group =
			vim.api.nvim_create_augroup("ydog.terminal_quitfix.buf" .. tostring(args.buf), { clear = true })
		vim.api.nvim_create_autocmd({ "VimLeavePre", "ExitPre" }, {
			group = quit_group,
			callback = function()
				if vim.api.nvim_buf_is_valid(args.buf) then
					vim.api.nvim_buf_delete(args.buf, { force = true })
				end
				vim.cmd("qall")
			end,
		})
	end,
})
