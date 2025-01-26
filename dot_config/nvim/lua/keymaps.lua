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

-- スペース + . で`~/.config/nvim`を開く
map(
  'n',
  '<Leader>.',
  function()
    vim.cmd('edit ~/.config/nvim')
  end
)


-- オペレーター待機モードのマッピング
-- 例：c8 で ci( の動きになる
map( 'o', '8', 'i(')
map( 'o', '2', 'i"')
map( 'o', '7', "i'")
map( 'o', '@', 'i`')
map( 'o', '[', 'i[')
map( 'o', '{', 'i{')

-- Ctrl + j と Ctrl + k で 段落の前後に移動
map( 'n', '<C-j>', '}' )
map( 'n', '<C-k>', '{' )

-- alt-j, alt-k で上下の行と入れ替える
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

