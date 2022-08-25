-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
vim.opt["guifont"] = "MesloLGS Nerd Font Mono:h20"
vim.opt["relativenumber"] = true
-- lvim.use_icons = false
-- 	 <-- do you see this?
vim.opt["listchars"] = "tab:▸·,eol:↲,nbsp:␣,extends:…,space:.,precedes:<,extends:>,trail:·"
-- vim.opt["listchars"] = "tab:▸·,nbsp:␣,extends:…,precedes:<,extends:>,trail:·"
-- vim.opt["listchars"] = "tab:»·,eol:↲,nbsp:␣,extends:…,space:␣,precedes:<,extends:>,trail:·"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Use which-key to add extra bindings with the leader-key prefix
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

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
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
lvim.builtin.treesitter.highlight.enabled = true

-- LSP settings
lvim.lsp.diagnostics.virtual_text = false

-- formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
}

-- linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  { command = "flake8", filetypes = { "python" } },
  { command = "shellcheck", extra_args = { "--severity", "warning" } },
  { command = "codespell", },
}

-- Additional Plugins
lvim.plugins = {
  { "folke/trouble.nvim", cmd = "TroubleToggle", },
  { "ggandor/lightspeed.nvim", }, -- https://github.com/ggandor/lightspeed.nvim
}

-- Options toggles
lvim.builtin.which_key.mappings["o"] = {
  name = "+Options",
  c = { "<cmd>lua vim.opt.cursorline = not vim.opt.cursorline:get()<cr>", "Toggle cursorline" },
  h = { "<cmd>lua vim.opt.hlsearch = not vim.opt.hlsearch:get()<cr>", "Toggle hlsearch" },
  l = { "<cmd>lua vim.opt.list = not vim.opt.list:get()<cr>", "Toggle list" },
  n = { "<cmd>lua vim.opt.number = not vim.opt.number:get(); vim.opt.relativenumber = not vim.opt.relativenumber:get()<cr>",
    "Toggle number" },
  s = { "<cmd>lua vim.opt.spell = not vim.opt.spell:get()<cr>", "Toggle spell" },
  w = { "<cmd>lua vim.opt.wrap = not vim.opt.wrap:get()<cr>", "Toggle wrap" },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})
