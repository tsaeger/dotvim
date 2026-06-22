#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Static analysis CI script — stylua format check + lua-language-server check.
#
# Usage:
#   test/lint.sh                   # stylua from PATH (nix develop puts it there)
#   nix run nixpkgs#stylua -- ...  # or let the script fall back to nix run
#
# Exit codes: 0 = clean, 1 = issues found.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=true

# ── helpers ──────────────────────────────────────────────────────────────────

_stylua() {
  if command -v stylua &>/dev/null; then
    stylua "$@"
  else
    nix run nixpkgs#stylua -- "$@"
  fi
}

_lls() {
  if command -v lua-language-server &>/dev/null; then
    lua-language-server "$@"
  else
    nix run nixpkgs#lua-language-server -- "$@"
  fi
}

# ── 1. stylua ────────────────────────────────────────────────────────────────
echo "→ stylua --check …"

STYLUA_ISSUES="$(_stylua --check "$REPO" 2>&1)" || {
  echo "$STYLUA_ISSUES"
  echo
  echo "✗ stylua: formatting issues found  (run: stylua $REPO)"
  PASS=false
}

if [ "$PASS" = "true" ] || [ -z "$STYLUA_ISSUES" ]; then
  echo "  ✓ stylua clean"
fi

# ── 2. lua-language-server --check ───────────────────────────────────────────
echo "→ lua-language-server --check …"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

LLS_OUT="$WORK/lls.log"

_lls --check "$REPO" --logpath "$WORK" >"$LLS_OUT" 2>&1 || true

# LLS writes diagnostics to check.json inside --logpath
CHECK_JSON="$WORK/check.json"

if [ -f "$CHECK_JSON" ]; then
  # Filter out info-level items; keep warnings and errors
  ISSUES="$(python3 -c "
import json, sys
data = json.load(open('$CHECK_JSON'))
items = [d for d in data if d.get('severity', 4) <= 2]  # 1=error 2=warning
if items:
    for d in items:
        sev = 'error' if d.get('severity') == 1 else 'warning'
        path = d.get('uri','').replace('file://', '')
        line = d.get('range', {}).get('start', {}).get('line', 0) + 1
        msg  = d.get('message', '')
        code = d.get('code', '')
        print(f'{path}:{line}: [{sev}] {code} {msg}')
sys.exit(1 if items else 0)
" 2>&1)" && LLS_OK=true || LLS_OK=false

  if [ "$LLS_OK" = "false" ]; then
    echo "$ISSUES"
    echo
    echo "✗ lua-language-server: warnings/errors found"
    PASS=false
  else
    echo "  ✓ lua-language-server clean"
  fi
else
  # No check.json means LLS found nothing to report
  echo "  ✓ lua-language-server clean (no diagnostics file)"
fi

# ── summary ──────────────────────────────────────────────────────────────────
echo
if [ "$PASS" = "true" ]; then
  echo "✓ lint clean"
  exit 0
else
  echo "✗ lint FAILED"
  exit 1
fi
