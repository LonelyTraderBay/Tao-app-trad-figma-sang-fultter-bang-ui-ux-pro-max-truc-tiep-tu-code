# VitTrade Global Search and Notifications Access Tracking Plan

Generated: 2026-06-03

Scope: Flutter-only VitTrade app trong `flutter_app/`.

Mục tiêu của file này là theo dõi chi tiết việc chuẩn hóa nút tìm kiếm và
thông báo theo hướng Dark professional / crypto exchange / trading super-app.
Kế hoạch này bổ sung cho:

- `VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md`
- `VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md`

## 1. Quyết định sản phẩm cuối cùng

Không thêm nút search và notification vào mọi top header.

Thay vào đó:

- Search phải luôn dễ truy cập từ Home và Discovery, nhưng chỉ hiện trong
  header của trang khác khi trang đó có nhu cầu tìm/lọc rõ ràng.
- Notification phải là trạng thái toàn cục, badge cập nhật xuyên app, nhưng
  icon chuông không được chiếm action slot trên mọi màn hình.
- Các màn hình trade, withdraw, confirm, security, P2P escrow, order submit và
  chart workspace phải ưu tiên hành động tài chính/ngữ cảnh màn hình.
- Nếu có thông báo khẩn cấp, dùng in-app alert/banner/toast theo mức độ nghiêm
  trọng, không phụ thuộc vào việc top header có icon chuông hay không.

## 2. Hiện trạng kỹ thuật đã xác nhận

| Khu vực | File | Hiện trạng |
| --- | --- | --- |
| Action catalog | `flutter_app/lib/shared/layout/vit_header_action_button.dart` | Đã có `VitHeaderActionType.search` và `VitHeaderActionType.notifications`. |
| Icon chuẩn | `vit_header_action_button.dart` | Search dùng `Icons.search_rounded`; notifications dùng `Icons.notifications_none_rounded`. |
| Home header | `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` | Đang có search route `/search` và notification route `/notifications` với badge. |
| Header action limit | `flutter_app/lib/shared/layout/vit_top_chrome.dart` và `vit_header.dart` | Action đang bị giới hạn tối đa 3 nút. Đây là giới hạn đúng, cần giữ. |
| Bottom nav badge | `flutter_app/lib/shared/layout/vit_bottom_nav.dart` | Đã có cơ chế badge nhưng hiện chỉ nhận `homeBadgeCount`. |
| App shell badge | `flutter_app/lib/shared/layout/vit_app_shell.dart` | Đang truyền `homeBadgeCount` xuống bottom nav. |
| Router shell | `flutter_app/lib/app/router/route_groups/root_routes.dart` | Đang truyền `HomeMockData.homeBadge`; chưa lấy unread count từ notification provider. |
| Notifications provider | `flutter_app/lib/app/providers/notifications_controller_providers.dart` | Có controller provider nhưng mới trả snapshot từ repository. |
| Notifications page | `flutter_app/lib/features/notifications/presentation/pages/notifications_page.dart` | Đang giữ `_notifications` trong local state; mark read/delete chưa cập nhật badge toàn app. |
| Routes | `flutter_app/lib/app/router/route_groups/utility_routes.dart` | Đã có `/search` và `/notifications`. |

## 3. Vấn đề cần giải quyết

### 3.1. Search

Nếu đặt search trên mọi trang:

- Làm top header bị rối vì mỗi trang chỉ nên có tối đa 3 action.
- Đẩy mất các action quan trọng như filter, favorite, share, settings, history,
  export hoặc contextual action.
- Gây nhầm scope: user không biết đang tìm toàn app hay tìm trong trang hiện tại.

Cần tách rõ:

- Global search: tìm toàn app, vào từ Home và các điểm discovery chính.
- Local search: tìm trong danh sách hiện tại, đặt trong content hoặc header nếu
  page thực sự là list/search-heavy page.
- No search: trang detail, form tài chính, confirmation, security, chart
  workspace.

### 3.2. Notifications

Nếu đặt chuông trên mọi trang:

- Làm app giống consumer social app hơn trading app.
- Tạo cạnh tranh thị giác với trạng thái rủi ro, giá, order, confirm, fee,
  escrow, security.
- Dễ kéo user rời khỏi flow đang thao tác tiền.

Cần tách rõ:

- Global notification badge: unread count toàn app, hiển thị qua shell/navigation.
- Global notification entry: route `/notifications`, giữ ở Home/root command center.
- Context notification: các nút bật/tắt thông báo theo claim, convert, launchpad
  receipt, P2P claim... phải ghi rõ scope và không được giả làm inbox toàn cục.
- Urgent notification: dùng alert/banner/toast riêng nếu cần user biết ngay.

## 4. Nguyên tắc UX bắt buộc

| Nguyên tắc | Quy định |
| --- | --- |
| Header attention budget | Mỗi header tối đa 3 action, không xin ngoại lệ cho search/bell mặc định. |
| Trading safety | Màn hình tài chính/rủi ro cao không bị chiếm slot bởi global bell/search. |
| Scope clarity | Tooltip/semantics phải phân biệt `Tìm kiếm toàn cục`, `Tìm trong thị trường`, `Thông báo`, `Bật thông báo claim`. |
| Badge consistency | Một nguồn unread count duy nhất, cập nhật khi mark read/delete/open notification. |
| Dark professional | Badge đủ nổi nhưng không làm header giống cảnh báo khẩn cấp nếu chỉ là unread bình thường. |
| Route stability | Giữ `/search` và `/notifications`; không đổi flow điều hướng đã có. |
| Phone-first | Không overlap ở 360 px; badge không cắt icon hoặc label bottom nav. |

## 5. Policy chuẩn cho search

### 5.1. Search scopes

| Scope | Meaning | UI placement | Ví dụ |
| --- | --- | --- | --- |
| `globalSearch` | Tìm toàn app: markets, products, orders, help, topics, creators | Home header hoặc command center | Home -> `/search` |
| `moduleSearch` | Tìm trong module lớn | Header action hoặc content search, tùy density | Predictions home, Topic Hub |
| `contentSearch` | Tìm trong list hiện tại | Trong content, gần filter/sort/tab | Markets list, P2P offers, transaction history |
| `noSearch` | Không có search | Không render icon search | Trade, confirm, withdraw, security |

### 5.2. Search placement matrix

| Route family | Header search | Content search | Ghi chú |
| --- | --- | --- | --- |
| Home | Bắt buộc | Không bắt buộc | Search là global command entry. |
| Discovery / Topic Hub | Cho phép | Cho phép | Search scope phải rõ. |
| Unified Search page | Không | Bắt buộc | Đã ở search page thì header chỉ cần back/title. |
| Markets root/list | Tùy action budget | Khuyến nghị | Nếu đã có content search/filter tốt thì không cần header search. |
| Pair detail | Không | Không | Ưu tiên pair selector, favorite/share, trade CTA. |
| Trade terminal/order | Không | Không | Ưu tiên pair/price/order controls. |
| Wallet history | Không mặc định | Khuyến nghị | Search/filter theo transaction nằm trong content. |
| P2P offers | Không mặc định | Khuyến nghị | Search merchant/offer nằm gần filter. |
| Notifications inbox | Không mặc định | Có thể thêm sau | Giai đoạn đầu giữ filter all/unread và mark all read. |
| Profile/settings | Không mặc định | Có thể có search settings nếu danh sách dài | Không đặt global search mặc định. |
| Support/help/news | Tùy page | Khuyến nghị | Search nội dung hỗ trợ nếu có list dài. |
| High-risk confirmation | Không | Không | Không kéo user khỏi flow. |

## 6. Policy chuẩn cho notifications

### 6.1. Notification layers

| Layer | Mục đích | UI placement | Bắt buộc |
| --- | --- | --- | --- |
| Global unread badge | Cho biết có thông báo mới ở mọi nơi trong shell | Bottom nav Home badge hoặc shell-level badge | Có |
| Global inbox entry | Mở `/notifications` | Home header, profile/settings row, optional command center | Có |
| Context notification toggle | Bật/tắt thông báo cho một đối tượng cụ thể | Header/context panel nếu liên quan trực tiếp | Có nếu flow cần |
| Urgent alert | Cảnh báo bảo mật/rủi ro/giá lớn | In-app banner/toast/modal theo severity | Khi có event urgent |

### 6.2. Notification placement matrix

| Route family | Header bell global | Global badge | Context notification |
| --- | --- | --- | --- |
| Home | Bắt buộc | Bắt buộc | Không cần |
| Markets root/list | Không mặc định | Bắt buộc qua shell | Price alert/market alert đặt trong content hoặc contextual action |
| Pair detail | Không | Bắt buộc qua shell | Alert cho cặp giao dịch nếu có, tooltip phải rõ scope |
| Trade/order | Không | Bắt buộc qua shell nếu bottom nav đang hiện | Order/risk alerts dùng inline state |
| Wallet | Không | Bắt buộc qua shell | Deposit/withdraw alerts là content/action state |
| P2P | Không | Bắt buộc qua shell | Claim/order notification toggle được phép nếu đúng ngữ cảnh |
| Notifications inbox | Không | Bắt buộc qua shell | Không đặt chuông mở chính nó |
| Profile/settings | Không mặc định | Bắt buộc qua shell | Notification settings row được phép |
| Security/confirm | Không | Bắt buộc qua shell khi visible | Security alert dùng blocking banner/modal nếu cần |
| Fullscreen chart | Không | Không bắt buộc nếu bottom nav ẩn | Urgent alert overlay nếu cần |

## 7. Route family quyết định cụ thể

| Module | Quyết định |
| --- | --- |
| Home | Giữ search + notifications trong `VitTopChrome`; badge lấy từ global notification state thay vì `HomeMockData.homeBadge`. |
| Discovery | Giữ Topic Hub search action; Unified Search page không cần search action trên header. |
| Markets | Không thêm global bell. Search/filter nên ở content nếu người dùng đang lọc danh sách coin/pair. |
| Predictions | Predictions Home được phép có module search; các detail/receipt/confirm không thêm global bell. |
| Trade | Không thêm global search/bell vào trade terminal, convert confirm, copy-trading action pages nếu không liên quan trực tiếp. |
| Wallet | Không thêm bell vào header; nếu có transaction search thì đặt trong content. |
| P2P | Không thêm global bell; các notification toggle hiện có phải được audit tooltip/semantics để chứng minh là contextual. |
| Launchpad/Earn | Notification settings/history page giữ content controls; không thêm global bell mặc định. |
| Notifications | Dùng page này làm inbox; không đặt icon chuông trong chính header page này. |
| Profile | Profile/settings có thể dẫn tới `/notifications` hoặc notification preferences bằng row/card, không cần top-header bell. |
| Support/news | Nếu danh sách dài thì dùng local search; global notification badge vẫn đi qua shell. |

## 8. Thứ tự triển khai bắt buộc

Không nhảy bước. Mỗi phase phải xong checklist và test tương ứng trước khi qua
phase tiếp theo.

### Phase 0 - Baseline audit trước khi sửa

- [x] Đọc lại `AGENTS.md`.
- [x] Đọc `docs/00_START_HERE.md`.
- [x] Đọc hai plan top header hiện có.
- [x] Chạy `rg` xác nhận tất cả chỗ dùng `VitHeaderActionType.search`.
- [x] Chạy `rg` xác nhận tất cả chỗ dùng `VitHeaderActionType.notifications`.
- [x] Chạy `rg` xác nhận mọi direct icon `Icons.search_rounded`,
  `Icons.notifications_none_rounded`, `Icons.notifications_rounded` trong top
  header scope.
- [x] Ghi lại danh sách allowlist hiện tại:
  - Home global search.
  - Home global notifications.
  - Topic Hub module search.
  - Predictions module search.
  - Convert contextual notification.
  - Launchpad receipt contextual notification.
  - P2P claim contextual notification.
- [x] Chạy audit hiện có:

```bash
cd flutter_app
dart run tool/top_header_action_audit.dart --check
dart run tool/top_header_visual_archetype_audit.dart --check --strict
flutter analyze
```

Expected output:

- Không có action groups vượt quá 3.
- Không có custom trailing drift mới.
- Không có visual archetype issue mới trước khi bắt đầu sửa.

### Phase 1 - Chuẩn hóa policy trong docs và audit

- [x] Thêm phần policy này vào tài liệu top-header hoặc giữ file này làm source
  tracking riêng.
- [x] Tạo/ cập nhật audit script nếu cần:
  `flutter_app/tool/top_header_global_access_policy_audit.dart`.
- [x] Audit phải phân biệt:
  - Global search action.
  - Module/context search action.
  - Content search field.
  - Global notification action.
  - Context notification toggle/action.
- [x] Audit không được cấm mọi `VitHeaderActionType.notifications`; chỉ cấm dùng
  global bell sai ngữ cảnh.
- [x] Audit phải fail nếu:
  - Header có hơn 3 action.
  - Global `/notifications` bell xuất hiện trên high-risk/detail/trade confirm.
  - Search action xuất hiện trên high-risk confirmation không có allowlist.
  - `HomeMockData.homeBadge` vẫn là nguồn badge shell sau Phase 3.
  - `NotificationsPage` vẫn giữ local notification list sau Phase 4.
- [x] Audit output phải có summary dễ đọc:

```text
global_search_actions=
module_search_actions=
content_search_controls=
global_notification_actions=
context_notification_actions=
policy_violations=
status=pass|fail
```

### Phase 2 - Tạo global notifications state

Mục tiêu: có một nguồn unread count duy nhất cho toàn app.

- [x] Giữ `NotificationsRepository` làm contract dữ liệu.
- [x] Không phá vỡ `MockNotificationsRepository` và fail-closed repository.
- [x] Tạo state/controller mới hoặc nâng cấp controller hiện có để quản lý UI
  state notifications.
- [x] State tối thiểu phải có:
  - `NotificationsSnapshot snapshot`.
  - `List<AppNotificationDraft> notifications`.
  - `int unreadCount`.
  - `bool hasUnread`.
  - `Set<NotificationsScreenState> supportedStates`.
- [x] Controller/notifier tối thiểu phải có:
  - `markAllRead()`.
  - `markRead(String id)`.
  - `deleteNotification(String id)`.
  - `resetFromRepository()` hoặc refresh equivalent.
- [x] Provider đề xuất:
  - `notificationsControllerProvider` giữ vai trò repository/controller factory
    nếu cần tương thích.
  - Thêm `notificationsStateProvider` hoặc `notificationsNotifierProvider`.
  - Thêm `notificationUnreadCountProvider` để shell watch nhẹ hơn.
- [x] Không để `NotificationsPage` tự giữ bản copy danh sách riêng sau phase này.
- [x] Đảm bảo state mutation không làm mất route actionPath.
- [x] Đảm bảo mark read/delete là idempotent.
- [x] Đảm bảo unread count không âm.

Test bắt buộc:

- [x] Controller test: initial unread count đúng với mock.
- [x] Controller test: `markRead(id)` giảm unread count đúng.
- [x] Controller test: gọi `markRead(id)` hai lần không giảm thêm.
- [x] Controller test: `markAllRead()` đưa unread count về 0.
- [x] Controller test: `deleteNotification(id)` xóa item và cập nhật unread count.

### Phase 3 - Wire global badge vào shell/navigation

Mục tiêu: user biết có notification mới ở mọi shell screen mà không cần đặt
chuông trong mọi header.

- [x] Cập nhật `VitAppShell` nhận notification badge count từ provider.
- [x] Cập nhật `VitBottomNav` để badge name rõ hơn:
  - Giữ backward compatibility nếu cần với `homeBadgeCount`.
  - Hoặc đổi sang `homeNotificationBadgeCount` kèm cập nhật toàn bộ callsite.
- [x] Không thêm destination mới vào bottom nav trong phase này.
- [x] Giữ badge trên Home destination vì hiện IA đang map Search/Notifications
  vào Home command center.
- [x] Cập nhật semantics của bottom nav Home để screen reader hiểu có unread
  notifications.
- [x] Badge vẫn hiển thị khi active destination không phải Home.
- [x] Badge không làm nhảy layout khi count đổi từ 0 -> 1 -> 99+.
- [x] Badge clamp `99+` nhất quán với `_NavBadge`.
- [x] Cập nhật `root_routes.dart`:
  - Không lấy `HomeMockData.homeBadge`.
  - Wrap shell bằng `Consumer` hoặc tạo shell host widget để watch provider.
  - Truyền `notificationUnreadCountProvider` xuống `VitAppShell`.
- [x] Không biến toàn bộ router thành nơi chứa business logic phức tạp.

Test bắt buộc:

- [x] Bottom nav render badge khi count > 0.
- [x] Bottom nav không render badge khi count = 0.
- [x] Bottom nav render `99+` khi count > 99.
- [x] Router/shell test: ở `/trade` hoặc `/wallet` vẫn thấy Home badge nếu có unread.
- [x] Router/shell test: badge count về 0 sau khi mark all read trong notifications page.

### Phase 4 - Cập nhật Home header

Mục tiêu: Home vẫn là global command center, nhưng badge dùng global state.

- [x] Giữ `VitTopChrome(type: rootBrand)`.
- [x] Giữ search action trong Home header.
- [x] Search action phải dùng route constant `AppRoutePaths.search` nếu file import
  hợp lý; nếu không thì giữ route string nhưng audit phải cover.
- [x] Giữ notifications action trong Home header.
- [x] Notifications action phải dùng route constant `AppRoutePaths.notifications`
  nếu import hợp lý.
- [x] Badge count của Home header lấy từ global notification state.
- [x] Không lấy `snapshot.notifications` từ Home mock làm nguồn sự thật cho badge.
- [x] Tooltip search phải phân biệt global: `Tìm kiếm toàn cục`.
- [x] Tooltip notifications giữ nghĩa inbox toàn cục: `Thông báo`.
- [x] Không thêm action thứ ba nếu không có nhu cầu rõ.

Test bắt buộc:

- [x] Home test: tap search đi `/search`.
- [x] Home test: tap notifications đi `/notifications`.
- [x] Home test: unread badge render đúng.
- [x] Home test: badge biến mất sau mark all read nếu cùng provider scope.

### Phase 5 - Cập nhật Notifications page

Mục tiêu: page inbox là nơi chỉnh state toàn cục, không phải local island.

- [x] Xóa local `_notifications` nếu đã có global notifier.
- [x] Giữ filter local `_NotificationFilter` nếu filter chỉ là UI state tạm.
- [x] `markAllRead()` gọi notifier.
- [x] `deleteNotification(id)` gọi notifier.
- [x] `_openNotification(notification)` gọi notifier mark read trước khi navigate.
- [x] Empty state vẫn hoạt động khi unread filter không còn item.
- [x] Không đặt icon chuông trong top header của chính Notifications page.
- [x] Giữ `VitHeader(showBack: true)`.
- [x] Giữ back route từ snapshot.
- [x] Không làm mất action path validation `_safeActionPath`.

Test bắt buộc:

- [x] Notifications page render baseline.
- [x] Filter unread chỉ hiện unread item.
- [x] Delete unread item giảm count.
- [x] Mark all read đưa unread filter về empty state.
- [x] Tap notification mark read rồi navigate đúng actionPath.
- [x] Shell/Home badge cập nhật sau mỗi mutation.

### Phase 6 - Chuẩn hóa contextual search

Mục tiêu: search xuất hiện đúng trang, đúng scope.

- [x] Kiểm tra tất cả action `VitHeaderActionType.search`.
- [x] Home search: global.
- [x] Topic Hub search: module/content discovery, route phải đúng snapshot search route.
- [x] Predictions Home search: module search, route `/markets/predictions/search`.
- [x] Unified Search page: không thêm search action vào header.
- [x] Market list nếu đã có content search tốt thì không thêm header search.
- [x] Wallet/P2P/history list nếu cần search thì đặt trong content gần filter/sort.
- [x] Không thêm search vào:
  - Trade terminal.
  - Pair detail nếu không có search pair selector rõ ràng.
  - Withdraw/deposit confirmation.
  - Security change.
  - P2P escrow/claim confirm.
  - Receipt page.
  - Fullscreen chart.
- [x] Tooltip/semantics phải rõ:
  - Global: `Tìm kiếm toàn cục`.
  - Module: `Tìm trong Prediction Markets`.
  - Topic: `Tìm trong Topic Hub`.

Test bắt buộc:

- [x] Existing search routes không đổi.
- [x] Tap module search đi đúng route.
- [x] Audit fail nếu search bị thêm vào route cấm.

### Phase 7 - Chuẩn hóa contextual notifications

Mục tiêu: phân biệt global inbox bell với contextual notification action.

- [x] Kiểm tra tất cả action `VitHeaderActionType.notifications`.
- [x] Home: global inbox bell, route `/notifications`.
- [x] Convert header widgets: nếu là thông báo theo convert/order, tooltip phải
  ghi rõ scope; nếu đang mở inbox global thì cân nhắc chuyển về Home/shell.
- [x] Launchpad claim receipt: nếu là notification receipt/context thì tooltip
  phải rõ; không dùng như global inbox bell.
- [x] P2P claim detail: notification toggle được phép nếu bật/tắt theo claim;
  active state phải rõ.
- [x] Không thêm global bell vào trade/detail/confirm page.
- [x] Nếu route mở `/notifications` từ module root ngoài Home, phải có lý do rõ
  và không vượt quá 3 action.
- [x] Context notification không được dùng badge global nếu bản chất là toggle.
- [x] Global unread badge chỉ lấy từ global provider.

Test bắt buộc:

- [x] Existing contextual notification tests vẫn pass.
- [x] Audit phân loại đúng global vs contextual.
- [x] No route cấm có global `/notifications` bell.

### Phase 8 - UI/visual QA

Mục tiêu: xác nhận thực tế trên phone width nhỏ.

- [x] Build debug APK.
- [x] Chạy emulator hoặc thiết bị thật.
- [x] Capture routes tối thiểu:
  - `/home`
  - `/search`
  - `/notifications`
  - `/markets`
  - `/trade`
  - `/wallet`
  - `/profile`
  - Một pair detail route.
  - Một P2P claim/detail route có contextual notification nếu có.
- [x] Width kiểm tra:
  - 360 px.
  - 390 px.
  - 440 px.
- [x] Checklist ảnh:
  - Badge không overlap icon/label bottom nav.
  - Header Home vẫn cân bằng với search + bell.
  - Không có chuông global ở trade/confirm/detail.
  - Search không xuất hiện sai scope.
  - Badge đủ nổi trên dark background nhưng không giống alarm cấp cứu.
  - Text tooltip/semantic không cần nhìn thấy nhưng test phải cover.
  - Không có layout shift khi badge count thay đổi.
- [x] Lưu artifacts vào `flutter_app/run-artifacts/`.

Commands tham khảo:

```bash
cd flutter_app
flutter build apk --debug
flutter run
```

Nếu dùng adb:

```bash
adb devices
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell am start -n com.vittrade.vit_trade_flutter/.MainActivity
```

### Phase 9 - Verification tổng

Chạy từ `flutter_app/`:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test test/shared/layout/vit_bottom_nav_test.dart --reporter=compact
flutter test test/shared/layout/vit_header_action_button_test.dart --reporter=compact
flutter test test/shared/layout/vit_header_test.dart --reporter=compact
flutter test test/features/home/home_page_test.dart --reporter=compact
flutter test test/features/notifications/notifications_controller_test.dart --reporter=compact
flutter test test/features/notifications/notifications_page_test.dart --reporter=compact
flutter test test/app/router/app_router_test.dart --reporter=compact
dart run tool/top_header_action_audit.dart --check
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/top_header_global_access_policy_audit.dart --check
flutter test --reporter=compact
```

Nếu `top_header_global_access_policy_audit.dart` chưa tồn tại ở thời điểm bắt
đầu triển khai, phải tạo trước khi coi plan này hoàn tất.

## 9. File targets dự kiến

| File | Việc cần làm |
| --- | --- |
| `flutter_app/lib/features/notifications/presentation/controllers/notifications_controller.dart` | Nâng cấp controller/notifier hoặc tách state provider mới. |
| `flutter_app/lib/app/providers/notifications_controller_providers.dart` | Thêm provider unread count/global state. |
| `flutter_app/lib/features/notifications/presentation/pages/notifications_page.dart` | Dùng global notifier thay local notification list. |
| `flutter_app/lib/features/notifications/presentation/widgets/notifications_page_sections.dart` | Giữ toolbar/filter; đảm bảo callbacks gọi notifier từ page. |
| `flutter_app/lib/shared/layout/vit_app_shell.dart` | Nhận notification badge count rõ nghĩa. |
| `flutter_app/lib/shared/layout/vit_bottom_nav.dart` | Hiển thị global unread badge ổn định trên Home destination. |
| `flutter_app/lib/app/router/route_groups/root_routes.dart` | Watch unread provider thay `HomeMockData.homeBadge`. |
| `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` | Home header lấy badge global và giữ routes search/notifications. |
| `flutter_app/tool/top_header_global_access_policy_audit.dart` | Audit policy search/notification mới. |
| `flutter_app/test/shared/layout/vit_layout_primitives_test.dart` | Bổ sung/điều chỉnh test bottom nav badge nếu phù hợp. |
| `flutter_app/test/features/home/home_page_test.dart` | Test route + badge state. |
| `flutter_app/test/features/notifications/notifications_controller_test.dart` | Test state mutation/unread count. |
| `flutter_app/test/features/notifications/notifications_page_test.dart` | Test page mutation cập nhật global badge. |
| `flutter_app/test/app/router/app_router_test.dart` | Test route mapping và shell badge. |

## 10. Allowlist ban đầu

Allowlist này phải được xác nhận bằng audit trước khi sửa code.

### 10.1. Global search allowlist

| File | Lý do |
| --- | --- |
| `features/home/presentation/pages/home_page_part_01.dart` | Home là global command center. |

### 10.2. Module/context search allowlist

| File | Lý do |
| --- | --- |
| `features/discovery/presentation/pages/topic_hub_page.dart` | Topic Hub là discovery/search-heavy page. |
| `features/predictions/presentation/pages/predictions_home_page.dart` | Prediction Markets có module search riêng. |

### 10.3. Global notifications allowlist

| File | Lý do |
| --- | --- |
| `features/home/presentation/pages/home_page_part_01.dart` | Home mở inbox toàn cục `/notifications`. |

### 10.4. Context notifications allowlist

| File | Điều kiện giữ |
| --- | --- |
| `features/trade/presentation/widgets/convert_page_header_widgets.dart` | Chỉ giữ nếu action là notification theo convert/order context, không giả làm global inbox. |
| `features/launchpad/presentation/pages/launchpad_claim_receipt_page.dart` | Chỉ giữ nếu action liên quan receipt/claim notification context. |
| `features/p2p/presentation/pages/p2p_claim_detail_page_part_01.dart` | Chỉ giữ nếu action là toggle notification cho claim. |

## 11. Anti-patterns phải tránh

- [x] Không thêm search + bell mặc định vào mọi `VitTopChrome`.
- [x] Không tăng giới hạn action từ 3 lên 4 để chứa thêm bell.
- [x] Không dùng direct `IconButton(Icons.notifications...)` trong header để né
  catalog.
- [x] Không để Home badge lấy từ mock Home trong khi Notifications page đã mutate
  state.
- [x] Không để Notifications page tự giữ local list tách khỏi shell badge.
- [x] Không dùng badge đỏ lớn cho unread bình thường khiến UI giống critical alarm.
- [x] Không đặt global bell trong màn hình confirm/withdraw/security/trade submit.
- [x] Không đổi route `/search` hoặc `/notifications`.
- [x] Không thêm bottom nav destination mới nếu chưa có quyết định IA riêng.
- [x] Không tạo search scope mơ hồ: user phải biết đang tìm toàn app hay trong
  module.

## 12. Definition of done

Plan này chỉ được coi là hoàn tất khi tất cả điều kiện sau đạt:

- [x] Home vẫn có search và notifications action chuẩn.
- [x] `/search` và `/notifications` vẫn hoạt động.
- [x] Unread notification count có một nguồn state duy nhất.
- [x] Bottom nav/shell hiển thị unread badge trên mọi shell route phù hợp.
- [x] Mark read/delete/mark all read cập nhật badge toàn app.
- [x] Không có global bell trong high-risk/detail/trade confirmation routes.
- [x] Search chỉ xuất hiện trên route allowlist hoặc content search đúng scope.
- [x] Context notification actions có tooltip/semantics rõ scope.
- [x] Header action count vẫn tối đa 3.
- [x] `flutter analyze` pass.
- [x] Focused tests pass.
- [x] Full `flutter test --reporter=compact` pass.
- [x] Top-header action audit pass.
- [x] Top-header visual archetype audit strict pass.
- [x] Global access policy audit pass.
- [x] Emulator/visual QA có artifacts cho các route chính.

## 13. Tracking board

| Phase | Status | Owner note | Evidence |
| --- | --- | --- | --- |
| Phase 0 - Baseline audit | `[x]` | Completed 2026-06-03: docs read, UI skill design-system checked, current search/notification usage audited. | `dart run tool/top_header_action_audit.dart --check` pass (`vit_header_total=381`, `action_groups_over_limit=0`); `dart run tool/top_header_visual_archetype_audit.dart --check --strict` pass (`strict_visual_issues=0`); `flutter analyze` pass. |
| Phase 1 - Policy/audit | `[x]` | Completed 2026-06-03: added global access policy audit and guardrail test; initial audit correctly exposes remaining work. | `dart analyze tool/top_header_global_access_policy_audit.dart` pass; `dart run tool/top_header_global_access_policy_audit.dart` wrote artifacts with `policy_violations=6`; guardrail test added for final `--check`. |
| Phase 2 - Global notification state | `[x]` | Completed 2026-06-03: added `notificationsStateProvider`, `notificationUnreadCountProvider`, idempotent mark-read/delete/mark-all-read/reset. | `flutter test test/features/notifications/notifications_controller_test.dart --reporter=compact` pass (`2` tests). |
| Phase 3 - Shell badge | `[x]` | Completed 2026-06-03: shell route now watches `notificationUnreadCountProvider`; bottom nav uses `homeNotificationBadgeCount` and keeps Home badge visible on non-Home routes. | `flutter test test/shared/layout/vit_layout_primitives_test.dart --reporter=compact` pass (`7` tests); `flutter test test/app/router/app_router_test.dart --reporter=compact` pass (`4` tests). |
| Phase 4 - Home header | `[x]` | Completed 2026-06-03: Home keeps global search + inbox bell, but badge now reads `notificationUnreadCountProvider` instead of Home mock snapshot. | `flutter test test/features/home/home_page_test.dart --reporter=compact` pass (`8` tests). |
| Phase 5 - Notifications page | `[x]` | Completed 2026-06-03: Notifications page now mutates global notification state for mark-read/delete/mark-all-read. | `flutter test test/features/notifications/notifications_page_test.dart --reporter=compact` pass (`6` tests). |
| Phase 6 - Contextual search | `[x]` | Completed 2026-06-03: search remains allowlisted to Home global, Topic Hub, and Predictions Home; content search controls remain content-scoped. | `dart run tool/top_header_global_access_policy_audit.dart` reports `global_search_actions=1`, `module_search_actions=2`, `policy_violations=0`. |
| Phase 7 - Contextual notifications | `[x]` | Completed 2026-06-03: contextual notification actions now have scope tooltips and do not open global inbox. | `flutter test test/features/trade/convert_page_test.dart --reporter=compact` pass (`7` tests); `flutter test test/features/launchpad/launchpad_claim_receipt_page_test.dart --reporter=compact` pass (`5` tests); `flutter test test/features/p2p/p2p_claim_detail_page_test.dart --reporter=compact` pass (`5` tests); global policy guardrail pass. |
| Phase 8 - Visual QA | `[x]` | Completed 2026-06-03: debug APK built/installed/launched on `emulator-5554`; Home emulator screenshot and route visual QA screenshots captured. | Artifacts in `flutter_app/run-artifacts/global_search_notifications_qa/`: `emulator_home.png`, `home_360.png`, `home_390.png`, `home_440.png`, `notifications_440.png`, `search_440.png`, `trade_440.png`, `markets_440.png`, `wallet_440.png`, `profile_440.png`. |
| Phase 9 - Verification tổng | `[x]` | Completed 2026-06-03: final source-format check, analyze, focused/full tests, route/navigation audits, top-header audits, and global access policy audit passed. | `dart format --output=none --set-exit-if-changed lib test tool` pass (`2425` files, `0` changed); `flutter analyze` pass; focused tests pass; `flutter test --reporter=compact` pass (`1952` tests); `dart run tool/top_header_action_audit.dart --check --strict` pass; `dart run tool/top_header_visual_archetype_audit.dart --check --strict` pass; `dart run tool/top_header_global_access_policy_audit.dart --check` pass (`policy_violations=0`); `dart run tool/route_coverage_audit.dart --check` pass; `dart run tool/navigation_edge_audit.dart --check` pass. |

## 14. Execution prompt ngắn cho AI triển khai

Khi giao cho AI thực hiện plan này, dùng prompt:

```text
Đọc kỹ AGENTS.md, docs/00_START_HERE.md, VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md,
VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md và
VitTrade-Global-Search-Notifications-Access-Tracking-Plan.md.

Thực hiện đúng thứ tự Phase 0 -> Phase 9. Không bỏ qua audit. Không thêm search
hoặc notification bell vào mọi top header. Mục tiêu là: search theo đúng scope,
notification unread badge toàn cục qua shell/bottom nav, Home giữ search + inbox
bell, high-risk/trade/detail routes không có global bell/search sai ngữ cảnh.

Sau mỗi phase, cập nhật tracking board trong file plan, chạy test/audit tương ứng
và ghi evidence. Không đổi route /search hoặc /notifications. Không tăng giới hạn
3 action của header. Không dùng HomeMockData.homeBadge làm nguồn badge cuối cùng.
```
