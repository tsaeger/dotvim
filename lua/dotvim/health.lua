-- Native healthcheck: `:checkhealth dotvim`.
--
-- Neovim discovers this via the modern `lua/<name>/health.lua` form. Two
-- sections: (1) config/runtime status (paths, core modules, lazy, LSP) and
-- (2) the tool registry audit (same data as :DotvimDoctor, via tools.audit()).
local M = {}

function M.check()
  local health = vim.health

  -- ── Config / runtime ──────────────────────────────────────────────────────
  health.start 'dotvim — config & runtime'

  local cfg = vim.g.myconfig
  if not cfg then
    health.error 'vim.g.myconfig not set — init.lua may not have loaded fully'
    return
  end
  health.ok('config file: ' .. tostring(cfg.configfile))
  health.info('config dir:  ' .. tostring(cfg.configdir))
  health.info('plugin dir:  ' .. tostring(cfg.plugindir))

  for _, mod in ipairs { 'core.options', 'core.keymaps', 'core.commands', 'core.util' } do
    if package.loaded[mod] then
      health.ok('loaded: ' .. mod)
    else
      health.warn('not loaded: ' .. mod)
    end
  end

  if package.loaded['lazy'] then
    local s = require('lazy').stats()
    if s then
      health.ok(string.format('lazy.nvim: %d/%d plugins loaded, startup %.1f ms', s.loaded, s.count, s.startuptime))
    end
  else
    health.warn 'lazy.nvim not loaded yet'
  end

  local clients = vim.lsp.get_clients()
  health.info(string.format('active LSP clients: %d', #clients))
  for _, c in ipairs(clients) do
    health.info(string.format('  %s (%d buffer(s))', c.name, #vim.lsp.get_buffers_by_client_id(c.id)))
  end

  health.info 'debug: :DotvimDoctor — same tool audit in a scratch buffer'
  health.info 'debug: :lua= vim.tbl_keys(package.loaded) — loaded modules'

  -- ── Tool registry vs reality ──────────────────────────────────────────────
  health.start 'dotvim — tool registry vs reality'

  local ok, tools = pcall(require, 'tools')
  if not ok then
    health.error('could not load tool registry (lua/tools.lua)', { tostring(tools) })
    return
  end

  for _, r in ipairs(tools.audit()) do
    local detail = string.format('%s (%s, intent=%s', r.key, r.bin, r.intent)
    if r.lsp then
      detail = detail .. ', lsp=' .. r.lsp
    end
    detail = detail .. ')'

    local where = r.where .. (r.version ~= '' and ('  ' .. r.version) or '')

    if r.severity == 'ok' then
      health.ok(detail .. ' → ' .. where)
    elseif r.severity == 'warn' then
      health.warn(detail .. ': ' .. r.status, { 'resolves: ' .. r.where })
    else
      health.error(detail .. ': ' .. r.status, { 'resolves: ' .. r.where })
    end
  end
end

return M
