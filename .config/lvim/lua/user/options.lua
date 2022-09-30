-- general
vim.opt["guifont"] = "MesloLGS Nerd Font Mono:h20"
vim.opt["relativenumber"] = true
vim.opt["listchars"] = "tab:▸·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:␣"
-- vim.opt["listchars"] = "tab:▸·,nbsp:␣,extends:…,precedes:<,extends:>,trail:·"
-- vim.opt["listchars"] = "tab:»·,eol:↲,nbsp:␣,extends:…,space:␣,precedes:<,extends:>,trail:·"
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
lvim.use_icons = true

-- config for predefined plugins
-- NOTE: After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.breadcrumbs.active = true
lvim.builtin.bufferline.active = false
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
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
