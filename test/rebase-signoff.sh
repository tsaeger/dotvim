#!/usr/bin/env bash
# Rebase all commits since BASE, stripping Co-Authored-By trailers and
# adding Signed-off-by to each commit.
#
# Usage:
#   test/rebase-signoff.sh                  # base defaults to origin/nvim2025
#   test/rebase-signoff.sh origin/main
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="${1:-origin/nvim2025}"
CLEANUP="$REPO/test/commit-cleanup.sh"

git -C "$REPO" rebase "$BASE" --exec "$CLEANUP"
