# VitTrade Top Header Dark Professional Polish Optimization Tracking Plan

Generated: 2026-06-03

Scope: Flutter-only VitTrade app trong `flutter_app/`.

Status: kế hoạch vòng polish/optimization tiếp theo. File này không thay thế các
plan đã hoàn thành; nó dùng để theo dõi vòng nâng cấp cuối cùng nhằm đưa top
header từ trạng thái "đúng guardrail" lên trạng thái "polished, trading-grade,
dark professional".

## 1. Mục tiêu

Hoàn thiện top header để đạt chuẩn:

- Dark professional.
- Crypto exchange.
- Trading super-app.
- Phone-first từ 360 px.
- Không gây nhiễu trong flow tài chính/rủi ro cao.
- Không làm lệch lại các quyết định đã khóa: search theo scope, notification
  badge toàn cục qua shell/bottom nav, action header tối đa 3 nút.

Mục tiêu của vòng này không phải sửa lỗi lớn vì audit hiện tại đã sạch. Mục tiêu
là nâng cấp độ hoàn thiện sản phẩm:

- Token hóa toàn bộ kích thước, padding, typography, surface, divider của top
  header.
- Làm các root module cùng nhịp visual.
- Làm instrument/trading header giàu ngữ cảnh hơn nhưng vẫn gọn.
- Chuẩn hóa trạng thái auto-hide/collapsed/elevated khi scroll.
- Siết accessibility, tooltip, semantics, hit target.
- Tạo visual QA/golden/screenshot guardrail để không bị drift lại.
- Cập nhật audit để nhận diện bridge/transitive header như `RewardsHubPage`.

## 2. Source of truth phải đọc trước khi triển khai

Thứ tự đọc bắt buộc:

1. `AGENTS.md`
2. `docs/00_START_HERE.md`
3. `docs/03_DESIGN_SYSTEM/Guidelines.md`
4. `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md`
5. `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md`
6. `docs/02_FLUTTER_MIGRATION/VitTrade-Global-Search-Notifications-Access-Tracking-Plan.md`
7. `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Visual-Archetype-Audit.md`
8. `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Action-Audit.md`
9. `docs/02_FLUTTER_MIGRATION/VitTrade-Top-Header-Global-Access-Policy-Audit.md`
10. `flutter_app/lib/shared/layout/vit_header.dart`
11. `flutter_app/lib/shared/layout/vit_top_chrome.dart`
12. `flutter_app/lib/shared/layout/vit_header_action_button.dart`
13. `flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart`

## 3. Baseline hiện tại

Audit gần nhất đang sạch:

```text
total_routed_screens=414
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

vit_header_total=381
vit_header_with_custom_trailing=0
vit_header_with_legacy_action=0
custom_header_targets=4
migration_candidates=0
banned_icon_usages=0
custom_button_usages=0
action_groups_over_limit=0

global_search_actions=1
module_search_actions=2
content_search_controls=34
global_notification_actions=1
context_notification_actions=3
content_notification_icons=36
policy_violations=0
```

Ý nghĩa:

- Không có lỗi visual strict hiện tại.
- Không có header vượt quá giới hạn 3 action.
- Search/notification đã đúng scope.
- Offline/status banner không còn nằm sai trong header.
- Phần cần làm tiếp là polish và guardrail nâng cao, không phải vá lỗi nền.

## 4. Product standard cuối cùng

Top header phải tạo cảm giác:

| Tiêu chuẩn | Quy định |
| --- | --- |
| Trading-grade | Ưu tiên cặp giao dịch, giá, trạng thái rủi ro, back/close và action đúng flow. Không làm user rời flow tài chính bằng global action sai ngữ cảnh. |
| Exchange-grade | Surface tối, divider mảnh, title rõ, action ít, trạng thái live/stale/offline rõ ràng. |
| Super-app-grade | Nhiều module nhưng chỉ dùng một hệ chrome chung. Root module khác nhau nhưng cùng rhythm. |
| Dark professional | Không dùng gradient/orb/trang trí dư. Accent amber/gold chỉ cho action hoặc trạng thái cần nhấn. |
| Phone-first | 360 px không overlap title/action/badge. Touch target tối thiểu 40x40, ưu tiên 44x44 nếu không phá layout. |
| Accessibility | Tooltip/semantics phân biệt back, close, global search, module search, global inbox, context notification. |

## 5. Non-goals

Không làm trong vòng này:

- Không đổi route.
- Không đổi `/search` hoặc `/notifications`.
- Không thêm search/bell mặc định vào mọi top header.
- Không tăng giới hạn 3 action.
- Không refactor toàn bộ page content ngoài vùng top header.
- Không đổi business logic trading, wallet, P2P, earn, launchpad.
- Không ép fullscreen chart/trading workspace dùng top header thường.
- Không đưa offline banner vào header.
- Không làm theme light.
- Không tạo hero marketing trên màn hình app vận hành.
- Không thay action catalog bằng icon local tự vẽ.

## 6. Kiểu top header hiện tại cần giữ

| Archetype | Count | Vai trò | Hướng polish |
| --- | ---: | --- | --- |
| `rootBrand` | 1 | Home brand/command center. | Giữ search + inbox bell, polish spacing/badge. |
| `rootModule` | 6 | Module root như Markets, Wallet, P2P. | Đồng bộ title rhythm, action placement, divider, scroll state. |
| `instrument` | 3 | Pair/trade instrument. | Tăng độ scan pair/price/selector, giữ action đúng trading context. |
| `detail` | 398 | Subpage/detail/form/list. | Giữ gọn, ổn định title/subtitle/loading, không thêm action dư. |
| `fullscreenTool` | 5 | Chart/chat/bot/futures/workspace. | Không top header; phải có exit/back trong tool UI. |
| `authOnboarding` | 1 | Login/onboarding entry. | Cho phép custom chrome; không dùng trading header. |

## 7. File targets dự kiến

| File | Việc cần kiểm tra/cải thiện |
| --- | --- |
| `flutter_app/lib/shared/layout/vit_top_chrome.dart` | Token hóa dimensions, root/instrument/detail rhythm, collapsed/elevated state nếu cần. |
| `flutter_app/lib/shared/layout/vit_header.dart` | Token hóa detail header, title/subtitle loading stability, semantics, trailing behavior. |
| `flutter_app/lib/shared/layout/vit_header_action_button.dart` | Kiểm tra 40x40/44x44 hit target, focus/tooltip/badge tone. |
| `flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart` | Scroll/collapsed/elevated behavior, no overlap, safe area. |
| `flutter_app/lib/app/theme/` | Thêm hoặc gom top-header tokens nếu cần. |
| `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` | RootBrand polish: spacing, badge, action tone. |
| `flutter_app/lib/features/markets/presentation/widgets/market_list_header.dart` | RootModule/action density polish. |
| `flutter_app/lib/features/markets/presentation/widgets/pair_detail_header_widgets.dart` | Instrument/pair selector polish. |
| `flutter_app/lib/features/trade/presentation/pages/trade_page_part_01.dart` | Instrument/trade header polish. |
| `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart` | RootModule parity. |
| `flutter_app/lib/features/profile/presentation/pages/profile_page.dart` | RootModule parity. |
| `flutter_app/lib/features/p2p/presentation/pages/p2p_home_page.dart` | RootModule parity; status banner vẫn ở content. |
| `flutter_app/lib/features/launchpad/presentation/pages/launchpad_page.dart` | RootModule parity; 3 action vẫn không overflow. |
| `flutter_app/lib/features/arena/presentation/pages/arena_points_page_part_01.dart` | Rewards bridge/rootModule parity. |
| `flutter_app/tool/top_header_visual_archetype_audit.dart` | Nhận diện bridge/transitive header, token drift, screenshot manifest. |
| `flutter_app/tool/top_header_action_audit.dart` | Giữ action catalog guardrail. |
| `flutter_app/tool/top_header_global_access_policy_audit.dart` | Giữ search/notification policy. |
| `flutter_app/test/shared/layout/` | Unit/widget tests cho primitive. |
| `flutter_app/test/features/*` | Focused tests cho rootBrand/rootModule/instrument. |
| `flutter_app/run-artifacts/top_header_polish/` | Visual QA artifacts mới. |

## 8. Thứ tự triển khai bắt buộc

Không nhảy phase. Sau mỗi phase phải cập nhật tracking board ở cuối file này,
chạy test/audit tương ứng và ghi evidence.

### Phase 0 - Baseline audit và inventory khóa phạm vi

Mục tiêu: xác nhận lại hiện trạng trước khi sửa.

- [x] Đọc đầy đủ source of truth ở mục 2.
- [x] Chạy `rg` xác nhận vị trí dùng `VitHeader`.
- [x] Chạy `rg` xác nhận vị trí dùng `VitTopChrome`.
- [x] Chạy `rg` xác nhận vị trí dùng `VitAutoHideHeaderScaffold`.
- [x] Chạy visual archetype audit strict.
- [x] Chạy action audit strict.
- [x] Chạy global access policy audit.
- [x] Xuất lại danh sách 6 archetype và count.
- [x] Ghi rõ root module nào dùng `VitTopChrome` trực tiếp và root module nào đi qua bridge.
- [x] Không sửa code trong phase này.

Commands:

```bash
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_global_access_policy_audit.dart --check
flutter analyze
```

Expected:

- `strict_visual_issues=0`
- `action_groups_over_limit=0`
- `policy_violations=0`

### Phase 1 - Top header token contract

Mục tiêu: không còn magic number rải rác trong header primitives.

- [x] Quyết định vị trí token:
  - `flutter_app/lib/app/theme/app_top_header_tokens.dart`, hoặc
  - gom trong file theme hiện có nếu repo đã có pattern tương tự.
- [x] Token tối thiểu phải có:
  - `detailMinHeight`
  - `rootMinHeight`
  - `instrumentMinHeight`
  - `horizontalPadding`
  - `rootTopPadding`
  - `rootBottomPadding`
  - `actionGap`
  - `titleGap`
  - `detailTitleSize`
  - `rootTitleSize`
  - `instrumentTitleSize`
  - `subtitleSize`
  - `buttonSize`
  - `badgeMinSize`
  - `dividerColor`
  - `surfaceColor`
  - `elevatedSurfaceColor` nếu có collapsed/elevated state.
- [x] Token phải dùng theme hiện có: `AppColors`, `AppSpacing`, `AppTextStyles`.
- [x] Không tạo palette mới ngoài theme.
- [x] Không đổi visual quá mạnh trong phase token hóa; chỉ gom nguồn sự thật.
- [x] Cập nhật `VitTopChrome` dùng token.
- [x] Cập nhật `VitHeader` dùng token nếu phù hợp.
- [x] Cập nhật test primitive để verify min height/button size không drift.
- [x] Chạy format/analyze/focused tests.

Commands:

```bash
cd flutter_app
dart format lib/app/theme lib/shared/layout test/shared/layout
flutter analyze
flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_top_chrome_test.dart test/shared/layout/vit_header_action_button_test.dart --reporter=compact
```

### Phase 2 - Primitive polish cho `VitTopChrome` và `VitHeader`

Mục tiêu: root/detail/instrument cùng hệ surface, divider, safe area, title
overflow, action row.

- [x] Kiểm tra `VitTopChromeType.detail` có thực sự map sang `VitHeader` ổn định.
- [x] Kiểm tra `VitTopChromeType.rootBrand` và `rootModule` có cùng root rhythm nhưng không làm Home quá giống module thường.
- [x] Kiểm tra `VitTopChromeType.instrument` có body linh hoạt cho pair selector/price.
- [x] Kiểm tra `VitHeaderVariant.page` và `standard` có alignment đúng ở title ngắn/dài/subtitle.
- [x] Title dài phải ellipsis, không đè action.
- [x] Subtitle dài phải ellipsis, không tăng chiều cao quá mức.
- [x] Header không được đổi chiều cao khi badge count đổi 0 -> 1 -> 99+.
- [x] Header actions vẫn tối đa 3.
- [x] Không dùng `trailing` custom trong `VitHeader` nếu action catalog đủ dùng.
- [x] Thêm tests cho long title/subtitle ở 360 px.
- [x] Thêm tests cho badge count `99+`.
- [x] Thêm tests cho transparent header nếu đang được dùng.

Commands:

```bash
cd flutter_app
flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_top_chrome_test.dart --reporter=compact
dart run tool/top_header_action_audit.dart --check --strict
```

### Phase 3 - Root module visual parity

Mục tiêu: Markets, Wallet, P2P, Profile, Launchpad, Rewards có cùng nhịp root
module.

- [x] Kiểm tra từng root module:
  - Home `rootBrand`
  - Markets `rootModule`
  - Wallet `rootModule`
  - P2P `rootModule`
  - Profile `rootModule`
  - Launchpad `rootModule`
  - Rewards `rootModule` qua bridge.
- [x] Root module title phải cùng size/hierarchy.
- [x] Root module subtitle phải cùng tone.
- [x] Root module action row phải cùng button primitive.
- [x] Root module không có global bell/search sai scope.
- [x] Root module không có title chính bị lặp trong content ngay dưới header nếu gây double-title.
- [x] Root module không có offline/status banner trong header.
- [x] `RewardsHubPage` phải được audit nhận diện rõ là transitive `VitTopChrome(rootModule)` hoặc có exception note rõ.
- [x] Không ép Home thành rootModule thường; Home vẫn là `rootBrand`.
- [x] Chụp visual 360/390/440 cho root modules.

Focused tests:

```bash
cd flutter_app
flutter test test/features/home/home_page_test.dart test/features/markets/market_list_page_test.dart test/features/wallet/wallet_page_test.dart test/features/profile/profile_page_test.dart test/features/p2p/p2p_home_page_test.dart test/features/launchpad/launchpad_page_test.dart test/features/rewards/rewards_hub_page_test.dart --reporter=compact
```

### Phase 4 - Instrument/trading header refinement

Mục tiêu: Pair/trade header phải giống trading exchange thật: scan nhanh, ít
nhiễu, action đúng ngữ cảnh.

- [x] Kiểm tra `PairDetailPage` instrument header.
- [x] Kiểm tra `TradePage` default route instrument header.
- [x] Kiểm tra `TradePage` pair route instrument header.
- [x] Pair selector phải rõ là button/selectable.
- [x] Pair/title không bị truncate quá sớm ở 360 px.
- [x] Price/change micro-state nếu nằm trong header phải dùng text style và màu đúng token.
- [x] Favorite/share chỉ hiện khi đúng context.
- [x] Không có global notification bell trong instrument header.
- [x] Không có global search trong instrument header.
- [x] Action count không vượt 3.
- [x] Header không che chart/order book/order form khi scroll.
- [x] Back/close behavior rõ ở pair detail và trade sub-route.

Focused tests:

```bash
cd flutter_app
flutter test test/features/markets/pair_detail_page_test.dart test/features/trade/trade_page_test.dart --reporter=compact
dart run tool/top_header_global_access_policy_audit.dart --check
```

### Phase 5 - Detail header stability

Mục tiêu: 398 detail routes dùng chung header ổn định, không bị lệch khi title
dài/loading/empty/error/offline.

- [x] Audit các detail route có `expectedActionCount > 0`.
- [x] Kiểm tra detail route có subtitle dài.
- [x] Kiểm tra detail route có loading skeleton.
- [x] Kiểm tra detail route có empty/error/offline state.
- [x] Header title không phụ thuộc data async nếu có thể dùng title route ổn định.
- [x] Nếu title lấy từ data async, phải có fallback không làm layout nhảy.
- [x] Detail header không tự vẽ button local.
- [x] Detail header không dùng icon không có trong action catalog.
- [x] Detail header không có status/offline banner trong header.
- [x] Detail header không có global search/bell sai ngữ cảnh.
- [x] Thêm hoặc cập nhật audit nếu phát hiện pattern dễ drift.

Audit commands:

```bash
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_global_access_policy_audit.dart --check
```

### Phase 6 - Fullscreen/no-header contract

Mục tiêu: các route không có top header vẫn an toàn, không làm user kẹt.

- [x] Kiểm tra `LoginPage`.
- [x] Kiểm tra `EnterpriseStatesPage`.
- [x] Kiểm tra `P2PChatPage`.
- [x] Kiểm tra `AdvancedChartPage`.
- [x] Kiểm tra `FuturesPage`.
- [x] Kiểm tra `TradingBotsPage`.
- [x] Mỗi route không header phải có lý do trong audit.
- [x] Mỗi fullscreen route phải có back/close/exit trong UI hoặc navigation shell phù hợp.
- [x] Không dùng no-header để né chuẩn header ở route thường.
- [x] Audit fail nếu xuất hiện no-header route mới không có reason.
- [x] Visual QA phải chụp ít nhất 2 fullscreen route.

Commands:

```bash
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check --strict
flutter test test/app/router/app_router_test.dart --reporter=compact
```

### Phase 7 - Status/offline/data freshness polish

Mục tiêu: mọi offline/stale/reconnecting state đúng chuẩn trading safety.

- [x] Không có `VitOfflineBanner` trong header.
- [x] Offline banner chỉ hiện khi có state thật:
  - `offlineWithCache`
  - `reconnecting`
  - high-risk offline read-only state.
- [x] `offlineNoCache` dùng error/empty state + retry, không giả vờ có dữ liệu mới nhất.
- [x] Market/trade/wallet/P2P stale state phải nói rõ dữ liệu không live.
- [x] Financial submit/confirm phải disabled nếu offline.
- [x] Status banner nằm dưới header trong content flow.
- [x] Status banner không làm top header nhảy chiều cao.
- [x] Audit vẫn báo:
  - `status_banner_in_header=0`
  - `hard_coded_offline_banner=0`
- [x] Visual QA có ảnh route online và offline/cached nếu harness hỗ trợ.

Commands:

```bash
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check --strict
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
```

### Phase 8 - Accessibility, semantics, tooltip

Mục tiêu: screen reader và QA automation hiểu đúng scope của mọi action.

- [x] Back button semantics: `Quay lại`.
- [x] Close button semantics: `Đóng`.
- [x] Home search tooltip/semantics: `Tìm kiếm toàn cục`.
- [x] Module search tooltip/semantics phân biệt module/content.
- [x] Global notification tooltip/semantics: `Thông báo`.
- [x] Context notification tooltip/semantics không giả làm global inbox:
  - Convert
  - Launchpad claim receipt
  - P2P claim detail
- [x] Badge semantics đọc được unread count.
- [x] `99+` badge vẫn có semantics rõ.
- [x] Instrument pair selector có semantics là button.
- [x] Header action hit target đạt chuẩn.
- [x] Focus order: left -> body/selector -> right actions.
- [x] Không có icon-only action thiếu tooltip.

Focused tests:

```bash
cd flutter_app
flutter test test/shared/layout/vit_header_action_button_test.dart test/shared/layout/vit_bottom_nav_test.dart --reporter=compact
flutter test test/features/home/home_page_test.dart test/features/trade/convert_page_test.dart test/features/launchpad/launchpad_claim_receipt_page_test.dart test/features/p2p/p2p_claim_detail_page_test.dart --reporter=compact
```

### Phase 9 - Visual QA artifacts và golden/screenshot manifest

Mục tiêu: có bằng chứng ảnh thật cho từng archetype và viewport.

- [x] Tạo thư mục artifact:
  `flutter_app/run-artifacts/top_header_polish/`.
- [x] Capture tối thiểu các viewport:
  - 360 x 800
  - 390 x 844
  - 440 x 956
- [x] Capture route `rootBrand`:
  - Home.
- [x] Capture root modules:
  - Markets
  - Wallet
  - P2P
  - Profile
  - Launchpad
  - Rewards.
- [x] Capture instrument:
  - Pair detail.
  - Trade.
- [x] Capture detail:
  - Notifications.
  - Wallet withdraw.
  - P2P order/detail.
  - Launchpad receipt.
- [x] Capture fullscreen/no-header:
  - Advanced chart hoặc Futures.
  - P2P chat hoặc Trading bots.
- [x] Visual checklist cho mỗi ảnh:
  - Không overlap title/action.
  - Không double-title khó chịu.
  - Không có global bell/search sai scope.
  - Bottom nav badge không che header.
  - Header không bị cắt bởi safe area.
  - Badge không giống critical alarm.
  - Divider/surface đúng dark professional.
  - 360 px vẫn đọc được title chính.
- [x] Không dùng emulator cho Phase 9; dùng widget screenshot harness, không có serial/package/activity cần ghi.
- [x] Lưu screenshot names có route + viewport rõ ràng.

Commands tham khảo:

```bash
cd flutter_app
flutter build apk --debug
adb devices
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell am start -n com.vittrade.vit_trade_flutter/.MainActivity
```

### Phase 10 - Audit nâng cao và guardrail regression

Mục tiêu: mọi polish có audit/test chặn drift.

- [x] Cập nhật visual archetype audit để nhận diện bridge/transitive header nếu cần.
- [x] Audit phải phân biệt:
  - direct `VitTopChrome`
  - transitive `VitTopChrome`
  - shared `VitHeader`
  - no-header exception.
- [x] Audit phải fail nếu:
  - no-header route mới không có reason.
  - rootModule route không có root-module chrome hoặc transitive exception.
  - status/offline banner quay lại header.
  - action count vượt 3.
  - global search/bell xuất hiện sai scope.
  - magic number token drift trong header primitive nếu implement được check.
- [x] Guardrail tests phải chạy trong suite quality.
- [x] Markdown/CSV artifact phải được cập nhật.
- [x] Không để audit chỉ pass vì allowlist quá rộng.

Commands:

```bash
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart
dart run tool/top_header_action_audit.dart
dart run tool/top_header_global_access_policy_audit.dart
flutter test test/quality/top_header_visual_guardrail_test.dart test/quality/top_header_action_guardrail_test.dart test/quality/top_header_global_access_policy_guardrail_test.dart --reporter=compact
```

### Phase 11 - Final verification

Mục tiêu: xác nhận toàn bộ vòng polish hoàn tất.

- [x] `dart format --output=none --set-exit-if-changed lib test tool` pass.
- [x] `flutter analyze` pass.
- [x] Focused tests pass.
- [x] Quality guardrail tests pass.
- [x] Route coverage audit pass.
- [x] Navigation edge audit pass.
- [x] Top-header action audit strict pass.
- [x] Top-header visual archetype audit strict pass.
- [x] Global access policy audit pass.
- [x] Full `flutter test --reporter=compact` pass.
- [x] Emulator/visual QA artifacts đầy đủ.
- [x] Tracking board cập nhật đầy đủ evidence.

Commands:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze
dart run tool/top_header_action_audit.dart --check --strict
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/top_header_global_access_policy_audit.dart --check
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter test --reporter=compact
```

## 9. Route checklist bắt buộc cho visual QA

| Archetype | Route/page | Viewport | Screenshot | Pass/Fail | Notes |
| --- | --- | --- | --- | --- | --- |
| `rootBrand` | Home | 360/390/440 | `[x]` | `[x]` | Search + inbox bell đúng scope; files in `root_modules/home_*`. |
| `rootModule` | Markets | 360/390/440 | `[x]` | `[x]` | 3 action không overflow; files in `root_modules/markets_*`. |
| `rootModule` | Wallet | 360/390/440 | `[x]` | `[x]` | Không global bell/search; files in `root_modules/wallet_*`. |
| `rootModule` | P2P | 360/390/440 | `[x]` | `[x]` | Offline/status không nằm trong header; files in `root_modules/p2p_*`. |
| `rootModule` | Profile | 360/390/440 | `[x]` | `[x]` | Identity rõ, không double-title; files in `root_modules/profile_*`. |
| `rootModule` | Launchpad | 360/390/440 | `[x]` | `[x]` | 3 action đúng rhythm; files in `root_modules/launchpad_*`. |
| `rootModule` | Rewards | 360/390/440 | `[x]` | `[x]` | Bridge route vẫn root-module visual; files in `root_modules/rewards_*`. |
| `instrument` | Pair detail | 360/390/440 | `[x]` | `[x]` | Pair selector/action không overlap; files in `instrument/pair_detail_*`. |
| `instrument` | Trade | 360/390/440 | `[x]` | `[x]` | Trading context ưu tiên pair/price; files in `instrument/trade_pair_*`. |
| `detail` | Notifications | 360/390/440 | `[x]` | `[x]` | Không có bell mở chính nó; files in `detail/notifications_*`. |
| `detail` | Wallet withdraw | 360/390/440 | `[x]` | `[x]` | High-risk không có global bell/search; files in `detail/wallet_withdraw_*`. |
| `detail` | P2P order/detail | 360/390/440 | `[x]` | `[x]` | Financial flow không bị nhiễu; files in `detail/p2p_order_*`. |
| `detail` | Launchpad receipt | 360/390/440 | `[x]` | `[x]` | Context notification rõ scope nếu có; files in `detail/launchpad_claim_receipt_*`. |
| `fullscreenTool` | Advanced chart/Futures | 390/440 | `[x]` | `[x]` | Có exit/back trong tool UI; files in `fullscreen/advanced_chart_*`. |
| `fullscreenTool` | P2P chat/Trading bots | 390/440 | `[x]` | `[x]` | Không dùng no-header sai mục đích; files in `fullscreen/p2p_chat_*`. |

## 10. Risk checklist

- [x] Token hóa làm thay đổi visual quá mạnh.
- [x] Header height đổi gây vỡ screenshot/layout test.
- [x] Root module bị double-title.
- [x] Instrument header mất thông tin pair/price quan trọng.
- [x] Badge unread quá nổi, giống critical risk.
- [x] Search/bell bị thêm sai scope khi polish action row.
- [x] Offline banner quay lại header.
- [x] Fullscreen route bị mất back/exit.
- [x] Audit allowlist quá rộng làm che lỗi thật.
- [x] Full test fail do hit-test warning chuyển thành fatal.

Mitigation:

- Mỗi phase chỉ sửa một nhóm.
- Sau mỗi phase chạy focused tests.
- Mọi thay đổi visual có screenshot artifact.
- Không sửa route/business logic trừ khi test chỉ ra cần thiết.
- Không revert unrelated dirty worktree changes.

## 11. Definition of done

Plan này chỉ hoàn tất khi:

- [x] Tất cả phase 0 -> 11 hoàn thành theo thứ tự.
- [x] Top header tokens có source of truth rõ ràng.
- [x] Root module visual parity được xác nhận bằng screenshot.
- [x] Instrument header giữ trading context và không có global action sai scope.
- [x] Detail header ổn định với title/subtitle dài/loading/error/offline.
- [x] Fullscreen/no-header routes có reason và exit/back rõ.
- [x] Status/offline banner không nằm trong header.
- [x] Search/notification policy vẫn pass.
- [x] Header action count vẫn tối đa 3.
- [x] Audit artifacts Markdown/CSV current.
- [x] Visual QA artifacts đầy đủ trong `flutter_app/run-artifacts/top_header_polish/`.
- [x] `flutter analyze` pass.
- [x] Full `flutter test --reporter=compact` pass.
- [x] Tracking board có evidence cho từng phase.

## 12. Tracking board

| Phase | Status | Owner note | Evidence |
| --- | --- | --- | --- |
| Phase 0 - Baseline audit/inventory | `[x]` | Completed 2026-06-03: source docs read, UI design-system checked, inventory locked before code edits. | `rg`: `VitHeader(`=381, `VitTopChrome(`=14, `VitAutoHideHeaderScaffold(`=385; visual audit strict pass (`strict_visual_issues=0`, `rootModule=6`, `rootBrand=1`, `instrument=3`); action audit strict pass (`action_groups_over_limit=0`); global access policy pass (`policy_violations=0`); `flutter analyze` pass. Root modules direct `VitTopChrome`: Home, Launchpad, Markets, P2P, Profile, Wallet; Rewards is bridge/transitive via `RewardsHubPage` -> `ArenaPointsPage`. |
| Phase 1 - Top header token contract | `[x]` | Completed 2026-06-03: added `AppTopHeaderTokens` and wired `VitTopChrome`, `VitHeader`, and `VitHeaderActionButton` to shared top-header metrics/colors without changing product routes or action policy. | `dart format ...` pass; `flutter analyze` pass; `flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_top_chrome_test.dart test/shared/layout/vit_header_action_button_test.dart --reporter=compact` pass (`12` tests). |
| Phase 2 - Primitive polish | `[x]` | Completed 2026-06-03: added primitive coverage for 360px long title/subtitle stability, title badge `99+` clamp without height shift, transparent header surface, and token alias stability. | `dart format test/shared/layout/vit_header_test.dart` pass; `flutter test test/shared/layout/vit_header_test.dart test/shared/layout/vit_top_chrome_test.dart --reporter=compact` pass (`12` tests); `dart run tool/top_header_action_audit.dart --check --strict` pass (`action_groups_over_limit=0`). |
| Phase 3 - Root module parity | `[x]` | Completed 2026-06-03: rootBrand/rootModule parity verified; Rewards is audited as transitive `VitTopChrome(rootModule)` through the bridge, Home remains `rootBrand`. | `dart run tool/top_header_visual_archetype_audit.dart --check --strict` pass (`strict_visual_issues=0`, `uses_vit_top_chrome=15`); `dart run tool/top_header_global_access_policy_audit.dart --check` pass (`policy_violations=0`); focused root module tests pass (`41` tests, existing non-fatal wallet hit-test warning observed); 21 screenshots captured in `flutter_app/run-artifacts/top_header_polish/root_modules/` for Home, Markets, Wallet, P2P, Profile, Launchpad, Rewards at 360/390/440. |
| Phase 4 - Instrument header refinement | `[x]` | Completed 2026-06-03: Pair detail and Trade instrument headers keep trading context, scoped actions, and the 3-action limit. | `flutter test test/features/markets/pair_detail_page_test.dart test/features/trade/trade_page_test.dart --reporter=compact` pass (`14` tests); `dart run tool/top_header_global_access_policy_audit.dart --check` pass (`policy_violations=0`); `dart run tool/top_header_action_audit.dart --check --strict` pass (`action_groups_over_limit=0`). |
| Phase 5 - Detail header stability | `[x]` | Completed 2026-06-03: detail routes remain on shared header primitives with stable scoped actions and no status/offline banner inside header. | `dart run tool/top_header_visual_archetype_audit.dart --check --strict` pass (`detail=398`, `strict_visual_issues=0`, `status_banner_in_header=0`, `hard_coded_offline_banner=0`); `dart run tool/top_header_action_audit.dart --check --strict` pass (`action_groups_over_limit=0`); `dart run tool/top_header_global_access_policy_audit.dart --check` pass (`policy_violations=0`); detail focused tests pass (`30` tests). |
| Phase 6 - Fullscreen/no-header contract | `[x]` | Completed 2026-06-03: no-header exceptions are constrained to auth/onboarding or fullscreen workspaces with documented reasons and exit/back coverage. | `dart run tool/top_header_visual_archetype_audit.dart --check --strict` pass (`fullscreenTool=5`, `authOnboarding=1`, `strict_visual_issues=0`); `flutter test test/app/router/app_router_test.dart --reporter=compact` pass (`4` tests); focused no-header tests pass (`35` tests); 4 fullscreen screenshots captured in `flutter_app/run-artifacts/top_header_polish/fullscreen/` for Advanced chart and P2P chat at 390/440. |
| Phase 7 - Status/offline polish | `[x]` | Completed 2026-06-03: offline/status banners stay outside header, remain state-driven, and high-risk offline UI uses shared primitives. | `dart run tool/top_header_visual_archetype_audit.dart --check --strict` pass (`status_banner_in_header=0`, `hard_coded_offline_banner=0`); audit CSV shows state-driven content placement only for Search, TopicHub, EnterpriseStates, and P2P; `flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact` pass (`1` test). |
| Phase 8 - Accessibility/semantics | `[x]` | Completed 2026-06-03: header actions, bottom nav badge, Home global actions, and context notification routes keep explicit semantics/tooltip scope. | `flutter test test/shared/layout/vit_header_action_button_test.dart test/shared/layout/vit_bottom_nav_test.dart --reporter=compact` pass (`4` tests); `flutter test test/features/home/home_page_test.dart test/features/trade/convert_page_test.dart test/features/launchpad/launchpad_claim_receipt_page_test.dart test/features/p2p/p2p_claim_detail_page_test.dart --reporter=compact` pass (`25` tests). |
| Phase 9 - Visual QA artifacts | `[x]` | Completed 2026-06-03: canonical screenshot set and manifest created for all required header archetypes and phone viewports. | `flutter test tool/capture_route_screenshot_test.dart ...` pass for all captures; canonical PNGs: `root_modules=21`, `instrument=6`, `detail=12`, `fullscreen=4` (`43` total) under `flutter_app/run-artifacts/top_header_polish/`; manifest written at `flutter_app/run-artifacts/top_header_polish/manifest.md`; spot-checked representative screenshots for pair detail, wallet withdraw, notifications, and advanced chart. |
| Phase 10 - Audit/guardrail regression | `[x]` | Completed 2026-06-03: audit artifacts regenerated; visual audit now recognizes Rewards transitive chrome narrowly; quality guardrails include token contract coverage. | `dart run tool/top_header_visual_archetype_audit.dart` pass/write (`uses_vit_top_chrome=15`, `strict_visual_issues=0`); `dart run tool/top_header_action_audit.dart` pass/write (`action_groups_over_limit=0`); `dart run tool/top_header_global_access_policy_audit.dart` pass/write (`policy_violations=0`); `dart run tool/top_header_behavior_audit.dart` pass/write (`fixed_vit_header_remaining=0`, `no_top_header=6`); quality guardrail tests pass (`5` tests). |
| Phase 11 - Final verification | `[x]` | Completed 2026-06-03: final verification finished after Phase 0 -> 10, no route/search/notification/business-logic policy drift found. | `dart format --output=none --set-exit-if-changed lib test tool` pass (`2426` files, `0 changed`); `flutter analyze` pass; action/visual/global audits pass; route coverage and navigation edge audits pass; full `flutter test --reporter=compact` pass (`1958` tests). Existing wallet chart hit-test warning observed but non-fatal and unchanged; visual QA artifacts complete in `flutter_app/run-artifacts/top_header_polish/`. |

## 13. Execution prompt cho AI triển khai

Dùng prompt này khi giao AI thực hiện:

```text
Đọc kỹ AGENTS.md, docs/00_START_HERE.md, docs/03_DESIGN_SYSTEM/Guidelines.md,
VitTrade-Top-Header-Dark-Professional-Standardization-Plan.md,
VitTrade-Top-Header-Visual-Consistency-Completion-Plan.md,
VitTrade-Global-Search-Notifications-Access-Tracking-Plan.md và
VitTrade-Top-Header-Dark-Professional-Polish-Optimization-Tracking-Plan.md.

Thực hiện đúng thứ tự Phase 0 -> Phase 11. Không bỏ qua audit. Không thêm search
hoặc notification bell vào mọi top header. Không đổi route /search hoặc
/notifications. Không tăng giới hạn 3 action. Không đưa offline banner vào
header. Không đổi business logic tài chính/trading.

Mục tiêu là polish top header đạt chuẩn Dark professional / crypto exchange /
trading super-app: token hóa header primitive, root module parity, instrument
header refinement, detail header stability, no-header contract, accessibility,
visual QA artifacts và guardrail regression.

Sau mỗi phase, cập nhật tracking board trong file plan, chạy test/audit tương
ứng và ghi evidence. Nếu phát hiện drift hoặc policy conflict, dừng phase đó,
ghi rõ blocker và không nhảy sang phase tiếp theo.
```
