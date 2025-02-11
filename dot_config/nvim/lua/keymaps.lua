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

-- Space + h, j, k, l で、ウィンドウの移動
set('n', '<Leader>h', '<C-w>h')
set('n', '<Leader>j', '<C-w>j')
set('n', '<Leader>k', '<C-w>k')
set('n', '<Leader>l', '<C-w>l')

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

-- ターミナル
set("t", "<C-W>n",      function () vim.cmd("new") end )
set("t", "<C-W><C-N>",  function () vim.cmd("new") end )
set("t", "<C-W>q",      function () vim.cmd("quit") end )
set("t", "<C-W><C-Q>",  function () vim.cmd("quit") end )
set("t", "<C-W>c",      function () vim.cmd("close") end )
set("t", "<C-W>o",      function () vim.cmd("only") end )
set("t", "<C-W><C-O>",  function () vim.cmd("only") end )
set("t", "<C-W><Down>", function () vim.cmd("wincmd j") end )
set("t", "<C-W><C-J>",  function () vim.cmd("wincmd j") end )
set("t", "<C-W>j",      function () vim.cmd("wincmd j") end )
set("t", "<C-W><Up>",   function () vim.cmd("wincmd k") end )
set("t", "<C-W><C-K>",  function () vim.cmd("wincmd k") end )
set("t", "<C-W>k",      function () vim.cmd("wincmd k") end )
set("t", "<C-W><Left>", function () vim.cmd("wincmd h") end )
set("t", "<C-W><C-H>",  function () vim.cmd("wincmd h") end )
set("t", "<C-W><BS>",   function () vim.cmd("wincmd h") end )
set("t", "<C-W>h",      function () vim.cmd("wincmd h") end )
set("t", "<C-W><Right>",function () vim.cmd("wincmd l") end )
set("t", "<C-W><C-L>",  function () vim.cmd("wincmd l") end )
set("t", "<C-W>l",      function () vim.cmd("wincmd l") end )
set("t", "<C-W>w",      function () vim.cmd("wincmd w") end )
set("t", "<C-W><C-W>",  function () vim.cmd("wincmd w") end )
set("t", "<C-W>W",      function () vim.cmd("wincmd W") end )
set("t", "<C-W>t",      function () vim.cmd("wincmd t") end )
set("t", "<C-W><C-T>",  function () vim.cmd("wincmd t") end )
set("t", "<C-W>b",      function () vim.cmd("wincmd b") end )
set("t", "<C-W><C-B>",  function () vim.cmd("wincmd b") end )
set("t", "<C-W>p",      function () vim.cmd("wincmd p") end )
set("t", "<C-W><C-P>",  function () vim.cmd("wincmd p") end )
set("t", "<C-W>P",      function () vim.cmd("wincmd P") end )
set("t", "<C-W>r",      function () vim.cmd("wincmd r") end )
set("t", "<C-W><C-R>",  function () vim.cmd("wincmd r") end )
set("t", "<C-W>R",      function () vim.cmd("wincmd R") end )
set("t", "<C-W>x",      function () vim.cmd("wincmd x") end )
set("t", "<C-W><C-X>",  function () vim.cmd("wincmd x") end )
set("t", "<C-W>K",      function () vim.cmd("wincmd K") end )
set("t", "<C-W>J",      function () vim.cmd("wincmd J") end )
set("t", "<C-W>H",      function () vim.cmd("wincmd H") end )
set("t", "<C-W>L",      function () vim.cmd("wincmd L") end )
set("t", "<C-W>T",      function () vim.cmd("wincmd T") end )
set("t", "<C-W>=",      function () vim.cmd("wincmd =") end )
set("t", "<C-W>-",      function () vim.cmd("wincmd -") end )
set("t", "<C-W>+",      function () vim.cmd("wincmd +") end )
set("t", "<C-W>z",      function () vim.cmd("pclose") end )
set("t", "<C-W><C-Z>",  function () vim.cmd("pclose") end )

