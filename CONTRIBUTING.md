# Contributing

This repo maintains a portable **Material Design 3 `SKILL.md`** plus client-specific packaging for agent tools. Keep changes **accurate**, **minimal**, and aligned with the **Compose-first** story in [README.md](README.md).

## Platform hierarchy (do not invert)

1. **Jetpack Compose** (`androidx.compose.material3`) — primary audience and most current implementation guidance.
2. **Flutter** — secondary; `useMaterial3`, `ColorScheme.fromSeed`, etc.
3. **Web** (`@material/web`, CSS tokens) — **limited**; [Material Web is in maintenance mode](https://m3.material.io/develop/web) and **M3 Expressive is not on Web**.

New examples or sections should default to **Compose** unless the change is explicitly web- or Flutter-only.

## OpenCode V2 plugin

OpenCode support is an actual TypeScript server plugin, not only a native `SKILL.md` install. Follow the [official V2 plugin docs](https://dev.opencode.ai/v2/docs/build/plugins/) and [server skill API](https://dev.opencode.ai/v2/docs/build/plugins/server).

- Plugin entry: `plugins/material-3-opencode/index.ts`
- Package metadata: `plugins/material-3-opencode/package.json`
- Canonical skill source: `skills/material-3/`
- Bundled copy used by the installable plugin: `plugins/material-3-opencode/skills/material-3/`

When editing `SKILL.md` or its references, run `bash scripts/sync-opencode-skill.sh` to update the bundled copy. The CI checks compare both trees and fail on drift. Keep the plugin as a server part unless a real Desktop-only control is needed; a custom GUI part is a separate, experimental API and is not needed to register this agent skill.

## Xiaomi MiMo Code plugin

MiMo Code is an OpenCode-derived host but uses its own SDK. Its plugin must import from `@mimo-ai/plugin`; do not reuse `@opencode/plugin` for this integration. Follow the [official MiMo Code skills documentation](https://mimo.xiaomi.com/mimocode/skills), [custom tool guide](https://mimo.xiaomi.com/mimocode/custom-tools), and the host SDK contract in [XiaomiMiMo/MiMo-Code](https://github.com/XiaomiMiMo/MiMo-Code/tree/main/packages/plugin).

- Plugin entry: `plugins/material-3-mimocode/index.ts`
- Package metadata: `plugins/material-3-mimocode/package.json`
- Canonical content: `skills/material-3/`
- Bundled plugin content: `plugins/material-3-mimocode/skills/material-3/`

When editing the canonical skill or references, run `bash scripts/sync-mimocode-skill.sh`. CI compares the plugin bundle with the canonical files and fails on drift. The current plugin exposes a read-only `material_3_reference` tool; it does not claim to register a native MiMo Skill or add a Desktop UI panel. Native skill installation remains available through MiMo Code's documented skill directories.

## M3 Expressive

Do **not** claim a feature is “available everywhere.” Use the **platform matrix** pattern in [SKILL.md](SKILL.md) (and mirror nuance in [references/typography-and-shape.md](references/typography-and-shape.md)): Compose vs Flutter vs Web, with opt-in / BOM caveats where APIs move quickly.

## Facts to double-check

- **Flutter:** `useMaterial3: true` — not `material3: true`.
- **Dynamic color from wallpaper:** Android 12+ (API 31+) for system wallpaper schemes — not a generic browser feature.
- **Contrast:** MD3 roles help; still distinguish **UI component** contrast (often 3:1) vs **body text** (typically 4.5:1) per WCAG — see audit wording in [SKILL.md](SKILL.md).
- **Shape:** Keep dialog vs card token usage consistent across [SKILL.md](SKILL.md) and [references/typography-and-shape.md](references/typography-and-shape.md).
- **Tonal palettes:** Do not reintroduce a wrong count for palette stops; see [references/color-system.md](references/color-system.md).

## Where to edit

| Topic | Start here |
|-------|------------|
| Skill entry, decision tree, audit | [SKILL.md](SKILL.md) |
| Color roles, dynamic color | [references/color-system.md](references/color-system.md) |
| Theming, dark mode, JS/CSS | [references/theming-and-dynamic-color.md](references/theming-and-dynamic-color.md) |
| Type, shape, motion, elevation | [references/typography-and-shape.md](references/typography-and-shape.md) |
| Components, Compose + web | [references/component-catalog.md](references/component-catalog.md) |
| Navigation | [references/navigation-patterns.md](references/navigation-patterns.md) |
| Breakpoints, insets, foldables | [references/layout-and-responsive.md](references/layout-and-responsive.md) |
| Repo overview, install | [README.md](README.md) |

Keep **SKILL.md** as an index; put deep Compose or web detail in **references/** unless a short snippet in SKILL is clearly better.

## PR checklist

- [ ] Compose-first wording preserved where both Compose and web appear.
- [ ] Web sections still mention maintenance / no Expressive parity when relevant.
- [ ] No contradictory token tables between files.
- [ ] Code snippets are labeled if pseudocode, BOM-dependent, or API-version-sensitive.
- [ ] Official links updated if you change behavior claims ([m3.material.io](https://m3.material.io/), [Android Developers](https://developer.android.com/develop/ui/compose/designsystems/material3)).

Thank you for helping keep this skill trustworthy for readers and agents.
