# VitTrade Top Header Visual Consistency Completion Plan

Generated: 2026-06-03

Scope: Flutter-only VitTrade app trong `flutter_app/`.

Reality update: 2026-06-03, đối chiếu trực tiếp với code, audit artifact và
focused tests hiện tại.

Trạng thái ngắn: implementation đã hoàn thành phần code/audit/guardrail chính
từ Phase 0 đến Phase 7. Phase 8 emulator visual QA chưa được xác nhận trong lần
rà soát này, và full `flutter test --reporter=compact` toàn repo chưa được chạy
lại ở bước đánh giá này.

Verification đã chạy từ `flutter_app/` trong lần cập nhật này:

```text
dart run tool/top_header_behavior_audit.dart --check
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_visual_archetype_audit.dart --check
flutter test test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart test/quality/top_header_visual_guardrail_test.dart --reporter=compact
flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_header_action_button_test.dart test/shared/layout/vit_top_chrome_test.dart --reporter=compact
flutter test test/features/home/home_page_test.dart test/features/markets/market_list_page_test.dart test/features/markets/pair_detail_page_test.dart test/features/wallet/wallet_page_test.dart test/features/profile/profile_page_test.dart test/features/p2p/p2p_home_page_test.dart test/features/trade/trade_page_test.dart test/features/launchpad/launchpad_page_test.dart test/features/rewards/rewards_hub_page_test.dart --reporter=compact
flutter analyze
```

Tất cả command trên pass. Nhóm focused feature test có một warning hit-test trong
`wallet_page_test.dart` khi tap tab chart ở vị trí ngoài hit-test target, nhưng
test vẫn pass; đây là test warning còn cần theo dõi nếu muốn siết fatal hit-test.

Tài liệu này là kế hoạch hoàn thiện phần còn thiếu sau
`VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md`. Plan trước đã
chuẩn hóa tốt action/icon/button. Plan này khóa tiếp phần visual skeleton để top
header không còn nhiều kiểu nhìn rời rạc giữa Home, Markets, Trade, Wallet,
Profile, P2P và các màn hình detail.

## 1. Kết luận hiện trạng

Audit thực tế hiện tại cho thấy action, behavior và visual guardrail đều đang
sạch. Số liệu dưới đây đã được chạy lại từ `flutter_app/` ngày 2026-06-03:

```text
vit_header_total=381
vit_header_with_custom_trailing=0
vit_header_with_legacy_action=0
custom_header_targets=4
migration_candidates=0
banned_icon_usages=0
custom_button_usages=0
action_groups_over_limit=0

total_routed_screens=414
fixed_vit_header_remaining=0
auto_hide_header=404
custom_scroll_header=4
no_top_header=6

strict_visual_issues=0
uses_vit_top_chrome=14
status_banner_in_header=0
hard_coded_offline_banner=0

detail=398
rootModule=6
fullscreenTool=5
instrument=3
authOnboarding=1
rootBrand=1
```

Ý nghĩa:

- `VitHeader` và `VitHeaderActionButton` đã đạt chuẩn action catalog.
- Không còn custom trailing trong `VitHeader`.
- Không còn banned icon trong top-header action scope.
- Không còn fixed `VitHeader` route.
- Visual archetype audit pass với `strict_visual_issues=0`.
- Không còn `VitOfflineBanner` hard-code trong vùng header theo audit.
- Các route không có top header đã giảm từ 13 xuống 6 và đều có exception
  reason trong visual audit: `LoginPage`, `EnterpriseStatesPage`, `P2PChatPage`,
  `FuturesPage`, `AdvancedChartPage`, `TradingBotsPage`.
- `RewardsHubPage` được audit là `rootModule`; implementation thực tế đi qua
  `RewardsArenaPointsBridge` tới `ArenaPointsPage`, nơi `VitTopChrome(rootModule)`
  được render. Audit hiện chưa ghi nhận transitive `VitTopChrome` trên dòng
  `RewardsHubPage`, nên đây là limitation của inventory, không phải lỗi visual.
- Còn lại chưa xác nhận bằng emulator screenshot 360/390/440 và chưa chạy full
  `flutter test --reporter=compact` trong lần cập nhật này.

## 2. Vấn đề cần giải quyết

Baseline ban đầu cho thấy người dùng có thể thấy nhiều header không giống nhau
vì code có nhiều lớp header khác nhau. Trạng thái hiện tại đã thay đổi như sau:

| Nhóm | Baseline ban đầu | Trạng thái thực tế 2026-06-03 |
| --- | --- | --- |
| Standard detail header | `VitHeader` height tối thiểu 52, title 17 | Vẫn là detail baseline chính; behavior/action audit sạch. |
| Home header | `_HomeHeader` custom, title `VitTrade` 26 | `_HomeHeader` vẫn là wrapper riêng nhưng body đã render `VitTopChrome(rootBrand)`. |
| Market list header | `MarketListHeader`, title 30 + 3 action | `MarketListHeader` đã render `VitTopChrome(rootModule)` và dùng canonical actions; không còn root top-header `fontSize: 30` trong file này. |
| Pair detail header | `_PairHeader`, back + pair selector + favorite/share | Đã wrap bằng `VitTopChrome(instrument)`; vẫn giữ domain-specific selector/action. |
| Trade header | `_TradeHeader`, pair + price + change | Đã wrap bằng `VitTopChrome(instrument)`; vẫn giữ trading-terminal UX. |
| Wallet root | title trong content, không có `VitHeader` | Đã dùng `VitTopChrome(rootModule)`. |
| Profile root | title trong content, không có `VitHeader` | Đã dùng `VitTopChrome(rootModule)`. |
| P2P home | offline banner nằm trong vùng header trước `VitHeader` | Banner đã chuyển xuống content flow và state-driven; audit báo `status_banner_in_header=0`, `hard_coded_offline_banner=0`. |
| No-header routes | 13 route không có top header chuẩn | Còn 6 route, đều đã phân loại exception rõ trong visual audit. |

## 3. Mục tiêu cuối cùng

Hoàn thiện top header theo chuẩn Dark professional / crypto exchange / trading
super-app:

- Mọi routed screen phải thuộc một visual archetype được khai báo rõ.
- Các root module phải có cùng rhythm: safe area, top padding, title size,
  action placement, surface và bottom divider policy.
- Các detail page dùng `VitHeader` hoặc primitive mới bao quanh `VitHeader`.
- Trade/pair header được giữ domain-specific nhưng phải dùng cùng top chrome
  metrics.
- Offline/status banner luôn nằm dưới header, trong content flow.
- Audit phải kiểm tra visual archetype, không chỉ kiểm tra action icon.
- Emulator QA phải xác nhận bằng ảnh thật ở 360, 390 và 440 px width.

## 4. Non-goals

Không làm các việc sau trong plan này:

- Không đổi route hoặc product flow.
- Không refactor toàn bộ page content ngoài top-header vùng đầu trang.
- Không thay đổi business logic trading, wallet, P2P, profile.
- Không xóa `VitHeaderActionButton` hoặc action catalog đã chuẩn hóa.
- Không ép Trade terminal thành header detail thường nếu làm giảm khả năng scan
  giá/cặp giao dịch.
- Không đưa offline banner vào action row.
- Không xóa `VitOfflineBanner`; component này vẫn cần cho trạng thái cached/stale
  data, nhưng không được hiển thị mặc định khi app đang online.
- Không dùng offline banner thay cho full error state khi màn hình không có dữ
  liệu cache để hiển thị.
- Không dùng light theme làm baseline; dark theme vẫn là chuẩn chính.

## 4.1. Offline and data freshness policy

Offline banner là cần thiết trong trading super-app, nhưng chỉ là conditional
safety state. App native vẫn có thể mở khi mất mạng và vẫn có thể hiển thị local
cache, session cũ, mock/local repository hoặc dữ liệu gần nhất. Với crypto /
trading, rủi ro lớn nhất là người dùng hiểu nhầm dữ liệu cũ là dữ liệu live.

Do not treat "no network" as one single UI state. Phải tách ít nhất bốn trạng
thái:

| State | Meaning | Required UI |
| --- | --- | --- |
| `onlineLive` | Có kết nối, dữ liệu đang live/fresh | Không hiện offline banner. |
| `offlineWithCache` | Mất kết nối nhưng còn dữ liệu cache/stale để đọc | Hiện `VitOfflineBanner` dưới header, ghi rõ dữ liệu gần nhất. |
| `offlineNoCache` | Mất kết nối và không có dữ liệu tin cậy để hiển thị | Không render data giả; dùng full error/empty state + retry. |
| `reconnecting` | App đang thử kết nối lại sau khi từng có data | Dùng info banner nhẹ hoặc inline reconnecting state. |

Rules:

- Offline banner chỉ hiện khi state thật sự là `offlineWithCache` hoặc
  `reconnecting`.
- Không hard-code `VitOfflineBanner` trong page nếu snapshot/controller không có
  trạng thái offline/stale tương ứng.
- Offline banner không nằm trong `header`; đặt dưới top chrome trong content
  flow, trừ khi có sticky status exception được audit ghi rõ.
- Với market/trading/wallet/P2P data, banner phải cho biết dữ liệu đang stale
  hoặc thời điểm cập nhật gần nhất nếu có.
- Với financial action như trade submit, withdrawal, transfer, P2P escrow,
  security change: nếu offline thì disable submit/confirm và hiển thị lý do rõ.
- Với first launch/login không có cache: dùng network/auth error state, không
  dùng "showing latest cached data".
- Với static/help/dev preview page: offline banner chỉ dùng trong preview/harness
  hoặc khi state thật sự offline.
- `VitHighRiskUiState.offline` vẫn được phép dùng `VitOfflineBanner`, nhưng nội
  dung phải làm rõ action đang read-only hoặc không thể tiếp tục cho tới khi có
  kết nối.

Known correction status:

- `P2PHomePage` từng hard-code `VitOfflineBanner` trong `header: Column`, làm UI
  giống như app luôn mất kết nối và làm top header bị lệch.
- Trạng thái thực tế 2026-06-03: lỗi visual này đã được xử lý theo audit. Banner
  chỉ render khi snapshot là offline có cache, nằm trong content flow dưới
  header, và visual audit báo `status_banner_in_header=0`,
  `hard_coded_offline_banner=0`.
- Lưu ý còn lại: code vẫn còn `header: Column` wrapper với một no-op/comment cũ.
  Nó không còn chứa banner và không bị audit xem là visual issue, nhưng nên được
  cleanup nếu có packet làm sạch code sau này.

## 5. Visual archetype chuẩn

Từ giờ mỗi top header phải thuộc đúng một nhóm dưới đây.

### 5.1. `detail`

Dùng cho phần lớn màn hình routed detail/subpage.

Structure:

```text
VitAutoHideHeaderScaffold
  header: VitTopChrome(type: detail)
    body: VitHeader(title, subtitle, showBack, actions)
  child: content
```

Spec:

| Property | Value |
| --- | --- |
| Height | `52` min |
| Background | `AppColors.navBg` |
| Border | bottom `AppColors.border` |
| Horizontal padding | `AppSpacing.contentPad` |
| Title size | `17` |
| Subtitle size | `12` |
| Back/action button | `40x40` |
| Max right actions | `3` |

### 5.2. `rootBrand`

Dùng cho Home.

Structure:

```text
VitTopChrome(type: rootBrand)
  title: VitTrade
  actions: search, notifications
```

Spec:

| Property | Value |
| --- | --- |
| Title size | `26` |
| Top padding | cùng token với root module |
| Bottom padding | cùng token với root module |
| Actions | canonical `VitHeaderActionButton` |
| Surface | không dùng gradient/orb/glow |

Home được phép khác detail header vì là global app chrome, nhưng spacing và
action placement phải dùng chung primitive với root modules.

### 5.3. `rootModule`

Dùng cho root module như Markets, Wallet, Profile, P2P, Launchpad, Rewards.

Structure:

```text
VitAutoHideHeaderScaffold hoặc root collapsible host
  header: VitTopChrome(type: rootModule)
    title
    optional subtitle
    optional actions
  child: content
```

Spec:

| Property | Value |
| --- | --- |
| Title size | `26` hoặc `27`; không dùng `30` nếu không có exception |
| Top padding | thống nhất giữa root pages |
| Bottom padding | thống nhất giữa root pages |
| Action size | `40x40` |
| Max actions | `3` |
| Offline banner | dưới header, trong content flow |

### 5.4. `instrument`

Dùng cho Trade và Pair detail.

Structure:

```text
VitTopChrome(type: instrument)
  left: back hoặc asset logo
  body: pair selector
  right: price/change hoặc favorite/share
```

Spec:

| Property | Value |
| --- | --- |
| Height | `52` đến `56`, không tăng tùy page |
| Pair selector | `Semantics(button: true)` |
| Asset logo | fixed `28-32` |
| Price text | monospace, max 1 line |
| Action buttons | canonical nếu là action |
| Surface | cùng tone với `detail` hoặc `rootModule`, không tự đặt lệch |

### 5.5. `fullscreenTool`

Dùng cho chart fullscreen, futures terminal, leverage, convert, bot workspace,
chat hoặc màn hình cần tối đa diện tích.

Quy tắc:

- Phải được allowlist rõ trong audit.
- Nếu không có top header, phải có điều hướng/close/back thay thế trong UI.
- Không được để người dùng mắc kẹt.
- Không được lẫn với root page bình thường.

### 5.6. `authOnboarding`

Dùng cho login/onboarding/welcome.

Quy tắc:

- Có thể custom hoặc không có header chuẩn.
- Phải được allowlist.
- Không dùng làm tiền lệ cho financial/root module screens.

## 6. Shared primitive cần tạo

Tạo primitive mới để khóa visual skeleton, không chỉ action:

```text
flutter_app/lib/shared/layout/vit_top_chrome.dart
```

API đề xuất:

```dart
enum VitTopChromeType {
  detail,
  rootBrand,
  rootModule,
  instrument,
  fullscreenTool,
  authOnboarding,
}

class VitTopChrome extends StatelessWidget {
  const VitTopChrome({
    super.key,
    required this.type,
    this.title,
    this.subtitle,
    this.showBack = false,
    this.onBack,
    this.actions = const [],
    this.leading,
    this.body,
    this.trailing,
    this.statusSlot,
    this.transparent = false,
  });
}
```

Rules:

- `detail` dùng `VitHeader` internally để không phá 383 màn hình hiện có.
- `rootBrand` và `rootModule` dùng cùng spacing/tokens.
- `instrument` cho phép `leading/body/trailing` custom nhưng vẫn khóa height,
  padding, surface và semantics expectations.
- `statusSlot` chỉ dùng khi thật cần sticky status. Offline cached data mặc định
  không dùng `statusSlot`; đặt vào content flow.
- Không cho page tự đặt `Padding.fromLTRB(20, x, 20, y)` cho top header nếu đã
  có token trong `VitTopChrome`.

## 7. Token cần khóa

Tạo hoặc gom constants trong `vit_top_chrome.dart`:

| Token | Value đề xuất | Dùng cho |
| --- | ---: | --- |
| `detailMinHeight` | `52` | detail |
| `rootMinHeight` | `56` | rootBrand/rootModule |
| `instrumentMinHeight` | `52` | trade/pair |
| `horizontalPadding` | `AppSpacing.contentPad` | tất cả |
| `rootTopPadding` | `8` hoặc `12` | root pages |
| `rootBottomPadding` | `12` | root pages |
| `actionGap` | `8` | action row |
| `detailTitleSize` | `17` | detail |
| `rootTitleSize` | `26` | root |
| `instrumentTitleSize` | `20-21` | instrument |
| `subtitleSize` | `12` | detail/root |

Không dùng hardcoded `fontSize: 30` trong root header nếu chưa có exception.

## 8. Implementation phases

Triển khai theo đúng thứ tự. Không nhảy phase nếu phase trước chưa có audit/test.
Các checklist chi tiết bên dưới được giữ như work-breakdown gốc; trạng thái
thực tế cập nhật nằm ở bảng `Current phase status` và các phần acceptance/packet
status trong tài liệu này.

### Current phase status

| Phase | Trạng thái thực tế 2026-06-03 | Bằng chứng |
| --- | --- | --- |
| Phase 0 - Lock visual baseline | Done | `top_header_behavior_audit`, `top_header_action_audit`, `top_header_visual_archetype_audit` đều pass và artifact current. |
| Phase 1 - Define `VitTopChrome` | Done | `flutter_app/lib/shared/layout/vit_top_chrome.dart` tồn tại, có đủ type/token chính; shared tests pass. |
| Phase 2 - Home `rootBrand` | Done | `_HomeHeader` render `VitTopChrome(type: rootBrand)`; focused Home test pass. |
| Phase 3 - Root module headers | Mostly done | Markets, Wallet, Profile, P2P, Launchpad dùng `VitTopChrome(rootModule)`; Rewards render qua bridge tới `ArenaPointsPage` có `VitTopChrome(rootModule)` nhưng audit file-level chưa bắt transitive usage. |
| Phase 4 - Instrument headers | Done | Trade và Pair detail dùng `VitTopChrome(type: instrument)`; focused Trade/Markets tests pass. |
| Phase 5 - No-header classification | Done | `no_top_header=6`, tất cả có exception reason trong visual audit. |
| Phase 6 - Status banner/data freshness cleanup | Done by audit | `status_banner_in_header=0`, `hard_coded_offline_banner=0`; P2P banner hiện ở content flow và state-driven theo `offlineWithCache`. Code P2P vẫn còn `header: Column` wrapper với no-op/comment cũ, nên có thể cleanup cosmetic sau. |
| Phase 7 - Strict visual guardrail | Done | `test/quality/top_header_visual_guardrail_test.dart` pass. Tên file thực tế khác tên đề xuất ban đầu `top_header_visual_archetype_guardrail_test.dart`. |
| Phase 8 - Emulator visual QA | Not verified | Chưa thấy bằng chứng screenshot/report 360/390/440 trong lần rà soát này. |

### Phase 0 - Lock visual baseline

Mục tiêu: biết chính xác top header đang có bao nhiêu visual archetype.

Checklist:

- [x] Chạy `dart run tool/top_header_behavior_audit.dart --check`.
- [x] Chạy `dart run tool/top_header_action_audit.dart --check --strict`.
- [x] Tạo audit mới:
  `flutter_app/tool/top_header_visual_archetype_audit.dart`.
- [x] Audit mới phải liệt kê từng route với:
  - [x] route path
  - [x] page class
  - [x] page file
  - [x] detected archetype
  - [x] uses `VitHeader`
  - [x] uses `VitTopChrome`
  - [x] custom header class nếu có
  - [x] no-header reason nếu có
  - [x] status banner placement nếu có
  - [x] status banner render condition: online, offline with cache,
    offline without cache, reconnecting
  - [x] whether offline banner is hard-coded or state-driven
  - [x] expected action count
  - [x] exception reason
- [x] Tạo artifact:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`.
- [x] Tạo CSV:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv`.
- [x] Không sửa UI trong phase này.

Baseline/current count đã capture:

| Category | Current count/status 2026-06-03 |
| --- | ---: |
| `detail` archetype | `398` |
| `rootModule` archetype | `6` |
| `rootBrand` archetype | `1` |
| `instrument` archetype | `3` |
| `fullscreenTool` archetype | `5` |
| `authOnboarding` archetype | `1` |
| `custom_scroll_header` | `4` |
| `no_top_header` | `6`, tất cả có exception reason |
| P2P stacked banner header | `0` theo visual audit |
| Hard-coded offline banner without state gate | `0` theo visual audit |
| Root title in content | Wallet/Profile đã dùng `VitTopChrome(rootModule)`; Rewards đi qua bridge tới `ArenaPointsPage` |

Verification:

```bash
cd flutter_app
dart run tool/top_header_behavior_audit.dart --check
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_visual_archetype_audit.dart
```

### Phase 1 - Define `VitTopChrome`

Mục tiêu: tạo shared skeleton để root/detail/instrument không tự vẽ padding và
surface riêng.

Files:

- `flutter_app/lib/shared/layout/vit_top_chrome.dart`
- `flutter_app/lib/shared/layout/vit_header.dart`
- `flutter_app/test/shared/layout/vit_top_chrome_test.dart`
- `flutter_app/test/shared/layout/vit_header_test.dart`

Checklist:

- [x] Tạo enum `VitTopChromeType`.
- [x] Tạo widget `VitTopChrome`.
- [x] Implement type `detail`.
- [x] Implement type `rootBrand`.
- [x] Implement type `rootModule`.
- [x] Implement type `instrument`.
- [x] Allow `fullscreenTool` và `authOnboarding` chỉ như classification helper,
  không dùng để vẽ header chung nếu không cần.
- [x] Tái sử dụng `VitHeaderActionButton`.
- [x] Dùng token từ `AppSpacing`, `AppColors`, `AppTextStyles`, `AppRadii`.
- [x] Không tạo màu local.
- [x] Không tạo font local.
- [x] Không tạo height riêng trong feature page.
- [ ] Export primitive nếu cần từ shared layout barrel hiện có.

Test:

- [x] `detail` render giống `VitHeader` baseline.
- [x] `rootBrand` title size đúng và action row không overflow.
- [x] `rootModule` title/subtitle/actions đúng.
- [x] `instrument` nhận body selector và giữ height ổn định.
- [x] Width `360` không overflow với title dài + 3 actions.
- [x] Semantics cho title và actions vẫn tồn tại.

Verification:

```bash
cd flutter_app
dart format lib/shared/layout test/shared/layout
flutter test test/shared/layout/vit_top_chrome_test.dart --reporter=compact
flutter analyze
```

### Phase 2 - Migrate Home to `rootBrand`

Mục tiêu: Home vẫn là brand chrome nhưng dùng chung skeleton/tokens.

File:

- `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart`

Checklist:

- [x] Thay `_HomeHeader` body bằng `VitTopChrome(type: rootBrand)`.
- [x] Giữ title `VitTrade`.
- [x] Giữ search action route `/search`.
- [x] Giữ notification action route `/notifications`.
- [x] Giữ badge notification.
- [x] Giữ collapse behavior hiện có hoặc chuyển sang `VitAutoHideHeaderScaffold`
  nếu không phá layout.
- [x] Không đổi content Home.
- [x] Không đổi bottom nav behavior.

Test:

- [x] Search tap vẫn điều hướng đúng.
- [x] Notification tap vẫn điều hướng đúng.
- [x] Header ẩn/hiện khi scroll vẫn hoạt động.
- [ ] Screenshot Home không overlap status bar ở 360 px.

Verification:

```bash
cd flutter_app
dart format lib/features/home/presentation/pages
flutter test test/features/home --reporter=compact
flutter analyze
```

### Phase 3 - Migrate root module headers

Mục tiêu: Markets, Wallet, Profile, P2P, Launchpad, Rewards cùng nhóm
`rootModule`, không còn title nằm rời trong content nếu page là root module.

Priority order:

1. Markets
2. Wallet
3. Profile
4. P2P home
5. Launchpad
6. Rewards

#### 3.1 Markets

Files:

- `flutter_app/lib/features/markets/presentation/pages/market_list_page.dart`
- `flutter_app/lib/features/markets/presentation/widgets/market_list_header.dart`

Checklist:

- [x] Replace `MarketListHeader` row bằng `VitTopChrome(type: rootModule)`.
- [x] Title `Thị trường` dùng root title size, không dùng `fontSize: 30`.
- [x] Giữ 3 actions: overview, analytics/movers, sectors.
- [x] Giữ max 3 actions.
- [x] Không đổi market list content.

#### 3.2 Wallet

File:

- `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart`

Checklist:

- [x] Bọc page bằng `VitAutoHideHeaderScaffold` nếu phù hợp root behavior.
- [x] Chuyển title `Ví tài sản` từ content lên `VitTopChrome(type: rootModule)`.
- [x] Content padding top giảm lại để không tạo double spacing.
- [x] Không đổi wallet balance hero.
- [x] Không đổi search/filter trong content vì đó là content control, không phải
  top-header action.
- [x] Giữ bottom inset.

#### 3.3 Profile

File:

- `flutter_app/lib/features/profile/presentation/pages/profile_page.dart`

Checklist:

- [x] Chuyển title `Tài khoản` từ content lên `VitTopChrome(type: rootModule)`.
- [x] Content bắt đầu từ profile hero.
- [x] Không đổi referral copy, edit profile, logout.
- [x] Không đổi product boundaries Prediction/Arena.
- [x] Giữ bottom inset.

#### 3.4 P2P home

File:

- `flutter_app/lib/features/p2p/presentation/pages/p2p_home_page_part_01.dart`

Checklist:

- [x] Header chỉ còn `VitTopChrome(type: rootModule)` hoặc `VitHeader` wrapped.
- [x] Move `VitOfflineBanner` ra khỏi `header: Column`.
- [x] Không hard-code offline banner khi page online.
- [x] Thêm hoặc dùng snapshot/controller state để phân biệt:
  - [x] `onlineLive`: không hiện banner.
  - [x] `offlineWithCache`: hiện `VitOfflineBanner`.
  - [ ] `offlineNoCache`: hiện full error/empty state, không render stale offers.
  - [ ] `reconnecting`: hiện info/reconnecting state nhẹ nếu cần.
- [x] Đặt offline banner dưới header, trước quick hub/content, chỉ khi state yêu
  cầu.
- [x] Giữ key `P2PHomePage.offlineKey`.
- [x] Giữ create action.
- [x] Giữ my orders/history action.
- [x] Giữ routes từ snapshot.
- [ ] Disable hoặc guard financial actions nếu offline state không cho phép tạo
  offer/order.
- [x] Đảm bảo auto-hide chỉ ẩn header, không ẩn banner sai policy nếu banner nằm
  trong content flow.

#### 3.5 Launchpad and Rewards

Files cần audit trước khi sửa:

- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_page.dart`
- `flutter_app/lib/features/referral/presentation/pages/referral_rewards_page*.dart`
- Các page rewards/launchpad root nếu route dùng tên khác.

Checklist:

- [x] Root module dùng `VitTopChrome(type: rootModule)`.
- [x] Detail/subpage tiếp tục dùng `detail`.
- [x] Không đổi financial copy.
- [x] Không đổi Arena/Prediction boundary.

Verification mỗi batch:

```bash
cd flutter_app
dart format <touched files>
flutter test <focused tests> --reporter=compact
flutter analyze
dart run tool/top_header_visual_archetype_audit.dart --check
```

### Phase 4 - Normalize instrument headers

Mục tiêu: Trade và Pair detail vẫn domain-specific nhưng không còn lệch surface,
height, padding và semantics.

Files:

- `flutter_app/lib/features/trade/presentation/pages/trade_page_part_01.dart`
- `flutter_app/lib/features/markets/presentation/widgets/pair_detail_header_widgets.dart`
- `flutter_app/lib/features/markets/presentation/pages/pair_detail_page.dart`

Checklist Trade:

- [x] Wrap `_TradeHeader` bằng `VitTopChrome(type: instrument)`.
- [x] Giữ pair selector.
- [x] Thêm hoặc xác nhận `Semantics(button: true)` cho pair selector.
- [x] Giữ route `AppRoutePaths.tradePair(pair.id)`.
- [ ] Price/change right block không overflow ở 360 px.
- [x] Không thêm action icon nếu không cần.
- [x] Không đổi order form.

Checklist Pair detail:

- [x] Wrap `_PairHeader` bằng `VitTopChrome(type: instrument)`.
- [x] Giữ canonical back button.
- [x] Giữ favorite on/off.
- [x] Giữ share action.
- [x] Pair selector center không overflow.
- [x] Surface/border giống instrument spec.

Test:

- [x] Trade pair selector tap hoạt động.
- [x] Pair detail back/favorite/share visible.
- [ ] Width 360 không overflow.
- [x] Scroll behavior không regress.

Verification:

```bash
cd flutter_app
dart format lib/features/trade lib/features/markets
flutter test test/features/trade test/features/markets --reporter=compact
flutter analyze
```

### Phase 5 - Classify and fix `no_top_header` routes

Mục tiêu ban đầu: 13 route không có top header phải được phân loại rõ: cần
header, cần fullscreen exception, hay auth/onboarding exception.

Trạng thái thực tế 2026-06-03: `no_top_header=6`, tất cả đã có archetype và
exception reason trong `VitTrade-Top-Header-Visual-Archetype-Audit.md`.

Current no-header routes từ visual audit hiện tại:

| Route/Page | Archetype hiện tại | Decision hiện tại |
| --- | --- | --- |
| `LoginPage` | `authOnboarding` | Auth entry screen intentionally owns its onboarding chrome. |
| `EnterpriseStatesPage` | `fullscreenTool` | Dev/showcase exception; not a normal financial route. |
| `P2PChatPage` | `fullscreenTool` | Conversation workspace; navigation must be provided in the chat UI. |
| `FuturesPage` | `fullscreenTool` | Trading terminal workspace; navigation must be provided in the tool UI. |
| `AdvancedChartPage` | `fullscreenTool` | Fullscreen chart workspace; navigation must be provided in the tool UI. |
| `TradingBotsPage` | `fullscreenTool` | Bot workspace; navigation must be provided in the workspace UI. |

Các route từng nằm trong danh sách cần review nhưng hiện đã migrate/không còn
no-header theo behavior audit: `DCARebalanceDashboard`, `DCAScheduleAnalytics`,
`ProfilePage`, `LeveragePage`, `ConvertPage`, `WalletPage`.

Checklist:

- [x] Với từng route, ghi decision vào visual archetype audit.
- [x] Nếu migrate, thêm `VitAutoHideHeaderScaffold` + `VitTopChrome`.
- [x] Nếu allowlist, ghi lý do cụ thể.
- [ ] Nếu fullscreen, xác nhận có back/close/navigation rõ trong UI.
- [x] Không để route no-header mà không có reason.

Verification:

```bash
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
flutter analyze
```

### Phase 6 - Status banner and data freshness cleanup

Mục tiêu: banner/status không tạo cảm giác là top header thứ hai, và không hiện
offline/cached warning khi app đang online.

Known issue status:

- Đã xử lý theo audit: `P2PHomePage` không còn đặt `VitOfflineBanner` trong vùng
  header và không còn hard-code banner ở online state.
- Còn lại cleanup cosmetic: `P2PHomePage` vẫn có `header: Column` wrapper với
  no-op/comment cũ trước `VitTopChrome(rootModule)`.

Checklist:

- [x] Scan toàn bộ app:
  `rg -n "header:\\s*Column|VitOfflineBanner\\(" flutter_app/lib`.
- [x] Với mỗi `VitOfflineBanner`, xác định nó thuộc header hay content.
- [x] Với mỗi `VitOfflineBanner`, xác định nó có state gate hay đang hard-code.
- [x] Nếu banner đang hard-code trong normal page, thay bằng conditional render.
- [x] Phân loại từng page có offline state theo bốn nhóm:
  - [x] `onlineLive`
  - [x] `offlineWithCache`
  - [ ] `offlineNoCache`
  - [ ] `reconnecting`
- [x] Nếu nằm trong header, move xuống content flow.
- [ ] Nếu cần sticky status thật sự, phải dùng `statusSlot` và có reason.
- [x] Nếu không có cache, không dùng `VitOfflineBanner`; dùng full error/empty
  state và retry.
- [x] Nếu có cache, banner copy phải nói rõ "dữ liệu gần nhất" hoặc timestamp.
- [ ] Với financial action, offline state phải disable submit/confirm hoặc chặn
  bằng state rõ ràng.
- [x] Offline banner không được che title/action.
- [x] Offline banner không được tạo bottom border cạnh tranh với header border.

Test:

- [x] P2P online state không hiện offline banner.
- [x] P2P offline-with-cache state hiện offline banner dưới header.
- [ ] P2P offline-without-cache state không render stale offer list như dữ liệu
  live; dùng error/empty state phù hợp.
- [x] Topic hub/unified search offline banner vẫn nằm dưới header.
- [x] Topic hub/unified search banner chỉ hiện khi snapshot state yêu cầu.
- [x] High-risk offline state vẫn dùng banner hoặc panel đúng copy.
- [x] Auto-hide không làm mất access vào critical status sai cách.

### Phase 7 - Add strict visual guardrail

Mục tiêu: repo tự chặn việc tạo thêm header visual tùy tiện.

Files:

- `flutter_app/tool/top_header_visual_archetype_audit.dart`
- `flutter_app/test/quality/top_header_visual_guardrail_test.dart`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv`

Guardrail fail khi:

Dấu `[x]` trong danh sách này nghĩa là rule fail-condition đã được guardrail/audit
cover, không phải lỗi đó đang xảy ra trong app.

- [x] Route không thuộc archetype nào.
- [x] Root module title nằm trực tiếp trong content thay vì `VitTopChrome`.
- [x] `header: Column` chứa `VitOfflineBanner` mà không có allowlist.
- [x] `VitOfflineBanner` xuất hiện trong normal page mà không có state gate.
- [x] Offline banner hiện ở `onlineLive` state.
- [x] `offlineNoCache` vẫn render cached-data banner thay vì full error/empty
  state.
- [x] Custom header class mới xuất hiện ngoài allowlist.
- [x] `fontSize: 30` hoặc top header title size ngoài token.
- [x] Top header tự dùng `Padding.fromLTRB(20, ..., 20, ...)` ngoài primitive.
- [x] No-header route không có exception reason.
- [x] Instrument header thiếu `Semantics(button: true)` cho selector.

Verification:

```bash
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check
flutter test test/quality/top_header_visual_guardrail_test.dart --reporter=compact
```

### Phase 8 - Emulator visual QA

Mục tiêu: xác nhận bằng UI thật, không chỉ test pass.

Viewports bắt buộc:

- [ ] 360 x 800
- [ ] 390 x 844
- [ ] 440 x 956

Routes bắt buộc:

- [ ] `/home`
- [ ] `/markets`
- [ ] `/trade`
- [ ] `/wallet`
- [ ] `/profile`
- [ ] `/p2p`
- [ ] `/launchpad`
- [ ] `/rewards`
- [ ] `/notifications`
- [ ] `/markets/BTCUSDT` hoặc route pair detail tương đương
- [ ] `/trade/BTCUSDT` nếu route có pair param

Checklist ảnh:

- [ ] Không overlap status bar.
- [ ] Header không bị cắt ở notch/camera.
- [ ] Root title sizes nhìn cùng hệ thống.
- [ ] Markets không còn title quá lớn lệch khỏi Wallet/Profile/Home.
- [ ] P2P online screenshot không hiện offline banner.
- [ ] P2P offline QA screenshot nếu có test hook: banner nằm dưới header, không
  nằm trên title.
- [ ] Trade/pair instrument header có cùng rhythm với app.
- [ ] Action buttons cùng size, radius, color.
- [ ] Badge không bị cắt.
- [ ] Không có horizontal overflow.
- [ ] Header auto-hide hoạt động sau scroll.
- [ ] Bottom nav không bị ảnh hưởng.

Artifacts:

```text
flutter_app/run-artifacts/top_header_visual_qa/
  360_home.png
  360_markets.png
  360_trade.png
  360_wallet.png
  360_profile.png
  360_p2p.png
  390_*.png
  440_*.png
  report.md
```

Verification:

```bash
cd flutter_app
flutter build apk --debug
adb devices
adb -s <serial> install -r build/app/outputs/flutter-apk/app-debug.apk
adb -s <serial> shell am start -n com.vittrade.vit_trade_flutter/.MainActivity
```

## 9. Detailed work packets

Triển khai thành các packet nhỏ để giảm rủi ro.

| Packet | Scope | Output | Required verification | Trạng thái thực tế 2026-06-03 |
| ---: | --- | --- | --- | --- |
| 1 | Visual archetype audit baseline | Audit tool + MD/CSV | audit command pass | Done; audit tool/artifacts current. |
| 2 | Add `VitTopChrome` | Shared primitive + tests | focused shared tests + analyze | Done; shared tests and analyze pass. |
| 3 | Home `rootBrand` | Home header uses shared top chrome | home tests + screenshot | Code/test done; screenshot chưa xác nhận. |
| 4 | Markets `rootModule` | Market title/actions normalized | markets tests + audit | Done; focused test and audit pass. |
| 5 | Wallet/Profile `rootModule` | Root titles moved out of content | focused tests + audit | Done; focused tests and audit pass. |
| 6 | P2P home cleanup | Banner moved below header and rendered only by offline/stale state | P2P tests + screenshot | Code/test/audit done; screenshot chưa xác nhận. |
| 7 | Trade/Pair `instrument` | Instrument headers normalized | trade/markets tests | Done; focused tests pass. |
| 8 | No-header route classification | All 13 routes decided | audit guardrail | Done; còn 6 no-header exception đã phân loại. |
| 9 | Strict visual guardrail | Prevent drift | quality test | Done; quality guardrail pass. |
| 10 | Emulator QA | 360/390/440 screenshots + report | visual QA report | Not verified. |

Không làm packet 3-8 trước khi packet 1-2 xong.

## 10. File map

### Shared layout

| File | Action |
| --- | --- |
| `flutter_app/lib/shared/layout/vit_top_chrome.dart` | Add new visual skeleton primitive. |
| `flutter_app/lib/shared/layout/vit_header.dart` | Keep as detail header core; optionally route through `VitTopChrome`. |
| `flutter_app/lib/shared/layout/vit_header_action_button.dart` | Keep action primitive; do not weaken catalog. |
| `flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart` | Keep behavior; no visual customization per page. |
| `flutter_app/lib/shared/widgets/vit_offline_banner.dart` | Keep status component below header. |

### High-priority pages

| Area | File | Expected change |
| --- | --- | --- |
| Home | `features/home/presentation/pages/home_page_part_01.dart` | `_HomeHeader` uses `VitTopChrome(rootBrand)`. |
| Markets | `features/markets/presentation/widgets/market_list_header.dart` | Replace local row with `VitTopChrome(rootModule)`. |
| Markets | `features/markets/presentation/widgets/pair_detail_header_widgets.dart` | Wrap as `VitTopChrome(instrument)`. |
| Trade | `features/trade/presentation/pages/trade_page_part_01.dart` | Wrap `_TradeHeader` as `VitTopChrome(instrument)`. |
| Wallet | `features/wallet/presentation/pages/wallet_page.dart` | Move root title into `VitTopChrome(rootModule)`. |
| Profile | `features/profile/presentation/pages/profile_page.dart` | Move root title into `VitTopChrome(rootModule)`. |
| P2P | `features/p2p/presentation/pages/p2p_home_page_part_01.dart` | Move offline banner below header and render it only from offline/stale state. |
| Launchpad | `features/launchpad/presentation/pages/launchpad_page.dart` | Confirm/migrate root module top chrome. |
| Rewards | reward/referral root page files | Confirm/migrate root module top chrome. |

### Audit/test

| File | Action |
| --- | --- |
| `flutter_app/tool/top_header_visual_archetype_audit.dart` | Add visual audit. |
| `flutter_app/test/quality/top_header_visual_guardrail_test.dart` | Add quality guardrail. |
| `flutter_app/test/shared/layout/vit_top_chrome_test.dart` | Add shared widget tests. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md` | Generated artifact. |
| `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.csv` | Generated artifact. |

## 11. Acceptance criteria

Chỉ coi hoàn thành khi toàn bộ điều kiện sau đạt:

Trạng thái acceptance thực tế 2026-06-03:

Đã đạt theo audit/test hiện tại:

- Action audit sạch: custom trailing `0`, legacy action `0`, banned icons `0`,
  over-limit action groups `0`.
- Behavior audit sạch: fixed header `0`, auto-hide `404`, custom scroll `4`,
  no-header exception `6`.
- Visual archetype audit pass: `strict_visual_issues=0`.
- `VitTopChrome` primitive, shared tests, visual guardrail test và focused tests
  cho Home/Markets/Pair/Wallet/Profile/P2P/Trade/Launchpad/Rewards đều pass.
- `flutter analyze` pass.
- P2P offline banner không còn hard-code trong header theo audit; banner nằm
  trong content flow và chỉ render khi snapshot là offline có cache.
- No-header routes đều có exception reason trong audit.

Chưa đủ bằng chứng để coi hoàn tất hoàn toàn:

- Chưa chạy full `flutter test --reporter=compact` trong lần rà soát này.
- Chưa có emulator visual QA report/screenshot cho 360/390/440.
- Chưa xác nhận bằng ảnh thật rằng Home/Markets/Trade/Wallet/Profile/P2P/
  Launchpad/Rewards không overlap ở các viewport bắt buộc.
- `RewardsHubPage` render `VitTopChrome(rootModule)` qua bridge sang
  `ArenaPointsPage`; audit artifact hiện ghi `RewardsHubPage` không trực tiếp
  dùng `VitTopChrome`, nên inventory còn limitation transitive bridge.
- `P2PHomePage` đã sạch visual theo audit nhưng vẫn còn `header: Column` wrapper
  với no-op/comment cũ; không còn blocker, nhưng nên cleanup để code khớp policy
  hơn.

- [x] Action audit vẫn sạch: custom trailing `0`, banned icons `0`.
- [x] Behavior audit vẫn sạch: fixed header `0`.
- [x] Visual archetype audit pass.
- [x] Mọi routed screen có archetype rõ ràng.
- [x] Root modules không còn tự vẽ title rời trong content nếu title đó là top
  page identity.
- [x] Home, Markets, Wallet, Profile, P2P, Launchpad, Rewards dùng chung root
  top chrome rhythm.
- [ ] Trade/Pair detail dùng `instrument` và không overflow ở 360 px.
- [x] P2P offline banner nằm dưới header và không hiện ở online state.
- [x] Không còn `VitOfflineBanner` hard-code trong normal online screen.
- [x] Mỗi offline banner có state gate rõ: `offlineWithCache` hoặc
  `reconnecting`.
- [x] `offlineNoCache` dùng full error/empty state, không dùng cached-data
  banner.
- [ ] Financial actions bị disable/guard rõ khi offline state không cho phép tiếp
  tục.
- [x] No-header routes đều có exception reason.
- [x] Không còn custom header mới ngoài allowlist.
- [x] Widget tests cho `VitTopChrome` pass.
- [x] Quality guardrail visual pass.
- [x] `flutter analyze` pass.
- [x] Focused tests cho touched modules pass.
- [ ] Full `flutter test --reporter=compact` pass nếu sửa shared layout hoặc nhiều
  feature.
- [ ] Emulator screenshots 360/390/440 có report và không phát hiện overlap.

## 12. AI execution prompt

Dùng prompt này nếu giao cho AI thực hiện:

```text
Đọc kỹ theo thứ tự:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/03_DESIGN_SYSTEM/Guidelines.md
4. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md
5. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md
6. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Behavior-Audit.md
7. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md

Nhiệm vụ:
Triển khai từng phase trong
VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md đúng thứ tự, không bỏ
sót checklist nào.

Nguyên tắc bắt buộc:
- Không sửa UI trước khi có visual archetype audit baseline.
- Không phá action catalog đã chuẩn hóa.
- Không tạo local top header padding/font/height khi `VitTopChrome` đã cover.
- Không để offline banner nằm trong header trừ khi có exception rõ.
- Không hard-code offline banner trong normal online screen.
- Offline banner chỉ được render khi state là offline-with-cache hoặc
  reconnecting.
- Nếu offline nhưng không có cache, dùng full error/empty state thay vì cached
  banner.
- Financial actions phải disabled/guarded khi offline state không cho phép tiếp
  tục.
- Không để root module title nằm rời trong content nếu đó là page identity.
- Không xóa domain-specific Trade/Pair UX; chỉ chuẩn hóa skeleton/tokens.
- Không đổi route, product copy hoặc business logic không liên quan.
- Không revert thay đổi không liên quan trong working tree.

Mỗi packet phải:
1. Nêu rõ file sẽ sửa.
2. Sửa bằng shared primitive.
3. Preserve keys/routes/callbacks hiện có.
4. Thêm hoặc cập nhật focused tests.
5. Chạy format/analyze/focused tests.
6. Chạy visual/action/behavior audit liên quan.
7. Ghi rõ exception còn lại và lý do.
8. Với offline/banner work, test cả online và offline/stale state.
9. Nếu sửa visual high-traffic, chụp emulator screenshot.
```

## 13. Risk notes

- Header là shared surface; thay đổi nhỏ có thể ảnh hưởng hàng trăm màn hình.
- Root pages như Wallet/Profile có content hero phức tạp; cần giảm content top
  padding sau khi move title lên header để tránh double spacing.
- Trade header là công cụ trading, không nên làm giống detail header đến mức mất
  thông tin giá/cặp giao dịch.
- P2P banner là lỗi visual rõ nhất vì đang nằm trong header stack.
- Offline banner nếu hiện sai lúc online sẽ làm app trông lỗi kết nối thường
  trực; nếu bỏ hẳn banner thì lại gây rủi ro người dùng nhầm dữ liệu stale là
  live.
- Audit action không đủ để bắt lỗi visual; phải thêm visual archetype audit.
- Emulator QA là bắt buộc vì vấn đề người dùng thấy là vấn đề bằng mắt.

## 14. Final verification command set

Chạy từ `flutter_app/`:

```bash
dart format .
dart run tool/top_header_behavior_audit.dart --check
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_visual_archetype_audit.dart --check
flutter analyze
flutter test test/quality/top_header_behavior_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart test/quality/top_header_visual_guardrail_test.dart --reporter=compact
flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_header_action_button_test.dart test/shared/layout/vit_top_chrome_test.dart --reporter=compact
flutter test --reporter=compact
```

Sau đó chạy emulator QA cho các viewport 360, 390 và 440 px.
