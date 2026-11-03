#!/usr/bin/env bash
# Decides which workflows a change needs (REPO-01) and writes flags to $GITHUB_OUTPUT.
# Usage: changed.sh <base-sha> (empty or all zeros means "run everything").
set -euo pipefail
base="${1:-}"
out="${GITHUB_OUTPUT:-/dev/stdout}"

if [[ -z "$base" || "$base" =~ ^0+$ ]] || ! git cat-file -e "$base^{commit}" 2>/dev/null; then
  files="__everything__"
else
  files="$(git diff --name-only "$base" HEAD)"
fi

hit() { # hit <extended-regex>
  if [[ "$files" == "__everything__" ]] || grep -Eq "$1" <<<"$files"; then echo true; else echo false; fi
}

shared='^(packages/tokens/|supabase/|\.github/(scripts/|workflows/ci\.yml))'
{
  echo "mobile=$(hit "^apps/mobile/|$shared|^\.github/workflows/mobile\.yml$")"
  echo "admin=$(hit "^apps/admin/|^package(-lock)?\.json$|$shared|^\.github/workflows/admin\.yml$")"
  echo "supabase=$(hit "^supabase/|^scripts/gen-types\.mjs$|^\.github/(scripts/|workflows/(ci|supabase)\.yml)")"
} >> "$out"
