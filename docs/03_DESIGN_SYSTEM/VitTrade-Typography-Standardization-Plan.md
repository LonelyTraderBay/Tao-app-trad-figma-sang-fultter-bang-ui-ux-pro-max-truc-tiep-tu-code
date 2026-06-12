# VitTrade Typography Standardization Plan

Updated: 2026-06-13

Scope: Flutter frontend in `flutter_app/`.

Muc tieu cua tai lieu nay la theo doi rieng viec chuan hoa font chu, kich
thuoc chu, font weight, line-height, numeric text, va text density cho VitTrade
theo huong:

- Dark professional.
- Crypto exchange.
- Trading super-app.
- Phone-first tu 360 px.
- Enterprise-grade, khong roi UI, khong cam giac moi man hinh mot kieu.

Tai lieu nay bo sung cho:

- `docs/03_DESIGN_SYSTEM/VitTrade-Flutter-Enterprise-Tokenization-Plan.md`
- `flutter_app/lib/app/theme/app_text_styles.dart`
- `flutter_app/lib/app/theme/app_density.dart`
- `flutter_app/lib/app/theme/app_spacing.dart`

## Ket Luan Hien Tai

He thong da co `AppTextStyles` va theme text da map vao `ThemeData`, nhung code
feature van con nhieu hardcode typography. Vi vay nguoi dung van thay chu to,
chu nho, do day chu, line-height, va numeric text khong dong bo giua cac man
hinh.

Baseline audit gan nhat, tinh tai 2026-06-13:

| Hang muc | So lieu |
| --- | ---: |
| Tong dong `fontSize` hardcoded | 638 |
| `fontSize` hardcoded ngoai theme | 621 |
| `fontSize` truc tiep khong qua `AppTextStyles` | 589 |
| `copyWith(fontSize: ...)` override | 50 |
| `TextStyle(...)` truc tiep ngoai `app_text_styles.dart` | 49 |
| Gia tri font-size numeric khac nhau ngoai theme | 28 |
| Dong `fontFamily:` | 57 |
| `fontFamily: 'monospace'` | 44 |
| `fontFamily: 'Roboto'` | 10 |

Phan bo `fontSize` hardcoded theo module:

| Module | So dong |
| --- | ---: |
| `features/trade` | 405 |
| `features/markets` | 82 |
| `features/p2p` | 44 |
| `features/profile` | 24 |
| `features/wallet` | 22 |
| `features/auth` | 15 |
| `features/news` | 10 |
| `features/onboarding` | 9 |
| `features/support` | 6 |
| `shared/widgets` | 3 |
| `features/discovery` | 1 |

Ket luan: loi khong nam o mot screen rieng le. Van de la typography contract
chua du manh va chua co enforcement ro rang cho feature code.

## Dinh Huong Typography

VitTrade khong nen co cam giac landing page, marketing app, hay dashboard noi
bo nang ne. Typography can co cam giac cua san giao dich crypto chuyen nghiep:

- Data-first: so tien, gia, P/L, quantity, percent phai doc nhanh va thang hang.
- Compact nhung khong bi chat: uu tien nhieu thong tin tren first viewport,
  nhung van giu khoang tho cho financial safety.
- Trustworthy: han che font qua lon, qua dam, qua "hero" tren cac card nho.
- Consistent: cung mot semantic role thi dung cung style, khong tao kich thuoc
  rieng vi tung screen.
- Dark professional: contrast du doc tren nen toi, khong dung text qua mong
  hoac line-height qua chat lam chu dinh vao nhau.
- Trading super-app: typography phai ho tro nhieu module khac nhau nhung van
  co chung mot thang bac thi giac.

## Source Of Truth

Tat ca typography phai di qua cac diem sau:

| Nhom | Source of truth |
| --- | --- |
| Text style semantic | `AppTextStyles` |
| Theme mapping | `ThemeData.textTheme` trong `vit_trade_app.dart` |
| Numeric/amount text | `AppTextStyles.amount*`, `heroNumber`, `numericMicro`, `tabularFigures` |
| Control labels | `AppTextStyles.control`, `badge`, `navLabel` |
| Density | `AppDensity` va shared component density variants |
| Page/card/layout rhythm | `AppSpacing`, `VitPageContent`, `VitCard` |

Feature code khong duoc la source of truth cho typography.

## Typography Scale Chuan

Thang font duoc phep dung mac dinh:

| Token | Size | Weight | Line-height | Dung cho |
| --- | ---: | --- | ---: | --- |
| `micro` | 10 | normal | 1.5 | Helper, timestamp, small secondary metadata |
| `numericMicro` | 10 | medium | 1.2 | Order book, compact numbers, tiny data rows |
| `badge` | 11 | bold | 1.0 | Status pill, risk badge, small label |
| `navLabel` | 11 | medium | 1.0 | Bottom nav, compact nav labels |
| `caption` | 13 | normal | 1.5 | Card caption, secondary body, descriptions |
| `body` | 14 | normal | 1.5 | Main readable text in cards/lists |
| `control` | 14 | medium | 1.0 | Buttons, tabs, inputs, segmented controls |
| `base` | 16 | normal | 1.5 | Prominent body text |
| `baseMedium` | 16 | medium | 1.5 | Row title, card title, form label emphasis |
| `amountSm` | 18 | bold | 1.2 | Small amount in metric card |
| `sectionTitle` | 21 | bold | 1.272 | Section heading |
| `pageTitle` | 26 | bold | 1.272 | Page title / route title |
| `amountMd` | 28 | bold | 1.1 | Amount input / secondary hero number |
| `heroNumber` | 34 | bold | 1.272 | Balance hero / key trading number |
| `amountLg` | 34 | bold | 1.06 | Large financial amount |
| `display` | 43 | bold | 1.618 | Rare full-screen/display moment |
| `jumbo` | 55 | bold | 1.618 | Rare onboarding or special marketing-style moment |

Rule quan trong:

- `display` va `jumbo` khong dung trong card nho, list row, settings, order
  form, P2P dispute, security, hay compliance screen.
- Neu mot component nho can chu lon hon `sectionTitle`, component do phai duoc
  review lai ve density truoc khi them size moi.
- Size `7`, `8`, `9`, `12`, `15`, `17`, `19`, `20`, `22`, `24`, `27`, `30`,
  `32`, `33`, `36`, `42`, `56` la drift hien tai. Chi giu lai neu co token
  semantic hoac exception hop le.

## Quy Tac Bat Buoc

### Font Size

Bat buoc:

- Dung `AppTextStyles.<token>` cho moi `Text`.
- Neu can doi mau, dung `.copyWith(color: ...)`.
- Neu can doi numeric feature, dung token amount/numeric va
  `fontFeatures: AppTextStyles.tabularFigures`.
- Neu can style moi lap lai tu 3 noi tro len, them vao `AppTextStyles` voi ten
  semantic.

Cam:

- Khong them `fontSize: <number>` trong `features/`.
- Khong them `copyWith(fontSize: <number>)` neu size do da co token.
- Khong tao `TextStyle(fontSize: ...)` truc tiep trong screen/widget feature.

Exception hop le:

- Axis label trong custom chart/canvas.
- Mini heatmap/correlation cell label.
- Text nam trong painter neu khong dung Flutter `Text` tree.
- Visual QA/dev/internal tool co ly do ro.

### Font Weight

Bat buoc:

- Dung `AppTextStyles.normal`, `medium`, `bold`, `extraBold`, `heavy`.
- Weight phai theo semantic role, khong theo cam tinh tung screen.

Cam:

- Khong dung `FontWeight.w800`/`FontWeight.w900` truc tiep trong feature code.
- Khong lam label phu qua dam trong card nho vi se canh tranh voi data chinh.

Guideline:

- Main amount: `bold` hoac `extraBold`.
- Section title: `bold`.
- Control label/tab: `medium`.
- Caption/helper: `normal`, chi `medium` khi can nhan trang thai.
- Alert/risk label: `bold`, khong lap lai `heavy` neu khong can.

### Font Family

Bat buoc:

- UI text thong thuong dung font mac dinh cua theme.
- Numeric trading data dung `tabularFigures` truoc khi nghi den monospace.
- Neu can monospace cho address/hash/API key/order id, phai goi qua helper/token
  semantic.

Cam:

- Khong dung `fontFamily: 'Roboto'` cuc bo trong feature code.
- Khong dung `fontFamily: 'monospace'` cho amount/gia/P/L neu tabular figures da
  du.
- Khong tron nhieu font trong cung mot card neu khong phai code/hash/address.

### Line Height

Bat buoc:

- Body/caption dai dung line-height thoang: `1.35` den `1.5`.
- Label/control ngan co the tight: `1.0` den `1.2`.
- Amount/numeric ngan co the tight nhung khong de bi cat glyph tren Android.

Cam:

- Khong rai `height: 1` cho body text hoac description.
- Khong dung line-height cuc bo chi de ep card nho neu noi dung dang qua dai.

### Text Density Tren Mobile

Bat buoc:

- Phone 360 px la baseline.
- Text trong card phai co `maxLines` va `overflow` khi noi dung co the dai.
- First viewport phai hien du context chinh: balance/market/order/action.
- CTA va risk copy khong duoc bi bottom nav che.

Cam:

- Khong tang font de "noi bat" trong card nho.
- Khong giam xuong size 8/9 cho body noi dung chi de nhet nhieu thong tin.
- Khong dung `FittedBox` de che giau van de typography neu text role sai.

## Bang Mapping Drift Ve Token

| Drift hien tai | Huong chuan hoa |
| --- | --- |
| `fontSize: 7` | Chi cho chart/canvas exception |
| `fontSize: 8` | `numericMicro` hoac chart exception |
| `fontSize: 9` | `micro` hoac them `microTight` neu lap lai hop le |
| `fontSize: 10` | `micro` / `numericMicro` |
| `fontSize: 11` | `badge` / `navLabel` |
| `fontSize: 12` | Chuyen ve `caption` neu text doc; chi tao `captionSm` neu can compact label |
| `fontSize: 13` | `caption` |
| `fontSize: 14` | `body` / `control` |
| `fontSize: 15` | Chuyen ve `body` hoac `baseMedium` theo role |
| `fontSize: 16` | `base` / `baseMedium` |
| `fontSize: 17` | Chuyen ve `amountSm` hoac `sectionTitle` tuy role |
| `fontSize: 18` | `amountSm` |
| `fontSize: 19/20` | Chuyen ve `sectionTitle` hoac tao `sectionTitleSm` neu can |
| `fontSize: 21/22` | `sectionTitle` |
| `fontSize: 24/25/26` | `pageTitle` hoac `sectionTitle` tuy context |
| `fontSize: 27/28/29/30` | `amountMd` hoac `pageTitle` tuy context |
| `fontSize: 32/33/34/36` | `heroNumber` / `amountLg` |
| `fontSize: 42/43` | `display`, chi dung o hero lon |
| `fontSize: 55/56` | `jumbo`, chi dung exception |

## File Nong Can Xu Ly Truoc

### Trade

| File/group | Van de chinh | Uu tien | Trang thai |
| --- | --- | --- | --- |
| `features/trade/presentation/pages/ombudsman_referral_page.dart` | 11 `fontSize`, local weight/line-height | P0 | `[ ]` |
| `features/trade/presentation/widgets/portfolio_risk_analysis_page_sections.dart` | 11 `fontSize`, metric card text khong dong bo | P0 | `[ ]` |
| `features/trade/presentation/widgets/copy_education_page_sections.dart` | 11 `fontSize`, education cards | P0 | `[ ]` |
| `features/trade/presentation/widgets/advanced_trading_demo_page_sections.dart` | 10 `fontSize`, demo dense UI | P1 | `[ ]` |
| `features/trade/presentation/widgets/execution_quality_overview.dart` | 10 `fontSize`, data overview | P1 | `[ ]` |
| `features/trade/presentation/widgets/complaint_submission_page_sections.dart` | 10 `fontSize`, compliance flow | P1 | `[ ]` |
| `features/trade/presentation/pages/trading_bots_page_part_02.dart` | 10 `fontSize`, bot config/data rows | P1 | `[ ]` |
| `features/trade/presentation/pages/complaint_tracking_page.dart` | 9 `fontSize`, status timeline | P2 | `[ ]` |
| `features/trade/presentation/pages/trading_bots_page_part_03.dart` | 9 `fontSize`, bot params | P2 | `[ ]` |
| `features/trade/presentation/widgets/transaction_reporting_reports.dart` | 9 `fontSize`, reports rows/cards | P2 | `[ ]` |

### Markets

| File/group | Van de chinh | Uu tien | Trang thai |
| --- | --- | --- | --- |
| `features/markets/presentation/pages/social_signals_page_part_02.dart` | 7 `fontSize`, social cards | P1 | `[ ]` |
| `features/markets/presentation/widgets/price_alerts_page_details.dart` | 7 `fontSize`, alert details | P1 | `[ ]` |
| `features/markets/presentation/widgets/comparison_tool_tokens.dart` | 5 `fontSize`, token comparison labels | P2 | `[ ]` |
| `features/markets/presentation/widgets/market_movers_row_common.dart` | 5 `fontSize`, row density | P2 | `[ ]` |
| `features/markets/presentation/widgets/market_screener_filters.dart` | 5 `fontSize`, filter controls | P2 | `[ ]` |

### P2P

| File/group | Van de chinh | Uu tien | Trang thai |
| --- | --- | --- | --- |
| `features/p2p/presentation/widgets/p2p_transaction_limits_page_common.dart` | 4 `fontSize`, limit rows | P1 | `[ ]` |
| `features/p2p/presentation/pages/p2p_blacklist_add_page.dart` | 4 `fontSize`, security form | P1 | `[ ]` |
| `features/p2p/presentation/pages/p2p_aml_screening_page.dart` | 3 `fontSize`, risk/compliance | P2 | `[ ]` |
| `features/p2p/presentation/pages/p2p_limit_tracker_page.dart` | 3 `fontSize`, tracking cards | P2 | `[ ]` |

### Wallet, Profile, Auth

| File/group | Van de chinh | Uu tien | Trang thai |
| --- | --- | --- | --- |
| `features/wallet/presentation/widgets/wallet_buy_crypto_input_sections.dart` | 12 `fontSize`, amount input/payment copy | P0 | `[ ]` |
| `features/wallet/presentation/widgets/wallet_buy_crypto_payment_sections.dart` | 6 `fontSize`, payment method cards | P1 | `[ ]` |
| `features/profile/presentation/widgets/activity_log_page_sections.dart` | 7 `fontSize`, activity row hierarchy | P2 | `[ ]` |
| `features/profile/presentation/widgets/settings_page_sections.dart` | 6 `fontSize`, settings list text | P2 | `[ ]` |
| `features/auth/presentation/widgets/reset_password_page_sections.dart` | 5 `copyWith(fontSize)`, auth headings | P2 | `[ ]` |
| `features/auth/presentation/widgets/forgot_password_page_sections.dart` | 4 `copyWith(fontSize)`, auth headings | P2 | `[ ]` |

## Phase Theo Doi Cong Viec

### T0 - Typography Contract

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T0.1 | Chot tai lieu nay lam typography contract | `[x]` | File plan trong `docs/03_DESIGN_SYSTEM/` |
| T0.2 | Xac nhan scale chuan trong `AppTextStyles` | `[ ]` | Bang token duoc review |
| T0.3 | Chot exception list cho chart/canvas/address/hash/dev tool | `[ ]` | Allowlist ro trong audit |
| T0.4 | Chot rule PR: khong them `fontSize` moi trong feature | `[ ]` | Checklist cap nhat |

Acceptance gate T0:

- Tat ca size semantic co ten ro.
- Moi size ngoai scale phai co exception hoac ticket tao token moi.
- Team/AI co mot tai lieu de theo doi, khong sua cam tinh tung man hinh.

### T1 - Foundation Cleanup

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T1.1 | Them/doi ten token thieu neu can: `captionSm`, `sectionTitleSm`, `monoCode` | `[ ]` | `app_text_styles.dart` |
| T1.2 | Them helper cho numeric/address/code text | `[ ]` | Style/helper dung `tabularFigures` hoac monospace exception |
| T1.3 | Map them textTheme neu can | `[ ]` | `vit_trade_app.dart` |
| T1.4 | Cap nhat shared components khong override font size cuc bo | `[ ]` | `shared/widgets`, `shared/layout` |

Acceptance gate T1:

- Shared component khong tao local typography drift.
- Feature code co du token de thay the cac pattern lap lai.
- Khong them style moi chi de phuc vu mot screen.

### T2 - P0 Visual Hotspots

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T2.1 | Wallet buy crypto typography pass | `[ ]` | Amount/payment/result text dong bo |
| T2.2 | Trade ombudsman/compliance typography pass | `[ ]` | Compliance cards doc ro, khong bi roi |
| T2.3 | Trade portfolio risk typography pass | `[ ]` | Metric cards/data rows dung amount/numeric tokens |
| T2.4 | Trade copy education typography pass | `[ ]` | Education cards dung body/caption/section scale |

Acceptance gate T2:

- Cac screen nguoi dung de nhin thay nhat khong con cam giac chu lech kich thuoc.
- Card nho khong dung title qua lon.
- So tien/risk metric su dung numeric/amount tokens.
- 360 px khong overflow va khong che CTA.

### T3 - Trading And Markets Pass

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T3.1 | Trade remaining top 20 files | `[ ]` | Giam manh 405 dong hardcode trong `features/trade` |
| T3.2 | Markets social/alerts/screener pass | `[ ]` | Market data rows va filter controls dong bo |
| T3.3 | Review chart label exceptions | `[ ]` | Chart/canvas exception list gon va co ly do |

Acceptance gate T3:

- `features/trade` giam it nhat 60% local `fontSize`.
- `features/markets` giam it nhat 50% local `fontSize`.
- Chart label exception khong bi lan sang UI text thong thuong.

### T4 - P2P, Profile, Auth, Secondary Modules

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T4.1 | P2P security/compliance typography pass | `[ ]` | Risk/limit/blacklist/AML screens dong bo |
| T4.2 | Profile settings/activity typography pass | `[ ]` | Settings rows va activity log dong bo |
| T4.3 | Auth typography pass | `[ ]` | Login/register/reset/2FA headings dong bo |
| T4.4 | News/onboarding/support cleanup | `[ ]` | Loai bo drift nho con lai |

Acceptance gate T4:

- Form labels, helper text, section titles trong cac flow tai khoan/security khong
  con moi screen mot size.
- Auth screen van ro rang nhung khong dung hero title qua lon tren card nho.
- Support/news/onboarding khong tao style rieng ngoai token.

### T5 - Enforcement

| ID | Cong viec | Trang thai | Deliverable |
| --- | --- | --- | --- |
| T5.1 | Cap nhat audit de report rieng typography debt | `[ ]` | Typography section trong audit |
| T5.2 | Fail changed-file neu them `fontSize` moi ngoai allowlist | `[ ]` | Guardrail test |
| T5.3 | Them PR checklist typography | `[ ]` | Checklist trong docs |
| T5.4 | Cap nhat execution prompt cho AI | `[ ]` | AI khong nhay buoc khi sua typography |

Acceptance gate T5:

- PR moi khong tang typography debt.
- Audit co baseline giam dan theo module.
- Moi exception co ly do, khong phai noi "tam de vay".

## Metric Muc Tieu

| Metric | Baseline 2026-06-13 | Muc tieu T2 | Muc tieu T3 | Muc tieu T5 |
| --- | ---: | ---: | ---: | ---: |
| `fontSize` hardcoded ngoai theme | 621 | < 520 | < 300 | < 100 |
| `fontSize` khong qua `AppTextStyles` | 589 | < 480 | < 260 | < 80 |
| `copyWith(fontSize: ...)` | 50 | < 35 | < 20 | < 10 |
| `TextStyle(...)` truc tiep ngoai theme | 49 | < 35 | < 20 | < 10 |
| Unique numeric font sizes ngoai theme | 28 | < 22 | < 15 | <= token scale + exceptions |
| `fontFamily: 'Roboto'` cuc bo | 10 | 0 | 0 | 0 |
| `fontFamily: 'monospace'` cuc bo | 44 | < 35 | < 20 | only approved code/hash exceptions |

## Checklist Khi Sua Tung File

- [ ] Xac dinh semantic role cua tung text: micro, caption, body, control,
  sectionTitle, pageTitle, amount, numeric.
- [ ] Thay `fontSize` truc tiep bang `AppTextStyles`.
- [ ] Thay `FontWeight.w*` truc tiep bang constant trong `AppTextStyles`.
- [ ] Thay amount/price/P/L/percent bang amount/numeric token co
  `tabularFigures`.
- [ ] Loai bo `Roboto` cuc bo.
- [ ] Chi giu monospace cho address/hash/API/code neu co ly do.
- [ ] Kiem tra `height: 1` khong nam tren body/description dai.
- [ ] Them `maxLines`/`overflow` cho text trong row/card co nguy co dai.
- [ ] Kiem tra 360 px first viewport bang mat thuong hoac visual QA.
- [ ] Cap nhat bang tracking trong tai lieu nay.

## Definition Of Done Cho Typography PR

Mot PR chuan hoa font chu chi duoc coi la xong khi:

- Khong them hardcoded `fontSize` moi trong feature code.
- So luong `fontSize` hardcoded cua touched files giam ro rang.
- Khong tao style cuc bo de thay the mot style cuc bo cu.
- Numeric financial text dung `tabularFigures`.
- Dark theme contrast van doc tot.
- Khong co text overlap, overflow, hoac card bi day cao bat thuong tren 360 px.
- Financial safety copy, fee, limit, risk, confirmation khong bi cat bo.
- Audit/checklist duoc cap nhat voi so lieu truoc/sau.

## Cach Cap Nhat Trang Thai

Khi hoan thanh mot batch, cap nhat dung mau sau:

```text
- YYYY-MM-DD: Hoan thanh batch <ten batch>.
- Files: <danh sach file>.
- Debt giam: <metric truoc> -> <metric sau>.
- Visual review: 360/440/480 px.
- Ghi chu exception: <neu co>.
```

## Nguyen Tac Khong Lam

- Khong sua toan bo typography bang mot script blind replace.
- Khong bien moi `fontSize: 12` thanh `caption` neu role that su la badge,
  control, hoac numeric.
- Khong them size moi vao token scale chi vi mot card dang thieu cho.
- Khong giam font xuong 8/9 de nhet them noi dung.
- Khong dung display/jumbo trong trading cards, security cards, P2P dispute,
  settings, hay report rows.
- Khong xoa financial safety text de lam UI gon.

## Trang Thai Tong Ket

Tai lieu nay la tracking plan rieng cho viec chuan hoa font chu cua VitTrade.
Uu tien thuc thi tiep theo nen la T0.2/T0.3 de chot scale va exception, sau do
di vao T2 voi cac diem nong nguoi dung thay ro nhat: Wallet buy crypto, Trade
ombudsman, Trade portfolio risk, va Trade copy education.
