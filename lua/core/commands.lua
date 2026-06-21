local util = vim.g.myconfig.util

local recreate_python_venv = util.path_join(vim.g.myconfig.configdir, 'recreate-python-venv.sh')

vim.api.nvim_create_user_command('Nvim2025RecreatePythonVenv', function()
  vim.cmd.split()
  vim.fn.termopen { recreate_python_venv }
  vim.cmd.startinsert()
end, {
  desc = 'Recreate the nvim2025 Python provider venv with uv',
})
