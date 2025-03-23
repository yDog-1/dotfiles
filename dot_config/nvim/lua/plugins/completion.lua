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
	["<C-J>"] = { "hide", "fallback" },
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
						score_offset = 30,
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
						score_offset = 95,
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
	{
		"vim-skk/skkeleton",
		dependencies = {
			"vim-denops/denops.vim",
		},
		keys = {
			-- <C-j>, <C-k>でskkeletonの切り替え
			{ "<C-j>", "<Plug>(skkeleton-enable)", mode = { "i", "c", "t" } },
			{ "<C-k>", "<Plug>(skkeleton-disable)", mode = { "i", "c", "t" } },
		},
		lazy = true,
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			vim.fn["skkeleton#config"]({
				globalDictionaries = {
					"~/.skk/SKK-JISYO.JIS2",
					"~/.skk/SKK-JISYO.JIS3_4",
					"~/.skk/SKK-JISYO.L",
					"~/.skk/SKK-JISYO.geo",
					"~/.skk/SKK-JISYO.jinmei",
					"~/.skk/SKK-JISYO.lisp",
					"~/.skk/SKK-JISYO.propernoun",
					"~/.skk/SKK-JISYO.station",
				},
				-- 候補選択メニューが出るまでの数
				showCandidatesCount = 2,
				-- Denoのインメモリキャッシュで高速化
				databasePath = "~/.cache/skkeleton/database.db",
				sources = { "deno_kv" },
				-- キャンセルの挙動
				immediatelyCancel = false,
			})
			require("denops-lazy").load("skkeleton", { wait_load = false })
		end,
	},
	-- skkeletonの入力中、右下にインジケータを表示
	{
		"delphinus/skkeleton_indicator.nvim",
		lazy = true,
		event = "User DenopsReady",
		branch = "v2",
		config = function()
			require("skkeleton_indicator").setup({
				zindex = 150,
			})
		end,
	},
}
