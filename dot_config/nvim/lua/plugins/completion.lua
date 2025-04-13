local ime_disabled = true
local toggle_cmp = vim.api.nvim_create_augroup("toggle_cmp", { clear = true })
vim.api.nvim_create_autocmd("User", {
	group = toggle_cmp,
	pattern = { "skkeleton-mode-changed" },
	desc = "skkeletonで日本語入力中は補完を無効に",
	callback = function()
		local menu = require("blink.cmp.completion.windows.menu")
		if vim.g["skkeleton#mode"] == "" and not ime_disabled then
			menu.auto_show = true
			ime_disabled = true
		elseif ime_disabled then
			menu.auto_show = false
			ime_disabled = false
		end
	end,
})

local keymap = {
	preset = "none",
	["<C-N>"] = { "show", "select_next" },
	["<C-P>"] = { "select_prev" },
	["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
	["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	["<C-Y>"] = { "accept" },
	["<CR>"] = { "select_and_accept", "fallback" },
	["<C-G>"] = { "cancel", "fallback" },
	["<C-space>"] = { "show" },
	["<C-E>"] = { "hide" },
	["<C-K>"] = { "show_documentation", "fallback" },
	["<C-S>"] = { "show_signature" },
	["<C-U>"] = { "scroll_documentation_up", "fallback" },
	["<C-D>"] = { "scroll_documentation_down" },
}

return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
			"fang2hou/blink-copilot",
		},
		version = "*",
		event = { "InsertEnter", "CmdlineEnter" },
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = keymap,
			appearance = {
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer", "copilot" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 70,
					},
					lsp = {
						score_offset = 60,
					},
					snippets = {
						score_offset = 90,
					},
					buffer = {
						opts = {
							-- 全てのバッファから補完
							get_bufnrs = vim.api.nvim_list_bufs,
						},
					},
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 80,
						async = true,
					},
					codecompanion = {
						name = "codecompanion",
						module = "codecompanion.providers.completion.blink",
						score_offset = 100,
					},
				},
				min_keyword_length = function(ctx)
					-- :wq, :qa -> menu doesn't popup
					-- :Lazy, :help -> menu popup
					if ctx.mode == "cmdline" and ctx.line:find("^%l+$") ~= nil then
						return 4
					end
					return 0
				end,
				per_filetype = {
					codecompanion = { "codecompanion", "buffer" },
					gitcommit = { "snippets", "copilot" },
				},
			},
			signature = {
				enabled = true,
			},
			cmdline = {
				keymap = keymap,
				completion = {
					menu = {
						auto_show = true,
					},
				},
			},
			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			-- TODO: どういうものか調べる
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
