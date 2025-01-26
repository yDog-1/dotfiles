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

-- ターミナル
local tMaps = {
  {"<C-W>n",      function () vim.cmd("new") end}, 
  {"<C-W><C-N>",  function () vim.cmd("new") end}, 
  {"<C-W>q",      function () vim.cmd("quit") end}, 
  {"<C-W><C-Q>",  function () vim.cmd("quit") end}, 
  {"<C-W>c",      function () vim.cmd("close") end}, 
  {"<C-W>o",      function () vim.cmd("only") end}, 
  {"<C-W><C-O>",  function () vim.cmd("only") end}, 
  {"<C-W><Down>", function () vim.cmd("wincmd j") end}, 
  {"<C-W><C-J>",  function () vim.cmd("wincmd j") end}, 
  {"<C-W>j",      function () vim.cmd("wincmd j") end}, 
  {"<C-W><Up>",   function () vim.cmd("wincmd k") end}, 
  {"<C-W><C-K>",  function () vim.cmd("wincmd k") end}, 
  {"<C-W>k",      function () vim.cmd("wincmd k") end}, 
  {"<C-W><Left>", function () vim.cmd("wincmd h") end}, 
  {"<C-W><C-H>",  function () vim.cmd("wincmd h") end}, 
  {"<C-W><BS>",   function () vim.cmd("wincmd h") end}, 
  {"<C-W>h",      function () vim.cmd("wincmd h") end}, 
  {"<C-W><Right>",function () vim.cmd("wincmd l") end}, 
  {"<C-W><C-L>",  function () vim.cmd("wincmd l") end}, 
  {"<C-W>l",      function () vim.cmd("wincmd l") end}, 
  {"<C-W>w",      function () vim.cmd("wincmd w") end}, 
  {"<C-W><C-W>",  function () vim.cmd("wincmd w") end}, 
  {"<C-W>W",      function () vim.cmd("wincmd W") end}, 
  {"<C-W>t",      function () vim.cmd("wincmd t") end}, 
  {"<C-W><C-T>",  function () vim.cmd("wincmd t") end}, 
  {"<C-W>b",      function () vim.cmd("wincmd b") end}, 
  {"<C-W><C-B>",  function () vim.cmd("wincmd b") end}, 
  {"<C-W>p",      function () vim.cmd("wincmd p") end}, 
  {"<C-W><C-P>",  function () vim.cmd("wincmd p") end}, 
  {"<C-W>P",      function () vim.cmd("wincmd P") end}, 
  {"<C-W>r",      function () vim.cmd("wincmd r") end}, 
  {"<C-W><C-R>",  function () vim.cmd("wincmd r") end}, 
  {"<C-W>R",      function () vim.cmd("wincmd R") end}, 
  {"<C-W>x",      function () vim.cmd("wincmd x") end}, 
  {"<C-W><C-X>",  function () vim.cmd("wincmd x") end}, 
  {"<C-W>K",      function () vim.cmd("wincmd K") end}, 
  {"<C-W>J",      function () vim.cmd("wincmd J") end}, 
  {"<C-W>H",      function () vim.cmd("wincmd H") end}, 
  {"<C-W>L",      function () vim.cmd("wincmd L") end}, 
  {"<C-W>T",      function () vim.cmd("wincmd T") end}, 
  {"<C-W>=",      function () vim.cmd("wincmd =") end}, 
  {"<C-W>-",      function () vim.cmd("wincmd -") end}, 
  {"<C-W>+",      function () vim.cmd("wincmd +") end}, 
  {"<C-W>z",      function () vim.cmd("pclose") end}, 
  "<C-W><C-Z>",  function () vim.cmd("pclose") end}, 
}
for i = 1, #tMaps do
  map('t', tMaps[i][1], tMaps[i][2])
end

