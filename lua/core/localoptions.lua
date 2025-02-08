vim.opt.guifont = 'MesloLGS Nerd Font:h22'
vim.g.have_nerd_font = true
vim.g.node_host_prog = '/Users/tsaeger/workspace/nix/node_modules/bin/neovim-node-host'
vim.g.python3_host_prog = '/Users/tsaeger/.local/share/zinit/plugins/pyenv---pyenv/shims/python'
vim.g.loaded_perl_provider = 0

-- shadafile
if vim.o.shadafile ~= nil then
  ---@diagnostic disable-next-line: undefined-field
  vim.o.shadafile = _G.util.path_join(vim.fn.stdpath 'cache', 'shada.dat')
end
