# VitTrade Enterprise UI/UX Synchronization Master Plan

Updated: 2026-06-04

Scope: Flutter-only enterprise UI/UX synchronization for VitTrade, a dark
professional crypto exchange and trading super-app.

This file is the master execution plan for making the current Flutter UI
consistent without missing screens, states, safety requirements, or QA gates.
It complements these existing artifacts:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Body-Component-Consistency-Audit.csv`
- `docs/03_DESIGN_SYSTEM/Guidelines.md`
- `flutter_app/tool/body_component_consistency_audit.dart`

## 1. Objective

Bring the app to an enterprise-grade UI/UX baseline:

- Header and chrome stay consistent by route archetype.
- Body layout uses shared primitives instead of repeated local scaffolds.
- Cards, panels, forms, tabs, search, CTA, banners, and state components follow
  the VitTrade design system.
- High-risk crypto and trading flows show preview, confirmation, risk, fee,
  limit, masking, result, and next-step semantics.
- The app remains dark professional, dense enough for trading, but clear enough
  for financial decisions.
- Every routed screen is audited, graded, fixed, and verified with commands.

Target outcome:

- No `D` grade standard screens.
- No `C` grade screens in high-impact modules.
- Wallet and Profile remain A/B.
- Trade, P2P, Earn, Launchpad, Predictions, Markets, and Auth are progressively
  pulled to A/B.
- Fullscreen tools are documented as `Tool` exceptions and pass visual QA.

## 2. Current Baseline

Header visual archetype audit:

```text
total_routed_screens=414
strict_visual_issues=0
screen_level_mismatches=0
detail=393
rootModule=11
fullscreenTool=5
instrument=3
authOnboarding=1
rootBrand=1
```

Body component consistency audit:

```text
grade_A=79
grade_B=175
grade_C=109
grade_D=46
grade_Tool=5
```

Current strong modules:

| Feature | Current state | Notes |
| --- | --- | --- |
| wallet | 21 B | BCC-05 complete; no C/D. |
| profile | 3 A, 11 B | BCC-06 complete; no C/D. |
| admin | 4 A, 1 B | Good baseline. |
| cross_module | 3 A, 1 B | Good baseline. |
| support | 2 A, 1 B | Good baseline. |
| discovery | 3 B | Acceptable. |
| referral | 5 B | Acceptable. |
| rewards | 1 A | Clean. |
| onboarding | 1 A | Clean special flow. |

Current priority modules:

| Priority | Feature | Current issue load | Reason |
| --- | --- | --- | --- |
| P0 | trade | 43 C, 41 D, 3 Tool | Core trading risk and largest inconsistency. |
| P0 | p2p | 29 C, 2 D, 1 Tool | Payment, escrow, counterparty, dispute risk. |
| P1 | earn | 16 C | Yield/subscription disclosure risk. |
| P1 | launchpad | 9 C | Allocation, eligibility, subscription risk. |
| P1 | predictions | 7 C | Financial copy boundary and position/risk clarity. |
| P2 | dca | 2 D | Automation and rebalance config need safety consistency. |
| P2 | auth | 1 C, 1 D | Auth/security trust foundation. |
| P2 | markets | 1 C | Market browsing and instrument entry consistency. |
| P3 | arena | 1 C | Mostly clean; preserve points-only boundary. |
| P3 | news | 1 C | Utility cleanup. |
| P3 | notifications | 1 C | Utility cleanup. |

## 3. Enterprise Design Direction

Use these product design rules as the active standard:

- Dark professional baseline, optimized for low-light trading and OLED screens.
- Trust-first fintech tone: clear risk, state, disclosures, and controls.
- High contrast text and focus visibility.
- Gold/amber is trust and warning accent; purple/blue is technology/product
  accent; green/red remain buy/sell or positive/negative semantics.
- Avoid light page backgrounds, decorative-only gradients, hype language,
  casino language, hidden fees, and unclear state.
- Use app theme tokens from `flutter_app/lib/app/theme/`.
- Use shared primitives from `flutter_app/lib/shared/`.

Do not create new local design systems inside a feature. If a repeated pattern
is missing, add or extend a shared primitive first.

## 4. UI Types And Synchronization Rules

The app currently has six top-level visual archetypes. They must stay distinct,
but synchronized.

| Archetype | Count | UI/UX rule |
| --- | ---: | --- |
| `rootBrand` | 1 | Brand/root entry can be visually richer but must still use tokens. |
| `authOnboarding` | 1 | Auth flow can own special chrome, but forms and safety states must be shared. |
| `rootModule` | 11 | Module home screens use `VitTopChrome`, dashboard rhythm, module accent only. |
| `detail` | 393 | Standard detail rhythm: `VitHeader`, `VitPageContent`, shared cards/states. |
| `instrument` | 3 | Trading instrument workspaces may be denser but must preserve safety and nav. |
| `fullscreenTool` | 5 | Tool exception; requires visual QA, safe close/back, nonblank rendering. |

Body patterns to standardize:

| Body pattern | Used for | Required primitives |
| --- | --- | --- |
| Root module dashboard | Wallet/Profile/Markets/Earn/P2P hubs | `VitPageLayout`, `VitTopChrome`, `VitPageContent`, `VitCard`, module sections. |
| Section hub | Settings hubs, safety centers, analytics hubs | `VitHeader`, `VitPageContent`, `VitPageSection`, `VitCard`. |
| Entity detail | Asset/order/event/user/device/API detail | `VitHeader`, `VitPageContent`, `VitCard`, status pills, contextual CTA. |
| Transaction flow | Withdraw, deposit, transfer, payment, subscribe, rebalance | `VitHighRiskStatePanel`, preview/confirm/result cards, `VitCtaButton`. |
| Form/settings flow | Profile edit, API key, payment method, auth, preferences | `VitInput`, `VitCtaButton`, validation states, success/error feedback. |
| Analytics/report | Portfolio, market data, risk report, performance | Shared cards, chart container standards, empty/loading/error states. |
| Fullscreen tool | Chart terminal, trading terminal, chat | Tool-specific safe area, close/back, no bottom overlap, visual QA exception doc. |

## 5. Component Standard

Use these shared primitives before creating local UI:

- Layout: `VitAppShell`, `VitPageLayout`, `VitAutoHideHeaderScaffold`,
  `VitPageContent`, `VitPageSection`.
- Header/chrome: `VitTopChrome`, `VitHeader`, `VitHeaderActionItem`.
- Navigation: `VitBottomNav`, route-safe back helpers.
- Surface: `VitCard`, `VitCardStat`, `VitModuleHeroCard`,
  `VitMetricCard`, `VitServiceTile`.
- Controls: `VitCtaButton`, `VitIconButton`, `VitInput`, `VitSearchBar`,
  `VitTabBar`, `VitStatusPill`.
- States: `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`,
  `VitSkeleton`, `VitHighRiskStatePanel`.
- Footer: use approved sticky/inline CTA footer patterns. Do not hand-roll
  bottom-positioned CTA without bottom inset verification.

Local UI is allowed only for:

- Small badges or pills inside a shared card.
- Domain-specific chart, order book, candle, or game canvas.
- Fullscreen tool panels with documented exception.
- One-off icon avatar or visual marker that does not create a repeated surface.

## 6. No-Miss Audit Checklist For Every Screen

Use this checklist for every route before marking it complete.

```text
Feature:
Route:
Page class:
Page file:
Archetype:
Screen level:
Current grade:
Target grade:

Layout:
[ ] Uses `VitPageLayout`.
[ ] Uses `VitAutoHideHeaderScaffold` or approved fullscreen exception.
[ ] Uses `VitPageContent` for standard scroll body.
[ ] Avoids double horizontal padding.
[ ] Clears bottom nav and system safe area.

Header:
[ ] Matches expected archetype.
[ ] Root module uses root chrome.
[ ] Detail screen has back behavior.
[ ] Header actions are limited and meaningful.
[ ] No status banner is embedded inside header.

Surfaces:
[ ] Repeated panels use `VitCard` or approved shared surface.
[ ] No local repeated `Container` card system remains.
[ ] Border/radius/background use theme tokens.
[ ] Hero card is not visually unrelated to module identity.
[ ] Nested cards are avoided unless data hierarchy requires it.

Controls:
[ ] Text input uses `VitInput` or approved field primitive.
[ ] Search uses `VitSearchBar`.
[ ] Primary action uses `VitCtaButton`.
[ ] Icon action uses `VitIconButton` or `VitHeaderActionItem`.
[ ] Tabs use `VitTabBar`.
[ ] Touch targets are stable and do not resize layout.

States:
[ ] Loading state exists when data can load asynchronously.
[ ] Empty state exists for empty lists/search/filter result.
[ ] Error state exists for failure.
[ ] Offline state exists where network dependency matters.
[ ] Submitting state exists for mutating action.
[ ] Success/result state exists after high-risk or transactional action.

Financial safety:
[ ] Preview exists before high-risk confirmation.
[ ] Confirmation is explicit and reversible only when product allows it.
[ ] Fees are shown before confirmation.
[ ] Risk is shown before confirmation.
[ ] Limits are shown before confirmation.
[ ] Next steps are shown after submission/result.
[ ] Sensitive wallet/email/phone/address/API data is masked.
[ ] Destructive action has danger treatment and confirmation.

Copy boundary:
[ ] Arena uses points-only language.
[ ] Arena does not mention wallet/profit/payout/stake return.
[ ] Prediction Markets can use positions/probability/P/L/receipt.
[ ] No casino, gamble, FOMO, or hype language.
[ ] Trading copy is sober and decision-oriented.

Responsive:
[ ] Works at 360 px width.
[ ] Text does not overflow buttons/cards.
[ ] Fixed heights are justified or replaced with flexible constraints.
[ ] Keyboard/form state does not hide primary CTA.
[ ] Bottom CTA/footer does not overlap bottom nav.

Testing:
[ ] Focused feature tests pass.
[ ] `flutter analyze` passes.
[ ] Body audit passes or expected grade is documented.
[ ] Header audit remains current.
[ ] Route coverage remains current.
[ ] Emulator/visual QA is run for layout-heavy or fullscreen pages.
```

## 7. Phase Plan

### Phase 0 - Guardrails And Baseline Lock

Goal: prevent regressions while module cleanup continues.

Tasks:

- Keep top-header audit strict and current.
- Keep body audit artifacts current after every batch.
- Preserve Wallet and Profile A/B status.
- Do not start broad refactors without feature-scoped tests.
- Do not touch unrelated dirty files unless required by the feature.

Commands:

```powershell
cd flutter_app
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\body_component_consistency_audit.dart --check
dart run tool\route_coverage_audit.dart --check
flutter analyze
```

Definition of done:

- Audit artifacts current.
- No new Wallet/Profile C/D.
- No header strict issue.

### Phase 1 - Trade P0 Cleanup

Goal: eliminate Trade D screens first, then reduce Trade C to B/A.

Why first:

- Trade has the largest issue load: `43 C`, `41 D`, `3 Tool`.
- It is the highest financial-risk domain.
- It contains instrument, order, position, margin, copy trading, and risk pages.

Execution order:

1. Inventory all Trade D pages from CSV.
2. Split Trade into subgroups:
   - spot/margin instrument pages
   - order and receipt flows
   - positions and risk pages
   - copy trading pages
   - analytics/report pages
   - fullscreen trading tools
3. For each subgroup:
   - Normalize body layout to `VitPageContent`.
   - Replace repeated local panels with `VitCard`.
   - Add `VitHighRiskStatePanel` for order/risk/position settings.
   - Ensure preview/confirm/result for transaction-like actions.
   - Preserve dense trading layout where justified.
4. Document `Tool` exceptions separately.

Must not miss:

- Order entry preview/confirm.
- Position close/reduce risk disclosure.
- Margin/liquidation risk copy.
- Copy trading provider/follower risk boundaries.
- Regulatory disclosure pages.
- Empty/history/export states.
- Chart/order-book responsiveness.

Verification:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
flutter test test\features\trade --reporter=compact
flutter analyze
```

Target:

- Trade D = 0.
- Trade C reduced as far as possible in the batch.
- Tool screens documented and visually checked.

### Phase 2 - P2P P0 Cleanup

Goal: eliminate P2P D screens and bring payment/escrow/dispute flows to A/B.

Why second:

- P2P has `29 C`, `2 D`, `1 Tool`.
- It involves payment methods, counterparties, escrow, disputes, and chat.

Execution order:

1. Fix P2P D pages.
2. Normalize offer list/detail and merchant profile surfaces.
3. Normalize payment method add/edit flows.
4. Normalize escrow release/cancel/dispute flows.
5. Document chat/tool exception if present.

Must not miss:

- Payment method masking.
- Counterparty risk and completion stats.
- Escrow status and next step.
- Confirm before release/cancel.
- Dispute evidence upload states.
- Offline/error state for payment instructions.
- No hidden fees or ambiguous settlement copy.

Verification:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
flutter test test\features\p2p --reporter=compact
flutter analyze
```

Target:

- P2P D = 0.
- P2P C reduced to acceptable residual or 0.

### Phase 3 - Earn P1 Cleanup

Goal: reduce Earn C screens to B/A.

Current issue load: `16 C`.

Execution order:

1. Identify Earn C pages.
2. Group by savings, staking, strategy, auto rebalance, history, disclosure.
3. Normalize surfaces and CTA/footer treatment.
4. Add high-risk panels where subscription, redemption, lockup, yield, or
   rebalance decisions exist.

Must not miss:

- APY/yield disclaimers.
- Lockup and redemption limits.
- Auto-rebalance preview.
- Fees and next steps.
- Empty portfolio or no active product state.

Verification:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
flutter test test\features\earn --reporter=compact
flutter analyze
```

Target:

- Earn C = 0 or documented low-risk residual.

### Phase 4 - Launchpad P1 Cleanup

Goal: reduce Launchpad C screens to B/A.

Current issue load: `9 C`.

Execution order:

1. Normalize project list/detail pages.
2. Normalize subscription/allocation/eligibility pages.
3. Normalize notification and footer CTA surfaces.
4. Add preview/confirm/result semantics for subscription-like flows.

Must not miss:

- Eligibility state.
- Allocation estimate.
- Lockup/vesting schedule.
- Risk disclosure.
- No hype/FOMO language.
- Empty/upcoming/completed states.

Verification:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
flutter test test\features\launchpad --reporter=compact
flutter analyze
```

Target:

- Launchpad C = 0.

### Phase 5 - Predictions P1 Cleanup

Goal: reduce Predictions C screens to B/A while preserving the product boundary
from Arena.

Current issue load: `7 C`.

Execution order:

1. Normalize event/detail cards.
2. Normalize position/order/receipt/history surfaces.
3. Normalize probability and P/L display.
4. Add state coverage for empty orders, no positions, loading market, and result.

Must not miss:

- Prediction Markets can mention positions, probability, P/L, receipt.
- No casino/gamble/FOMO copy.
- Do not reuse Arena points-only language.
- Trading value must not visually merge with Arena challenge points.

Verification:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
flutter test test\features\predictions --reporter=compact
flutter analyze
```

Target:

- Predictions C = 0.
- Copy boundary pass.

### Phase 6 - Auth, DCA, Markets, Arena Residuals

Goal: clean remaining C/D outside the largest modules.

Targets:

- Auth: `1 C`, `1 D`.
- DCA: `2 D`.
- Markets: `1 C`.
- Arena: `1 C`.
- News: `1 C`.
- Notifications: `1 C`.

Execution order:

1. Auth and DCA first because they affect trust and automation.
2. Markets next because it drives trading entry.
3. Arena cleanup with points-only copy validation.
4. News/Notifications last.

Must not miss:

- Auth loading/error/submitting/success states.
- Password/2FA safety copy.
- DCA preview/confirm/rebalance result.
- Market empty/error/loading states.
- Arena points-only boundary.

Verification:

```powershell
cd flutter_app
dart run tool\body_component_consistency_audit.dart
flutter test test\features\auth --reporter=compact
flutter test test\features\dca --reporter=compact
flutter test test\features\markets --reporter=compact
flutter test test\features\arena --reporter=compact
flutter analyze
```

Target:

- No D standard screens.
- No C high-impact screens.

### Phase 7 - Global Polish And Visual QA

Goal: verify the app feels like one product after code-level audit passes.

Tasks:

- Review top 5 root modules: Home, Markets, Trade, Wallet, Profile.
- Review high-risk flows: withdraw, transfer, deposit, order, P2P release,
  payment method, API key, security, Earn subscribe, Launchpad subscribe.
- Run 360 px phone-width checks for dense pages.
- Run emulator screenshots for representative modules.
- Compare spacing, card radius, border, typography, and CTA rhythm.

Representative visual QA set:

| Area | Screens |
| --- | --- |
| Root tabs | Home, Markets, Trade, Wallet, Profile |
| Wallet | Wallet, Deposit, Transfer, Address Add, Token Approval |
| Profile | Profile, Security, API Management, KYC, Sub Account |
| Trade | Instrument workspace, Orders, Position, Receipt, Risk |
| P2P | Offer list, Offer detail, Payment method, Escrow/dispute |
| Earn | Product detail, Subscribe, Auto rebalance, Redemption |
| Launchpad | Project detail, Subscribe, Allocation, Vesting |
| Predictions | Event detail, Position, Order receipt |

## 8. Feature Tracking Table

Use this table as the master progress tracker.

| Feature | Current A | Current B | Current C | Current D | Tool | Target | Status |
| --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| wallet | 0 | 21 | 0 | 0 | 0 | A/B only | Done |
| profile | 3 | 11 | 0 | 0 | 0 | A/B only | Done |
| admin | 4 | 1 | 0 | 0 | 0 | A/B only | Done |
| arena | 13 | 12 | 1 | 0 | 0 | A/B only | Pending residual |
| auth | 0 | 4 | 1 | 1 | 0 | A/B only | Pending |
| cross_module | 3 | 1 | 0 | 0 | 0 | A/B only | Done |
| dca | 5 | 7 | 0 | 2 | 0 | A/B only | Pending |
| dev | 3 | 1 | 0 | 0 | 0 | A/B only | Done |
| discovery | 0 | 3 | 0 | 0 | 0 | B acceptable | Done |
| earn | 29 | 25 | 16 | 0 | 0 | A/B only | Pending |
| enterprise_states | 0 | 0 | 0 | 0 | 1 | Tool exception | Document |
| home | 0 | 1 | 0 | 0 | 0 | B acceptable | Done |
| launchpad | 9 | 6 | 9 | 0 | 0 | A/B only | Pending |
| markets | 2 | 19 | 1 | 0 | 0 | A/B only | Pending residual |
| news | 0 | 0 | 1 | 0 | 0 | A/B only | Pending residual |
| notifications | 0 | 0 | 1 | 0 | 0 | A/B only | Pending residual |
| onboarding | 1 | 0 | 0 | 0 | 0 | A/B only | Done |
| p2p | 0 | 45 | 29 | 2 | 1 | A/B only | Pending P0 |
| predictions | 4 | 8 | 7 | 0 | 0 | A/B only | Pending |
| referral | 0 | 5 | 0 | 0 | 0 | B acceptable | Done |
| rewards | 1 | 0 | 0 | 0 | 0 | A/B only | Done |
| support | 2 | 1 | 0 | 0 | 0 | A/B only | Done |
| trade | 0 | 4 | 43 | 41 | 3 | A/B only plus tools | Pending P0 |

## 9. Per-Batch Execution Template

Use this template for every cleanup batch.

```text
Batch ID:
Feature:
Routes included:
Pages included:
Current grades:
Target grades:
Risk level:

Before editing:
[ ] Read page files.
[ ] Read feature widget parts/imports.
[ ] Check existing tests.
[ ] Check current audit rows.
[ ] Identify unrelated dirty files and avoid them.

Implementation:
[ ] Add/verify `VitPageContent`.
[ ] Convert main local surfaces to `VitCard`.
[ ] Convert raw inputs/search/CTA where needed.
[ ] Add shared states.
[ ] Add high-risk panel where needed.
[ ] Preserve route keys used by tests.
[ ] Preserve financial copy boundaries.
[ ] Avoid unrelated refactors.

Verification:
[ ] `dart format` touched files.
[ ] Focused `dart analyze` if useful.
[ ] Regenerate body audit.
[ ] Confirm target feature has no unexpected C/D.
[ ] Run focused feature tests.
[ ] Run `flutter analyze`.
[ ] Run header and route audit checks if layout/router/chrome touched.

Result:
[ ] Update this plan status if needed.
[ ] Summarize pages changed.
[ ] Summarize remaining risk.
```

## 10. Required Verification Commands

Run from `flutter_app/`.

Minimum after any UI body batch:

```powershell
dart format lib\features\<feature>\presentation
dart run tool\body_component_consistency_audit.dart
flutter test test\features\<feature> --reporter=compact
flutter analyze
```

When header, route, shell, or shared layout changes:

```powershell
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
```

Before declaring an enterprise-grade milestone:

```powershell
dart run tool\body_component_consistency_audit.dart --check
dart run tool\top_header_visual_archetype_audit.dart --check --strict
dart run tool\route_coverage_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

If full test has unrelated failures, document them with exact failing tests and
run all focused tests for touched features.

## 11. Acceptance Criteria

A screen can be accepted as enterprise-grade when:

- Grade is A or B.
- `layout_status` is pass.
- `controls_status` is pass.
- `state_status` is pass.
- `financial_safety_status` is pass or not_applicable.
- `responsive_status` is pass.
- `copy_boundary_status` is pass.
- `surface_status` is pass or warn with a justified local exception.
- Focused feature tests pass.
- Analyzer passes.
- No known 360 px overflow or bottom CTA overlap.

A feature can be accepted when:

- No standard D screens remain.
- No high-impact C screens remain.
- Tool exceptions are documented.
- Representative visual QA has been completed.
- Feature tests pass.
- Audit artifacts are current.

The whole app can be accepted when:

- Header audit remains strict-clean.
- Body audit has no standard D.
- Wallet, Trade, Profile, P2P, Predictions, Markets are A/B only.
- Arena and Prediction copy boundaries remain separate.
- High-risk financial flows have preview/confirm/result semantics.
- Fullscreen tools have documented exceptions and visual QA evidence.

## 12. Risk Controls

Common risks and how to prevent them:

| Risk | Prevention |
| --- | --- |
| Double horizontal padding | Use `VitPageContent(fullBleed: true)` when scroll already has page padding. |
| Test tap failures | Preserve existing keys and avoid moving critical actions too far without scroll handling. |
| 360 px overflow | Avoid rigid widths; use `Expanded`, `Flexible`, `Wrap`, and text overflow rules. |
| Bottom CTA overlap | Use approved footer/bottom inset pattern and `MediaQuery.paddingOf(context).bottom`. |
| Local design drift | Convert repeated card/list panels to `VitCard`; keep only micro decorations local. |
| Financial safety gap | Add `VitHighRiskStatePanel` and explicit preview/confirm/result steps. |
| Arena/Prediction copy mix | Run copy boundary check and manually review points-only vs value/P/L language. |
| Dirty worktree conflict | Only edit scoped feature files; never revert unrelated changes. |

## 13. Recommended Next Step

Start with `BCC-07 Trade P0`.

Proposed first Trade batch:

1. Generate filtered CSV list for `feature == trade` and `body_grade == D`.
2. Pick 5 to 8 highest-risk D pages, not all 41 at once.
3. Normalize layout/surfaces/states.
4. Run Trade focused tests and audit.
5. Repeat until Trade D = 0.

Recommended command to inspect first batch:

```powershell
Import-Csv -Path ..\docs\02_FLUTTER_MIGRATION\VitTrade-Body-Component-Consistency-Audit.csv |
  Where-Object { $_.feature -eq 'trade' -and $_.body_grade -eq 'D' } |
  Select-Object route,page,page_file,primary_issue,recommended_action |
  Format-Table -AutoSize
```

