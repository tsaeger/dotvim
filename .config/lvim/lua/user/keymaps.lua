-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

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
  c = { "<cmd>bdelete<cr>", "Close" },
  n = { "<cmd>bnext<cr>", "Next" },
  p = { "<cmd>bprev<cr>", "Prev" },
}
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }
-- true-zen
-- lvim.builtin.which_key.mappings["z"] = {
--   name = "+Zen",
--   a = { "<cmd>TZAtaraxis<cr>", "Ataraxis" },
--   f = { "<cmd>TZFocus<cr>", "Focus" },
--   m = { "<cmd>TZMinimalist<cr>", "Minimalist" },
--   n = { "<cmd>TZNarrow<cr>", "Narrow" },
-- }
