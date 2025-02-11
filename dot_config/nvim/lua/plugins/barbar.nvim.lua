return {
  "romgrk/barbar.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim",
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = function()
    local set = vim.keymap.set
    -- タブの切り替え
    set("n", "H", function()
      vim.cmd("BufferPrevious")
    end)
    set("n", "L", function()
      vim.cmd("BufferNext")
    end)

    -- タブの入れ替え
    set("n", "<Leader>h", function()
      vim.cmd("BufferMovePrevious")
    end)
    set("n", "<Leader>l", function()
      vim.cmd("BufferMoveNext")
    end)

    -- タブのピン
    set("n", "<Leader>bp", function()
      vim.cmd("BufferPin")
    end)
    -- バッファを閉じる
    set("n", "<Leader>bc", function()
      vim.cmd("BufferClose")
    end)

    return {
      animation = false,
      clickable = false,
    }
  end,
  version = "^1.0.0", -- optional: only update when a new 1.x version is released
}
