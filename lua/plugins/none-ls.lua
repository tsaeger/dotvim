-- see: https://github.com/nvimtools/none-ls.nvim/issues/58

return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters
    local code_actions = null_ls.builtins.code_actions
    -- local hover = null_ls.builtins.hover
    -- local completion = null_ls.builtins.completion

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        -- NOTE: mason auto-install tools
        'checkmake', -- linter for Makefiles
        'codespell', -- spelling
        'prettier', -- ts/js formatter
        'ruff', -- Python linter and formatter
        'shfmt', -- Shell formatter
        'stylua', -- lua formatter
      },
      automatic_installation = true,
    }

    -- NOTE: none-ls sources
    local sources = {
      code_actions.gitrebase,
      code_actions.gitsigns,
      diagnostics.checkmake,
      diagnostics.codespell,
      formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
      formatting.stylua.with { filetypes = { 'lua' } },
      formatting.shfmt.with { args = { '-i', '4' } },
      -- formatting.codespell,
      require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      require 'none-ls.formatting.ruff_format',
    }

    vim.keymap.set('n', '<leader>cF', function()
      local myconfig = vim.g.myconfig
      myconfig.format_on_write = not myconfig.format_on_write
      vim.g.myconfig = myconfig
      vim.notify('format_on_write set to ' .. tostring(vim.g.myconfig.format_on_write))
    end, { noremap = true, silent = true, desc = '[C]ode Toggle [F]ormat on save' })

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client and client:supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              if vim.g.myconfig.format_on_write then
                vim.lsp.buf.format { async = false }
              end
            end,
          })
        end
      end,
    }
  end,
}
