--@type snacks.dashboard.Config
local dashboard_opts = {
  preset = {
    keys = {
      { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
      -- { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
      { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
      -- { icon = ' ', key = 'h', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
      { icon = ' ', key = 'M', desc = 'Mason', action = ':Mason' },
      {
        icon = ' ',
        key = 'c',
        desc = 'Configuration',
        action = ":lua vim.cmd (':e ' .. vim.g.myconfig.configfile)",
      },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
      -- { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
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
      ttl = 1 * 60,
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
    animate = {},
    bigfile = {},
    dashboard = dashboard_opts,
    dim = {},
    indent = {},
    notifier = {},
    scroll = {},
    terminal = {},

    -- animate snacks.animate
    -- bigfile snacks.bigfile
    -- bufdelete snacks.bufdelete
    -- dashboard snacks.dashboard
    -- debug snacks.debug
    -- dim snacks.dim
    -- explorer snacks.explorer
    -- git snacks.git
    -- gitbrowse snacks.gitbrowse
    -- health snacks.health
    -- indent snacks.indent
    -- input snacks.input
    -- layout snacks.layout
    -- lazygit snacks.lazygit
    -- meta snacks.meta
    -- notifier snacks.notifier
    -- notify snacks.notify
    -- picker snacks.picker
    -- profiler snacks.profiler
    -- quickfile snacks.quickfile
    -- rename snacks.rename
    -- scope snacks.scope
    -- scratch snacks.scratch
    -- scroll snacks.scroll
    -- statuscolumn snacks.statuscolumn
    -- terminal snacks.terminal
    -- toggle snacks.toggle
    -- util snacks.util
    -- win snacks.win
    -- words snacks.words
    -- zen snacks.zen
  },
}
