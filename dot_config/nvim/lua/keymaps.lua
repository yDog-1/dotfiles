local set = vim.keymap.set

-- <Leader>をスペースキーに設定
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = ' '

-- jjでノーマルモードに戻る
set(
  'i',
  'jj',
  '<Esc>',
  { silent = true }
)

-- Alt-h, Alt-l でタブの切り替え
set('n', '<M-h>', function() vim.cmd('tabNext') end)
set('n', '<M-l>', function() vim.cmd('tabnext') end)

-- Ctrl-j と Ctrl-k で 段落の前後に移動
set('n', '<C-j>', '}')
set('n', '<C-k>', '{')

-- Alt-j, Alt-k で上下の行と入れ替える
-- 最上、最下の行では何も起こさない
set('n', '<M-j>', function()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local last_line = vim.api.nvim_buf_line_count(0)
  if current_line < last_line then
    vim.cmd('move .+1')
  end
end
)
set('n', '<M-k>', function()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  if current_line > 1 then
    vim.cmd('move .-2')
  end
end
)

-- Space + Enter で、カーソルの位置で改行
set('n', '<Leader><CR>', 'i<CR><Esc>')

-- Space + o, O で、行の上下に空白行を作成
set('n', '<Leader>o', 'o<Esc>')
set('n', '<Leader>O', 'O<Esc>')

-- ウィンドウ操作
set('n', '<C-h>', '<C-w>h')
set('n', '<C-j>', '<C-w>j')
set('n', '<C-k>', '<C-w>k')
set('n', '<C-l>', '<C-w>l')
-- ターミナルでエスケープ
set("t", "<Esc>", "<C-\\><C-n>")


