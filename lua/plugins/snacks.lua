--@type snacks.dashboard.Config
local dashboard_opts = {
  preset = {
    keys = {
      { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
      { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
      { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = ' ', key = 'h', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
      { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
  sections = {
    { section = 'header' },
    { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
    {
      icon = ' ',
      pane = 2,
      title = 'Recent Files',
      section = 'recent_files',
      indent = 2,
      padding = 1,
      cwd = true,
      limit = 10,
    },
    {
      icon = ' ',
      pane = 2,
      title = 'Projects',
      section = 'projects',
      indent = 2,
      padding = 1,
    },

    {
      icon = ' ',
      pane = 2,
      title = 'Git Status',
      section = 'terminal',
      enabled = function()
        return Snacks.git.get_root() ~= nil
      end,
      cmd = 'git status --short --branch --renames',
      height = 5,
      padding = 1,
      ttl = 5 * 60,
      indent = 3,
    },
    { section = 'startup' },
  },
}

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- picker = picker_opts,
    -- indent = {},
    -- notifier = {},
    bigfile = {},
    scroll = {},
    -- gitbrowse = {},
    -- explorer = {},
    dashboard = dashboard_opts,
  },
}
