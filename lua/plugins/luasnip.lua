return {
  'L3MON4D3/LuaSnip',
  build = (function()
    return 'make install_jsregexp'
  end)(),
  config = function()
    local paths = {}
    paths[#paths + 1] = vim.g.myconfig.util.path_join(vim.fn.stdpath 'data', 'lazy', 'friendly-snippets')
    local local_snippets = vim.g.myconfig.util.path_join(vim.g.myconfig.configdir, 'snippets')
    if vim.g.myconfig.util.is_directory(local_snippets) then
      paths[#paths + 1] = local_snippets
    end
    require('luasnip.loaders.from_lua').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load {
      paths = paths,
    }
    require('luasnip.loaders.from_snipmate').lazy_load()
  end,
  dependencies = {
    {
      -- https://github.com/rafamadriz/friendly-snippets
      'rafamadriz/friendly-snippets',
    },
  },
}
