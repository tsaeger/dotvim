return {
  'milanglacier/minuet-ai.nvim',
  config = function()
    local mak = require 'macaltkey'
    require('minuet').setup {
      virtualtext = {
        auto_trigger_ft = {},
        keymap = {
          -- accept whole completion
          accept = mak.convert '<A-g>', -- option-g
          -- accept one line
          accept_line = mak.convert '<A-l>', -- option-l
          -- accept n lines (prompts for number)
          accept_n_lines = '<A-z>',
          -- Cycle to prev completion item, or manually invoke completion
          prev = mak.convert '<A-[>',
          -- Cycle to next completion item, or manually invoke completion
          next = mak.convert '<A-]>',
          dismiss = mak.convert '<A-e>',
        },
      },
      provider = 'openai_fim_compatible',
      n_completions = 1, -- recommend for local model for resource saving
      context_window = 1000,
      provider_options = {
        openai_fim_compatible = {
          api_key = 'TERM',
          name = 'Ollama',
          end_point = vim.g.myconfig.ollama.completion_url,
          model = vim.g.myconfig.ollama.model,
          optional = {
            max_tokens = 256,
            top_p = 0.9,
            stop = { '\n\n' },
          },
        },
      },
    }
    vim.keymap.set('n', '<leader>av', '<cmd>Minuet virtualtext toggle<cr>', { desc = 'AI virtualtext toggle' })
    vim.keymap.set('n', '<leader>oav', '<cmd>Minuet virtualtext toggle<cr>', { desc = 'AI virtualtext toggle' })
  end,
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'clvnkhr/macaltkey.nvim' },
    -- optional
    -- { 'hrsh7th/nvim-cmp' },
  },
}
