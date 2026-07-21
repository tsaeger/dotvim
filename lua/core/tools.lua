-- -----------------------------------------------------------------------------
-- Tool registry: the ONE place executable ownership/adapter role is declared.
--
-- lua/plugins/lsp.lua and lua/plugins/none-ls.lua DERIVE their behavior from
-- these tables: mason ensure_installed, skip_autoinstall, and
-- skip_autoconfigure. That keeps an executable from ever being half-promoted.
-- nix/package.nix's runtimeDeps is the matching half on the Nix side; keep the
-- two in sync (see name map below).
--
-- Promote a tool mason -> nix:
--   1. add the nixpkgs attr to runtimeDeps in nix/package.nix
--   2. flip source = 'mason' -> 'nix' in M.executables here
--   3. rebuild, then in nvim: :MasonUninstall <mason-name> and :DotvimDoctor
-- Demote nix -> mason: reverse (drop from runtimeDeps, flip to 'mason').
--
-- Verify reality matches intent any time with :DotvimDoctor.
-- -----------------------------------------------------------------------------
--
-- Name spaces differ across subsystems; this table bridges them:
--   registry key  = lspconfig server name where it's an LSP, else the tool name
--   lsp           = lspconfig server name (nil if not an LSP)
--   mason         = mason package name    (defaults to key; only set when different)
--   bin           = executable probed on PATH by :DotvimDoctor
--
--   nixpkgs attr (package.nix) <-> this table:
--     rust-analyzer -> rust_analyzer  basedpyright -> basedpyright  ruff -> ruff
--     vscode-langservers-extracted -> jsonls  yaml-language-server -> yamlls
--     lua-language-server -> lua_ls   bash-language-server -> bashls
--     python313 -> (python3 cli)      uv/poethepoet/pyrefly/mypy/ty -> cli entries

local M = {}

-- source : 'nix' (Tier-1, on PATH already) | 'mason' (Tier-2) | 'system' (OS-provided)
-- roles  : lsp=true / cli=true (an executable may have several)
M.executables = {
  -- -- LSP servers -----------------------------------------------------------
  bashls = { source = 'nix', lsp = 'bashls', mason = 'bash-language-server', bin = 'bash-language-server' },
  clangd = { source = 'system', lsp = 'clangd', bin = 'clangd' },
  basedpyright = { source = 'nix', lsp = 'basedpyright', bin = 'basedpyright' },
  rust_analyzer = { source = 'nix', lsp = 'rust_analyzer', bin = 'rust-analyzer', no_autoconfigure = true }, -- rustaceanvim owns config
  ruff = { source = 'nix', lsp = 'ruff', bin = 'ruff' },
  jsonls = {
    source = 'nix',
    lsp = 'jsonls',
    mason = 'json-lsp',
    bin = 'vscode-json-language-server',
  },
  yamlls = { source = 'nix', lsp = 'yamlls', mason = 'yaml-language-server', bin = 'yaml-language-server' },
  lua_ls = { source = 'nix', lsp = 'lua_ls', mason = 'lua-language-server', bin = 'lua-language-server' },

  -- -- Executables used by none-ls adapters ----------------------------------
  stylua = { source = 'nix', bin = 'stylua' },
  prettier = { source = 'nix', bin = 'prettier' },
  shfmt = { source = 'nix', bin = 'shfmt' },
  shellcheck = { source = 'nix', cli = true, bin = 'shellcheck' }, -- used by bashls; no none-ls builtin is shipped anymore
  codespell = { source = 'nix', bin = 'codespell' },
  checkmake = { source = 'mason', bin = 'checkmake' },

  -- -- Pure CLI tools from Nix Tier-1 (no LSP/none-ls role; verified by doctor)
  ripgrep = { source = 'nix', cli = true, bin = 'rg' },
  fd = { source = 'nix', cli = true, bin = 'fd' },
  git = { source = 'nix', cli = true, bin = 'git' },
  ['tree-sitter'] = { source = 'nix', cli = true, bin = 'tree-sitter' },
  node = { source = 'nix', cli = true, bin = 'node' },
  python = { source = 'nix', cli = true, bin = 'python3' },
  uv = { source = 'nix', cli = true, bin = 'uv' },
  poethepoet = { source = 'nix', cli = true, bin = 'poe' },
  pyrefly = { source = 'nix', cli = true, bin = 'pyrefly' },
  mypy = { source = 'nix', cli = true, bin = 'mypy' },
  ty = { source = 'nix', cli = true, bin = 'ty' },
  imagemagick = { source = 'nix', cli = true, bin = 'magick' }, -- snacks.image
  ghostscript = { source = 'nix', cli = true, bin = 'gs' }, -- snacks.image (PDF)
  tectonic = { source = 'nix', cli = true, bin = 'tectonic' }, -- snacks.image (LaTeX)
  ['mermaid-cli'] = { source = 'nix', cli = true, bin = 'mmdc' }, -- snacks.image (Mermaid)
}

-- none-ls adapters are integration records, not installable tools. An adapter
-- that invokes a command references the owning executable above.
M.none_ls_adapters = {
  ruff_fix = {
    executable = 'ruff',
    kind = 'formatting',
    require = 'none-ls.formatting.ruff',
    opts = { extra_args = { '--extend-select', 'I' } },
  },
  ruff_format = {
    executable = 'ruff',
    kind = 'formatting',
    require = 'none-ls.formatting.ruff_format',
  },
  stylua = { executable = 'stylua', kind = 'formatting', opts = { filetypes = { 'lua' } } },
  prettier = {
    executable = 'prettier',
    kind = 'formatting',
    opts = { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
  },
  shfmt = { executable = 'shfmt', kind = 'formatting', opts = { args = { '-i', '4' } } },
  codespell = { executable = 'codespell', kind = 'diagnostics' },
  checkmake = { executable = 'checkmake', kind = 'diagnostics' },
  gitrebase = { kind = 'code_actions' },
  gitsigns = { kind = 'code_actions' },
}

-- Should mason auto-install this lspconfig server? Only when source == 'mason'.
-- Unknown servers default to mason-installed (backward-safe).
function M.lsp_skip_autoinstall(server)
  local executable = M.executables[server]
  return executable ~= nil and executable.source ~= 'mason'
end

-- rustaceanvim et al.: prevent lspconfig/mason-lspconfig from configuring it.
function M.lsp_skip_autoconfigure(server)
  local executable = M.executables[server]
  return executable ~= nil and executable.no_autoconfigure == true
end

-- Mason packages for executable records only. none-ls adapters cannot cause an
-- installation because they are deliberately absent from this derivation.
function M.none_ls_mason_install()
  local out, seen = {}, {}
  for key, executable in pairs(M.executables) do
    if executable.source == 'mason' and executable.bin then
      local mason = executable.mason or key
      if not seen[mason] then
        table.insert(out, mason)
        seen[mason] = true
      end
    end
  end
  table.sort(out)
  return out
end

function M.none_ls_sources(null_ls, is_available)
  is_available = is_available
    or function(key)
      local executable = M.executables[key]
      return executable ~= nil and executable.bin ~= nil and vim.fn.exepath(executable.bin) ~= ''
    end

  local sources = {}
  local keys = vim.tbl_keys(M.none_ls_adapters)
  table.sort(keys)

  for _, key in ipairs(keys) do
    local adapter = M.none_ls_adapters[key]
    if not adapter.executable or is_available(adapter.executable) then
      local source = adapter.require and require(adapter.require) or null_ls.builtins[adapter.kind][key]
      if adapter.opts then
        source = source.with(adapter.opts)
      end
      table.insert(sources, source)
    else
      vim.notify(
        ('none-ls adapter %s skipped: executable %s is unavailable'):format(key, adapter.executable),
        vim.log.levels.DEBUG
      )
    end
  end

  return sources
end

-- -- Audit: registry vs reality (single source for doctor + healthcheck) -------
-- For each tool, resolve where its binary actually sits on nvim's PATH
-- (nix-store / mason / system / MISSING), grab its version, and compare against
-- the declared source. Returns structured rows so both :DotvimDoctor (scratch
-- buffer) and :checkhealth dotvim (native health UI) render from the same data.
local function classify(path)
  if path == '' then
    return 'MISSING'
  end
  if path:match '/nix/store/' then
    return 'nix'
  end
  if path:match '/mason/' then
    return 'mason'
  end
  return 'system'
end

local function version(bin)
  local ok, out = pcall(vim.fn.system, { bin, '--version' })
  if not ok or vim.v.shell_error ~= 0 then
    return ''
  end
  return (vim.split(out or '', '\n')[1] or ''):gsub('^%s*(.-)%s*$', '%1'):sub(1, 24)
end

-- Returns a sorted list of rows:
--   { key, intent, bin, where, version, lsp ('attached'|'idle'|nil),
--     severity ('ok'|'warn'|'error'), status }
function M.audit()
  local active = {}
  for _, c in ipairs(vim.lsp.get_clients()) do
    active[c.name] = true
  end

  local keys = vim.tbl_keys(M.executables)
  table.sort(keys)

  local rows = {}
  for _, key in ipairs(keys) do
    local t = M.executables[key]
    local bin = t.bin or key
    local where = classify(vim.fn.exepath(bin))

    local severity, status
    if where == 'MISSING' then
      if t.source == 'system' then
        severity, status = 'warn', 'not found - expected from OS'
      else
        severity, status = 'error', 'NOT FOUND on PATH'
      end
    elseif t.source == 'nix' and where ~= 'nix' then
      severity, status = 'error', 'SHADOWED by ' .. where .. ' - :MasonUninstall the stale copy'
    elseif t.source == 'mason' and where == 'nix' then
      severity, status = 'warn', 'nix shadows mason copy'
    else
      severity, status = 'ok', 'ok'
    end

    rows[#rows + 1] = {
      key = key,
      intent = t.source,
      bin = bin,
      where = where,
      version = (where ~= 'MISSING') and version(bin) or '',
      lsp = t.lsp and (active[t.lsp] and 'attached' or 'idle') or nil,
      severity = severity,
      status = status,
    }
  end
  return rows
end

-- -- :DotvimDoctor - render the audit into a scratch buffer --------------------
function M.doctor()
  local sev = { ok = '✓', warn = '!', error = '✗' }
  local lines = {
    'DotvimDoctor — registry vs reality   (✓ ok · ! warn · ✗ problem)',
    string.rep('─', 96),
    string.format('%-2s %-16s %-7s %-7s %-9s %-26s %s', '', 'TOOL', 'INTENT', 'WHERE', 'LSP', 'VERSION', 'STATUS'),
    string.rep('─', 96),
  }
  for _, r in ipairs(M.audit()) do
    lines[#lines + 1] = string.format(
      '%-2s %-16s %-7s %-7s %-9s %-26s %s',
      sev[r.severity],
      r.key,
      r.intent,
      r.where,
      r.lsp or '-',
      r.version,
      r.status
    )
  end

  lines[#lines + 1] = ''
  lines[#lines + 1] = 'Obsidian vaults'
  for _, vault in ipairs(vim.g.myconfig.get_obsidian_vaults()) do
    local path = vim.fn.expand(vault.path)
    lines[#lines + 1] = string.format(
      '%s %s: %s',
      vim.fn.isdirectory(path) == 1 and '✓' or '!',
      vault.name,
      path
    )
  end

  vim.cmd 'botright new'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  local bo = vim.bo
  bo.buftype = 'nofile'
  bo.bufhidden = 'wipe'
  bo.swapfile = false
  bo.modifiable = false
  vim.api.nvim_buf_set_name(0, 'DotvimDoctor')
end

vim.api.nvim_create_user_command('DotvimDoctor', M.doctor, { desc = 'Verify tool registry vs actual PATH/LSP state' })

return M
