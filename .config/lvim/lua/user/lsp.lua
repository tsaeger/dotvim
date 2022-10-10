-- LSP settings
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

lvim.lsp.diagnostics.virtual_text = false

-- formatters
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  { command = "stylua", filetypes = { "lua" } },
})

-- linters
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
  { command = "flake8", filetypes = { "python" } },
  { command = "mypy", filetypes = { "python" } },
  { command = "shellcheck", extra_args = { "--severity", "warning" }, filetypes = { "bash" } },
  { command = "codespell" },
})
