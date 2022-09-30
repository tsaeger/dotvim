vim.opt["guifont"] = "MesloLGS Nerd Font Mono:h20"
vim.opt["relativenumber"] = true
local listchars_sets = {
  [1] = "tab:▸·,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:␣",
  [2] = "tab:▸·,nbsp:␣,extends:…,precedes:<,extends:>,trail:·",
  [3] = "tab:»·,eol:↲,nbsp:␣,extends:…,space:␣,precedes:<,extends:>,trail:·",
}
vim.opt["listchars"] = listchars_sets[1]

lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
lvim.use_icons = true
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
