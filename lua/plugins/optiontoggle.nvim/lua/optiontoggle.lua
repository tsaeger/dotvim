-- Description: neovim plugin to toggle various options
--      Author: Tom Saeger <tom.saeger@gmail.com>
--        Date: September 2022
-- Assumptions: Treesitter, Gitsigns, IndentBlankline| Snacks.indent, Which-Key

local function prequire(m)
  local ok, err = pcall(require, m)
  if not ok then
    return nil, err
  end
  return err
end

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

-- indent lines plugin abstraction
local _indent_snacks = prequire("snacks.indent")
local _indent_ibl = prequire("ibl.config")

local _indent_is_enabled = function()
  if _indent_snacks then
    return _indent_snacks.enabled
  elseif _indent_ibl then
    return _indent_ibl.get_config(-1).enabled
  end
  return false
end

local _indent_enable = function()
  if _indent_snacks then
    _indent_snacks.enable()
  elseif _indent_ibl then
    vim.cmd([[ IBLEnable ]])
  end
end

local _indent_disable = function()
  if _indent_snacks then
    _indent_snacks.disable()
  elseif _indent_ibl then
    vim.cmd([[ IBLDisable ]])
  end
end

local _indent_toggle = function()
  if _indent_is_enabled() then
    _indent_disable()
  else
    _indent_enable()
  end
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
  if vim.o.list and _indent_is_enabled() then
    _indent_disable()
    _M._state.listchar_indent_state = true
  elseif _M._state.listchar_indent_state then
    _indent_enable()
    _M._state.listchar_indent_state = nil
  end
end

_M.OptionToggleIndentlines = function()
  _indent_toggle()
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
  _M._state.listchar_index = int_inc_range(_M._state.listchar_index, 1, #_M.options.listchars_sets)
  vim.opt["listchars"] = _M.options.listchars_sets[_M._state.listchar_index]
  vim.notify("listchars set to index " .. tostring(_M._state.listchar_index))
end

_M.OptionToggleNumber = function()
  _M._state.number_cycle_index = int_inc_range(_M._state.number_cycle_index, 1, 3)
  if _M._state.number_cycle_index == 1 then
    vim.o["number"] = true
    vim.o["relativenumber"] = false
  elseif _M._state.number_cycle_index == 2 then
    vim.o["number"] = true
    vim.o["relativenumber"] = true
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

---@class snacks.dim
local _snacks_dim = prequire("snacks.dim")
_M.OptionToggleDim = function()
  if _snacks_dim then
    if _snacks_dim.enabled then
      _snacks_dim.disable()
    else
      _snacks_dim.enable()
    end
  end
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
  -- TODO: figure out LSP equivalent
  -- vim.cmd("LvimToggleFormatOnSave")
end

_M.set_default_keymaps = function()
  vim.keymap.set("n", "<leader>oc", "<cmd>OptionToggleCursorline<cr>", { desc = "Toggle cursorline" })
  vim.keymap.set("n", "<leader>oC", "<cmd>OptionToggleCursorcolumn<cr>", { desc = "Toggle cursorcolumn" })
  vim.keymap.set(
    "n",
    "<leader>oe",
    "<cmd>lua require('luasnip.loaders').edit_snippet_files()<cr>",
    { desc = "Edit snippets" }
  )
  vim.keymap.set("n", "<leader>od", "<cmd>OptionToggleDim<cr>", { desc = "Toggle Dimming" })
  vim.keymap.set("n", "<leader>of", "<cmd>OptionToggleFolds<cr>", { desc = "Cycle folds" })
  vim.keymap.set("n", "<leader>oF", "<cmd>OptionToggleFormatOnSave<cr>", { desc = "Toggle Format on save" })
  vim.keymap.set("n", "<leader>og", "<cmd>OptionToggleGitsigns<cr>", { desc = "Toggle git signs" })
  vim.keymap.set("n", "<leader>oh", "<cmd>OptionToggleHlsearch<cr>", { desc = "Toggle hlsearch" })
  vim.keymap.set("n", "<leader>oi", "<cmd>OptionToggleIndentlines<cr>", { desc = "Toggle indent" })
  vim.keymap.set("n", "<leader>ol", "<cmd>OptionToggleList<cr>", { desc = "Toggle list" })
  vim.keymap.set("n", "<leader>oL", "<cmd>OptionToggleListchars<cr>", { desc = "Cycle listchar set" })
  vim.keymap.set("n", "<leader>on", "<cmd>OptionToggleNumber<cr>", { desc = "Cycle number" })
  vim.keymap.set("n", "<leader>oo", "<cmd>OptionToggleColorcolumn<cr>", { desc = "Toggle colorcolumn" })
  vim.keymap.set("n", "<leader>op", "<cmd>OptionTogglePaste<cr>", { desc = "Toggle paste" })
  vim.keymap.set("n", "<leader>os", "<cmd>OptionToggleSpell<cr>", { desc = "Toggle spell" })
  vim.keymap.set("n", "<leader>ow", "<cmd>OptionToggleWrap<cr>", { desc = "Toggle wrap" })
  vim.keymap.set("n", "<leader>oy2", "<cmd>OptionToggleEdit2<cr>", { desc = "sw=2 ts=2 sts=2 et" })
  vim.keymap.set("n", "<leader>oy4", "<cmd>OptionToggleEdit4<cr>", { desc = "sw=4 ts=4 sts=4 et" })
  vim.keymap.set("n", "<leader>oy8", "<cmd>OptionToggleEdit8<cr>", { desc = "sw=8 ts=8 sts=8 noet" })
  vim.keymap.set("n", "<leader>oyt", "<cmd>OptionToggleTab<cr>", { desc = "tab {et, noet}" })
  local wk = prequire("which-key")
  if wk then
    wk.add({
      { "<leader>o", group = "[O]ptions" },
      { "<leader>oy", group = "St[y]les" },
    })
  end
end

_M.setup = function(options)
  -- defaults
  _M.options = vim.tbl_extend("force", options or {}, {
    colorcolumn = "80",
    -- colorcolumn = "132",
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
  _M.set_default_keymaps()
end

return _M
