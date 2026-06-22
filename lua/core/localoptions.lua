vim.opt.guifont = 'MesloLGS Nerd Font:h20'
vim.g.have_nerd_font = true

-- This config is pure Lua — no plugin uses a remote-plugin host — so disable all
-- language providers. Speeds startup and silences :checkhealth provider warnings.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- shadafile
if vim.o.shadafile ~= nil then
  ---@diagnostic disable-next-line: undefined-field
  vim.o.shadafile = vim.g.myconfig.util.path_join(vim.fn.stdpath 'cache', 'shada.dat')
end

-- Augment myconfig
-- :help vim.g
local myconfig = vim.g.myconfig
myconfig.format_on_write = true
vim.g.myconfig = myconfig
