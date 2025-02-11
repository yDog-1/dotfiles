return {
  {
    -- カラースキーム
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("sonokai")
    end,
    init = function()
      vim.g.sonokai_transparent_background = 1
    end,
  },
}
