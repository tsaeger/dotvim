return {
  {
    'shaunsingh/nord.nvim',
    lazy = false,
    config = function()
      -- Example config in lua
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = true
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false

      -- Load the colorscheme
      -- require('nord').set()
      --
      --   -- Toggle background transparency
      --   local bg_transparent = true
      --
      --   local toggle_transparency = function()
      --     bg_transparent = not bg_transparent
      --     vim.g.nord_disable_background = bg_transparent
      --     vim.cmd.colorscheme 'nord'
      --   end
      --
      --   vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    opts = {},
    -- config = function()
    --   vim.cmd.colorscheme 'tokyonight-night'
    --   -- You can configure highlights by doing something like:
    --   vim.cmd.hi 'Comment gui=none'
    -- end,
  },
  { 'sainnhe/sonokai' },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    config = function()
      -- vim.g.catppuccin_flavour = "macchiato"
      -- vim.g.catppuccin_flavour = "latte"
      -- vim.g.catppuccin_flavour = "frappe"
      vim.g.catppuccin_flavour = 'mocha'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    lazy = false,
  },
}
