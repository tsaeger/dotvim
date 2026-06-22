#!/usr/bin/env bash
# Per-commit exec script used by rebase-signoff.sh.
# Strips Co-Authored-By trailers and ensures a Signed-off-by is present.
set -euo pipefail

NAME=$(git config user.name)
EMAIL=$(git config user.email)
SOB="Signed-off-by: $NAME <$EMAIL>"

# Strip Co-Authored-By lines; collapse runs of blank lines to one; trim trailing blanks
msg=$(git log -1 --format=%B \
  | grep -v '^Co-Authored-By:' \
  | sed 's/[[:space:]]*$//' \
  | awk '/^$/ { if (!blank) { print; blank=1 } next } { blank=0; print }' \
  | perl -0pe 's/\n+$/\n/')

# Add Signed-off-by if absent
if ! printf '%s\n' "$msg" | grep -qF "$SOB"; then
  msg="$msg

$SOB"
fi

git commit --amend --cleanup=verbatim -m "$msg"
