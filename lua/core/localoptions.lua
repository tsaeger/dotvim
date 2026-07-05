vim.opt.guifont = 'MesloLGM Nerd Font:h20'
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

-- System-specific configuration (shared dotvim, local overrides per machine)
-- Available myconfig functions:
--   myconfig.get_obsidian_vaults() — vault paths for this system
-- Available myconfig properties:
--   myconfig.format_on_write — auto-format on write toggle
--
-- Augment myconfig
-- :help vim.g
local myconfig = vim.g.myconfig
myconfig.format_on_write = true

-- Returns obsidian vault configuration for this system
function myconfig.get_obsidian_vaults()
  return {
    {
      name = 'wiki',
      path = '~/dev/wiki',
    },
    {
      name = 'wiki-personal',
      path = '~/dev/wiki-personal',
    },
  }
end

vim.g.myconfig = myconfig
