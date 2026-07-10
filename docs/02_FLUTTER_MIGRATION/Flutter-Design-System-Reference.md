# Flutter Design System Reference

## Purpose & how to use this doc

This is the **required entry point for UI/UX regulation** in this repo (see
`docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`) — start here before creating or
editing any page. It is a router, not the normative content itself: the
CSV/MD audit reports, the guardrail tests, and the individual `*-Standard.md`
files remain the actual source of truth for each domain's rules — this doc
exists to answer *"what governs X, and what do I run to check it locally?"*
in one place, since that full picture currently exists nowhere else in the
repo (it's scattered across 17 test files, 18 tool files, and a growing set
of per-domain markdown standards).

Every enforced UI/UX domain in this app is now covered by all three of: a
tool/test enforcement mechanism, a prose `*-Standard.md` regulation doc, and a
row in §2 below — with `lib/features/home/presentation/**` (SC-007 HomePage)
as the anchoring structural reference the majority of domains are ultimately
diffed against or extracted from (see
[Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)).
The only remaining gap is CI enforcement depth for a handful of domains — see
the **CI status** column in §2.

**Non-goals**: this doc does not restate token *values* (see
[DESIGN.md](../../DESIGN.md) and [Flutter-Design-Tokens.md](./Flutter-Design-Tokens.md)
for those) or the full shared-widget catalogue (see
[Flutter-Component-Mapping.md](./Flutter-Component-Mapping.md)). It only adds
what's missing: the full enforcement-domain map, a page-creation checklist,
and pointers to everything else.

## §1 — Foundation quick-reference

Just enough to orient — full scale and every component-specific token lives
in the linked source files.

| Category | Core tokens | Full source |
| --- | --- | --- |
| Spacing scale | `AppSpacing.x1..x7` (3/5/8/13/21/34/55), `contentPad` (20), `rowPy` (14), `inputHeight`/`ctaHeight` (52) | `lib/app/theme/app_spacing.dart` |
| Radius tiers | `AppRadii.inputRadius` (14), `cardRadius` (16), `cardLargeRadius` (24), `smRadius` (8), `pillRadius` (999) | `lib/app/theme/app_radii.dart` |
| Color foundation | `AppColors.bg`, `surface`/`surface2`/`surface3`, `border`/`borderSolid`/`cardBorder`/`divider`, `primary`, `buy`/`sell`, `warn`/`riskWarning`, `text1`/`text2`/`text3` | `lib/app/theme/app_colors.dart` |
| Component ladder | `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`, `VitStatusPill`, `VitEmptyState`/`VitErrorState`, `VitSkeleton`, and ~40 more | [Flutter-Component-Mapping.md](./Flutter-Component-Mapping.md) |
| Module accent rules | Which module gets which accent, non-negotiable foundation rules | [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md) |

## §2 — The audit-domain map

One row per enforcement domain. **CI status** distinguishes domains with a
named CI step (fails the build directly) from domains that only ride along in
the full-suite `flutter test` step, from domains that currently have **no CI
enforcement at all** — that last category is the single most useful fact this
table surfaces, since it exists nowhere else in the repo.

| Domain | Enforces | Tool | Guardrail test | Regenerate / check command | CI status |
| --- | --- | --- | --- | --- | --- |
| Home reference consistency | Structural divergence from Home's own patterns; every module hard-gated, Home locked at `0` | `tool/home_reference_consistency_audit.dart` | `home_reference_consistency_guardrail_test.dart` | `dart run tool/home_reference_consistency_audit.dart --check` | Named CI step + artifact upload |
| Design token consistency | Local literal `fontSize`/`EdgeInsets`/`BorderRadius.circular` debt; hard baseline on 5 P0 financial modules | `tool/design_token_consistency_audit.dart` | `design_token_consistency_guardrail_test.dart` | `dart run tool/design_token_consistency_audit.dart --check` | Named CI step + artifact upload |
| Card tile tiers | Tier A fixed-height strip tiles use `VitCard.height`/`cardTilePadding` | `tool/card_tile_audit.dart` | `card_tile_guardrail_test.dart` | `dart run tool/card_tile_audit.dart --check --strict-full` | Named CI step + artifact upload |
| Segment pill | Tab/toggle/preset/filter tier decision tree (S1–S4) | `tool/segment_pill_audit.dart` | `segment_pill_guardrail_test.dart` | `dart run tool/segment_pill_audit.dart --check --strict-full` | Named CI step + artifact upload |
| Page rhythm (layout) | `VitPageContent` wiring, structural nesting, vertical-rhythm tier per page | `tool/page_rhythm_audit.dart` | `page_rhythm_guardrail_test.dart` | `dart run tool/page_rhythm_audit.dart --check --strict-full` | Named CI step + artifact upload |
| Page rhythm — phone visual QA | No layout overflow @ 360×800 across 40 flows | — | `page_rhythm_phone_visual_qa_test.dart` | `flutter test test/quality/page_rhythm_phone_visual_qa_test.dart` | Named CI step |
| Page rhythm — responsive matrix | Cross-breakpoint (360/440/480) layout safety | — | `responsive_visual_qa_matrix_test.dart` | `flutter test test/quality/responsive_visual_qa_matrix_test.dart` | Full-suite only |
| Task card | Tier E intrinsic-height mission rows use `VitTaskCard` | — | `task_card_guardrail_test.dart` | `flutter test test/quality/task_card_guardrail_test.dart` | Named CI step |
| Accent icon box | `VitAccentIconBox` (34px) instead of local `_AccentIcon` | — | `accent_icon_box_guardrail_test.dart` | `flutter test test/quality/accent_icon_box_guardrail_test.dart` | Named CI step |
| Service tile badge | Tier B corner badge safe-inset contract | — | `service_tile_badge_guardrail_test.dart` | `flutter test test/quality/service_tile_badge_guardrail_test.dart` | Named CI step |
| Archetype reference (tab / wizard) | 2 canonical pages (tabbed detail, form wizard) stay divergence-free | — | `home_reference_consistency_guardrail_test.dart` (4th sub-test) | `flutter test test/quality/home_reference_consistency_guardrail_test.dart` | Named CI step (piggybacks on Home reference) |
| [Top header behavior](./Top-Header-Standard.md) | Header pin/scroll/collapse classification per route | `tool/top_header_behavior_audit.dart` | `top_header_behavior_guardrail_test.dart` | `dart run tool/top_header_behavior_audit.dart --check --strict` | Named CI step + artifact upload |
| [Top header actions](./Top-Header-Standard.md) | Trailing action/icon catalogue vs canonical set | `tool/top_header_action_audit.dart` | `top_header_action_guardrail_test.dart` | `dart run tool/top_header_action_audit.dart --check --strict` | Named CI step + artifact upload |
| [Top header global access policy](./Top-Header-Standard.md) | Which routes may expose notifications/wallet/search icons in header | `tool/top_header_global_access_policy_audit.dart` | `top_header_global_access_policy_guardrail_test.dart` | `dart run tool/top_header_global_access_policy_audit.dart --check --strict` | Named CI step + artifact upload |
| [Top header visual archetype](./Top-Header-Standard.md) | Header archetype vs screen-level (root/detail/tool) expectations | `tool/top_header_visual_archetype_audit.dart` | `top_header_visual_guardrail_test.dart` | `dart run tool/top_header_visual_archetype_audit.dart --check --strict` | Named CI step + artifact upload |
| [Back navigation behavior](./Back-Navigation-Standard.md) | Back-button presence/mode/fallback, high-risk flagging | `tool/back_navigation_behavior_audit.dart` | `back_navigation_behavior_guardrail_test.dart` | `dart run tool/back_navigation_behavior_audit.dart --check --strict` | Named CI step + artifact upload |
| [Home entry back navigation](./Back-Navigation-Standard.md) | Required/forbidden back-nav snippets for Home entry points | `tool/home_entry_back_navigation_audit.dart` | `home_entry_back_navigation_guardrail_test.dart` | `dart run tool/home_entry_back_navigation_audit.dart --check` | Named CI step + artifact upload |
| [Bottom sheet usage](./Bottom-Sheet-Standard.md) | `showVitBottomSheet` instead of raw `showModalBottomSheet` | — | `bottom_sheet_guardrail_test.dart` | `flutter test test/quality/bottom_sheet_guardrail_test.dart` | Named CI step |
| [Scroll physics](./Scroll-Physics-Standard.md) | `ClampingScrollPhysics` only, `BouncingScrollPhysics` forbidden | — | `scroll_physics_guardrail_test.dart` | `flutter test test/quality/scroll_physics_guardrail_test.dart` | Named CI step |
| [Scroll auto-hide](./Scroll-Auto-Hide-Standard.md) | Short-list snap-back: shared scaffold keeps collapse budget; no page-local `heightFactor` header hide | — | `scroll_auto_hide_guardrail_test.dart` (+ widget test) | `flutter test test/quality/scroll_auto_hide_guardrail_test.dart` | Named CI step |
| [High-risk state primitives](./High-Risk-State-Standard.md) | 8 named high-risk pages use `VitHighRiskStatePanel` + `highRiskContractId` | — | `high_risk_state_primitives_guardrail_test.dart` | `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart` | Named CI step |
| Navigation-edge graph | Navigation call → target-screen graph completeness | `tool/navigation_edge_audit.dart` | `navigation_route_guardrails_test.dart` (broader scope) | `dart run tool/navigation_edge_audit.dart --check` | Named CI step (artifact-check only) |
| Route coverage | Router path/name coverage truth table | `tool/route_coverage_audit.dart` | `route_coverage_guardrails_test.dart` (broader scope) | `dart run tool/route_coverage_audit.dart --check` | Named CI step (artifact-check only) |
| [Body component consistency](./Body-Component-Standard.md) | Layout/surface/controls/state/financial-safety/responsive/copy-boundary grading per route | `tool/body_component_consistency_audit.dart` | *(none)* | `dart run tool/body_component_consistency_audit.dart` | **Audit-only — not CI-enforced** |
| [UI fullscreen density](./UI-Density-Standard.md) | Fixed-size/local-font debt on full screens | `tool/ui_fullscreen_density_audit.dart` | *(none)* | `dart run tool/ui_fullscreen_density_audit.dart` | **Audit-only — not CI-enforced** |
| [Visual density risk](./UI-Density-Standard.md) | Cross-route visual-density risk scoring (derived from the two above) | `tool/visual_density_risk_audit.dart` | *(none)* | `dart run tool/visual_density_risk_audit.dart` | **Audit-only — not CI-enforced** |
| [Spacing token duplication](./Spacing-Token-Duplication-Standard.md) | Per-module literal values that duplicate a core `AppSpacing.x1..x7` scale step | `tool/spacing_token_duplication_audit.dart` | `spacing_token_duplication_guardrail_test.dart` | `dart run tool/spacing_token_duplication_audit.dart --check` | Named CI step + artifact upload |
| [Page content width](./Page-Content-Width-Standard.md) | Single horizontal `contentPad` owner on `ScrollView → VitPageContent`; Recipe A/B | `tool/page_content_width_audit.dart` | `page_content_width_guardrail_test.dart` | `dart run tool/page_content_width_audit.dart --check` | Named CI step + artifact upload |

## §3 — Domains with a dedicated standard doc

Read the linked doc for the full rule set; this table's row is just the
enforcement mechanics.

- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md) — Home reference consistency
- [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md) — Archetype reference (tab / wizard)
- `Page-Rhythm-Standard.md` — Page rhythm
- `Card-Tile-Standard.md` — Card tile tiers
- `Segment-Pill-Standard.md` — Segment pill
- `Service-Tile-Badge-Standard.md` — Service tile badge
- `Task-Card-Standard.md` — Task card
- `Accent-Icon-Box-Standard.md` — Accent icon box
- [High-Risk-State-Standard.md](./High-Risk-State-Standard.md) — High-risk state primitives
- [Bottom-Sheet-Standard.md](./Bottom-Sheet-Standard.md) — Bottom sheet usage
- [Body-Component-Standard.md](./Body-Component-Standard.md) — Body component consistency
- [Top-Header-Standard.md](./Top-Header-Standard.md) — Top header (behavior, actions, global access policy, visual archetype — 4 sub-domains, one doc)
- [Back-Navigation-Standard.md](./Back-Navigation-Standard.md) — Back navigation (header back-control behavior, Home-entry contract — 2 sub-domains, one doc)
- [Scroll-Physics-Standard.md](./Scroll-Physics-Standard.md) — Scroll physics
- [Scroll-Auto-Hide-Standard.md](./Scroll-Auto-Hide-Standard.md) — Scroll-linked chrome must not clamp short-list offsets
- [UI-Density-Standard.md](./UI-Density-Standard.md) — UI density (fullscreen density + visual density risk — 2 sub-domains, one doc)
- [Spacing-Token-Duplication-Standard.md](./Spacing-Token-Duplication-Standard.md) — Spacing token duplication (per-module literals reinventing a core `AppSpacing` scale step)
- [Page-Content-Width-Standard.md](./Page-Content-Width-Standard.md) — Horizontal content inset (Recipe A/B, no double `contentPad`)

## §4 — Domains without a dedicated standard doc

These rules exist only as tool/test logic today — this is the first place
they're written down in prose.

- **Navigation-edge graph / route coverage**: every navigation call must resolve to a real, reachable route — these two audits build and cross-check that full graph.

## §5 — Before creating a new page

1. Pick the right scaffold: `VitPageLayout` + `VitPageContent` (never a raw `Scaffold`). Pick a `VitPageRhythm` tier — `.compact` (tab root/feed), `.standard` (scroll list), `.form` (wizard/KYC), `.relaxed` (hero/onboarding) — see `Page-Rhythm-Standard.md`.
2. Reuse before inventing: `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`/`VitSegmentedTabBar`, `VitStatusPill`, `VitEmptyState`/`VitErrorState`/`VitOfflineBanner`, `VitSkeleton` — see [Flutter-Component-Mapping.md](./Flutter-Component-Mapping.md).
3. Tokens only — no hardcoded `fontSize`/`EdgeInsets`/`BorderRadius.circular`. Use `AppSpacing.*`, `AppRadii.*`, `AppColors.*`; new one-off tokens go in that feature's own `<module>_spacing_tokens.dart` (never back into `app_spacing.dart`).
4. Match the pattern to the content: horizontal strip tile → `Card-Tile-Standard.md`; grid tile with a corner badge → `Service-Tile-Badge-Standard.md`; mission/task row → `Task-Card-Standard.md`; module row icon → `Accent-Icon-Box-Standard.md`; any tab/toggle/preset/filter → `Segment-Pill-Standard.md`; a page with 2+ tabbed content panels or a data-entry wizard → [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md).
5. Bottom sheets always go through `showVitBottomSheet` — never `showModalBottomSheet` directly; see [Bottom-Sheet-Standard.md](./Bottom-Sheet-Standard.md).
6. Match one of the existing header archetypes and back-navigation contract — don't hand-roll a custom header or back button without a documented exception; see [Top-Header-Standard.md](./Top-Header-Standard.md) and [Back-Navigation-Standard.md](./Back-Navigation-Standard.md). Scroll-to-hide headers must go through `VitAutoHideHeaderScaffold` (collapse-budget gate) — never a page-local `heightFactor` hide; see [Scroll-Auto-Hide-Standard.md](./Scroll-Auto-Hide-Standard.md).
7. High-risk flows (withdraw/escrow/security/address/payment-method) use `VitHighRiskStatePanel` with a `highRiskContractId`; see [High-Risk-State-Standard.md](./High-Risk-State-Standard.md).
8. Run before opening a PR (from `flutter_app/`):
   ```bash
   dart run tool/design_token_consistency_audit.dart --check
   dart run tool/home_reference_consistency_audit.dart --check
   dart run tool/page_rhythm_audit.dart --check --strict-full
   dart run tool/page_content_width_audit.dart --check
   flutter test test/quality/page_rhythm_guardrail_test.dart --reporter=compact
   flutter test test/quality/page_content_width_guardrail_test.dart --reporter=compact
   flutter test test/quality/page_rhythm_phone_visual_qa_test.dart --reporter=compact
   flutter test test/quality/home_reference_consistency_guardrail_test.dart --reporter=compact
   dart run tool/route_coverage_audit.dart --check
   dart run tool/navigation_edge_audit.dart --check
   ```
9. If the new route is reachable via a nav call or link, confirm it shows up correctly in `dart run tool/navigation_edge_audit.dart` output — dangling/unlinked routes are a common miss.
10. For anything not covered above, check §2's domain map.

## §6 — Where to look next

- [docs/INDEX.md](../INDEX.md) — full doc routing table
- `Future-Feature-Onboarding-Checklist.md` — architecture/typography/size/product-safety gates for new features
- [Enterprise-PR-Review-Checklist.md](./Enterprise-PR-Review-Checklist.md) — PR-gate checklist organized by review phase
- [DESIGN.md](../../DESIGN.md) — full token values and Do's/Don'ts
