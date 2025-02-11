vim.opt.guifont = 'MesloLGS Nerd Font:h20'
vim.g.have_nerd_font = true
vim.g.loaded_perl_provider = 0
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

vim.g.myconfig.ollama = {
  url = 'http://localhost:11434/v1/completions',
  model = 'qwen2.5-coder:7b',
}
