vim.opt.guifont = 'MesloLGS Nerd Font:h20'
vim.g.have_nerd_font = true
vim.g.loaded_perl_provider = 0
-- vim.g.loaded_node_provider = 0
vim.g.node_host_prog = '/Users/tsaeger/workspace/nix/node_modules/bin/neovim-node-host'
--[[
## neovim python install

```bash
cargo install --git https://github.com/astral-sh/uv uv
uv venv --python 3.12 nvim2025.venv
source nvim2025.venv/bin/activate
uv pip install pynvim
```
--]]
vim.g.python3_host_prog = vim.g.myconfig.configdir .. '.venv/bin/python3'

-- shadafile
if vim.o.shadafile ~= nil then
  ---@diagnostic disable-next-line: undefined-field
  vim.o.shadafile = vim.g.myconfig.util.path_join(vim.fn.stdpath 'cache', 'shada.dat')
end

-- Augment myconfig
-- :help vim.g
local myconfig = vim.g.myconfig

local host = 'localhost'
local port = 11434
myconfig.ollama = {
  host = host,
  port = port,
  completion_url = string.format('http://%s:%d/v1/completions', host, port),
  chat_url = string.format('http://%s:%d/v1/chat/completions', host, port),
  model = 'qwen2.5-coder:7b',
}

vim.g.myconfig = myconfig
