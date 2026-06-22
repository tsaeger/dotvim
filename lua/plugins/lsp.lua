return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.compat',
  },
  config = function()
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- LSPs are external tools that must be installed separately from Neovim.
    -- This is where `mason` and related plugins come into play.
    --
    -- LSP/treesitter differences
    -- `:help lsp-vs-treesitter`

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- keymap helper function
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>cn', vim.lsp.buf.rename, '[C]ode Re[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        -- Find references for the word under your cursor.
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('<leader>cgr', require('telescope.builtin').lsp_references, '[C]ode [G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>cgI', require('telescope.builtin').lsp_implementations, '[C]ode [G]oto [I]mplementation')

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('<leader>cgd', require('telescope.builtin').lsp_definitions, '[C]ode [G]oto [D]efinition')

        -- This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>cgD', vim.lsp.buf.declaration, '[C]ode [G]oto [D]eclaration')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
        map('<leader>cds', require('telescope.builtin').lsp_document_symbols, '[C]ode [D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
        map('<leader>cws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[C]ode [W]orkspace [S]ymbols')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        map('<leader>cgt', require('telescope.builtin').lsp_type_definitions, '[C]ode [G]oto [T]ype Definition')

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
          client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
        then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- keymap for inlay hint toggle if supported by LSP
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>ch', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[C]ode Toggle Inlay [H]ints')
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  Plugins like blink-cmp, nvim-cmp, luasnip, etc. add *more* capabilities.
    --  Broadcast the combined capabilities to servers.
    local capabilities = require('blink.cmp').get_lsp_capabilities({}, true)

    -- Keep Ruff as style linter and suppress pycodestyle-style diagnostics from pylsp.
    do
      local default_publish_diagnostics = vim.lsp.handlers['textDocument/publishDiagnostics']
      vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.name == 'pylsp' and result and result.diagnostics then
          result.diagnostics = vim.tbl_filter(function(diagnostic)
            local code = tostring(diagnostic.code or '')
            return not code:match '^[EW]%d%d%d$'
          end, result.diagnostics)
        end
        return default_publish_diagnostics(err, result, ctx, config)
      end
    end

    -- Enable the following language servers
    -- :help lspconfig-all
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      -- NOTE: LSP server configs
      bashls = {},
      clangd = {
        -- install/config flags are derived from the registry (source='system')
        -- cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
        cmd = { 'clangd', '--background-index' },
        -- init_options = {
        --   fallbackFlags = { '-std=c++17' },
        -- },
      },
      -- gopls = {},
      basedpyright = { enabled = true },
      -- rust_analyzer: skip_autoconfigure is derived from the registry
      -- (no_autoconfigure=true) so rustaceanvim owns the config.
      rust_analyzer = {},
      -- ts_ls = {},
      ruff = {},
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_mypy = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
              pycodestyle = {
                enabled = true,
                maxLineLength = 132,
              },
            },
          },
        },
      },
      -- html = { filetypes = { 'html', 'twig', 'hbs' } },
      -- cssls = {},
      -- tailwindcss = {},
      -- dockerls = {},
      -- sqlls = {},
      -- terraformls = {},
      jsonls = {},
      yamlls = {},

      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            diagnostics = { disable = { 'missing-fields' } },
            format = {
              enable = false,
            },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require('mason').setup()

    -- Single source of truth for who installs/configures what (lua/tools.lua):
    -- skip_autoinstall / skip_autoconfigure are DERIVED from the registry so a
    -- tool is never half-promoted between nix and mason.
    local tools = require 'tools'

    -- mason-tool-installer installs only the LSP servers the registry marks as
    -- mason-sourced (nix/system ones are filtered out so mason can't shadow them).
    -- none-ls tools (stylua, prettier, …) are installed via mason-null-ls in
    -- none-ls.lua — also derived from the same registry.
    local ensure_installed = {}
    for server_name in pairs(servers) do
      if not tools.lsp_skip_autoinstall(server_name) then
        table.insert(ensure_installed, server_name)
      end
    end
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Disable mason-lspconfig auto-enable so we can apply custom settings first.
    require('mason-lspconfig').setup {
      automatic_enable = false,
    }

    -- Configure and enable servers with local overrides, skipping any the
    -- registry flags (e.g. rust_analyzer, owned by rustaceanvim).
    for server_name, server in pairs(servers) do
      if not tools.lsp_skip_autoconfigure(server_name) then
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(server_name, server)
        vim.lsp.enable(server_name)
      end
    end
  end,
}
