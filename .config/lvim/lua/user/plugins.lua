-- Additional Plugins
lvim.plugins = {
  -- general editor
  { "ggandor/lightspeed.nvim" },
  { "jghauser/mkdir.nvim" },
  { "karb94/neoscroll.nvim" },
  { "cossonleo/dirdiff.nvim" },
  { "sindrets/diffview.nvim" },
  { "gpanders/editorconfig.nvim" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "ys",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
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
  { "tpope/vim-fugitive" },
  -- lua
  { "rafcamlet/nvim-luapad" },
  -- python
  { "AckslD/swenv.nvim" },
  { "mfussenegger/nvim-dap-python" },
  {
    -- generate docstrings
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "numpydoc",
            },
          },
        },
      })
    end,
  },
  -- TBD: jupyter
  -- {
  --   "dccsillag/magma-nvim",
  --   build = function()
  --     vim.cmd("UpdateRemotePlugins")
  --   end,
  -- },
  -- rust
  { "simrat39/rust-tools.nvim" },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },
  {
    "saecki/crates.nvim",
    version = "v0.3.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      })
    end,
  },
  -- colorscheme
  { "folke/tokyonight.nvim" },
  { "sainnhe/sonokai" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
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
