# Page Rhythm Standard (Mandatory)

**Authority:** [DESIGN.md](../../DESIGN.md) Layout · [AGENTS.md](../../AGENTS.md) UI rules  
**Enforcement:** `dart run tool/page_rhythm_audit.dart --check` · `test/quality/page_rhythm_guardrail_test.dart`  
**Reference screen:** `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`

Page rhythm makes spacing **consistent across navigation** — not just wired with a `rhythm:` token.

## Three gap levels

| Level | Owner | Token / API |
| --- | --- | --- |
| **Section gap** | Parent `VitPageContent` (`rhythm` / `customGap`) | `pageRhythm*SectionGap` |
| **Inner gap** | Section header → body | `pageRhythm*InnerGap`, `VitSectionHeader.bottomGap` |
| **Item gap** | Rows, chips, cards inside a section | `rowGap`, module item tokens |

Parent owns section gaps. Children must **not** insert orphan `SizedBox` between top-level blocks inside `VitPageContent.children`.

## Tier by navigation role

| Role | `VitPageRhythm` | Section gap | Examples |
| --- | --- | --- | --- |
| Bottom-nav tab root | `compact` | 8px | Home, Markets, Trade hub, Wallet, Profile |
| Standard scroll | `standard` | 13px | Settings, VIP, earn lists, detail scroll |
| Wizard / KYC / auth forms / bottom sheets | `form` | 16px | OTP, onboarding steps, savings guide, staking sheets, P2P merchant apply |
| Hero / onboarding hero (icon→title blocks) | `relaxed` | 24px | Welcome hero blocks, ladder/backtest hero, provider apply intro |
| Chart / terminal | `flush` | 0 | Depth, full-bleed chart |

Tab roots are listed in `flutter_app/tool/page_rhythm_audit.dart` (`_tabRootPages`).

## Six mandatory rules

1. **One rhythm owner** — Each scroll surface has one top-level `VitPageContent` with `rhythm:` or `customGap:`.
2. **Direct children = sections** — Major blocks (hero, stats, grid, menu) are **sibling** `VitPageContent` children, not one `_FooBody` `Column` wrapper.
3. **No orphan section gaps** — No `SizedBox(height: AppSpacing.sectionGap|x3|x4|x5|x6|x7|…)` between `VitPageContent` direct children. Use `pageRhythm*SectionGap`, `pageRhythm*InnerGap`, or `rowGap` only.
4. **No spacing-only nested VPC** — Do not nest `VitPageContent` only to inject gaps; flatten to direct children.
5. **Inner gap after headers** — `VitSectionHeader` uses `bottomGap: rhythm.innerGap` (or tier token); do not rely on ad-hoc `SizedBox` under labels.
6. **Tier matches role** — Tab roots use `compact`; do not use legacy `AppSpacing.sectionGap` (20px) for page section rhythm.

## Wire pattern (tab root)

```dart
VitPageContent(
  rhythm: VitPageRhythm.compact,
  padding: VitContentPadding.compact,
  density: VitDensity.compact,
  children: [
    _HeroSection(...),
    _StatsSection(...),
    _QuickActionsSection(...),
  ],
)
```

## Allowed exceptions

Document in code with a line comment:

```dart
// page-rhythm: allow-single-child — loading shell defers sections until data ready
```

Allowed without comment: `/dev/*`, CustomPainter charts, bottom sheets, tab panel internals, single `VitAsyncState` / error / empty shell on a page.

### VitModuleSectionHeader default inner gap

`VitModuleSectionHeader` applies tier-matched inner gap when `bottomGap` is omitted:

| Density | Default `bottomGap` |
| --- | --- |
| `compact` / `tool` | `pageRhythmCompactInnerGap` (5px) |
| `standard` (default) | `pageRhythmStandardInnerGap` (8px) |

Use `bottomGap: 0` when a subtitle sits in the same block; place one tier-matched gap **after** the subtitle block before body content.

### Module `*SectionGap` tokens

| Usage | Token |
| --- | --- |
| Major section on standard scroll | `pageRhythmStandardSectionGap` (13px) |
| Bottom sheet / modal wizard step | `pageRhythmFormSectionGap` (16px) |
| Hero icon → title (intro blocks) | `pageRhythmRelaxedSectionGap` or `pageRhythmRelaxedInnerGap` (13px) |
| Form / flush terminal (e.g. Market Depth) | `pageRhythmFormSectionGap` (16px) |
| In-card field stack | `pageRhythmStandardInnerGap` (8px) or `rowGap` |
| Item row / chip gap inside a section | `rowGap`, `x1`, module **item** tokens — not `*SectionGap` |
| Deprecated module section aliases | Migrate to `pageRhythmFormSectionGap` or rhythm tokens above |
| **Banned** for vertical section rhythm | `AppSpacing.x5`, `x6`, `x7` in `SizedBox(height: …)` — use tier tokens above |

Visual-debt manifest: [VitTrade-Page-Rhythm-Visual-Debt-Manifest.csv](./VitTrade-Page-Rhythm-Visual-Debt-Manifest.csv). **`--strict-full` fails when any row has `status=open`.**

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `VitPageContent` → single `_ProfileBody` `Column` | Parent rhythm never gaps hero / VIP / grid |
| `standard` on Profile tab root | 13px vs Home 8px — tabs feel misaligned |
| Module `profileSectionGap` for global section rhythm | Use `pageRhythm*SectionGap` |
| Nested `VitPageContent` for spacing only | Double ownership, audit noise |

## Verify

```bash
cd flutter_app
dart run tool/page_rhythm_audit.dart          # regenerate CSV baseline
dart run tool/page_rhythm_audit.dart --check  # CI: artifact current
flutter test test/quality/page_rhythm_guardrail_test.dart --reporter=compact
```

## Migration pointers

- Short checklist: [Page-Rhythm-Migration-Checklist.md](./Page-Rhythm-Migration-Checklist.md)
- Batch history: [Page-Rhythm-Migration-Execution-Plan.md](./Page-Rhythm-Migration-Execution-Plan.md)
- Structural debt baseline: [VitTrade-Page-Rhythm-Audit.csv](./VitTrade-Page-Rhythm-Audit.csv) (`structural_violations` column)

Structural violations are **baselined** until tab-root refactors land (Profile first). CI blocks **new** wiring debt and **new** structural debt on changed files.
