if vim.g.myconfig.ollama ~= nil then
  return {
    require 'plugins.gen',
    require 'plugins.minuet-ai',
  }
else
  return {}
end
