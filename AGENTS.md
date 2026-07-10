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
- Put mock/remote repository implementations and their base Riverpod provider
  under `data/`; feature/screen-level controller providers that wire a
  repository provider together with `presentation/controllers/` models live
  in `app/providers/<feature>_controller_providers.dart` (composition root —
  confirmed 100% consistent across all 23 feature modules).
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

- Visual contract for agents: [`DESIGN.md`](DESIGN.md) at repo root (tokens +
  component ladder); `AGENTS.md` wins on product/financial rules.
- Full map of every design-consistency audit domain (~24), what enforces it,
  and the exact command to check it locally — see
  `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md` before
  creating a new page.
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
- **Page rhythm:** new/changed presentation pages must pass
  `page_rhythm_audit.dart --check` and `page_rhythm_guardrail_test.dart`.
  Phone-first layout @ 360×800: `page_rhythm_phone_visual_qa_test.dart`.
  Tab roots use `VitPageRhythm.compact` with major sections as direct
  `VitPageContent` children — see
  `docs/02_FLUTTER_MIGRATION/Page-Rhythm-Standard.md`.
- **Page content width:** horizontal `contentPad` (20px) applies once on the
  scroll → `VitPageContent` chain — Recipe A (`VitInsetScrollView` + default
  VPC padding) or Recipe B (scroll token with horizontal pad + `fullBleed: true`);
  see `docs/02_FLUTTER_MIGRATION/Page-Content-Width-Standard.md` and
  `page_content_width_audit.dart --check`.
- **Scroll auto-hide:** scroll-to-hide headers must use `VitAutoHideHeaderScaffold`
  / `VitAutoHidePageScaffold` only — the shared scaffold keeps a collapse-budget
  gate so short lists do not snap scroll offset back to the top. Do not hand-roll
  `_headerVisible` + `heightFactor` collapse; see
  `docs/02_FLUTTER_MIGRATION/Scroll-Auto-Hide-Standard.md` and
  `flutter test test/quality/scroll_auto_hide_guardrail_test.dart`.
- **Card tiles:** Tier A strip tiles use `VitCard.height` / `minHeight` with
  `contentAlign: VitCardContentAlign.center`, `cardTilePadding`, and
  `cardTileInnerGap` — see
  `docs/02_FLUTTER_MIGRATION/Card-Tile-Standard.md` and
  `card_tile_audit.dart --check --strict-full`.
- **Service tile badges:** Tier B `VitServiceTile` corner badges (`badgeLabel`,
  `riskBadgeLabel`) must use the shared safe-inset contract — see
  `docs/02_FLUTTER_MIGRATION/Service-Tile-Badge-Standard.md` and
  `flutter test test/quality/service_tile_badge_guardrail_test.dart`.
- **Task cards:** Tier E mission rows use `VitTaskCard` with intrinsic height —
  no `buttonHero + x7 + x5` minHeight — see
  `docs/02_FLUTTER_MIGRATION/Task-Card-Standard.md` and
  `flutter test test/quality/task_card_guardrail_test.dart`.
- **Accent icon boxes:** module row icons use `VitAccentIconBox` (34px, shared
  fill/border) — no page-local `_AccentIcon` — see
  `docs/02_FLUTTER_MIGRATION/Accent-Icon-Box-Standard.md` and
  `flutter test test/quality/accent_icon_box_guardrail_test.dart`.
- **Segment pills:** view tabs, binary toggles, preset rows, and filter chips
  use the tier decision tree — no P0 local `_FilterButton` / `_FilterTabs` /
  `_SegmentedTabs` — see
  `docs/02_FLUTTER_MIGRATION/Segment-Pill-Standard.md` and
  `dart run tool/segment_pill_audit.dart --check --strict-full` +
  `flutter test test/quality/segment_pill_guardrail_test.dart`.

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
- **Fixed-height tile cards** (horizontal strips, product tiles): set
  `VitCard.height` (or `constraints.minHeight`) with
  `contentAlign: VitCardContentAlign.center`; use `AppSpacing.cardTilePadding`
  and `AppSpacing.cardTileInnerGap` for row gaps. Do not hand-roll Column
  centering on individual pages.
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
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
flutter run
```

Use focused tests for touched modules and full tests for router, shared layout,
repository, or broad structural changes.

## Cursor AI Workflow

Cursor subscription ($200) is the default agent surface. Optimize quota with:

- Daily session: `.\scripts\Start-CursorSession.ps1` (Headroom proxy + GitNexus status).
- MCP scope split (no duplicate server names):
  - **Home** (`~/.cursor/mcp.json`): `gitnexus`, `dart` — must be Connected.
  - **Workspace** (project `.cursor/mcp.json`): `headroom` only — must be Connected.
- Model: Cursor **Auto** only — do not switch models manually or suggest tier changes.
- When stuck: smaller scope, new chat, or GitNexus trace — not a different model.
- Docs: load **one** execution prompt + **one** plan per task via `docs/INDEX.md`.
- Batch 5–10 files per turn; new chat after each batch.

### Minimal diff (Ponytail-lite)

- Rule [`.cursor/rules/vittrade-minimal-diff.mdc`](.cursor/rules/vittrade-minimal-diff.mdc) auto-applies when editing `flutter_app/**`.
- Reuse `Vit*` shared widgets and theme tokens; shortest diff that passes the plan gate.
- No one-caller abstractions, no new pub deps unless explicitly requested.
- Batch completion gate: self-check diff and trim bloat before marking batch done (see workflow rule).
- AGENTS.md and the active execution prompt override YAGNI — do not skip required migration scope.

Headroom details: `scripts/headroom/README.md`. Claude Code CLI is optional
(Anthropic account only).

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

| Task | Skill |
| --- | --- |
| UI review / screen polish | `.codex/skills/vittrade-ui-checklists/SKILL.md` |
| Pre-merge review | `.codex/skills/code-review-and-quality/SKILL.md` |
| GitNexus impact / refactor | `.codex/skills/gitnexus-impact-analysis/SKILL.md` |
| Over-engineering / diff trim | `.codex/skills/vittrade-minimal-review/SKILL.md` |
| Debug / test failure / blocked batch | `.codex/skills/debugging-and-error-recovery/SKILL.md` |
| Performance / jank / profiling | `.codex/skills/performance-optimization/SKILL.md` |
| Trade module debt scan (sprint) | `.codex/skills/ponytail-audit/SKILL.md` |

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **Tao-app-trad-figma-sang-fultter-bang-ui-ux-pro-max-truc-tiep-tu-code** (59889 symbols, 97348 relationships, 36 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> Index stale? Run `.\scripts\gitnexus\Refresh-Index.ps1` or `gitnexus analyze --skip-agents-md --skip-skills`. Local index lives in `.gitnexus/` (gitignored, ~730MB — refresh after clone).

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

More GitNexus skills: `.codex/skills/gitnexus-exploring/`, `gitnexus-debugging/`,
`gitnexus-refactoring/`, `gitnexus-guide/`, `gitnexus-cli/`.

<!-- gitnexus:end -->
