return {
  "vim-denops/denops.vim",
  lazy = true,
  init = function()
    vim.g["denops#server#deno_args"] = {
      "-q",
      "--no-lock",
      "-A",
      "--unstable-kv",
    }
    end,
}
