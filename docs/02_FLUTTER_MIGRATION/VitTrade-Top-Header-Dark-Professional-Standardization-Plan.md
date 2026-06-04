# VitTrade Top Header Dark Professional Standardization Plan

Generated: 2026-06-03  
Scope: Flutter-only VitTrade app trong `flutter_app/`.

Tài liệu này là kế hoạch triển khai chi tiết để chuẩn hóa toàn bộ top header
theo chuẩn **Dark professional / crypto exchange / trading super-app**. Mục
tiêu là làm cho mọi màn hình có cùng ngôn ngữ điều hướng, cùng action catalog,
cùng kích thước nút, cùng màu/tone, cùng accessibility, và có guardrail để
không bị lệch lại sau này.

## 1. Kết luận điều tra hiện trạng

Audit thủ công + code scan hiện tại cho thấy:

| Hạng mục | Kết quả hiện tại | Ý nghĩa |
| --- | ---: | --- |
| Routed screens trong top-header audit | `414` | Phạm vi màn hình cần giữ nhất quán. |
| `VitHeader(...)` trong `flutter_app/lib` | `383` | Phần lớn page dùng shared header. |
| Header có `showBack: true` | `375` | Back là action phổ biến nhất. |
| Header có `trailing` custom | `42` | Nguồn chính gây lệch UI. |
| Built-in `VitHeaderAction.bell` | `2` | Built-in action đang ít dùng. |
| Unique icon/state trong top header | `29` | Quá nhiều so với một super-app chuyên nghiệp. |
| Nhóm chức năng header thực tế | `~22` | Có thể gom và chuẩn hóa còn khoảng `16-18`. |
| Fixed header còn lại | `0` | Auto-hide migration đã đạt baseline. |

Vấn đề chính không còn là header bị fixed, mà là **action và button style chưa
có hợp đồng thiết kế chung**. Cùng một chức năng đang có nhiều icon hoặc nhiều
cách tự vẽ khác nhau:

- Share: `share_outlined` và `ios_share_rounded`.
- Export: `download_rounded` và `file_download_outlined`.
- Filter: `tune_rounded` và `filter_alt_outlined`.
- Favorite/watchlist: `star_*` và `favorite_*`.
- Add/create: `add`, `add_rounded`, `person_add_alt_1_rounded`.
- Button implementation: `VitIconButton`, `IconButton`, `InkWell`,
  `GestureDetector`, local `Container` + `Icon`.

## 2. Product standard cần đạt

Top header của VitTrade phải tạo cảm giác:

- **Trading-grade:** nhanh, chắc, ít nhiễu, ưu tiên scan thông tin và hành động
  đúng.
- **Exchange-grade:** điều hướng rõ, risk/status không bị trang trí quá mức,
  financial actions không bị lẫn với social/points actions.
- **Super-app-grade:** nhiều module nhưng cùng một ngôn ngữ top chrome.
- **Dark professional:** surface tối, contrast rõ, accent hạn chế, không dùng
  glow/gradient/orb trang trí.
- **Mobile-first:** an toàn ở width `360px`, không overlap title/action, touch
  target đủ lớn.

Không được tối ưu theo từng màn riêng lẻ nếu làm mất tính thống nhất toàn app.

## 3. Header information architecture

Mọi top header phải được phân thành 3 vùng:

| Vùng | Nội dung cho phép | Quy tắc |
| --- | --- | --- |
| Left | Back, close, module identity đặc biệt | Back luôn cùng kích thước, icon, vị trí. |
| Body | Title/subtitle, pair selector, search field đặc biệt | Text không overlap action, max 2 dòng trong standard header. |
| Right | Tối đa 3 action chính | Nếu nhiều hơn 3 action, gom vào `more`. |

### 3.1. Page header chuẩn

Dùng cho phần lớn routed screens:

```text
VitAutoHideHeaderScaffold
  header: VitHeader
    left: back optional
    body: title + subtitle
    right: actions
  child: scrollable content
```

### 3.2. Home header

Home được phép custom vì là global chrome, nhưng action vẫn phải dùng cùng
catalog:

- Search.
- Notifications + badge.
- Không thêm action thứ ba nếu chưa có lý do product rõ ràng.

### 3.3. Trade / Pair header

Trade được phép có selector cặp giao dịch ở body vì đây là domain-specific
control. Tuy nhiên:

- Back vẫn dùng canonical back button nếu có.
- Pair selector phải có semantics là button.
- Favorite/share nếu xuất hiện phải dùng canonical action catalog.
- Không tự vẽ button mới nếu `VitHeaderActionButton` đã cover được.

### 3.4. Market list header

Market list hiện có 3 action nhanh. Giữ tối đa 3:

- Market overview.
- Movers.
- Sectors.

Các nút này phải dùng cùng button primitive và cùng 40x40 sizing.

## 4. Canonical action catalog

Tạo một catalog duy nhất để mọi top header dùng lại. Không dùng icon trực tiếp
trong page header nếu action đã có trong catalog.

| Action type | Icon chuẩn | Tooltip/semantic tiếng Việt | Tone | Ghi chú |
| --- | --- | --- | --- | --- |
| `back` | `Icons.chevron_left_rounded` | `Quay lại` | neutral | Left only. |
| `close` | `Icons.close_rounded` | `Đóng` | neutral | Dùng cho modal/fullscreen flow. |
| `search` | `Icons.search_rounded` | `Tìm kiếm` | neutral | Không đổi icon theo module. |
| `notifications` | `Icons.notifications_none_rounded` | `Thông báo` | neutral + badge | Badge dùng cùng component. |
| `filter` | `Icons.tune_rounded` | `Bộ lọc` | neutral/primary when active | Thay `filter_alt_outlined` trong top header. |
| `settings` | `Icons.settings_outlined` | `Cài đặt` | neutral | Không dùng nhiều variant settings. |
| `export` | `Icons.download_rounded` | `Xuất dữ liệu` | neutral | Thay `file_download_outlined` trong top header. |
| `share` | `Icons.share_outlined` | `Chia sẻ` | neutral | Thay `ios_share_rounded`. |
| `favoriteOn` | `Icons.star_rounded` | `Bỏ theo dõi` | warning | Watchlist/trading dùng star. |
| `favoriteOff` | `Icons.star_border_rounded` | `Theo dõi` | neutral/warning | Không dùng `favorite_*` trong top header. |
| `add` | `Icons.add_rounded` | `Tạo mới` | primary | Label cụ thể nằm ở tooltip nếu cần. |
| `history` | `Icons.history_rounded` | `Lịch sử` | neutral | Dùng cho ledger/order/history. |
| `analytics` | `Icons.bar_chart_rounded` | `Phân tích` | neutral | Dashboard/performance/report. |
| `portfolio` | `Icons.business_center_outlined` | `Portfolio` | neutral | Không dùng wallet icon cho portfolio header. |
| `overview` | `Icons.monitor_heart_outlined` | `Tổng quan` | neutral | Market overview. |
| `sectors` | `Icons.layers_rounded` | `Ngành` | neutral | Market sector/depth only. |
| `refresh` | `Icons.refresh_rounded` | `Làm mới` | neutral | Dùng ít, tránh thay thế pull-to-refresh. |
| `help` | `Icons.help_outline_rounded` | `Hướng dẫn` | neutral | Tour/help only. |
| `emergency` | `Icons.error_outline_rounded` | `Khẩn cấp` | danger | High-risk only. |
| `more` | `Icons.more_vert_rounded` | `Thêm` | neutral | Khi quá 3 action. |

### 4.1. Action không được dùng trong top header sau chuẩn hóa

| Icon hiện tại | Thay bằng | Lý do |
| --- | --- | --- |
| `Icons.ios_share_rounded` | `Icons.share_outlined` | Tránh platform-specific style trong app chung. |
| `Icons.file_download_outlined` | `Icons.download_rounded` | Gom export/download. |
| `Icons.filter_alt_outlined` | `Icons.tune_rounded` | Tune phù hợp bộ lọc dạng controls. |
| `Icons.favorite_rounded` | `Icons.star_rounded` | Trading/watchlist nên dùng star. |
| `Icons.favorite_border_rounded` | `Icons.star_border_rounded` | Đồng bộ watchlist state. |
| `Icons.add` | `Icons.add_rounded` | Đồng bộ rounded icon style. |
| `Icons.person_add_alt_1_rounded` | `Icons.add_rounded` hoặc local content action | Top header không nên đổi add theo domain. |
| `Icons.chevron_right_rounded` | `more` hoặc content CTA | Chevron-right không phải icon action header chuẩn. |

## 5. Button visual spec

Tạo primitive riêng cho header action:

```text
flutter_app/lib/shared/layout/vit_header_action_button.dart
```

API đề xuất:

```dart
enum VitHeaderActionType {
  back,
  close,
  search,
  notifications,
  filter,
  settings,
  export,
  share,
  favoriteOn,
  favoriteOff,
  add,
  history,
  analytics,
  portfolio,
  overview,
  sectors,
  refresh,
  help,
  emergency,
  more,
}

enum VitHeaderActionTone {
  neutral,
  primary,
  success,
  danger,
  warning,
  transparent,
}
```

```dart
class VitHeaderActionButton extends StatelessWidget {
  const VitHeaderActionButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.tooltip,
    this.tone,
    this.active = false,
    this.badgeCount = 0,
    this.size = VitHeaderActionSize.md,
  });
}
```

### 5.1. Sizing

| Property | Value | Lý do |
| --- | ---: | --- |
| Touch target | `40x40` default | Mobile header đủ chạm, không quá to. |
| Icon size | `18-20` | Tránh icon lấn title. |
| Gap giữa action | `6-8` | Không dính nhau ở width `360px`. |
| Radius | `10` | Khớp `VitIconButton` hiện tại. |
| Badge min size | `16x16` | Đủ đọc `1-99+`. |

WCAG 2.2 yêu cầu target tối thiểu `24x24`; mobile trading nên đặt target thực tế
`40-44` để giảm tap nhầm.

### 5.2. Tone

| Tone | Background | Foreground | Border |
| --- | --- | --- | --- |
| neutral | `AppColors.searchBg` | `AppColors.text2` | `AppColors.border` |
| neutral active | `AppColors.surface3` | `AppColors.text1` | `AppColors.borderSolid` |
| primary | `AppColors.primary12` | `AppColors.primary` | `AppColors.primary20` |
| success | `AppColors.buy15` | `AppColors.buy` | `AppColors.buy20` |
| danger | `AppColors.sell15` | `AppColors.sell` | `AppColors.sell20` |
| warning | `AppColors.warn10` | `AppColors.warn` | `AppColors.warningBorder` |
| transparent | transparent | `AppColors.text1/text2` | none |

Không tạo màu local trong page. Nếu tone thiếu, thêm vào theme/shared primitive,
không thêm `Color(0x...)` ở feature.

## 6. Banner/status policy

Banner như `Mất kết nối. Đang hiển thị dữ liệu gần nhất.` không phải top-header
button. Nó là status banner và phải tách khỏi action catalog.

| Status | Component | Icon | Vị trí |
| --- | --- | --- | --- |
| Offline cached data | `VitOfflineBanner` | `Icons.wifi_off_rounded` | Dưới header, trong content flow. |
| Reconnecting | `VitOfflineBanner(reconnecting: true)` | `Icons.wifi_rounded` | Dưới header. |
| Warning/info/error | `VitBanner` | Theo variant | Dưới header hoặc trong card state. |

Không đặt offline banner vào trailing action. Không dùng banner màu quá sáng hoặc
full-width alarm style trừ high-risk blocking state.

## 7. Implementation phases

Triển khai theo thứ tự dưới đây. Không nhảy phase nếu phase trước chưa có test
và audit.

### Phase 0 - Lock baseline inventory

Mục tiêu: biết chính xác hiện trạng trước khi sửa.

Checklist:

- [ ] Chạy `dart run tool/top_header_behavior_audit.dart`.
- [ ] Lưu lại số liệu: routed screens, auto-hide, custom scroll, no header.
- [ ] Tạo audit mới hoặc mở rộng audit hiện có để liệt kê:
  - [ ] `VitHeader` có `trailing`.
  - [ ] `VitHeader` có `action`.
  - [ ] Header custom: Home, Trade, Markets, Pair detail.
  - [ ] Icon trực tiếp trong top-header scope.
  - [ ] File/line của từng local header button.
- [ ] Ghi output vào doc hoặc artifact Markdown/CSV.
- [ ] Không sửa UI trong phase này.

Deliverable:

- `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md`
  hoặc cập nhật audit hiện có nếu phù hợp.

Verification:

```bash
cd flutter_app
dart run tool/top_header_behavior_audit.dart
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
```

### Phase 1 - Add canonical action primitive

Mục tiêu: tạo primitive chuẩn nhưng chưa migrate hàng loạt.

Files cần thêm/sửa:

- `flutter_app/lib/shared/layout/vit_header_action_button.dart`
- `flutter_app/lib/shared/layout/vit_header.dart`
- `flutter_app/test/shared/layout/vit_header_action_button_test.dart`
- `flutter_app/test/shared/layout/vit_header_test.dart` nếu đã có hoặc tạo mới.

Checklist:

- [ ] Tạo `VitHeaderActionType`.
- [ ] Tạo `VitHeaderActionTone`.
- [ ] Tạo catalog map type -> icon + fallback tooltip + default tone.
- [ ] Tạo `VitHeaderActionButton`.
- [ ] Hỗ trợ `badgeCount`.
- [ ] Hỗ trợ `active`.
- [ ] Hỗ trợ `loading` nếu cần thay thế các local loading action.
- [ ] Tooltip bắt buộc: dùng explicit tooltip hoặc fallback từ catalog.
- [ ] Semantics bắt buộc: `button: true`, `label`, `enabled`.
- [ ] Disabled state rõ ràng.
- [ ] Không dùng hardcoded color ngoài theme.
- [ ] Không dùng kích thước tùy tiện ngoài primitive.

Test bắt buộc:

- [ ] Renders canonical icon cho từng action type quan trọng.
- [ ] Badge hiển thị đúng `1`, `99+`.
- [ ] Disabled không gọi callback.
- [ ] Tooltip/semantics tồn tại.
- [ ] Size mặc định là `40x40`.
- [ ] Active filter đổi tone nhưng không đổi layout.

Verification:

```bash
cd flutter_app
dart format lib/shared/layout test/shared/layout
flutter test test/shared/layout/vit_header_action_button_test.dart --reporter=compact
flutter analyze
```

### Phase 2 - Upgrade `VitHeader` API without breaking old pages

Mục tiêu: cho `VitHeader` nhận danh sách action chuẩn, nhưng vẫn giữ `trailing`
tạm thời để migrate dần.

API đề xuất:

```dart
class VitHeaderActionItem {
  const VitHeaderActionItem({
    required this.type,
    required this.onPressed,
    this.tooltip,
    this.tone,
    this.active = false,
    this.badgeCount = 0,
  });
}
```

Thêm vào `VitHeader`:

```dart
final List<VitHeaderActionItem> actions;
```

Quy tắc render:

- Nếu `trailing != null`, render `trailing` để không break.
- Nếu `actions.isNotEmpty`, render action row.
- Nếu `actions.length > 3`, chỉ cho phép khi explicit test/exception; mặc định
  guardrail phải báo lỗi.
- `action: VitHeaderAction.*` cũ vẫn support tạm thời nhưng đánh dấu legacy.

Checklist:

- [ ] Add `actions` vào constructor.
- [ ] Render action row bằng `VitHeaderActionButton`.
- [ ] Spacing giữa action dùng token cố định.
- [ ] Badge không làm layout nhảy.
- [ ] Standard/page variant đều dùng cùng button primitive.
- [ ] Back button có thể được chuyển sang `VitHeaderActionButton(type: back)`.
- [ ] Không đổi behavior của 383 header hiện có ngoài các page được migrate.

Test:

- [ ] `VitHeader` title/subtitle vẫn render.
- [ ] `showBack` vẫn hoạt động.
- [ ] `actions` render nhiều nút.
- [ ] `trailing` legacy vẫn ưu tiên nếu có.
- [ ] Header không overflow ở width `360`.

### Phase 3 - Migrate high-visibility headers first

Mục tiêu: chuẩn hóa các màn người dùng thấy nhiều nhất trước.

Thứ tự migrate:

1. Home header.
2. Markets list header.
3. Trade header / pair selector related actions.
4. Pair detail header.
5. Launchpad home header.
6. P2P home + P2P high-traffic pages.
7. Wallet high-traffic pages.
8. Profile/security pages.

Checklist Home:

- [ ] Search dùng `VitHeaderActionButton(type: search)`.
- [ ] Notifications dùng `type: notifications`.
- [ ] Badge dùng cùng component với header badge.
- [ ] Không thay layout title `VitTrade`.
- [ ] Test tap search/notifications vẫn đi đúng route.

Checklist Markets:

- [ ] `MarketListHeader` dùng canonical buttons.
- [ ] Overview dùng `overview`.
- [ ] Movers dùng `analytics` hoặc `trending` nếu catalog giữ riêng.
- [ ] Sectors dùng `sectors`.
- [ ] Không dùng local `_HeaderActionButton` sau migration.

Checklist Trade / Pair detail:

- [ ] Back dùng canonical back.
- [ ] Pair selector giữ domain UI nhưng có `Semantics(button: true)`.
- [ ] Favorite dùng `favoriteOn/favoriteOff`.
- [ ] Share dùng `share`.
- [ ] Không dùng `favorite_*` icon trong top header.

Checklist Launchpad:

- [ ] Filter dùng `filter`.
- [ ] Performance dùng `analytics`.
- [ ] Portfolio dùng `portfolio`.
- [ ] Row action dùng shared primitive.

Checklist P2P / Wallet:

- [ ] Add/create dùng `add`.
- [ ] History dùng `history`.
- [ ] Export dùng `export`.
- [ ] Settings dùng `settings`.
- [ ] Help dùng `help`.

Verification mỗi batch:

```bash
cd flutter_app
dart format <touched files>
flutter test <focused tests> --reporter=compact
flutter analyze
```

### Phase 4 - Migrate remaining `trailing` custom headers

Mục tiêu: xóa hoặc giảm tối đa 42 custom trailing.

Checklist:

- [ ] Chạy audit để lấy danh sách custom trailing còn lại.
- [ ] Với mỗi file:
  - [ ] Xác định action function group.
  - [ ] Map sang canonical action type.
  - [ ] Replace local button bằng `actions: [...]` hoặc
    `VitHeaderActionButton`.
  - [ ] Giữ route/callback/haptic behavior.
  - [ ] Giữ keys test hiện có nếu test phụ thuộc.
  - [ ] Update focused test.
- [ ] Nếu local button thật sự cần custom:
  - [ ] Ghi exception vào audit.
  - [ ] Phải có reason: pair selector, segmented header, hoặc high-risk domain
    control.
  - [ ] Vẫn dùng canonical icon nếu có icon action.

Không được làm:

- [ ] Không thay đổi product copy không liên quan.
- [ ] Không refactor layout lớn ngoài header action scope.
- [ ] Không đổi route.
- [ ] Không gom financial action với Arena Points action.

### Phase 5 - Add strict guardrails

Mục tiêu: sau khi migrate, repo tự chặn lệch chuẩn.

Guardrail cần có:

- [ ] `top_header_action_audit.dart`
  - [ ] Liệt kê header actions.
  - [ ] Báo icon ngoài catalog.
  - [ ] Báo local `IconButton` trong `VitHeader.trailing`.
  - [ ] Báo `actions.length > 3`.
  - [ ] Báo thiếu tooltip/semantics.
  - [ ] Báo target size dưới `40x40` nếu primitive không dùng đúng.
- [ ] `test/quality/top_header_action_guardrail_test.dart`
  - [ ] Audit artifact current.
  - [ ] Không có banned icon.
  - [ ] Không có unexpected local header button.
  - [ ] Exceptions phải nằm trong allowlist.

Output artifact đề xuất:

```text
docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md
docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.csv
```

### Phase 6 - Visual QA and emulator pass

Mục tiêu: xác nhận không chỉ test pass mà UI thật nhìn thống nhất.

Viewport bắt buộc:

- [ ] 360 x 800.
- [ ] 390 x 844.
- [ ] 440 x 956.

Routes bắt buộc chụp:

- [ ] `/home`
- [ ] `/markets`
- [ ] `/trade`
- [ ] `/wallet`
- [ ] `/profile`
- [ ] `/rewards`
- [ ] `/launchpad`
- [ ] `/p2p`
- [ ] `/notifications`
- [ ] `/markets/BTCUSDT` hoặc pair detail tương đương.

Kiểm tra bằng mắt:

- [ ] Header không overlap status bar.
- [ ] Title không đè action.
- [ ] Action row không vượt quá width.
- [ ] Badge không bị cắt.
- [ ] Offline banner nằm dưới header, không che button.
- [ ] Auto-hide vẫn hoạt động sau migration.
- [ ] Bottom nav không bị ảnh hưởng.
- [ ] Dark surface không bị một màu phẳng quá mức.
- [ ] Accent không quá nhiều trên cùng một header.

Emulator workflow:

```bash
cd flutter_app
flutter build apk --debug
adb devices
adb -s <serial> install -r build/app/outputs/flutter-apk/app-debug.apk
adb -s <serial> shell am start -n com.vittrade.vit_trade_flutter/.MainActivity
```

## 8. Detailed migration map

### 8.1. Shared files

| File | Action |
| --- | --- |
| `flutter_app/lib/shared/layout/vit_header_action_button.dart` | Add new primitive. |
| `flutter_app/lib/shared/layout/vit_header.dart` | Add `actions`, use primitive, keep legacy `trailing`. |
| `flutter_app/lib/shared/widgets/vit_icon_button.dart` | Do not remove; keep for content-level buttons. |
| `flutter_app/lib/shared/widgets/vit_offline_banner.dart` | Keep banner separate from header actions. |
| `flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart` | Keep current auto-hide behavior. |

### 8.2. High-priority feature files

| Feature | File / area | Expected change |
| --- | --- | --- |
| Home | `features/home/presentation/pages/home_page_part_01.dart` | Replace local search/bell row with canonical header action buttons. |
| Markets | `features/markets/presentation/widgets/market_list_header.dart` | Replace `_HeaderActionButton`. |
| Markets | `features/markets/presentation/widgets/pair_detail_header_widgets.dart` | Canonical back/favorite/share, keep pair selector. |
| Trade | `features/trade/presentation/pages/trade_page_part_01.dart` | Review `_TradeHeader`; add semantics to pair selector; avoid new action variants. |
| Launchpad | `features/launchpad/presentation/widgets/launchpad_home_header_widgets.dart` | Replace 3 `VitIconButton` actions with canonical header buttons. |
| P2P | `features/p2p/presentation/pages/p2p_home_page_part_01.dart` | Replace add/history header actions. |
| Wallet | `features/wallet/presentation/widgets/wallet_address_book_controls.dart` | Replace add address header control. |
| Notifications | `features/notifications/presentation/pages/notifications_page.dart` | Ensure bell/action semantics and no custom icon drift. |

### 8.3. Secondary trailing custom files

Các class local cần được audit và migrate nếu đang nằm trong top header:

- `_SettingsButton`
- `_HeaderSettingsButton`
- `_LoadingToggle`
- `_HeaderShareButton`
- `_AddButton`
- `_RefreshButton`
- `LaunchpadDcaHeaderCreateButton`
- `_HeaderCreateButton`
- `_MarketplaceButton`
- `_DownloadButton`
- `_HeaderChartButton`
- `_HeaderHistoryButton`
- `_FilterButton`
- `_CreateButton`
- `_HeaderAddButton`
- `_HeaderDownloadButton`
- `_HeaderExportButton`
- `_HeaderEmergencyButton`
- `_ExportHeaderButton`
- `_SettingsAction`
- `_DownloadAction`
- `_AddAddressButton`

Không migrate blindly. Với mỗi class, xác nhận nó có thật đang nằm trong
`VitHeader.trailing` hoặc top custom header trước khi sửa.

## 9. Test matrix

### 9.1. Unit/widget tests

| Test area | Required assertions |
| --- | --- |
| `VitHeaderActionButton` | Icon, tooltip, semantics, enabled/disabled, active, badge, loading, size. |
| `VitHeader` | Title/subtitle, back, action row, legacy trailing fallback, max 3 actions. |
| Home | Search/notification route vẫn đúng, badge render đúng. |
| Markets | 3 quick actions route đúng. |
| Pair detail | Back, favorite toggle, share visible, selector tap route đúng. |
| Launchpad | Filter/performance/portfolio actions route đúng. |
| P2P/Wallet | Add/history/export actions route đúng. |

### 9.2. Quality guardrails

| Guardrail | Fails when |
| --- | --- |
| Header action catalog | Top header dùng icon ngoài catalog. |
| Header local button | `IconButton`/`InkWell` trực tiếp trong `VitHeader.trailing` không có allowlist. |
| Header action count | Right side có hơn 3 action. |
| Header semantics | Action thiếu tooltip/semantic label. |
| Header sizing | Action target dưới 40. |
| Auto-hide behavior | Fixed header quay lại ngoài allowlist. |

### 9.3. Full verification

Chạy từ `flutter_app/`:

```bash
dart format .
dart run tool/top_header_behavior_audit.dart
dart run tool/top_header_action_audit.dart
flutter analyze
flutter test --reporter=compact
```

Nếu thay đổi shared layout hoặc nhiều feature header, full test là bắt buộc.

## 10. Definition of Done

Chỉ đánh dấu hoàn thành khi tất cả điều kiện sau đạt:

- [ ] Không còn banned top-header icons ngoài allowlist.
- [ ] Custom trailing giảm về 0 hoặc mọi exception có lý do rõ.
- [ ] Header action catalog được dùng bởi Home, Markets, Trade, Launchpad, P2P,
  Wallet, Profile.
- [ ] Không có page tự vẽ header action mới khi shared primitive đủ dùng.
- [ ] Header action touch target đạt ít nhất `40x40`.
- [ ] Mọi icon action có tooltip/semantics.
- [ ] Mọi header right action có tối đa 3 nút, nếu nhiều hơn dùng `more`.
- [ ] Offline/status banner vẫn là banner, không nhập vào action row.
- [ ] `flutter analyze` pass.
- [ ] Focused tests cho các feature đã sửa pass.
- [ ] `flutter test --reporter=compact` pass nếu đụng shared layout.
- [ ] Emulator QA ít nhất Home, Markets, Trade, Wallet, Rewards không overlap.

## 11. AI execution prompt

Khi giao cho AI triển khai, dùng prompt này:

```text
Đọc kỹ:
1. AGENTS.md
2. docs/00_START_HERE.md
3. docs/03_DESIGN_SYSTEM/Guidelines.md
4. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md
5. docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Behavior-Audit.md

Nhiệm vụ:
Triển khai từng phase theo thứ tự trong
VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md.

Không được:
- Bỏ qua audit baseline.
- Tự thêm icon ngoài canonical catalog.
- Tự vẽ local header button nếu shared primitive cover được.
- Đổi route/product copy không liên quan.
- Trộn Arena Points với wallet/profit/payout language.
- Revert thay đổi không liên quan trong working tree.

Mỗi work packet phải:
1. Nêu phạm vi file sẽ sửa.
2. Sửa code bằng shared primitives.
3. Cập nhật hoặc thêm test.
4. Chạy format/analyze/focused tests.
5. Cập nhật audit artifact nếu audit thay đổi.
6. Báo rõ còn exception nào và lý do.
```

## 12. Recommended work packets

| Packet | Scope | Output |
| ---: | --- | --- |
| 1 | Baseline action audit | Audit Markdown/CSV + guardrail skeleton. |
| 2 | Add `VitHeaderActionButton` | Shared primitive + tests. |
| 3 | Add `VitHeader.actions` API | Backward-compatible header upgrade + tests. |
| 4 | Migrate Home + Notifications | Canonical search/bell + badge. |
| 5 | Migrate Markets + Pair detail | Canonical market actions, favorite/share. |
| 6 | Migrate Launchpad + P2P home | Canonical filter/analytics/portfolio/add/history. |
| 7 | Migrate Wallet/Profile high-traffic headers | Canonical add/export/settings/history. |
| 8 | Migrate remaining custom trailing | Reduce exceptions; update allowlist. |
| 9 | Strict guardrail enforcement | Audit fails on drift. |
| 10 | Emulator visual QA | Screenshots + final report. |

Không làm packet 4-8 trước khi packet 1-3 xong.

## 13. Risk notes

- Header là shared surface; thay đổi nhỏ có thể ảnh hưởng hàng trăm màn.
- Một số local header button đang giữ test keys; khi migrate phải preserve key
  hoặc update test có chủ đích.
- Một số custom header như Trade pair selector là domain control, không nên ép
  thành `VitHeader` tiêu chuẩn nếu làm mất usability.
- Dark professional không có nghĩa là tất cả màu tối giống nhau. Cần giữ layer:
  `bg`, `surface`, `surface2`, `surface3`, `border`, `text1/text2/text3`.
- Crypto/trading app cần màu buy/sell rõ, nhưng không dùng green/red cho action
  điều hướng thông thường.
- Badge notification phải nổi nhưng không được làm header trông như alarm.

## 14. References

- Internal design source: `docs/03_DESIGN_SYSTEM/Guidelines.md`
- Header primitive: `flutter_app/lib/shared/layout/vit_header.dart`
- Icon button primitive: `flutter_app/lib/shared/widgets/vit_icon_button.dart`
- Auto-hide primitive: `flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart`
- Offline banner: `flutter_app/lib/shared/widgets/vit_offline_banner.dart`
- Existing top-header audit:
  `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Behavior-Audit.md`

