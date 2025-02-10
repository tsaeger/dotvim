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
  { 'karb94/neoscroll.nvim', opts = {} },
  { 'gpanders/editorconfig.nvim' },
  { 'David-Kunz/gen.nvim' },
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
  -- my plugins
  { dir = '~/workspace/neovim/plugins/optiontoggle.nvim', opts = {} },
  {
    dir = vim.g.myconfig.util.path_join(vim.g.myconfig.configdir, 'lua', 'plugins', 'macos.nvim'),
    opts = {},
    dependencies = { { 'clvnkhr/macaltkey.nvim', opts = {} } },
  },
}
