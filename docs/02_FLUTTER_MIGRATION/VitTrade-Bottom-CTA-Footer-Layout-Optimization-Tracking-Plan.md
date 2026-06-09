# VitTrade Bottom CTA Footer Layout Optimization Tracking Plan

Created: 2026-06-04

Scope: Flutter-only VitTrade app trong `flutter_app/`.

Status: Completed implementation and QA on 2026-06-04.

## 1. Muc tieu

Toi uu cac nut hanh dong o day man hinh de app:

- Khong che noi dung hoac lam mat dien tich doc tren dien thoai.
- Khong tao "floating footer" khi nut hanh dong chi can nam trong noi dung.
- Giu sticky footer cho cac flow tai chinh, bao mat, confirm rui ro cao.
- Khong sua nham cac flow da dung: bottom nav, app shell, bottom sheet root navigator.
- Dam bao moi thay doi co test va emulator smoke de tranh regression.

Van de goc:

- Home bottom sheet tung bi `VitBottomNav` che.
- Arena Studio tung co nut `Tiep tuc` sticky/floating lam chiem dien tich va khong gan voi ngu canh noi dung.
- Sau khi sua Arena Studio, can kiem tra va toi uu cac man hinh co pattern tuong tu.

## 2. Source of truth phai doc truoc khi implement

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/03_DESIGN_SYSTEM/Guidelines.md`
4. `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md`
5. `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`
6. `docs/02_FLUTTER_MIGRATION/VitTrade-Bottom-Sheet-Root-Navigator-Standardization-Tracking-Plan.md`
7. `flutter_app/lib/shared/layout/vit_app_shell.dart`
8. `flutter_app/lib/shared/layout/vit_bottom_nav.dart`
9. `flutter_app/lib/shared/layout/vit_page_layout.dart`
10. `flutter_app/lib/shared/widgets/vit_bottom_sheet.dart`

## 3. Dinh nghia loi can xu ly

Mot case duoc xem la "giong Arena" khi:

- Co CTA/footer nam co dinh o day man hinh bang `Positioned`, `VitStickyFooter`, hoac widget footer tu viet.
- Nut bi disable cho den khi user chon/nhap du dieu kien.
- User phai doc/chon noi dung truoc roi moi bam nut, nen nut co the nam inline sau noi dung.
- Footer co them nut phu nhu save/share/settings/export lam tang dien tich day man hinh.
- Chuc nang khong phai giao dich tien that, khong phai confirm bao mat, khong phai emergency action.

Khong xem la loi neu:

- La `VitBottomNav` hoac `VitAppShell` bottom navigation.
- La modal/bottom sheet da dung `showVitBottomSheet`.
- La flow tai chinh/rui ro cao can CTA luon san sang, vi du P2P buy/sell, wallet address save, copy trading confirmation, emergency stop.
- La footer nam ben trong scroll content, khong overlay len noi dung.

## 4. Baseline audit hien tai

Ket qua audit ngay 2026-06-04:

| Hang muc | Ket qua |
| --- | ---: |
| Direct `showModalBottomSheet` ngoai helper | 0 |
| `showVitBottomSheet` trong feature code | 60 |
| `VitStickyFooter` trong `flutter_app/lib/features` | 18 |
| Arena sticky CTA sau khi sua Studio | 0 case can sua ngay |

Post-implementation audit ngay 2026-06-04:

| Hang muc | Ket qua |
| --- | ---: |
| Direct `showModalBottomSheet` ngoai helper | 0 |
| `showVitBottomSheet` trong feature code | 60 |
| `VitStickyFooter` trong `flutter_app/lib/features` | 16 |
| DCA target floating/sticky CTA overlay | 0 |
| Earn Savings Auto Rebalance duplicate sticky CTA | 0 |
| Launchpad Notification Sound sticky save footer | 0 |

Guardrail bottom sheet:

- `flutter_app/test/quality/bottom_sheet_guardrail_test.dart`
- Muc tieu: khong cho feature/app/shared goi `showModalBottomSheet` truc tiep.

## 5. Nguyen tac thiet ke cho vong sua nay

- Phone-first tu 360 px.
- Mot man hinh khong nen co 2 CTA cung chuc nang.
- CTA lien quan den dieu kien hoan thanh nen nam ngay sau block dieu kien/summary.
- Nut phu nhu save/share/settings nen uu tien header action, icon button compact, hoac inline trong card co ngu canh.
- Khi van can sticky footer, phai tinh `bottomInset` ro rang de scroll content khong bi che.
- Khong tao nested card cho footer moi.
- Khong them palette moi; dung token trong `app/theme`.
- Khong thay doi copy tai chinh/rui ro cao neu khong can thiet.
- Arena van phai points-only, khong dung ngon ngu payout/profit/stake-return.

## 6. Pham vi khong duoc sua trong Phase 1

Cac flow sau chi audit/giu nguyen, khong chuyen inline trong Phase 1:

- P2P ad detail buy/sell.
- P2P create ad publish.
- P2P payment method add/save.
- Wallet address add/save.
- Copy trading configuration/confirmation.
- Bot emergency stop.
- Complaint/dispute submit neu dang la flow form rui ro/phap ly.
- Launchpad bridge/claim/swap/rebalance neu la hanh dong giao dich/claim thuc te.

Ly do: cac flow nay co rui ro tai chinh, bao mat, hoac phap ly. Sticky CTA co the dung ve UX vi user can thay hanh dong chinh va trang thai disabled/enabled lien tuc.

## 7. Work items uu tien cao

### P1. DCA Home floating create plan CTA

Status: [x] Completed

Files:

- `flutter_app/lib/features/dca/presentation/pages/dca_page_part_01.dart`
- `flutter_app/lib/features/dca/presentation/pages/dca_page_part_03.dart`

Problem:

- `Tao ke hoach moi` dang `Positioned` o day man hinh.
- Hero/overview da co action tao moi nen sticky CTA bi trung ngu canh.
- Sticky CTA lam tang `bottomInset` va chiem vung doc danh sach plans/history.

Target behavior:

- Bo floating CTA.
- Giu action tao moi trong overview card hoac them inline CTA compact o cuoi tab plans.
- Neu danh sach plans empty, dat CTA trong empty state.
- Khong thay doi create sheet behavior.

Acceptance:

- Khong con `Positioned` CTA tao moi trong DCA Home.
- Scroll content khong bi mat vung day.
- `DCAPage.createPlanKey` van co the tap duoc trong test, neu key duoc doi vi tri thi update test tuong ung.

Implementation note:

- Removed the bottom `Positioned` create CTA.
- Reused the overview `Tao moi` action with `DCAPage.createPlanKey`.
- Kept create sheet behavior unchanged.

### P2. DCA Rebalance Config sticky preview/save

Status: [x] Completed

Files:

- `flutter_app/lib/features/dca/presentation/pages/dca_rebalance_config_page.dart`
- `flutter_app/lib/features/dca/presentation/pages/dca_rebalance_config_page_part_02.dart`

Problem:

- `_StickyActions` co 2 nut `Xem truoc` va `Luu cau hinh` noi co dinh.
- User phai set allocation/strategy truoc, nen action nen nam sau settings/summary.
- Co nguy co che slider/card cuoi tren mobile.

Target behavior:

- Chuyen action thanh inline section sau `_AdvancedSettings` hoac them `_RebalanceActionSummary` cuoi content.
- `Xem truoc` la primary neu valid; `Luu cau hinh` chi thuc hien qua preview/confirm sheet.
- Neu van giu 2 nut, dat trong inline row va khong overlay.
- Preview sheet van phai hien tren bottom nav va khong bi che.

Acceptance:

- Khong con `_StickyActions` duoc dat bang `Positioned(bottom: stickyBottom)`.
- Disabled state van ro khi total percent != 100.
- Preview confirm van tinh fee/trade preview dung.

Implementation note:

- Replaced `_StickyActions` with inline `_InlineRebalanceActions` after advanced settings.
- Kept preview as the required path before save.
- Added extra bottom safe padding after emulator QA so the inline row stays above bottom nav at the end of scroll.

### P3. DCA Dynamic Amount floating actions

Status: [x] Completed

Files:

- `flutter_app/lib/features/dca/presentation/pages/dca_dynamic_amount_page.dart`
- `flutter_app/lib/features/dca/presentation/pages/dca_dynamic_amount_page_part_02.dart`

Problem:

- `_FloatingActions` gom settings + `Ap dung chien luoc` noi o day.
- Settings da co the nam tren header, action apply nen gan voi config/explainer.

Target behavior:

- Giu settings trong header action hien co.
- Bo nut settings o floating row.
- Dat `Ap dung chien luoc` inline sau `_StrategyExplainer` hoac sau `_DynamicDisclaimer`.
- Giu snackbar behavior khi apply neu hien tai chi demo, hoac route ve DCA nhu cu.

Acceptance:

- Khong con `_FloatingActions` o day man hinh.
- `DCADynamicAmount.applyKey` van ton tai va tap duoc.
- Khong tang chieu cao card/section bat thuong.

Implementation note:

- Removed the floating apply/settings row.
- Kept settings in the header action.
- Added inline `_ApplyStrategyAction` after the dynamic disclaimer.
- Fixed a narrow-constraint `LayoutBuilder` width calculation found during emulator QA.

### P4. DCA Portfolio Optimizer floating actions

Status: [x] Completed

Files:

- `flutter_app/lib/features/dca/presentation/pages/dca_portfolio_optimizer_page.dart`
- `flutter_app/lib/features/dca/presentation/widgets/dca_portfolio_optimizer_floating_actions.dart`

Problem:

- Floating row co share, settings, `Ap dung phan bo`.
- Share da co header action; settings co the la header action hoac inline tren drift banner.
- Footer chiem day man hinh tren cac tab frontier/correlation/backtest/risk.

Target behavior:

- Giu share tren header.
- Dua drift settings vao `_DriftBanner` hoac header action compact.
- Dat `Ap dung phan bo` inline sau `_TabContent` hoac trong summary cua tab frontier.
- Khong lam mat `DCAPortfolioOptimizer.applyKey` va `driftSettingsKey`.

Acceptance:

- Khong con `_FloatingActions` overlay.
- Cac tab van scroll day du va khong bi che.
- Route sang `AppRoutePaths.dcaRebalanceConfig` van dung.

Implementation note:

- Removed the floating share/settings/apply row.
- Kept share in the header.
- Moved drift settings into `_DriftBanner`.
- Added inline `_OptimizerApplyAction` after tab content.

### P5. Savings Auto Rebalance duplicate sticky CTA

Status: [x] Completed

Files:

- `flutter_app/lib/features/earn/presentation/pages/savings_auto_rebalance_page.dart`
- `flutter_app/lib/features/earn/presentation/pages/savings_auto_rebalance_page_part_01.dart`

Problem:

- `_DriftStatusCard` da co nut inline `Xem truoc`.
- Trang van them sticky CTA `Tai can bang ngay`.
- Hai action cung mo preview, gay trung va chiem dien tich.

Target behavior:

- Bo sticky CTA.
- Tang prominence cho nut inline trong `_DriftStatusCard` khi `needsAction`.
- Neu can primary action cuoi trang, dat inline sau stats/summary, khong overlay.

Acceptance:

- `SavingsAutoRebalancePage.previewButtonKey` van duoc gan cho action con lai.
- Preview sheet van mo dung.
- Tab khac khong bi them bottom padding du thua.

Implementation note:

- Removed duplicate sticky `Tai can bang ngay`.
- Kept the existing inline `Xem truoc` action in `_DriftStatusCard` as the single primary preview action.

### P6. Launchpad Notification Sound save footer

Status: [x] Completed

Files:

- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_notif_sound_page.dart`
- `flutter_app/lib/features/launchpad/presentation/widgets/launchpad_notif_sound_footer.dart`

Problem:

- Settings page dang co sticky save footer luon nam o day.
- Day khong phai flow tai chinh/rui ro cao.
- Footer con hien saved message nen co the chiem them chieu cao.

Target behavior:

- Chuyen save action thanh inline section cuoi settings.
- Hoac chi hien compact dirty bar khi `_hasChanges == true`, khong hien khi chua thay doi.
- Saved state nen la inline toast/snackbar hoac status text nho trong footer inline.

Acceptance:

- Khong con footer save co dinh khi chua co thay doi.
- Khi co thay doi, user van thay action save ro rang.
- Khong che category sound section/DND settings.

Implementation note:

- Replaced sticky `_SaveFooter` with inline `_InlineSaveActions` at the end of settings content.
- Kept existing keys and save behavior.
- The save action remains visible at the correct content location and no longer overlays categories.

## 8. Work items can nhac sau Phase 1

### P7. Staking Suitability Assessment

Status: [ ] Defer

File:

- `flutter_app/lib/features/earn/presentation/pages/staking_suitability_assessment_page.dart`

Recommendation:

- Co the giu sticky previous/next vi day la quiz wizard.
- Neu toi uu, lam footer compact hon va dam bao cau hoi cuoi khong bi che.

### P8. Staking Risk Score Calculator

Status: [ ] Defer

File:

- `flutter_app/lib/features/earn/presentation/pages/staking_risk_score_calculator_page.dart`

Recommendation:

- Co the dat `proceedLabel` inline sau recommendations.
- Chi sua neu emulator cho thay footer chiem qua nhieu dien tich.

### P9. Trade Provider Application

Status: [ ] Defer

File:

- `flutter_app/lib/features/trade/presentation/pages/provider_application_page.dart`

Recommendation:

- Day la multi-step flow nen sticky `Tiep tuc` co the chap nhan.
- Neu sua, can lam theo tung step va test day du validation.

## 9. Sticky footer duoc phep giu

Status: [x] Audit only complete

Cac file/man hinh duoc phep giu sticky trong vong nay:

- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_swap_aggregator_page.dart`
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_rebalance_page.dart`
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_bridge_compare_page.dart`
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_batch_claim_page.dart`
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_limit_orders_page.dart`
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_dca_builder_page.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_ad_detail_page.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_create_ad_page.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_payment_method_add_page.dart`
- `flutter_app/lib/features/wallet/presentation/pages/address_add_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/copy_configuration_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/copy_confirmation_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/bot_emergency_stop_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/dispute_resolution_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/complaint_submission_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/bot_optimization_page.dart`

Guardrail cho nhom nay:

- [x] Scroll content co bottom padding du de khong bi che trong cac target da sua.
- [x] CTA target khong bi bottom nav che sau emulator QA.
- [x] Disabled/loading state target van ro rang.
- [x] Khong co 2 primary CTA cung chuc nang trong cac target P1-P6.
- [x] Bottom sheet guardrail pass; direct `showModalBottomSheet` = 0.

## 10. Thu tu implement de tranh sua sai

### Phase 0 - Preflight

- [x] Chay `git status --short` de biet dirty worktree.
- [x] Doc source file cua tung item truoc khi sua.
- [x] Tim test hien co bang `rg "DCA|SavingsAutoRebalance|LaunchpadNotif" flutter_app/test`.
- [x] Khong sua file ngoai item dang lam, tru nhung file test/doc can update cho item.

### Phase 1 - Sua high-confidence inline conversion

- [x] P1 DCA Home
- [x] P2 DCA Rebalance Config
- [x] P3 DCA Dynamic Amount
- [x] P4 DCA Portfolio Optimizer
- [x] P5 Savings Auto Rebalance
- [x] P6 Launchpad Notification Sound

### Phase 2 - Update tests

- [x] Update widget tests neu keys/position thay doi.
- [x] Existing screen tests cover CTA/key behavior for target screens.
- [x] Giu `bottom_sheet_guardrail_test.dart` pass.
- [x] New inline action widgets are covered by existing focused feature tests.

### Phase 3 - Visual/emulator QA

- [x] Chay emulator cho tung man hinh da sua.
- [x] Kiem tra emulator phone mac dinh `emulator-5554`.
- [x] Cuon den cuoi trang, xac nhan target CTA khong bi che.
- [x] Kiem tra bottom nav khong de len target CTA/sheet.
- [x] Chup screenshot vao `flutter_app/run-artifacts/bottom_cta_footer_qa/`.

### Phase 4 - Final verification

Chay tu `flutter_app/`:

```bash
dart format .
flutter analyze
flutter test test/quality/bottom_sheet_guardrail_test.dart --reporter=compact
flutter test test/features/dca --reporter=compact
flutter test test/features/earn --reporter=compact
flutter test test/features/launchpad --reporter=compact
```

Neu sua shared layout hoac nhieu module, chay them:

```bash
flutter test --reporter=compact
```

## 11. Acceptance criteria toan bo

Hoan thanh khi:

- [x] 6 item P1-P6 duoc xu ly.
- [x] Khong con CTA overlay khong can thiet trong DCA/Savings/Launchpad settings target.
- [x] Arena Studio van giu action inline, khong rollback ve sticky.
- [x] Bottom sheet guardrail van pass, direct `showModalBottomSheet` ngoai helper = 0.
- [x] Cac flow tai chinh/rui ro cao khong bi chuyen inline nham.
- [x] Mobile scroll cuoi trang khong bi che boi bottom nav/footer cho target CTA.
- [x] Tests lien quan pass; full suite co loi unrelated stale audit artifacts duoc ghi ro ben duoi.
- [x] Co screenshot/emulator evidence cho cac man hinh da sua.

## 12. Regression checklist truoc khi merge

- [x] DCA Home: create plan action van mo sheet/flow dung.
- [x] DCA Rebalance: invalid total percent khong cho preview/save.
- [x] DCA Rebalance: preview sheet khong bi bottom nav che trong focused test/emulator flow.
- [x] DCA Dynamic Amount: apply route dung.
- [x] DCA Portfolio Optimizer: share/settings/apply khong trung nhau.
- [x] Savings Auto Rebalance: chi con mot action preview/rebalance chinh.
- [x] Launchpad Notification Sound: save chi hien dung trang thai dirty/saved.
- [x] P2P/Wallet/Copy/Bot Emergency sticky footer khong bi thay doi ngoai y muon.
- [x] Khong xoa/doi key test neu khong update test tuong ung.

## 13. Notes cho nguoi implement

- Uu tien sua tung man hinh mot, chay focused test ngay sau do.
- Neu mot CTA co business risk, dung lai va phan loai lai thay vi chuyen inline.
- Khong refactor shared `VitStickyFooter` trong Phase 1; chi sua callsite cu the.
- Neu can tao widget moi, dat trong feature presentation widgets/part hien co theo pattern repo.
- Dung `VitCtaButton`, `VitCard`, `VitPageContent`, token theme hien co.
- Khong them landing-style hero, gradient/orb, hoac decoration khong lien quan.
- Khong lam text button qua dai tren mobile; icon-only phai co tooltip/semantics.

## 14. Execution log 2026-06-04

Code changes completed:

- P1: DCA Home create plan action moved out of bottom overlay and into existing overview action.
- P2: DCA Rebalance Config preview/save converted to inline action card after settings.
- P3: DCA Dynamic Amount floating action row removed; apply action moved inline after disclaimer.
- P4: DCA Portfolio Optimizer floating action row removed; apply action moved inline and drift settings moved into drift banner.
- P5: Savings Auto Rebalance duplicate sticky CTA removed; inline preview remains the single primary action.
- P6: Launchpad Notification Sound sticky save footer converted to inline save section.

Verification commands:

```bash
dart format .
dart format lib test
flutter analyze
flutter test test/quality/bottom_sheet_guardrail_test.dart --reporter=compact
flutter test test/features/dca --reporter=compact
flutter test test/features/earn --reporter=compact
flutter test test/features/launchpad --reporter=compact
flutter test --reporter=compact
```

Verification results:

- `dart format .`: failed because stale generated Android `build/` path could not be listed. This is a generated build artifact issue, not source formatting.
- `dart format lib test`: pass.
- `flutter analyze`: pass, no issues found.
- `flutter test test/quality/bottom_sheet_guardrail_test.dart --reporter=compact`: pass.
- `flutter test test/features/dca --reporter=compact`: pass after final DCA fixes.
- `flutter test test/features/earn --reporter=compact`: pass.
- `flutter test test/features/launchpad --reporter=compact`: pass.
- `flutter test --reporter=compact`: failed only on unrelated stale audit artifacts:
  - `test/quality/back_navigation_behavior_guardrail_test.dart`
  - `test/quality/home_entry_back_navigation_guardrail_test.dart`
  - `test/quality/top_header_action_guardrail_test.dart`
  - `test/quality/top_header_global_access_policy_guardrail_test.dart`

Emulator QA evidence:

- Device: `emulator-5554`.
- Screenshots saved under `flutter_app/run-artifacts/bottom_cta_footer_qa/`.
- Verified fixed target CTA states:
  - `bc02_dca_rebalance_config_cta_fixed.png`
  - `bc03_dca_dynamic_amount_bottom_fixed.png`
  - `bc04_dca_portfolio_optimizer_bottom.png`
  - `bc05_earn_savings_rebalance_bottom.png`
  - `bc06_launchpad_notif_sound_bottom.png`

QA finding fixed during execution:

- `DCA Dynamic Amount` emulator run exposed a `LayoutBuilder` negative width assertion in `_ConfigSection`; fixed by clamping narrow constraints and falling back to single-column layout.
- `DCA Rebalance Config` emulator run exposed insufficient end-of-scroll padding for inline preview/save; fixed by adding additional bottom safe padding.
