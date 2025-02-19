-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
-- vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
-- vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer
vim.keymap.set('n', '<leader>bb', '<cmd>Telescope buffers<cr>', { desc = 'Buffer list' })
vim.keymap.set('n', '<leader>bc', '<cmd>cd %:p:h<cr>', { desc = 'Cwd to current buffer' })
-- vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete' })
vim.keymap.set('n', '<leader>bd', '<cmd>Bwipeout<cr>', { desc = 'Delete' })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprev<cr>', { desc = 'Prev' })

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  if vim.diagnostic.jump then
    vim.diagnostic.jump { count = -1, float = true }
  else
    vim.diagnostic.goto_prev() -- needed in 0.10.x, deprecated >=0.11
  end
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
  if vim.diagnostic.jump then
    vim.diagnostic.jump { count = 1, float = true }
  else
    vim.diagnostic.goto_next() -- needed in 0.10.x, deprecated >=0.11
  end
end, { desc = 'Go to next diagnostic message' })
vim.keymap.set(
  'n',
  '<leader>do',
  vim.diagnostic.open_float,
  { desc = '[D]iagnostic [O]pen floating diagnostic message' }
)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = '[D]iagnostic [O]pen floating message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = '[D]iagnostic [l]ocation list open' })
vim.keymap.set('n', '<leader>dv', function()
  vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end, { desc = '[D]iagnostic [v]irtual_text toggle' })

-- Dashboard
vim.keymap.set('n', '<leader>;', function()
  Snacks.dashboard.open()
end, { desc = 'Open Dashboard' })
