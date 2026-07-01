# AGENTS.md - VitTrade Flutter Enterprise Mono-Repo

**Project:** VitTrade - Enterprise Crypto Trading App  
**Tech Stack:** Flutter, Dart, Riverpod, GoRouter  
**Package Manager:** Flutter/Dart pub  
**Test Framework:** flutter_test  
**Last Updated:** 2026-05-26

Read `docs/00_START_HERE.md` before using long-form design, architecture, or QA
guidance.

## Source Of Truth

- App package: `flutter_app/`
- App source: `flutter_app/lib/`
- Public router import: `flutter_app/lib/app/router/app_router.dart`
- Tests: `flutter_app/test/`
- Generated QA artifacts: `flutter_app/run-artifacts/`

Do not recreate root npm, Vite, React, Tailwind, or web screenshot capture
tooling. The former web baseline is obsolete historical context only.

## Architecture

Use the enterprise Flutter module layout:

```text
flutter_app/lib/
├── app/
├── core/
├── features/
│   └── <feature>/
│       ├── domain/
│       ├── data/
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── controllers/
└── shared/
```

Rules:

- Keep app bootstrap, theme, router facade, and shell composition in `app/`.
- Keep non-UI cross-cutting boundaries in `core/`.
- Keep reusable UI primitives in `shared/`.
- Keep screen widgets under `features/<feature>/presentation/pages/`.
- Put repository contracts and value objects under `domain/`.
- Put mock/remote implementations and Riverpod providers under `data/`.
- Prefer `package:vit_trade_flutter/...` imports across modules.

## Product Boundaries

Prediction Markets and Open Arena must stay separate.

| Boundary | Prediction Markets | Open Arena |
| --- | --- | --- |
| Currency | Wallet balance | Arena Points |
| Performance | PnL / positions | Points pool / completion |
| History | Orders / receipts | Ledger entries |
| Leaderboard | Trading context | Fair play / completion |

Allowed bridges: topic/category, event context, creator discovery,
search/discovery, and profile surfaces with clearly separated sections.

## UI Rules

- Use shared layout primitives before creating local scaffolds:
  `VitAppShell`, `VitPageLayout`, `VitPageContent`, `VitHeader`,
  `VitBottomNav`, `VitCard`, `VitCtaButton`, `VitInput`, and `VitTabBar`.
- Use theme tokens from `flutter_app/lib/app/theme/`.
- Keep dark theme as the active baseline.
- Support phone-first layouts at 360 px and up.
- Include loading, empty, error, offline, submitting, and success states where
  the flow needs them.
- Do not wrap `VitTabBar` / `VitSegmentedTabBar` in `VitCard` or `DecoratedBox`
  with a border — segment tabs render their own pill outline.
- Binary or semantic 2–4 option toggles (MUA/BÁN, Long/Short) use
  `VitSegmentedChoice`, not `VitCard` + `Row` + full-width `VitChoicePill`.
- Preset amount/% shortcut rows use `VitPresetChipRow`; do not wrap
  `VitCard(inner + border)` around pill rows.
- Delete local `_SegmentButton` duplicates after migration; use shared primitives.
- Open Arena community rules footer chip uses `VitCommunityRulesLink`; do not
  duplicate local `_CommunityRules*` widgets.

### Radius rules

Canonical tiers (see `AppRadii` in `app_radii.dart`):

| Role | Token | px |
| --- | --- | --- |
| Interactive controls | `AppRadii.inputRadius` | 14 |
| Standard cards | `AppRadii.cardRadius` | 16 |
| Large / hero cards | `AppRadii.cardLargeRadius` | 24 |
| Micro surfaces | `AppRadii.smRadius` | 8 |
| Status pills | `AppRadii.pillRadius` | 999 |

- CTA, input, tab, chip, segmented choice, preset row, section link, and header
  icon buttons use `inputRadius` only.
- `VitCard` uses `VitCardRadius.standard` (16) by default and
  `VitCardRadius.large` (24) for hero/large surfaces.
- Avatars, delta chips, and icon backgrounds use `smRadius` (micro).
- `VitStatusPill` / `VitAccentPill` use `pillRadius` only.
- Do not use `BorderRadius.circular()` outside `app_radii.dart`.
- Do not use `AppRadii.mdRadius` or `AppRadii.headerActionRadius` for new UI;
  they are legacy chart/chrome values.

## Financial Safety

- Preview and confirm withdrawals, escrow release, security changes, address
  additions, and P2P payment-method changes.
- Show fees, risk, limits, and next steps before high-risk confirmation.
- Mask sensitive account, wallet, email, phone, and address data.
- Arena copy must stay points-only. Do not use payout, wallet, profit, or
  stake-return language for Arena.
- Prediction Markets may use positions, probability, receipt, rewards, and P/L;
  avoid hype or casino language.

## Commands

Run from `flutter_app/`:

```bash
flutter pub get
dart format .
flutter analyze
flutter test --reporter=compact
flutter run
```

Use focused tests for touched modules and full tests for router, shared layout,
repository, or broad structural changes.

## Repo Hygiene

- Do not commit `.idea/`, `*.iml`, logs, `build/`, `.dart_tool/`,
  `flutter_app/tmp/`, `flutter_app/run-artifacts/`, or root `output/`.
- Keep Android, iOS, web, Dart source, tests, and package metadata under
  `flutter_app/`.
- Treat `docs/02_FLUTTER_MIGRATION/` as the retained path for Flutter coverage
  and QA docs, not as a dependency on old React code.

## Agent Skills

Local agent workflow skills live in `.codex/skills/`. Use them selectively for
spec, planning, implementation, testing, debugging, review, security, and UI
work. This AGENTS.md remains the higher-priority project contract; GitNexus,
Flutter commands, financial safety, and Prediction Markets/Open Arena
boundaries always take precedence over generic skill guidance.

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code** (59889 symbols, 97348 relationships, 36 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> Index stale? Run `node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills` from the project root — it refreshes the graph without generating `CLAUDE.md` or `.claude/skills`. No `.gitnexus/run.cjs` yet? `npx gitnexus analyze --skip-agents-md --skip-skills` (npm 11 crash → `npm i -g gitnexus`; #1939).

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows. For regression review, compare against the default branch: `detect_changes({scope: "compare", base_ref: "main"})`.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `rename` which understands the call graph.
- NEVER commit changes without running `detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code/context` | Codebase overview, check index freshness |
| `gitnexus://repo/Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code/clusters` | All functional areas |
| `gitnexus://repo/Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code/processes` | All execution flows |
| `gitnexus://repo/Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.codex/skills/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.codex/skills/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.codex/skills/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.codex/skills/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.codex/skills/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.codex/skills/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
