local map = vim.keymap.set

-- スペース + . で`~/.config/nvim`を開く
map(
  'n',
  '<Leader>.',
  function()
    vim.cmd('cd ~/.config/nvim')
    vim.cmd('Neotree')
  end
)

-- スペース + e で`:Neotree`
map(
  'n',
  '<Leader>e',
  function()
    vim.cmd('Neotree')
  end
)

