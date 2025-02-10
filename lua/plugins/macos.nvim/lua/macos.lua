local _M = {}

_M.setup = function()
  local opts = { noremap = true, silent = true }

  -- Move selected visual block up/down one line at-a-time
  if vim.fn.has 'mac' == 1 then
    -- MacOS "Option-key" equivalent of Alt mappings
    local mak = require 'macaltkey'
    -- Option-j ∆
    -- vim.keymap.set('v', '∆', ":m '>+1<CR>gv-gv", opts)
    mak.keymap.set('v', '<A-j>', ":m '>+1<CR>gv-gv", opts)
    -- Option-k ˚
    -- vim.keymap.set('v', '˚', ":m '<-2<CR>gv-gv", opts)
    mak.keymap.set('v', '<A-k>', ":m '<-2<CR>gv-gv", opts)
  end

  -- neovide Keymaps
  if vim.g.neovide then
    vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
    vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
    vim.keymap.set('v', '<D-c>', '"+y') -- Copy
    vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
    vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
    vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
    vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

    -- Allow clipboard copy paste in neovim
    vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', opts)
    vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', opts)
    vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', opts)
    vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', opts)
  end
end

return _M
