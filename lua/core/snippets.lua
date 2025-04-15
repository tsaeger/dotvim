-- Custom code snippets for different purposes

-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
(vim.hl or vim.highlight).priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

local virtual_text = {
  prefix = '●',
  -- Add a custom format function to show error codes
  format = function(diagnostic)
    local code = diagnostic.code and string.format('[%s]', diagnostic.code) or ''
    return string.format('%s %s', code, diagnostic.message)
  end,
}
-- only show current line's diagnostic
if vim.version.ge(vim.version.parse(tostring(vim.version())), { 0, 11, 0 }) then
  virtual_text.current_line = true
end

-- Appearance of diagnostics
vim.diagnostic.config {
  virtual_text = virtual_text,
  underline = false,
  update_in_insert = true,
  float = {
    source = true, -- Or "if_many"
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
    (vim.hl or vim.highlight).on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'zsh',
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require('nvim-treesitter.highlight').attach(0, 'bash')
  end,
})
