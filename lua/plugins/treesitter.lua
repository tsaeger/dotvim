return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      -- NOTE: treesitter languages
      ensure_installed = {
        'lua',
        'python',
        -- 'javascript',
        -- 'typescript',
        'vimdoc',
        'vim',
        'regex',
        -- 'terraform',
        'sql',
        'dockerfile',
        'toml',
        'json',
        -- 'java',
        -- 'groovy',
        -- 'go',
        'gitignore',
        -- 'graphql',
        'yaml',
        'make',
        'cmake',
        'markdown',
        'markdown_inline',
        'bash',
        -- 'tsx',
        -- 'css',
        -- 'html',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      -- `:help nvim-treesitter-incremental-selection-mod`
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
    },
  },
  -- NOTE: Additional treesitter modules
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter-context/issues/145#issuecomment-1188712754
    -- https://github.com/syphar/dotfiles/blob/7fb87b3f9be7113bfdd01a4c781642592aac9880/.config/nvim/after/plugin/treesitter_context.lua
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      vim.keymap.set(
        'n',
        '<leader>ctc',
        ':TSContextToggle<CR>',
        { noremap = true, silent = true, desc = '[C]ontext Toggle' }
      )
    end,
    opts = {
      enable = true,
      throttle = true,
      max_lines = 0,
      patterns = {
        default = {
          'class',
          'function',
          'method',
          'for',
          'while',
          'if',
          'else',
          'switch',
          'case',
        },
        rust = {
          'impl_item',
          'mod_item',
          'enum_item',
          'match',
          'struct',
          'loop',
          'closure',
          'async_block',
          'block',
        },
        python = {
          'elif',
          'with',
          'try',
          'except',
        },
        json = {
          'object',
          'pair',
        },
        javascript = {
          'object',
          'pair',
        },
        yaml = {
          'block_mapping_pair',
          'block_sequence_item',
        },
        toml = {
          'table',
          'pair',
        },
        markdown = {
          'section',
        },
      },
    },
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
