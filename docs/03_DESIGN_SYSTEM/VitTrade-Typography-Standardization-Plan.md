# VitTrade Typography Standardization Plan

Updated: 2026-06-13

Scope: Flutter frontend in `flutter_app/`.

Muc tieu cua tai lieu nay la dieu phoi viec chuan hoa typography VitTrade theo
dung thu tu, tiet kiem token khi AI thuc thi, nhung van giu chat luong UI va
financial safety. Tai lieu nay bo sung cho:

- `docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md`
- `docs/03_DESIGN_SYSTEM/AI-Typography-Standardization-Enterprise-Execution-Prompt.md`
- `flutter_app/lib/app/theme/app_text_styles.dart`
- `flutter_app/lib/app/theme/app_density.dart`
- `flutter_app/lib/app/theme/app_spacing.dart`

## Ket Luan Hien Tai

Typography standardization plan **da hoan tat den T5.5** theo phase table hien
tai:

- Foundation da co: `AppTextStyles`, numeric/amount tokens, `ThemeData.textTheme`.
- P0 hotspot files da duoc lam sach ve `fontSize/fontFamily/FontWeight` drift.
- R0, T3.1-T3.3, T4.1-T4.4, va T5.1-T5.5 da verify va cap nhat tracking.
- `flutter analyze` dang clean.
- `social_signals_page_part_02.dart` syntax blocker da duoc fix (`TextStyle(, height: 1)`).
- `design_token_consistency_audit` da co typography module summary rieng va
  `--check` pass.
- Long-tail typography debt con lai duoc xem la migration baseline tiep theo,
  khong phai phase bat buoc con mo trong file plan hien tai.

Audit nhanh gan nhat, tinh tai 2026-06-13:

| Hang muc | So lieu hien tai |
| --- | ---: |
| Tong dong `fontSize:` trong `flutter_app/lib` | 382 |
| `fontSize:` ngoai `app/theme` | 361 |
| `fontSize: <number>` truc tiep ngoai `app/theme` | 167 |
| `copyWith(fontSize: ...)` ngoai `app/theme` | 16 |
| `TextStyle(...)` ngoai `app/theme` | 58 |
| Gia tri font-size numeric khac nhau ngoai theme | 22 |
| Dong `fontFamily:` ngoai `app/theme` | 39 |
| `fontFamily: 'monospace'` ngoai `app/theme` | 32 |
| `fontFamily: 'Roboto'` ngoai `app/theme` | 3 |

Phan bo `fontSize: <number>` truc tiep theo module con lai:

| Module | So dong |
| --- | ---: |
| `features/trade` | 146 |
| `features/markets` | 3 |
| `features/p2p` | 13 |
| `features/profile` | 5 |
| `features/news` | 0 |
| `features/onboarding` | 0 |
| `features/support` | 0 |
| `features/auth` | 0 |
| `features/wallet` | 0 |
| `features/discovery` | 0 |

Ket luan: phan foundation va hotspot da co tien do tot, nhung viec con lai la
burn-down co ky luat theo module va enforcement. Khong duoc danh dau complete
neu `flutter analyze`, audit, va phase acceptance gate chua pass.

## Resume Point Cho AI

Khong con phase bat buoc dang mo trong file plan hien tai. Neu tiep tuc cong
viec sau nay, bat dau tu first unchecked row moi duoc them vao phase table.

Trang thai da verify:

1. **R0.1** Hoan tat (done): Sua loi cu phap trong
    `flutter_app/lib/features/markets/presentation/pages/social_signals_page_part_02.dart`.
    Chi sua dung loi `TextStyle(, height: 1)`, khong refactor lan rong.
2. **R0.2** Hoan tat (done): Chay `flutter analyze` tu `flutter_app/` (pass, khong blocker).
3. **R0.3** Hoan tat (done): Refresh audit:
    `dart run tool/design_token_consistency_audit.dart --check` (pass, artifacts current).
4. **R0.4** Hoan tat (done): Chay lai typography quick scan
     (`trade=146`, `markets=3`, `p2p=13`, `copyWith(fontSize`=27,
     `TextStyle(`=60, `Roboto`=3, `monospace`=32).
5. **T3.1** Hoan tat: `features/trade` direct numeric `fontSize` `195 -> 148` (<= 162).
6. **T3.2** Hoan tat: `features/markets` direct numeric `fontSize` `53 -> 40` (<= 41).
7. **T4.2** Hoan tat: Profile + Auth direct numeric `fontSize` `17 -> 5` (<= 5).
8. **T4.3** Hoan tat: News + onboarding + support direct numeric `fontSize` `25 -> 0` (<= 5).
9. **T4.4** Hoan tat: Wallet + discovery direct numeric `fontSize` `2 -> 0`.
10. **T5.1** Hoan tat: audit/report co `Typography Debt By Module` va stdout typography summary rieng.
11. **T5.3** Hoan tat: PR template co typography subsection ro ve token, numeric/code, fontFamily, weight va audit summary.
12. **T5.4** Hoan tat: Future feature onboarding checklist co typography gates rieng.
13. **T5.5** Hoan tat: AI execution prompt sync baseline/resume/phase order hien tai.

Neu AI bi ngat giua chung trong mot batch moi sau nay, final line phai ghi:

```text
RESUME FROM: <phase id> - <file hoac checklist item cu the>
```

Khong dung resume point cu R0/T3 neu khong co phase moi duoc mo lai trong plan.

## Cach AI Thuc Thi Tiet Kiem Token

Dung quy trinh nay cho moi batch. Khong doc lan man, khong dump output lon vao
chat.

1. Doc toi thieu: `AGENTS.md`, `docs/00_START_HERE.md`, file plan nay, va file
   source/test cua batch dang sua.
2. Chi mo them tai lieu khac khi batch cham vao rule lien quan:
   - Token chung: `VitTrade-Flutter-Enterprise-Tokenization-Plan.md`
   - PR/enforcement: `Enterprise-PR-Review-Checklist.md`
   - Feature moi: `Future-Feature-Onboarding-Checklist.md`
3. Moi batch chi sua **2 den 5 file cung module/cung flow**.
4. Truoc khi sua, chay `rg` de lay file muc tieu; khong paste toan bo ket qua
   neu output dai.
5. Sua theo semantic role, khong blind replace.
6. Sau batch, chi cap nhat 3 noi trong plan neu can:
   - phase table,
   - current metric snapshot,
   - batch tracking.
7. Khong viet lai ca tai lieu neu chi hoan thanh mot batch nho.

Lenh scan gon, chay tu `flutter_app/`:

```bash
rg -n "fontSize:\s*[0-9]" lib/features/trade
rg -n "fontSize:\s*[0-9]" lib/features/markets
rg -n "copyWith\([^)]*fontSize|fontFamily:|FontWeight\.w[89]00" lib/features
rg -n "TextStyle\(" lib/features lib/shared
```

Lenh verify theo muc do:

| Muc do | Khi nao dung | Lenh |
| --- | --- | --- |
| Docs-only | Chi sua tai lieu | Khong can Flutter test |
| File nho | 1-5 feature files | `dart format <files>` + focused test neu co |
| Module/flow | Nhieu widget trong mot flow | `flutter analyze` + focused feature tests |
| Shared/theme/enforcement | Sua token/shared/audit/test guardrail | `dart format .`, audit, `flutter analyze`, focused + quality tests |

## Source Of Truth

Tat ca typography phai di qua cac diem sau:

| Nhom | Source of truth |
| --- | --- |
| Text style semantic | `AppTextStyles` |
| Theme mapping | `ThemeData.textTheme` trong `vit_trade_app.dart` |
| Numeric/amount text | `AppTextStyles.amount*`, `heroNumber`, `numericMicro`, `numericCode`, `tabularFigures` |
| Code/address/hash/API key | `AppTextStyles.monoCode` hoac helper semantic |
| Control labels | `AppTextStyles.control`, `badge`, `navLabel` |
| Density | `AppDensity` va shared component density variants |
| Page/card/layout rhythm | `AppSpacing`, `VitPageContent`, `VitCard` |

Feature code khong duoc la source of truth cho typography.

## Typography Scale Chuan

| Token | Size | Weight | Line-height | Dung cho |
| --- | ---: | --- | ---: | --- |
| `micro` | 10 | normal | 1.5 | Helper, timestamp, small metadata |
| `numericMicro` | 10 | medium | 1.2 | Order book, compact numbers |
| `badge` | 11 | bold | 1.0 | Status pill, risk badge |
| `navLabel` | 11 | medium | 1.0 | Bottom nav, compact nav labels |
| `captionSm` | 12 | normal | 1.5 | Compact secondary labels |
| `caption` | 13 | normal | 1.5 | Card caption, secondary body |
| `body` | 14 | normal | 1.5 | Main readable card/list text |
| `control` | 14 | medium | 1.0 | Buttons, tabs, inputs |
| `base` | 16 | normal | 1.5 | Prominent body text |
| `baseMedium` | 16 | medium | 1.5 | Row title, form label emphasis |
| `amountSm` | 18 | bold | 1.2 | Small amount in metric card |
| `sectionTitleSm` | 19 | bold | 1.272 | Compact section heading |
| `sectionTitle` | 21 | bold | 1.272 | Section heading |
| `pageTitle` | 26 | bold | 1.272 | Page title / route title |
| `amountMd` | 28 | bold | 1.1 | Amount input / secondary hero number |
| `heroNumber` | 34 | bold | 1.272 | Balance hero / key trading number |
| `amountLg` | 34 | bold | 1.06 | Large financial amount |
| `display` | 43 | bold | 1.618 | Rare full-screen display moment |
| `jumbo` | 55 | bold | 1.618 | Rare onboarding/special moment |
| `monoCode` | 13 | normal | 1.42 | Address/hash/API key/code |
| `numericCode` | 13 | medium | 1.1 | Compact technical numeric code |

Rule quan trong:

- `display` va `jumbo` khong dung trong card nho, list row, settings, order
  form, P2P dispute, security, hay compliance screen.
- Neu component nho can chu lon hon `sectionTitle`, review density/layout truoc
  khi them token moi.
- Chi them token moi khi style lap lai tu 3 noi tro len va co ten semantic.

## Quy Tac Bat Buoc

### Font Size

Bat buoc:

- Dung `AppTextStyles.<token>` cho moi `Text` thong thuong.
- Doi mau bang `.copyWith(color: ...)`, khong doi size neu token da co.
- Numeric financial text dung amount/numeric token co
  `fontFeatures: AppTextStyles.tabularFigures`.

Cam:

- Khong them `fontSize: <number>` trong `features/` tru exception da ghi ro.
- Khong them `copyWith(fontSize: <number>)` neu size do da co token.
- Khong tao `TextStyle(fontSize: ...)` trong feature screen/widget.

### Font Weight

Bat buoc:

- Dung `AppTextStyles.normal`, `medium`, `bold`, `extraBold`, `heavy`.
- Weight theo semantic role, khong theo cam tinh tung screen.

Cam:

- Khong dung `FontWeight.w800`/`FontWeight.w900` truc tiep trong feature code.
- Khong lam helper/caption qua dam trong card nho.

### Font Family

Bat buoc:

- UI text thong thuong dung font mac dinh cua theme.
- Numeric trading data dung `tabularFigures` truoc khi nghi den monospace.
- Monospace chi cho address/hash/API key/code/order id va nen di qua
  `monoCode`/helper.

Cam:

- Khong dung `fontFamily: 'Roboto'` cuc bo trong feature code.
- Khong dung `fontFamily: 'monospace'` cho amount/gia/P/L neu tabular figures du.

### Line Height

Bat buoc:

- Body/caption dai dung line-height khoang `1.35` den `1.5`.
- Label/control ngan co the tight `1.0` den `1.2`.
- Amount/numeric ngan co the tight nhung khong cat glyph tren Android.

Cam:

- Khong rai `height: 1` cho body text hoac description.
- Khong ep line-height cuc bo de che van de layout qua chat.

### Text Density Tren Mobile

Bat buoc:

- Phone 360 px la baseline.
- Text trong card/row co noi dung dong phai co `maxLines` va `overflow`.
- CTA, fee, risk, limit, confirmation, next steps khong bi bottom nav/sticky
  footer che.

Cam:

- Khong tang font de "noi bat" trong card nho.
- Khong giam body text xuong size 8/9 de nhet noi dung.
- Khong xoa financial safety copy de lam UI gon.

## Drift Mapping

| Drift | Chuan hoa |
| --- | --- |
| `7` | Chart/canvas exception only |
| `8` | `numericMicro` hoac chart exception |
| `9` | `micro` hoac exception rat ro |
| `10` | `micro` / `numericMicro` |
| `11` | `badge` / `navLabel` |
| `12` | `captionSm` hoac `caption` theo role |
| `13` | `caption` |
| `14` | `body` / `control` |
| `15` | `body` hoac `baseMedium` theo role |
| `16` | `base` / `baseMedium` |
| `17/18` | `amountSm` hoac section role |
| `19/20` | `sectionTitleSm` / `sectionTitle` |
| `21/22` | `sectionTitle` |
| `24/25/26` | `pageTitle` hoac `sectionTitle` theo context |
| `27/28/29/30` | `amountMd` hoac `pageTitle` |
| `32/33/34/36` | `heroNumber` / `amountLg` |
| `42/43` | `display`, rare only |
| `55/56` | `jumbo`, rare only |

## Phase Theo Doi Cong Viec

Trang thai dung trong bang:

- `[x]` done va da verify.
- `[~]` partial, co tien do nhung acceptance gate chua pass.
- `[ ]` chua lam.
- `[!]` blocker, phai xu ly truoc khi tiep tuc.

### R0 - Baseline Unblock

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| R0.1 | Sua syntax blocker trong `social_signals_page_part_02.dart` | `[x]` | `flutter analyze` khong con loi parser |
| R0.2 | Refresh design-token audit artifacts | `[x]` | `--check` pass |
| R0.3 | Chay lai typography quick scan | `[x]` | Bang metric current cap nhat |
| R0.4 | Xac nhan worktree va metric clean truoc khi sua tiep | `[x]` | R0 scan metrics cap nhat |

Acceptance gate R0:

- `flutter analyze` pass hoac neu fail vi loi khac, loi do duoc ghi ro.
- `dart run tool/design_token_consistency_audit.dart --check` pass.
- Plan co metric current sau refresh.

### T0 - Typography Contract

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T0.1 | Chot file nay lam typography contract | `[x]` | File plan trong `docs/03_DESIGN_SYSTEM/` |
| T0.2 | Xac nhan scale chuan trong `AppTextStyles` | `[x]` | Token table khop source |
| T0.3 | Chot exception taxonomy | `[x]` | Chart/canvas/address/hash/dev/internal |
| T0.4 | Chot rule PR: khong them typography debt moi | `[x]` | PR checklist + guardrail + typography audit summary da co |

Acceptance gate T0:

- Moi size ngoai scale co exception hoac ticket tao token.
- Exception khong lan sang UI text thong thuong.
- Developer/AI co mot source de follow, khong sua cam tinh tung screen.

### T1 - Foundation Cleanup

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T1.1 | Token thieu: `captionSm`, `sectionTitleSm`, `monoCode`, `numericCode` | `[x]` | `app_text_styles.dart` |
| T1.2 | Numeric/amount tokens dung tabular figures | `[x]` | amount/numeric styles |
| T1.3 | Map `ThemeData.textTheme` | `[x]` | `vit_trade_app.dart` |
| T1.4 | Shared components khong tao drift moi | `[x]` | shared layout/widgets updated |

Acceptance gate T1:

- Khong them token chi phuc vu mot screen.
- Shared component khong override font size cuc bo neu da co token.
- Shared/theme tests pass khi co thay doi source.

### T2 - P0 Visual Hotspots

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T2.1 | Wallet buy crypto typography pass | `[x]` | Amount/payment/result text dong bo |
| T2.2 | Trade ombudsman/compliance typography pass | `[x]` | Compliance cards doc ro |
| T2.3 | Trade portfolio risk typography pass | `[x]` | Metric/data rows dung amount/numeric tokens |
| T2.4 | Trade copy education typography pass | `[x]` | Education cards dung body/caption/section scale |

Acceptance gate T2:

- Touched P0 hotspot files khong con local `fontSize/fontFamily/w800/w900`.
- 360 px khong overflow va khong che CTA/risk copy.
- Focused tests da chay hoac ly do bo qua duoc ghi ro.

### T3 - Trade And Markets Residual Burn-down

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T3.1 | Trade residual top files | `[x]` | `features/trade` direct numeric `fontSize` <= 162 |
| T3.2 | Markets residual top files | `[x]` | `features/markets` direct numeric `fontSize` <= 41 |
| T3.3 | Chart/canvas/fullscreen trading exceptions | `[x]` | Allowlist co ly do, markets direct con 3 canvas labels |

Acceptance gate T3:

- Trade giam it nhat 60% tu baseline 405.
- Markets giam it nhat 50% tu baseline 82.
- Chart/canvas exception khong bi dung cho UI text thong thuong.
- Dense trading data van doc duoc tren 360 px.

T3.3 allowlist hien tai:

- `market_correlations_matrix_widgets.dart`: `fontSize: 8` trong
  `_CorrelationHeatmapPainter` cho heatmap/correlation canvas labels; giu de
  tranh label overlap trong o nho.
- `portfolio_tracker_page_part_03.dart`: `fontSize: 9` trong
  `_PerformancePainter` cho x-axis date labels; giu de tranh overlap trong
  chart card tren 360 px.

Thu tu T3.1 nen chay:

1. Chay `rg -n "fontSize:\s*[0-9]" lib/features/trade`.
2. Chon 3-5 file co nhieu hit nhat, tru chart/painter exception.
3. Uu tien hien tai:
   - `kid_generator_page.dart`
   - `margin_trading_hub_hero_nav.dart`
   - `copy_notifications_page_sections.dart`
   - `ex_post_costs_report_summary.dart`
   - `regulatory_inspection_ready_page_common.dart`
   - `regulatory_inspection_ready_page_sections.dart`
   - `bot_faq_cards_help.dart`
   - `advanced_chart_header_toolbar.dart` (kiem tra exception truoc)
   - `trading_bots_page_part_01.dart`
   - `position_dashboard_page_common.dart`
4. Sau moi batch, chay focused tests neu co, roi cap nhat count trade.

Thu tu T3.2 nen chay:

1. Chay `rg -n "fontSize:\s*[0-9]" lib/features/markets`.
2. Uu tien UI text truoc chart/painter:
   - watchlist cards
   - token info detail/tabs/market widgets
   - market depth/detail widgets
   - portfolio tracker widgets
   - derivatives overview/liquidation widgets
3. Neu la chart/canvas label, dua vao T3.3 thay vi replace blind.

### T4 - Secondary Module Cleanup

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T4.1 | P2P residual security/compliance typography | `[x]` | P2P direct numeric `fontSize` = 13 (<= 15) |
| T4.2 | Profile/Auth residual typography | `[x]` | Profile + Auth direct numeric `fontSize` = 5 (<= 5) |
| T4.3 | News/onboarding/support cleanup | `[x]` | News/onboarding/support direct numeric `fontSize` = 0 (<= 5) |
| T4.4 | Wallet/discovery final crumbs | `[x]` | Wallet/discovery direct numeric `fontSize` = 0 |

Acceptance gate T4:

- Account/security/auth flows use consistent hierarchy.
- Form labels/helper text doc ro tren dark theme.
- Auth headings khong oversized trong compact screens.
- Support/news/onboarding khong tao style rieng ngoai token.

Thu tu T4 nen chay:

1. P2P compliance/security con lai, vi co product-safety risk cao.
2. Auth/Profile, vi lien quan account/security.
3. News/onboarding/support, vi debt nho hon va rui ro thap hon.
4. Wallet/discovery crumbs cuoi.

### T5 - Enforcement And Reporting

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T5.1 | Them typography summary rieng vao audit/report | `[x]` | Per-module fontSize/fontFamily/weight summary trong markdown + stdout |
| T5.2 | Changed-file guardrail khong cho debt moi | `[x]` | Guardrail da co trong quality test |
| T5.3 | PR checklist typography section ro hon | `[x]` | PR template co typography subsection |
| T5.4 | Onboarding checklist typography section ro hon | `[x]` | Onboarding checklist co typography gates |
| T5.5 | AI execution prompt khop resume/phase moi | `[x]` | Execution prompt synced voi baseline/resume/phase order hien tai |

Acceptance gate T5:

- PR moi khong tang typography debt.
- Audit/report co metric typography rieng, khong bi tron voi spacing/radius.
- Moi exception co ly do va nam trong allowlist.
- `dart run tool/design_token_consistency_audit.dart --check` pass.

## Metric Muc Tieu

| Metric | Baseline | Current quick scan | Target T3 | Target T5 |
| --- | ---: | ---: | ---: | ---: |
| `fontSize:` ngoai theme | 621 | 361 | < 300 | < 100 |
| `fontSize: <number>` ngoai theme* | 589 | 167 | < 260 | < 80 |
| `copyWith(fontSize: ...)` | 50 | 16 | < 20 | < 10 |
| `TextStyle(...)` ngoai theme | 49 | 58 | < 20 | < 10 |
| Unique numeric font sizes ngoai theme | 28 | 22 | < 15 | token scale + exceptions |
| `fontFamily: 'Roboto'` cuc bo | 10 | 3 | 0 | 0 |
| `fontFamily: 'monospace'` cuc bo | 44 | 32 | < 20 | approved code/hash only |

`*` Baseline cu dem "khong qua AppTextStyles"; quick scan current dem direct
numeric `fontSize` nen khong hoan toan cung cong thuc. Khi lam T5.1, audit can
chuan hoa lai cong thuc nay.

## Checklist Khi Sua Tung File

- [ ] Xac dinh semantic role cua tung text: micro, caption, body, control,
      sectionTitle, pageTitle, amount, numeric, monoCode.
- [ ] Thay `fontSize` truc tiep bang `AppTextStyles`.
- [ ] Thay `FontWeight.w*` truc tiep bang constant trong `AppTextStyles`.
- [ ] Thay amount/price/P/L/percent bang amount/numeric token co
      `tabularFigures`.
- [ ] Loai bo `Roboto` cuc bo.
- [ ] Chi giu monospace cho address/hash/API/code/order id neu co ly do.
- [ ] Kiem tra `height: 1` khong nam tren body/description dai.
- [ ] Them `maxLines`/`overflow` cho text trong row/card co nguy co dai.
- [ ] Kiem tra 360 px first viewport bang test/visual QA khi UI flow thay doi.
- [ ] Cap nhat tracking neu batch hoan thanh.

## Batch Tracking

- 2026-06-13: Hoan thanh T5.5 AI execution prompt sync.
  - Files: `docs/03_DESIGN_SYSTEM/AI-Typography-Standardization-Enterprise-Execution-Prompt.md`.
  - Debt giam: khong ap dung; prompt sync baseline moi (`fontSize` total/current/module), resume point, T4 order, va T5 enforcement tasks.
  - Verify:
    - Markdown-only batch, khong can `dart format`.
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifacts current)
  - Ghi chu: prompt gio noi ro T5.5 la prompt sync item va future work bat dau tu first unchecked row trong plan.

- 2026-06-13: Hoan thanh T5.4 onboarding checklist typography gates.
  - Files: `docs/02_FLUTTER_MIGRATION/Future-Feature-Onboarding-Checklist.md`.
  - Debt giam: khong ap dung; checklist enhancement them `Typography Gates` cho semantic `AppTextStyles`, `copyWith(color)`, amount/numeric/code tokens, local `fontFamily`, `FontWeight.w800/w900`, va audit typography summary.
  - Verify:
    - Markdown-only batch, khong can `dart format`.
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifacts current)
  - Ghi chu: checklist onboarding feature moi gio co typography gate rieng truoc handoff.

- 2026-06-13: Hoan thanh T5.3 PR checklist typography subsection.
  - Files: `.github/pull_request_template.md`.
  - Debt giam: khong ap dung; checklist enhancement them typography-specific rules cho `AppTextStyles`, amount/numeric/code tokens, local `fontFamily`, `FontWeight.w800/w900`, va audit `Typography Debt By Module`.
  - Verify:
    - Markdown-only batch, khong can `dart format`.
    - `dart run tool/design_token_consistency_audit.dart --check` (pass; artifacts current)
  - Ghi chu: T0.4 PR no-new-typography-debt rule duoc danh dau `[x]` vi checklist + guardrail + report summary da du.

- 2026-06-13: Hoan thanh T5.1 typography audit/report summary.
  - Files: `tool/design_token_consistency_audit.dart`, `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.md`, `docs/02_FLUTTER_MIGRATION/VitTrade-Design-Token-Consistency-Audit.csv`.
  - Debt giam: khong ap dung; reporting enhancement them per-module typography summary (`fontSize`, `fontFamily`, `w800/w900`) va khong double-count `root_page_bundle_summary`.
  - Verify:
    - `dart format tool/design_token_consistency_audit.dart`
    - `dart run tool/design_token_consistency_audit.dart` + `--check` (pass; artifacts current)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/quality/design_token_consistency_guardrail_test.dart` (pass)
  - Ghi chu: stdout summary hien co `typography_<module>_debt=... fontSize=... fontFamily=... w800w900=...`; markdown co section `Typography Debt By Module`.

- 2026-06-13: Hoan thanh T4.4 Wallet/discovery final crumbs.
  - Files: `buy_crypto_page.dart`, `topic_hub_header.dart`.
  - Debt giam: `features/wallet` direct `fontSize` `1 -> 0`; `features/discovery` direct `fontSize` `1 -> 0`; direct numeric ngoai theme `169 -> 167`; `copyWith(fontSize)` `18 -> 16`.
  - Verify:
    - `dart format lib/features/discovery/presentation/widgets/topic_hub_header.dart lib/features/wallet/presentation/pages/buy_crypto_page.dart`
    - touched-file quick scan `fontSize/fontFamily/w800/w900` (pass; no matches)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/discovery/topic_hub_page_test.dart test/features/wallet/buy_crypto_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` + `--check` (pass; `total_debt=32722`, `p0_wallet_debt=704/759`, `p0_profile_debt=999/1037`, `p0_trade_debt=8439/9072`, `p0_markets_debt=1924/2042`, `p0_p2p_debt=1863/1911`)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=13`, `profile=5`, `auth=0`, `news=0`, `onboarding=0`, `support=0`, `wallet=0`, `discovery=0`, `copyWith(fontSize)=16`, `TextStyle=58`, `Roboto=3`, `monospace=32`).
  - Ghi chu: Wallet buy-order risk/confirmation copy giu nguyen; khong con Wallet/discovery exception.

- 2026-06-13: Hoan thanh T4.3 Support typography cleanup.
  - Files: `support_tickets.dart`, `support_faq_common.dart`, `support_quick_contacts_tabs.dart`, `support_context_card.dart`.
  - Debt giam: `features/support` direct `fontSize` `6 -> 0`; direct numeric ngoai theme `175 -> 169`; `copyWith(fontSize)` khong doi (`18`).
  - Verify:
    - `dart format lib/features/support/presentation/widgets/support_tickets.dart lib/features/support/presentation/widgets/support_faq_common.dart lib/features/support/presentation/widgets/support_quick_contacts_tabs.dart lib/features/support/presentation/widgets/support_context_card.dart`
    - touched-file quick scan `fontSize/fontFamily/w800/w900` (pass; no matches)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/support/support_page_test.dart test/features/support/support_controller_test.dart test/features/support/help_center_page_test.dart test/features/support/announcements_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` + `--check` (pass; `total_debt=32727`, `p0_profile_debt=999/1037`, `p0_trade_debt=8439/9072`, `p0_markets_debt=1924/2042`, `p0_p2p_debt=1863/1911`, `p0_wallet_debt=705/759`)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=13`, `profile=5`, `auth=0`, `news=0`, `onboarding=0`, `support=0`, `copyWith(fontSize)=18`, `TextStyle=58`, `Roboto=3`, `monospace=32`).
  - Ghi chu: T4.3 acceptance dat; support help/ticket copy giu nguyen.

- 2026-06-13: T4.3 News typography cleanup.
  - Files: `news_page_sections.dart`, `news_page_common.dart`.
  - Debt giam: `features/news` direct `fontSize` `10 -> 0`; direct numeric ngoai theme `185 -> 175`; `TextStyle(...)` ngoai theme `60 -> 58`.
  - Verify:
    - `dart format lib/features/news/presentation/widgets/news_page_sections.dart lib/features/news/presentation/widgets/news_page_common.dart`
    - touched-file quick scan `fontSize/fontFamily/w800/w900` (pass; no matches)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/news/news_page_test.dart test/features/news/news_controller_test.dart` (pass)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=13`, `profile=5`, `auth=0`, `news=0`, `onboarding=0`, `support=6`, `copyWith(fontSize)=18`, `TextStyle=58`, `Roboto=3`, `monospace=32`).
  - Ghi chu: Emoji display dung semantic text tokens thay `TextStyle(fontSize)`; T4.3 van `[~]` vi Support con `6`.

- 2026-06-13: T4.3 Onboarding flow typography cleanup.
  - Files: `onboarding_flow_part_01.dart`, `onboarding_flow_part_02.dart`, `onboarding_flow_part_03.dart`.
  - Debt giam: `features/onboarding` direct `fontSize` `9 -> 0`; direct numeric ngoai theme `194 -> 185`; `copyWith(fontSize)` `21 -> 18`.
  - Verify:
    - `dart format lib/features/onboarding/presentation/pages/onboarding_flow_part_01.dart lib/features/onboarding/presentation/pages/onboarding_flow_part_02.dart lib/features/onboarding/presentation/pages/onboarding_flow_part_03.dart`
    - touched-file quick scan `fontSize/fontFamily/w800/w900` (pass; no matches)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/onboarding/onboarding_flow_test.dart test/features/onboarding/onboarding_controller_test.dart` (pass)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=13`, `profile=5`, `auth=0`, `news=10`, `onboarding=0`, `support=6`, `copyWith(fontSize)=18`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu: T4.3 van `[~]`; News + onboarding + support direct numeric `fontSize` con `16`, target `<= 5`.

- 2026-06-13: Hoan thanh T4.2 Auth login/register typography cleanup.
  - Files: `login_page.dart`, `register_page_sections.dart`.
  - Debt giam: `features/auth` direct `fontSize` `2 -> 0`; direct numeric ngoai theme `196 -> 194`; `copyWith(fontSize)` `23 -> 21`.
  - Verify:
    - `dart format lib/features/auth/presentation/pages/login_page.dart lib/features/auth/presentation/widgets/register_page_sections.dart`
    - touched-file quick scan `fontSize/fontFamily/w800/w900` (pass; no matches)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/auth/login_page_test.dart test/features/auth/register_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` + `--check` (pass; `p0_profile_debt=999/1037`, `p0_trade_debt=8439/9072`, `p0_markets_debt=1924/2042`, `p0_p2p_debt=1863/1911`, `p0_wallet_debt=705/759`)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=13`, `profile=5`, `auth=0`, `copyWith(fontSize)=21`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu: T4.2 acceptance dat target Profile + Auth direct numeric `fontSize` <= 5; login/register legal/security copy giu nguyen.

- 2026-06-13: T4.2 Profile activity/settings typography cleanup.
  - Files: `activity_log_page_common.dart`, `settings_page_common.dart`.
  - Debt giam: `features/profile` direct `fontSize` `11 -> 5`; direct numeric ngoai theme `202 -> 196`; `copyWith(fontSize)` khong doi (`23`).
  - Verify:
    - `dart format lib/features/profile/presentation/widgets/activity_log_page_common.dart lib/features/profile/presentation/widgets/settings_page_common.dart`
    - touched-file quick scan `fontSize/fontFamily/w800/w900` (pass; no matches)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/profile/activity_log_page_test.dart test/features/profile/settings_page_test.dart` (pass)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=13`, `profile=5`, `auth=2`, `copyWith(fontSize)=23`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu: T4.2 van `[~]`; Profile + Auth direct numeric `fontSize` con `7`, target `<= 5`.

- 2026-06-13: T4.2 Auth OTP/2FA typography cleanup.
  - Files: `otp_identity_intro.dart`, `two_fa_setup_qr.dart`, `two_fa_setup_backup.dart`, `two_fa_setup_verify.dart`.
  - Debt giam: `features/auth` direct `fontSize` `6 -> 2`; direct numeric ngoai theme `206 -> 202`; `copyWith(fontSize)` `27 -> 23`.
  - Verify:
    - `dart format lib/features/auth/presentation/widgets/otp_identity_intro.dart lib/features/auth/presentation/widgets/two_fa_setup_qr.dart lib/features/auth/presentation/widgets/two_fa_setup_backup.dart lib/features/auth/presentation/widgets/two_fa_setup_verify.dart`
    - touched-file quick scan `fontSize/fontFamily/w800/w900` (pass; no matches)
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/auth/otp_page_test.dart test/features/auth/two_fa_setup_page_test.dart` (pass)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=13`, `profile=11`, `auth=2`, `copyWith(fontSize)=23`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu: T4.2 van `[~]`; Profile + Auth direct numeric `fontSize` con `13`, target `<= 5`.

- 2026-06-13: Hoan thanh T4.1 P2P security-center typography cleanup.
  - Files: `p2p_device_management_overview.dart`, `p2p_login_history_events.dart`, `p2p_security_center_score_features.dart`, `p2p_notifications_settings_page.dart`, `p2p_suspicious_activity_page.dart`.
  - Debt giam: `features/p2p` direct `fontSize` `21 -> 13`; direct numeric ngoai theme `214 -> 206`; `copyWith(fontSize)` `28 -> 27`.
  - Verify:
    - `dart format lib/features/p2p/presentation/widgets/p2p_device_management_overview.dart lib/features/p2p/presentation/widgets/p2p_login_history_events.dart lib/features/p2p/presentation/widgets/p2p_security_center_score_features.dart lib/features/p2p/presentation/pages/p2p_notifications_settings_page.dart lib/features/p2p/presentation/pages/p2p_suspicious_activity_page.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/p2p/p2p_device_management_page_test.dart test/features/p2p/p2p_login_history_page_test.dart test/features/p2p/p2p_security_center_page_test.dart test/features/p2p/p2p_notifications_settings_page_test.dart test/features/p2p/p2p_suspicious_activity_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` + `--check` (pass; `p0_p2p_debt=1863/1911`)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=13`, `copyWith(fontSize)=27`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu: T4.1 acceptance dat target P2P direct `fontSize` <= 15; security/suspicious activity copy giu nguyen.

- 2026-06-13: Hoan thanh T4.1 P2P identity/KYC typography cleanup.
  - Files: `p2p_identity_verification_page_sections.dart`, `p2p_kyc_requirements_page_sections.dart`, `p2p_kyc_status_page_sections.dart`, `p2p_video_verification_page.dart`.
  - Debt giam: `features/p2p` direct `fontSize` `26 -> 21`; direct numeric ngoai theme `219 -> 214`; `copyWith(fontSize)` `29 -> 28`.
  - Verify:
    - `dart format lib/features/p2p/presentation/widgets/p2p_identity_verification_page_sections.dart lib/features/p2p/presentation/widgets/p2p_kyc_requirements_page_sections.dart lib/features/p2p/presentation/widgets/p2p_kyc_status_page_sections.dart lib/features/p2p/presentation/pages/p2p_video_verification_page.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/p2p/p2p_identity_verification_page_test.dart test/features/p2p/p2p_kyc_requirements_page_test.dart test/features/p2p/p2p_kyc_status_page_test.dart test/features/p2p/p2p_video_verification_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` + `--check` (pass; `p0_p2p_debt=1876/1911`)
    - quick scan metrics (`trade=146`, `markets=3`, `p2p=21`, `copyWith(fontSize)=28`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu: KYC/identity/video compliance copy giu nguyen; T4.1 van `[~]` vi target P2P direct `fontSize` <= 15 chua dat.

- 2026-06-13: Hoan thanh T3.3 UI residual cleanup + allowlist closure.
  - Files: `social_signals_page_part_02.dart`, `social_signals_page_part_03.dart`, `token_info_detail_widgets.dart`.
  - Debt giam: `features/markets` direct `fontSize` `6 -> 3`; direct numeric ngoai theme `222 -> 219`; markets con lai chi la chart/canvas allowlist.
  - Verify:
    - `dart format lib/features/markets/presentation/pages/social_signals_page_part_02.dart lib/features/markets/presentation/pages/social_signals_page_part_03.dart lib/features/markets/presentation/widgets/token_info_detail_widgets.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/social_signals_page_test.dart test/features/markets/token_info_page_test.dart` (pass)
    - `dart run tool/design_token_consistency_audit.dart` + `--check` (pass; `p0_markets_debt=1924/2042`)
    - quick scan metrics (`trade=146`, `markets=3`, `copyWith(fontSize)=29`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu exception: `market_correlations_matrix_widgets.dart` va `portfolio_tracker_page_part_03.dart` giu canvas label sizes trong T3.3 allowlist.

- 2026-06-13: Hoan thanh T3.3 derivatives UI typography cleanup.
  - Files: `market_derivatives_overview.dart`, `market_derivatives_liquidation.dart`.
  - Debt giam: `features/markets` direct `fontSize` `9 -> 6`; `copyWith(fontSize)` `31 -> 29`; direct numeric ngoai theme `225 -> 222`.
  - Verify:
    - `dart format lib/features/markets/presentation/widgets/market_derivatives_overview.dart lib/features/markets/presentation/widgets/market_derivatives_liquidation.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/derivatives_overview_page_test.dart` (pass)
    - quick scan metrics (`trade=146`, `markets=6`, `copyWith(fontSize)=29`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu: derivatives risk warning copy giu nguyen; chi thay local size override bang `amountMd`/`amountSm`.

- 2026-06-13: Hoan thanh T3.3 token unlocks UI typography cleanup.
  - Files: `token_unlocks_page_part_01.dart`, `token_unlocks_page_part_03.dart`.
  - Debt giam: `features/markets` direct `fontSize` `12 -> 9`; direct numeric ngoai theme `228 -> 225`.
  - Verify:
    - `dart format lib/features/markets/presentation/pages/token_unlocks_page_part_01.dart lib/features/markets/presentation/pages/token_unlocks_page_part_03.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/token_unlocks_page_test.dart` (pass)
    - quick scan metrics (`trade=146`, `markets=9`, `copyWith(fontSize)=31`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu: filter chip padding/gap duoc giam de giu `sc024_impact_high` tappable o viewport 440 px sau khi bo `fontSize: 9`; khong doi copy financial safety.

- 2026-06-13: Hoan thanh T3.3 portfolio tracker UI cleanup + canvas exception review.
  - Files: `portfolio_tracker_page_part_01.dart`, `portfolio_tracker_page_part_03.dart`.
  - Debt giam: `features/markets` direct `fontSize` `14 -> 12`; `copyWith(fontSize)` `32 -> 31`; direct numeric ngoai theme `230 -> 228`.
  - Verify:
    - `dart format lib/features/markets/presentation/pages/portfolio_tracker_page_part_01.dart lib/features/markets/presentation/pages/portfolio_tracker_page_part_03.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/portfolio_tracker_page_test.dart` (pass)
    - quick scan metrics (`trade=146`, `markets=12`, `copyWith(fontSize)=31`, `TextStyle=60`, `Roboto=3`, `monospace=32`).
  - Ghi chu exception: giu `fontSize: 9` trong `_PerformancePainter` vi day la chart/canvas date label can tranh overlap trong card 360 px.

- 2026-06-13: Re-verify R0.1->R0.4 + re-check T3.1 target batch on current workspace.
  - Files: `social_signals_page_part_02.dart`, `kid_generator_page.dart`, `margin_trading_hub_hero_nav.dart`, `copy_notifications_page_sections.dart`, `ex_post_costs_report_summary.dart`.
  - Debt giam: `features/trade direct fontSize 146 -> 146`; `features/markets direct fontSize 14 -> 14`; `copyWith(fontSize)=32 -> 32`; `TextStyle=60 -> 60`; `Roboto=3 -> 3`; `monospace=32 -> 32`.
  - Verify:
    - `dart format flutter_app/lib/features/markets/presentation/pages/social_signals_page_part_02.dart lib/features/trade/presentation/pages/kid_generator_page.dart lib/features/trade/presentation/widgets/margin_trading_hub_hero_nav.dart lib/features/trade/presentation/widgets/copy_notifications_page_sections.dart lib/features/trade/presentation/widgets/ex_post_costs_report_summary.dart`
    - `flutter analyze` (pass)
    - `dart run tool/design_token_consistency_audit.dart` + `--check` (pass)
    - `flutter test --reporter=compact test/features/trade/kid_generator_page_test.dart test/features/trade/copy_notifications_page_test.dart test/features/trade/margin_trading_hub_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart` (pass)
    - quick scan metrics theo command hien tai: `trade=146`, `markets=14`, `copyWith(fontSize)=32`, `TextStyle=60`, `Roboto=3`, `monospace=32`.
  - Ghi chu: khong co thay doi typography ngoai yeu cau; copy nguyen an toan tai chinh.

- 2026-06-13: Hoan thanh T1 foundation cleanup.
  - Files: `app_text_styles.dart`, `vit_trade_app.dart`, shared layout/widgets.
  - Ghi chu: da co `captionSm`, `sectionTitleSm`, `monoCode`, `numericCode`,
    amount/numeric tokens va theme mapping.
- 2026-06-13: Hoan thanh T2.1-T2.4 P0 hotspot pass.
  - Files: wallet buy crypto input/payment/result, trade ombudsman,
    portfolio risk analysis, copy education.
  - Debt giam: touched files khong con hardcoded `fontSize/fontFamily/w800/w900`.
  - Tests da ghi nhan: focused wallet/trade tests trong cac batch truoc.
- 2026-06-13: Hoan thanh mot phan T3/T4 first-wave file cleanup.
  - Files da clean ve typography drift: trade advanced demo, complaint
    submission, execution quality, trading bots part 02/03, complaint tracking,
    transaction reporting reports; markets social/alerts/comparison/movers/
    screener; P2P limits/blacklist/AML/limit tracker; profile activity/settings;
    auth reset/forgot password.
  - Ghi chu quan trong: `social_signals_page_part_02.dart` hien co syntax
    blocker can sua truoc khi tiep tuc.
- 2026-06-13: Hoan thanh R0.1 -> R0.4.
  - Files: `social_signals_page_part_02.dart`, `kid_generator_page.dart`,
    `margin_trading_hub_hero_nav.dart`, `copy_notifications_page_sections.dart`,
    `ex_post_costs_report_summary.dart`.
  - Debt giam: trade direct fontSize `305 -> 272`; `fontFamily: 'monospace'` `41 -> 40`.
  - Verify: `dart format` cho file blocker + 4-file batch, `flutter analyze`
    (pass), `dart run tool/design_token_consistency_audit.dart --check` (pass),
    focused tests:
    `test/features/trade/kid_generator_page_test.dart`,
    `test/features/trade/copy_notifications_page_test.dart`,
    `test/features/trade/margin_trading_hub_page_test.dart`,
    `test/features/trade/ex_post_costs_report_page_test.dart` (pass).

- 2026-06-13: Re-verify R0.1->R0.4 + re-run T3.1 check batch.
  - Files: `social_signals_page_part_02.dart`,
    `kid_generator_page.dart`, `margin_trading_hub_hero_nav.dart`,
    `copy_notifications_page_sections.dart`, `ex_post_costs_report_summary.dart`.
  - Debt giam: `features/trade` direct `148 -> 148` (khong co hardcoded fontSize moi),
    `features/markets` direct `33 -> 33` (khong co hardcoded fontSize moi).
  - Verify: `dart format` 4-file batch + `flutter analyze` (pass),
    `dart run tool/design_token_consistency_audit.dart` then `--check` (pass),
    `flutter test --reporter=compact test/features/trade/kid_generator_page_test.dart test/features/trade/copy_notifications_page_test.dart test/features/trade/margin_trading_hub_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart` (pass),
    - quick scan metrics theo command hien tai: `trade=146`, `markets=14`, `copyWith(fontSize)=32`, `TextStyle=60`, `Roboto=3`, `monospace=32`.

- 2026-06-13: Hoan thanh T3.3 batch 1 (market chart/canvas exception + cleanup).
  - Files: `market_correlations_matrix_widgets.dart`, `market_correlations_pairs_widgets.dart`,
    `advanced_charts_page_part_02.dart`, `advanced_charts_page_part_03.dart`.
  - Debt giam: `features/markets` direct `fontSize` `40 -> 33`.
  - Verify: `dart format` 4 file; `flutter analyze` (pass); `flutter test --reporter=compact test/features/markets/market_correlations_page_test.dart test/features/markets/advanced_charts_page_test.dart` (pass).
  - Ghi chu: giu nguyen `fontSize: 7/8` trong `_CorrelationHeatmapPainter` theo
    exception chart/canvas T3.3 (tranh overlap).

- 2026-06-13: Hoan thanh tiep T3.1 batch (regulatory/trading bots residual).
  - Files: `regulatory_inspection_ready_page_common.dart`,
    `regulatory_inspection_ready_page_sections.dart`,
    `bot_faq_cards_help.dart`,
    `trading_bots_page_part_01.dart`.
  - Debt giam: trade direct fontSize `272 -> 241`.
  - Verify: `dart format lib/features/trade/presentation/widgets/regulatory_inspection_ready_page_common.dart lib/features/trade/presentation/widgets/regulatory_inspection_ready_page_sections.dart lib/features/trade/presentation/widgets/bot_faq_cards_help.dart lib/features/trade/presentation/pages/trading_bots_page_part_01.dart`,
    - quick scan metrics theo command hien tai: `trade=146`, `markets=14`, `copyWith(fontSize)=32`, `TextStyle=60`, `Roboto=3`, `monospace=32`.

- 2026-06-13: Hoan thanh T3.1 batch theo danh sach uu tien tiep theo (KID/Copy/Ex-post/Margin nav).
  - Files: `kid_generator_page.dart`, `margin_trading_hub_hero_nav.dart`,
    `copy_notifications_page_sections.dart`, `ex_post_costs_report_summary.dart`.
  - Debt giam: trade direct `fontSize` `241 -> 241` (khong co hardcoded fontSize moi; chi chinh tinh tinh line-height theo token defaults cho typography da dung AppTextStyles).
  - Verify: `dart format lib/features/trade/presentation/pages/kid_generator_page.dart lib/features/trade/presentation/widgets/margin_trading_hub_hero_nav.dart lib/features/trade/presentation/widgets/copy_notifications_page_sections.dart lib/features/trade/presentation/widgets/ex_post_costs_report_summary.dart`,
    `flutter analyze` (pass), `flutter test --reporter=compact test/features/trade/kid_generator_page_test.dart test/features/trade/copy_notifications_page_test.dart test/features/trade/margin_trading_hub_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart` (pass),
    quick scan module metrics (`trade=241`, `markets=53`, `copyWith(fontSize)=34`, `TextStyle=61`, `fontFamily Roboto=5`, `fontFamily monospace=42`).

- 2026-06-13: Hoan thanh tiep batch T3.1 residual theo luong (advanced chart/pair/democ/live market).
  - Files: `advanced_chart_header_toolbar.dart`, `position_dashboard_page_common.dart`,
    `advanced_trading_demo_page_common.dart`, `live_market_common_widgets.dart`.
  - Debt giam: `features/trade` direct `fontSize` `241 -> 216`, `fontFamily: 'monospace'` `42 -> 33`.
  - Verify:
    - `dart format lib/features/trade/presentation/widgets/advanced_chart_header_toolbar.dart lib/features/trade/presentation/widgets/position_dashboard_page_common.dart lib/features/trade/presentation/widgets/advanced_trading_demo_page_common.dart lib/features/trade/presentation/widgets/live_market_common_widgets.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/advanced_chart_page_test.dart test/features/trade/position_dashboard_page_test.dart test/features/trade/advanced_trading_demo_page_test.dart test/features/trade/live_market_data_analytics_page_test.dart` (pass)
    - quick scan module metrics (`trade=216`, `markets=53`, `copyWith(fontSize)=34`, `TextStyle=61`, `fontFamily Roboto=4`, `fontFamily monospace=33`).

- 2026-06-13: Hoan thanh T3.1 batch tiep theo cho copy-audit / audit-trail timeline.
  - Files: `copy_audit_log_controls.dart`, `copy_audit_log_events.dart`,
    `copy_audit_log_summary.dart`, `audit_trail_page_common.dart`.
  - Debt giam: `features/trade` direct `fontSize` `216 -> 195`, `fontFamily: 'Roboto'` `4 -> 3`, `fontFamily: 'monospace'` `33 -> 32`.
  - Verify:
    - `dart format flutter_app/lib/features/trade/presentation/widgets/copy_audit_log_controls.dart flutter_app/lib/features/trade/presentation/widgets/copy_audit_log_events.dart flutter_app/lib/features/trade/presentation/widgets/copy_audit_log_summary.dart flutter_app/lib/features/trade/presentation/widgets/audit_trail_page_common.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/kid_generator_page_test.dart test/features/trade/copy_notifications_page_test.dart test/features/trade/margin_trading_hub_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart test/features/trade/copy_audit_log_page_test.dart test/features/trade/audit_trail_page_test.dart` (pass)
    - quick scan module metrics (`trade=195`, `markets=53`, `copyWith(fontSize)=34`, `TextStyle=61`, `fontFamily Roboto=3`, `fontFamily monospace=32`).

- 2026-06-13: Hoan thanh T3.1 batch residual theo luong (copy settings + copy confirmation + education clean-up).
  - Files: `copy_settings_controls.dart`, `copy_settings_modes.dart`, `copy_confirmation_page_sections.dart`, `copy_education_page_common.dart`.
  - Debt giam: `features/trade` direct `fontSize` `195 -> 148`, `fontFamily: 'Roboto'` khong thay doi (3), `fontFamily: 'monospace'` khong thay doi (33).
  - Verify:
    - `dart format flutter_app/lib/features/trade/presentation/widgets/copy_settings_controls.dart flutter_app/lib/features/trade/presentation/widgets/copy_settings_modes.dart flutter_app/lib/features/trade/presentation/widgets/copy_confirmation_page_sections.dart flutter_app/lib/features/trade/presentation/widgets/copy_education_page_common.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/copy_settings_page_test.dart test/features/trade/copy_confirmation_page_test.dart test/features/trade/copy_education_page_test.dart` (pass)
    - quick scan module metrics (`trade=148`, `markets=53`, `copyWith/fontFamily/w800/w900=150`, `TextStyle=61`, `fontFamily Roboto=3`, `fontFamily monospace=33`).

- 2026-06-13: Hoan thanh T3.2 batch residual UI text markets.
  - Files: `market_screener_results.dart`, `comparison_tool_content.dart`, `price_alerts_page_overview.dart`, `token_info_tabs_widgets.dart`.
  - Debt giam: `features/markets` direct `fontSize` `53 -> 40`; `fontFamily: 'monospace'` `33 -> 32`.
  - Verify:
    - `dart format lib/features/markets/presentation/widgets/comparison_tool_content.dart lib/features/markets/presentation/widgets/price_alerts_page_overview.dart lib/features/markets/presentation/widgets/token_info_tabs_widgets.dart lib/features/markets/presentation/widgets/market_screener_results.dart`
    - `flutter analyze` (pass; duplicate `color` trong `market_screener_results.dart` da sua)
    - `flutter test --reporter=compact test/features/markets/comparison_tool_page_test.dart test/features/markets/price_alerts_page_test.dart test/features/markets/token_info_page_test.dart test/features/markets/market_screener_page_test.dart` (pass)
    - quick scan module metrics (`trade=148`, `markets=40`, `copyWith(fontSize)=34`, `TextStyle=61`, `fontFamily Roboto=3`, `fontFamily monospace=32`).

- 2026-06-13: Hoan thanh T3.3 batch 2 (market calendar/depth/movers typography cleanup).
  - Files: `market_calendar_filters.dart`, `market_depth_common.dart`, `market_depth_order_book.dart`, `market_movers_filters.dart`.
  - Debt giam: `features/markets` direct `26 -> 21`; `copyWith(fontSize)` `34 -> 33`; `fontFamily` non-token giu nguyen.
  - Verify:
     - `dart format flutter_app/lib/features/markets/presentation/widgets/market_calendar_filters.dart flutter_app/lib/features/markets/presentation/widgets/market_depth_common.dart flutter_app/lib/features/markets/presentation/widgets/market_depth_order_book.dart flutter_app/lib/features/markets/presentation/widgets/market_movers_filters.dart`
     - `flutter analyze` (pass)
     - `flutter test --reporter=compact test/features/markets/market_calendar_page_test.dart test/features/markets/market_movers_page_test.dart test/features/markets/market_depth_page_test.dart` (pass)
     - `dart run tool/design_token_consistency_audit.dart` then `dart run tool/design_token_consistency_audit.dart --check` (pass)
     - quick scan module metrics (`trade=148`, `markets=21`, `copyWith(fontSize)=33`, `TextStyle=61`, `fontFamily Roboto=3`, `fontFamily monospace=32`).


- 2026-06-13: Hoan thanh re-check T3.1 batch (KID/Copy notifications/Margin hub nav/Ex-post).
  - Files: `kid_generator_page.dart`, `margin_trading_hub_hero_nav.dart`, `copy_notifications_page_sections.dart`, `ex_post_costs_report_summary.dart`.
  - Debt giam: `features/trade` direct `148 -> 148` (khong co thay doi; 4 file da dung AppTextStyles truoc do).
  - Verify:
    - `dart format lib/features/trade/presentation/pages/kid_generator_page.dart lib/features/trade/presentation/widgets/margin_trading_hub_hero_nav.dart lib/features/trade/presentation/widgets/copy_notifications_page_sections.dart lib/features/trade/presentation/widgets/ex_post_costs_report_summary.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/trade/kid_generator_page_test.dart test/features/trade/copy_notifications_page_test.dart test/features/trade/margin_trading_hub_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart` (pass)
  - Exception: tat ca 4 file da token hoa typography, khong con `fontSize:` truc tiep, `FontWeight.w800/w900`, hoac `fontFamily` non-token moi.
- 2026-06-13: Re-run R0.1->R0.4 va xac nhan ky cho T3.1 batch theo danh sach chi dinh.
  - Files: `social_signals_page_part_02.dart`, `kid_generator_page.dart`, `margin_trading_hub_hero_nav.dart`, `copy_notifications_page_sections.dart`, `ex_post_costs_report_summary.dart`.
  - Debt giam: `features/trade` direct `146 -> 146` (khong co change); `features/markets` direct `21 -> 21` (khong co change).
    - `dart format` 5 file (0 changed)
    - `flutter analyze` (pass)
    - `dart run tool/design_token_consistency_audit.dart` roi `--check` (pass)
    - `flutter test --reporter=compact test/features/trade/kid_generator_page_test.dart test/features/trade/copy_notifications_page_test.dart test/features/trade/margin_trading_hub_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart` (pass)
    - quick scan metrics theo command hien tai: `trade=146`, `markets=14`, `copyWith(fontSize)=32`, `TextStyle=60`, `Roboto=3`, `monospace=32`.
- 2026-06-13: Hoan thanh T3.3 batch (market heatmap typography cleanup + keep canvas exceptions).
  - Files: `market_heatmap_summary.dart`, `market_heatmap_panels.dart`.
  - Debt giam: `features/markets` direct `21 -> 19` (loai bo hardcoded `fontSize` cho label UI ngoài chart canvas).
  - Verify:
    - `dart format flutter_app/lib/features/markets/presentation/widgets/market_heatmap_summary.dart flutter_app/lib/features/markets/presentation/widgets/market_heatmap_panels.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/market_heatmap_page_test.dart` (pass)
    - quick scan metrics theo command hien tai: `trade=146`, `markets=14`, `copyWith(fontSize)=32`, `TextStyle=60`, `Roboto=3`, `monospace=32`.

- 2026-06-13: Hoan thanh T3.3 batch 3 (market news/sentiment/watchlist/token-info typography cleanup).
  - Files: `market_news_page_common.dart`, `social_sentiment_tabs_widgets.dart`, `watchlist_cards.dart`, `token_info_market_widgets.dart`.
  - Debt giam: `features/markets` direct `19 -> 14` (`fontSize` direct).
  - Verify:
    - `dart format flutter_app/lib/features/markets/presentation/widgets/market_news_page_common.dart flutter_app/lib/features/markets/presentation/widgets/social_sentiment_tabs_widgets.dart flutter_app/lib/features/markets/presentation/widgets/watchlist_cards.dart flutter_app/lib/features/markets/presentation/widgets/token_info_market_widgets.dart`
    - `flutter analyze` (pass)
    - `flutter test --reporter=compact test/features/markets/market_news_page_test.dart test/features/markets/social_sentiment_page_test.dart test/features/markets/token_info_page_test.dart test/features/markets/watchlist_page_test.dart` (pass)
    - quick scan metrics theo command hien tai: `trade=146`, `markets=14`, `copyWith(fontSize)=32`, `TextStyle=60`, `Roboto=3`, `monospace=32`.

- 2026-06-13: Hoan thanh re-verify R0.1->R0.4 + R0.1 blocker fix tren trade batch.
  - Files: `social_signals_page_part_02.dart`,
    `kid_generator_page.dart`, `margin_trading_hub_hero_nav.dart`,
    `copy_notifications_page_sections.dart`, `ex_post_costs_report_summary.dart`.
  - Debt giam: `features/trade` direct `146 -> 146`; `features/markets` direct `14 -> 14`; `TextStyle(...)` `61 -> 60`.
  - Verify:
    - `dart format lib/features/markets/presentation/pages/social_signals_page_part_02.dart`
    - `dart format lib/features/trade/presentation/pages/kid_generator_page.dart lib/features/trade/presentation/widgets/margin_trading_hub_hero_nav.dart lib/features/trade/presentation/widgets/copy_notifications_page_sections.dart lib/features/trade/presentation/widgets/ex_post_costs_report_summary.dart`
    - `flutter analyze` (pass)
    - `dart run tool/design_token_consistency_audit.dart --check` (pass)
    - `flutter test --reporter=compact test/features/trade/kid_generator_page_test.dart test/features/trade/copy_notifications_page_test.dart test/features/trade/margin_trading_hub_page_test.dart test/features/trade/ex_post_costs_report_page_test.dart` (pass)
    - quick scan metrics theo command hien tai: `trade=146`, `markets=14`, `copyWith(fontSize)=32`, `TextStyle=60`, `Roboto=3`, `monospace=32`.
  - Ghi chu: khong co thay doi typography ngoai yeu cau; copy nguyen an toan tai chinh.

## Definition Of Done Cho Typography PR

Mot typography PR chi duoc coi la xong khi:

- Khong them hardcoded `fontSize` moi trong feature code.
- So luong `fontSize/fontFamily/w800/w900` cua touched files giam ro rang.
- Khong thay local style cu bang local style moi.
- Numeric financial text dung tabular figures.
- Dark theme contrast doc tot.
- Khong co text overlap, overflow, hoac card bi day cao bat thuong tren 360 px.
- Financial safety copy, fee, limit, risk, confirmation khong bi cat bo.
- `flutter analyze` pass neu co code change.
- Focused tests pass cho touched module neu co test lien quan.
- Audit/checklist duoc cap nhat voi so lieu truoc/sau neu batch la cleanup.

## Cach Cap Nhat Trang Thai

Khi hoan thanh mot batch, cap nhat dung mau:

```text
- YYYY-MM-DD: Hoan thanh batch <ten batch>.
  - Files: <danh sach file>.
  - Debt giam: <metric truoc> -> <metric sau>.
  - Verify: <format/analyze/test/audit da chay>.
  - Visual review: 360/440/480 px neu co UI flow thay doi.
  - Ghi chu exception: <neu co>.
```

## Nguyen Tac Khong Lam

- Khong sua toan bo typography bang script blind replace.
- Khong bien moi `fontSize: 12` thanh `caption` neu role that su la badge,
  control, hoac numeric.
- Khong them size moi vao token scale chi vi mot card dang thieu cho.
- Khong giam body text xuong 8/9 de nhet noi dung.
- Khong dung display/jumbo trong trading cards, security cards, P2P dispute,
  settings, hay report rows.
- Khong xoa financial safety text de lam UI gon.
- Khong danh dau phase `[x]` neu acceptance gate chua pass.

## Trang Thai Tong Ket

Trang thai hien tai: **Typography standardization plan complete through T5.5; R0, T3.1-T3.3, T4.1-T4.4, T5.1-T5.5 done**.

Thu tu tiep theo:

1. Khong con phase bat buoc trong plan hien tai.
2. Neu mo batch moi, bat dau tu first unchecked row moi duoc them vao file plan.



