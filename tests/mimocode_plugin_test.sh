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

expect_file "plugins/material-3-mimocode/index.ts"
expect_file "plugins/material-3-mimocode/package.json"
expect_file "plugins/material-3-mimocode/LICENSE"
expect_file "plugins/material-3-mimocode/skills/material-3/SKILL.md"

if command -v jq >/dev/null 2>&1; then
  jq -e '.name == "material-3-mimocode" and .type == "module" and .main == "./index.ts" and .exports["./server"] == "./index.ts"' \
    plugins/material-3-mimocode/package.json >/dev/null || fail "invalid MiMo Code plugin package metadata"
  jq -e '.devDependencies["@mimo-ai/plugin"] == "0.1.16" and (.devDependencies.typescript | type == "string")' \
    plugins/material-3-mimocode/package.json >/dev/null || fail "missing MiMo Code plugin SDK or TypeScript dependency"
else
  fail "jq is required to validate the MiMo Code plugin package manifest"
fi

expect_contains "plugins/material-3-mimocode/index.ts" 'import { tool } from "@mimo-ai/plugin"'
expect_contains "plugins/material-3-mimocode/index.ts" 'id: "material-3-mimocode"'
expect_contains "plugins/material-3-mimocode/index.ts" 'material_3_reference: tool({'
expect_contains "README.md" 'mimo plugin -g'
expect_contains "README.md" 'material-3-mimocode'
expect_contains "README.md" 'MiMo Desktop uses a Node runtime'
expect_contains "README.md" 'git clone https://github.com/SoufianoDev/material-3-skill.git'
expect_contains "README.md" 'skills/material-3/.'


while IFS= read -r source; do
  target="plugins/material-3-mimocode/$source"
  expect_file "$target"
  if [[ -f "$source" && -f "$target" ]] && ! cmp -s "$source" "$target"; then
    fail "MiMo Code plugin bundle is out of sync with canonical file $source (run bash scripts/sync-mimocode-skill.sh)"
  fi
done < <(find "skills/material-3" -type f \( -name 'SKILL.md' -o -name '*.md' \) | sort)

if [[ "$failures" -gt 0 ]]; then
  printf '\n%d MiMo Code plugin check(s) failed.\n' "$failures"
  exit 1
fi

printf 'MiMo Code plugin checks passed.\n'
