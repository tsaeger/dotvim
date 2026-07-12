return {
  'carlos-algms/agentic.nvim',
  opts = {
    provider = 'opencode-acp',
    acp_providers = {
      ['opencode-acp'] = {
        command = 'opencode',
      },
      ['claude-agent-acp'] = {},
      ['codex-acp'] = {},
    },
  },
  keys = {
    {
      '<leader>ac',
      function()
        require('agentic').toggle()
      end,
      mode = { 'n' },
      desc = '[A]I [C]hat Toggle',
    },
    {
      '<leader>ai',
      function()
        require('agentic').add_selection_or_file_to_context { focus_prompt = true }
      end,
      mode = { 'n', 'v' },
      desc = '[A]I add selection/file to context',
    },
    {
      '<leader>an',
      function()
        require('agentic').new_session()
      end,
      mode = { 'n' },
      desc = '[A]I [N]ew session',
    },
    {
      '<leader>ar',
      function()
        require('agentic').restore_session()
      end,
      mode = { 'n' },
      desc = '[A]I [R]estore session',
    },
    {
      '<leader>af',
      function()
        require('agentic').add_file()
      end,
      mode = { 'n' },
      desc = '[A]I add [F]ile to context',
    },
    {
      '<leader>ad',
      function()
        require('agentic').add_current_line_diagnostics()
      end,
      mode = { 'n' },
      desc = '[A]I add line [D]iagnostics to context',
    },
    {
      '<leader>ab',
      function()
        require('agentic').add_buffer_diagnostics()
      end,
      mode = { 'n' },
      desc = '[A]I add [B]uffer diagnostics to context',
    },
    {
      '<leader>ap',
      function()
        require('agentic').switch_provider()
      end,
      mode = { 'n' },
      desc = '[A]I switch [P]rovider',
    },
  },
}
