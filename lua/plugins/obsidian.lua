-- [[wikilink]] navigation, backlinks, search, TOC for ~/dev/wiki
-- Works on plain markdown — no Obsidian app required.
-- deps: plenary.nvim (already installed)
return {
  'epwalsh/obsidian.nvim',
  version = '*', -- stable releases
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  enabled = function()
    local vaults = vim.g.myconfig.get_obsidian_vaults()
    return vaults and #vaults > 0
  end,
  opts = {
    -- Point at your wiki. Can be a list for multiple vaults.
    workspaces = vim.g.myconfig.get_obsidian_vaults(),
    -- Your wiki uses [[slug]] — match exactly
    wiki_link_func = function(opts)
      -- [[slug]] — no alias, no path prefix
      if opts.label == opts.path then
        return string.format('[[%s]]', opts.path)
      else
        return string.format('[[%s|%s]]', opts.path, opts.label)
      end
    end,
    -- New notes preserve your SCHEMA.md frontmatter format
    note_frontmatter_func = function(note)
      local out = {
        title = note.title,
        created = os.date '%Y-%m-%d',
        updated = os.date '%Y-%m-%d',
        type = 'concept',
        tags = {},
      }
      if note.tags then
        out.tags = note.tags
      end
      return out
    end,
    follow_url_func = nil, -- don't override url handling
    -- Use telescope (you already have it) for pickers
    picker = { name = 'telescope.nvim' },
    daily_notes = {
      folder = '.',
      template = nil,
    },
  },
  -- Keymaps scoped to markdown buffers in your vault
  keys = {
    {
      'gf',
      function()
        return require('obsidian').util.gf_passthrough()
      end,
      ft = 'markdown',
      desc = 'Obsidian gf',
    },
    {
      '<leader>wb',
      function()
        vim.cmd 'ObsidianBacklinks'
      end,
      ft = 'markdown',
      desc = '[W]iki [B]acklinks',
    },
    {
      '<leader>ws',
      function()
        vim.cmd 'ObsidianSearch'
      end,
      ft = 'markdown',
      desc = '[W]iki [S]earch',
    },
    {
      '<leader>wt',
      function()
        vim.cmd 'ObsidianTOC'
      end,
      ft = 'markdown',
      desc = '[W]iki [T]OC',
    },
    {
      '<leader>wn',
      function()
        vim.cmd 'ObsidianNew'
      end,
      ft = 'markdown',
      desc = '[W]iki [N]ew note',
    },
    {
      '<leader>wo',
      function()
        vim.cmd 'ObsidianOpen'
      end,
      ft = 'markdown',
      desc = '[W]iki [O]pen in app',
    },
  },
}
