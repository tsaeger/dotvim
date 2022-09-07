-- Description: neovim plugin to provide functions to toggle various options
--      Author: Tom Saeger <tom.saeger@gmail.com>
--        Date: September 2022

local _M = {}
_M.options = nil

local function with_defaults(options)
  return {
    colorcolumn = options and options.colorcolumn or "79"
  }
end

_M.OptionToggleCursorline = function()
  vim.o.cursorline = not vim.o.cursorline
end

_M.OptionToggleCursorcolumn = function()
  vim.o.cursorcolumn = not vim.o.cursorcolumn
end

_M.OptionToggleGitsigns = function()
  vim.cmd [[ Gitsigns toggle_signs ]]
end

_M.OptionToggleHlsearch = function()
  vim.o.hlsearch = not vim.o.hlsearch
end

_M.OptionToggleList = function()
  vim.o.list = not vim.o.list
end

_M.OptionToggleNumber = function()
  vim.o.number = not vim.o.number
  vim.o.relativenumber = not vim.o.relativenumber
end

_M.OptionTogglePaste = function()
  vim.o.paste = not vim.o.paste
end

_M.OptionToggleColorcolumn = function()
  local col = _M.options.colorcolumn
  for _, v in ipairs(vim.opt.colorcolumn:get()) do
    if v == col then
      vim.opt.colorcolumn:remove(v)
      goto done
    end
  end
  vim.opt.colorcolumn:append(col)
  ::done::
end

_M.OptionToggleSpell = function()
  vim.o.spell = not vim.o.spell
end

_M.OptionToggleWrap = function()
  vim.o.wrap = not vim.o.wrap
end

_M.setup = function(options)
  _M.options = with_defaults(options)
  for k, v in pairs(_M) do
    if not string.match(k, "OptionToggle") then
      goto next
    end
    vim.api.nvim_create_user_command(k, v, {})
    ::next::
  end
end

return _M
