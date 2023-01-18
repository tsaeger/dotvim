vim.opt["backup"] = false
vim.opt["guifont"] = "MesloLGS Nerd Font:h22"
vim.opt["relativenumber"] = true
vim.opt["wrap"] = false

lvim.colorscheme = ({ "lunar", "onedarker" })[1]
lvim.format_on_save = false
lvim.log.level = "warn"
lvim.use_icons = true

lvim.builtin.breadcrumbs.active = true
lvim.builtin.bufferline.active = false
lvim.builtin.dap.active = true

lvim.builtin.telescope.pickers.buffers.theme = "ivy"
lvim.builtin.telescope.pickers.live_grep.theme = "ivy"

lvim.builtin.terminal.active = true
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
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.ignore_install = { "haskell" }
