#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT/skills/material-3"
TARGET="$ROOT/plugins/material-3-mimocode/skills/material-3"

mkdir -p "$TARGET/references"
cp "$SOURCE/SKILL.md" "$TARGET/SKILL.md"
rm -f "$TARGET"/references/*.md
cp "$SOURCE"/references/*.md "$TARGET/references/"

printf 'Synced canonical Material 3 skill into the MiMo Code plugin package.\n'
