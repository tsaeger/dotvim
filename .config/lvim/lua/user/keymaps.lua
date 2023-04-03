-- vim.api.nvim_set_keymap("n", "<m-d>", "<cmd>RustOpenExternalDocs<Cr>", { noremap = true, silent = true })

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- take-back vim built-ins
-- lvim.keys.visual_block_mode["J"] = false
-- lvim.keys.visual_block_mode["K"] = false

-- MacOS "Option-key" equivalent of Alt mappings
if vim.fn.has("mac") == 1 then
  -- Option-j ∆
  lvim.keys.visual_block_mode["∆"] = ":m '>+1<CR>gv-gv"
  -- Option-k ˚
  lvim.keys.visual_block_mode["˚"] = ":m '<-2<CR>gv-gv"
end

-- which-key bindings
-- Option toggles
lvim.builtin.which_key.mappings["o"] = require("user.optiontoggle").get_which_key_mappings()
-- Telescope additions
if lvim.builtin.which_key.mappings["s"] then
  if not lvim.builtin.which_key.mappings["s"]["s"] then
    lvim.builtin.which_key.mappings["s"]["s"] = { "<cmd>Telescope resume<CR>", "Resume" }
  end
  if lvim.builtin.project.active then
    if not lvim.builtin.which_key.mappings["s"]["P"] then
      lvim.builtin.which_key.mappings["s"]["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
    end
  end
end
-- Term tig
if lvim.builtin.which_key.mappings["g"] and not lvim.builtin.which_key.mappings["g"]["t"] then
  lvim.builtin.which_key.mappings["g"]["t"] = { '<cmd>TermExec cmd="tig"<CR>', "tig" }
end
-- which_key Buffers
lvim.builtin.which_key.mappings["b"] = {
  name = "Buffers",
  b = { "<cmd>Telescope buffers<cr>", "List" },
  c = { "<cmd>cd %:p:h<cr>", "Cwd to current buffer" },
  d = { "<cmd>bdelete<cr>", "Delete" },
  n = { "<cmd>bnext<cr>", "Next" },
  p = { "<cmd>bprev<cr>", "Prev" },
}

if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
end
