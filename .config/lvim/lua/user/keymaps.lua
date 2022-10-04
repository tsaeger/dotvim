-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- take-back vim built-ins
lvim.keys.visual_block_mode["J"] = false
lvim.keys.visual_block_mode["K"] = false

-- MacOS "Option-key" equivalent of Alt mappings
if vim.fn.has "mac" == 1 then
  -- Option-j ∆
  lvim.keys.visual_block_mode["∆"] = ":m '>+1<CR>gv-gv"
  -- Option-k ˚
  lvim.keys.visual_block_mode["˚"] = ":m '<-2<CR>gv-gv"
end

-- which-key bindings
-- Option toggles
lvim.builtin.which_key.mappings["o"] = require("user.optiontoggle").get_which_key_mappings()
-- Telescope additions
if lvim.builtin.which_key.mappings["s"]["s"] == nil then
  lvim.builtin.which_key.mappings["s"]["s"] = { "<cmd>Telescope resume<CR>", "Resume" }
end
if lvim.builtin.which_key.mappings["s"]["P"] == nil then
  lvim.builtin.which_key.mappings["s"]["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
end
-- Term tig
if lvim.builtin.which_key.mappings["g"]["t"] == nil then
  lvim.builtin.which_key.mappings["g"]["t"] = { "<cmd>TermExec cmd=\"tig\"<CR>", "tig" }
end
-- which_key Buffers
lvim.builtin.which_key.mappings["b"] = {
  name = "Buffers",
  b = { "<cmd>Telescope buffers<cr>", "List" },
  d = { "<cmd>bdelete<cr>", "Delete" },
  n = { "<cmd>bnext<cr>", "Next" },
  p = { "<cmd>bprev<cr>", "Prev" },
}
