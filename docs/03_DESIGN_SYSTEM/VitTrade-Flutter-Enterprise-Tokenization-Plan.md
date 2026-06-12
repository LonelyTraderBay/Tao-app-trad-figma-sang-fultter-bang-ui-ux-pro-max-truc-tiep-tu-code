# VitTrade Flutter Enterprise Tokenization Plan

Updated: 2026-06-11

Scope: Flutter frontend in `flutter_app/`.

Muc tieu cua tai lieu nay la tao mot ke hoach theo doi chi tiet de token hoa
toan bo nhung thanh phan UI co the token hoa, tao quy dinh chung cho typography,
spacing, radius, card, sizing, icon, color, state, va layout density de dam bao
VitTrade dung chuan Flutter enterprise-grade.

## Ket Luan Hien Tai

He thong shared foundation da ton tai va tuong doi day du:

- Theme tokens: `flutter_app/lib/app/theme/`
- Layout primitives: `VitPageLayout`, `VitPageContent`, `VitHeader`,
  `VitTopChrome`, `VitBottomNav`
- Shared widgets: `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`,
  `VitStatusPill`, `VitModuleHeroCard`, `VitMetricCard`, `VitServiceTile`

Van de chinh khong phai la thieu foundation. Van de la nhieu screen/widget dang
override token bang so rieng, lam UI bi lech nhip ve font, khoang cach, do bo
card, chieu cao component, va mat do thong tin tren man hinh dien thoai.

So lieu audit tinh tai 2026-06-11:

| Hang muc | Hien trang |
| --- | --- |
| Feature `fontSize` hardcoded | 1,090 occurrences |
| So muc font numeric khac nhau | 31 values |
| Feature `EdgeInsets` | 4,744 occurrences |
| `EdgeInsets` numeric hardcoded | 1,866 occurrences |
| Feature numeric radius | 245 occurrences |
| So radius numeric khac nhau | 22 values |
| Feature `Container` | 1,838 calls |
| Feature `BoxDecoration` | 2,308 calls |
| Feature line-height override around `height: 1` | 2,500+ lines |
| Root page bundles | 390 |
| Root page bundles missing `VitPageLayout` | 1 |
| Root page bundles missing `VitPageContent` | 19 |

Ket luan: scaffold tong the kha on; can tap trung vao token hoa ben trong
section/card/widget va bo sung audit visual-density.

## Source Of Truth

Token source of truth bat buoc:

| Nhom | File hien tai | Huong mo rong |
| --- | --- | --- |
| Color | `app_colors.dart`, `app_asset_colors.dart`, `app_data_viz_colors.dart` | Tach semantic state/finance/status neu can |
| Module accent | `app_module_accents.dart` | Dung cho accent, khong dung lam page/card background |
| Gradient | `app_gradients.dart` | Chi dung cho hero/visual accent da duoc phe duyet |
| Typography | `app_text_styles.dart` | Them semantic styles: amount, numeric, badge, control, nav |
| Spacing | `app_spacing.dart` | Them semantic insets/gaps/density tokens |
| Radius | `app_radii.dart` | Them pill/sheet/chart/avatar radius neu can |
| Header | `app_top_header_tokens.dart` | Giu rieng cho top chrome/header |
| Device | `device_metrics.dart` | Dung cho shell, nav, safe area, QA frame |

Shared component source of truth bat buoc:

| Component | Dung cho |
| --- | --- |
| `VitPageLayout` | Page background, bottom inset, semantics |
| `VitPageContent` | Page padding va section gap |
| `VitPageSection` | Section label va section rhythm |
| `VitCard` | Card surface/radius/border/tap behavior |
| `VitModuleHeroCard` | Hero card theo module nhung van dung surface chung |
| `VitMetricCard` | Metric/stat cards |
| `VitServiceTile` | Shortcut/action/service grid |
| `VitCtaButton` | CTA height, text, icon, state |
| `VitInput`, `VitSearchBar` | Form/search field |
| `VitTabBar`, `VitStatusPill` | Tabs/status/badges |

## Nguyen Tac Enterprise-Grade

1. Token truoc, component sau, screen sau.
   Khong sua tung man hinh bang so moi neu token hoac shared primitive chua ro.

2. Token phai co y nghia semantic.
   Vi du: `AppSpacing.cardPaddingCompact` tot hon viec lap lai `EdgeInsets.all(12)`.

3. Module identity chi la accent layer.
   Khong tao page background, card background, input background rieng cho tung module.

4. Phone-first tu 360 px.
   Layout phai toi uu vung nhin dau tien, khong chi "render khong loi".

5. Audit phai bat duoc drift.
   Neu mot route van A-grade nhung co nhieu local font/spacing/radius thi audit hien
   tai chua du nghiem.

6. Khong token hoa nhung so co y nghia logic thuan tuy.
   Vi du: chart scale, percent, animation math, canvas coordinate dac thu co the giu
   local neu duoc comment ro hoac nam trong painter-specific helper.

## Quy Dinh Bat Buoc

### Typography

Bat buoc:

- Dung `AppTextStyles` hoac semantic extension tu `AppTextStyles`.
- Dung `fontFeatures: AppTextStyles.tabularFigures` cho so tien, P/L, ty le,
  gia, order book, quantity.
- Tao style rieng cho numeric/amount thay vi rai `fontFamily: 'Roboto'` hoac
  `fontFamily: 'monospace'`.
- Text tren mobile phai uu tien `maxLines`, `overflow`, va line-height de tranh
  che/vo layout.

Cam:

- Khong dung `fontSize: <number>` trong feature code, tru truong hop da duoc
  liet ke trong exception.
- Khong dung `FontWeight.w800`/`w900` truc tiep trong feature code.
- Khong dung `height: 1` hang loat cho body/caption text.
- Khong dung font family local cho UI text thong thuong.

Token can them:

| Token de xuat | Gia tri khoi diem | Dung cho |
| --- | --- | --- |
| `AppTextStyles.badge` | 10/11, bold, tight | Badge/status small |
| `AppTextStyles.control` | 13/14, medium | Button/tab/control label |
| `AppTextStyles.amountSm` | 18, bold, tabular | So tien trong card nho |
| `AppTextStyles.amountMd` | 26/28, bold, tabular | Amount input/hero secondary |
| `AppTextStyles.amountLg` | 34, bold, tabular | Balance hero |
| `AppTextStyles.numericMicro` | 10, tabular | Order book, address short, compact data |
| `AppTextStyles.navLabel` | 10/11, medium | Bottom nav label |

### Spacing

Bat buoc:

- Dung `AppSpacing` cho gap, padding, grid spacing, control height.
- Neu mot spacing lap lai tu 3 man hinh tro len, promote thanh token.
- Dung `VitPageContent` cho page body padding/gap.

Cam:

- Khong them `EdgeInsets.all(12)`, `EdgeInsets.symmetric(horizontal: 16)`,
  `SizedBox(height: 11)`, `SizedBox(width: 10)` truc tiep trong feature code.
- Khong tao local spacing ladder trong tung module.

Token can them:

| Token de xuat | Gia tri khoi diem | Dung cho |
| --- | --- | --- |
| `AppSpacing.gapXs` | 4/5 | Gap rat nho |
| `AppSpacing.gapSm` | 8 | Row/icon gap |
| `AppSpacing.gapMd` | 13/16 | Section internal gap |
| `AppSpacing.gapLg` | 21 | Section external gap |
| `AppSpacing.cardPaddingCompact` | EdgeInsets.all(12/13) | Compact card |
| `AppSpacing.cardPadding` | EdgeInsets.all(16) hoac x5 neu giu ladder hien tai | Standard card |
| `AppSpacing.cardPaddingHero` | EdgeInsets.fromLTRB(...) | Hero card |
| `AppSpacing.pageHorizontal` | 20 | Page horizontal padding |
| `AppSpacing.gridGap` | 8/13 | Repeated grid gap |
| `AppSpacing.bottomContentInset` | semantic | Scroll inset tren mobile |

### Radius

Bat buoc:

- Dung `AppRadii` hoac `VitCardRadius`.
- Dung radius semantic cho pill/sheet/avatar/chart neu can.

Cam:

- Khong dung `BorderRadius.circular(<number>)` trong feature code.
- Khong dung `999` truc tiep cho pill; phai co token `AppRadii.pillRadius`.
- Khong tao radius local cho card neu `VitCard` da dap ung.

Token can them:

| Token de xuat | Gia tri khoi diem | Dung cho |
| --- | --- | --- |
| `AppRadii.pill` / `pillRadius` | 999 | Pills/badges |
| `AppRadii.sheetTopRadius` | 22/24 | Bottom sheet |
| `AppRadii.avatar` | 999 hoac semantic | Avatar/circle surface |
| `AppRadii.chart` | 8/13 | Chart panels |

### Sizing Va Density

Bat buoc:

- Control height dung token: input, CTA, compact button, icon button, nav item.
- Card/list/grid phai co density variant: compact, standard, relaxed.
- Shortcut/service tile phai co responsive density cho 360 px.

Cam:

- Khong dung fixed height/width neu co the dung constraints/aspect ratio/token.
- Khong de hero/card chiem qua nhieu first viewport ma it thong tin.
- Khong dung grid hardcode neu noi dung co the can layout responsive theo density.

Token/component can them:

| Hang muc | De xuat |
| --- | --- |
| `VitDensity` | `compact`, `standard`, `relaxed` |
| `VitServiceTileDensity` | compact tile cho Home/mobile |
| `VitMetricGrid` | Grid metric 2 cot/3 cot co mainAxisExtent token |
| `VitListRow` | Row height/padding/avatar/icon theo token |
| `VitAmountInput` | Amount field dung amount styles + input height token |

### Color, Surface, Border

Bat buoc:

- Dung `AppColors` va `AppModuleAccents`.
- Surface/card/input/bottom nav background phai theo global foundation.
- Module accent chi dung cho icon, border alpha, tab indicator, pill, chart marker.

Cam:

- Khong tao local color palette bang `Color(0x...)` trong feature code.
- Khong dung accent module lam background chinh cua page/card/input.
- Khong tao card border alpha rieng neu co token/chuan shared.

### Card Va Container

Bat buoc:

- Dung `VitCard`, `VitMetricCard`, `VitModuleHeroCard` truoc khi tao `Container`
  co `BoxDecoration`.
- Neu can custom card pattern lap lai, tao shared component moi.

Cam:

- Khong lap lai `Container + BoxDecoration + Border + Radius + Padding` trong
  nhieu feature.
- Khong long card trong card neu khong phai repeated item, modal, hoac framed tool.
- Khong tao surface treatment rieng cho tung module.

Exception hop le:

- CustomPainter/chart panel noi bo.
- Visual QA/dev tools.
- Highly specialized interactive canvas/tool screen.
- One-off security/risk disclosure panel neu da co ly do va khong lap lai.

## Phase Theo Doi Cong Viec

### P0 - Dong Bang Quy Dinh Va Audit Moi

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| P0.1 | Chot tai lieu tokenization plan nay lam rule tham chieu | `[x]` | Link tu docs/design guidelines hoac PR checklist |
| P0.2 | Tao `design_token_consistency_audit.dart` | `[x]` | Audit font/spacing/radius/sizing theo root page bundle |
| P0.3 | Them test guardrail cho audit token | `[x]` | `test/quality/design_token_consistency_guardrail_test.dart` |
| P0.4 | Xac dinh allowlist exception | `[x]` | Tool/dev/chart/canvas exceptions ro rang |
| P0.5 | Tao report CSV/MD | `[x]` | `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.*` |

Acceptance gate P0:

- Audit chay duoc trong `flutter_app/`.
- Report phan biet root page, part files, shared widgets, feature widgets.
- Co baseline hien tai de theo doi giam dan, chua can fail CI ngay neu debt con lon.

### P1 - Mo Rong Token Foundation

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| P1.1 | Mo rong `AppTextStyles` voi semantic numeric/control/badge/amount | `[x]` | Updated `app_text_styles.dart` |
| P1.2 | Mo rong `AppSpacing` voi semantic card/page/grid/list insets | `[x]` | Updated `app_spacing.dart` |
| P1.3 | Mo rong `AppRadii` voi pill/sheet/avatar/chart radius | `[x]` | Updated `app_radii.dart` |
| P1.4 | Tao density enum/shared helper | `[x]` | `VitDensity` hoac equivalent |
| P1.5 | Cap nhat shared component dung token moi | `[x]` | `VitCard`, `VitServiceTile`, `VitCtaButton`, `VitInput`, `VitTabBar` |

Acceptance gate P1:

- Shared components khong con hardcode so co the token hoa.
- Feature code co du token de thay the pattern pho bien ma khong can tao so moi.
- `flutter analyze` pass.
- Focused shared widget tests pass.

### P2 - Chuan Hoa Home Va Global Chrome

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| P2.1 | Toi uu Home first viewport density | `[x]` | Hero + product grid gon hon |
| P2.2 | Chuan hoa `VitServiceTile` compact/standard variants | `[x]` | Service grid dung density |
| P2.3 | Chuan hoa bottom nav label/badge/radius tokens | `[x]` | No local numeric font/radius in nav |
| P2.4 | Chuan hoa root header/title scale | `[x]` | Header tokens mapped to typography scale |
| P2.5 | Them visual-density snapshot/manual QA checklist cho Home | `[x]` | 360/440/480 px evidence |

Acceptance gate P2:

- First viewport Home hien nhieu gia tri hon nhung khong bi chat/roi.
- Service grid khong chiem qua nhieu chieu cao voi thong tin thap.
- Bottom nav khong che noi dung quan trong khi route load.

### P3 - Chuan Hoa P0 Financial Screens

Thu tu uu tien:

1. Wallet overview/assets/history.
2. Deposit/Withdraw/Transfer.
3. Address Book/Add Address.
4. Token Approval/Revoke.
5. Trade basic order/history/receipt.
6. P2P home/order/payment method/dispute.
7. Markets list/pair detail.
8. Profile/security/KYC.

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| P3.1 | Wallet token pass | `[x]` | Giam local font/spacing/radius trong wallet |
| P3.2 | Trade token pass | `[x]` | Giam local font/spacing/radius trong trade |
| P3.3 | Markets token pass | `[x]` | Chart/list/price rows dung token |
| P3.4 | P2P token pass | `[x]` | Order/payment/dispute cards dong bo |
| P3.5 | Profile/security token pass | `[x]` | Form/list/security rows dong bo |

Checkpoint P3.1:

- 2026-06-12: Hoan thanh batch Wallet overview/history dau tien:
  `wallet_page_*` allocation/asset/DCA sections va
  `transaction_history_page_*`.
- Debt giam theo audit:
  `transaction_history_page_common.dart` 6 -> 1,
  `transaction_history_page_sections.dart` 19 -> 8,
  `wallet_page_allocation_sections.dart` 8 -> 2,
  `wallet_page_asset_sections.dart` 9 -> 7,
  `wallet_page_dca_tool_sections.dart` 9 -> 7.
- Test da chay: focused Wallet overview/history, responsive visual QA matrix
  360/440/480, accessibility semantics critical flows, `flutter analyze`.
- 2026-06-12: Hoan thanh batch Wallet asset detail/transaction detail:
  `asset_detail_page_sections.dart`,
  `transaction_detail_page_sections.dart`, va
  `transaction_detail_page_common.dart`.
- Debt giam theo audit:
  `asset_detail_page_sections.dart` 12 -> 8,
  `transaction_detail_page_sections.dart` 16 -> 9,
  total audit debt 41214 -> 41181 sau batch detail.
- Test da chay: focused `asset_detail_page_test.dart` va
  `transaction_detail_page_test.dart`, responsive visual QA matrix 360/440/480
  voi `Asset Detail`/`Transaction Detail`, `flutter analyze`, va design token
  audit.
- 2026-06-12: Hoan thanh batch Wallet deposit/withdraw/transfer:
  `deposit_page_sections.dart`, `withdraw_form_sections.dart`,
  `withdraw_amount_actions.dart`, `withdraw_network_picker.dart`,
  `withdraw_preview_sheet.dart`, va cac `wallet_transfer_*` widgets.
- Debt giam theo audit:
  `deposit_page_sections.dart` 9 -> 6,
  `withdraw_form_sections.dart` 6 -> 2,
  `withdraw_amount_actions.dart` 2 -> 0,
  `withdraw_network_picker.dart` 2 -> 0,
  `withdraw_preview_sheet.dart` 1 -> 0,
  `wallet_transfer_history_picker.dart` 13 -> 4,
  `wallet_transfer_confirm_sheet.dart` 9 -> 2,
  `wallet_transfer_asset_amount.dart` 5 -> 4,
  total audit debt 41181 -> 41146 sau batch deposit/withdraw/transfer.
- Test da chay: focused `deposit_page_test.dart`, `withdraw_page_test.dart`,
  `transfer_page_test.dart`, responsive visual QA matrix 360/440/480 voi
  `Deposit`/`Withdraw`/`Transfer`, `flutter analyze`, va design token audit.
- 2026-06-12: Hoan thanh batch Wallet address book/add address:
  `wallet_address_book_*`, `wallet_address_add_*`, va
  `address_add_page.dart` wrapper.
- Debt giam theo audit:
  `wallet_address_book_controls.dart` 16 -> 0,
  `wallet_address_book_list.dart` 47 -> 6,
  `wallet_address_book_security.dart` 20 -> 7,
  `wallet_address_add_form.dart` 17 -> 0,
  `wallet_address_add_selectors.dart` 14 -> 2,
  `wallet_address_add_common.dart` 24 -> 4,
  `wallet_address_add_preview.dart` 37 -> 7,
  `wallet_address_add_agreement.dart` 35 -> 14,
  total audit debt 41146 -> 40832 sau batch address.
- Test da chay: focused `address_book_page_test.dart`,
  `address_add_page_test.dart`, responsive visual QA matrix 360/440/480 voi
  `Address Book`/`Address Add`, `flutter analyze`, va design token audit.
- 2026-06-12: Hoan thanh batch Wallet token approval/revoke:
  `wallet_token_active_approvals_tab.dart`,
  `wallet_token_approval_cards.dart`, `wallet_token_approval_badges.dart`,
  `wallet_token_approval_common.dart`, `wallet_token_approval_settings_tab.dart`,
  `wallet_token_approval_history_tab.dart`, `wallet_token_approval_tabs.dart`,
  va `wallet_token_revoke_sheet.dart`.
- Debt giam theo audit:
  `wallet_token_active_approvals_tab.dart` 37 -> 4,
  `wallet_token_approval_cards.dart` 30 -> 4,
  `wallet_token_approval_badges.dart` 23 -> 6,
  `wallet_token_approval_common.dart` 19 -> 6,
  `wallet_token_approval_settings_tab.dart` 29 -> 5,
  `wallet_token_approval_history_tab.dart` 20 -> 0,
  `wallet_token_approval_tabs.dart` 6 -> 3,
  `wallet_token_revoke_sheet.dart` 10 -> 0,
  total audit debt 40832 -> 40686 sau batch token approval/revoke.
- Test da chay: focused `wallet_token_approval_page_test.dart`, responsive
  visual QA matrix 360/440/480 voi `Token Approval`, full responsive visual QA
  matrix, `flutter analyze`, va design token audit.
- 2026-06-12: Hoan thanh batch Wallet network status:
  `network_status_cards_stats.dart`, `network_status_legend_common.dart`,
  `network_status_summary.dart`, va `network_status_page.dart`.
- Debt giam theo audit:
  `network_status_cards_stats.dart` 37 -> 8,
  `network_status_legend_common.dart` 23 -> 8,
  `network_status_summary.dart` 18 -> 4,
  `network_status_page.dart` 5 -> 0,
  total audit debt 40686 -> 40502 sau batch network status.
- Test da chay: focused `network_status_page_test.dart`, responsive visual QA
  matrix 360/440/480 voi `Network Status`, `flutter analyze`, va design token
  audit.
- 2026-06-12: Hoan thanh batch Wallet pending deposits:
  `pending_deposits_page.dart`, `pending_deposits_page_sections.dart`,
  `pending_deposits_page_common.dart`, va them `Pending Deposits` vao
  responsive visual QA matrix.
- Debt giam theo audit:
  `pending_deposits_page_sections.dart` 38 -> 12,
  `pending_deposits_page_common.dart` 20 -> 4,
  `pending_deposits_page.dart` 2 -> 0,
  total audit debt 40502 -> 40372 sau batch pending deposits.
- Test da chay: focused `pending_deposits_page_test.dart`, responsive visual QA
  matrix 360/440/480 voi `Pending Deposits`, `flutter analyze`, va design token
  audit.
- 2026-06-12: Hoan thanh batch Wallet portfolio analytics:
  `portfolio_analytics_page.dart`, `portfolio_analytics_summary_switcher.dart`,
  `portfolio_analytics_metrics_assets.dart`,
  `portfolio_analytics_overview_chart.dart`, `portfolio_analytics_common.dart`,
  va them `Portfolio Analytics` vao responsive visual QA matrix.
- Debt giam theo audit:
  `portfolio_analytics_summary_switcher.dart` 38 -> 10,
  `portfolio_analytics_metrics_assets.dart` 29 -> 6,
  `portfolio_analytics_overview_chart.dart` 10 -> 2,
  `portfolio_analytics_common.dart` 2 -> 0,
  `portfolio_analytics_page.dart` 1 -> 0,
  total audit debt 40372 -> 40187 sau batch portfolio analytics.
- Test da chay: focused `portfolio_analytics_page_test.dart`, responsive visual
  QA matrix 360/440/480 voi `Portfolio Analytics`, `flutter analyze`, va design
  token audit.
- 2026-06-12: Hoan thanh batch Wallet health score:
  `wallet_health_score_page.dart`,
  `wallet_health_score_page_part_01.dart`,
  `wallet_health_score_page_part_02.dart`,
  `wallet_health_score_page_part_03.dart`, va them `Wallet Health` vao
  responsive visual QA matrix.
- Debt giam theo audit:
  `wallet_health_score_page_part_01.dart` 41 -> 4,
  `wallet_health_score_page_part_02.dart` 48 -> 8,
  `wallet_health_score_page_part_03.dart` 20 -> 5,
  `wallet_health_score_page.dart` 0 -> 0,
  total audit debt 40187 -> 40003 sau batch wallet health score.
- Test da chay: focused `wallet_health_score_page_test.dart`, responsive visual
  QA matrix 360/440/480 voi `Wallet Health`, `flutter analyze`, va design token
  audit.
- 2026-06-12: Hoan thanh batch Wallet dust converter:
  `dust_converter_page.dart`, `wallet_dust_converter_hero.dart`,
  `wallet_dust_converter_assets.dart`, `wallet_dust_converter_targets.dart`,
  `wallet_dust_converter_confirm.dart`, va them `Dust Converter` vao
  responsive visual QA matrix.
- Debt giam theo audit:
  `wallet_dust_converter_confirm.dart` 19 -> 8,
  `wallet_dust_converter_assets.dart` 18 -> 4,
  `wallet_dust_converter_hero.dart` 18 -> 4,
  `wallet_dust_converter_targets.dart` 15 -> 4,
  `dust_converter_page.dart` 10 -> 1,
  total audit debt 40003 -> 39835 sau batch dust converter.
- Test da chay: focused `dust_converter_page_test.dart`, responsive visual QA
  matrix 360/440/480 voi `Dust Converter`, `flutter analyze`, va design token
  audit.
- 2026-06-12: Hoan thanh batch Wallet gas optimizer:
  `wallet_gas_optimizer_page.dart`, `wallet_gas_optimizer_current.dart`,
  `wallet_gas_optimizer_trends.dart`, `wallet_gas_optimizer_tips.dart`, voi
  scroll padding/tab/card/chart/tip tokens.
- Debt giam theo audit:
  `wallet_gas_optimizer_current.dart` 57 -> 24,
  `wallet_gas_optimizer_tips.dart` 35 -> 13,
  `wallet_gas_optimizer_trends.dart` 15 -> 3,
  `wallet_gas_optimizer_page.dart` 1 -> 0,
  total audit debt 39835 -> 39632 sau batch gas optimizer.
- Test da chay: focused `wallet_gas_optimizer_page_test.dart`, responsive
  visual QA matrix 360/440/480 voi `Gas Optimizer`, `flutter analyze`, va
  design token audit.
- 2026-06-12: Hoan thanh batch Wallet multi-manager:
  `wallet_multi_manager_page.dart`, `wallet_manager_tabs.dart`,
  `wallet_manager_common.dart`, `wallet_manager_all_wallets_tab.dart`,
  `wallet_manager_distribution_chart.dart`, `wallet_manager_groups_tab.dart`,
  `wallet_manager_activity_tab.dart`, voi typography/spacing/radius tokens cho
  tab, summary, wallet cards, groups, activity row, distribution chart va risk
  notice.
- Debt giam theo audit:
  `wallet_manager_all_wallets_tab.dart` 71 -> 18,
  `wallet_manager_groups_tab.dart` 46 -> 15,
  `wallet_manager_common.dart` 45 -> 18,
  `wallet_manager_activity_tab.dart` 23 -> 8,
  `wallet_manager_distribution_chart.dart` 8 -> 3,
  `wallet_manager_tabs.dart` 6 -> 4,
  `wallet_multi_manager_page.dart` 1 -> 0,
  total audit debt 39632 -> 39497 sau batch multi-manager.
- Test da chay: focused `wallet_multi_manager_page_test.dart`, responsive
  visual QA matrix 360/440/480 voi `Multi Manager`, `flutter analyze`, va
  design token audit.
- P3.1 Wallet token pass da hoan tat; tiep theo P3.2 Trade token pass.

Checkpoint P3.2:

- 2026-06-12: Hoan thanh batch Trade basic order/history/receipt:
  `trade_page.dart`, `trade_page_part_01.dart`, `trade_page_part_02.dart`,
  `trade_page_part_03.dart`, `orders_history_page.dart`,
  `orders_history_page_common.dart`, `orders_history_page_sections.dart`,
  `order_receipt_page.dart`, `order_receipt_page_common.dart`,
  `order_receipt_page_sections.dart`, va them `Orders History`/`Order Receipt`
  vao responsive visual QA matrix.
- Debt giam theo audit:
  `order_receipt_page_sections.dart` 45 -> 18,
  `order_receipt_page_common.dart` 32 -> 13,
  `orders_history_page_sections.dart` 28 -> 9,
  `orders_history_page_common.dart` 14 -> 8,
  `trade_page_part_01.dart` 28 -> 10,
  `trade_page_part_02.dart` 28 -> 10,
  `trade_page_part_03.dart` 15 -> 4,
  `order_receipt_page.dart` 5 -> 1,
  `orders_history_page.dart` 1 -> 1,
  `trade_page.dart` 0 -> 0,
  total audit debt 39497 -> 39182 sau batch trade basic.
- Test da chay: focused `trade_page_test.dart`, `orders_history_page_test.dart`,
  `order_receipt_page_test.dart`, responsive visual QA matrix 360/440/480 voi
  `Trade`, `Orders History`, `Order Receipt`, `flutter analyze`, va design
  token audit.
- 2026-06-12: Hoan thanh batch P2P home/order/payment method/dispute:
  `p2p_dashboard_page*`, `p2p_order_page*`,
  `p2p_payment_methods_page*`, `p2p_payment_method_add_page*`,
  `p2p_payment_method_verification_page*`,
  `p2p_payment_method_ownership_page.dart`,
  `p2p_payment_method_cooling_period_page.dart`,
  `p2p_payment_method_history_page.dart`, `p2p_dispute_page.dart`,
  `p2p_dispute_detail_page.dart`, `p2p_dispute_evidence_page.dart`,
  `p2p_dispute_resolution_page.dart`, `p2p_disputes_page.dart`, va cac
  widget shared lien quan.
- Debt giam theo audit:
  `p2p_payment_method_cooling_period_page.dart` 10 -> 4,
  `p2p_payment_method_ownership_page.dart` 9 -> 5,
  `p2p_payment_method_verification_flow.dart` 9 -> 6,
  `p2p_payment_method_history_page.dart` 5 -> 2,
  `p2p_dispute_page.dart` 7 -> 2,
  `p2p_dispute_detail_page.dart` 1 -> 0,
  `p2p_payment_method_add_page.dart` 1 -> 0,
  `p2p_payment_method_verification_page.dart` 1 -> 0,
  total audit debt 39182 -> 38905 sau batch P2P.
- Test da chay: focused dashboard/order/payment-method/dispute suites,
  responsive visual QA matrix 360/440/480 voi `P2P Dashboard`, `P2P Order`,
  `P2P Payment Add`, `P2P Payment Methods`, `P2P Dispute`,
  `flutter analyze`, va design token audit. Payment-method delete test con
  warning tap off-screen khong fatal, test van pass.
- P3.4 P2P da hoan tat; tiep theo P3.3 Markets list/pair detail theo thu tu
  P3 cua execution prompt, sau do moi den Profile/security/KYC.
- 2026-06-12: Hoan thanh batch Markets list/pair detail:
  `market_list_page.dart`, `market_list_pairs.dart`,
  `market_list_filters.dart`, `market_list_tools.dart`,
  `market_list_movers.dart`, `market_list_discover.dart`,
  `pair_detail_page.dart`, `pair_detail_header_widgets.dart`,
  `pair_detail_chart_widgets.dart`, `pair_detail_order_widgets.dart`, va
  `pair_detail_painter_widgets.dart`.
- Debt giam theo audit:
  `pair_detail_chart_widgets.dart` 38 -> 12,
  `market_list_pairs.dart` 27 -> 8,
  `pair_detail_header_widgets.dart` 24 -> 6,
  `market_list_discover.dart` 21 -> 6,
  `pair_detail_order_widgets.dart` 10 -> 2,
  `market_list_movers.dart` 6 -> 0,
  `market_list_page.dart` 1 -> 0,
  `pair_detail_page.dart` 1 -> 0,
  total audit debt 38905 -> 38689 sau batch Markets list/pair detail.
- Test da chay: focused `market_list_page_test.dart`,
  `pair_detail_page_test.dart`, responsive visual QA matrix 360/440/480 voi
  `Markets` va `Pair Detail`, `flutter analyze`, va design token audit.
- P3.3 Markets da hoan tat; tiep theo P3.5 Profile/security/KYC.
- 2026-06-12: Hoan thanh batch Profile/security/KYC core:
  `profile_page.dart`, `profile_home_hero.dart`,
  `profile_home_menu_actions.dart`, `profile_home_vip_prediction.dart`,
  `profile_home_arena_stats.dart`, `security_page.dart`,
  `security_page_sections.dart`, `security_page_common.dart`,
  `kyc_page.dart`, `kyc_status_levels.dart`, va `kyc_details_privacy.dart`.
- Debt giam theo audit:
  `profile_page.dart` 0,
  `security_page.dart` 0,
  `kyc_page.dart` 0,
  `profile_home_vip_prediction.dart` 0,
  `kyc_details_privacy.dart` 0,
  `security_page_common.dart` 2,
  `profile_home_arena_stats.dart` 2,
  `kyc_status_levels.dart` 5,
  `profile_home_menu_actions.dart` 7,
  `profile_home_hero.dart` 8,
  `security_page_sections.dart` 12,
  total audit debt 38689 -> 38072 sau batch Profile/security/KYC.
- Ghi chu: cac file core tren khong con local `fontSize`, numeric
  `EdgeInsets`, numeric `SizedBox`, numeric radius, `FontWeight.w800/w900`,
  hoac text `height: 1`; residual debt con lai chu yeu la
  `Container`/`BoxDecoration` cho avatar, icon box, status surface va alert
  one-off.
- Test da chay: focused `profile_page_test.dart`, `security_page_test.dart`,
  `kyc_page_test.dart`, responsive visual QA matrix 360/440/480 voi `Profile`,
  `flutter analyze`, va design token audit.
- P3.5 Profile/security/KYC da hoan tat; tiep theo P4.1 Predictions token pass.

Acceptance gate P3:

- Khong lam mat preview/confirmation/risk disclosure.
- High-risk flows van co loading, error, offline, submitting, success states.
- `flutter test test/quality/accessibility_semantics_critical_flows_test.dart`
  pass.
- Responsive QA 360/440/480 pass va co visual review cho touched routes.

### P4 - Chuan Hoa Product Expansion Modules

Thu tu uu tien:

1. Predictions.
2. Arena.
3. Earn.
4. DCA.
5. Launchpad.
6. Referral/Rewards.
7. Admin/internal dashboards.

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| P4.1 | Predictions token pass | `[x]` | Probability/portfolio/order cards dong bo |
| P4.2 | Arena token pass | `[x]` | Points-only UI dong bo, khong wallet/PnL copy |
| P4.3 | Earn token pass | `[x]` | Financial product cards dong bo |
| P4.4 | DCA token pass | `[x]` | Recurring buy cards va flow surfaces dong bo |
| P4.5 | Launchpad token pass | `[x]` | Risk/status/token sale surfaces dong bo |
| P4.6 | Referral/Rewards token pass | `[x]` | Campaign/reward cards dong bo |
| P4.7 | Admin/internal dashboards exception review | `[x]` | Tool/dashboard exceptions ro rang |

Acceptance gate P4:

- Module identity van ro nhung chi qua accent.
- Predictions va Arena khong bi tron boundary.
- Local hardcoded tokens giam theo report.
- Audit sau P4.7: `total_debt=34172`, reports duoc cap nhat ngay
  `2026-06-12`.

### P5 - CI Gate Va Long-Term Enforcement

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| P5.1 | Bat audit token o warning mode | `[x]` | CI upload `design-token-consistency-audit` artifact |
| P5.2 | Dat threshold fail cho code moi | `[x]` | Changed-file guardrail khong cho them debt moi |
| P5.3 | Dat threshold fail theo module | `[x]` | P0 module baseline gates trong audit `--check` |
| P5.4 | Cap nhat PR checklist | `[x]` | Token drift checklist trong PR review/template |
| P5.5 | Cap nhat onboarding checklist | `[x]` | Feature moi bat buoc dung token/shared |

Acceptance gate P5:

- PR moi khong duoc them hardcoded `fontSize`, `EdgeInsets`, numeric radius neu
  khong nam trong allowlist.
- CI co report de xem trend tang/giam token debt.
- Design token rules tro thanh mot phan cua definition of done.
- Final audit sau P5: `total_debt=34160`; P0 financial module debt khong
  duoc vuot migration baseline: Wallet `751/759`, Trade `9072/9072`,
  P2P `1911/1911`, Markets `2042/2042`, Profile `1037/1037`.

## Metric Theo Doi

| Metric | Baseline 2026-06-11 | Muc tieu P3 | Muc tieu P5 |
| --- | --- | --- | --- |
| Feature hardcoded `fontSize` | 1,090 | < 400 | < 100 |
| Unique numeric font sizes | 31 | < 15 | <= token scale + exceptions |
| Feature numeric `EdgeInsets` | 1,866 | < 700 | < 200 |
| Feature numeric radius | 245 | < 80 | < 25 |
| Feature `height: 1` text overrides | 2,500+ | < 900 | < 250 |
| Root page bundles missing `VitPageContent` | 19 | < 10 | 0 or justified exceptions |

## Audit Can Xay Dung

### `design_token_consistency_audit.dart`

Audit nen gom:

- Root page bundle scanner: root page + declared `part` files.
- Feature widget scanner.
- Shared widget scanner.
- Allowlist scanner.
- CSV + Markdown output.

Nen dem:

- `fontSize: <number>`
- `fontFamily:`
- `FontWeight.w800/w900`
- `height: 1` trong text styles
- `EdgeInsets.*(<number>)`
- `SizedBox(width/height: <number>)`
- `BorderRadius.circular(<number>)`
- `Radius.circular(<number>)`
- `Container(` + `BoxDecoration(`
- Fixed `height`/`width` tren card/list/grid
- Grid hardcode: `crossAxisCount`, `childAspectRatio`, `mainAxisExtent`

Nen phan loai:

| Status | Y nghia |
| --- | --- |
| `pass` | Dung token/shared, debt thap |
| `warn` | Co local overrides nhung chua cao |
| `fail_new_debt` | File moi/touched them hardcoded token |
| `fail_p0` | Man P0 vuot nguong |
| `exception` | Tool/chart/canvas co ly do |

## Definition Of Done Cho Moi Tokenization PR

Moi PR token hoa phai dap ung:

- [ ] Khong them local `fontSize`, `EdgeInsets`, numeric radius moi.
- [ ] Neu can token moi, them vao `app/theme/` voi ten semantic.
- [ ] Neu pattern lap lai, tao/cap nhat shared widget thay vi copy code.
- [ ] Khong thay doi product boundary cua Prediction Markets va Open Arena.
- [ ] High-risk financial flows van co preview/confirm/risk/fee/limit.
- [ ] Phone 360 px khong overflow, khong text overlap, khong bottom nav che CTA quan
  trong.
- [ ] Chay focused tests cho touched module.
- [ ] Chay `flutter analyze`.
- [ ] Neu chạm shared layout/component, chay responsive visual QA matrix.

## Quy Tac Cho AI/Developer Khi Sua Tung Module

Trinh tu bat buoc:

1. Chon mot module hoac mot screen group, khong sua toan bo app trong mot PR.
2. Chay hoac xem audit token cua group do.
3. Gom cac magic number lap lai.
4. Neu token da co, thay bang token.
5. Neu token chua co va dung chung, them vao theme token.
6. Neu pattern card/list/input lap lai, tao shared component hoac bien the cua shared
   component.
7. Kiem tra copy va financial safety khong bi doi nghia.
8. Kiem tra 360 px first viewport.
9. Chay test/analyze.
10. Cap nhat checklist trong tai lieu nay neu phase do hoan thanh.

## Khong Nen Lam

- Khong thay toan bo UI bang mot lan refactor lon.
- Khong doi color/theme identity khi muc tieu chi la token hoa.
- Khong xoa preview/confirmation state de tiet kiem dien tich.
- Khong ep moi man hinh thanh cung mot layout neu nghiep vu khac nhau.
- Khong dua web/React screenshot cu lam source of truth.

## File Nen Cap Nhat Sau Tai Lieu Nay

| File | Ly do |
| --- | --- |
| `docs/02_FLUTTER_MIGRATION/AI-Design-Tokenization-Enterprise-Execution-Prompt.md` | Prompt thuc thi bat AI lam dung thu tu P0-P5, khong bo sot va khong lam UI roi |
| `docs/03_DESIGN_SYSTEM/Guidelines.md` | Link den tokenization plan |
| `docs/02_FLUTTER_MIGRATION/Enterprise-PR-Review-Checklist.md` | Them gate token drift |
| `docs/02_FLUTTER_MIGRATION/Future-Feature-Onboarding-Checklist.md` | Feature moi bat buoc dung token/shared |
| `flutter_app/tool/design_token_consistency_audit.dart` | Audit moi |
| `flutter_app/test/quality/design_token_consistency_guardrail_test.dart` | CI guardrail |

## Trang Thai Tong Ket

Tai lieu nay la tracking plan cho viec token hoa va dong bo UI Flutter
enterprise-grade. Viec tiep theo nen lam la P0: tao audit token consistency de
co baseline chinh thuc, sau do mo rong token foundation va chuan hoa Home/P0
financial flows theo tung module.
