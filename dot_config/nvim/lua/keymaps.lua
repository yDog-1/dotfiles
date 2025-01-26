local map = vim.keymap.set

-- <Leader>をスペースキーに設定
vim.g.mapleader = ' '

-- jjでノーマルモードに戻る
map(
  'i',
  'jj',
  '<Esc>',
  { silent = true }
)

-- Space + h, j, k, l で、ウィンドウの移動
map('n', '<Leader>h', '<C-w>h')
map('n', '<Leader>j', '<C-w>j')
map('n', '<Leader>k', '<C-w>k')
map('n', '<Leader>l', '<C-w>l')

-- Alt-h, Alt-l でタブの切り替え
map('n', '<M-h>', function() vim.cmd('tabNext') end)
map('n', '<M-l>', function() vim.cmd('tabnext') end)

-- オペレーター待機モードのマッピング
-- 例：c8 で ci( の動きになる
map('o', '8', 'i(')
map('o', '2', 'i"')
map('o', '7', "i'")
map('o', '@', 'i`')
map('o', '[', 'i[')
map('o', '{', 'i{')

-- Ctrl-j と Ctrl-k で 段落の前後に移動
map('n', '<C-j>', '}')
map('n', '<C-k>', '{')

-- Alt-j, Alt-k で上下の行と入れ替える
-- 最上、最下の行では何も起こさない
map('n', '<M-j>', function()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local last_line = vim.api.nvim_buf_line_count(0)
  if current_line < last_line then
    vim.cmd('move .+1')
  end
end
)
map('n', '<M-k>', function()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  if current_line > 1 then
    vim.cmd('move .-2')
  end
end
)

-- Space + Enter で、カーソルの位置で改行
map('n', '<Leader><CR>', 'i<CR><Esc>')

-- Space + o, O で、行の上下に空白行を作成
map('n', '<Leader>o', 'o<Esc>')
map('n', '<Leader>O', 'O<Esc>')

