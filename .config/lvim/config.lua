-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
vim.opt["guifont"] = "MesloLGS Nerd Font Mono:h20"
vim.opt["relativenumber"] = true
lvim.use_icons = true
vim.opt["listchars"] = "tab:▸·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:␣"
-- vim.opt["listchars"] = "tab:▸·,nbsp:␣,extends:…,precedes:<,extends:>,trail:·"
-- vim.opt["listchars"] = "tab:»·,eol:↲,nbsp:␣,extends:…,space:␣,precedes:<,extends:>,trail:·"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"
-- vim.keymap.del("n", "<C-Up>")
-- vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- config for predefined plugins
-- NOTE: After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.breadcrumbs.active = true
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
-- lvim.builtin.indentlines.active = false
-- lvim.builtin.nvimtree.active = false
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "css",
  "javascript",
  "json",
  "lua",
  "python",
  "rust",
  "yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- LSP settings
lvim.lsp.diagnostics.virtual_text = false

-- formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
}

-- linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  { command = "flake8", filetypes = { "python" } },
  { command = "mypy", filetypes = { "python" } },
  { command = "shellcheck", extra_args = { "--severity", "warning" }, filetypes = { "bash" } },
  { command = "codespell" },
}

-- Additional Plugins
lvim.plugins = {
  { "ggandor/lightspeed.nvim" },
  { "j-hui/fidget.nvim" },
  { "gpanders/editorconfig.nvim" },
  { "sindrets/diffview.nvim" },
  { "cossonleo/dirdiff.nvim" },
  -- { "folke/trouble.nvim", cmd = "TroubleToggle" },
  -- { "simrat39/symbols-outline.nvim" },
  -- { "Pocco81/true-zen.nvim" },
}
pcall(function() require("fidget").setup() end)
pcall(function() require("optiontoggle").setup() end)
-- pcall(function() require("symbols-outline").setup() end)

-- which-key bindings
-- Option toggles
lvim.builtin.which_key.mappings["o"] = require("optiontoggle").get_which_key_mappings()

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

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})
