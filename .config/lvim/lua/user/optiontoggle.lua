-- Description: neovim plugin to toggle various options
--      Author: Tom Saeger <tom.saeger@gmail.com>
--        Date: September 2022
-- Assumptions: Treesitter, Gitsigns, IndentBlankline, Lvim

local _M = {}
_M._state = {
  foldmode = "treesitter",
  listchar_index = 1,
  listchar_indent_state = nil,
  number_cycle_index = nil,
}

local _toggleopt = function(opt)
  local val = not vim.o[opt]
  vim.o[opt] = val
  -- vim.notify(opt .. " set to " .. tostring(val))
end

_M.OptionToggleCursorline = function()
  _toggleopt("cursorline")
end

_M.OptionToggleCursorcolumn = function()
  _toggleopt("cursorcolumn")
end

_M.OptionToggleGitsigns = function()
  vim.cmd([[ Gitsigns toggle_signs ]])
end

_M.OptionToggleHlsearch = function()
  _toggleopt("hlsearch")
end

--- Toggle list and IndentBlankline if active
_M.OptionToggleList = function()
  _toggleopt("list")
  if vim.o.list and vim.b.__indent_blankline_active then
    pcall(function()
      vim.cmd([[ IndentBlanklineDisable ]])
    end)
    _M._state.listchar_indent_state = true
  elseif _M._state.listchar_indent_state then
    pcall(function()
      vim.cmd([[ IndentBlanklineEnable ]])
    end)
    _M._state.listchar_indent_state = nil
  end
end

local int_inc_range = function(current, min, max)
  -- force wrap to min if current is nil
  local result = (current or max) + 1
  if result > max then
    result = min
  end
  return result
end

_M.OptionToggleListchars = function()
  _M._state.listchar_index = int_inc_range(
    _M._state.listchar_index, 1, #_M.options.listchars_sets)
  vim.opt["listchars"] = _M.options.listchars_sets[_M._state.listchar_index]
  vim.notify("listchars set to index " .. tostring(_M._state.listchar_index))
end

_M.OptionToggleNumber = function()
  _M._state.number_cycle_index = int_inc_range(
    _M._state.number_cycle_index, 1, 3)
  if _M._state.number_cycle_index == 1 then
    vim.o["number"] = true
    vim.o["relativenumber"] = true
  elseif _M._state.number_cycle_index == 2 then
    vim.o["number"] = true
    vim.o["relativenumber"] = false
  elseif _M._state.number_cycle_index == 3 then
    vim.o["number"] = false
    vim.o["relativenumber"] = false
  end
end

_M.OptionTogglePaste = function()
  _toggleopt("paste")
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
  _toggleopt("spell")
end

_M.OptionToggleWrap = function()
  _toggleopt("wrap")
end

_M.OptionToggleIndentlines = function()
  pcall(function()
    vim.cmd([[ IndentBlanklineToggle ]])
  end)
end

_M.OptionToggleEdit2 = function()
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.expandtab = true
  vim.notify("style set to sw=2 ts=2 sts=2 et")
end

_M.OptionToggleEdit4 = function()
  vim.opt.shiftwidth = 4
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.expandtab = true
  vim.notify("style set to sw=4 ts=4 sts=4 et")
end

_M.OptionToggleEdit8 = function()
  vim.opt.shiftwidth = 8
  vim.opt.tabstop = 8
  vim.opt.softtabstop = 8
  vim.opt.expandtab = false
  vim.notify("style set to sw=8 ts=8 sts=8 noet")
end

_M.OptionToggleTab = function()
  _toggleopt("expandtab")
end

_M.OptionToggleFolds = function()
  local method = _M._state and _M._state.foldmode or "treesitter"
  if method == "treesitter" then
    vim.opt.foldmethod = "expr"
    vim.cmd([[ set foldexpr=nvim_treesitter#foldexpr() ]])
    _M._state.foldmode = "indent"
  elseif method == "indent" then
    vim.opt.foldmethod = "indent"
    _M._state.foldmode = "off"
  else
    vim.opt.foldmethod = "manual"
    vim.cmd("normal zE")
    _M._state.foldmode = "treesitter"
  end
  vim.notify("indent method set to " .. method)
  vim.opt.foldlevel = 0
  -- set back to manual to allow zE to delete all folds
  vim.opt.foldmethod = "manual"
end

_M.OptionToggleFormatOnSave = function()
  vim.cmd("LvimToggleFormatOnSave")
end

_M.get_which_key_mappings = function()
  return {
    name = "+Options",
    c = { "<cmd>OptionToggleCursorline<cr>", "Toggle cursorline" },
    C = { "<cmd>OptionToggleCursorcolumn<cr>", "Toggle cursorcolumn" },
    e = { "<cmd>lua require('luasnip.loaders').edit_snippet_files()<cr>", "Edit snippets"},
    f = { "<cmd>OptionToggleFolds<cr>", "Cycle folds" },
    F = { "<cmd>OptionToggleFormatOnSave<cr>", "Toggle Format on save" },
    g = { "<cmd>OptionToggleGitsigns<cr>", "Toggle git signs" },
    h = { "<cmd>OptionToggleHlsearch<cr>", "Toggle hlsearch" },
    i = { "<cmd>OptionToggleIndentlines<cr>", "Toggle indent" },
    l = { "<cmd>OptionToggleList<cr>", "Toggle list" },
    L = { "<cmd>OptionToggleListchars<cr>", "Cycle listchar set" },
    n = { "<cmd>OptionToggleNumber<cr>", "Cycle number" },
    p = { "<cmd>OptionTogglePaste<cr>", "Toggle paste" },
    o = { "<cmd>OptionToggleColorcolumn<cr>", "Toggle colorcolumn" },
    s = { "<cmd>OptionToggleSpell<cr>", "Toggle spell" },
    w = { "<cmd>OptionToggleWrap<cr>", "Toggle wrap" },
    y = {
      name = "Styles",
      ["2"] = { "<cmd>OptionToggleEdit2<cr>", "sw=2 ts=2 sts=2 et" },
      ["4"] = { "<cmd>OptionToggleEdit4<cr>", "sw=4 ts=4 sts=4 et" },
      ["8"] = { "<cmd>OptionToggleEdit8<cr>", "sw=8 ts=8 sts=8 noet" },
      ["t"] = { "<cmd>OptionToggleTab<cr>", "tab {et, noet}" },
    },
  }
end

_M.setup = function(options)
  -- defaults
  _M.options = vim.tbl_extend("force", options or {}, {
    colorcolumn = "79",
    listchars_sets = {
      [1] = "tab:→ ,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·",
      [2] = "tab:→ ,eol:↲,nbsp:␣,extends:…,precedes:<,extends:>,trail:·,space:␣",
      -- [3] = "tab:▸·,nbsp:␣,extends:…,precedes:<,extends:>,trail:·",
    },
  })
  vim.opt["listchars"] = _M.options.listchars_sets[_M._state.listchar_index]

  -- force initial number state
  if not _M._state.number_cycle_index then
    _M.OptionToggleNumber()
  end

  -- create OptionToggle commands
  for k, v in pairs(_M) do
    if not string.match(k, "OptionToggle") then
      goto next
    end
    vim.api.nvim_create_user_command(k, v, {})
    ::next::
  end
end

return _M
