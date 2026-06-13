# VitTrade Typography Residual Unification Execution Plan

Updated: 2026-06-13

Scope: Flutter frontend in `flutter_app/`.

Muc tieu cua file nay la tao ke hoach **thuc thi tiep** cho phan font chu va
kich thuoc font chu con chua thong nhat 100% sau khi
`VitTrade-Typography-Standardization-Plan.md` da complete den T5.5.

Day khong phai plan thay the. Day la plan residual burn-down moi, dung de AI
lam tiep theo batch nho, tiet kiem token, nhung van giu chat luong UI va
financial safety.

## Trang Thai Hien Tai

Ket qua scan gan nhat / Current Metrics sau RU5 strict typography completion
(2026-06-13):

| Metric | Current |
| --- | ---: |
| `fontSize:` trong `flutter_app/lib` | 42 |
| `fontSize:` ngoai `app/theme` | 0 |
| `fontSize: <number>` truc tiep ngoai theme | 0 |
| `copyWith(fontSize: ...)` ngoai theme theo quick scan | 0 |
| `copyWith(...fontSize...)` ngoai theme theo strict multiline gate | 0 |
| `TextStyle(...)` ngoai theme | 0 |
| `fontFamily:` ngoai theme | 0 |
| `fontFamily: 'monospace'` | 0 |
| `fontFamily: 'Roboto'` | 0 |

Module hotspot theo direct `fontSize`:

| Module | Direct `fontSize` | `fontFamily` | `FontWeight.w800/w900` |
| --- | ---: | ---: | ---: |
| `features/trade` | 0 | 0 | 0 |
| `features/p2p` | 0 | 0 | 0 |
| `features/profile` | 0 | 0 | 0 |
| `features/markets` | 0 | 0 | 0 |
| `features/news/onboarding/support/auth/wallet/discovery` | 0 | 0 | 0 |

Ket luan: strict source-level typography residual da ve **0 ngoai
`app/theme`**. Cac `fontSize:` con lai chi nam trong theme token definitions;
audit gate da chan drift moi cho `fontSize:`, `TextStyle(...)`, `fontFamily:`,
va direct `FontWeight.w800/w900` ngoai theme.

## Muc Tieu Hoan Thanh

Target cho plan nay:

| Metric | Current | Target |
| --- | ---: | ---: |
| Direct numeric `fontSize` ngoai theme | 0 | 0 |
| `fontFamily: 'Roboto'` cuc bo | 0 | 0 |
| `FontWeight.w800/w900` trong feature code | 0 | 0 hoac AppTextStyles constants |
| `features/trade` direct `fontSize` | 0 | 0 |
| `features/p2p` direct `fontSize` | 0 | 0 |
| `features/profile` direct `fontSize` | 0 | 0 |
| `features/markets` direct `fontSize` | 0 | 0 |

RU5 strict mode da xoa sach `TextStyle(...)`, `fontSize:`, `fontFamily`, va
direct `FontWeight.w800/w900` ngoai theme. Neu can kich thuoc moi, them token
vao `AppTextStyles` truoc; khong them local typography exception moi.

## Quy Tac Bat Buoc Cho AI

Doc toi thieu truoc moi batch:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. File plan nay
4. Source/test cua batch dang lam

Chi doc them:

- `docs/03_DESIGN_SYSTEM/VitTrade-Typography-Standardization-Plan.md` neu can
  mapping token/exception.
- `docs/02_FLUTTER_MIGRATION/Future-Feature-Onboarding-Checklist.md` neu batch
  cham feature moi hoac checklist.
- `.github/pull_request_template.md` neu batch cham enforcement/checklist.

Khong lam:

- Khong blind replace toan app.
- Khong sua qua 2-5 file moi batch.
- Khong xoa fee/risk/limit/confirm/next-step copy.
- Khong doi business logic, route, provider, key, state machine.
- Khong bien chart/canvas exception thanh body token neu no that su la painter
  label can tranh overlap.
- Khong dung size 8/9 de nhet noi dung.

Bat buoc lam sau moi batch:

1. `dart format <touched dart files>` neu co source Dart.
2. `flutter analyze` neu batch co source code.
3. Focused test cho module/flow neu co.
4. `dart run tool/design_token_consistency_audit.dart --check` neu batch giam
   typography debt hoac cham audit/checklist.
5. Cap nhat `Batch Tracking` trong file nay.

## Autonomous Execution Prompt Cho AI

Dung section nay khi user yeu cau thuc thi file nay. Day la prompt van hanh de
AI tu dong lam tiep den khi dat completion gate, tiet kiem token nhung van giu
chat luong cao.

Nguyen tac tong quat:

- Tiep tuc tu `RESUME FROM` hien tai trong file nay.
- Khong tao plan moi neu user dang yeu cau thuc thi.
- Khong hoi lai neu repo va file plan da du thong tin de tiep tuc.
- Moi vong chi lam 1 batch nho, toi da 2-5 source files dung scope.
- Neu batch pass va van con token/thoi gian, co the tu dong tiep tuc batch ke
  tiep, nhung moi batch phai co verify va tracking rieng.
- Khong nhay phase: RU1 phai uu tien xong truoc RU2, RU3 chi bat dau sau khi
  RU1/RU2 pass, RU4 chi bat dau sau khi direct font/size debt dat target.

Vong lap bat buoc cho moi batch:

1. Doc toi thieu:
   - `AGENTS.md`
   - `docs/00_START_HERE.md`
   - file plan nay
   - source va test cua batch hien tai
2. Xac dinh batch:
   - Lay `RESUME FROM` moi nhat.
   - Neu batch do da co tracking complete, chon batch tiep theo trong cung
     phase.
   - Neu target phase chua dat, khong chuyen sang module phu.
3. Re-scan scope:
   - Chay scan typography lien quan den batch.
   - Ghi nhanh debt before cho file/batch neu se cap nhat tracking.
4. Sua dung scope:
   - Chi sua file trong batch dang lam.
   - Dung `AppTextStyles`, token, va shared primitives thay hardcoded
     typography.
   - Dung `amount*`, `numeric*`, `tabularFigures` cho so lieu tai chinh, fee,
     risk, limit, quantity, percent, P/L, price.
   - Dung `monoCode` hoac monospace chi cho code, hash, address, API key,
     technical id/order id.
   - Giu nguyen nghia copy fee/risk/limit/confirm/preview/masking/next-step.
5. Verify:
   - `dart format <touched dart files>`
   - `flutter analyze`
   - focused tests cua batch
   - neu test trong plan khong ton tai, tim focused test gan nhat cung
     module/flow va ghi ro trong tracking
   - `dart run tool/design_token_consistency_audit.dart --check`
   - neu audit stale, chay `dart run tool/design_token_consistency_audit.dart`
     roi chay lai `--check`
6. Cap nhat file plan:
   - Cap nhat `Current Metrics` neu debt thay doi.
   - Mark batch/phase complete chi khi verify pass.
   - Ghi debt before/after trong `Batch Tracking`.
   - Ghi test thay the neu test trong plan khong ton tai.
   - Ghi allowlist exception neu giu chart/canvas/order-book/code/dev/internal
     typography.
   - Cap nhat `RESUME FROM` sang batch tiep theo hoac completion gate tiep theo.

Dung lai va bao blocker neu:

- `flutter analyze` fail va khong the sua trong scope batch.
- Focused test fail do behavior/logic ngoai scope typography.
- Can sua file ngoai batch de pass.
- Can doi business logic, route, provider, key, state machine.
- Co rui ro financial safety copy bi doi nghia.
- Neu dung do blocker, final response phai ket thuc bang:
  `RESUME FROM: <phase id> - <file hoac checklist item cu the>`.

## Token Mapping Nhanh

Dung source of truth `AppTextStyles`:

| Drift | Thay bang |
| --- | --- |
| `8/9/10` | `micro` hoac `numericMicro`; chart/canvas exception neu painter |
| `11` | `badge` hoac `navLabel` |
| `12` | `captionSm` |
| `13` | `caption` |
| `14` | `body` hoac `control` |
| `15/16` | `body`, `base`, hoac `baseMedium` theo role |
| `17/18` | `amountSm`, `sectionTitleSm`, hoac role tuong ung |
| `19/20` | `sectionTitleSm` |
| `21/22` | `sectionTitle` |
| `24/25/26` | `pageTitle` hoac `sectionTitle` |
| `27/28/29/30` | `pageTitle`, `amountMd`, hoac `heroNumber` theo role |

Dung `AppTextStyles.normal/medium/bold/extraBold/heavy` thay direct
`FontWeight.w*`.

Dung `amount*`, `numeric*`, `tabularFigures` cho:

- balance
- price
- P/L
- percentage
- quantity
- fee
- limit
- risk score
- order-book / trading stats

Dung `monoCode` chi cho:

- address
- hash
- API key
- code
- technical id / order id neu can monospace

## Lenh Scan Bat Dau Moi Session

Chay tu `flutter_app/`:

```powershell
rg -n "fontSize:\s*[0-9]" lib/features/trade
rg -n "fontSize:\s*[0-9]" lib/features/p2p lib/features/profile lib/features/markets
rg -n "copyWith\([^)]*fontSize|fontFamily:|FontWeight\.w[89]00|TextStyle\(" lib/features lib/shared
dart run tool/design_token_consistency_audit.dart --check
```

## Phase RU0 - Rebaseline Truoc Khi Sua

Trang thai: `[x]`

AI phai lam:

1. Chay cac lenh scan o tren.
2. Ghi lai metric hien tai vao `Current Metrics`.
3. Neu audit stale, chay:

```powershell
dart run tool/design_token_consistency_audit.dart
dart run tool/design_token_consistency_audit.dart --check
```

Acceptance RU0:

- `flutter analyze` dang pass hoac blocker duoc ghi ro.
- Audit artifact current.
- Batch tiep theo duoc chon tu phase RU1, khong nhay sang module phu.

## Phase RU1 - Trade Residual Priority Burn-down

Trang thai: `[x]`

Ly do: `features/trade` dang chua thong nhat nhat: direct `fontSize=146`,
`fontFamily=19`, `FontWeight.w800/w900=43`.

Target RU1:

- Trade direct `fontSize` `146 -> <= 70`.
- Trade local `Roboto` ve `0`.
- Trade `FontWeight.w800/w900` giam it nhat 70%, uu tien cac file khong phai
  chart/painter.
- Khong xoa financial safety copy trong futures/margin/copy-trading.

### RU1 Batch 1 - Transaction reporting + leverage confirmation

Files:

1. `flutter_app/lib/features/trade/presentation/widgets/transaction_reporting_stats.dart`
2. `flutter_app/lib/features/trade/presentation/widgets/transaction_reporting_notice.dart`
3. `flutter_app/lib/features/trade/presentation/widgets/transaction_reporting_actions.dart`
4. `flutter_app/lib/features/trade/presentation/widgets/leverage_impact_confirm.dart`
5. `flutter_app/lib/features/trade/presentation/widgets/leverage_header_hero_risk.dart`

AI phai lam:

- Doi labels/stat captions sang `captionSm`, `caption`, `micro`, `badge`.
- Doi amount/percent/risk number sang `amount*`/`numeric*` + tabular figures.
- Doi monospace chi neu la technical id; price/percent khong dung monospace.
- Giu nguyen risk/impact/confirmation copy.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/trade/transaction_reporting_page_test.dart test/features/trade/leverage_impact_page_test.dart
```

Neu test khong ton tai, chay focused test gan nhat trong `test/features/trade`
co ten `transaction`, `leverage`, hoac page route tuong ung.

### RU1 Batch 2 - Futures page parts

Files:

1. `flutter_app/lib/features/trade/presentation/pages/futures_page_part_01.dart`
2. `flutter_app/lib/features/trade/presentation/pages/futures_page_part_02.dart`
3. `flutter_app/lib/features/trade/presentation/pages/futures_page_part_03.dart`
4. `flutter_app/lib/features/trade/presentation/widgets/leverage_controls_presets.dart`
5. `flutter_app/lib/features/trade/presentation/widgets/cass_reconciliation_summary_tabs.dart`

AI phai lam:

- Token hoa futures labels, amount, percent, funding, risk rows.
- Kiem tra moi `fontFamily: 'monospace'`: chi giu cho code/id; con lai dung
  `tabularFigures`.
- Kiem tra futures financial safety copy: fee, risk, liquidation, margin,
  leverage warning khong bi xoa.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/trade/futures_page_test.dart
```

### RU1 Batch 3 - Audit trail + complaint + copy confirmation

Files:

1. `flutter_app/lib/features/trade/presentation/widgets/audit_trail_page_sections.dart`
2. `flutter_app/lib/features/trade/presentation/pages/copy_audit_log_page.dart`
3. `flutter_app/lib/features/trade/presentation/widgets/complaint_submission_page_common.dart`
4. `flutter_app/lib/features/trade/presentation/widgets/copy_confirmation_page_common.dart`
5. `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_validation_common.dart`

AI phai lam:

- Doi timeline/status labels sang `badge`, `captionSm`, `micro`.
- Doi direct `FontWeight.w800` sang `AppTextStyles.extraBold` hoac semantic
  style.
- Giu complaint/legal/copy confirmation text nguyen nghia.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/trade/audit_trail_page_test.dart test/features/trade/copy_audit_log_page_test.dart test/features/trade/complaint_submission_page_test.dart test/features/trade/copy_confirmation_page_test.dart
```

### RU1 Batch 4 - Copy configuration + copy performance weights

Files:

1. `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_provider_capital_mode.dart`
2. `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_risk_summary.dart`
3. `flutter_app/lib/features/trade/presentation/widgets/copy_performance_summary_tabs.dart`
4. `flutter_app/lib/features/trade/presentation/widgets/copy_performance_details.dart`
5. `flutter_app/lib/features/trade/presentation/widgets/copy_performance_common.dart`

AI phai lam:

- Uu tien xoa `FontWeight.w800/w900`.
- So lieu performance dung `numeric*`/`amount*`.
- Risk badges dung `badge`/`captionSm`.
- Khong sua copy ve copy-trading risk, capital allocation, drawdown.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/trade/copy_configuration_page_test.dart test/features/trade/copy_performance_page_test.dart
```

### RU1 Batch 5 - Performance scenarios + ex-post costs + portfolio risk

Files:

1. `flutter_app/lib/features/trade/presentation/widgets/performance_scenarios_intro_widgets.dart`
2. `flutter_app/lib/features/trade/presentation/widgets/performance_scenarios_outcome_widgets.dart`
3. `flutter_app/lib/features/trade/presentation/widgets/ex_post_costs_report_variance_common.dart`
4. `flutter_app/lib/features/trade/presentation/widgets/portfolio_risk_analysis_page_common.dart`
5. `flutter_app/lib/features/trade/presentation/widgets/position_dashboard_page_sections.dart`

AI phai lam:

- Doi outcome/stat typography sang semantic tokens.
- Dung amount/numeric tokens cho variance/portfolio/risk numbers.
- Kiem tra `maxLines`/`overflow` cho card row text dai.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/trade/performance_scenarios_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart test/features/trade/portfolio_risk_analysis_page_test.dart test/features/trade/position_dashboard_page_test.dart
```

### RU1 Batch 6 - Live market + convert + trade settings

Files:

1. `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_ratio.dart`
2. `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_funding.dart`
3. `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_top_traders.dart`
4. `flutter_app/lib/features/trade/presentation/widgets/live_market_pair_card.dart`
5. `flutter_app/lib/features/trade/presentation/widgets/convert_page_widgets.dart`

AI phai lam:

- Doi live market numbers sang `numericMicro`, `numericCode`, `amount*`.
- Loai `fontFamily` cho price/percent neu tabular figures du.
- Convert page code/id moi duoc giu monospace.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/trade/live_market_data_analytics_page_test.dart test/features/trade/convert_page_test.dart
```

### RU1 Batch 7 - Remaining high-score trade files

Files:

1. `flutter_app/lib/features/trade/presentation/pages/target_market_definition_page.dart`
2. `flutter_app/lib/features/trade/presentation/pages/pre_copy_assessment_page.dart`
3. `flutter_app/lib/features/trade/presentation/pages/provider_comparison_page.dart`
4. `flutter_app/lib/features/trade/presentation/widgets/trade_settings_page_sections.dart`
5. `flutter_app/lib/features/trade/presentation/widgets/execution_quality_sheets.dart`

AI phai lam:

- Token hoa title/section/helper text theo role.
- Doi direct heavy weights sang `AppTextStyles`.
- Kiem tra neu file co financial suitability/assessment copy thi giu nguyen.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/trade/pre_copy_assessment_page_test.dart test/features/trade/provider_comparison_page_test.dart test/features/trade/trade_settings_page_test.dart test/features/trade/execution_quality_page_test.dart
```

### RU1 Exception Review

Sau moi 2-3 batch, chay:

```powershell
rg -n "fontSize:\s*[0-9]|fontFamily:|FontWeight\.w[89]00" lib/features/trade
```

Neu con lai la painter/chart/order-book labels:

- Ghi vao allowlist trong file nay.
- Ghi ly do: chart/canvas/order-book density, label overlap, hoac code/id.
- Khong mark RU1 xong neu con UI text thong thuong co direct `fontSize`.

## Phase RU2 - P2P/Profile/Markets Cleanup

Trang thai: `[x]`

Target RU2:

- `p2p` direct `fontSize` `13 -> <= 5`.
- `profile` direct `fontSize` `5 -> 0`.
- `profile` direct `FontWeight.w800/w900` `34 -> <= 10`.
- `markets` direct `fontSize=3` chi con documented chart/canvas exceptions.

### RU2 Batch 1 - Profile VIP/API/security weights

Files:

1. `flutter_app/lib/features/profile/presentation/widgets/profile_vip_overview.dart`
2. `flutter_app/lib/features/profile/presentation/widgets/api_management_key_controls.dart`
3. `flutter_app/lib/features/profile/presentation/widgets/profile_api_key_create_result.dart`
4. `flutter_app/lib/features/profile/presentation/pages/api_management_page.dart`
5. `flutter_app/lib/features/profile/presentation/widgets/vip_history_widgets.dart`

AI phai lam:

- Doi direct `fontSize` sang `sectionTitleSm`, `captionSm`, `badge`, hoac
  `numeric*`.
- Doi `FontWeight.w800/w900` sang semantic tokens/constants.
- Giu API key/security copy va masking logic.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/profile/api_management_page_test.dart test/features/profile/vip_page_test.dart
```

### RU2 Batch 2 - P2P remaining compact labels

Files:

1. `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart`
2. `flutter_app/lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart`
3. `flutter_app/lib/features/p2p/presentation/widgets/p2p_my_ads_stats_cards.dart`
4. `flutter_app/lib/features/p2p/presentation/widgets/p2p_transaction_limits_page_common.dart`
5. `flutter_app/lib/features/p2p/presentation/widgets/p2p_limit_tracker_page_common.dart`

AI phai lam:

- Doi compact labels sang `captionSm`, `badge`, `numericMicro`.
- P2P payment/limit/AML/dispute copy khong bi xoa hoac doi nghia.
- Monospace chi cho ID/code neu that su can.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/p2p/p2p_create_ad_page_test.dart test/features/p2p/p2p_e2e_info_page_test.dart test/features/p2p/p2p_my_ads_page_test.dart test/features/p2p/p2p_transaction_limits_page_test.dart test/features/p2p/p2p_limit_tracker_page_test.dart
```

### RU2 Batch 3 - Markets exception review

Files:

1. `flutter_app/lib/features/markets/presentation/widgets/market_correlations_matrix_widgets.dart`
2. `flutter_app/lib/features/markets/presentation/pages/portfolio_tracker_page_part_03.dart`
3. `flutter_app/lib/features/markets/presentation/widgets/pair_detail_order_widgets.dart`
4. `flutter_app/lib/features/markets/presentation/pages/advanced_charts_page_part_02.dart`

AI phai lam:

- Confirm `fontSize: 8/9` chi nam trong painter/chart labels.
- Doi pair/order UI text sang numeric tokens neu khong phai chart/canvas.
- Ghi exception ro trong allowlist neu giu.

Verify:

```powershell
dart format <changed files only>
flutter analyze
flutter test --reporter=compact test/features/markets/market_correlations_page_test.dart test/features/markets/portfolio_tracker_page_test.dart test/features/markets/pair_detail_page_test.dart test/features/markets/advanced_charts_page_test.dart
```

## Phase RU3 - Secondary Module CopyWith/FontFamily Cleanup

Trang thai: `[x]`

Chi bat dau RU3 sau khi RU1/RU2 pass.

Target RU3:

- `fontFamily: 'Roboto'` ve `0`.
- Secondary modules khong con `fontFamily` cuc bo tru code/hash/dev/internal.
- `copyWith(fontSize)` trong Launchpad/Earn/Admin/DCA giam ro rang hoac co
  exception documented.

### RU3 Batch 1 - Launchpad webhooks/gas tracker

Files:

1. `flutter_app/lib/features/launchpad/presentation/pages/launchpad_webhooks_page_part_02.dart`
2. `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_webhooks_form_controls.dart`
3. `flutter_app/lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_01.dart`
4. `flutter_app/lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_02.dart`
5. `flutter_app/lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_03.dart`

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/launchpad/launchpad_webhooks_page_test.dart test/features/launchpad/launchpad_gas_tracker_page_test.dart
```

### RU3 Batch 2 - Launchpad multisig/rebalance/swap/limit

Files:

1. `flutter_app/lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_01.dart`
2. `flutter_app/lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_02.dart`
3. `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_rebalance_summary.dart`
4. `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_swap_aggregator_input.dart`
5. `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_active_widgets.dart`

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/launchpad
```

### RU3 Batch 3 - Earn/Admin/DCA low-risk typography

Files:

1. `flutter_app/lib/features/earn/presentation/widgets/staking_earn_hero_tabs.dart`
2. `flutter_app/lib/features/admin/presentation/widgets/ab_test_dashboard_common.dart`
3. `flutter_app/lib/features/admin/presentation/widgets/ab_test_dashboard_sections.dart`
4. `flutter_app/lib/features/admin/presentation/widgets/analytics_dashboard_sections.dart`
5. `flutter_app/lib/features/dca/presentation/widgets/dca_smart_rules_info_common.dart`

AI phai lam:

- Admin/dev dashboards co the co internal/code exceptions, nhung phai ghi ly do.
- DCA/earn financial numbers dung numeric/amount tokens.

Verify:

```powershell
dart format <5 files>
flutter analyze
flutter test --reporter=compact test/features/earn test/features/admin test/features/dca
```

## Phase RU4 - TextStyle Color-only Review

Trang thai: `[x]`

Chi lam RU4 sau khi direct font/size debt da dat target. Muc tieu la giam local
`TextStyle(...)` neu no la typography drift that su, khong phai `TextSpan`
color-only hop le.

Priority files:

1. `flutter_app/lib/features/auth/presentation/widgets/otp_identity_intro.dart`
2. `flutter_app/lib/features/auth/presentation/widgets/two_fa_setup_qr.dart`
3. `flutter_app/lib/features/auth/presentation/pages/login_page.dart`
4. `flutter_app/lib/features/predictions/presentation/widgets/prediction_portfolio_summary.dart`
5. `flutter_app/lib/features/predictions/presentation/widgets/predictions_rewards_hero_filters.dart`
6. `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_common.dart`
7. `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_preview.dart`

AI phai lam:

- Neu `TextStyle` chi la `TextSpan` color-only va khong co `fontSize`,
  `fontFamily`, `height`, weight drift, co the de lai.
- Neu co `fontSize`, `fontFamily`, weight drift, token hoa.
- Ghi ro "kept color-only TextSpan" neu de lai.

Verify:

```powershell
dart format <changed files only>
flutter analyze
flutter test --reporter=compact test/features/auth test/features/predictions test/features/wallet
```

## Completion Gate Cho Plan Nay

Trang thai: `[x]`

Plan nay duoc coi la xong khi:

1. `dart run tool/design_token_consistency_audit.dart --check` pass.
2. `flutter analyze` pass.
3. Focused tests cua moi batch pass hoac missing test duoc ghi ro.
4. Direct numeric `fontSize` ngoai theme <= 80.
5. `fontFamily: 'Roboto'` cuc bo = 0.
6. Direct `FontWeight.w800/w900` trong feature UI = 0 hoac da thay bang
   `AppTextStyles.extraBold/heavy`.
7. Moi chart/canvas/code/dev/internal exception co ly do trong allowlist.
8. Financial safety copy khong bi xoa: fee, risk, limit, confirm, preview,
   masking, next step.

## Allowlist Exceptions

Ghi tai day khi giu lai local typography:

| File | Pattern | Ly do | Approved |
| --- | --- | --- | --- |
| _None active for typography strict mode_ | - | RU5 Batch 3 retired prior chart/canvas font-size allowlist by moving painter labels to `AppTextStyles.chartLabelTiny/chartLabelXs`. | 2026-06-13 |

## RU5 - Strict Typography Zero Residual

Trang thai: `[x]`

Muc tieu strict source-level:

1. `fontSize:\s*[0-9]` ngoai `lib/app/theme/**` = 0.
2. `copyWith(...fontSize...)` ngoai `lib/app/theme/**` = 0.
3. `TextStyle(...)` ngoai `lib/app/theme/**` = 0.
4. `fontFamily:` ngoai `lib/app/theme/**` = 0.
5. `FontWeight.w800/w900` trong `lib/features` va `lib/shared` = 0.
6. Audit tool co strict typography gate de ngan drift quay lai.
7. Chart/canvas typography allowlist cu duoc retire sau khi painter labels dung
   `AppTextStyles.chartLabelNano` / `chartLabelTiny` / `chartLabelXs`.

Batch order:

1. `[x]` Batch 0 - theme typography tokens.
2. `[x]` Batch 1 - P2P residual direct font sizes/painter style.
3. `[x]` Batch 2 - P2P local `TextStyle(...)` con lai.
4. `[x]` Batch 3 - Markets/chart typography.
5. `[x]` Batch 4 - Trade margin/live typography.
6. `[x]` Batch 5 - Trade live/export/settings/reporting typography.
7. `[x]` Batch 6 - Trade copy/execution/RIY/governance typography.
8. `[x]` Batch 7 - cross-module local `TextStyle(...)`.
9. `[x]` Batch 8 - strict audit gate/docs completion.
   - `[x]` Batch 8A - Launchpad robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8B - Admin/cross-module robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8C - Cross tax + DCA robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8D - DCA remaining + Dev robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8E - Dev residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8F - Route checker + Earn residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8G - Earn portfolio/analytics/auto-compound residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8H - Earn residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8I - Earn residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8J - Earn final residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8K - Launchpad residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8L - Launchpad residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8M - Launchpad residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8N - Launchpad final residual robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8O - Final Markets/Trade robust `copyWith(fontSize)` burn-down.
   - `[x]` Batch 8 final - regenerate artifacts/docs and mark strict completion.

## Batch Tracking

Dung mau nay sau moi batch:

```text
- YYYY-MM-DD: Hoan thanh <phase/batch>.
  - Files: `<file1>`, `<file2>`.
  - Debt giam: `<metric before> -> <metric after>`.
  - Verify:
    - `dart format ...`
    - `flutter analyze` (pass)
    - `flutter test ...` (pass hoac missing test noted)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: <financial safety copy / exception / visual risk>.
```

- 2026-06-13: Hoan thanh RU0 - rebaseline current typography drift scan.
  - Files: `docs/03_DESIGN_SYSTEM/VitTrade-Typography-Residual-Unification-Execution-Plan.md`.
  - Debt giam: baseline only; no source debt change before RU1 Batch 1.
  - Verify:
    - `rg -n "fontSize:\s*[0-9]" lib/features/trade` (pass; baseline `146`)
    - `rg -n "fontSize:\s*[0-9]" lib/features/p2p lib/features/profile lib/features/markets` (pass; baseline `21`)
    - `rg -n "copyWith\([^)]*fontSize|fontFamily:|FontWeight\.w[89]00|TextStyle\(" lib/features lib/shared` (pass)
    - `flutter analyze` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: RU0 baseline matched plan: direct numeric `fontSize` ngoai theme `167`, trade `fontSize/fontFamily/w800w900` `146/19/43`; next batch selected RU1 Batch 1.
- 2026-06-13: Hoan thanh RU1 Batch 1 - transaction reporting + leverage confirmation.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/transaction_reporting_stats.dart`, `flutter_app/lib/features/trade/presentation/widgets/transaction_reporting_notice.dart`, `flutter_app/lib/features/trade/presentation/widgets/transaction_reporting_actions.dart`, `flutter_app/lib/features/trade/presentation/widgets/leverage_impact_confirm.dart`, `flutter_app/lib/features/trade/presentation/widgets/leverage_header_hero_risk.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `23/2/1 -> 0/0/0`; direct numeric `fontSize` ngoai theme `167 -> 144`; trade `fontSize/fontFamily/w800w900` `146/19/43 -> 123/17/42`; audit `typography_trade_debt 325 -> 285`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/transaction_reporting_stats.dart lib/features/trade/presentation/widgets/transaction_reporting_notice.dart lib/features/trade/presentation/widgets/transaction_reporting_actions.dart lib/features/trade/presentation/widgets/leverage_impact_confirm.dart lib/features/trade/presentation/widgets/leverage_header_hero_risk.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/transaction_reporting_page_test.dart test/features/trade/leverage_page_test.dart` (pass; `test/features/trade/leverage_impact_page_test.dart` khong ton tai, dung focused test gan nhat)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen risk/impact/confirmation/compliance copy; khong them allowlist exception; leverage, fee, percent, va report stats dung token numeric/tabular thay local monospace.
- 2026-06-13: Hoan thanh RU1 Batch 2 - futures page parts.
  - Files: `flutter_app/lib/features/trade/presentation/pages/futures_page_part_01.dart`, `flutter_app/lib/features/trade/presentation/pages/futures_page_part_02.dart`, `flutter_app/lib/features/trade/presentation/pages/futures_page_part_03.dart`, `flutter_app/lib/features/trade/presentation/widgets/leverage_controls_presets.dart`, `flutter_app/lib/features/trade/presentation/widgets/cass_reconciliation_summary_tabs.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `20/6/0 -> 0/0/0`; direct numeric `fontSize` ngoai theme `144 -> 124`; trade `fontSize/fontFamily/w800w900` `123/17/42 -> 103/11/42`; audit `typography_trade_debt 285 -> 251`.
  - Verify:
    - `dart format lib/features/trade/presentation/pages/futures_page_part_01.dart lib/features/trade/presentation/pages/futures_page_part_02.dart lib/features/trade/presentation/pages/futures_page_part_03.dart lib/features/trade/presentation/widgets/leverage_controls_presets.dart lib/features/trade/presentation/widgets/cass_reconciliation_summary_tabs.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/futures_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen futures fee/risk/liquidation/margin/leverage warning copy; khong them allowlist exception; financial numbers dung numeric/amount/tabular thay local monospace.
- 2026-06-13: Hoan thanh RU1 Batch 3 - audit trail + complaint + copy confirmation.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/audit_trail_page_sections.dart`, `flutter_app/lib/features/trade/presentation/pages/copy_audit_log_page.dart`, `flutter_app/lib/features/trade/presentation/widgets/complaint_submission_page_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_confirmation_page_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_validation_common.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `14/0/3 -> 0/0/0`; direct numeric `fontSize` ngoai theme `124 -> 110`; trade `fontSize/fontFamily/w800w900` `103/11/42 -> 89/11/39`; audit `typography_trade_debt 251 -> 219`.
  - Verify:
    - `rg -n "fontSize:\s*[0-9]|fontFamily:|FontWeight\.w[89]00" lib/features/trade` (exception review run; remaining items are scheduled later RU1 batches, so no allowlist added)
    - `dart format lib/features/trade/presentation/widgets/audit_trail_page_sections.dart lib/features/trade/presentation/pages/copy_audit_log_page.dart lib/features/trade/presentation/widgets/complaint_submission_page_common.dart lib/features/trade/presentation/widgets/copy_confirmation_page_common.dart lib/features/trade/presentation/widgets/copy_configuration_validation_common.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/audit_trail_page_test.dart test/features/trade/copy_audit_log_page_test.dart test/features/trade/complaint_submission_page_test.dart test/features/trade/copy_confirmation_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen complaint/legal/copy confirmation next-step copy; khong them allowlist exception.
- 2026-06-13: Hoan thanh RU1 Batch 4 - copy configuration + copy performance weights.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_provider_capital_mode.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_configuration_risk_summary.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_performance_summary_tabs.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_performance_details.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_performance_common.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `2/0/18 -> 0/0/0`; direct numeric `fontSize` ngoai theme `110 -> 108`; trade `fontSize/fontFamily/w800w900` `89/11/39 -> 87/11/21`; audit `typography_trade_debt 219 -> 179`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/copy_configuration_provider_capital_mode.dart lib/features/trade/presentation/widgets/copy_configuration_risk_summary.dart lib/features/trade/presentation/widgets/copy_performance_summary_tabs.dart lib/features/trade/presentation/widgets/copy_performance_details.dart lib/features/trade/presentation/widgets/copy_performance_common.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/copy_configuration_page_test.dart test/features/trade/copy_performance_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen copy-trading risk, capital allocation, drawdown va performance explanation copy; khong them allowlist exception.
- 2026-06-13: Hoan thanh RU1 Batch 5 - performance scenarios + ex-post costs + portfolio risk.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/performance_scenarios_intro_widgets.dart`, `flutter_app/lib/features/trade/presentation/widgets/performance_scenarios_outcome_widgets.dart`, `flutter_app/lib/features/trade/presentation/widgets/ex_post_costs_report_variance_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/portfolio_risk_analysis_page_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/position_dashboard_page_sections.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `22/1/0 -> 0/0/0`; direct numeric `fontSize` ngoai theme `108 -> 86`; trade `fontSize/fontFamily/w800w900` `87/11/21 -> 65/10/21`; audit `typography_trade_debt 179 -> 133`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/performance_scenarios_intro_widgets.dart lib/features/trade/presentation/widgets/performance_scenarios_outcome_widgets.dart lib/features/trade/presentation/widgets/ex_post_costs_report_variance_common.dart lib/features/trade/presentation/widgets/portfolio_risk_analysis_page_common.dart lib/features/trade/presentation/widgets/position_dashboard_page_sections.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/performance_scenarios_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart test/features/trade/portfolio_risk_analysis_page_test.dart test/features/trade/position_dashboard_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen scenario, variance, VaR/stress impact, va position P/L copy; khong them allowlist exception; long row text co `maxLines`/`overflow` guard.
- 2026-06-13: Hoan thanh RU1 Batch 6 - live market + convert + trade settings.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_ratio.dart`, `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_funding.dart`, `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_top_traders.dart`, `flutter_app/lib/features/trade/presentation/widgets/live_market_pair_card.dart`, `flutter_app/lib/features/trade/presentation/widgets/convert_page_widgets.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `12/6/0 -> 0/0/0`; direct numeric `fontSize` ngoai theme `86 -> 74`; trade `fontSize/fontFamily/w800w900` `65/10/21 -> 53/4/21`; audit `typography_trade_debt 133 -> 115`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/live_market_interest_ratio.dart lib/features/trade/presentation/widgets/live_market_interest_funding.dart lib/features/trade/presentation/widgets/live_market_interest_top_traders.dart lib/features/trade/presentation/widgets/live_market_pair_card.dart lib/features/trade/presentation/widgets/convert_page_widgets.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/live_market_data_analytics_page_test.dart test/features/trade/convert_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen live-market va convert copy; khong them allowlist exception; price, percent, timer, balance, va fee text dung token numeric/amount/tabular thay local monospace.
- 2026-06-13: Hoan thanh RU1 Batch 7 - remaining high-score trade files.
  - Files: `flutter_app/lib/features/trade/presentation/pages/target_market_definition_page.dart`, `flutter_app/lib/features/trade/presentation/pages/pre_copy_assessment_page.dart`, `flutter_app/lib/features/trade/presentation/pages/provider_comparison_page.dart`, `flutter_app/lib/features/trade/presentation/widgets/trade_settings_page_sections.dart`, `flutter_app/lib/features/trade/presentation/widgets/execution_quality_sheets.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `16/3/8 -> 0/0/0`; direct numeric `fontSize` ngoai theme `74 -> 58`; trade `fontSize/fontFamily/w800w900` `53/4/21 -> 37/1/13`; audit `typography_trade_debt 115 -> 85`.
  - Verify:
    - `dart format lib/features/trade/presentation/pages/target_market_definition_page.dart lib/features/trade/presentation/pages/pre_copy_assessment_page.dart lib/features/trade/presentation/pages/provider_comparison_page.dart lib/features/trade/presentation/widgets/trade_settings_page_sections.dart lib/features/trade/presentation/widgets/execution_quality_sheets.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/target_market_definition_page_test.dart test/features/trade/pre_copy_assessment_page_test.dart test/features/trade/provider_comparison_page_test.dart test/features/trade/trade_settings_page_test.dart test/features/trade/execution_quality_demo_page_test.dart` (pass; `test/features/trade/execution_quality_page_test.dart` khong ton tai, dung focused test gan nhat; them `target_market_definition_page_test.dart` vi batch co page tuong ung)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen target-market governance, MiFID suitability, provider comparison risk/fee/performance, order confirmation, va execution quality copy; `Order ID` dung `AppTextStyles.monoCode`, khong giu local `fontFamily` exception.
- 2026-06-13: Hoan thanh RU2 Batch 1 - profile VIP/API/security weights.
  - Files: `flutter_app/lib/features/profile/presentation/widgets/profile_vip_overview.dart`, `flutter_app/lib/features/profile/presentation/widgets/api_management_key_controls.dart`, `flutter_app/lib/features/profile/presentation/widgets/profile_api_key_create_result.dart`, `flutter_app/lib/features/profile/presentation/pages/api_management_page.dart`, `flutter_app/lib/features/profile/presentation/widgets/vip_history_widgets.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `4/0/12 -> 0/0/0`; direct numeric `fontSize` ngoai theme `58 -> 54`; profile `fontSize/fontFamily/w800w900` `5/0/34 -> 1/0/22`; audit `typography_profile_debt 73 -> 44`.
  - Verify:
    - `dart format lib/features/profile/presentation/widgets/profile_vip_overview.dart lib/features/profile/presentation/widgets/api_management_key_controls.dart lib/features/profile/presentation/widgets/profile_api_key_create_result.dart lib/features/profile/presentation/pages/api_management_page.dart lib/features/profile/presentation/widgets/vip_history_widgets.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/profile/api_management_page_test.dart test/features/profile/vip_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen API key/security copy va masking/reveal/copy/delete logic; profile residual ngoai batch con `1` direct `fontSize` va `22` direct `w800/w900`, tiep tuc theo RU2 tracking.
- 2026-06-13: Hoan thanh RU2 Batch 2 - P2P remaining compact labels.
  - Files: `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart`, `flutter_app/lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_my_ads_stats_cards.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_transaction_limits_page_common.dart`, `flutter_app/lib/features/p2p/presentation/pages/p2p_limit_tracker_page.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `4/3/0 -> 0/0/0`; direct numeric `fontSize` ngoai theme `54 -> 50`; p2p `fontSize/fontFamily/w800w900` `13/3/0 -> 9/0/0`; audit `typography_p2p_debt 25 -> 15`.
  - Verify:
    - `dart format lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart lib/features/p2p/presentation/pages/p2p_e2e_info_page.dart lib/features/p2p/presentation/widgets/p2p_my_ads_stats_cards.dart` (pass; formatted changed files only)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/p2p/p2p_create_ad_page_test.dart test/features/p2p/p2p_e2e_info_page_test.dart test/features/p2p/p2p_my_ads_page_test.dart test/features/p2p/p2p_transaction_limits_page_test.dart test/features/p2p/p2p_limit_tracker_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen P2P payment/limit/E2E/security copy; `p2p_limit_tracker_page_common.dart` khong ton tai, dung source gan nhat `p2p_limit_tracker_page.dart`; `p2p_transaction_limits_page_common.dart` va replacement tracker da scan clean nen khong sua.
- 2026-06-13: Hoan thanh RU2 Batch 3 - markets exception review.
  - Files: `flutter_app/lib/features/markets/presentation/widgets/market_correlations_matrix_widgets.dart`, `flutter_app/lib/features/markets/presentation/pages/portfolio_tracker_page_part_03.dart`, `flutter_app/lib/features/markets/presentation/widgets/pair_detail_order_widgets.dart`, `flutter_app/lib/features/markets/presentation/pages/advanced_charts_page_part_02.dart`.
  - Debt giam: markets `fontSize/fontFamily/w800w900` `3/2/0 -> 3/0/0`; UI local `fontFamily` trong pair order/trades `2 -> 0`; audit `typography_markets_debt 9 -> 5`.
  - Verify:
    - `dart format lib/features/markets/presentation/widgets/pair_detail_order_widgets.dart` (pass; changed file only)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/market_correlations_page_test.dart test/features/markets/portfolio_tracker_page_test.dart test/features/markets/pair_detail_page_test.dart test/features/markets/advanced_charts_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu chart/canvas labels trong `market_correlations_matrix_widgets.dart` va `portfolio_tracker_page_part_03.dart` theo allowlist approved RU2; pair order price/trade values dung tabular figures thay local monospace; `advanced_charts_page_part_02.dart` scan clean nen khong sua.
- 2026-06-13: Hoan thanh RU2 residual - profile target gap.
  - Files: `flutter_app/lib/features/profile/presentation/widgets/profile_vip_benefits.dart`, `flutter_app/lib/features/profile/presentation/widgets/device_management_page_sections.dart`, `flutter_app/lib/features/profile/presentation/widgets/device_management_page_common.dart`, `flutter_app/lib/features/profile/presentation/widgets/profile_vip_hero.dart`, `flutter_app/lib/features/profile/presentation/pages/edit_profile_page.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `1/0/16 -> 0/0/0`; direct numeric `fontSize` ngoai theme `50 -> 49`; profile `fontSize/fontFamily/w800w900` `1/0/22 -> 0/0/6`; audit `typography_profile_debt 44 -> 12`.
  - Verify:
    - `dart format lib/features/profile/presentation/widgets/profile_vip_benefits.dart lib/features/profile/presentation/widgets/device_management_page_sections.dart lib/features/profile/presentation/widgets/device_management_page_common.dart lib/features/profile/presentation/widgets/profile_vip_hero.dart lib/features/profile/presentation/pages/edit_profile_page.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/profile/vip_page_test.dart test/features/profile/device_management_page_test.dart test/features/profile/edit_profile_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen VIP benefits, device security, logout/trust, va edit-profile safety copy; profile RU2 target dat `fontSize=0`, `w800/w900=6`.
- 2026-06-13: Hoan thanh RU2 residual - P2P direct fontSize gap.
  - Files: `flutter_app/lib/features/p2p/presentation/widgets/p2p_wallet_hero.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_wallet_actions_history.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_wallet_transfer_form.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_wallet_transfer_amount.dart`, `flutter_app/lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart`.
  - Debt giam: batch local direct `fontSize/fontFamily/w800w900` `5/0/0 -> 0/0/0`; direct numeric `fontSize` ngoai theme `49 -> 44`; p2p `fontSize/fontFamily/w800w900` `9/0/0 -> 4/0/0`; audit `typography_p2p_debt 15 -> 6`.
  - Verify:
    - `dart format lib/features/p2p/presentation/widgets/p2p_wallet_hero.dart lib/features/p2p/presentation/widgets/p2p_wallet_actions_history.dart lib/features/p2p/presentation/widgets/p2p_wallet_transfer_form.dart lib/features/p2p/presentation/widgets/p2p_wallet_transfer_amount.dart lib/features/p2p/presentation/pages/p2p_compliance_overview_page.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/p2p/p2p_wallet_page_test.dart test/features/p2p/p2p_wallet_transfer_page_test.dart test/features/p2p/p2p_compliance_overview_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen P2P wallet transfer, fee, escrow, payment, limit, AML/compliance copy; RU2 target dat `p2p fontSize=4`, `profile fontSize=0`, `profile w800/w900=6`, markets exceptions documented.
- 2026-06-13: Hoan thanh RU3 Batch 1 - Launchpad webhooks/gas tracker.
  - Files: `flutter_app/lib/features/launchpad/presentation/pages/launchpad_webhooks_page_part_02.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_webhooks_form_controls.dart`, `flutter_app/lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_01.dart`, `flutter_app/lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_02.dart`, `flutter_app/lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_03.dart`.
  - Debt giam: batch local `fontSize/fontFamily/w800w900` `32/6/0 -> 0/0/0`; `fontSize:` ngoai theme `236 -> 204`; `fontFamily:` ngoai theme `16 -> 10`; `fontFamily: 'monospace'` `13 -> 9`; audit `typography_launchpad_debt -> 0`.
  - Verify:
    - `dart format lib/features/launchpad/presentation/pages/launchpad_webhooks_page_part_02.dart lib/features/launchpad/presentation/widgets/launchpad_webhooks_form_controls.dart lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_01.dart lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_02.dart lib/features/launchpad/presentation/pages/launchpad_gas_tracker_page_part_03.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/launchpad/launchpad_webhooks_page_test.dart test/features/launchpad/launchpad_gas_tracker_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen webhook delivery/copy/delete va gas alert/estimator copy; URL/contract/tx hash dung `AppTextStyles.monoCode`, status/gas/fee/percent values dung numeric/tabular tokens; khong them allowlist exception.
- 2026-06-13: Hoan thanh RU3 Batch 2 - Launchpad multisig/rebalance/swap/limit.
  - Files: `flutter_app/lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_01.dart`, `flutter_app/lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_02.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_rebalance_summary.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_swap_aggregator_input.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_active_widgets.dart`.
  - Debt giam: batch local `fontSize/fontFamily/w800w900` `19/0/0 -> 0/0/0`; `fontSize:` ngoai theme `204 -> 185`; audit `typography_launchpad_debt` giu `0`.
  - Verify:
    - `dart format lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_01.dart lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_02.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_summary.dart lib/features/launchpad/presentation/widgets/launchpad_swap_aggregator_input.dart lib/features/launchpad/presentation/widgets/launchpad_limit_orders_active_widgets.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/launchpad` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Giu nguyen multisig sign/execute, limit-order expiry/distance, swap amount, va rebalance risk warning copy; threshold/nonce/swap amount/fee values dung numeric/amount/tabular tokens; khong them allowlist exception.
- 2026-06-13: Hoan thanh RU3 Batch 3 - Earn/Admin/DCA low-risk typography.
  - Files: `flutter_app/lib/features/earn/presentation/widgets/staking_earn_hero_tabs.dart`, `flutter_app/lib/features/admin/presentation/widgets/ab_test_dashboard_common.dart`, `flutter_app/lib/features/admin/presentation/widgets/ab_test_dashboard_sections.dart`, `flutter_app/lib/features/admin/presentation/widgets/analytics_dashboard_sections.dart`, `flutter_app/lib/features/dca/presentation/widgets/dca_smart_rules_info_common.dart`.
  - Debt giam: batch local `fontSize/fontFamily/w800w900` `11/5/0 -> 0/0/0`; `fontSize:` ngoai theme `185 -> 174`; `fontFamily:` ngoai theme `10 -> 5`; audit `typography_earn_debt 0`, `typography_dca_debt 2 -> 0`, `typography_admin_debt 7 -> 3`.
  - Verify:
    - `dart format lib/features/earn/presentation/widgets/staking_earn_hero_tabs.dart lib/features/admin/presentation/widgets/ab_test_dashboard_common.dart lib/features/admin/presentation/widgets/ab_test_dashboard_sections.dart lib/features/admin/presentation/widgets/analytics_dashboard_sections.dart lib/features/dca/presentation/widgets/dca_smart_rules_info_common.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/earn test/features/admin test/features/dca` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen earn staking, A/B analytics, admin dashboard, va DCA smart-rule copy; DCA rule condition/action dung `AppTextStyles.monoCode` thay local monospace; khong them allowlist exception.
- 2026-06-13: Hoan thanh RU3 residual - Admin remaining fontFamily/TextStyle cleanup.
  - Files: `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_waterfall_details.dart`, `flutter_app/lib/features/admin/presentation/widgets/admin_home_dashboards_footer.dart`.
  - Debt giam: residual local `fontSize/fontFamily/TextStyle` `2/3/1 -> 0/0/0`; `fontSize:` ngoai theme `174 -> 172`; `fontFamily:` ngoai theme `5 -> 2`; `TextStyle(...)` ngoai theme `58 -> 57`; audit `typography_admin_debt 3 -> 0`.
  - Verify:
    - `dart format lib/features/admin/presentation/widgets/funnel_dashboard_waterfall_details.dart lib/features/admin/presentation/widgets/admin_home_dashboards_footer.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/admin` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen admin funnel/dashboard copy va route behavior; numeric admin stats dung `AppTextStyles.numericCode`; khong them allowlist exception. RU3 target dat: `typography_launchpad/earn/admin/dca = 0`, local `Roboto = 0`; con local `fontFamily` ngoai RU3 nam o wallet address/code va trade export summary de xu ly/document trong phase sau.
- 2026-06-13: Hoan thanh RU4 Batch 1 - Auth/Predictions TextStyle review.
  - Files: `flutter_app/lib/features/auth/presentation/widgets/otp_identity_intro.dart`, `flutter_app/lib/features/auth/presentation/widgets/two_fa_setup_qr.dart`, `flutter_app/lib/features/auth/presentation/pages/login_page.dart`, `flutter_app/lib/features/predictions/presentation/widgets/prediction_portfolio_summary.dart`, `flutter_app/lib/features/predictions/presentation/widgets/predictions_rewards_hero_filters.dart`.
  - Debt giam: batch local `TextStyle/fontSize/fontFamily/w800w900` `14/0/0/0 -> 0/0/0/0`; `TextStyle(...)` ngoai theme `57 -> 43`; direct numeric `fontSize` ngoai theme giu `44`.
  - Verify:
    - `dart format lib/features/auth/presentation/widgets/otp_identity_intro.dart lib/features/auth/presentation/widgets/two_fa_setup_qr.dart lib/features/auth/presentation/pages/login_page.dart lib/features/predictions/presentation/widgets/prediction_portfolio_summary.dart lib/features/predictions/presentation/widgets/predictions_rewards_hero_filters.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/auth test/features/predictions` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Giu nguyen login/OTP/2FA legal and demo copy, prediction shares/P/L education copy, and rewards mechanics copy; weight/color-only `TextSpan` styles duoc token hoa bang `AppTextStyles`, khong can allowlist.
- 2026-06-13: Hoan thanh RU4 Batch 2 - Wallet address TextStyle/fontFamily review.
  - Files: `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_common.dart`, `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_add_preview.dart`.
  - Debt giam: batch local `TextStyle/fontFamily/w800w900` `2/1/0 -> 0/0/0`; `TextStyle(...)` ngoai theme `43 -> 41`; `fontFamily:` ngoai theme `2 -> 1`; audit `typography_wallet_debt 1 -> 0`.
  - Verify:
    - `dart format lib/features/wallet/presentation/widgets/wallet_address_add_common.dart lib/features/wallet/presentation/widgets/wallet_address_add_preview.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/wallet` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen address preview/confirm/whitelist safety copy; address preview value dung `AppTextStyles.monoCode` thay local `Roboto Mono`; khong them allowlist exception. RU4 priority list complete; completion gate con fail o direct `FontWeight.w800/w900` feature residual.
- 2026-06-13: Hoan thanh Completion Gate Batch 1 - Profile direct weight residual.
  - Files: `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_primitives.dart`, `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_create.dart`, `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_cards.dart`, `flutter_app/lib/features/profile/presentation/widgets/api_management_keys.dart`, `flutter_app/lib/features/profile/presentation/widgets/api_management_docs.dart`.
  - Debt giam: profile direct `FontWeight.w800/w900` `6 -> 0`; feature direct `FontWeight.w800/w900` `19 -> 13`; audit `typography_profile_debt 12 -> 0`.
  - Verify:
    - `dart format lib/features/profile/presentation/widgets/profile_sub_account_primitives.dart lib/features/profile/presentation/widgets/profile_sub_account_create.dart lib/features/profile/presentation/widgets/profile_sub_account_cards.dart lib/features/profile/presentation/widgets/api_management_keys.dart lib/features/profile/presentation/widgets/api_management_docs.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/profile/sub_account_page_test.dart test/features/profile/api_management_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen sub-account balance masking/create form va API documentation/key copy; direct weights replaced with `AppTextStyles.extraBold/heavy`.
- 2026-06-13: Hoan thanh Completion Gate Batch 2 - Trade direct weight residual group 1.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/copy_trading_v2_variant_hero.dart`, `flutter_app/lib/features/trade/presentation/widgets/performance_attribution_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/provider_application_progress_intro.dart`, `flutter_app/lib/features/trade/presentation/widgets/performance_attribution_tabs.dart`, `flutter_app/lib/features/trade/presentation/widgets/provider_application_common.dart`.
  - Debt giam: trade direct `FontWeight.w800/w900` `13 -> 2`; feature direct `FontWeight.w800/w900` `13 -> 2`; audit `typography_trade_debt 85 -> 63`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/copy_trading_v2_variant_hero.dart lib/features/trade/presentation/widgets/performance_attribution_common.dart lib/features/trade/presentation/widgets/provider_application_progress_intro.dart lib/features/trade/presentation/widgets/performance_attribution_tabs.dart lib/features/trade/presentation/widgets/provider_application_common.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/copy_trading_v2_page_test.dart test/features/trade/performance_attribution_page_test.dart test/features/trade/provider_application_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen copy trading, performance attribution, provider application responsibility/risk copy; direct weights replaced with `AppTextStyles.extraBold/heavy`.
- 2026-06-13: Hoan thanh Completion Gate final - Trade performance attribution summary/export residual.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/performance_attribution_summary_tabs.dart`, `flutter_app/lib/features/trade/presentation/widgets/trade_history_export_summary_sections.dart`.
  - Debt giam: feature direct `FontWeight.w800/w900` `2 -> 0`; `fontFamily:` ngoai theme `1 -> 0`; direct numeric `fontSize` ngoai theme `44 -> 43`; trade `fontSize/fontFamily/w800w900` `37/1/2 -> 36/0/0`; audit `typography_trade_debt 63 -> 55`, `fontFamily 2 -> 0`, `w800w900 4 -> 0`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/performance_attribution_summary_tabs.dart lib/features/trade/presentation/widgets/trade_history_export_summary_sections.dart` (pass; run per changed file in two final steps)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/performance_attribution_page_test.dart` (pass)
    - `flutter test --reporter=compact test/features/trade/trade_history_export_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen performance attribution explanation va trade history export summary copy; export numeric values dung token tabular thay local monospace; khong con local `fontFamily` ngoai theme hay direct feature `FontWeight.w800/w900`.
- 2026-06-13: Hoan thanh RU5 Batch 0 - theme typography tokens.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `docs/03_DESIGN_SYSTEM/VitTrade-Typography-Residual-Unification-Execution-Plan.md`.
  - Debt giam: source debt chua doi; them strict tokens `chartLabelTiny`, `chartLabelXs`, `numericDisplaySm`, `numericDisplayMd`, `numericDisplayLg`, `numericDisplayHeroSm`, `numericDisplayHero`; `fontSize:` trong `flutter_app/lib` `191 -> 198`, direct numeric `fontSize` ngoai theme giu `43`, local `TextStyle(...)` giu `41`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart` (pass)
    - `flutter analyze` (pass)
    - Focused test: theme-token-only batch, no focused widget test required.
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Token them nam trong theme, chua thay doi UI copy/financial safety copy; tiep theo RU5 Batch 1 P2P residual.
- 2026-06-13: Hoan thanh RU5 Batch 1 - P2P residual direct font sizes/painter style.
  - Files: `flutter_app/lib/features/p2p/presentation/pages/p2p_ad_analytics_page_part_03.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_transaction_limits_page_sections.dart`, `flutter_app/lib/features/p2p/presentation/pages/p2p_risk_assessment_page.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_book_selector_ticker.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_order_book_painter.dart`.
  - Debt giam: P2P typography audit `6 -> 0`; P2P direct numeric `fontSize` `4 -> 0`; direct numeric `fontSize` ngoai theme `43 -> 39`; local `TextStyle(...)` ngoai theme `41 -> 40`; quick `copyWith(fontSize)` `6 -> 5`.
  - Verify:
    - `dart format lib/features/p2p/presentation/pages/p2p_ad_analytics_page_part_03.dart lib/features/p2p/presentation/widgets/p2p_transaction_limits_page_sections.dart lib/features/p2p/presentation/pages/p2p_risk_assessment_page.dart lib/features/p2p/presentation/widgets/p2p_order_book_selector_ticker.dart lib/features/p2p/presentation/widgets/p2p_order_book_painter.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/p2p/p2p_ad_analytics_page_test.dart test/features/p2p/p2p_transaction_limits_page_test.dart test/features/p2p/p2p_risk_assessment_page_test.dart test/features/p2p/p2p_order_book_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen P2P limits/risk/order-book copy; painter labels dung `AppTextStyles.chartLabelTiny/chartLabelXs`; con 2 local `TextStyle(...)` P2P cho RU5 Batch 2.
- 2026-06-13: Hoan thanh RU5 Batch 2 - P2P local `TextStyle(...)` con lai.
  - Files: `flutter_app/lib/features/p2p/presentation/widgets/p2p_guide_video_common.dart`, `flutter_app/lib/features/p2p/presentation/widgets/p2p_trading_level_hero_progress.dart`.
  - Debt giam: P2P local `TextStyle(...)` `2 -> 0`; local `TextStyle(...)` ngoai theme `40 -> 38`; P2P direct numeric `fontSize` giu `0`.
  - Verify:
    - `dart format lib/features/p2p/presentation/widgets/p2p_guide_video_common.dart lib/features/p2p/presentation/widgets/p2p_trading_level_hero_progress.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/p2p/p2p_guide_page_test.dart test/features/p2p/p2p_trading_level_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Giu nguyen P2P guide va trading level limit copy; rich text emphasis dung `AppTextStyles.caption.copyWith(...)` thay local `TextStyle`.
- 2026-06-13: Hoan thanh RU5 Batch 3 - Markets/chart typography.
  - Files: `flutter_app/lib/features/markets/presentation/widgets/market_correlations_matrix_widgets.dart`, `flutter_app/lib/features/markets/presentation/pages/portfolio_tracker_page_part_03.dart`, `flutter_app/lib/features/markets/presentation/pages/advanced_charts_page_part_02.dart`.
  - Debt giam: Markets typography audit `5 -> 0`; Markets direct numeric `fontSize` `3 -> 0`; direct numeric `fontSize` ngoai theme `39 -> 36`; local `TextStyle(...)` ngoai theme `38 -> 36`.
  - Verify:
    - `dart format lib/features/markets/presentation/widgets/market_correlations_matrix_widgets.dart lib/features/markets/presentation/pages/portfolio_tracker_page_part_03.dart lib/features/markets/presentation/pages/advanced_charts_page_part_02.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/market_correlations_page_test.dart test/features/markets/portfolio_tracker_page_test.dart test/features/markets/advanced_charts_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Retired chart/canvas typography allowlist rows; painter labels dung `AppTextStyles.chartLabelTiny/chartLabelXs`; advanced chart params dung token rich text styles.
- 2026-06-13: Hoan thanh RU5 Batch 4 - Trade margin/live typography.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/margin_trading_hub_cards.dart`, `flutter_app/lib/features/trade/presentation/widgets/margin_trading_hub_widgets.dart`, `flutter_app/lib/features/trade/presentation/widgets/margin_trading_positions_orders.dart`, `flutter_app/lib/features/trade/presentation/widgets/live_market_tabs.dart`, `flutter_app/lib/features/trade/presentation/widgets/live_market_liquidations.dart`.
  - Debt giam: trade typography audit `55 -> 40`; trade direct numeric `fontSize` `36 -> 26`; direct numeric `fontSize` ngoai theme `36 -> 26`; quick `copyWith(fontSize)` `5 -> 4`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/margin_trading_hub_cards.dart lib/features/trade/presentation/widgets/margin_trading_hub_widgets.dart lib/features/trade/presentation/widgets/margin_trading_positions_orders.dart lib/features/trade/presentation/widgets/live_market_tabs.dart lib/features/trade/presentation/widgets/live_market_liquidations.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/margin_trading_hub_page_test.dart test/features/trade/margin_trading_page_test.dart test/features/trade/live_market_data_analytics_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen leverage/liquidation/cost-disclosure copy; liquidation amount dung tabular figures; margin/live labels dung `captionSm`, `micro`, `baseMedium`.
- 2026-06-13: Hoan thanh RU5 Batch 5A - Trade live/settings typography.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/live_market_interest_open_interest.dart`, `flutter_app/lib/features/trade/presentation/widgets/live_market_sentiment.dart`, `flutter_app/lib/features/trade/presentation/widgets/trade_settings_page_common.dart`.
  - Debt giam: trade typography audit `40 -> 34`; trade direct numeric `fontSize` `26 -> 22`; direct numeric `fontSize` ngoai theme `26 -> 22`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/live_market_interest_open_interest.dart lib/features/trade/presentation/widgets/live_market_sentiment.dart lib/features/trade/presentation/widgets/trade_settings_page_common.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/live_market_data_analytics_page_test.dart test/features/trade/trade_settings_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Batch 5 split thanh 5A/5B de giu 2-5 files moi batch; market sentiment/open interest values dung numeric display tokens; trade settings labels dung caption/navLabel.
- 2026-06-13: Hoan thanh RU5 Batch 5B - Trade export/reporting typography.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/trade_history_export_footer.dart`, `flutter_app/lib/features/trade/presentation/widgets/trade_history_export_selectors_includes.dart`, `flutter_app/lib/features/trade/presentation/widgets/transaction_reporting_filters.dart`.
  - Debt giam: trade typography audit `34 -> 29`; trade direct numeric `fontSize` `22 -> 19`; direct numeric `fontSize` ngoai theme `22 -> 19`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/trade_history_export_footer.dart lib/features/trade/presentation/widgets/trade_history_export_selectors_includes.dart lib/features/trade/presentation/widgets/transaction_reporting_filters.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/trade_history_export_page_test.dart test/features/trade/transaction_reporting_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Giu nguyen tax/export/reporting copy; compact labels dung `AppTextStyles.navLabel`.
- 2026-06-13: Hoan thanh RU5 Batch 6A - Trade copy settings/notifications/safety/card demo typography.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/copy_settings_contacts_privacy.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_notifications_page_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_safety_enforcement_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_trading_card_demo_sections.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_trading_card_demo_widgets.dart`.
  - Debt giam: trade typography audit `29 -> 15`; trade direct numeric `fontSize` `19 -> 10`; direct numeric `fontSize` ngoai theme `19 -> 10`; quick `copyWith(fontSize)` `4 -> 1`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/copy_settings_contacts_privacy.dart lib/features/trade/presentation/widgets/copy_notifications_page_common.dart lib/features/trade/presentation/widgets/copy_safety_enforcement_common.dart lib/features/trade/presentation/widgets/copy_trading_card_demo_sections.dart lib/features/trade/presentation/widgets/copy_trading_card_demo_widgets.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/copy_settings_page_test.dart test/features/trade/copy_notifications_page_test.dart test/features/trade/copy_safety_center_page_test.dart test/features/trade/copy_trading_card_demo_test.dart` (pass after keeping strict no-fontSize and lowering privacy note line-height to avoid 1px overflow)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Batch 6 split thanh 6A/6B de giu 2-5 files moi batch; emergency/privacy/safety copy giu nguyen; numeric card values dung display tokens.
- 2026-06-13: Hoan thanh RU5 Batch 6B - Trade execution/RIY/governance/chart typography.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/execution_quality_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/execution_quality_tabs.dart`, `flutter_app/lib/features/trade/presentation/widgets/riy_calculator_page_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/provider_governance_page_overview.dart`, `flutter_app/lib/features/trade/presentation/widgets/advanced_chart_painter.dart`.
  - Debt giam: trade typography audit `15 -> 3`; trade direct numeric `fontSize` `10 -> 2`; direct numeric `fontSize` ngoai theme `10 -> 2`; quick `copyWith(fontSize)` `1` con lai o trade bot residual.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/execution_quality_common.dart lib/features/trade/presentation/widgets/execution_quality_tabs.dart lib/features/trade/presentation/widgets/riy_calculator_page_common.dart lib/features/trade/presentation/widgets/provider_governance_page_overview.dart lib/features/trade/presentation/widgets/advanced_chart_painter.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/execution_quality_demo_page_test.dart test/features/trade/riy_calculator_page_test.dart test/features/trade/provider_governance_page_test.dart test/features/trade/advanced_chart_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Advanced chart overlay label now uses `AppTextStyles.chartLabelXs`; RIY/execution/governance copy unchanged. Need RU5 Batch 6C for two trade bot residual files discovered by strict scan.
- 2026-06-13: Hoan thanh RU5 Batch 6C - Trade bot residual direct font sizes.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/bot_faq_search_tabs.dart`, `flutter_app/lib/features/trade/presentation/pages/trading_bots_page_part_04.dart`.
  - Debt giam: trade typography audit `3 -> 0`; trade direct numeric `fontSize` `2 -> 0`; direct numeric `fontSize` ngoai theme `2 -> 0`; quick `copyWith(fontSize)` `1 -> 0`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/bot_faq_search_tabs.dart lib/features/trade/presentation/pages/trading_bots_page_part_04.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/bot_faq_page_test.dart test/features/trade/trading_bots_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated stale audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
  - Ghi chu: Two trade bot residual files were discovered by strict scan after planned Batch 6B; bot success/FAQ copy unchanged and direct typography now zero across P2P/Markets/Trade.
- 2026-06-13: Hoan thanh RU5 Batch 7A - Auth local `TextStyle(...)`.
  - Files: `flutter_app/lib/features/auth/presentation/widgets/register_page_sections.dart`, `flutter_app/lib/features/auth/presentation/widgets/otp_input_status.dart`, `flutter_app/lib/features/auth/presentation/widgets/forgot_password_page_sections.dart`.
  - Debt giam: local `TextStyle(...)` ngoai theme `36 -> 32`; direct numeric `fontSize` giu `0`.
  - Verify:
    - `dart format lib/features/auth/presentation/widgets/register_page_sections.dart lib/features/auth/presentation/widgets/otp_input_status.dart lib/features/auth/presentation/widgets/forgot_password_page_sections.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/auth/register_page_test.dart test/features/auth/otp_page_test.dart test/features/auth/forgot_password_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Auth terms, OTP timer, and forgot-password email emphasis use `AppTextStyles.caption.copyWith(...)`; auth copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 7B - Profile/Wallet local `TextStyle(...)`.
  - Files: `flutter_app/lib/features/profile/presentation/widgets/profile_api_key_create_result.dart`, `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_card_details.dart`, `flutter_app/lib/features/profile/presentation/pages/api_management_page.dart`, `flutter_app/lib/features/wallet/presentation/widgets/wallet_gas_optimizer_current.dart`, `flutter_app/lib/features/wallet/presentation/widgets/wallet_address_book_security.dart`.
  - Debt giam: local `TextStyle(...)` ngoai theme `32 -> 26`; direct numeric `fontSize` giu `0`.
  - Verify:
    - `dart format lib/features/profile/presentation/widgets/profile_api_key_create_result.dart lib/features/profile/presentation/widgets/profile_sub_account_card_details.dart lib/features/profile/presentation/pages/api_management_page.dart lib/features/wallet/presentation/widgets/wallet_gas_optimizer_current.dart lib/features/wallet/presentation/widgets/wallet_address_book_security.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/profile/api_management_page_test.dart test/features/profile/sub_account_page_test.dart test/features/wallet/wallet_gas_optimizer_page_test.dart test/features/wallet/address_book_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: API delete/key creation, sub-account email, gas optimizer, and address-book security emphasis use token styles; warning/delete/whitelist copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 7C - Admin/DCA/Earn/Discovery local `TextStyle(...)`.
  - Files: `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_common_painter.dart`, `flutter_app/lib/features/admin/presentation/widgets/analytics_dashboard_common.dart`, `flutter_app/lib/features/dca/presentation/widgets/dca_performance_compare_tabs.dart`, `flutter_app/lib/features/earn/presentation/pages/staking_voting_page.dart`, `flutter_app/lib/features/discovery/presentation/widgets/unified_search_results.dart`.
  - Debt giam: local `TextStyle(...)` ngoai theme `26 -> 20`; direct numeric `fontSize` giu `0`.
  - Verify:
    - `dart format lib/features/admin/presentation/widgets/funnel_dashboard_common_painter.dart lib/features/admin/presentation/widgets/analytics_dashboard_common.dart lib/features/dca/presentation/widgets/dca_performance_compare_tabs.dart lib/features/earn/presentation/pages/staking_voting_page.dart lib/features/discovery/presentation/widgets/unified_search_results.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/admin/funnel_dashboard_test.dart test/features/admin/analytics_dashboard_test.dart test/features/dca/dca_performance_compare_page_test.dart test/features/earn/staking_voting_page_test.dart test/features/discovery/unified_search_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Admin painter labels now receive token `TextStyle` values; DCA/earn/discovery emphasis copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 7D - Predictions local `TextStyle(...)`.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/predictions/presentation/widgets/predictions_global_activity_feed_widgets.dart`, `flutter_app/lib/features/predictions/presentation/widgets/predictions_breaking_page_sections.dart`, `flutter_app/lib/features/predictions/presentation/widgets/predictions_leaderboard_rows_wins.dart`, `flutter_app/lib/features/predictions/presentation/widgets/predictions_leaderboard_podium_rankings.dart`.
  - Debt giam: local `TextStyle(...)` ngoai theme `20 -> 15`; direct numeric `fontSize` giu `0`; theme gained avatar tokens `avatarSm/avatarMd/avatarLg`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/predictions/presentation/widgets/predictions_global_activity_feed_widgets.dart lib/features/predictions/presentation/widgets/predictions_breaking_page_sections.dart lib/features/predictions/presentation/widgets/predictions_leaderboard_rows_wins.dart lib/features/predictions/presentation/widgets/predictions_leaderboard_podium_rankings.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/predictions/predictions_global_activity_page_test.dart test/features/predictions/predictions_breaking_page_test.dart test/features/predictions/predictions_leaderboard_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Prediction avatar sizes moved to semantic theme tokens; probability/leaderboard copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 7E - Wallet/Trade local `TextStyle(...)`.
  - Files: `flutter_app/lib/features/wallet/presentation/pages/address_book_page.dart`, `flutter_app/lib/features/wallet/presentation/pages/wallet_health_score_page_part_03.dart`, `flutter_app/lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart`, `flutter_app/lib/features/trade/presentation/widgets/copy_performance_summary_tabs.dart`, `flutter_app/lib/features/trade/presentation/widgets/performance_attribution_tabs.dart`.
  - Debt giam: local `TextStyle(...)` ngoai theme `15 -> 8`; direct numeric `fontSize` giu `0`.
  - Verify:
    - `dart format lib/features/wallet/presentation/pages/address_book_page.dart lib/features/wallet/presentation/pages/wallet_health_score_page_part_03.dart lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart lib/features/trade/presentation/widgets/copy_performance_summary_tabs.dart lib/features/trade/presentation/widgets/performance_attribution_tabs.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/wallet/address_book_page_test.dart test/features/wallet/wallet_health_score_page_test.dart test/features/trade/advanced_chart_page_test.dart test/features/trade/copy_performance_page_test.dart test/features/trade/performance_attribution_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Wallet painter labels now receive token style; address delete, trade header metrics, copy performance, and attribution explanatory copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 7F - Trade bot local `TextStyle(...)`.
  - Files: `flutter_app/lib/features/trade/presentation/widgets/bot_drawdown_analyzer_page_common.dart`, `flutter_app/lib/features/trade/presentation/widgets/bot_performance_painters.dart`, `flutter_app/lib/features/trade/presentation/widgets/bot_risk_dashboard_controls.dart`, `flutter_app/lib/features/trade/presentation/widgets/bot_strategy_compare_selection.dart`, `flutter_app/lib/features/trade/presentation/widgets/bot_terms_of_service_page_sections.dart`.
  - Debt giam: local `TextStyle(...)` ngoai theme `8 -> 3`; direct numeric `fontSize` giu `0`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/bot_drawdown_analyzer_page_common.dart lib/features/trade/presentation/widgets/bot_performance_painters.dart lib/features/trade/presentation/widgets/bot_risk_dashboard_controls.dart lib/features/trade/presentation/widgets/bot_strategy_compare_selection.dart lib/features/trade/presentation/widgets/bot_terms_of_service_page_sections.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/bot_drawdown_analyzer_page_test.dart test/features/trade/bot_performance_analytics_page_test.dart test/features/trade/bot_risk_dashboard_page_test.dart test/features/trade/bot_strategy_compare_page_test.dart test/features/trade/bot_terms_of_service_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Bot chart painters now receive token `TextStyle` values; risk/terms/strategy copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 7G - Trade client/risk local `TextStyle(...)`.
  - Files: `flutter_app/lib/features/trade/presentation/pages/client_categorization_page_part_02.dart`, `flutter_app/lib/features/trade/presentation/widgets/client_money_protection_page_sections.dart`, `flutter_app/lib/features/trade/presentation/widgets/risk_indicator_scale_intro.dart`.
  - Debt giam: local `TextStyle(...)` ngoai theme `3 -> 0`; strict scans `fontSize` direct/copy/`TextStyle`/`fontFamily`/`FontWeight.w800/w900` all `0`.
  - Verify:
    - `dart format lib/features/trade/presentation/pages/client_categorization_page_part_02.dart lib/features/trade/presentation/widgets/client_money_protection_page_sections.dart lib/features/trade/presentation/widgets/risk_indicator_scale_intro.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/client_categorization_page_test.dart test/features/trade/client_money_protection_page_test.dart test/features/trade/risk_indicator_explainer_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifact current)
  - Ghi chu: Client categorization opt-up warning, client money protection, and SRI high-risk copy unchanged; local `TextStyle(...)` now zero outside theme.
- 2026-06-13: Hoan thanh RU5 Batch 8A - Launchpad robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_rebalance_suggestions.dart`, `flutter_app/lib/features/launchpad/presentation/pages/launchpad_webhooks_page_part_01.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_dca_builder_strategies.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_rebalance_allocation.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_rebalance_hero.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `113 -> 94`; `fontSize:` trong `flutter_app/lib` `146 -> 128`; `fontSize:` ngoai theme `115 -> 96`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_suggestions.dart lib/features/launchpad/presentation/pages/launchpad_webhooks_page_part_01.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_strategies.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_allocation.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_hero.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/launchpad/launchpad_rebalance_page_test.dart test/features/launchpad/launchpad_webhooks_page_test.dart test/features/launchpad/launchpad_dca_builder_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 94 residuals remain outside this batch)
  - Ghi chu: Added `AppTextStyles.numericDisplayXl` for the existing 30px Launchpad hero amount; rebalance/webhook/DCA copy unchanged; no chart/canvas/code exception kept.
- 2026-06-13: Hoan thanh RU5 Batch 8B - Admin/cross-module robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/admin/presentation/widgets/admin_home_metrics_realtime.dart`, `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_selector_metrics.dart`, `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_cards.dart`, `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_tabs.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `94 -> 84`; `fontSize:` trong `flutter_app/lib` `128 -> 119`; `fontSize:` ngoai theme `96 -> 86`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/admin/presentation/widgets/admin_home_metrics_realtime.dart lib/features/admin/presentation/widgets/funnel_dashboard_selector_metrics.dart lib/features/cross_module/presentation/widgets/smart_alert_center_cards.dart lib/features/cross_module/presentation/widgets/smart_alert_center_tabs.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/admin/admin_home_test.dart test/features/admin/funnel_dashboard_test.dart test/features/cross_module/smart_alert_center_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 84 residuals remain outside this batch)
  - Ghi chu: Added `AppTextStyles.amountXs` for existing 22px admin metric values; admin live metrics/funnel and smart alert copy unchanged; no typography exception kept.
- 2026-06-13: Hoan thanh RU5 Batch 8C - Cross tax + DCA robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/cross_module/presentation/pages/tax_report_center_part_02.dart`, `flutter_app/lib/features/cross_module/presentation/pages/tax_report_center_part_03.dart`, `flutter_app/lib/features/dca/presentation/pages/dca_multi_asset_page_part_03.dart`, `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart`, `flutter_app/lib/features/dca/presentation/widgets/dca_overview_demo_shell.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `84 -> 77`; `fontSize:` trong `flutter_app/lib` `119 -> 115`; `fontSize:` ngoai theme `86 -> 79`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/cross_module/presentation/pages/tax_report_center_part_02.dart lib/features/cross_module/presentation/pages/tax_report_center_part_03.dart lib/features/dca/presentation/pages/dca_multi_asset_page_part_03.dart lib/features/dca/presentation/pages/dca_page_part_01.dart lib/features/dca/presentation/widgets/dca_overview_demo_shell.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/cross_module/tax_report_center_test.dart test/features/dca/dca_multi_asset_page_test.dart test/features/dca/dca_page_test.dart test/features/dca/dca_overview_demo_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 77 residuals remain outside this batch)
  - Ghi chu: Added `AppTextStyles.sectionTitleXs`, `numericDisplayHeroXs`, and `numericDisplay2xl` for existing DCA 18/29/31 display sizes; tax status and DCA amount/risk copy unchanged; no typography exception kept.
- 2026-06-13: Hoan thanh RU5 Batch 8D - DCA remaining + Dev robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/features/dca/presentation/widgets/dca_schedule_common.dart`, `flutter_app/lib/features/dca/presentation/widgets/dca_schedule_strategy_time.dart`, `flutter_app/lib/features/dca/presentation/widgets/dca_smart_rules_tabs_stats.dart`, `flutter_app/lib/features/dev/presentation/widgets/design_system_color_section.dart`, `flutter_app/lib/features/dev/presentation/widgets/design_system_footer.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `77 -> 72`; `fontSize:` trong `flutter_app/lib` `115 -> 110`; `fontSize:` ngoai theme `79 -> 74`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/features/dca/presentation/widgets/dca_schedule_common.dart lib/features/dca/presentation/widgets/dca_schedule_strategy_time.dart lib/features/dca/presentation/widgets/dca_smart_rules_tabs_stats.dart lib/features/dev/presentation/widgets/design_system_color_section.dart lib/features/dev/presentation/widgets/design_system_footer.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/dca/dca_schedule_config_page_test.dart test/features/dca/dca_smart_rules_page_test.dart test/features/dev/design_system_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 72 residuals remain outside this batch)
  - Ghi chu: DCA section/info labels now use `sectionTitleXs`/`captionSm`; dev palette/footer tiny values use `chartLabelXs`; no copy or exception changes.
- 2026-06-13: Hoan thanh RU5 Batch 8E - Dev residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/dev/presentation/widgets/design_system_hero.dart`, `flutter_app/lib/features/dev/presentation/widgets/design_system_input_section.dart`, `flutter_app/lib/features/dev/presentation/widgets/missing_screens_showcase_page_common.dart`, `flutter_app/lib/features/dev/presentation/widgets/missing_screens_showcase_page_sections.dart`, `flutter_app/lib/features/dev/presentation/widgets/performance_monitor_sections.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `72 -> 61`; `fontSize:` trong `flutter_app/lib` `110 -> 100`; `fontSize:` ngoai theme `74 -> 63`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/dev/presentation/widgets/design_system_hero.dart lib/features/dev/presentation/widgets/design_system_input_section.dart lib/features/dev/presentation/widgets/missing_screens_showcase_page_common.dart lib/features/dev/presentation/widgets/missing_screens_showcase_page_sections.dart lib/features/dev/presentation/widgets/performance_monitor_sections.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/dev/design_system_page_test.dart test/features/dev/missing_screens_showcase_page_test.dart test/features/dev/performance_monitor_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 61 residuals remain outside this batch)
  - Ghi chu: Added `AppTextStyles.sectionTitleMd` for existing 24px dev hero title; dev route/performance copy unchanged; no typography exception kept.
- 2026-06-13: Hoan thanh RU5 Batch 8F - Route checker + Earn residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/dev/presentation/widgets/route_checker_page_sections.dart`, `flutter_app/lib/features/earn/presentation/pages/savings_goal_page_part_02.dart`, `flutter_app/lib/features/earn/presentation/widgets/savings_home_hero.dart`, `flutter_app/lib/features/earn/presentation/widgets/savings_home_products.dart`, `flutter_app/lib/features/earn/presentation/widgets/staking_earn_products.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `61 -> 52`; `fontSize:` trong `flutter_app/lib` `100 -> 92`; `fontSize:` ngoai theme `63 -> 54`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/dev/presentation/widgets/route_checker_page_sections.dart lib/features/earn/presentation/pages/savings_goal_page_part_02.dart lib/features/earn/presentation/widgets/savings_home_hero.dart lib/features/earn/presentation/widgets/savings_home_products.dart lib/features/earn/presentation/widgets/staking_earn_products.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/dev/route_checker_page_test.dart test/features/earn/savings_goal_page_test.dart test/features/earn/savings_page_test.dart test/features/earn/staking_earn_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 52 residuals remain outside this batch)
  - Ghi chu: Added `AppTextStyles.microTiny` for existing 7px savings milestone label; savings/staking APY and balance values use numeric tokens; no fee/risk/limit copy changed.
- 2026-06-13: Hoan thanh RU5 Batch 8G - Earn portfolio/analytics/auto-compound robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/features/earn/presentation/pages/savings_portfolio_page_part_01.dart`, `flutter_app/lib/features/earn/presentation/pages/savings_portfolio_page_part_03.dart`, `flutter_app/lib/features/earn/presentation/pages/staking_analytics_page_part_02.dart`, `flutter_app/lib/features/earn/presentation/pages/staking_auto_compound_page_part_01.dart`, `flutter_app/lib/features/earn/presentation/pages/staking_auto_compound_page_part_02.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `52 -> 47`; `fontSize:` trong `flutter_app/lib` `92 -> 87`; `fontSize:` ngoai theme `54 -> 49`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/features/earn/presentation/pages/savings_portfolio_page_part_01.dart lib/features/earn/presentation/pages/savings_portfolio_page_part_03.dart lib/features/earn/presentation/pages/staking_analytics_page_part_02.dart lib/features/earn/presentation/pages/staking_auto_compound_page_part_01.dart lib/features/earn/presentation/pages/staking_auto_compound_page_part_02.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/earn/savings_portfolio_page_test.dart test/features/earn/staking_analytics_page_test.dart test/features/earn/staking_auto_compound_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 47 residuals remain outside this batch)
  - Ghi chu: Savings portfolio balances, staking analytics ROI, and auto-compound stat/axis labels now use numeric/chart tokens; copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 8H - Earn residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/earn/presentation/pages/staking_liquid_staking_page_part_02.dart`, `flutter_app/lib/features/earn/presentation/widgets/savings_dca_summary.dart`, `flutter_app/lib/features/earn/presentation/widgets/savings_export_config_widgets.dart`, `flutter_app/lib/features/earn/presentation/widgets/savings_history_page_common.dart`, `flutter_app/lib/features/earn/presentation/widgets/savings_smart_suggestions_summary.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `47 -> 42`; `fontSize:` trong `flutter_app/lib` `87 -> 83`; `fontSize:` ngoai theme `49 -> 44`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/earn/presentation/pages/staking_liquid_staking_page_part_02.dart lib/features/earn/presentation/widgets/savings_dca_summary.dart lib/features/earn/presentation/widgets/savings_export_config_widgets.dart lib/features/earn/presentation/widgets/savings_history_page_common.dart lib/features/earn/presentation/widgets/savings_smart_suggestions_summary.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/earn/staking_liquid_staking_page_test.dart test/features/earn/savings_dca_page_test.dart test/features/earn/savings_export_page_test.dart test/features/earn/savings_history_page_test.dart test/features/earn/savings_smart_suggestions_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 42 residuals remain outside this batch)
  - Ghi chu: Added `AppTextStyles.numericDisplay3xl` for existing 32px savings stat values; liquid staking, export, DCA, history, and suggestions copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 8I - Earn residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/earn/presentation/widgets/savings_what_if_asset_impact.dart`, `flutter_app/lib/features/earn/presentation/widgets/staking_community_governance_page_common.dart`, `flutter_app/lib/features/earn/presentation/widgets/staking_community_governance_page_sections.dart`, `flutter_app/lib/features/earn/presentation/widgets/staking_multi_chain_page_sections.dart`, `flutter_app/lib/features/earn/presentation/widgets/staking_risk_dashboard_page_sections.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `42 -> 37`; `fontSize:` trong `flutter_app/lib` `83 -> 79`; `fontSize:` ngoai theme `44 -> 39`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/earn/presentation/widgets/savings_what_if_asset_impact.dart lib/features/earn/presentation/widgets/staking_community_governance_page_common.dart lib/features/earn/presentation/widgets/staking_community_governance_page_sections.dart lib/features/earn/presentation/widgets/staking_multi_chain_page_sections.dart lib/features/earn/presentation/widgets/staking_risk_dashboard_page_sections.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/earn/savings_what_if_page_test.dart test/features/earn/staking_community_governance_page_test.dart test/features/earn/staking_multi_chain_page_test.dart test/features/earn/staking_risk_dashboard_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 37 residuals remain outside this batch)
  - Ghi chu: Added `AppTextStyles.numericDisplay4xl` for existing 36px staking risk score; what-if, governance, multi-chain, and risk dashboard copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 8J - Earn final residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/features/earn/presentation/widgets/staking_suitability_assessment_page_sections.dart`, `flutter_app/lib/features/earn/presentation/widgets/staking_tax_guide_calculator.dart`, `flutter_app/lib/features/earn/presentation/widgets/staking_tax_guide_common.dart`, `flutter_app/lib/features/earn/presentation/widgets/staking_tax_guide_overview.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `37 -> 32`; `fontSize:` trong `flutter_app/lib` `79 -> 74`; `fontSize:` ngoai theme `39 -> 34`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/features/earn/presentation/widgets/staking_suitability_assessment_page_sections.dart lib/features/earn/presentation/widgets/staking_tax_guide_calculator.dart lib/features/earn/presentation/widgets/staking_tax_guide_common.dart lib/features/earn/presentation/widgets/staking_tax_guide_overview.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/earn/staking_suitability_assessment_page_test.dart test/features/earn/staking_tax_guide_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 32 residuals remain outside this batch)
  - Ghi chu: Earn robust `copyWith(fontSize)` residuals now zero; tax guide and staking suitability copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 8K - Launchpad residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_swap_aggregator_history_settings.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_dca_builder_history.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_rebalance_deviation.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_rebalance_strategy.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_risk_tabs_overview.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `32 -> 21`; `fontSize:` trong `flutter_app/lib` `74 -> 63`; `fontSize:` ngoai theme `34 -> 23`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/features/launchpad/presentation/widgets/launchpad_swap_aggregator_history_settings.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_history.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_deviation.dart lib/features/launchpad/presentation/widgets/launchpad_rebalance_strategy.dart lib/features/launchpad/presentation/widgets/launchpad_risk_tabs_overview.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/launchpad/launchpad_swap_aggregator_page_test.dart test/features/launchpad/launchpad_dca_builder_page_test.dart test/features/launchpad/launchpad_rebalance_page_test.dart test/features/launchpad/launchpad_risk_analytics_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 21 residuals remain outside this batch)
  - Ghi chu: Launchpad swap/DCA/rebalance/risk labels now use token styles; safety copy in swap settings unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 8L - Launchpad residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_03.dart`, `flutter_app/lib/features/launchpad/presentation/pages/launchpad_staking_page_part_01.dart`, `flutter_app/lib/features/launchpad/presentation/pages/launchpad_staking_page_part_03.dart`, `flutter_app/lib/features/launchpad/presentation/pages/launchpad_webhooks_page_part_04.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_dca_builder_create_form.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `21 -> 16`; `fontSize:` trong `flutter_app/lib` `63 -> 58`; `fontSize:` ngoai theme `23 -> 18`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/features/launchpad/presentation/pages/launchpad_multisig_page_part_03.dart lib/features/launchpad/presentation/pages/launchpad_staking_page_part_01.dart lib/features/launchpad/presentation/pages/launchpad_staking_page_part_03.dart lib/features/launchpad/presentation/pages/launchpad_webhooks_page_part_04.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_create_form.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/launchpad/launchpad_multisig_page_test.dart test/features/launchpad/launchpad_staking_page_test.dart test/features/launchpad/launchpad_webhooks_page_test.dart test/features/launchpad/launchpad_dca_builder_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 16 residuals remain outside this batch)
  - Ghi chu: Launchpad multisig/staking/webhook/DCA labels now use token styles; webhook endpoint and multisig safety copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 8M - Launchpad residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_dca_builder_summary.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_home_tool_widgets.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_header_widgets.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_history_widgets.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_limit_orders_preview_widgets.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `16 -> 11`; `fontSize:` trong `flutter_app/lib` `58 -> 54`; `fontSize:` ngoai theme `18 -> 13`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/launchpad/presentation/widgets/launchpad_dca_builder_summary.dart lib/features/launchpad/presentation/widgets/launchpad_home_tool_widgets.dart lib/features/launchpad/presentation/widgets/launchpad_limit_orders_header_widgets.dart lib/features/launchpad/presentation/widgets/launchpad_limit_orders_history_widgets.dart lib/features/launchpad/presentation/widgets/launchpad_limit_orders_preview_widgets.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/launchpad/launchpad_page_test.dart test/features/launchpad/launchpad_dca_builder_page_test.dart test/features/launchpad/launchpad_limit_orders_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 11 residuals remain outside this batch)
  - Ghi chu: Added `AppTextStyles.amountBase` for existing 20px Launchpad summary values; limit order and DCA copy unchanged.
- 2026-06-13: Hoan thanh RU5 Batch 8N - Launchpad final residual robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_performance_overview.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_risk_painter.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_risk_report_common.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_swap_aggregator_quotes.dart`, `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_webhooks_common_widgets.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `11 -> 4`; `fontSize:` trong `flutter_app/lib` `54 -> 47`; `fontSize:` ngoai theme `13 -> 6`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/features/launchpad/presentation/widgets/launchpad_performance_overview.dart lib/features/launchpad/presentation/widgets/launchpad_risk_painter.dart lib/features/launchpad/presentation/widgets/launchpad_risk_report_common.dart lib/features/launchpad/presentation/widgets/launchpad_swap_aggregator_quotes.dart lib/features/launchpad/presentation/widgets/launchpad_webhooks_common_widgets.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/launchpad/launchpad_performance_page_test.dart test/features/launchpad/launchpad_risk_analytics_page_test.dart test/features/launchpad/launchpad_swap_aggregator_page_test.dart test/features/launchpad/launchpad_webhooks_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (expected fail while strict gate burn-down continues; 4 residuals remain outside this batch)
  - Ghi chu: Launchpad robust `copyWith(fontSize)` residuals now zero; risk painter label uses token style and no exception retained.
- 2026-06-13: Hoan thanh RU5 Batch 8O - Final Markets/Trade robust `copyWith(fontSize)` burn-down.
  - Files: `flutter_app/lib/features/markets/presentation/widgets/comparison_tool_common.dart`, `flutter_app/lib/features/markets/presentation/widgets/market_derivatives_common.dart`, `flutter_app/lib/features/markets/presentation/widgets/market_heatmap_treemap.dart`, `flutter_app/lib/features/trade/presentation/widgets/trade_settings_page_common.dart`.
  - Debt giam: robust strict `copyWith(...fontSize...)` ngoai theme `4 -> 0`; `fontSize:` trong `flutter_app/lib` `47 -> 43`; `fontSize:` ngoai theme `6 -> 2`; direct numeric `fontSize`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` giu `0`.
  - Verify:
    - `dart format lib/features/markets/presentation/widgets/comparison_tool_common.dart lib/features/markets/presentation/widgets/market_derivatives_common.dart lib/features/markets/presentation/widgets/market_heatmap_treemap.dart lib/features/trade/presentation/widgets/trade_settings_page_common.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/comparison_tool_page_test.dart test/features/markets/derivatives_overview_page_test.dart test/features/markets/market_heatmap_page_test.dart test/features/trade/trade_settings_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass under then-current robust gate)
  - Ghi chu: Final Markets/Trade conditional label values now use token styles; no code/id exception kept; financial safety/settings copy unchanged. Batch 8 final tightened the gate to catch the remaining conditional `fontSize:` parameters not covered by the prior quick regex.
- 2026-06-13: Hoan thanh RU5 Batch 8 final - strict typography zero residual gate/docs.
  - Files: `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/features/markets/presentation/widgets/market_correlations_matrix_widgets.dart`, `flutter_app/lib/features/markets/presentation/widgets/market_heatmap_treemap.dart`, `flutter_app/tool/design_token_consistency_audit.dart`; artifacts/docs: `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.md`, `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`, `docs/03_DESIGN_SYSTEM/VitTrade-Typography-Residual-Unification-Execution-Plan.md`.
  - Debt giam: `fontSize:` ngoai theme `2 -> 0`; `fontSize:` trong `flutter_app/lib` `43 -> 42`; direct numeric `fontSize`, robust `copyWith(...fontSize...)`, local `TextStyle(...)`, `fontFamily`, and direct `FontWeight.w800/w900` all `0`.
  - Verify:
    - `dart format lib/app/theme/app_text_styles.dart lib/features/markets/presentation/widgets/market_correlations_matrix_widgets.dart lib/features/markets/presentation/widgets/market_heatmap_treemap.dart tool/design_token_consistency_audit.dart` (pass)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/market_correlations_page_test.dart test/features/markets/market_heatmap_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` (regenerated audit artifact)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; `strict_typography_gate=zero_residual pass residuals=0`)
    - Final acceptance scans for `fontSize:\s*[0-9]`, `copyWith\([^)]*fontSize`, `TextStyle\(`, `fontFamily:`, `FontWeight\.w[89]00`, and any `fontSize:` outside theme all returned `0`.
  - Ghi chu: Added `AppTextStyles.chartLabelNano` to preserve the existing 7sp correlation matrix label without local font sizing; strict gate now fails on any `fontSize:` outside theme, not only direct numeric values. No chart/canvas/code/internal typography exception remains active and no financial safety copy changed.

## Copy-Paste Execution Request

Dung prompt ngan nay cho lan chay tiep theo de tiet kiem token:

```text
Hay thuc thi file:
docs/03_DESIGN_SYSTEM/VitTrade-Typography-Residual-Unification-Execution-Plan.md

Tu dong tiep tuc tu RESUME FROM hien tai. Khong tao plan moi.
Lam tung batch 2-5 file, khong blind replace, khong sua ngoai scope, khong xoa
financial safety copy. Sau moi batch phai format, analyze, focused test, audit
check, cap nhat Current Metrics/Batch Tracking/RESUME FROM. Neu test trong plan
khong ton tai, dung focused test gan nhat cung module/flow va ghi ro trong
tracking. Neu audit stale, regenerate artifact roi check lai.

Neu batch pass va con kha nang tiep tuc, chay batch ke tiep theo cung quy tac.
Neu bi block, final response phai ket thuc bang:
RESUME FROM: <phase id> - <file hoac checklist item cu the>
```

## Resume Point

Tiep tuc tai:

```text
RESUME FROM: COMPLETE - strict typography zero residual passed
```
