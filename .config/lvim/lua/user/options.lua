vim.opt["backup"] = false
vim.opt["guifont"] = "MesloLGS Nerd Font Mono:h20"
vim.opt["relativenumber"] = true
vim.opt["wrap"] = false

lvim.builtin.breadcrumbs.active = true
lvim.builtin.bufferline.active = false
lvim.colorscheme = "onedarker"
lvim.builtin.dap.active = true
lvim.builtin.terminal.active = true
lvim.format_on_save = false
lvim.log.level = "warn"
-- lvim.use_icons = true
-- lvim.builtin.dap.active = true
-- lvim.builtin.terminal.active = true
-- lvim.builtin.nvimtree.setup.view.side = "left"
-- lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "css",
  "javascript",
  "json",
  "lua",
  "python",
  "rust",
  "toml",
  "yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
-- lvim.builtin.treesitter.highlight.enable = true
