#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Headless smoke test — the AUTOMATED half of the eval loop.
#
# Boots this config in a throwaway environment against the committed
# lazy-lock.json, forces every plugin to load, and fails on any Lua error or
# deprecation warning. Catches the "upstream moved under me" breakages (e.g. the
# nvim 0.12 API removals: ft_to_lang, tbl_flatten, goto_prev) before you hit
# them interactively. :DotvimDoctor is the manual half (registry vs reality).
#
# Usage:
#   test/smoke.sh                 # uses `nvim` from PATH
#   NVIM=/path/to/nvim test/smoke.sh
#   nix run .#nvim -- ... ;  or  NVIM="$(nix build .#nvim --print-out-paths)/bin/nvim" test/smoke.sh
#
# Needs network the first run (Lazy! restore clones plugins at the locked pins).
# Never touches your live ~/.config/nvim2026 data — everything is isolated in a
# tmpdir via XDG_*.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVIM="${NVIM:-nvim}"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# Isolated XDG dirs: load THIS repo as the nvim2026 config, keep all plugin/data
# state in the tmpdir so a test run can't corrupt the user's editor.
export XDG_CONFIG_HOME="$WORK/config"
export XDG_DATA_HOME="$WORK/data"
export XDG_STATE_HOME="$WORK/state"
export XDG_CACHE_HOME="$WORK/cache"
export NVIM_APPNAME=nvim2026
mkdir -p "$XDG_CONFIG_HOME"
ln -s "$REPO" "$XDG_CONFIG_HOME/nvim2026"

RESTORE_LOG="$WORK/restore.log"
BOOT_LOG="$WORK/boot.log"

echo "→ installing plugins at locked pins (Lazy! restore)…"
"$NVIM" --headless "+Lazy! restore" +qa >"$RESTORE_LOG" 2>&1 || true

echo "→ booting config and loading every plugin…"
# Load all plugins, then capture :messages (where vim.deprecate warnings land)
# into the log alongside anything nvim wrote to stderr.
"$NVIM" --headless \
  "+Lazy! load all" \
  "+redir! > $BOOT_LOG" \
  "+silent messages" \
  "+redir END" \
  +qa 2>>"$BOOT_LOG" || true

echo "→ scanning output for errors / deprecations…"
# Tight patterns: vim error codes, Lua tracebacks, explicit error/deprecation
# notices. Avoids matching benign words like "errorformat".
PATTERN='E[0-9]+:|Error executing|Error detected|stack traceback|is deprecated|will be removed|attempt to (call|index)'

if grep -nEi "$PATTERN" "$RESTORE_LOG" "$BOOT_LOG"; then
  echo
  echo "✗ smoke test FAILED — see matches above"
  echo "  full logs: $RESTORE_LOG  $BOOT_LOG   (tmpdir removed on exit; re-run with WORK kept to inspect)"
  exit 1
fi

echo "✓ smoke test clean — config loads with no errors or deprecations"
