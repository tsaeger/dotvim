return {
  'David-Kunz/gen.nvim',
  enabled = vim.g.myconfig.ollama ~= nil,
  opts = {
    model = vim.g.myconfig.ollama.model,
    host = vim.g.myconfig.ollama.host,
    port = vim.g.myconfig.ollama.port,
    -- debug = true,
  },
}
