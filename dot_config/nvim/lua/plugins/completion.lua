local cmp_sources = {
	{ name = "nvim_lsp_signature_help" },
	{ name = "path" },
	{ name = "copilot" },
	{ name = "nvim_lsp" },
	{ name = "luasnip" },
	{ name = "buffer" },
	{ name = "git" },
	{ name = "lazydev", group_index = 0 },
	{ name = "codecompanion" },
}

-- skkeleton と nvim-cmp の連携
local ime_disabled = true
local toggle_cmp = vim.api.nvim_create_augroup("toggle_cmp", { clear = true })
vim.api.nvim_create_autocmd("User", {
	group = toggle_cmp,
	pattern = { "skkeleton-mode-changed" },
	desc = "skkeletonで日本語入力中は補完を無効に",
	callback = function()
		local cmp = require("cmp")
		if vim.g["skkeleton#mode"] == "" and not ime_disabled then
			cmp.setup({ sources = cmp.config.sources(cmp_sources) })
			ime_disabled = true
		elseif ime_disabled then
			cmp.setup({
				sources = {
					{ name = "skkeleton" },
					{ name = "copilot" },
				},
			})
			ime_disabled = false
		end
	end,
})

return {
	-- Neovimに最適化された LuaLS
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				"LazyVim",
			},
		},
	},
	-- スニペット
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		dependencies = {
			-- 補完と連携
			"saadparwaiz1/cmp_luasnip",
			-- VSCode風スニペット
			"rafamadriz/friendly-snippets",
		},
	},
	-- 補完
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- VSCode風アイコン表示
			"onsails/lspkind.nvim",
			-- バッファ
			"hrsh7th/cmp-buffer",
			-- パス
			"hrsh7th/cmp-path",
			-- コマンドライン
			"hrsh7th/cmp-cmdline",
			-- LSPソース
			"hrsh7th/cmp-nvim-lsp",
			-- スニペット
			"L3MON4D3/LuaSnip",
			-- 関数のシグネチャを表示
			"hrsh7th/cmp-nvim-lsp-signature-help",
			-- copilot
			"zbirenbaum/copilot-cmp",
			-- skkeleton
			"uga-rosa/cmp-skkeleton",
			-- Git
			"petertriho/cmp-git",
			-- コマンドラインでの `input()` プロンプトの補完
			-- vim-gin の action で使う
			"teramako/cmp-cmdline-prompt.nvim",
		},
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			require("luasnip.loaders.from_vscode").lazy_load()
			lspkind.init({
				symbol_map = {
					Copilot = " ",
				},
			})

			cmp.setup({
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol", -- アイコンのみを表示する
						maxwidth = {
							menu = function()
								-- ウィンドウの45%の幅
								return math.floor(0.45 * vim.o.columns)
							end,
							abbr = 50,
						},
						-- はみ出た文字列を省略するときの文字
						ellipsis_char = "...",
						show_labelDetails = true,
					}),
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						scrollbar = false,
						zindex = 100,
					},
					documentation = {
						zindex = 100,
					},
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-g>"] = cmp.mapping.abort(),

					["<CR>"] = cmp.mapping(function(fallback)
						-- 何も選択していないときは改行
						if cmp.get_selected_index() == nil then
							fallback()
							return
						end
						-- スニペットが展開可能なときは展開
						if luasnip.expandable() then
							luasnip.expand()
							return
						end
						-- それ以外は補完を確定
						cmp.confirm({
							select = true,
						})
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				experimental = {
					ghost_text = true,
				},
				sources = cmp.config.sources(cmp_sources),
			})
			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				view = {
					entries = { name = "wildmenu", separator = "|" },
				},
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				view = {
					entries = { name = "wildmenu", separator = "|" },
				},
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})

			-- input()
			cmp.setup.cmdline("@", {
				sources = cmp.config.sources({
					{ name = "cmdline-prompt" },
				}),
			})
		end,
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
			-- <CR> で確定
			vim.fn["skkeleton#register_keymap"]("henkan", "<CR>", "kakutei")
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
