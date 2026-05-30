# Flutter Enterprise File Structure Audit

Generated: 2026-05-30
Scope: đánh giá lại mức độ enterprise-grade của cấu trúc Flutter hiện tại, tập
trung vào file/folder, layer boundary, controller/data coupling, design token
governance, file-size debt, router/test guardrails và production data readiness.

## Executive Verdict

VitTrade hiện đã đạt mức **enterprise architecture-ready** ở nền tảng cấu trúc:
source of truth nằm trong `flutter_app/`, runtime source được chia rõ thành
`app/`, `core/`, `features/`, `shared/`, toàn bộ `23/23` feature modules đã có
đủ `domain/data/presentation`, router đã tách route groups, shared UI primitives
đã có nền riêng, test inventory rộng, route coverage artifact đang current, và
quality guardrails đã bắt đầu khóa các nợ kiến trúc quan trọng.

Tuy nhiên, dự án **chưa nên được gọi là production enterprise-grade hoàn chỉnh**.
Lý do không còn nằm ở top-level folder layout, mà nằm ở các nợ hardening bên
trong module:

- Page/widget đã sạch direct data imports và controller data-provider exposure
  hiện đang ở `0`; `27` import/export còn lại đều là data-layer provider/mock
  wiring ngoài presentation boundary.
- File runtime quan trọng còn quá lớn, đặc biệt là mock repositories, entity
  barrels và một số page phức tạp.
- Design token governance đang được khóa bằng guardrail: runtime `Colors.*`
  hiện là `0`, và `Color(0x...)` ngoài `lib/app/theme/` là `0`.
- Controller state boundary thật cho high-risk financial flows vẫn chưa đủ sâu.
- Critical modules chưa có remote repositories/backend contracts thật; production
  data path vẫn phải fail-closed.

Verdict ngắn: **enterprise-shaped mạnh và architecture-ready, nhưng chưa đạt
production enterprise-grade hoàn chỉnh.**

## Evidence Snapshot

Các số liệu dưới đây phản ánh trạng thái repo hiện tại trong working tree ngày
2026-05-30.

| Hạng mục | Kết quả hiện tại | Nhận xét |
| --- | ---: | --- |
| `flutter_app/lib` Dart files | `1087` | Runtime source lớn, đã tập trung đúng app package. |
| `flutter_app/test` Dart files | `423` | Test inventory rộng và bám theo feature modules. |
| Feature modules | `23` | Tất cả module hiện có đủ `domain/data/presentation`. |
| Static route entries | `417` | Route coverage artifact đang current. |
| Real pages | `414` | Không còn route placeholder trong truth table. |
| Redirect aliases | `3` | Được phân loại rõ, không bị tính nhầm là screen thật. |
| Feature Dart files | `1006` | Phần lớn runtime code nằm đúng trong `features/`. |
| App Dart files | `54` | Bootstrap, router facade, route groups, theme nằm đúng `app/`. |
| Core Dart files | `5` | Có config/network/error/result/repository guard, nhưng còn mỏng cho production backend. |
| Shared Dart files | `21` | Shared layout/widget đã được tách riêng. |
| Feature modules đủ `domain/data/presentation` | `23/23` | Đạt baseline enterprise module layout. |
| Page/widget direct data imports | `0` | Đã đạt mục tiêu UI không import trực tiếp `features/*/data`. |
| Presentation-to-data imports | `0` | Pages/widgets/controllers không import trực tiếp feature data providers hoặc repositories. |
| Non-controller direct feature data imports | `27` | Chủ yếu là provider/data wiring ngoài controller boundary. |
| Controller data-provider exposure | `0` | Đạt guardrail hiện tại. |
| Controller mock/remote imports | `0` | Controller facades không expose mock hoặc remote repositories trực tiếp. |
| Runtime `Color(0x...)` matches | `186` | Tất cả nằm trong theme registry. |
| Runtime `Colors.*` matches | `0` | Đạt: không còn Material color direct usage trong runtime `lib`. |
| `Color(0x...)` trong `lib/test` | `210` | Đang được guard bằng architecture baseline. |
| Feature files trên 600 lines | `239` | Nợ file-size còn lớn, cần tách theo bounded context. |
| Feature files trên 1200 lines | `4` | Chỉ còn bốn file vượt 1200 lines sau S6 cleanup. |
| `presentation/controllers/` dirs | `23` | Mọi feature đã có controller/provider boundary, nhưng nhiều file còn là facade mỏng. |
| Remote provider wirings | `0` | Chưa có remote repositories production. |

## Verification Evidence

| Command | Result |
| --- | --- |
| `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` | Passed, `10` architecture guardrail tests during S8-01 refresh. |
| `dart run tool/route_coverage_audit.dart --check` | Passed during S8-01 refresh; route coverage artifact is current. |
| `flutter analyze` | Passed, no issues found during the latest S7 high-risk smoke fix verification. |
| `flutter test --reporter=compact` | Passed, `1,841` tests during S7-01 precondition verification. |
| `dart format --output=none --set-exit-if-changed .` | Passed, `1512` files and `0` changed during S7-01 precondition verification. |

## Implementation Progress

### Phase 1 / Wallet Controller Boundary - Completed For First Pass

Batch đầu tiên của Phase 1 đã xử lý module `wallet`, ưu tiên các luồng rủi ro
cao và sau đó chuyển toàn bộ Wallet pages khỏi repository provider call trực
tiếp.

Đã thực hiện:

- Thêm `WithdrawController`, `AddressAddController`, `TokenApprovalController`
  cùng immutable view-state/preview types cho withdraw, add address và token
  approval revoke.
- `WithdrawPage`, `AddressAddPage`, `WalletTokenApprovalPage` không còn gọi
  `walletRepositoryProvider` trực tiếp; các bước preview/confirm high-risk đi
  qua controller methods.
- Thêm read-model providers trong `wallet_controller.dart` cho các Wallet pages
  còn lại như wallet home, transaction history/detail, deposit, address book,
  buy crypto, transfer, portfolio analytics, gas optimizer, health score,
  pending deposits, withdraw limits, dust converter và network status.
- Toàn bộ `features/wallet/presentation/pages` hiện có `0` reference tới
  `walletRepositoryProvider`.
- Guardrail kiến trúc được tách rõ thành `non-controller direct feature data
  imports` và `presentation controller data-provider exposure`, để tiếp tục hạ
  controller/provider barrels về `0` mà không trộn với data-layer wiring.
- Thêm `test/features/wallet/wallet_controller_test.dart` để kiểm tra withdraw
  validation/preview, add-address preview và token approval revoke copy.

Verification sau batch Wallet:

| Command | Result |
| --- | --- |
| `flutter test test/features/wallet/wallet_controller_test.dart test/features/wallet/withdraw_page_test.dart test/features/wallet/address_add_page_test.dart test/features/wallet/wallet_token_approval_page_test.dart --reporter=compact` | Passed, 14 tests. |
| `flutter analyze` | Passed, no issues found. |
| `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` | Passed, 8 architecture guardrail tests. |
| `dart run tool/route_coverage_audit.dart --check` | Passed, route coverage artifact is current. |

Current Wallet status:

- `controller data-provider exposure` remains `0`, page/widget data imports
  remain `0`, and the remaining work is deeper view-state/error/offline
  behavior plus manual completion of the Address Add smoke blocker.

### Phase 1 / P2P High-Risk Controller Boundary - Completed For Provider Cleanup + First Pass

Batch tiếp theo đã bắt đầu với `p2p`, tập trung trước vào payment/risk/order vì
đây là nhóm flow có escrow, KYC/risk và payment-state clarity.

Đã thực hiện:

- Thêm `P2PPaymentMethodAddController` để sở hữu validation và preview cho
  add payment method.
- Thêm `P2PRiskAssessmentController` để expose risk review/material factors.
- Thêm `P2POrderController` để sở hữu paid-confirmation intent/copy cho order
  payment flow.
- Thêm `P2PExpressConfirmController` để sở hữu express confirmation title và
  order destination.
- `P2PPaymentMethodAddPage`, `P2PRiskAssessmentPage`, `P2POrderPage` và
  `P2PExpressConfirmPage` đã bắt đầu dùng controller boundary cho logic
  validation/preview/confirm thay vì giữ toàn bộ trong widget.
- Thêm `test/features/p2p/p2p_controller_test.dart` để kiểm tra payment-method
  preview, risk material factors, order paid preview và express confirmation.

Verification sau batch P2P:

| Command | Result |
| --- | --- |
| `flutter test test/features/p2p/p2p_controller_test.dart test/features/p2p/p2p_payment_method_add_page_test.dart test/features/p2p/p2p_risk_assessment_page_test.dart test/features/p2p/p2p_order_page_test.dart test/features/p2p/p2p_express_confirm_page_test.dart --reporter=compact` | Passed, 20 tests. |
| `flutter analyze` | Passed, no issues found. |
| `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` | Passed, 8 architecture guardrail tests. |
| `dart run tool/route_coverage_audit.dart --check` | Passed, route coverage artifact is current. |

Current P2P status:

- P2P page/widget direct data imports remain `0`, controller data-provider
  exposure remains `0`, and the remaining work is deeper state/error/offline
  behavior plus manual completion of the P2P Payment Add smoke blocker.

### Phase 1 / P2P Provider Barrel Cleanup + Trade High-Risk Batch - Completed 2026-05-26

Cập nhật mới nhất sau batch hiện tại:

- Hoàn tất chuyển các P2P presentation pages còn lại khỏi `p2pRepositoryProvider`; `features/p2p/presentation/pages` hiện còn `0` reference trực tiếp tới provider data-layer này.
- `p2p_controller.dart` hiện là read-model/controller boundary cho toàn bộ P2P page surface, không còn export provider barrel trực tiếp.
- Thêm Trade high-risk controller boundary batch đầu tiên cho `TradePage`, `CopyConfirmationPage`, `LeveragePage` và `MarginTradingPage`.
- Các màn Trade high-risk trên không còn gọi `tradeRepositoryProvider`, `previewOrder`, `submitOrder`, `submitCopyConfirmation`, `previewFuturesLeverage`, `submitFuturesLeverage` hoặc `getMarginTrading` trực tiếp trong page.
- Thêm `TradeOrderController`, `TradeCopyConfirmationController`, `TradeLeverageController`, `TradeMarginController` cùng provider/view-state request types trong `trade_controller.dart`.
- Thêm `trade_repository_facade.dart` như legacy presentation facade tạm thời cho các Trade pages chưa migrate, để giữ compatibility mà không tăng `controller data-provider exposure` vượt guardrail.
- Thêm `test/features/trade/trade_controller_test.dart` cho order submit, copy consent gate, leverage clamp/submit và margin mode totals/max amount.

Verification sau batch P2P + Trade:

| Command | Result |
| --- | --- |
| `flutter analyze` | Passed, no issues found. |
| `flutter test test/features/p2p --reporter=compact` | Passed, `308` tests. |
| `flutter test test/features/trade/trade_controller_test.dart test/features/trade/trade_page_test.dart test/features/trade/copy_confirmation_page_test.dart test/features/trade/leverage_page_test.dart test/features/trade/margin_trading_page_test.dart --reporter=compact` | Passed, `24` tests. |
| `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` | Passed, `8` architecture guardrail tests. |
| `dart run tool/route_coverage_audit.dart --check` | Passed, route coverage artifact is current. |
| `flutter test --reporter=compact` | Passed, `1,771` tests. |

Superseded status after later frontend hardening:

- P2P page-provider references are clean, page/widget data imports are `0`, and
  `presentation-to-data imports` across presentation are `0`.
- The tracked remaining debt is `27` non-controller feature-data imports outside
  presentation plus high-risk controller depth and file-size cleanup.

### Phase 1 / Trade Copy, Risk, Futures, Advanced Tools, Bot Safety - Completed 2026-05-26

Batch Trade tiếp theo đã xử lý đúng nhóm high-risk/complex flows còn dùng legacy
facade trong phạm vi được ưu tiên: copy/risk/copy-settings/provider flows,
Futures order, Advanced tools/order amendment và Bot emergency/security/suitability.

Đã thực hiện:

- Chuyển các page Trade được chỉ định khỏi direct `tradeRepositoryProvider` hoặc
  legacy facade call trong widget: `active_copies_page.dart`,
  `copy_configuration_page.dart`, `copy_settings_page.dart`,
  `provider_application_page.dart`, `pre_copy_assessment_page.dart`,
  `copy_provider_detail_page.dart`, `copy_trading_page.dart`,
  `copy_trading_v2_page.dart`, `provider_leaderboard_page.dart`,
  `provider_comparison_page.dart`, `provider_governance_page.dart`,
  `portfolio_risk_analysis_page.dart`, `risk_indicator_explainer_page.dart`,
  `risk_management_demo_page.dart`, `futures_page.dart`,
  `advanced_tools_demo_page.dart`, `orders_history_page.dart`,
  `bot_emergency_stop_page.dart`, `bot_security_settings_page.dart`,
  `bot_suitability_assessment_page.dart` và `trading_bots_page.dart`.
- Thêm controller/view-state boundary cho copy configuration/settings/active
  copies/provider application, risk management, Futures order preview/submit,
  order cancellation, advanced tools/order amendment, bot emergency stop,
  bot security settings, bot suitability và trading bot actions.
- Tách `trade_controller.dart` thành barrel 5 dòng và chuyển implementation sang
  `trade_controller_models.dart` (`419` dòng) và
  `trade_controller_providers.dart` (`266` dòng). File providers là nơi duy nhất
  trong Trade controllers còn import `data/providers`, vì vậy không làm tăng
  `controller data-provider exposure`.
- Cập nhật `test/features/trade/trade_controller_test.dart` để cover copy,
  futures, risk/order, advanced tools và bot safety intents.
- Các page trong batch này có `0` direct reference tới `tradeRepositoryProvider`,
  `tradeRepositoryFacadeProvider`, `tradeRepositoryFacade` hoặc
  `features/trade/data/providers`.

Verification sau batch Trade mở rộng:

| Command | Result |
| --- | --- |
| `dart format lib/features/trade/presentation/controllers/trade_controller.dart lib/features/trade/presentation/controllers/trade_controller_providers.dart lib/features/trade/presentation/controllers/trade_controller_models.dart ...` | Passed. |
| `flutter analyze` | Passed, no issues found. |
| `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` | Passed, `8` architecture guardrail tests. |
| `dart run tool/route_coverage_audit.dart --check` | Passed, route coverage artifact is current. |
| Focused Trade tests for the migrated pages/controllers | Passed, `103` tests. |
| `flutter test --reporter=compact` | Passed, `1,775` tests. |

Current status after later frontend hardening:

- Trade presentation no longer contributes page/widget direct data imports.
- `presentation-to-data imports` across presentation are `0`; the remaining
  `27` count is non-controller feature-data wiring outside presentation.
- Trade still has large runtime surfaces and should continue reducing file-size
  and high-risk controller depth without reintroducing presentation data imports.

## Folder Layout Assessment

### Top-Level Repo

```text
.
├── AGENTS.md
├── README.md
├── docs/
├── flutter_app/
│   ├── android/
│   ├── ios/
│   ├── lib/
│   ├── test/
│   ├── tool/
│   └── web/
└── .github/
```

Đánh giá: **đạt chuẩn định hướng mono-repo Flutter hiện tại**. App source,
tests, platform targets, tools và generated QA artifacts đều nằm dưới
`flutter_app/` hoặc `docs/`, đúng với source of truth trong `AGENTS.md`.
Không thấy dấu hiệu app Flutter bị trộn lại với root React/Vite/npm tooling cũ.

### Flutter App Source

```text
flutter_app/lib/
├── main.dart
├── app/
│   ├── router/
│   └── theme/
├── core/
├── features/
│   └── <feature>/
│       ├── domain/
│       ├── data/
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── widgets/
└── shared/
    ├── layout/
    └── widgets/
```

Đánh giá: **đạt chuẩn top-level enterprise layout**.

- `app/` giữ bootstrap, app shell, router facade, route groups và theme tokens.
- `core/` giữ cross-cutting non-UI boundaries như config, network, result/failure
  và guarded repository behavior.
- `features/` giữ feature-owned domain/data/presentation.
- `shared/` giữ reusable layout primitives và design-system widgets.
- `main.dart` là entrypoint duy nhất nằm ngoài các vùng trên.

## Module Layer Audit

| Feature | Domain | Data | Presentation | Dart files | Tests | Controllers | Đánh giá |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| `admin` | Có | Có | Có | 9 | 4 | 1 | Đạt layer cơ bản. |
| `arena` | Có | Có | Có | 32 | 26 | 1 | Đạt layer cơ bản, cần state boundary sâu hơn cho points/governance. |
| `auth` | Có | Có | Có | 13 | 6 | 2 | Có controller boundary tốt hơn mặt bằng chung. |
| `cross_module` | Có | Có | Có | 28 | 4 | 4 | Đạt layer cơ bản, cần giữ bridge boundary rõ. |
| `dca` | Có | Có | Có | 17 | 12 | 1 | Đạt layer cơ bản. |
| `dev` | Có | Có | Có | 10 | 4 | 1 | Đạt layer cơ bản cho internal tooling. |
| `discovery` | Có | Có | Có | 8 | 2 | 1 | Đạt layer cơ bản. |
| `earn` | Có | Có | Có | 74 | 68 | 1 | Coverage rộng, nhưng repository/entity file rất lớn. |
| `enterprise_states` | Có | Có | Có | 7 | 1 | 1 | Đạt layer cơ bản. |
| `home` | Có | Có | Có | 8 | 2 | 1 | Đã được chuẩn hóa với domain/repository/controller. |
| `launchpad` | Có | Có | Có | 30 | 24 | 1 | Đạt layer cơ bản, cần tách file theo surface. |
| `markets` | Có | Có | Có | 27 | 21 | 1 | Đạt layer cơ bản, còn token drift và mock data lớn. |
| `news` | Có | Có | Có | 7 | 1 | 1 | Đạt layer cơ bản. |
| `notifications` | Có | Có | Có | 7 | 1 | 1 | Đạt layer cơ bản. |
| `onboarding` | Có | Có | Có | 7 | 1 | 1 | Đạt layer cơ bản. |
| `p2p` | Có | Có | Có | 77 | 71 | 1 | Coverage rộng, module lớn, nhiều high-risk flows cần controller thật. |
| `predictions` | Có | Có | Có | 23 | 17 | 1 | Đạt layer cơ bản, cần risk/order state boundary sâu hơn. |
| `profile` | Có | Có | Có | 17 | 11 | 1 | Đạt layer cơ bản. |
| `referral` | Có | Có | Có | 11 | 5 | 1 | Đạt layer cơ bản. |
| `rewards` | Có | Có | Có | 7 | 1 | 1 | Đạt layer cơ bản, cần giữ Arena Points wording boundary. |
| `support` | Có | Có | Có | 9 | 3 | 1 | Đạt layer cơ bản. |
| `trade` | Có | Có | Có | 92 | 86 | 1 | Module lớn nhất, cần refactor mạnh về file size và high-risk controllers. |
| `wallet` | Có | Có | Có | 25 | 19 | 1 | Đạt layer cơ bản, high-risk wallet flows cần controller/state isolation hơn. |

Kết luận module audit: **23/23 feature modules đã đạt baseline folder layout**.
Điểm chưa đạt không phải thiếu folder layer, mà là độ sâu của boundary bên trong
layer.

## Enterprise Strengths

### 1. Top-Level Architecture Rõ Ràng

Dự án có cấu trúc đúng hướng cho một app Flutter lớn:

- App shell, router facade và theme nằm trong `app/`.
- Cross-cutting code nằm trong `core/`.
- Feature-owned code nằm trong `features/<feature>/`.
- Reusable UI primitives nằm trong `shared/`.
- Tests phản chiếu theo `features/`, `core/`, `shared/` và `quality/`.

Đây là nền tảng enterprise quan trọng vì giảm nguy cơ trộn app bootstrap, domain
logic, shared UI và platform code vào cùng một vùng.

### 2. Feature Module Layout Đã Đồng Nhất

Tất cả `23` feature modules đều có `domain`, `data` và `presentation`. `home`
trước đây là gap đáng chú ý, hiện đã được bổ sung domain entities, repository
contract, data provider/mock implementation và presentation controller.

Điểm này đưa repo từ trạng thái chỉ “enterprise-shaped” lên mức
“enterprise architecture-ready” về folder layout.

### 3. Page/Widget Import Boundary Đã Cải Thiện Mạnh

Page và widget trong `presentation/pages` hoặc `presentation/widgets` hiện có
`0` import/export trực tiếp tới `features/*/data`. Đây là cải thiện lớn vì UI
layer không còn đọc mock data hoặc data facade trực tiếp.

Chuẩn hiện tại:

- Page render state.
- Page gọi controller/provider facade.
- Data provider và mock implementation không bị expose trực tiếp vào page/widget.

Điểm còn lại là biến controller facade thành controller thật, không chỉ barrel.

### 4. Router Và Route Coverage Được Kiểm Soát

Router vẫn giữ public facade ở `app/router/app_router.dart`, trong khi route
declarations đã được chia theo route groups. Route truth table hiện ghi nhận:

- `417` total static route entries.
- `414` real pages.
- `3` redirect aliases.
- `0` placeholder/skeleton routes trong artifact hiện tại.

Đây là điểm mạnh vì số lượng route lớn nhưng vẫn có artifact và guardrail để
tránh route placeholder trượt vào production.

### 5. Shared UI Primitive Đã Có Nền

`shared/layout` và `shared/widgets` có các primitive quan trọng như
`VitAppShell`, `VitPageLayout`, `VitPageContent`, `VitHeader`, `VitBottomNav`,
`VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`, empty/error/offline/skeleton
states.

Nền shared UI này phù hợp với enterprise Flutter vì giúp giảm copy UI scaffold
trong từng page, giữ dark theme baseline và chuẩn hóa state presentation.

### 6. Quality Guardrails Đã Có Giá Trị Thực Tế

`flutter_app/test/quality/architecture_baseline_guardrails_test.dart` hiện khóa
các điểm quan trọng:

- Mọi feature phải có `domain/data/presentation`.
- Page/widget không được import data facades.
- Presentation controllers không được expose mock/remote repositories trực tiếp.
- Non-controller direct feature data imports không được tăng.
- Controller data-provider exposure không được tăng và phải hạ dần về `0`.
- Hardcoded color usage không được tăng.
- Large-file architecture debt không được tăng.

Guardrail hiện chưa phải đích cuối, nhưng đã ngăn repo trượt ngược sau mỗi batch
refactor.

## Enterprise Gaps

### G-01: Presentation Provider Coupling Đã Được Khóa Ở Baseline Hiện Tại

Trạng thái hiện tại:

- Page/widget direct data imports: `0`.
- Presentation-to-data imports toàn bộ `presentation/`: `0`.
- Non-controller direct feature data imports: `27`.
- Controller data-provider exposure: `0`.
- Controller mock/remote imports: `0`.

Diễn giải: page/widget/controller hiện không import data providers hoặc mock/
remote repositories trực tiếp. `27` import/export còn lại nằm trong data-layer
provider/mock wiring và tiếp tục được guard như non-controller data import debt.

Impact:

- Controller file vẫn cần tiếp tục được làm sâu bằng immutable view state hoặc
  intent methods cho các flow rủi ro cao.
- Khi wire remote backend thật, data-layer provider contract vẫn cần DTO/error/
  offline policy rõ để không rò rỉ lên presentation.

Next step:

- Tạo controller thật theo screen hoặc bounded flow, ví dụ
  `WithdrawController`, `AddressAddController`, `PredictionOrderController`.
- Controller expose immutable view state, loading/error/offline/submitting/success
  states và intent methods.
- Page chỉ import controller/domain/shared UI.
- Giữ presentation-to-data imports ở `0` và không tái tạo provider barrel trong
  presentation.

### G-02: File Lớn Là Nợ Kiến Trúc Lớn Nhất Còn Lại

Trạng thái hiện tại:

- Feature files trên `600` lines: `239`.
- Feature files trên `1200` lines: `4`.

Top offenders hiện tại:

| File | Lines | Nhóm nợ |
| --- | ---: | --- |
| `lib/features/predictions/presentation/pages/predictions_portfolio_page.dart` | `1249` | Prediction portfolio page còn cần tách widgets/controller. |
| `lib/features/predictions/presentation/pages/prediction_social_page.dart` | `1225` | Prediction social page còn cần tách widgets/controller. |
| `lib/features/trade/presentation/pages/trader_profile_page.dart` | `1225` | Trade profile surface còn cần tách widgets/controller. |
| `lib/features/profile/presentation/pages/vip_page.dart` | `1224` | Profile VIP surface còn cần tách widgets/controller. |
| `lib/features/p2p/domain/entities/p2p_entities.dart` | `4785` | Entity barrel quá lớn. |
| `lib/features/markets/data/repositories/mock_market_repository.dart` | `4483` | Market mock data lớn. |
| `lib/features/launchpad/data/repositories/mock_launchpad_repository.dart` | `3750` | Launchpad mock data lớn. |
| `lib/features/predictions/data/repositories/mock_predictions_repository.dart` | `2578` | Prediction mock data lớn. |

Impact:

- Review khó phát hiện regression vì một file chứa quá nhiều context.
- Ownership theo aggregate/use case chưa rõ.
- Mock data, transformation logic, repository behavior và domain model dễ bị
  trộn vào cùng file.
- Refactor backend sau này có thể tạo diff rất lớn và khó kiểm chứng.

Next step:

- Với `mock_*_repository.dart`, giữ repository class mỏng và chuyển fixture
  constants sang `data/fixtures/<area>_fixtures.dart`.
- Với `*_entities.dart`, giữ public barrel tương thích import cũ nhưng chuyển
  entity groups sang subfiles theo bounded context.
- Với page lớn, tách thành page shell, controller và local widgets dưới
  `presentation/widgets/`.
- Ưu tiên theo thứ tự: `earn`, `trade`, `p2p`, `arena`, `markets`, `launchpad`,
  `predictions`, `wallet`.

### G-03: Design Token Drift Đã Được Khóa

Trạng thái hiện tại:

- Runtime `Color(0x...)`: `186`.
- Runtime `Color(0x...)` ngoài `app/theme`: `0`.
- Tổng `Color(0x...)` trong `lib/test`: `210`.
- Runtime `Colors.*`: `0`.

Guardrail hiện khóa không cho hardcoded color ngoài theme và không cho
`Colors.*` runtime quay lại. `AppColors`, `AppModuleAccents` và `AppAssetColors`
đang là registry chính.

Impact:

- Token mới vẫn cần được thêm qua registry theme, không thêm trực tiếp trong
  page/widget.
- Visual QA cần tiếp tục phân biệt intentional data visualization với color
  drift bằng registry rõ ràng.

Next step:

- Giữ guardrail `Color(0x...)` ngoài `lib/app/theme/` ở `0`.
- Giữ guardrail `Colors.*` runtime ở `0`.
- Chỉ thêm màu data visualization bằng token registry được đặt tên rõ.

### G-04: High-Risk Flows Chưa Có Controller State Boundary Đủ Sâu

Hiện mọi feature đã có `presentation/controllers/`, nhưng nhiều controller còn
mỏng. Với app crypto/trading, enterprise-grade cần controller state thật cho
các flow rủi ro cao.

Các flow cần ưu tiên:

| Module | Flow cần controller thật | Lý do |
| --- | --- | --- |
| `wallet` | Withdraw, address add, token approval/revoke | Liên quan tài sản, địa chỉ, phí, limit, preview/confirm. |
| `p2p` | Payment method, order confirm, risk assessment, dispute evidence | Liên quan escrow, KYC, AML, payment ownership. |
| `trade` | Order confirmation, copy confirmation, margin/copy risk | Liên quan execution, leverage, suitability, disclosure. |
| `predictions` | Risk calculator, order entry, order receipt | Cần tách prediction market risk khỏi Arena points. |
| `arena` | Points ledger, governance gate, report/resolution | Phải giữ points-only language và fair-play boundary. |
| `earn` | Savings/redeem/risk, staking suitability, emergency actions | Liên quan risk disclosure, lockup, withdrawal policy. |

Expected controller contract:

- Immutable view state.
- Loading, empty, error, offline, submitting, success states.
- Confirmation preview state cho high-risk action.
- Intent methods cho user actions.
- Repository đọc qua same-feature contract, không import mock/remote.
- Focused controller tests cho validation, error mapping và confirm flow.

### G-05: Chưa Có Remote Repositories Và Backend Contracts Thật

Critical providers đang fail-closed khi production không được dùng mock. Đây là
lựa chọn đúng về an toàn, nhưng đồng nghĩa app chưa production-usable cho các
luồng trọng yếu.

Hiện trạng:

- Remote provider wirings: `0`.
- Critical modules vẫn dựa vào mock/fail-closed architecture.
- Chưa có contract test skeleton đủ rõ cho Auth, Wallet, Trade, P2P,
  Predictions, Arena.

Impact:

- Chưa có production data path cho đăng nhập, ví, giao dịch, P2P, prediction
  markets và Arena governance.
- Chưa có DTO mapping thật giữa backend contract và domain entities.
- Chưa có typed network error mapping, timeout/offline handling, auth/session
  injection cho remote repos.

Next step:

- Không wire remote giả chỉ để pass architecture.
- Giữ fail-closed cho production cho đến khi có backend contract thật.
- Thêm contract docs/tests cho critical modules.
- Khi backend contract có thật, mỗi remote repo phải có DTO mapping, typed error
  mapping, timeout/offline handling và focused repository tests trước khi wire.

## Scorecard

| Area | Score | Verdict |
| --- | ---: | --- |
| Top-level Flutter layout | 4.8/5 | Đạt chuẩn tốt, source of truth rõ. |
| Feature module consistency | 4.8/5 | `23/23` modules đủ `domain/data/presentation`. |
| Router organization | 4.5/5 | Route groups và coverage artifact tốt; public router facade vẫn đúng. |
| Shared UI organization | 4.2/5 | Shared primitives rõ; cần giảm local widget duplication trong page lớn. |
| Page/widget layer isolation | 4.6/5 | Page/widget data imports đã về `0`. |
| Presentation/controller isolation | 4.1/5 | Controller dirs đủ và provider exposure đang ở `0`; vẫn cần state boundary sâu hơn. |
| Domain/data separation | 4.0/5 | Boundary khá tốt, nhưng provider/data wiring cần hardening thêm. |
| Design token governance | 4.4/5 | Runtime `Colors.*` và hardcoded color ngoài theme đang ở `0`. |
| File-size governance | 3.7/5 | `239` files trên 600 lines và `4` files trên 1200 lines còn là nợ cần giảm tiếp. |
| Test structure | 4.7/5 | `423` test files, guardrails xanh; full suite gần nhất pass `1,841` tests. |
| Production backend readiness | 2.4/5 | Fail-closed tốt, nhưng chưa có remote repositories/backend contracts. |
| Overall enterprise readiness | 3.9/5 | Architecture-ready, chưa production enterprise-grade hoàn chỉnh. |

## What To Do Next

### P0: Giữ Production Fail-Closed Và Chuẩn Bị Backend Contracts

- Không gắn nhãn production enterprise-grade khi chưa có remote data path thật.
- Không wire remote repository giả.
- Giữ critical providers fail-closed khi `enableMockData == false`.
- Thêm backend contract docs/tests cho Auth, Wallet, Trade, P2P, Predictions và
  Arena.
- Mỗi contract cần xác định endpoint, request/response DTO, auth/session
  requirement, timeout policy, offline behavior và typed error mapping.

### P1: Biến Controller Barrels Thành Controller State Thật

- Giảm presentation-to-data imports từ `27` xuống `0`.
- Page chỉ import controller/domain/shared UI, không import `data/providers`.
- Controller nhận repository qua provider injection nội bộ và expose immutable
  view state.
- Ưu tiên controller thật cho Wallet withdraw/address/token approval, P2P
  payment/risk, Trade confirmation/copy/margin risk, Predictions order/risk,
  Arena points/governance, Earn risk/savings.
- Sau mỗi batch, hạ architecture guardrail baseline thay vì giữ nợ cũ.

### P1: Tách File Lớn Theo Fixtures, Entities, Widgets, Controllers

- Tách mock repository lớn thành `data/fixtures/` và repository class mỏng.
- Tách entity barrel lớn thành subfiles theo aggregate, giữ public barrel để
  không phá imports hiện tại.
- Tách page lớn thành page shell, controller và local widgets.
- Ưu tiên bốn file còn trên `1200` lines: Prediction portfolio/social, Trade
  trader profile, và Profile VIP.
- Mục tiêu batch tiếp theo: giảm files trên `1200` lines từ `4` xuống `0`.

### P1: Chuẩn Hóa Design Tokens

- Giữ `Colors.*` runtime ở `0` bằng cách dùng `AppColors` hoặc semantic tokens.
- Giữ hardcoded colors ngoài `app/theme` ở `0` bằng registry được phê duyệt.
- Dùng `AppAssetColors` cho chain/asset colors, `AppModuleAccents` cho module
  identity, `AppColors` cho semantic UI tokens.
- Chỉ giữ local color khi đó là data visualization đặc thù và có lý do rõ.

### P2: Làm Sạch Router Coupling Dài Hạn

- Giữ public router facade `createAppRouter`, `appRouter`, `AppRoutePaths`,
  `AppRouteNames`.
- Tiếp tục duy trì route group files vì đã tốt hơn single router file.
- Sau khi controller/data boundary ổn định, cân nhắc feature-owned route exports
  để giảm import tập trung trong app router.
- Không đánh đổi route coverage guardrail để giảm coupling.

## Acceptance Criteria Để Gọi Là Production Enterprise-Grade

| Tiêu chí | Target |
| --- | --- |
| Feature module layout | `23/23` modules có `domain/data/presentation` và duy trì bằng guardrail. |
| Page/widget data import | `0` direct imports tới `features/*/data`. |
| Presentation-to-data import | `0` imports/exports từ toàn bộ `presentation/` tới `data/providers` hoặc `data/repositories`. |
| Controller/state boundary | High-risk flows có controller/view-state riêng và focused tests. |
| Mock/remote exposure | Presentation không import/export mock hoặc remote repositories trực tiếp. |
| File-size guardrail | Không page/repository/entity runtime trọng yếu vượt ngưỡng mới đã phê duyệt. |
| Design token governance | Hardcoded colors ngoài registry giảm theo baseline và không tăng trở lại. |
| Remote repositories | Critical modules có remote implementation thật, không fake remote. |
| DTO/error/offline handling | Remote repos có DTO mapping, typed error mapping, timeout/offline behavior. |
| Backend contract tests | Auth, Wallet, Trade, P2P, Predictions, Arena có contract tests hoặc skeleton được backend team xác nhận. |
| Verification | `flutter analyze`, route coverage audit, architecture guardrails và full test suite đều xanh trước release. |

## Final Conclusion

Nếu chỉ xét **cách sắp xếp file/folder và architecture baseline**, VitTrade đã
đạt mức rất tốt cho một Flutter enterprise app: app package rõ, module hóa theo
feature, toàn bộ feature có `domain/data/presentation`, shared UI và theme có
nền, router có route groups, test inventory rộng và guardrails đã kiểm soát các
regression quan trọng.

Nếu xét **production enterprise-grade hoàn chỉnh**, dự án vẫn còn thiếu các
điểm bắt buộc: controller state boundary sâu cho high-risk flows, giảm provider
coupling trong presentation, tách file lớn, chuẩn hóa design token governance,
và quan trọng nhất là remote repositories/backend contracts thật cho critical
modules.

Kết luận cuối: **dự án hiện đã enterprise architecture-ready, nhưng chưa nên gọi
là production enterprise-grade cho đến khi hoàn tất hardening P0/P1 ở trên.**
