-- Additional Plugins
lvim.plugins = {
  { "rcarriga/nvim-dap-ui" },
  { "ggandor/lightspeed.nvim" },
  { "j-hui/fidget.nvim" },
  { "gpanders/editorconfig.nvim" },
  { "sindrets/diffview.nvim" },
  { "cossonleo/dirdiff.nvim" },
  { "simrat39/rust-tools.nvim" },
  { "zegervdv/settle.nvim" },
  -- { "folke/trouble.nvim", cmd = "TroubleToggle" },
  -- { "simrat39/symbols-outline.nvim" },
  -- { "Pocco81/true-zen.nvim" },
}
pcall(function() require("fidget").setup() end)
pcall(function() require("user.optiontoggle").setup() end)
pcall(function() require("rust-tools").setup(
    {
      tools = {
        on_initialized = function()
          vim.cmd [[
          autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
        ]]
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
    }
  )
end)
pcall(function() require("settle").setup(
    {
      wrap = true,
      symbol = '!',
      keymaps = {
        next_conflict = '-n',
        prev_conflict = '-N',
        use_ours = '-u1',
        use_theirs = '-u2',
        close = '-q',
      },
    }
  )
end)
-- pcall(function() require("symbols-outline").setup() end)
