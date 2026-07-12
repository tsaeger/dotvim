# CodeCompanion → agentic.nvim Swap Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `olimorris/codecompanion.nvim` with `carlos-algms/agentic.nvim` as the AI chat plugin in this Neovim config, preserving `<leader>ac`/`<leader>ai` muscle memory as closely as agentic.nvim's chat-only architecture allows.

**Architecture:** Single lazy.nvim plugin spec swap in `lua/plugins/ai.lua`, configured with three ACP providers (`opencode-acp` default, `claude-agent-acp`, `codex-acp`) and lazy-loaded via `keys` (agentic.nvim has no user commands, unlike CodeCompanion). Keymaps move from `lua/core/keymaps.lua` into the plugin spec's `keys` table, matching the existing convention in `lua/plugins/obsidian.lua`.

**Tech Stack:** Neovim (Lua), lazy.nvim plugin manager, agentic.nvim (ACP chat client).

## Global Constraints

- No automated test suite exists for this Neovim config — "tests" in this plan are manual verification via headless nvim Lua checks and interactive keymap checks.
- Default provider must be `opencode-acp` (the only ACP CLI installed on this machine today; matches current CodeCompanion default).
- `claude-agent-acp` and `codex-acp` are configured as placeholders (empty override tables) — they are expected to error until their CLIs are installed separately (out of scope, per spec).
- CLI installation (`claude-agent-acp`, `codex-acp` binaries) is explicitly out of scope for this plan.
- Follow this repo's Lua style: single quotes for strings (per existing files), 2-space indent, `stylua` formatting.

---

### Task 1: Swap plugin spec in `lua/plugins/ai.lua`

**Files:**
- Modify: `lua/plugins/ai.lua` (full rewrite, currently 27 lines)
- Test: manual headless nvim Lua syntax/load check (no dedicated test file — no test suite exists in this repo)

**Interfaces:**
- Consumes: nothing from other tasks.
- Produces: `lua/plugins/ai.lua` returns a lazy.nvim spec table for `carlos-algms/agentic.nvim` with `opts.provider = 'opencode-acp'`, `opts.acp_providers` keys `'opencode-acp'`, `'claude-agent-acp'`, `'codex-acp'`, and a `keys` table with entries for `<leader>ac` (mode `{'n'}`) and `<leader>ai` (mode `{'n','v'}`). Task 2 depends on these two keymap entries existing here (so it can delete the old ones from `keymaps.lua` without losing functionality).

- [ ] **Step 1: Confirm current file contents before editing**

Run: `cat lua/plugins/ai.lua`
Expected: shows the current 27-line CodeCompanion spec (adapter `opencode` for chat/inline, `cmd` lazy-load list, plenary/treesitter deps).

- [ ] **Step 2: Rewrite `lua/plugins/ai.lua`**

Replace the entire file contents with:

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

- [ ] **Step 3: Verify the file is valid Lua**

Run: `nvim --headless -c "luafile lua/plugins/ai.lua" -c "qa" 2>&1`
Expected: no output, exit code 0 (a `return {...}` file loads and evaluates without printing anything or erroring).

If it errors, re-check for typos (missing commas, unbalanced braces) against the code block in Step 2.

- [ ] **Step 4: Run stylua formatting check**

Run: `stylua --check lua/plugins/ai.lua`
Expected: no output, exit code 0. If it reports diffs, run `stylua lua/plugins/ai.lua` to auto-fix, then re-check.

- [ ] **Step 5: Commit**

```bash
git add lua/plugins/ai.lua
git commit -s -m "feat(ai): swap codecompanion.nvim for agentic.nvim"
```

---

### Task 2: Remove obsolete AI keymaps from `lua/core/keymaps.lua`

**Files:**
- Modify: `lua/core/keymaps.lua:108-111` (the "AI/Chat keymaps" block)

**Interfaces:**
- Consumes: Task 1's `lua/plugins/ai.lua` `keys` table (already provides `<leader>ac`/`<leader>ai` equivalents), so this block is now dead/duplicate code, not a functionality gap.
- Produces: nothing consumed by later tasks.

- [ ] **Step 1: View the block to remove**

Run: `sed -n '103,112p' lua/core/keymaps.lua`
Expected output:
```lua
-- Dashboard
vim.keymap.set('n', '<leader>;', function()
  Snacks.dashboard.open()
end, { desc = 'Open Dashboard' })

-- AI/Chat keymaps
vim.keymap.set('n', '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', desc_opts '[A]I [C]hat Toggle')
vim.keymap.set('n', '<leader>ai', '<cmd>CodeCompanion<cr>', desc_opts '[A]I Inline Assistant')
vim.keymap.set('v', '<leader>ai', '<cmd>CodeCompanion<cr>', desc_opts '[A]I Inline Assistant (Visual)')
```

- [ ] **Step 2: Delete the "AI/Chat keymaps" block**

Remove these 4 lines (a blank line, the comment, and the 3 `vim.keymap.set` calls) from `lua/core/keymaps.lua`:

```lua

-- AI/Chat keymaps
vim.keymap.set('n', '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', desc_opts '[A]I [C]hat Toggle')
vim.keymap.set('n', '<leader>ai', '<cmd>CodeCompanion<cr>', desc_opts '[A]I Inline Assistant')
vim.keymap.set('v', '<leader>ai', '<cmd>CodeCompanion<cr>', desc_opts '[A]I Inline Assistant (Visual)')
```

The file should end at the Dashboard block (line 106's closing `end, { desc = 'Open Dashboard' })`) with no trailing AI section.

- [ ] **Step 3: Verify no remaining CodeCompanion references anywhere in the repo**

Run: `grep -rn -i "codecompanion" lua/ 2>/dev/null; echo "exit: $?"`
Expected: `exit: 1` (grep found nothing — no matches). If any match prints, the plugin spec or keymaps still reference CodeCompanion and must be cleaned up before proceeding.

- [ ] **Step 4: Verify the file is still valid Lua**

Run: `nvim --headless -c "luafile lua/core/keymaps.lua" -c "qa" 2>&1`
Expected: no output, exit code 0.

- [ ] **Step 5: Run stylua formatting check**

Run: `stylua --check lua/core/keymaps.lua`
Expected: no output, exit code 0.

- [ ] **Step 6: Commit**

```bash
git add lua/core/keymaps.lua
git commit -s -m "refactor(keymaps): drop codecompanion keymaps, superseded by agentic.nvim keys spec"
```

---

### Task 3: Interactive verification and lockfile sync

**Files:**
- Modify: `lazy-lock.json` (gitignored per `project-architecture` memory — lazy.nvim manages it locally; no commit needed for this file)
- Test: interactive nvim session (manual, no automated test file — this repo has no test suite)

**Interfaces:**
- Consumes: Task 1's plugin spec and Task 2's cleaned-up keymaps.
- Produces: nothing consumed by later tasks (final verification task).

- [ ] **Step 1: Launch nvim and let lazy.nvim install the new plugin**

Run: `nvim --headless "+Lazy! sync" +qa 2>&1`
Expected: output shows `agentic.nvim` being installed and `codecompanion.nvim` being removed/cleaned. No error lines (look for `Error` or `Failed`).

If `opencode-acp`/`claude-agent-acp`/`codex-acp` provider errors appear at this stage, that's unexpected — this step only installs the plugin, it doesn't launch any ACP provider yet. Investigate before proceeding.

- [ ] **Step 2: Check `:Lazy` reports no load errors**

Run: `nvim --headless -c "Lazy load agentic.nvim" -c "lua print(vim.inspect(require('lazy.core.config').plugins['agentic.nvim'] and 'loaded' or 'MISSING'))" -c "qa" 2>&1`
Expected: prints `"loaded"` with no error traceback above it.

- [ ] **Step 3: Interactively verify `<leader>ac` toggles chat**

Open nvim interactively (`nvim` in the repo, or any file), press `<leader>ac`.
Expected: the agentic.nvim chat sidebar opens (default provider `opencode-acp`, since `opencode` CLI is installed). If the sidebar opens and shows an OpenCode-backed chat prompt (even if you don't send a message), this step passes. Close it with `q` in the sidebar or `<leader>ac` again.

- [ ] **Step 4: Interactively verify `<leader>ai` adds selection to context**

In the same nvim session, open any file, visually select a few lines (`V` then move down), press `<leader>ai`.
Expected: the chat sidebar opens (if not already) and the selection appears as a context item in the chat buffer.

- [ ] **Step 5: Confirm no stray CodeCompanion state remains**

Run: `nvim --headless -c "lua print(pcall(require, 'codecompanion') and 'FOUND-should-not-exist' or 'clean')" -c "qa" 2>&1`
Expected: prints `clean` (module fails to load because the plugin is gone — `pcall` returns `false`, so the ternary lands on `'clean'`).

- [ ] **Step 6: No commit needed**

`lazy-lock.json` is gitignored (per repo convention — lazy.nvim always pulls latest). No files to stage in this task; it's verification-only. If Steps 1-5 all passed, the implementation is complete.
