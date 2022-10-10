-- vim.api.nvim_set_keymap("n", "<m-d>", "<cmd>RustOpenExternalDocs<Cr>", { noremap = true, silent = true })

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- take-back vim built-ins
lvim.keys.visual_block_mode["J"] = false
lvim.keys.visual_block_mode["K"] = false

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
  if not lvim.builtin.which_key.mappings["s"]["P"] then
    lvim.builtin.which_key.mappings["s"]["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
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
  d = { "<cmd>bdelete<cr>", "Delete" },
  n = { "<cmd>bnext<cr>", "Next" },
  p = { "<cmd>bprev<cr>", "Prev" },
}
-- -- Language Rust
-- lvim.builtin.which_key.mappings["L"] = {
--   name = "Rust",
--   r = { "<cmd>RustRunnables<Cr>", "Runnables" },
--   t = { "<cmd>lua _CARGO_TEST()<cr>", "Cargo Test" },
--   m = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
--   c = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
--   p = { "<cmd>RustParentModule<Cr>", "Parent Module" },
--   d = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
--   v = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
--   R = {
--     "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
--     "Reload Workspace",
--   },
--   o = { "<cmd>RustOpenExternalDocs<Cr>", "Open External Docs" },
-- }
