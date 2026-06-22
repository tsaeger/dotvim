return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'cmake',
        'css',
        'dockerfile',
        'gitignore',
        'go',
        'html',
        'javascript',
        'json',
        'lua',
        'make',
        'markdown_inline',
        'markdown',
        'python',
        'regex',
        'rust',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
        'zsh',
      },
    },
    config = function(_, opts)
      local ts = require 'nvim-treesitter'

      ts.setup()
      ts.install(opts.ensure_installed)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('myconfig-treesitter', { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)

          if vim.bo[args.buf].filetype ~= 'ruby' then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
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
