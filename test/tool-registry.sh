#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

cd "$REPO"
XDG_DATA_HOME="$WORK/data" \
XDG_STATE_HOME="$WORK/state" \
XDG_CACHE_HOME="$WORK/cache" \
"${NVIM:-nvim}" --headless -u NONE '+luafile test/tool-registry.lua' +qa
