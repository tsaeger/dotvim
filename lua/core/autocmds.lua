-- Autocommands and editor behavior hooks

-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.hl.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

local virtual_text = {
  prefix = '●',
  -- Add a custom format function to show error codes
  format = function(diagnostic)
    local code = diagnostic.code and string.format('[%s]', diagnostic.code) or ''
    return string.format('%s %s', code, diagnostic.message)
  end,
}
-- only show current line's diagnostic
virtual_text.current_line = true

-- Appearance of diagnostics
vim.diagnostic.config {
  virtual_text = virtual_text,
  underline = false,
  update_in_insert = true,
  float = {
    source = true, -- Or "if_many"
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = '»',
    },
  },
  -- Make diagnostic background transparent
  on_ready = function()
    vim.cmd 'highlight DiagnosticVirtualText guibg=NONE'
  end,
}
vim.keymap.set('n', '<leader>dv', function()
  if vim.diagnostic.config().virtual_text then
    vim.diagnostic.config { virtual_text = false }
  else
    vim.diagnostic.config { virtual_text = virtual_text }
  end
end, { desc = '[D]iagnostic [v]irtual_text toggle' })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

