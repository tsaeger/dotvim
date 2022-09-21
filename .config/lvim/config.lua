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

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
-- lvim.builtin.nvimtree.active = false
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "css",
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
  -- { command = "isort", filetypes = { "python" } },
}

-- linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  { command = "flake8", filetypes = { "python" } },
  { command = "shellcheck", extra_args = { "--severity", "warning" }, filetypes = { "bash" } },
  { command = "codespell" },
}

-- Additional Plugins
lvim.plugins = {
  { "folke/trouble.nvim", cmd = "TroubleToggle" },
  { "ggandor/lightspeed.nvim" },
  { "simrat39/symbols-outline.nvim" },
  { "Pocco81/true-zen.nvim" },
  { "gpanders/editorconfig.nvim" },
  { "sindrets/diffview.nvim" },
  { "cossonleo/dirdiff.nvim" },
}
-- TODO: is there a better way to do this?
pcall(function() require("symbols-outline").setup() end)
pcall(function() require("optiontoggle").setup() end)

-- which-key bindings
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}

-- true-zen
lvim.builtin.which_key.mappings["z"] = {
  name = "+Zen",
  a = { "<cmd>TZAtaraxis<cr>", "Ataraxis" },
  f = { "<cmd>TZFocus<cr>", "Focus" },
  m = { "<cmd>TZMinimalist<cr>", "Minimalist" },
  n = { "<cmd>TZNarrow<cr>", "Narrow" },
}

-- Option toggles
lvim.builtin.which_key.mappings["o"] = {
  name = "+Options",
  c = { "<cmd>OptionToggleCursorline<cr>", "Toggle cursorline" },
  C = { "<cmd>OptionToggleCursorcolumn<cr>", "Toggle cursorcolumn" },
  g = { "<cmd>OptionToggleGitsigns<cr>", "Toggle git signs" },
  h = { "<cmd>OptionToggleHlsearch<cr>", "Toggle hlsearch" },
  l = { "<cmd>OptionToggleList<cr>", "Toggle list" },
  n = { "<cmd>OptionToggleNumber<cr>", "Toggle number" },
  p = { "<cmd>OptionTogglePaste<cr>", "Toggle paste" },
  o = { "<cmd>OptionToggleColorcolumn<cr>", "Toggle colorcolumn" },
  s = { "<cmd>OptionToggleSpell<cr>", "Toggle spell" },
  w = { "<cmd>OptionToggleWrap<cr>", "Toggle wrap" },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})
