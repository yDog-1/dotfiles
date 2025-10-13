local default_tool = {
	name = "codex",
	focus = true,
}

local user_sidekick_autocmd = vim.api.nvim_create_augroup("UserSidekick", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = user_sidekick_autocmd,
	pattern = "sidekick_terminal",
	callback = function()
		vim.keymap.set({ "n", "t" }, "<c-q>", "<cmd>wincmd q<cr>", { buffer = true, desc = "Close window" })
	end,
})

return {
	"folke/sidekick.nvim",
	opts = {
		cli = {
			win = {
				layout = "float",
			},
			mux = {
				backend = "zellij",
				enabled = true,
			},
		},
	},
	keys = {
		{
			"<tab>",
			function()
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>" -- fallback to normal tab
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			"<leader>ast",
			function()
				require("sidekick.cli").toggle(default_tool)
			end,
			mode = { "n", "v" },
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>ass",
			function()
				require("sidekick.cli").select({ filter = { installed = true } })
			end,
			desc = "Sidekick Select CLI",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").send(vim.tbl_extend("force", { selection = true }, default_tool))
			end,
			mode = { "v" },
			desc = "Sidekick Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "v" },
			desc = "Sidekick Select Prompt",
		},
	},
}
