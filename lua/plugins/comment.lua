-- Easily comment visual regions/lines
return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
    local api = require 'Comment.api'
    vim.keymap.set('n', '<C-_>', api.toggle.linewise.current, { desc = 'Toggle comment' })
    vim.keymap.set('n', '<C-c>', api.toggle.linewise.current, { desc = 'Toggle comment' })
    vim.keymap.set('n', '<C-/>', api.toggle.linewise.current, { desc = 'Toggle comment' })
    vim.keymap.set(
      'v',
      '<C-_>',
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      { desc = 'Toggle comment' }
    )
    vim.keymap.set(
      'v',
      '<C-c>',
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      { desc = 'Toggle comment' }
    )
    vim.keymap.set(
      'v',
      '<C-/>',
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      { desc = 'Toggle comment' }
    )
  end,
}
