# AGENTS.md - VitTrade Flutter Enterprise Mono-Repo

**Project:** VitTrade - Enterprise Crypto Trading App  
**Tech Stack:** Flutter, Dart, Riverpod, GoRouter  
**Package Manager:** Flutter/Dart pub  
**Test Framework:** flutter_test  
**Last Updated:** 2026-07-18 (GĐ4-S4: 28 feature module / 27 file controller_providers; ARCH-A4: quy ước part-file; DOC-D4: hệ ADR)

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
  - **Documented exception:** `core/navigation/back_navigation.dart` imports
    `flutter/widgets.dart` + `go_router` because `goBackOrFallback` needs a
    `BuildContext` to call `context.go`/`context.pop`. This is the one
    sanctioned "UI-adjacent" file in `core/` — do not use it as precedent for
    importing Flutter/UI packages elsewhere in `core/`. The path-validation
    helpers in the same file (`resolveSafeBackPath`, `_normalizeInternalPath`)
    are pure Dart and stay non-UI.
- Keep reusable UI primitives in `shared/`.
- Keep screen widgets under `features/<feature>/presentation/pages/`.
- Put repository contracts and value objects under `domain/`.
- Put mock/remote repository implementations and their base Riverpod provider
  under `data/`; feature/screen-level controller providers that wire a
  repository provider together with `presentation/controllers/` models live
  in `app/providers/<feature>_controller_providers.dart` (composition root —
  27 provider files covering 27/28 feature modules as of 2026-07-18; naming
  variants: `dev` → `dev_tools_controller_providers.dart`, `markets` →
  `market_controller_providers.dart`. `trade_core` intentionally has none —
  it is the shared entity kernel with no screens/controllers of its own).
- Prefer `package:vit_trade_flutter/...` imports across modules.

### State management / controller pattern

Chuẩn chốt tại GĐ2 · STATE-S26 (2026-07-17), chi tiết trong
`docs/05_ARCHITECTURE/decisions/ADR-001-async-error-idiom.md`:

- Controller có **mutation / async / status transition** ⇒ `NotifierProvider`
  (đường đọc async thuần dùng `AsyncNotifierProvider`). Family arg truyền qua
  constructor (`ClassName.new` — idiom Riverpod 3). Khuôn mẫu:
  `NotificationsStateController`
  (`lib/app/providers/notifications_controller_providers.dart`) và
  `TradeOrderController` (implementation tham chiếu ADR-001).
- `Provider<Controller>` const CHỈ cho **read-model thuần** (không ghi status,
  không repo-write). Ví dụ hợp lệ: `tradeReadModelControllerProvider`,
  `TradeMarginController`.
- Cấm seed `late List` từ `ref.read` rồi mutate bằng `setState`
  (dual-source-of-truth — STATE-S23 đang gỡ). Guardrail:
  `flutter_app/test/quality/state_management_guardrail_test.dart`.
- Family key: scalar/record-of-scalar, hoặc bắt buộc `.autoDispose`
  (STATE-S24).
- Máy trạng thái high-risk dùng enum `TradeHighRiskFlowStatus` (10 giá trị),
  KHÔNG bọc `AsyncValue` — xem bảng điểm ghi trong ADR-001.

### Quy ước part-file

Chuẩn chốt tại GĐ3 · ARCH-A4 (2026-07-18):

- Tách một file lớn thành `part`/`part of` là hợp lệ, nhưng **tên part phải
  mang vai trò ổn định**: `_sections` (các section UI của trang), `_common`
  (widget/helper dùng chung trong trang), `_widgets`, `_state`, `_methods`
  (nhóm method của mock repo), `_entities`...
- **KHÔNG dùng suffix số thứ tự `_part_NN`** — đó là tách cơ học tạm thời, là
  "nợ có theo dõi". Toàn lib/ hiện đã về 0 và bị khóa ở 0 bởi guardrail
  `test/quality/architecture_size_style_debt_guardrails_test.dart`.
- UI tái dùng nên chuyển vào `presentation/widgets/` thay vì phình part-file
  của trang.

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

## Chính sách ngôn ngữ (vi-VN-only)

Chuẩn chốt tại GĐ2 · I18N-1 (DEC-i18n Nhánh A, 2026-07-16):

- Copy sản phẩm user-facing là **tiếng Việt có dấu đầy đủ, viết inline** —
  hợp lệ, KHÔNG cần bọc qua ARB/gen-l10n ở giai đoạn mock-UI này. Lý do:
  sản phẩm một ngôn ngữ, backend chưa chốt; bọc l10n sớm chỉ thêm một tầng
  gián tiếp mà không có người dùng thứ hai ngôn ngữ nào hưởng lợi.
- Đường nâng cấp đã định: khi có backend/đa ngôn ngữ thật, migrate sang
  `flutter gen-l10n` (ARB) theo từng module — locale runtime đã sẵn
  (`flutter_localizations` + `locale: vi` trong `vit_trade_app.dart`,
  I18N-2).
- **Cấm thêm chuỗi tiếng Anh user-facing MỚI** trong presentation layer.
  Ratchet: `flutter_app/test/quality/i18n_vi_only_guardrail_test.dart` +
  baseline `i18n_vi_only_baseline.txt` (nợ tiếng Anh baseline — xem số dòng
  file làm nguồn sự thật, đang giảm dần —
  trả dần khi chạm file; SỬA một chuỗi baseline nghĩa là dịch nó luôn).
  Lưu ý heuristic: tiếng Việt KHÔNG DẤU ("mua nhanh") từng false-positive
  là tiếng Anh — guardrail chỉ bắt chuỗi có ≥2 từ marker tiếng Anh, không
  language-detect; copy mới cứ viết đủ dấu là an toàn.
- Nhãn kỹ thuật không phải copy (semanticIdentifier, route path, Key, tên
  package/API) không thuộc phạm vi chính sách này.

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
  `docs/02_FLUTTER_MIGRATION/standards/Page-Rhythm-Standard.md`.
- **Page content width:** horizontal `contentPad` (20px) applies once on the
  scroll → `VitPageContent` chain — Recipe A (`VitInsetScrollView` + default
  VPC padding) or Recipe B (scroll token with horizontal pad + `fullBleed: true`);
  see `docs/02_FLUTTER_MIGRATION/standards/Page-Content-Width-Standard.md` and
  `page_content_width_audit.dart --check`.
- **Scroll auto-hide:** scroll-to-hide headers must use `VitAutoHideHeaderScaffold`
  / `VitAutoHidePageScaffold` only — the shared scaffold keeps a collapse-budget
  gate so short lists do not snap scroll offset back to the top. Do not hand-roll
  `_headerVisible` + `heightFactor` collapse; see
  `docs/02_FLUTTER_MIGRATION/standards/Scroll-Auto-Hide-Standard.md` and
  `flutter test test/quality/scroll_auto_hide_guardrail_test.dart`.
- **Notice acknowledgements:** success / error / “sẽ sớm ra mắt” / must-ack UI
  must use `showVitNoticeSheet` (not `SnackBar`, not `Positioned` success
  toasts, not sticky Share+Continue footers). `VitStickyFooter` / scaffold
  `footer:` stay valid only for in-progress form/wizard CTAs. See
  `docs/02_FLUTTER_MIGRATION/standards/Notice-Acknowledgement-Standard.md` and
  `flutter test test/quality/notice_acknowledgement_guardrail_test.dart`.
- **Card tiles:** Tier A strip tiles use `VitCard.height` / `minHeight` with
  `contentAlign: VitCardContentAlign.center`, `cardTilePadding`, and
  `cardTileInnerGap` — see
  `docs/02_FLUTTER_MIGRATION/standards/Card-Tile-Standard.md` and
  `card_tile_audit.dart --check --strict-full`.
- **Service tile badges:** Tier B `VitServiceTile` corner badges (`badgeLabel`,
  `riskBadgeLabel`) must use the shared safe-inset contract — see
  `docs/02_FLUTTER_MIGRATION/standards/Service-Tile-Badge-Standard.md` and
  `flutter test test/quality/service_tile_badge_guardrail_test.dart`.
- **Task cards:** Tier E mission rows use `VitTaskCard` with intrinsic height —
  no `buttonHero + x7 + x5` minHeight — see
  `docs/02_FLUTTER_MIGRATION/standards/Task-Card-Standard.md` and
  `flutter test test/quality/task_card_guardrail_test.dart`.
- **Accent icon boxes:** module row icons use `VitAccentIconBox` (34px, shared
  fill/border) — no page-local `_AccentIcon` — see
  `docs/02_FLUTTER_MIGRATION/standards/Accent-Icon-Box-Standard.md` and
  `flutter test test/quality/accent_icon_box_guardrail_test.dart`.
- **Segment pills:** view tabs, binary toggles, preset rows, and filter chips
  use the tier decision tree — no P0 local `_FilterButton` / `_FilterTabs` /
  `_SegmentedTabs` — see
  `docs/02_FLUTTER_MIGRATION/standards/Segment-Pill-Standard.md` and
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
 - **Home** (`~/.cursor/mcp.json`): `gitnexus`, `dart`, `headroom` — must be Connected.
 - **Workspace** (project `.cursor/mcp.json`): empty — no project-level servers.
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

## Claude Code Subagents

Claude Code sessions only — dispatched via the Task/Agent tool, not directly
invokable from Cursor/Codex. Each file under `.claude/agents/` is a
self-contained runbook in plain markdown; any AI (including Cursor's) can
still open one and follow its procedure manually for a matching task.

Entry slash commands (Claude Code): `/vt-verify`, `/vt-audit`, `/vt-batch`
(Plan → Build → Trim → Verify for one batch), `/vt-review` (pre-merge).
Project skills: `.claude/skills/*/SKILL.md` (mirrors under `.codex/skills/`
are for Cursor/Codex — runtimes do not share skill discovery). Session
discipline: `.claude/rules/session-discipline.md`. Descendant notes:
`flutter_app/CLAUDE.md`.

| Task | Agent |
| --- | --- |
| Split large migration/rollout into safe batches | `.claude/agents/flutter-batch-planner.md` |
| Implement one pre-scoped batch | `.claude/agents/flutter-batch-builder.md` |
| Design/build a new screen or deliberate redesign | `.claude/agents/flutter-screen-designer.md` |
| Check design-consistency domain compliance | `.claude/agents/flutter-domain-auditor.md` |
| Trim over-engineered diff (current diff only) | `.claude/agents/flutter-diff-trimmer.md` |
| Whole-module architecture-debt sweep (dead code/circular/god-class) | `.claude/agents/flutter-architecture-sweep.md` |
| Check button/data-flow wiring (dead `onPressed`/`onTap`) | `.claude/agents/flutter-button-wiring-auditor.md` |
| Write unit/controller/widget tests | `.claude/agents/flutter-test-writer.md` |
| Check structural test-coverage gaps | `.claude/agents/flutter-test-coverage-auditor.md` |
| Full PR merge-readiness gate | `.claude/agents/flutter-pr-gate.md` |

`flutter-architecture-sweep` is the Claude Code-native counterpart to the
`ponytail-audit` skill above — same ledger format/location
(`flutter_app/run-artifacts/ponytail-audit-<scope>-<date>.md`), same tags,
but uses the `tokensave` MCP server instead of GitNexus (unavailable in
Claude Code sessions). They are two entry points to the same process, not
two different processes.

`flutter-button-wiring-auditor` fills a gap neither `route_coverage_audit`
nor `navigation_edge_audit` covers: those two verify navigation calls
resolve to real routes, not that non-navigation `onPressed`/`onTap`
handlers actually do anything. Ledger location:
`flutter_app/run-artifacts/button-wiring-audit-<scope>-<date>.md`.

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
