-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
    config = function()
      local wk = require 'which-key'
      wk.add {
        { '<leader>a', group = '[A]I' },
        { '<leader>b', group = '[B]uffers' },
        { '<leader>c', group = '[C]ode' },
        { '<leader>cg', group = '[G]oto' },
        { '<leader>cd', group = '[D]ocument' },
        { '<leader>cw', group = '[W]orkspace' },
        { '<leader>d', group = '[D]iagnostic' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]abs' },
        { '<leader>u', group = '[U]tils' },
        { '<leader>ug', group = '[G]it' },
      }
    end,
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    opts = {},
  },
  -- general editor
  {
    'ggandor/leap.nvim',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
      vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
      -- vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')
    end,
  },
  { 'jghauser/mkdir.nvim' },
  { 'gpanders/editorconfig.nvim' },
  -- lua
  { 'rohanorton/lua-gf.nvim', opts = {} },
  { 'rafcamlet/nvim-luapad' },
  -- rust
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    opts = {},
  },
  -- MacOS
  { 'clvnkhr/macaltkey.nvim', opts = { language = 'en-US' } },
  -- my plugins
  {
    dir = vim.g.myconfig.util.path_join(vim.g.myconfig.plugindir, 'optiontoggle.nvim'),
    opts = {},
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter' },
      { 'lewis6991/gitsigns.nvim' },
      { 'folke/which-key.nvim' },
      { 'folke/snacks.nvim', opts = {
        indent = {},
      } },
    },
  },
  {
    dir = vim.g.myconfig.util.path_join(vim.g.myconfig.plugindir, 'macos.nvim'),
    opts = {},
    dependencies = { { 'clvnkhr/macaltkey.nvim' } },
  },
}
