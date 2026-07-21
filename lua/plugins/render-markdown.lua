-- Inline markdown rendering (tables, headers, checkboxes, code, latex)
-- deps: nvim-treesitter (already installed), nvim-web-devicons (mocked via mini.icons)
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'norg', 'rmd', 'org' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    -- Render on load; toggle with :RenderMarkdown toggle
    start_enabled = true,
    -- Don't render in buffers larger than this (lines)
    max_file = 1000,
    -- LaTeX via treesitter (no external KaTeX needed for inline)
    latex = { enabled = true },
    -- Window options to set on render buffers
    win_options = {
      conceallevel = { default = 0, rendered = 3 },
      concealcursor = { default = '', rendered = 'n' },
    },
  },
}
