-- see: https://github.com/nvimtools/none-ls.nvim/issues/58

return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local tools = require 'core.tools'

    -- Formatters & linters for mason to install — DERIVED from the registry
    -- (lua/core/tools.lua): derived only from executable records. none-ls
    -- adapters never declare packages, so they cannot trigger an installation.
    require('mason-null-ls').setup {
      ensure_installed = tools.none_ls_mason_install(),
      automatic_installation = true,
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
      sources = tools.none_ls_sources(null_ls),
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
