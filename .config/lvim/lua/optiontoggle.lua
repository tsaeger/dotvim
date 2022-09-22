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

_M.OptionToggleIndentlines = function()
  pcall(function() vim.cmd [[ IndentBlanklineToggle ]] end)
end

_M.OptionToggleEdit2 = function()
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.expandtab = true
end

_M.OptionToggleEdit4 = function()
  vim.opt.shiftwidth = 4
  vim.opt.tabstop = 4
  vim.opt.expandtab = true
end

_M.OptionToggleEdit8 = function()
  vim.opt.shiftwidth = 8
  vim.opt.tabstop = 8
  vim.opt.expandtab = false
end

_M.get_which_key_mappings = function()
  return {
    name = "+Options",
    c = { "<cmd>OptionToggleCursorline<cr>", "Toggle cursorline" },
    C = { "<cmd>OptionToggleCursorcolumn<cr>", "Toggle cursorcolumn" },
    g = { "<cmd>OptionToggleGitsigns<cr>", "Toggle git signs" },
    h = { "<cmd>OptionToggleHlsearch<cr>", "Toggle hlsearch" },
    i = { "<cmd>OptionToggleIndentlines<cr>", "Toggle indent" },
    l = { "<cmd>OptionToggleList<cr>", "Toggle list" },
    n = { "<cmd>OptionToggleNumber<cr>", "Toggle number" },
    p = { "<cmd>OptionTogglePaste<cr>", "Toggle paste" },
    o = { "<cmd>OptionToggleColorcolumn<cr>", "Toggle colorcolumn" },
    s = { "<cmd>OptionToggleSpell<cr>", "Toggle spell" },
    w = { "<cmd>OptionToggleWrap<cr>", "Toggle wrap" },
    z = { "<cmd>OptionToggleEdit2<cr>", "sw=2 ts=2 et" },
    x = { "<cmd>OptionToggleEdit4<cr>", "sw=4 ts=4 et" },
    k = { "<cmd>OptionToggleEdit8<cr>", "sw=8 ts=8 noet" },
  }
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
