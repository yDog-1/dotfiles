local set = vim.keymap.set

-- <Leader>をスペースキーに設定
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- jjでノーマルモードに戻る
set("i", "jj", "<Esc>", { silent = true })

-- Alt-j, Alt-k で上下の行と入れ替える
-- 最上、最下の行では何も起こさない
set("n", "<M-j>", function()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local last_line = vim.api.nvim_buf_line_count(0)
	if current_line < last_line then
		vim.cmd("move .+1")
	end
end)
set("n", "<M-k>", function()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	if current_line > 1 then
		vim.cmd("move .-2")
	end
end)

-- Leader + n で、ハイライトを消す
set("n", "<Leader>n", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })

-- Space + Enter で、カーソルの位置で改行
set("n", "<Leader><CR>", "i<CR><Esc>", { desc = "Insert newline from cursor" })

-- Space + o, O で、行の上下に空白行を作成
set("n", "<Leader>o", 'o<Esc>0"_d$', { desc = "Insert newline below" })
set("n", "<Leader>O", 'O<Esc>0"_d$', { desc = "Insert newline above" })

-- Xをブラックホール register に割り当て
set({ "n", "v" }, "x", '"_x')
set({ "n", "v" }, "X", '"_d')

-- ウィンドウ操作
set("n", "<C-h>", "<C-w>h")
set("n", "<C-j>", "<C-w>j")
set("n", "<C-k>", "<C-w>k")
set("n", "<C-l>", "<C-w>l")
