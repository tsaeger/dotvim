-- https://raw.githubusercontent.com/jakobwesthoff/nvim-from-scratch/refs/heads/main/lua/plugins/blink-cmp.lua
return {
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'moyiz/blink-emoji.nvim',
      'ray-x/cmp-sql',
      'folke/lazydev.nvim',
    },
    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = 'mono',
      },

      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'default',
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = true } },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true },
      snippets = { preset = 'luasnip' },

      -- NOTE: blink-cmp sources
      sources = {
        default = { 'lazydev', 'lsp', 'snippets', 'buffer', 'path', 'emoji', 'sql' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 15, -- Tune by preference
            opts = { insert = true }, -- Insert emoji (default) or complete its name
            should_show_items = function()
              return vim.tbl_contains(
                -- Enable emoji completion only for git commits and markdown.
                { 'gitcommit', 'markdown' },
                vim.o.filetype
              )
            end,
          },
          sql = {
            -- IMPORTANT: use the same name as you would for nvim-cmp
            name = 'sql',
            module = 'blink.compat.source',

            -- all blink.cmp source config options work as normal:
            score_offset = -3,

            -- this table is passed directly to the proxied completion source
            -- as the `option` field in nvim-cmp's source config
            -- this is NOT the same as the opts in a plugin's lazy.nvim spec
            opts = {},
            should_show_items = function()
              return vim.tbl_contains(
                -- enable only for sql files
                { 'sql' },
                vim.o.filetype
              )
            end,
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
