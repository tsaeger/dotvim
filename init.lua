local thisdir = vim.env.MYNVIM_BASE_DIR or (function()
  local fpath = debug.getinfo(1, 'S').source
  return fpath:sub(2):match('(.*[/\\])'):sub(1, -2)
end)()

local luapath = thisdir .. '/lua'
---@diagnostic disable-next-line: param-type-mismatch
if not vim.tbl_contains(vim.opt.rtp:get(), luapath) then
  vim.opt.rtp:prepend(luapath)
end

---@diagnostic disable-next-line: param-type-mismatch
if not vim.tbl_contains(vim.opt.rtp:get(), thisdir) then
  vim.opt.rtp:prepend(thisdir)
end

require 'core.options' -- Load general options
require 'core.localoptions' -- Load local options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require('lazy').setup({
  require 'plugins.neotree',
  require 'plugins.colortheme',
  require 'plugins.bufferline',
  require 'plugins.lualine',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.none-ls',
  require 'plugins.gitsigns',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.misc',
  require 'plugins.comment',
}, {
  rocks = {
    enabled = false,
    hererocs = false,
  },
})

-- vim: ts=2 sts=2 sw=2 et
