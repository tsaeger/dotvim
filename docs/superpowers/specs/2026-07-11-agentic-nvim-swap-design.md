# Swap CodeCompanion.nvim for agentic.nvim

## Context

`lua/plugins/ai.lua` currently configures `olimorris/codecompanion.nvim` with an
`opencode` adapter for both chat and inline-edit strategies, bound to
`<leader>ac` (chat toggle) and `<leader>ai` (inline assistant, normal +
visual) in `lua/core/keymaps.lua`. Replacing it with
[carlos-algms/agentic.nvim](https://github.com/carlos-algms/agentic.nvim), an
Agent Client Protocol (ACP) chat client that shells out to external ACP CLIs
(Claude, OpenCode, Codex, etc.) instead of bundling its own provider
integrations.

## Key behavioral differences

- agentic.nvim is **chat-sidebar only** — there is no inline-diff mode
  equivalent to `:CodeCompanion` on a visual selection. Context (selection or
  whole file) is instead added to the chat via
  `add_selection_or_file_to_context()`.
- No user commands are registered (`:CodeCompanion*` has no analog); all
  functionality is exposed as Lua functions (`require('agentic').toggle()`,
  `.open()`, `.add_selection_or_file_to_context()`, `.new_session()`, etc.),
  so lazy-loading must use `keys` in the lazy.nvim spec rather than `cmd`.
- Multiple ACP providers can be configured under `acp_providers` and switched
  at runtime (`<localLeader>s` inside the chat buffer, preserving history).
  Built-in providers (`opencode-acp`, `claude-agent-acp`, `codex-acp`, etc.)
  have baked-in default commands; entries in `acp_providers` only need to
  override fields that differ from the default.

## Decisions

1. **Keymap mapping**: `<leader>ac` stays chat-toggle
   (`require('agentic').toggle()`). `<leader>ai` (normal + visual) is
   repurposed from "inline assistant" to "add selection/file to context"
   (`require('agentic').add_selection_or_file_to_context { focus_prompt = true }`),
   the closest equivalent workflow to the old inline-edit trigger.
2. **Providers configured**: `opencode-acp`, `claude-agent-acp`, and
   `codex-acp`, matching the request to have all three available via
   runtime provider switching. Default (`provider` field) stays
   `opencode-acp` to match current CodeCompanion behavior and because it's
   the only one with its CLI (`opencode`) already installed on this machine.
   `claude-agent-acp` and `codex-acp` are configured with empty override
   tables (use plugin defaults) as placeholders — they will error until their
   CLIs (`@agentclientprotocol/claude-agent-acp`,
   `@zed-industries/codex-acp`) are installed separately.
3. **CLI installation is out of scope for this change.** `dotvim`'s
   `nix/package.nix` is a deliberately lean Tier-1 tool list scoped to the
   editor runtime (LSP servers, formatters, etc.) — AI CLI agents like
   `opencode` and `claude` are already managed in the separate main system
   flake (`~/.config/nix/home/home.nix`), not in dotvim. Adding
   `claude-agent-acp`/`codex-acp` there (they're not in nixpkgs, so would
   need `pnpm add -g` or a custom derivation) is left for the user to do
   later, independently of this task.
4. **Keymap location**: moved into the plugin spec's `keys` table (matching
   the existing convention in `lua/plugins/obsidian.lua` and
   `lua/plugins/snacks.lua`), replacing the `cmd`-based lazy-loading used by
   CodeCompanion — required since agentic.nvim has no user commands to bind
   `cmd` against. The three CodeCompanion keymap lines are removed from
   `lua/core/keymaps.lua`.

## Changes

### `lua/plugins/ai.lua` (full replacement)

```lua
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
      function() require('agentic').toggle() end,
      mode = { 'n' },
      desc = '[A]I [C]hat Toggle',
    },
    {
      '<leader>ai',
      function() require('agentic').add_selection_or_file_to_context { focus_prompt = true } end,
      mode = { 'n', 'v' },
      desc = '[A]I add selection/file to context',
    },
  },
}
```

### `lua/core/keymaps.lua`

Remove the "AI/Chat keymaps" block (the three `CodeCompanion*` lines) since
the equivalent keymaps now live in `lua/plugins/ai.lua`.

## Testing

Manual verification in nvim (`nvim2026` config):
- `<leader>ac` toggles the agentic chat sidebar, defaulting to `opencode-acp`.
- `<leader>ai` in visual mode adds the selection to chat context.
- `:Lazy` shows no errors loading the plugin; lazy-lock.json updates on
  `:Lazy sync` after `olimorris/codecompanion.nvim` no longer appears in any
  spec.
