-- Additional Plugins
lvim.plugins = {
  { "cossonleo/dirdiff.nvim" },
  { "ggandor/lightspeed.nvim" },
  { "gpanders/editorconfig.nvim" },
  { "j-hui/fidget.nvim" },
  { "karb94/neoscroll.nvim" },
  { "simrat39/rust-tools.nvim" },
  { "sindrets/diffview.nvim" },
  { "zegervdv/settle.nvim" },
}
pcall(function()
  require("user.optiontoggle").setup()
end)
pcall(function()
  require("fidget").setup()
end)
pcall(function()
  require("rust-tools").setup({
    tools = {
      on_initialized = function()
        vim.cmd([[
          autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
        ]])
      end,
    },
    server = {
      settings = {
        ["rust-analyzer"] = {
          lens = {
            enable = true,
          },
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  })
end)
pcall(function()
  require("settle").setup({
    wrap = true,
    symbol = "!",
    keymaps = {
      next_conflict = "-n",
      prev_conflict = "-N",
      use_ours = "-u1",
      use_theirs = "-u2",
      close = "-q",
    },
  })
end)
