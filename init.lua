-- [[
-- Tom Saeger <tom.saeger@gmail.com>
--
-- Hints:
-- https://tech.serhatteker.com/post/2022-07/dump-command-output-to-buffer-in-neovim/
-- :enew|put=execute('scriptnames')
-- :enew|put=execute(':lua=_G')
-- :enew|put=execute(':lua=package.loaded')
-- :enew|.!jq -r '.| keys[] |@text' ./lazy-lock.json | sort
-- ]]

--- path_join is needed in isolated-mode to find core.util
--- copy here
---Join input path segments
---@return string
local path_join = function(...)
  local path_sep = (vim.uv or vim.loop).os_uname().version:match 'Windows' and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

local thisconfig, thisdir = (function()
  local fpath = debug.getinfo(1, 'S').source
  return fpath:sub(2), fpath:sub(2):match('(.*[/\\])'):sub(1, -2)
end)()

local luapath = path_join(thisdir, 'lua')
---@diagnostic disable-next-line: param-type-mismatch
if not vim.tbl_contains(vim.opt.rtp:get(), luapath) then
  vim.opt.rtp:prepend(luapath)
end

---@diagnostic disable-next-line: param-type-mismatch
if not vim.tbl_contains(vim.opt.rtp:get(), thisdir) then
  vim.opt.rtp:prepend(thisdir)
end

-- Make myconfig available globally
local myconfig = {}
myconfig.util = require 'core.util'
myconfig.configfile = thisconfig
myconfig.configdir = thisdir
vim.g.myconfig = myconfig

require 'core.options' -- Load general options
require 'core.localoptions' -- Load local options
require 'core.keymaps' -- Load general keymaps
require 'core.snippets' -- Custom code snippets

-- Set up Lazy plugin manager
---@diagnostic disable-next-line: undefined-field
local lazypath = vim.g.myconfig.util.path_join(vim.fn.stdpath 'data', 'lazy', 'lazy.nvim')
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
  require 'plugins.misc',
  require 'plugins.comment',
  require 'plugins.snacks',
}, {
  rocks = {
    enabled = false,
    hererocs = false,
  },
})

vim.cmd.colorscheme 'kanagawa-wave'
-- vim.cmd.colorscheme 'tokyonight-night'

-- vim: ts=2 sts=2 sw=2 et
