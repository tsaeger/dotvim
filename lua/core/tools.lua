-- ╭───────────────────────────────────────────────────────────────────────────╮
-- │ Tool registry — the ONE place tool ownership/role is declared.            │
-- │                                                                           │
-- │ lua/plugins/lsp.lua and lua/plugins/none-ls.lua DERIVE their behavior from│
-- │ this table (mason ensure_installed, skip_autoinstall, skip_autoconfigure),│
-- │ so a tool can never be half-promoted. nix/package.nix's runtimeDeps is the│
-- │ matching half on the Nix side — keep the two in sync (see name map below).│
-- │                                                                           │
-- │ Promote a tool mason → nix:                                               │
-- │   1. add the nixpkgs attr to runtimeDeps in nix/package.nix               │
-- │   2. flip source = 'mason' → 'nix' here                                   │
-- │   3. rebuild, then in nvim: :MasonUninstall <mason-name> and :DotvimDoctor│
-- │ Demote nix → mason: reverse (drop from runtimeDeps, flip to 'mason').     │
-- │                                                                           │
-- │ Verify reality matches intent any time with :DotvimDoctor.                │
-- ╰───────────────────────────────────────────────────────────────────────────╯
--
-- Name spaces differ across subsystems — this table bridges them:
--   registry key  = lspconfig server name where it's an LSP, else the tool name
--   lsp           = lspconfig server name (nil if not an LSP)
--   mason         = mason package name    (defaults to key; only set when different)
--   bin           = executable probed on PATH by :DotvimDoctor
--
--   nixpkgs attr (package.nix) ↔ this table:
--     rust-analyzer→rust_analyzer  basedpyright→basedpyright  ruff→ruff
--     vscode-langservers-extracted→jsonls  yaml-language-server→yamlls
--     lua-language-server→lua_ls   bash-language-server→bashls
--     python313→(python3 cli)      uv/poethepoet/pyrefly/mypy/ty→cli entries

local M = {}

-- source : 'nix' (Tier-1, on PATH already) | 'mason' (Tier-2) | 'system' (OS-provided)
-- roles  : lsp=true / none_ls=true / cli=true (a tool may have several)
M.tools = {
  -- ── LSP servers ──────────────────────────────────────────────────────────
  bashls = { source = 'nix', lsp = 'bashls', mason = 'bash-language-server', bin = 'bash-language-server' },
  clangd = { source = 'system', lsp = 'clangd', bin = 'clangd' },
  basedpyright = { source = 'nix', lsp = 'basedpyright', bin = 'basedpyright' },
  rust_analyzer = { source = 'nix', lsp = 'rust_analyzer', bin = 'rust-analyzer', no_autoconfigure = true }, -- rustaceanvim owns config
  ruff = { source = 'nix', lsp = 'ruff', none_ls = true, bin = 'ruff' },
  jsonls = {
    source = 'nix',
    lsp = 'jsonls',
    mason = 'json-lsp',
    bin = 'vscode-json-language-server',
  },
  yamlls = { source = 'nix', lsp = 'yamlls', mason = 'yaml-language-server', bin = 'yaml-language-server' },
  lua_ls = { source = 'nix', lsp = 'lua_ls', mason = 'lua-language-server', bin = 'lua-language-server' },

  -- ── none-ls (formatters / linters / diagnostics) ──────────────────────────
  stylua = { source = 'nix', none_ls = true, bin = 'stylua' },
  prettier = { source = 'nix', none_ls = true, bin = 'prettier' },
  shfmt = { source = 'nix', none_ls = true, bin = 'shfmt' },
  shellcheck = { source = 'nix', none_ls = true, bin = 'shellcheck' },
  checkmake = { source = 'mason', none_ls = true, bin = 'checkmake' },
  codespell = { source = 'nix', none_ls = true, bin = 'codespell' },

  -- ── Pure CLI tools from Nix Tier-1 (no LSP/none-ls role; verified by doctor) ─
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

-- Should mason auto-install this lspconfig server? Only when source == 'mason'.
-- Unknown servers default to mason-installed (backward-safe).
function M.lsp_skip_autoinstall(server)
  local t = M.tools[server]
  return t ~= nil and t.source ~= 'mason'
end

-- rustaceanvim et al.: prevent lspconfig/mason-lspconfig from configuring it.
function M.lsp_skip_autoconfigure(server)
  local t = M.tools[server]
  return t ~= nil and t.no_autoconfigure == true
end

-- mason package names of none-ls tools that mason should install
-- (i.e. none-ls role AND source == 'mason' — nix-provided ones are excluded
-- so mason can't shadow them on PATH).
function M.none_ls_mason_install()
  local out = {}
  for key, t in pairs(M.tools) do
    if t.none_ls and t.source == 'mason' then
      table.insert(out, t.mason or key)
    end
  end
  table.sort(out)
  return out
end

-- ── Audit: registry vs reality (single source for doctor + healthcheck) ──────
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

  local keys = vim.tbl_keys(M.tools)
  table.sort(keys)

  local rows = {}
  for _, key in ipairs(keys) do
    local t = M.tools[key]
    local bin = t.bin or key
    local where = classify(vim.fn.exepath(bin))

    local severity, status
    if where == 'MISSING' then
      if t.source == 'system' then
        severity, status = 'warn', 'not found — expected from OS'
      else
        severity, status = 'error', 'NOT FOUND on PATH'
      end
    elseif t.source == 'nix' and where ~= 'nix' then
      severity, status = 'error', 'SHADOWED by ' .. where .. ' — :MasonUninstall the stale copy'
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

-- ── :DotvimDoctor — render the audit into a scratch buffer ───────────────────
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
