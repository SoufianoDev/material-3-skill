#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

failures=0

fail() {
  printf 'FAIL: %s\n' "$1"
  failures=$((failures + 1))
}

expect_file() {
  [[ -f "$1" ]] || fail "expected file $1"
}

expect_contains() {
  local path="$1"
  local pattern="$2"
  [[ -f "$path" ]] || { fail "cannot inspect missing file $path"; return; }
  grep -Fq "$pattern" "$path" || fail "expected $path to contain: $pattern"
}

expect_file "plugins/material-3-opencode/index.ts"
expect_file "plugins/material-3-opencode/package.json"
expect_file "plugins/material-3-opencode/LICENSE"
expect_file "plugins/material-3-opencode/skills/material-3/SKILL.md"

if command -v jq >/dev/null 2>&1; then
  jq -e '.name == "material-3" and .type == "module" and .exports["."] == "./index.ts"' \
    plugins/material-3-opencode/package.json >/dev/null || fail "invalid OpenCode plugin package metadata"
  jq -e '.dependencies["@opencode/plugin"] == "2.1.2" and (.dependencies.yaml | type == "string")' \
    plugins/material-3-opencode/package.json >/dev/null || fail "missing pinned OpenCode SDK or YAML parser dependency"
else
  fail "jq is required to validate the OpenCode plugin package manifest"
fi

expect_contains "plugins/material-3-opencode/index.ts" 'import { Plugin, Skill } from "@opencode/plugin"'
expect_contains "plugins/material-3-opencode/index.ts" 'Plugin.define({'
expect_contains "plugins/material-3-opencode/index.ts" 'ctx.skill.transform'
expect_contains "plugins/material-3-opencode/index.ts" 'Skill.ID.make("material-3")'
expect_contains "README.md" 'opencode plugin add'
expect_contains "README.md" 'plugins/material-3-opencode'

while IFS= read -r source; do
  target="plugins/material-3-opencode/$source"
  expect_file "$target"
  if [[ -f "$source" && -f "$target" ]] && ! cmp -s "$source" "$target"; then
    fail "OpenCode plugin bundle is out of sync with canonical file $source (run bash scripts/sync-opencode-skill.sh)"
  fi
done < <(find "skills/material-3" -type f \( -name 'SKILL.md' -o -name '*.md' \) | sort)

if [[ "$failures" -gt 0 ]]; then
  printf '\n%d OpenCode plugin check(s) failed.\n' "$failures"
  exit 1
fi

printf 'OpenCode V2 plugin checks passed.\n'
