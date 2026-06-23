# VitTrade Button System Standardization Execution Plan

Status: Draft ready for implementation
Scope: Flutter app button, chip, tab, toggle, and button-like action surfaces
Primary app package: `flutter_app/`
Source of truth: `flutter_app/lib/`
Created for: AI execution without skipping pages or damaging current architecture

## 1. Objective

Standardize all button-like UI in VitTrade so every page feels like one
enterprise-grade Flutter product instead of separate local screen designs.

This plan covers:

- Full-width and sticky CTAs.
- Buy, sell, destructive, warning, secondary, ghost, and disabled actions.
- Header icon actions.
- Inline icon actions.
- Segmented controls.
- Choice chips, filter chips, payment chips, amount chips, percent chips.
- Toggle/switch style controls.
- Card/tile actions built with `InkWell` or `GestureDetector`.
- Dialog actions in high-risk financial flows.

The implementation must not restructure the app, move feature ownership, change
routes, or remove financial safety review steps.

## 2. Non-Negotiable Project Rules

Follow these rules before any implementation task:

- Read `AGENTS.md`.
- Read `docs/00_START_HERE.md`.
- Read `docs/03_DESIGN_SYSTEM/Guidelines.md`.
- Read `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`.
- Work only inside the Flutter app architecture already used by the repo.
- Keep shared primitives in `flutter_app/lib/shared/`.
- Keep feature screens under `flutter_app/lib/features/<feature>/presentation/`.
- Use theme tokens from `flutter_app/lib/app/theme/`.
- Preserve dark theme as the active baseline.
- Preserve phone-first support at 360 px and up.
- Preserve financial-safety copy, preview, fee/risk/limit review, confirmation,
  loading, success, offline, empty, and error states.
- Preserve Prediction Markets and Open Arena boundaries.
- Do not add new bottom-nav tabs.
- Do not make broad find-and-replace edits.
- Do not rename symbols manually. Use GitNexus rename if a rename is required.
- Before editing a Dart class, method, or function, run GitNexus impact analysis
  for the target symbol and record risk in the working notes.
- If impact is HIGH or CRITICAL, stop and warn the user before editing.
- After implementation batches, run GitNexus `detect_changes()` before any
  commit or handoff.

## 3. Current Button Baseline

Current source audit from `flutter_app/lib`:

| Surface | Uses | Files | Interpretation |
| --- | ---: | ---: | --- |
| `VitCtaButton` | 410 | 292 | Main shared CTA primitive. Keep as canonical. |
| `VitIconButton` | 56 | 42 | Main shared icon-action primitive. Keep as canonical. |
| `VitHeaderActionButton` | 14 | 6 | Header action primitive. Expand usage where appropriate. |
| `VitTogglePill` | 12 | 11 | Shared visual toggle primitive. Needs clearer usage rules. |
| `VitTabBar` | 105 | 104 | Shared tabs primitive. Keep as canonical. |
| `TextButton` | 85 | 46 | Direct Material use. Audit and replace where it is not dialog/simple text action. |
| `IconButton` | 69 | 56 | Direct Material use. Audit and replace where it is not platform/dialog-specific. |
| `ElevatedButton` | 2 | 1 | Should be migrated or justified. |
| `OutlinedButton` | 5 | 3 | Should be migrated or justified. |
| `FilledButton` | 10 | 5 | Should be migrated or justified. |
| `ActionChip` | 3 | 2 | Should be migrated or justified. |
| `InkWell` | 408 | 305 | Many are valid cards/tabs, but button-like usages must be standardized. |
| `GestureDetector` | 84 | 67 | Must be reviewed for semantics and replaced with shared actions when button-like. |

Class-name audit:

| Class family | Total class declarations | Unique names | Risk |
| --- | ---: | ---: | --- |
| `*Button` | 235 | 165 | High local-style fragmentation. |
| `*Chip` | 130 | 87 | High chip-style fragmentation. |
| `*Toggle` | 8 | 8 | Moderate fragmentation. |
| `*Tab` | 285 | 222 | Many are content tabs, not all are controls. Audit carefully. |
| `*Tabs` | 146 | 98 | Many wrappers around local tab systems. |

Main problem:

- The project already has good shared primitives.
- Many screens still define local `_ActionButton`, `_SegmentButton`,
  `_ChoiceChipButton`, `_PaymentChip`, `_FilterChip`, `_TabButton`, and similar
  widgets.
- These local widgets often differ in height, radius, border, active color,
  disabled opacity, text style, icon size, and semantics.

## 4. Page Coverage Baseline

Current page-bearing feature modules under `features/*/presentation/pages`:

| Feature | Page files |
| --- | ---: |
| admin | 1 |
| arena | 26 |
| auth | 6 |
| dca | 11 |
| dev | 3 |
| discovery | 2 |
| earn | 68 |
| enterprise_states | 1 |
| home | 1 |
| launchpad | 24 |
| markets | 21 |
| news | 1 |
| notifications | 1 |
| p2p | 71 |
| predictions | 17 |
| profile | 11 |
| referral | 5 |
| rewards | 1 |
| support | 3 |
| trade | 85 |
| wallet | 19 |

Total page files found: 378.

Implementation must keep a durable checklist so all 378 page files are reviewed.
Do not rely on memory.

## 5. Canonical Button Taxonomy

Every button-like UI must map to one of these canonical families. If a screen has
a control that does not fit, pause and either extend a shared primitive
additively or document why the local control remains.

### 5.1 Primary CTA

Use:

- `VitCtaButton`
- Usually full width
- Usually `AppSpacing.ctaHeight` or density-based resolved height
- Used for final user decisions and high-risk action entry points

Allowed variants:

- `primary`: neutral main action
- `success`: buy, add, approve, continue positive state
- `danger`: sell or risk-colored financial action
- `destructive`: delete, revoke, cancel irreversible state
- `warning`: elevated caution flow
- `auth`: auth primary action

Rules:

- Do not build local gradient/filled CTA classes unless they wrap `VitCtaButton`.
- Disabled state must use `onPressed: null`, not hidden opacity only.
- High-risk disabled state must explain why the button is disabled.
- Loading state must use `loading: true`.

### 5.2 Secondary CTA

Use:

- `VitCtaButton(variant: VitCtaButtonVariant.secondary)`
- `VitCtaButton(variant: VitCtaButtonVariant.ghost)` for lower emphasis

Rules:

- Use for back, preview, later, secondary route, export, details, or non-final
  actions.
- Avoid direct `OutlinedButton`, `FilledButton`, and `ElevatedButton` unless
  kept for a narrow platform/dialog reason.

### 5.3 Destructive and Risk CTA

Use:

- `VitCtaButtonVariant.danger`
- `VitCtaButtonVariant.destructive`
- `VitCtaButtonVariant.warning`

Rules:

- Require preview or confirmation when the action changes money, escrow,
  security, address, payment method, or irreversible account state.
- Copy must name what happens next.
- Never use hype language.

### 5.4 Header Icon Action

Use:

- `VitHeaderActionButton`
- `VitHeaderActionItem`
- `VitHeaderActionType`

Rules:

- Use for header/search/notification/filter/settings/export/share/favorite/add
  actions.
- Every icon-only action needs tooltip and semantics label.
- Avoid direct `IconButton` in headers unless the header primitive cannot express
  the action.

### 5.5 Inline Icon Action

Use:

- `VitIconButton`
- `VitInlineIconAction`

Rules:

- Use for copy, refresh, remove, edit, small inline actions, and compact row
  actions.
- Choose size: `sm` for dense table/list rows, `md` for card actions, `lg` for
  major icon actions.
- Do not create new local round icon buttons without checking `VitIconButton`
  first.

### 5.6 Segmented Control

Current state:

- Many screens use local `_SegmentButton`, `_TradeToggleButton`,
  `_ChoiceChipButton`, `_TabButton`, or row-based `InkWell` tabs.

Target:

- Prefer `VitTabBar(variant: VitTabBarVariant.segment)` for simple segment tabs.
- Add a shared `VitSegmentedControl` only if `VitTabBar` cannot support the
  required visual and semantic contract.

Rules:

- Segment height must be tokenized.
- Text must scale down safely and not overflow.
- Active segment must be visible by fill, text color, and border, not color
  alone when possible.
- Buy/sell segments may use `AppColors.buy` and `AppColors.sell`, but module
  identity remains an accent layer only.

### 5.7 Choice, Filter, Payment, Amount, and Percent Chips

Current state:

- Many local chip classes exist.

Target:

- Create and migrate to a shared chip primitive such as `VitChoicePill`.
- One component must support single-select, multi-select, icon-leading,
  compact, selected, disabled, and danger/success/primary tones.

Rules:

- Do not use different radius/height per page unless explicitly required.
- Multi-select chips must show selected state clearly.
- Payment method chips must not be confused with payment-window chips.
- Filter chips must be compact and scroll/wrap safely at 360 px.

### 5.8 Toggle/Switch

Use:

- `VitTogglePill` for custom visual toggles.
- Native Flutter `Switch` only if product explicitly needs system switch
  behavior.

Rules:

- Toggle rows must be tappable by row when safe, not only the knob.
- Semantics must expose checked/on state.
- High-risk toggles require confirmation if they affect security or money.

### 5.9 Card and Tile Actions

Use:

- `VitCard(onTap: ...)`
- `VitActionTileGrid`
- `VitDiscoveryActionCard`
- `VitNextActionCard`

Rules:

- Keep cards as cards when the entire card navigates or opens details.
- Do not make a local button inside a tappable card if one shared tile can do it.
- Use `Semantics(button: true)` when the card functions as a button.

### 5.10 Dialog Actions

Use:

- Existing Flutter `TextButton` may remain in simple dialogs if it follows theme
  colors and the action is clearly secondary/confirm.
- For high-risk dialogs, prefer a shared confirm/cancel pattern when available.

Rules:

- Primary confirm must be visually clear.
- Destructive confirm must use danger/destructive tone.
- Cancel must remain lower emphasis.
- Dialog copy must show consequence, fee/risk/limit where relevant, and next
  step.

## 6. Button Design Token Contract

Do not invent local values unless there is no existing token.

Use:

- Heights from `AppSpacing.ctaHeight`, `AppSpacing.buttonCompact`,
  `AppSpacing.inputHeight`, and existing feature tokens.
- Radii from `AppRadii.inputRadius`, `AppRadii.smRadius`,
  `AppRadii.headerActionRadius`, and `AppRadii.pillRadius`.
- Text from `AppTextStyles.control`, `AppTextStyles.caption`,
  `AppTextStyles.badge`, and `AppTextStyles.micro`.
- Colors from `AppColors` and gradients from `AppGradients`.
- Density from `VitDensity` when the control has standard/compact variants.

Global target behavior:

- Primary CTA: stable height, full width unless intentionally inline.
- Secondary CTA: same text rhythm and radius as primary CTA.
- Compact chip: consistent vertical padding and line height.
- Segment: consistent active/inactive states and touch target.
- Icon action: consistent icon size, background, radius, tooltip.
- Disabled control: visible but low emphasis, with reason when flow-critical.
- Loading control: no layout shift.

## 7. Required Inventory Before Coding

Before any code implementation, create or refresh a working inventory. The
inventory may be written to `flutter_app/run-artifacts/` during work, but the
final summary must report coverage.

Run from repo root:

```powershell
cd flutter_app
rg -n "\b(VitCtaButton|VitIconButton|VitHeaderActionButton|VitTogglePill|VitTabBar|TextButton|IconButton|ElevatedButton|OutlinedButton|FilledButton|ActionChip|InkWell|GestureDetector)\b" lib --glob "*.dart"
```

Run page coverage:

```powershell
cd ..
$root=(Resolve-Path .).Path
$pages=Get-ChildItem -Path "flutter_app\lib\features" -Recurse -Filter "*_page.dart" |
  Where-Object { $_.FullName -match "\\presentation\\pages\\" }
$pages | ForEach-Object { $_.FullName.Substring($root.Length+1) } | Sort-Object
"TOTAL_PAGES=$($pages.Count)"
```

Run local class coverage:

```powershell
cd flutter_app
rg -n "^(class|final class|enum)\s+[A-Za-z_][A-Za-z0-9_]*(Button|Chip|Toggle|Tab|Tabs)\b" lib\shared lib\features --glob "*.dart"
```

Inventory fields each AI batch must maintain:

| Field | Required value |
| --- | --- |
| Page or widget path | Exact path |
| Feature module | `p2p`, `trade`, `wallet`, etc. |
| Current local controls | Class names or direct Material widgets |
| Canonical replacement | `VitCtaButton`, `VitChoicePill`, etc. |
| Financial risk | none, low, high-risk confirm |
| Tests touched | Exact test path or reason missing |
| Status | todo, in_progress, done, deferred |
| Notes | Any exception or follow-up |

Do not start a later module until the active batch inventory is updated.

## 8. Implementation Order

Implementation must be sequential. Do not jump between modules without finishing
the active batch checkpoint.

### Phase 0: Read-Only Audit and Safety Setup

Goal: create a precise map before edits.

Tasks:

1. Read project rules listed in section 2.
2. Run the inventory commands in section 7.
3. Identify all direct `TextButton`, `IconButton`, `FilledButton`,
   `OutlinedButton`, `ElevatedButton`, `ActionChip`, `InkWell`, and
   `GestureDetector` usages.
4. Split usages into:
   - keep as is
   - migrate to existing shared primitive
   - migrate after creating additive shared primitive
   - defer with reason
5. Identify high-risk flows first:
   - wallet withdrawal/deposit/address/payment/security
   - P2P order/escrow/payment/dispute/ad publish
   - trade order/copy/futures/margin/high leverage
6. Do not modify code in this phase.

Acceptance criteria:

- Inventory includes all 378 page files.
- Inventory includes shared widgets likely to be touched.
- No code changes were made.
- Risk list is ordered before implementation.

Verification:

```powershell
cd flutter_app
flutter analyze
```

### Phase 1: Shared Button Foundation

Goal: make shared primitives capable enough so page migrations are small.

Candidate shared files:

- `flutter_app/lib/shared/widgets/vit_cta_button.dart`
- `flutter_app/lib/shared/widgets/vit_icon_button.dart`
- `flutter_app/lib/shared/widgets/vit_tab_bar.dart`
- `flutter_app/lib/shared/widgets/vit_toggle_pill.dart`
- new file only if needed: `flutter_app/lib/shared/widgets/vit_choice_pill.dart`
- new file only if needed: `flutter_app/lib/shared/widgets/vit_segmented_control.dart`
- `flutter_app/lib/shared/widgets/widgets.dart`

Tasks:

1. Run GitNexus impact for each shared symbol before editing.
2. Prefer additive changes. Do not break current constructor calls.
3. Add shared chip/choice primitive only if existing `VitTabBar` or
   `VitCtaButton` cannot cover chips cleanly.
4. Define selected, disabled, loading if relevant, tone, leading icon, compact
   density, and semantics behavior.
5. Add or update shared widget tests.
6. Add design-system demo coverage if current dev design system page already
   has matching patterns.

Acceptance criteria:

- Shared primitive supports P2P create ad chips and segments.
- No existing call site breaks.
- Disabled state is visually consistent.
- Icon-only controls have tooltip/semantic label.
- Text does not overflow in compact width.

Verification:

```powershell
cd flutter_app
dart format .
flutter test test/shared/widgets/vit_shared_widgets_test.dart --reporter=compact
flutter analyze
```

Checkpoint:

- Stop after Phase 1 if shared primitive impact is HIGH or CRITICAL.
- Ask user before broad migration if shared API changed more than additively.

### Phase 2: P0 Financial Critical Flows

Goal: standardize the most visible and risky controls first.

Order:

1. P2P create ad.
2. P2P order, payment, escrow, dispute.
3. Wallet withdraw, deposit, transfer, address book.
4. Trade order entry and trade settings.

#### Task 2.1: P2P Create Ad Page

Files likely touched:

- `flutter_app/lib/features/p2p/presentation/pages/p2p_create_ad_page.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_page_sections.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_choice_chips.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart`
- `flutter_app/test/features/p2p/p2p_create_ad_page_test.dart`
- `flutter_app/test/features/p2p/p2p_controller_test.dart`

Required changes:

- Replace local `_SegmentButton` visual contract with canonical segment style.
- Replace `_ChoiceChipButton` and `_PaymentChip` with canonical choice pill
  style or shared wrapper.
- Keep final CTA as `VitCtaButton`.
- Add clear disabled guidance above or near sticky CTA:
  - missing price
  - missing total amount
  - missing payment method
  - submitting state
- Make payment method chips visually distinct from payment-window chips.
- Do not enable publish without required validation.
- Keep confirmation dialog before publish.

Acceptance criteria:

- Initial disabled publish state explains why.
- Selecting valid price, total, and at least one payment method enables CTA.
- Payment-window selection alone does not enable CTA.
- Buy/sell tone is consistent with app buttons.
- No bottom nav overlap at 360 px.

Verification:

```powershell
cd flutter_app
flutter test test/features/p2p/p2p_create_ad_page_test.dart --reporter=compact
flutter test test/features/p2p/p2p_controller_test.dart --reporter=compact
flutter analyze
```

#### Task 2.2: P2P Order, Escrow, Payment, Dispute Batch

Initial pages:

- `p2p_order_page.dart`
- `p2p_order_cancel_page.dart`
- `p2p_order_proof_page.dart`
- `p2p_order_rate_page.dart`
- `p2p_payment_method_add_page.dart`
- `p2p_payment_method_verification_page.dart`
- `p2p_payment_method_ownership_page.dart`
- `p2p_payment_method_cooling_period_page.dart`
- `p2p_dispute_page.dart`
- `p2p_dispute_detail_page.dart`
- `p2p_dispute_evidence_page.dart`
- `p2p_dispute_resolution_page.dart`
- `p2p_escrow_detail_page.dart`
- `p2p_escrow_balance_page.dart`

Required changes:

- Migrate local small buttons to `VitIconButton`, `VitCtaButton`, or shared
  compact action.
- Keep high-risk confirmation and evidence upload states.
- Keep payment proof, dispute reason, and cancel reason semantics.
- Use destructive tone for cancel/delete/revoke/blacklist actions.
- Use warning tone for suspicious/risk review actions.

Acceptance criteria:

- Every high-risk CTA still has preview or confirmation.
- Every disabled CTA has a visible reason if user action is blocked.
- No local button introduces un-tokenized height/radius/color.

Verification:

```powershell
cd flutter_app
flutter test test/features/p2p --reporter=compact
flutter analyze
dart run tool/visual_density_risk_audit.dart --check
```

#### Task 2.3: Wallet Critical Batch

Initial pages:

- `wallet_page.dart`
- `deposit_page.dart`
- `withdraw_page.dart`
- `withdraw_limits_page.dart`
- `transfer_page.dart`
- `address_book_page.dart`
- `address_add_page.dart`
- `wallet_token_approval_page.dart`
- `wallet_multi_manager_page.dart`
- `transaction_detail_page.dart`
- `transaction_history_page.dart`

Required changes:

- Standardize withdraw/deposit/transfer CTAs.
- Standardize copy, scan, refresh, add address, revoke, approve, and details
  actions.
- Keep address masking and confirmation rules.
- Do not hide fees/limits behind compacting.

Verification:

```powershell
cd flutter_app
flutter test test/features/wallet --reporter=compact
flutter analyze
```

#### Task 2.4: Trade Critical Batch

Initial pages:

- `trade_page.dart`
- `trade_settings_page.dart`
- `futures_page.dart`
- `leverage_page.dart`
- `margin_trading_page.dart`
- `margin_trading_hub_page.dart`
- `order_receipt_page.dart`
- `orders_history_page.dart`
- `copy_trading_page.dart`
- `copy_confirmation_page.dart`
- `copy_provider_detail_page.dart`
- `copy_settings_page.dart`

Required changes:

- Standardize buy/sell/order submit buttons.
- Standardize percent buttons, order type tabs, leverage controls, copy action
  buttons, and receipt copy/export actions.
- Preserve order confirmation and risk review.
- Keep trade page compact and bottom-nav safe.

Verification:

```powershell
cd flutter_app
flutter test test/features/trade --reporter=compact
flutter analyze
```

Checkpoint after Phase 2:

```powershell
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
flutter test test/features/p2p --reporter=compact
flutter test test/features/wallet --reporter=compact
flutter test test/features/trade --reporter=compact
```

Also run emulator QA on representative screens:

- P2P create ad
- P2P order
- Wallet withdraw
- Trade page

### Phase 3: P1 Full P2P Completion

Goal: finish all P2P pages after the critical batch.

All P2P page files must be checked:

- `p2p_2fa_settings_page.dart`
- `p2p_achievements_page.dart`
- `p2p_ad_analytics_page.dart`
- `p2p_ad_detail_page.dart`
- `p2p_address_proof_page.dart`
- `p2p_aml_screening_page.dart`
- `p2p_anti_phishing_code_page.dart`
- `p2p_blacklist_add_page.dart`
- `p2p_blacklist_page.dart`
- `p2p_chat_page.dart`
- `p2p_claim_detail_page.dart`
- `p2p_compliance_overview_page.dart`
- `p2p_contribution_history_page.dart`
- `p2p_create_ad_page.dart`
- `p2p_dashboard_page.dart`
- `p2p_device_management_page.dart`
- `p2p_dispute_detail_page.dart`
- `p2p_dispute_evidence_page.dart`
- `p2p_dispute_page.dart`
- `p2p_dispute_resolution_page.dart`
- `p2p_disputes_page.dart`
- `p2p_e2e_info_page.dart`
- `p2p_escrow_balance_page.dart`
- `p2p_escrow_detail_page.dart`
- `p2p_express_confirm_page.dart`
- `p2p_express_page.dart`
- `p2p_fraud_prevention_page.dart`
- `p2p_fund_lock_history_page.dart`
- `p2p_guide_page.dart`
- `p2p_home_page.dart`
- `p2p_identity_verification_page.dart`
- `p2p_insurance_certificate_page.dart`
- `p2p_insurance_fund_page.dart`
- `p2p_insurance_policy_page.dart`
- `p2p_insurance_score_page.dart`
- `p2p_kyc_requirements_page.dart`
- `p2p_kyc_status_page.dart`
- `p2p_large_transaction_justification_page.dart`
- `p2p_limit_tracker_page.dart`
- `p2p_login_history_page.dart`
- `p2p_merchant_apply_page.dart`
- `p2p_merchant_profile_page.dart`
- `p2p_my_ads_page.dart`
- `p2p_my_orders_page.dart`
- `p2p_notifications_settings_page.dart`
- `p2p_order_book_page.dart`
- `p2p_order_cancel_page.dart`
- `p2p_order_page.dart`
- `p2p_order_proof_page.dart`
- `p2p_order_rate_page.dart`
- `p2p_order_timeline_page.dart`
- `p2p_payment_method_add_page.dart`
- `p2p_payment_method_cooling_period_page.dart`
- `p2p_payment_method_history_page.dart`
- `p2p_payment_method_ownership_page.dart`
- `p2p_payment_method_verification_page.dart`
- `p2p_payment_methods_page.dart`
- `p2p_report_merchant_page.dart`
- `p2p_reviews_page.dart`
- `p2p_risk_assessment_page.dart`
- `p2p_security_center_page.dart`
- `p2p_selfie_verification_page.dart`
- `p2p_settings_page.dart`
- `p2p_source_of_funds_page.dart`
- `p2p_suspicious_activity_page.dart`
- `p2p_tax_reporting_page.dart`
- `p2p_trading_level_page.dart`
- `p2p_transaction_limits_page.dart`
- `p2p_video_verification_page.dart`
- `p2p_wallet_page.dart`
- `p2p_wallet_transfer_page.dart`

Batch rule:

- Work 5 to 8 P2P pages per batch.
- Finish tests and inventory update before starting the next batch.
- Prefer pages with high direct Material button usage first.

Verification after every P2P batch:

```powershell
cd flutter_app
flutter test test/features/p2p --reporter=compact
flutter analyze
```

### Phase 4: P2 Trade, Wallet, Markets, Auth, Profile

Goal: standardize high-traffic product modules outside P2P.

Order:

1. Remaining `trade` pages.
2. Remaining `wallet` pages.
3. `markets` pages.
4. `auth` pages.
5. `profile` pages.

Rules:

- Process one feature module at a time.
- Do not mix trade and wallet edits in one batch unless a shared primitive fix is
  required.
- Keep auth buttons stable and accessible.
- Keep profile/security actions explicit and confirm destructive actions.

Feature counts:

- `trade`: 85 page files.
- `wallet`: 19 page files.
- `markets`: 21 page files.
- `auth`: 6 page files.
- `profile`: 11 page files.

Verification:

```powershell
cd flutter_app
flutter test test/features/trade --reporter=compact
flutter test test/features/wallet --reporter=compact
flutter test test/features/markets --reporter=compact
flutter test test/features/auth --reporter=compact
flutter test test/features/profile --reporter=compact
flutter analyze
```

If a feature test folder does not exist, run the nearest page or quality tests
and document the gap.

### Phase 5: P3 Remaining Product Modules

Goal: finish every remaining page without lowering financial/product safety.

Order:

1. `earn` and staking/savings pages.
2. `launchpad` pages.
3. `dca` pages.
4. `predictions` pages.
5. `arena` pages.
6. `referral`, `support`, `news`, `notifications`, `discovery`, `rewards`.
7. `admin`, `dev`, `enterprise_states`.

Rules:

- Arena remains points-only.
- Predictions may use trading/probability/PnL language, but avoid hype.
- Earn/staking must preserve risk and lockup disclosures.
- Launchpad must preserve contract/security warnings.
- Dev/design-system pages can expose examples but must not define product-only
  local button systems.

Verification after each module:

```powershell
cd flutter_app
flutter analyze
flutter test --reporter=compact
```

When full test runtime is too high during a batch, run focused tests first and
run full tests at final checkpoint.

### Phase 6: Final App-Wide Closure

Goal: prove no page was skipped.

Required final checks:

```powershell
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Required GitNexus check:

- Run `detect_changes({scope: "all"})`.
- Confirm affected symbols and flows match the button standardization scope.

Required emulator QA:

- Home
- Markets overview and one pair detail
- Trade page
- Wallet page and withdraw/deposit flow entry
- P2P create ad
- P2P order/dispute representative screen
- Profile/security representative screen

## 9. Per-Page Execution Checklist

Use this checklist for every page or widget touched.

1. Read the page file.
2. Read the local widget part files used by that page.
3. Read existing tests for that page.
4. Run GitNexus impact for any class, method, or function that will be edited.
5. Classify every button-like control into the taxonomy in section 5.
6. Decide: keep, migrate to existing shared primitive, migrate to new shared
   primitive, or defer with reason.
7. Apply the smallest code change.
8. Keep imports using `package:vit_trade_flutter/...` across modules.
9. Keep the page in its current feature module.
10. Do not change route names, paths, providers, repository contracts, or domain
    entities unless the page cannot compile without it.
11. Add semantics/tooltip for icon-only controls.
12. Add disabled reason for blocked financial CTA.
13. Add loading/submitting state if the flow already has async state.
14. Run focused tests.
15. Update inventory status.
16. Move to the next page only after the current page compiles and tests pass.

## 10. P2P Create Ad Design Direction

The P2P create ad page is the first concrete target because the user identified
its disabled publish button and inconsistent local controls.

Target layout behavior:

- Top segmented control for buy/sell uses canonical segment style.
- Price type control uses the same segment style.
- Asset and fiat chips use canonical choice pill style.
- Payment method chips use canonical multi-select pill style and selected count.
- Payment-window chips use canonical single-select pill style but visually
  separate from payment methods.
- Sticky footer keeps `VitCtaButton`.
- Disabled CTA area shows missing requirements:
  - "Nhap gia"
  - "Nhap tong USDT"
  - "Chon phuong thuc thanh toan"
- The disabled CTA remains visible but not misleading.
- Publish confirmation remains mandatory.

Do not:

- Enable publish with only payment-window selected.
- Remove escrow/risk review copy.
- Hide min/max fields if they remain required in the visual form.
- Add a new route.
- Move the page outside P2P.

## 11. Shared Primitive Migration Rules

When replacing local controls:

- If a local button is a final form submit, use `VitCtaButton`.
- If a local button is icon-only, use `VitIconButton` or
  `VitHeaderActionButton`.
- If a local button is a header action, use `VitHeaderActionButton`.
- If a local button is a segment/tab, use `VitTabBar` or shared segment control.
- If a local button is a filter/payment/amount chip, use shared choice pill.
- If a local button is a whole-card navigation action, use `VitCard(onTap:)`
  with semantics.
- If a local button is a tiny inline copy/details action, use `VitIconButton`
  size `sm`, `VitInlineIconAction`, or compact `VitCtaButton` only if text is
  required.
- If a direct Material button remains, document why.

## 12. Accessibility and Semantics Requirements

Every migrated control must satisfy:

- Icon-only actions have `tooltip` or `Semantics(label: ...)`.
- Disabled state exposes `enabled: false` when using custom semantics.
- Toggle state is clear to screen readers.
- Dialog confirm/cancel actions are named clearly.
- Hit target is not reduced below safe mobile usage.
- Text fits at 360 px width.
- Color is not the only indicator for critical selected/risk state.

## 13. Financial Safety Requirements

Do not weaken these controls:

- Withdrawals.
- Escrow release.
- P2P payment-method changes.
- P2P ad publishing.
- P2P dispute evidence and resolution.
- Address add/delete.
- API key/security settings.
- Copy trading confirmation.
- Futures/margin/leverage order actions.

For these flows:

- CTA must show disabled reason when blocked.
- CTA must show loading/submitting when action is in progress.
- Confirmation must include risk/fee/limit/next step when relevant.
- Destructive actions must not share primary/success color.

## 14. Testing Strategy

Minimum tests per batch:

- Shared primitive tests for shared widget changes.
- Focused feature tests for touched pages.
- Existing quality tests if design token or visual density changes.
- Full analyze after every batch.

Recommended command ladder:

```powershell
cd flutter_app
dart format .
flutter analyze
flutter test test/shared/widgets/vit_shared_widgets_test.dart --reporter=compact
flutter test test/features/p2p --reporter=compact
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
```

Final command ladder:

```powershell
cd flutter_app
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
dart run tool/design_token_consistency_audit.dart --check
dart run tool/visual_density_risk_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

## 15. Acceptance Criteria for Completion

The work is complete only when:

- All 378 page files were reviewed in inventory.
- All direct Material button usages are either migrated or documented.
- All local button/chip classes are either migrated or documented.
- P2P create ad button system is aligned with app-wide controls.
- P2P payment method, order, dispute, and escrow flows keep financial safety.
- Wallet withdraw/deposit/transfer/address flows keep financial safety.
- Trade order/copy/futures/margin flows keep financial safety.
- No route, module boundary, or provider contract was changed without explicit
  need.
- Shared primitives compile and tests pass.
- App-wide audits pass.
- Emulator screenshots confirm representative UI is not broken.
- GitNexus `detect_changes()` shows expected scope.

## 16. Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Editing `VitCtaButton` affects hundreds of files. | High | Run GitNexus impact, make additive changes, test shared widgets first. |
| Replacing all `InkWell` blindly breaks card navigation. | High | Classify each usage; migrate only button-like local controls. |
| Financial CTA becomes easier to tap without review. | Critical | Preserve preview/confirm and disabled requirements. |
| Button compacting hurts accessibility. | Medium | Keep readable text, semantics, and safe hit targets. |
| Local module identity becomes too strong. | Medium | Module colors remain accent only; shared button contract wins. |
| Full test suite is slow. | Medium | Use focused tests per batch, full tests at final checkpoint. |
| AI skips obscure pages. | High | Maintain inventory of all 378 page files and mark every page. |

## 17. Stop Conditions

Stop and ask the user before continuing if:

- GitNexus impact is HIGH or CRITICAL for a shared symbol.
- A change requires route/provider/domain contract edits.
- A page has no clear test coverage and touches high-risk financial behavior.
- The shared component API would require broad constructor migration.
- A disabled high-risk CTA lacks enough state information to show a truthful
  reason.
- Visual density fixes conflict with financial safety copy.

## 18. Reporting Format After Each Batch

Each implementation batch must report:

- Batch name.
- Files touched.
- Pages covered.
- Button families migrated.
- Deferred controls and reasons.
- Tests run.
- Analyze/audit result.
- GitNexus impact summary for edited symbols.
- Screenshots or emulator notes when visual behavior changed.

Example:

```text
Batch: P2P Create Ad
Pages covered: p2p_create_ad_page.dart
Migrated: segment buttons, payment chips, payment-window chips
Kept: VitCtaButton sticky footer
Deferred: AlertDialog TextButton, kept as dialog action
Tests: flutter test test/features/p2p/p2p_create_ad_page_test.dart
Analyze: pass
Emulator: checked at 360 px, no bottom-nav overlap
```

## 19. Final Notes for AI Executors

- This is a standardization project, not a redesign free-for-all.
- Do not change product flows just to make buttons prettier.
- Do not compact away risk, fee, limits, or confirmation.
- Do not create a second design system.
- Work from shared primitives outward.
- Finish one batch before starting the next.
- Update coverage notes immediately after each page.
- When in doubt, preserve behavior and improve only visual consistency,
  semantics, and disabled-state clarity.
