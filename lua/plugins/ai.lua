return {
  'olimorris/codecompanion.nvim',
  version = '^18.0.0',
  -- Only invoked via :CodeCompanion* commands (see core/keymaps.lua <leader>a*),
  -- so defer loading until first use — saves ~6ms at startup.
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions', 'CodeCompanionCmd' },
  opts = {
    interactions = {
      chat = {
        adapter = 'opencode',
      },
      inline = {
        adapter = 'opencode',
      },
    },
    opts = {
      log_level = 'INFO',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
