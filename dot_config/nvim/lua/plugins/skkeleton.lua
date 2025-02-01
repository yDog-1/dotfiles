return {
  "vim-skk/skkeleton",
  dependencies = {
    "vim-denops/denops.vim",
  },
  keys = {
    {'<C-j>', '<Plug>(skkeleton-toggle)', mode = { 'i', 'c', 't' } }
  }
}
