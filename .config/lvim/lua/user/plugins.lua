-- Additional Plugins
lvim.plugins = {
  { "cossonleo/dirdiff.nvim" },
  { "ggandor/lightspeed.nvim" },
  { "gpanders/editorconfig.nvim" },
  { "jghauser/mkdir.nvim" },
  { "karb94/neoscroll.nvim" },
  { "sainnhe/sonokai" },
  { "simrat39/rust-tools.nvim" },
  { "sindrets/diffview.nvim" },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },
  {
    "saecki/crates.nvim",
    tag = "v0.3.0",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      })
    end,
  },
  {
    "zegervdv/settle.nvim",
    config = function()
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
    end,
  },
  {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      -- vim.g.catppuccin_flavour = "macchiato"
      -- vim.g.catppuccin_flavour = "latte"
      -- vim.g.catppuccin_flavour = "frappe"
      vim.g.catppuccin_flavour = "mocha"
      -- require("catppuccin").setup()
      -- vim.api.nvim_command("colorscheme catppuccin")
    end,
  },
}
pcall(function()
  require("user.optiontoggle").setup()
end)
