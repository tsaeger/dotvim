vim.opt.runtimepath:prepend(vim.fn.getcwd())

local tools = require 'core.tools'

local function source(name)
  return {
    name = name,
    with = function(opts)
      return { name = name, opts = opts }
    end,
  }
end

package.preload['none-ls.formatting.ruff'] = function()
  return source 'ruff'
end
package.preload['none-ls.formatting.ruff_format'] = function()
  return source 'ruff_format'
end

local null_ls = {
  builtins = {
    formatting = {
      prettier = source 'prettier',
      shfmt = source 'shfmt',
      stylua = source 'stylua',
    },
    diagnostics = {
      checkmake = source 'checkmake',
      codespell = source 'codespell',
    },
    code_actions = {
      gitrebase = source 'gitrebase',
      gitsigns = source 'gitsigns',
    },
  },
}

local function names(items)
  local out = {}
  for _, item in ipairs(items) do
    out[item.name] = true
  end
  return out
end

vim.notify = function() end

assert(vim.deep_equal(tools.none_ls_mason_install(), { 'checkmake' }))
assert(tools.executables.ruff.source == 'nix')
assert(tools.executables.checkmake.source == 'mason')
assert(tools.none_ls_adapters.ruff_fix.executable == 'ruff')
assert(tools.none_ls_adapters.ruff_format.executable == 'ruff')

local missing = names(tools.none_ls_sources(null_ls, function()
  return false
end))
assert(not missing.ruff and not missing.ruff_format)
assert(missing.gitrebase and missing.gitsigns)

local present = names(tools.none_ls_sources(null_ls, function(key)
  return key == 'ruff'
end))
assert(present.ruff and present.ruff_format)

local stylua_only = names(tools.none_ls_sources(null_ls, function(key)
  return key == 'stylua'
end))
assert(stylua_only.stylua)
assert(not stylua_only.ruff and not stylua_only.ruff_format)
assert(stylua_only.gitrebase)

print 'tool registry contract: PASS'
