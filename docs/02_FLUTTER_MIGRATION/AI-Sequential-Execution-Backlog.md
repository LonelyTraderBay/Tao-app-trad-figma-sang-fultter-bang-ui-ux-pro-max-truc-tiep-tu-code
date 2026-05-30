# AI Sequential Execution Backlog

Updated: 2026-05-27  
Scope: Flutter frontend hardening trong `flutter_app/`, không bao gồm backend
implementation thật.

File này là hàng đợi thực thi tuần tự cho AI. Khi không có chỉ định cụ thể hơn
từ người dùng, AI phải đọc file này, chọn work packet đầu tiên còn `[ ]`, thực
hiện đến khi đạt acceptance, cập nhật trạng thái, rồi mới chuyển sang packet
tiếp theo.

## 1. Quy tắc thực thi bắt buộc

1. Luôn đọc theo thứ tự:
   - `AGENTS.md`
   - `docs/00_START_HERE.md`
   - `docs/02_FLUTTER_MIGRATION/ke-hoac-tong-the.md`
   - file backlog này
   - tài liệu hoặc source được nêu trong packet đang làm
2. Không hỏi người dùng chọn packet nếu họ không chỉ định. Chọn packet đầu tiên
   còn `[ ]` trong thứ tự bên dưới.
3. Trước khi sửa file, chạy `git status --short` và đọc các file liên quan để
   không ghi đè thay đổi đang có.
4. Khi bắt đầu một packet, đổi status của packet đó từ `[ ]` sang `[~]`.
5. Chỉ đổi `[~]` sang `[x]` khi code đã xong, format/test/guardrail liên quan đã
   pass, và phần "Verification log" của packet đã được cập nhật.
6. Nếu packet bị chặn bởi backend contract, CI secret, store signing secret hoặc
   input ngoài repo, đổi status sang `[!]`, ghi blocker cụ thể, rồi chuyển sang
   packet tiếp theo không bị chặn.
7. Mỗi lượt AI ưu tiên hoàn thành một packet nhỏ. Nếu packet rất nhỏ và tất cả
   checks pass, có thể tiếp tục packet kế tiếp trong cùng lượt.
8. Không tạo lại React, Vite, Tailwind, root npm scripts hoặc web screenshot
   tooling cũ.
9. Không nới guardrail để làm test pass. Nếu guardrail đỏ, sửa nguyên nhân hoặc
   tách packet nhỏ hơn.
10. Không gọi production-ready nếu backend remote thật và release signing thật
    chưa được đội phụ trách hoàn tất.

## 2. Ngoài phạm vi của backlog này

Không tự triển khai các phần sau trong queue này:

- Backend API thật.
- Remote repository production thật khi chưa có backend contract được xác nhận.
- CI/store signing secrets.
- Staging/production credentials.
- Thay đổi product policy cho financial flows hoặc Arena/Prediction boundary.

AI vẫn được phép làm phần frontend chuẩn bị cho backend:

- Controller/view-state.
- Fail-closed UI.
- Loading, empty, error, offline, submitting và success states.
- DTO placeholder shape trong contract skeleton nếu chỉ là tài liệu hoặc test
  skeleton đã được đánh dấu rõ là chờ backend.
- Widget/repository tests dùng mock/fail-closed behavior hiện có.

## 3. Baseline hiện tại

Snapshot ngày 2026-05-30:

| Metric | Hiện tại | Mục tiêu queue này |
| --- | ---: | ---: |
| Feature modules đủ `domain/data/presentation` | `23/23` | Giữ `23/23` |
| Page/widget direct data imports | `0` | Giữ `0` |
| Controller mock/remote imports | `0` | Giữ `0` |
| Controller data-provider exposure | `0` | Giữ `0` |
| Non-controller feature data imports | `27` | Không tăng, giảm nếu an toàn |
| `Color(0x...)` ngoài `lib/app/theme/` | `0` | Giữ `0` |
| `Colors.*` trong runtime `lib` | `0` | Giữ `0` |
| Feature files trên 600 dòng | `239` | Giảm dần, không tăng |
| Feature files trên 1200 dòng | `4` | Về `0` trước khi đóng queue |
| Route entries | `417` | Route audit vẫn current |
| Real pages | `414` | Không tái tạo placeholder/skeleton |

Verification baseline gần nhất:

| Ngày | Command | Result |
| --- | --- | --- |
| 2026-05-30 | `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` | Passed, `10` tests |
| 2026-05-27 | `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact` | Passed, `8` tests |
| 2026-05-27 | `dart run tool/route_coverage_audit.dart --check` | Passed |

## 4. Definition of Done cho mọi packet

Một packet chỉ được tick `[x]` khi:

- Code nằm đúng layer: `app/`, `core/`, `features/<feature>/domain`,
  `features/<feature>/data`, `features/<feature>/presentation`, hoặc `shared/`.
- Không phá public router facade: `createAppRouter`, `appRouter`,
  `AppRoutePaths`, `AppRouteNames`.
- Không tăng direct page/widget data imports.
- Không thêm hardcoded color ngoài theme.
- Không thêm `Colors.*` runtime.
- Không tăng số file trên 600 hoặc 1200 dòng, trừ khi packet ghi rõ và có lý do.
- `dart format .` đã chạy nếu sửa Dart.
- Focused tests của module pass.
- Guardrail liên quan pass.
- Nếu chạm router, `dart run tool/route_coverage_audit.dart --check` pass.
- Nếu chạm high-risk copy, `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact` pass.
- Packet ghi lại "Verification log" với command và result.

## 5. Lệnh chuẩn

Chạy từ `flutter_app/`.

Focused verification thường dùng:

```bash
dart format .
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/route_coverage_guardrails_test.dart --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Full verification khi đổi router, shared layout, nhiều module, hoặc trước khi
đóng một stage lớn:

```bash
dart format .
flutter analyze
flutter test --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

## 6. Thứ tự thực hiện tổng thể

| Stage | Status | Mục tiêu | Hoàn tất khi |
| --- | --- | --- | --- |
| S0 | `[x]` | Khóa baseline và chuẩn hóa cách cập nhật backlog | Guardrails xanh, file backlog có log mới |
| S1 | `[x]` | Thêm guardrail để AI không tạo nợ mới | Guardrails mới pass |
| S2 | `[!]` | Wallet high-risk và file-size hardening | Wallet file lớn giảm, tests pass; Address Add emulator input blocker logged |
| S3 | `[x]` | P2P high-risk và payment/dispute hardening | P2P flow có controller/view-state rõ hơn |
| S4 | `[x]` | Trade high-risk và copy/risk hardening | Trade file lớn giảm, copy/risk tests pass |
| S5 | `[x]` | Prediction/Arena boundary hardening | Boundary copy và route edges rõ |
| S6 | `[x]` | Earn/Markets/Launchpad large-page cleanup | File trên 1200 dòng giảm tiếp |
| S7 | `[ ]` | Manual smoke và visual QA evidence | Checklist có full run log |
| S8 | `[ ]` | Docs closeout và readiness report | Kế hoạch, audit, QA report đồng bộ |

## 7. Stage S0 - Baseline và backlog hygiene

### S0-01 - Confirm baseline commands

Status: `[x]`

Goal:
- Xác nhận baseline hiện tại trước khi refactor tiếp.

Scope:
- Không sửa Dart source trừ khi command chỉ ra lỗi phải sửa.
- Có thể cập nhật file backlog này và `ke-hoac-tong-the.md` nếu metric thay đổi.

Implementation:
- Chạy `git status --short`.
- Chạy architecture guardrail.
- Chạy route coverage audit.
- Ghi lại result dưới packet này.

Tests:

```bash
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Acceptance:
- Hai command pass.
- Nếu metric thay đổi, cập nhật bảng baseline trong file này.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry.
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`8` tests).
- 2026-05-27: `dart run tool/route_coverage_audit.dart --check` passed
  (`Route coverage artifact is current.`).

### S0-02 - Normalize backlog update workflow

Status: `[x]`

Goal:
- Đảm bảo AI các lượt sau biết cách cập nhật status mà không bỏ sót.

Scope:
- `docs/02_FLUTTER_MIGRATION/AI-Sequential-Execution-Backlog.md`
- `docs/02_FLUTTER_MIGRATION/ke-hoac-tong-the.md` nếu cần thêm link.

Implementation:
- Thêm link từ kế hoạch tổng thể sang file backlog này nếu chưa có.
- Kiểm tra file UTF-8 có tiếng Việt đúng.
- Không sửa source app.

Tests:
- Không cần Flutter test nếu chỉ sửa docs.
- Kiểm tra UTF-8 bằng cách đọc file với UTF-8 strict.

Acceptance:
- `ke-hoac-tong-the.md` trỏ tới backlog này.
- Backlog có quy tắc status `[ ]`, `[~]`, `[x]`, `[!]`.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry.
- 2026-05-27: Verified `docs/02_FLUTTER_MIGRATION/ke-hoac-tong-the.md`
  already links to `docs/02_FLUTTER_MIGRATION/AI-Sequential-Execution-Backlog.md`.
- 2026-05-27: Verified backlog status workflow rules include `[ ]`, `[~]`,
  `[x]`, and `[!]`.
- 2026-05-27: UTF-8 strict read passed for `ke-hoac-tong-the.md` and
  `AI-Sequential-Execution-Backlog.md`.

## 8. Stage S1 - Guardrails chống tái tạo nợ mới

### S1-01 - Guardrail không tăng page part-file debt

Status: `[x]`

Goal:
- Ngăn việc tiếp tục tạo thêm `*_part_*.dart` trong `presentation/pages/` nếu
  không có lý do rõ.

Scope:
- `flutter_app/test/quality/architecture_baseline_guardrails_test.dart`
- Không sửa feature source trong packet này.

Implementation:
- Đo số file `*_part_*.dart` hiện có dưới `lib/features/*/presentation/pages/`.
- Thêm test guardrail `lessThanOrEqualTo(<current count>)`.
- Reason phải nói rõ: refactor dài hạn nên chuyển widget sang
  `presentation/widgets/`, không thêm page part debt.

Tests:

```bash
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- Guardrail pass với baseline hiện tại.
- Không làm fail các test hiện có.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry and
  `flutter_app/test/quality/architecture_baseline_guardrails_test.dart`.
- 2026-05-27: Measured `218` `*_part_*.dart` files under
  `lib/features/*/presentation/pages/`.
- 2026-05-27: `dart format .` initially failed on stale generated
  `flutter_app/build/` desugar artifacts; removed generated `build/`, then
  `dart format .` passed (`1450` files, `0` changed).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`9` tests).

### S1-02 - Guardrail yêu cầu high-volume feature dùng widgets folder

Status: `[x]`

Goal:
- Buộc các feature lớn bắt đầu dùng `presentation/widgets/` thay vì để toàn bộ
  UI nằm trong pages/part files.

Scope:
- `flutter_app/test/quality/architecture_baseline_guardrails_test.dart`
- Feature source chỉ sửa nếu cần tạo widget extraction nhỏ để làm guardrail pass.

Implementation:
- Chọn staged rollout, không bật một lúc cho tất cả feature.
- Bắt đầu với `wallet`, vì packet S2 sẽ tạo widget thật.
- Thêm guardrail sau khi S2-01 hoặc S2-02 đã tạo widget.

Tests:

```bash
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
flutter test test/features/wallet --reporter=compact
```

Acceptance:
- Wallet có ít nhất một file widget thật dưới
  `lib/features/wallet/presentation/widgets/`.
- Guardrail pass.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry,
  `flutter_app/test/quality/architecture_baseline_guardrails_test.dart`,
  `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart`, and
  `flutter_app/lib/features/wallet/presentation/widgets/wallet_unavailable_banner.dart`.
- 2026-05-27: Confirmed wallet had no existing `presentation/widgets/` Dart
  files, then extracted the fail-closed unavailable banner from `wallet_page.dart`
  into `wallet_unavailable_banner.dart`.
- 2026-05-27: Wallet widget file count is now `1`.
- 2026-05-27: `dart format .` passed (`1451` files, `1` changed).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-27: `flutter test test/features/wallet --reporter=compact` passed
  (`66` tests).

### S1-03 - Guardrail high-risk confirmation copy

Status: `[x]`

Goal:
- Giữ preview/confirm, fee/risk/limit/next-step copy cho các flow rủi ro cao.

Scope:
- `flutter_app/test/quality/product_copy_guardrails_test.dart`
- Các pages liên quan nếu guardrail phát hiện thiếu copy.

Implementation:
- Bổ sung static checks cho các file:
  - `wallet/presentation/pages/withdraw_page.dart`
  - `wallet/presentation/pages/address_add_page.dart`
  - `wallet/presentation/pages/wallet_token_approval_page.dart`
  - `p2p/presentation/pages/p2p_payment_method_add_page.dart`
  - `p2p/presentation/pages/p2p_create_ad_page.dart`
- Check không cần quá cứng theo exact text; ưu tiên tìm các cụm role như
  risk, fee, limit, confirm, preview hoặc tiếng Việt tương ứng.

Tests:

```bash
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:
- Guardrail pass.
- Không ép copy sai ngữ cảnh Arena/Prediction.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry and
  `flutter_app/test/quality/product_copy_guardrails_test.dart`.
- 2026-05-27: Added static role checks for withdraw, address add, token
  approval revoke, P2P payment method add, and P2P create ad. Checks verify
  preview/confirm plus context-specific fee, limit, risk, destination, spender,
  owner, security, and payment roles without forcing exact UI copy.
- 2026-05-27: `dart format .` passed (`1451` files, `1` changed).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`7` tests).
- 2026-05-27: Stage S1 verification rerun:
  `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

## 9. Stage S2 - Wallet hardening

### S2-01 - Split `wallet_page.dart`

Status: `[x]`

Goal:
- Giảm `wallet_page.dart` từ khoảng `1293` dòng xuống dưới `600` nếu khả thi,
  hoặc tối thiểu giảm rõ rệt mà không tăng số file trên 1200 dòng.

Scope:
- `flutter_app/lib/features/wallet/presentation/pages/wallet_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/`
- `flutter_app/lib/features/wallet/presentation/controllers/wallet_controller.dart`
- `flutter_app/test/features/wallet/wallet_page_test.dart`

Implementation:
- Giữ public page class và route import hiện tại.
- Chuyển các section/card/list UI lặp lại sang widgets riêng.
- Chuyển derived display state đơn giản sang controller nếu hiện còn trong page.
- Không đổi repository/provider wiring.

Tests:

```bash
flutter test test/features/wallet/wallet_page_test.dart --reporter=compact
flutter test test/features/wallet/wallet_controller_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- `wallet_page.dart` giảm dòng.
- Không có page/widget direct data imports.
- Wallet tests pass.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry,
  `wallet_page.dart`, wallet presentation widgets, and wallet-focused tests
  already in scope.
- 2026-05-27: Read `wallet_page.dart`, `wallet_controller.dart`, and
  `wallet_page_test.dart` before refactor.
- 2026-05-27: Extracted wallet page section/list/card/painter UI from
  `wallet_page.dart` into
  `lib/features/wallet/presentation/widgets/wallet_page_sections.dart`, keeping
  public `WalletPage` and existing route/test keys.
- 2026-05-27: Line metrics: `wallet_page.dart` reduced from `1256` to `146`
  lines; new `wallet_page_sections.dart` is `1117` lines; feature files
  `>600` stayed `250`; feature files `>1200` decreased to `23`.
- 2026-05-27: `dart format .` passed (`1452` files, `2` changed).
- 2026-05-27: `flutter test test/features/wallet/wallet_page_test.dart --reporter=compact`
  passed (`5` tests).
- 2026-05-27: `flutter test test/features/wallet/wallet_controller_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S2-02 - Split `wallet_multi_manager_page.dart`

Status: `[x]`

Goal:
- Tách UI quản lý nhiều ví thành widgets/controller state dễ test.

Scope:
- `flutter_app/lib/features/wallet/presentation/pages/wallet_multi_manager_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/`
- `flutter_app/test/features/wallet/` test liên quan.

Implementation:
- Tách asset/account rows, warning panels, filter controls, summary cards.
- Giữ route behavior.
- Không thêm backend dependency.

Tests:

```bash
flutter test test/features/wallet --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- File giảm dưới 1200 dòng.
- Tests pass.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry,
  `wallet_multi_manager_page.dart`, and wallet presentation widgets.
- 2026-05-27: Read `wallet_multi_manager_page.dart` and
  `wallet_multi_manager_page_test.dart` before refactor.
- 2026-05-27: Extracted multi-wallet tabs, summary, distribution, wallet rows,
  group rows, activity rows, controls, and painter UI into
  `lib/features/wallet/presentation/widgets/wallet_multi_manager_sections.dart`,
  keeping clipboard/state/navigation in the page.
- 2026-05-27: Initial `flutter test test/features/wallet --reporter=compact`
  failed because `_managerBackground` was not copied into the extracted widget
  file; added the missing token and reran.
- 2026-05-27: Line metrics: `wallet_multi_manager_page.dart` reduced from
  `1267` to `118` lines; new `wallet_multi_manager_sections.dart` is `1163`
  lines; feature files `>600` stayed `250`; feature files `>1200` decreased to
  `22`.
- 2026-05-27: `dart format .` passed after fix (`1453` files, `0` changed on
  final run).
- 2026-05-27: `flutter test test/features/wallet --reporter=compact` passed
  (`66` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S2-03 - Harden token approval revoke flow

Status: `[x]`

Goal:
- Đảm bảo revoke token approval có preview/confirm state rõ, copy rủi ro rõ và
  controller không phụ thuộc mock/remote repo trực tiếp.

Scope:
- `flutter_app/lib/features/wallet/presentation/pages/wallet_token_approval_page.dart`
- `flutter_app/lib/features/wallet/presentation/controllers/wallet_controller.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/`
- `flutter_app/test/features/wallet/wallet_token_approval_page_test.dart`

Implementation:
- Tách revoke sheet/card thành widget.
- Kiểm tra copy hiển thị spender, token, allowance, gas/impact, cancel/confirm.
- Nếu state submit đang nằm trong page, chuyển sang controller/view model.

Tests:

```bash
flutter test test/features/wallet/wallet_token_approval_page_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- High-risk copy rõ.
- File giảm dưới 1200 dòng nếu đang vượt.
- Guardrails pass.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry,
  `wallet_token_approval_page.dart`, wallet presentation widgets, and
  `product_copy_guardrails_test.dart`.
- 2026-05-27: Read `wallet_token_approval_page.dart`,
  `wallet_controller.dart`, and `wallet_token_approval_page_test.dart` before
  refactor.
- 2026-05-27: Extracted revoke confirmation bottom sheet UI into
  `lib/features/wallet/presentation/widgets/wallet_token_revoke_sheet.dart`;
  controller-owned revoke preview copy remains in `wallet_controller.dart`.
- 2026-05-27: `wallet_token_approval_page.dart` reduced from `1249` to `1161`
  lines; new `wallet_token_revoke_sheet.dart` has `104` lines. Feature large
  file metric after packet: `>600 = 250`, `>1200 = 21`.
- 2026-05-27: `dart format .` passed (`1454` files, `0` changed before the
  guardrail update; after updating the guardrail source aggregation it passed
  again with `1454` files, `1` changed).
- 2026-05-27: `flutter test test/features/wallet/wallet_token_approval_page_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  initially failed because the guardrail only read the old page file after
  sheet extraction; updated it to aggregate the page, revoke sheet, and
  controller sources for this flow, then it passed (`7` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S2-04 - Harden address add flow

Status: `[x]`

Goal:
- Address add có validation, risk copy, preview/confirm state và tests rõ hơn.

Scope:
- `flutter_app/lib/features/wallet/presentation/pages/address_add_page.dart`
- `flutter_app/lib/features/wallet/presentation/controllers/wallet_controller.dart`
- `flutter_app/test/features/wallet/address_add_page_test.dart`

Implementation:
- Tách form sections và confirmation summary.
- Đảm bảo sensitive destination được mask ở preview nếu phù hợp.
- Không đổi backend path.

Tests:

```bash
flutter test test/features/wallet/address_add_page_test.dart --reporter=compact
flutter test test/features/wallet/wallet_controller_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:
- Address add test cover validation + preview + confirm.
- Product copy guardrail pass.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry,
  `address_add_page.dart`, wallet presentation widgets, and
  `product_copy_guardrails_test.dart`.
- 2026-05-27: Read `address_add_page.dart`, `wallet_controller.dart`, and
  `address_add_page_test.dart` before refactor.
- 2026-05-27: Extracted address add form sections, inline preview panel,
  confirmation sheet, footer, and success state into
  `lib/features/wallet/presentation/widgets/wallet_address_add_sections.dart`.
  Test keys remain stable via the same literal key values.
- 2026-05-27: Updated high-risk copy guardrail to aggregate
  `address_add_page.dart`, `wallet_address_add_sections.dart`, and
  `wallet_controller.dart` for the Address Add flow after extraction.
- 2026-05-27: `address_add_page.dart` reduced from `1225` to `207` lines; new
  `wallet_address_add_sections.dart` has `1045` lines. Feature large file
  metric after packet: `>600 = 250`, `>1200 = 20`.
- 2026-05-27: `dart format .` passed (`1455` files, `2` changed; rerun after
  import fix passed with `1455` files, `0` changed).
- 2026-05-27: `flutter test test/features/wallet/address_add_page_test.dart --reporter=compact`
  initially failed compile because the extracted success state needed shared
  layout imports; added `VitHeader`/`VitPageLayout` imports, then it passed
  (`3` tests).
- 2026-05-27: `flutter test test/features/wallet/wallet_controller_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`7` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S2-05 - Wallet transfer and buy crypto split pass

Status: `[x]`

Goal:
- Giảm large-page debt trong `transfer_page.dart` và `buy_crypto_page.dart`.

Scope:
- `flutter_app/lib/features/wallet/presentation/pages/transfer_page.dart`
- `flutter_app/lib/features/wallet/presentation/pages/buy_crypto_page.dart`
- `flutter_app/lib/features/wallet/presentation/widgets/`
- Wallet tests liên quan.

Implementation:
- Tách repeated panels/rows/forms.
- Giữ financial safety copy.
- Không thay đổi route paths.

Tests:

```bash
flutter test test/features/wallet --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- Không còn Wallet file trên 1200 dòng nếu khả thi.
- Wallet focused suite pass.

Verification log:
- 2026-05-27: `git status --short` showed a dirty working tree with existing
  modified/untracked files; packet edits were limited to this backlog entry,
  `transfer_page.dart`, `buy_crypto_page.dart`, and wallet presentation
  widgets.
- 2026-05-27: Read `transfer_page.dart`, `buy_crypto_page.dart`,
  `transfer_page_test.dart`, and `buy_crypto_page_test.dart` before refactor.
- 2026-05-27: Extracted Transfer wallet cards, asset/amount panels, notices,
  recent-transfer rows, picker rows, success banner, confirm sheet, and format
  helpers into `lib/features/wallet/presentation/widgets/wallet_transfer_sections.dart`.
- 2026-05-27: Extracted Buy Crypto input form, amount/payment/rate panels,
  confirmation content, success state, crypto picker row, and format helpers
  into `lib/features/wallet/presentation/widgets/wallet_buy_crypto_sections.dart`.
  Existing test keys remain stable via the same literal key values.
- 2026-05-27: `transfer_page.dart` reduced from `1214` to `318` lines;
  `wallet_transfer_sections.dart` has `937` lines. `buy_crypto_page.dart`
  reduced from `1202` to `190` lines; `wallet_buy_crypto_sections.dart` has
  `1023` lines. No Wallet Dart file remains above `1200` lines; feature large
  file metric after packet: `>600 = 250`, `>1200 = 18`.
- 2026-05-27: `dart format .` passed (`1457` files, `4` changed).
- 2026-05-27: `flutter test test/features/wallet --reporter=compact` passed
  (`66` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`7` tests).

### S2-06 - Wallet smoke evidence

Status: `[!]`

Goal:
- Cập nhật manual smoke evidence cho Wallet, Withdraw, Address Add,
  Token Approval Revoke bằng mock-data dev smoke.

Scope:
- `docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md`
- `flutter_app/run-artifacts/` chỉ dùng cho artifact generated, không commit nếu
  repo hygiene yêu cầu không commit artifacts.

Implementation:
- Build debug APK nếu emulator/device sẵn có.
- Chạy flow theo checklist.
- Ghi run log: build, device, result, notes.
- Nếu không có emulator/device, ghi blocker rõ trong packet này, không fake evidence.

Tests:

```bash
flutter build apk --debug
```

Acceptance:
- Checklist có log thật hoặc blocker rõ.
- Không commit `run-artifacts/` nếu policy repo không cho phép.

Blocker:
- Owner: QA automation / Android emulator input owner.
- Reason: Address Add full preview/confirm smoke could not be completed via
  adb. The focused Flutter `EditText` accepted focus in
  `address-add-direct-label-ui.xml`, but `adb shell input text coldwallet` and
  keyevent attempts left the label counter at `0/30` and did not populate the
  form fields.
- Unblock condition: provide a reliable emulator text-entry method or semantic
  automation hook for Flutter text fields, or complete manual interactive
  Address Add smoke and attach evidence under `flutter_app/run-artifacts/`.

Verification log:
- 2026-05-27: `git status --short` showed an already dirty worktree; packet
  edits were limited to Wallet token revoke preview details, focused tests, this
  backlog entry, and the manual smoke checklist. Generated smoke artifacts were
  written only under `flutter_app/run-artifacts/wallet-smoke-20260527T112318/`.
- 2026-05-27: `flutter build apk --debug` passed and produced
  `build\app\outputs\flutter-apk\app-debug.apk`; after the Token Approval
  detail fix, the same build command was rerun and passed again.
- 2026-05-27: `adb -s emulator-5554 install -r build\app\outputs\flutter-apk\app-debug.apk`
  passed (`Success`) on Android 17 API 37 emulator.
- 2026-05-27: Wallet smoke captured Home `SC-007`, Wallet overview `SC-135`,
  Withdraw preview with amount/network/fee/masked destination/risk confirmation,
  Address Book `SC-144`, Address Add initial `SC-143`, and Token Approval
  `SC-150` with revoke sheet details. Crash log buffer was empty.
- 2026-05-27: Updated `TokenApprovalController.revokePreview` so the revoke
  sheet exposes spender, token, allowance, gas estimate, and impact details; the
  emulator capture `token-approval-fixed-revoke-sheet-ui.xml` confirms those
  fields plus Cancel and Confirm.
- 2026-05-27: `dart format .` initially failed on generated Gradle build output
  under `flutter_app/build/`; `flutter clean` removed generated artifacts,
  `flutter pub get` restored dependencies, and `dart format .` then passed
  (`1457` files, `0` changed).
- 2026-05-27: `flutter test test/features/wallet/wallet_token_approval_page_test.dart --reporter=compact`
  initially failed after expanding the sheet body because the old dismiss tap
  coordinate hit the taller sheet; the test was updated to dismiss via the
  scrim and rerun passed (`3` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`7` tests).

## 10. Stage S3 - P2P hardening

### S3-01 - Harden `p2p_create_ad_page.dart`

Status: `[x]`

Goal:
- Create ad flow có view-state, preview/confirm, fee/limit/risk copy và file nhỏ
  hơn.

Scope:
- `flutter_app/lib/features/p2p/presentation/pages/p2p_create_ad_page.dart`
- `flutter_app/lib/features/p2p/presentation/controllers/p2p_controller.dart`
- `flutter_app/lib/features/p2p/presentation/widgets/`
- `flutter_app/test/features/p2p/p2p_create_ad_page_test.dart`

Implementation:
- Tách form sections, price/limit controls, payment method summary, review panel.
- Chuyển derived validation/preview state sang controller.
- Không đổi P2P repository/provider.

Tests:

```bash
flutter test test/features/p2p/p2p_create_ad_page_test.dart --reporter=compact
flutter test test/features/p2p/p2p_controller_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- Page giảm dưới 1200 dòng.
- Tests pass.

Verification log:
- 2026-05-27: `git status --short` showed an already dirty worktree with
  existing modified/untracked files; packet edits were limited to
  `p2p_create_ad_page.dart`, `p2p_controller.dart`,
  `p2p_create_ad_sections.dart`, focused P2P/controller tests, product-copy
  guardrail aggregation, and this backlog entry.
- 2026-05-27: Added `P2PCreateAdController`, `P2PCreateAdDraft`, and
  `P2PCreateAdPreview` so effective price, publish validity, payment summary,
  fee review, limit summary, escrow note, and risk copy are derived outside the
  page. P2P repository/provider files were not changed.
- 2026-05-27: Extracted create-ad UI sections to
  `flutter_app/lib/features/p2p/presentation/widgets/p2p_create_ad_sections.dart`;
  `p2p_create_ad_page.dart` reduced from `1234` to `724` lines, extracted
  widget file is `596` lines, `p2p_controller.dart` is `495` lines. Feature
  large-file metric after packet: `>600 = 250`, `>1200 = 17`.
- 2026-05-27: `dart format .` passed (`1458` files, `2` changed on final run).
- 2026-05-27: First rerun of
  `flutter test test/features/p2p/p2p_create_ad_page_test.dart --reporter=compact`
  failed because the new widget file initially carried mojibake text; labels
  were corrected to Unicode and the final rerun passed (`4` tests).
- 2026-05-27: `flutter test test/features/p2p/p2p_controller_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`7` tests).
- 2026-05-27: First rerun of
  `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  failed because the extracted widget file was `611` lines and increased
  `>600` debt to `251`; the widget file was reduced below the threshold, and
  the final rerun passed (`10` tests).

### S3-02 - Harden P2P payment method add

Status: `[x]`

Goal:
- Payment method add flow preview account data, ownership risk, limits và
  confirmation rõ.

Scope:
- `flutter_app/lib/features/p2p/presentation/pages/p2p_payment_method_add_page.dart`
- `flutter_app/lib/features/p2p/presentation/controllers/p2p_controller.dart`
- `flutter_app/test/features/p2p/p2p_payment_method_add_page_test.dart`

Implementation:
- Tách form, ownership warning, review summary.
- Mask sensitive account data where applicable.
- Thêm/siết tests cho validation và confirmation.

Tests:

```bash
flutter test test/features/p2p/p2p_payment_method_add_page_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:
- Flow có preview/confirm rõ.
- No direct page data import.

Verification log:
- 2026-05-27: `git status --short` showed an already dirty worktree with
  existing modified/untracked files; packet edits were limited to
  `p2p_payment_method_add_page.dart`, `p2p_controller.dart`, focused P2P tests,
  and this backlog entry.
- 2026-05-27: Added masked-account, ownership-risk, and limit-review fields to
  `P2PPaymentMethodPreview`; preview and confirm surfaces now use
  `maskedAccount` (`007...3456` in tests) instead of repeating the raw account
  outside the input field.
- 2026-05-27: Payment Method Add page remains below the large-file threshold:
  `p2p_payment_method_add_page.dart` is `694` lines and `p2p_controller.dart`
  is `514` lines. Feature large-file metric after packet: `>600 = 250`,
  `>1200 = 17`.
- 2026-05-27: `dart format .` passed (`1458` files, `1` changed).
- 2026-05-27: `flutter test test/features/p2p/p2p_payment_method_add_page_test.dart --reporter=compact`
  passed (`5` tests).
- 2026-05-27: `flutter test test/features/p2p/p2p_controller_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`7` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests), covering the no direct page data import acceptance.

### S3-03 - Harden P2P dispute/evidence flows

Status: `[x]`

Goal:
- Dispute detail và evidence flow có state rõ, back/navigation edge ổn định.

Scope:
- `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_detail_page.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_evidence_page.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_dispute_resolution_page.dart`
- `flutter_app/lib/features/p2p/presentation/controllers/p2p_controller.dart`
- P2P dispute tests.

Implementation:
- Tách timeline, evidence list, upload placeholder UI, resolution summary.
- Không thêm real upload/backend behavior.
- Copy phải nói rõ trạng thái mock/fail-closed nếu action chưa có backend.

Tests:

```bash
flutter test test/features/p2p/p2p_dispute_detail_page_test.dart --reporter=compact
flutter test test/features/p2p/p2p_dispute_evidence_page_test.dart --reporter=compact
flutter test test/features/p2p/p2p_dispute_resolution_page_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- No backend dependency.
- Dispute tests pass.

Verification log:
- 2026-05-27: `git status --short` showed an already dirty worktree with
  existing modified/untracked files; packet edits were limited to P2P
  dispute/evidence/resolution pages, their focused tests, and this backlog
  entry.
- 2026-05-27: Added explicit mock/fail-closed copy to dispute evidence upload,
  dispute detail evidence management, and dispute resolution appeal state. No
  real upload, appeal, or backend behavior was added; existing local UI state
  remains local.
- 2026-05-27: File-size metrics after packet:
  `p2p_dispute_detail_page.dart = 1143` lines,
  `p2p_dispute_evidence_page.dart = 298` lines,
  `p2p_dispute_resolution_page.dart = 324` lines, and
  `p2p_controller.dart = 514` lines. Feature large-file metric stayed
  `>600 = 250`, `>1200 = 17`.
- 2026-05-27: `dart format .` passed (`1458` files, `2` changed).
- 2026-05-27: `flutter test test/features/p2p/p2p_dispute_detail_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-27: `flutter test test/features/p2p/p2p_dispute_evidence_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-27: `flutter test test/features/p2p/p2p_dispute_resolution_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S3-04 - Harden P2P order and escrow surfaces

Status: `[x]`

Goal:
- Order, escrow balance/detail, wallet surfaces giữ đúng financial safety copy.

Scope:
- `flutter_app/lib/features/p2p/presentation/pages/p2p_order_page.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_escrow_balance_page.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_escrow_detail_page.dart`
- `flutter_app/lib/features/p2p/presentation/pages/p2p_wallet_page.dart`
- Tests liên quan.

Implementation:
- Tách repeated widgets.
- Kiểm tra copy escrow/payment không dùng Arena Points wording.
- Giữ route behavior.

Tests:

```bash
flutter test test/features/p2p --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- P2P focused suite pass.
- No product boundary regression.

Verification log:
- 2026-05-27: `git status --short` showed a large dirty working tree with
  existing modified/untracked files; packet edits were limited to this backlog
  entry, S3-04 P2P order/escrow/wallet pages, `p2p_notice_widgets.dart`, and
  `product_copy_guardrails_test.dart`.
- 2026-05-27: Read `p2p_order_page.dart`, order part files,
  `p2p_escrow_balance_page.dart`, `p2p_escrow_detail_page.dart`,
  `p2p_wallet_page.dart`, and related P2P widget tests before editing.
- 2026-05-27: Added reusable P2P notice/bullet widgets in
  `lib/features/p2p/presentation/widgets/p2p_notice_widgets.dart`; reused them
  for payment warning, escrow info/help, escrow security notice, and P2P wallet
  info copy. No Arena Points wording was added.
- 2026-05-27: Line metrics after extraction: `p2p_escrow_balance_page.dart`
  `702 -> 641`, `p2p_escrow_detail_page.dart` `854 -> 829`,
  `p2p_wallet_page.dart` `1007 -> 991`, `p2p_order_page_part_02.dart`
  `511 -> 500`; new `p2p_notice_widgets.dart` is `118` lines.
- 2026-05-27: `dart format .` passed (`1459` files, `4` changed).
- 2026-05-27: `flutter test test/features/p2p --reporter=compact` passed
  (`311` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`8` tests), including the new P2P order/escrow/wallet boundary check.
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S3-05 - Clean P2P placeholder wording

Status: `[x]`

Goal:
- Test names/copy không còn gây hiểu nhầm route thật là placeholder.

Scope:
- `flutter_app/test/features/p2p/`
- `flutter_app/lib/features/p2p/`
- Không đổi route behavior nếu không cần.

Implementation:
- Đổi mô tả test từ "placeholder" sang "canonical fallback route", "parent
  route", hoặc "safe route edge" khi route thực tế đã là real page.
- Không đổi assertion nếu route vẫn đúng.

Tests:

```bash
flutter test test/features/p2p --reporter=compact
flutter test test/quality/route_coverage_guardrails_test.dart --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Acceptance:
- Tests pass.
- Route audit vẫn current.

Verification log:
- 2026-05-27: `git status --short` showed a large dirty working tree with
  existing modified/untracked files; packet edits were limited to this backlog
  entry and P2P test description wording.
- 2026-05-27: `rg -n "placeholder" flutter_app/test/features/p2p flutter_app/lib/features/p2p`
  showed route/test wording debt in P2P tests plus source input placeholder
  fields. Source `placeholder` fields were left unchanged because they describe
  text-field hints, not route behavior.
- 2026-05-27: Renamed P2P test descriptions from placeholder wording to
  canonical route, parent route, route edge, or confirmed route wording without
  changing assertions or route behavior.
- 2026-05-27: `dart format .` passed (`1459` files, `5` changed).
- 2026-05-27: `rg -n "placeholder" flutter_app/test/features/p2p` returned no
  matches.
- 2026-05-27: `flutter test test/features/p2p --reporter=compact` passed
  (`311` tests).
- 2026-05-27: `flutter test test/quality/route_coverage_guardrails_test.dart --reporter=compact`
  passed (`1` test).
- 2026-05-27: `dart run tool/route_coverage_audit.dart --check` passed
  (`Route coverage artifact is current.`).

## 11. Stage S4 - Trade hardening

### S4-01 - Split `copy_trading_card_demo.dart`

Status: `[x]`

Goal:
- Giảm large-page debt và đưa repeated copy-trading UI sang widgets.

Scope:
- `flutter_app/lib/features/trade/presentation/pages/copy_trading_card_demo.dart`
- `flutter_app/lib/features/trade/presentation/widgets/`
- `flutter_app/test/features/trade/copy_trading_card_demo_test.dart`

Implementation:
- Tách provider card, metric chips, risk panels, action rows.
- Không đổi route path hoặc test intent.

Tests:

```bash
flutter test test/features/trade/copy_trading_card_demo_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- File giảm dưới 1200 dòng.
- Trade copy card test pass.

Verification log:
- 2026-05-27: `git status --short` for S4-01 scope showed
  `copy_trading_card_demo.dart` already modified and the backlog file
  untracked/dirty; edits were limited to the copy-card page and new Trade
  presentation widget files.
- 2026-05-27: Read `copy_trading_card_demo.dart` and
  `copy_trading_card_demo_test.dart` before refactor.
- 2026-05-27: Extracted provider-card variants, metric rows, trend/action
  primitives, badge, and variant notes into
  `lib/features/trade/presentation/widgets/copy_trading_card_demo_widgets.dart`
  and `copy_trading_card_demo_primitives.dart`; preserved public
  `CopyTradingCardDemo.cardKey` and route/test behavior.
- 2026-05-27: Line metrics: `copy_trading_card_demo.dart` `1257 -> 676`;
  new `copy_trading_card_demo_widgets.dart` `473` lines and
  `copy_trading_card_demo_primitives.dart` `168` lines, so no new file over
  `600` lines.
- 2026-05-27: `dart format .` passed (`1461` files, `1` changed).
- 2026-05-27: `flutter test test/features/trade/copy_trading_card_demo_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S4-02 - Harden copy trading high-risk flow

Status: `[x]`

Goal:
- Copy trading configuration/confirmation có risk, suitability, amount, limit và
  confirmation state rõ.

Scope:
- `flutter_app/lib/features/trade/presentation/pages/copy_trading_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/copy_trading_v2_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/copy_confirmation_page.dart`
- `flutter_app/lib/features/trade/presentation/controllers/trade_controller.dart`
- Trade copy tests.

Implementation:
- Tách preview/confirmation state nếu còn nằm trong page.
- Đảm bảo không dùng casino/hype copy.
- Giữ route edges SC tests.

Tests:

```bash
flutter test test/features/trade/copy_trading_page_test.dart --reporter=compact
flutter test test/features/trade/copy_trading_v2_page_test.dart --reporter=compact
flutter test test/features/trade/copy_confirmation_page_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:
- High-risk confirmation rõ.
- Tests pass.

Verification log:
- 2026-05-27: `git status --short` for S4-02 scope showed existing dirty
  Trade copy pages plus untracked Trade controller files; packet edits were
  limited to this backlog entry, `copy_confirmation_page.dart`,
  `copy_confirmation_page_test.dart`, and `product_copy_guardrails_test.dart`.
- 2026-05-27: Read `copy_trading_page.dart`, `copy_trading_v2_page.dart`,
  `copy_confirmation_page.dart`, Trade controller models, and the three copy
  tests before editing.
- 2026-05-27: Added a confirmation `Suitability & limits review` section with
  explicit risk suitability, copy amount at risk, provider portfolio limit, and
  risk-tolerance/cooling-off copy. Added test coverage through
  `CopyConfirmationPage.suitabilityKey`.
- 2026-05-27: Added product copy guardrail for Trade copy high-risk roles:
  risk, suitability, amount, limit, fee, and confirmation; also rejects
  casino/hype copy such as `risk-free` or `guaranteed profit`.
- 2026-05-27: Initial `copy_confirmation_page_test.dart` rerun failed due a
  `RenderFlex` overflow in `_SummaryRow`; fixed value text with `Flexible`,
  right alignment, and wrapping.
- 2026-05-27: `dart format .` passed (`1461` files, final rerun `1` changed).
- 2026-05-27: `flutter test test/features/trade/copy_trading_page_test.dart --reporter=compact`
  passed (`5` tests).
- 2026-05-27: `flutter test test/features/trade/copy_trading_v2_page_test.dart --reporter=compact`
  passed (`6` tests).
- 2026-05-27: `flutter test test/features/trade/copy_confirmation_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`9` tests).

### S4-03 - Harden futures and margin flows

Status: `[x]`

Goal:
- Futures/margin screens có risk/limit/liquidation copy rõ và file-size giảm.

Scope:
- `flutter_app/lib/features/trade/presentation/pages/futures_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/margin_trading_page.dart`
- `flutter_app/lib/features/trade/presentation/pages/margin_trading_hub_page.dart`
- Tests liên quan.

Implementation:
- Tách order form, leverage/risk panels, position summary.
- Không thêm real order submission.

Tests:

```bash
flutter test test/features/trade/futures_page_test.dart --reporter=compact
flutter test test/features/trade/margin_trading_page_test.dart --reporter=compact
flutter test test/features/trade/margin_trading_hub_page_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:
- Tests pass.
- No unsafe copy.

Verification log:
- 2026-05-27: `git status --short` for S4-03 scope showed existing dirty
  `futures_page.dart`, `margin_trading_page.dart`, `margin_trading_hub_page.dart`,
  plus untracked backlog/product guardrail files from current work; no unrelated
  changes were reverted.
- 2026-05-27: Extracted hub phase badge/compliance banner to
  `presentation/widgets/margin_trading_hub_widgets.dart`; added futures and
  margin review copy covering leverage limit, liquidation, margin, fee preview,
  and risk roles.
- 2026-05-27: Metrics: `margin_trading_hub_page.dart` reduced `624 -> 550`
  lines; new `margin_trading_hub_widgets.dart` is `83` lines.
- 2026-05-27: `dart format .` passed (`1462` files, `4` changed).
- 2026-05-27: `flutter test test/features/trade/futures_page_test.dart --reporter=compact`
  passed (`8` tests).
- 2026-05-27: `flutter test test/features/trade/margin_trading_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-27: `flutter test test/features/trade/margin_trading_hub_page_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`10` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S4-04 - Split live market data analytics

Status: `[x]`

Goal:
- Giảm `live_market_data_analytics_page.dart` dưới 1200 dòng và tách chart/list UI.

Scope:
- `flutter_app/lib/features/trade/presentation/pages/live_market_data_analytics_page.dart`
- `flutter_app/lib/features/trade/presentation/widgets/`
- Test liên quan.

Implementation:
- Tách chart cards, metric rows, alert panels.
- Không đổi data source.

Tests:

```bash
flutter test test/features/trade/live_market_data_analytics_page_test.dart --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- File giảm dưới 1200 dòng.
- Tests pass.

Verification log:
- 2026-05-27: `git status --short` before S4-04 showed existing dirty
  `live_market_data_analytics_page.dart`, unrelated dirty trade tests, and
  untracked `presentation/widgets/`; no unrelated changes were reverted.
- 2026-05-27: Extracted live market pair header, tabs, market/liquidation/
  sentiment tab bodies, metric cards, alert/info strips, source rows, and line
  painter to `presentation/widgets/live_market_data_analytics_widgets.dart`.
- 2026-05-27: Metrics: `live_market_data_analytics_page.dart` reduced
  `1250 -> 83` lines; new `live_market_data_analytics_widgets.dart` is `1194`
  lines, under the 1200-line packet threshold.
- 2026-05-27: `dart format .` passed (`1463` files, `2` changed).
- 2026-05-27: `flutter test test/features/trade/live_market_data_analytics_page_test.dart --reporter=compact`
  passed (`3` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S4-05 - Trade controller model split

Status: `[x]`

Goal:
- Giảm kích thước và tăng ownership của `trade_controller_models.dart`.

Scope:
- `flutter_app/lib/features/trade/presentation/controllers/trade_controller_models.dart`
- Có thể tạo model files nhỏ hơn dưới `presentation/controllers/`.
- Trade controller tests.

Implementation:
- Tách view-state theo bounded context: copy, futures/margin, analytics, risk.
- Giữ public exports tương thích nếu tests đang import.

Tests:

```bash
flutter test test/features/trade/trade_controller_test.dart --reporter=compact
flutter test test/features/trade --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- Controller model file nhỏ hơn.
- No controller mock/remote imports.

Verification log:
- 2026-05-27: `git status --short` before S4-05 showed the trade
  presentation controller directory as untracked from prior/current controller
  work; no unrelated dirty files were reverted.
- 2026-05-27: Split `trade_controller_models.dart` into a compatibility barrel
  plus context files: `trade_controller_common.dart`,
  `trade_order_controller_models.dart`, `trade_copy_controller_models.dart`,
  `trade_futures_margin_controller_models.dart`, and
  `trade_risk_bot_controller_models.dart`.
- 2026-05-27: Metrics: `trade_controller_models.dart` reduced `515 -> 5`
  lines; split files are `8`, `91`, `154`, `104`, and `164` lines.
- 2026-05-27: `rg` check found no mock/remote/data repository imports under
  `lib/features/trade/presentation/controllers/`.
- 2026-05-27: `dart format .` passed (`1468` files, `6` changed).
- 2026-05-27: `flutter test test/features/trade/trade_controller_test.dart --reporter=compact`
  passed (`8` tests).
- 2026-05-27: `flutter test test/features/trade --reporter=compact`
  passed (`343` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

- 2026-05-27: Stage S4 verification: initial `flutter analyze` exposed one
  introduced unnecessary import and existing public-widget key/unused-import
  analyzer issues in dirty P2P/Wallet widget files; `dart fix --apply` applied
  41 mechanical analyzer fixes, then `dart format .` passed (`1468` files,
  `6` changed).
- 2026-05-27: Stage S4 verification: `flutter analyze` passed with no issues.
- 2026-05-27: Stage S4 verification: `flutter test --reporter=compact`
  passed (`1833` tests).
- 2026-05-27: Stage S4 verification:
  `dart run tool/route_coverage_audit.dart --check` passed
  (`Route coverage artifact is current.`).

## 12. Stage S5 - Prediction và Arena boundary hardening

### S5-01 - Predictions portfolio/event high-risk state

Status: `[x]`

Goal:
- Prediction event/order/portfolio state rõ, tách khỏi Arena copy và route.

Scope:
- `flutter_app/lib/features/predictions/presentation/pages/prediction_event_detail_page.dart`
- `flutter_app/lib/features/predictions/presentation/pages/predictions_portfolio_page.dart`
- `flutter_app/lib/features/predictions/presentation/controllers/predictions_controller.dart`
- Predictions tests.

Implementation:
- Tách event summary, probability, order preview, receipt/portfolio cards.
- Prediction copy được phép dùng positions, probability, receipt, rewards, P/L.
- Không dùng Arena Points cho prediction financial surfaces.

Tests:

```bash
flutter test test/features/predictions --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:
- Prediction/Arena boundary giữ đúng.
- Tests pass.

Verification log:
- 2026-05-27: `git status --short` before S5-01 showed a large dirty working
  tree with existing modified/untracked files; packet edits were limited to
  predictions event/portfolio state, prediction controller/provider wiring,
  focused prediction tests, product copy guardrail, this backlog entry, and a
  new prediction order preview widget.
- 2026-05-27: Read `prediction_event_detail_page.dart`, event-detail part
  files, `predictions_portfolio_page.dart`, predictions controller/provider
  files, and related prediction tests before editing.
- 2026-05-27: Added `PredictionEventDetailController`,
  `PredictionsPortfolioController`, view-state classes, and typed order preview
  state under `presentation/controllers`; app providers now expose these
  controllers without page/widget data imports.
- 2026-05-27: Event detail now renders an order preview with outcome,
  probability, estimated shares, fee preview, max loss, and disabled submit
  behavior until an amount is entered. Portfolio and Arena bridge copy now state
  that prediction positions/P&L stay separate from Arena Points.
- 2026-05-27: Extracted the order preview UI to
  `lib/features/predictions/presentation/widgets/prediction_order_preview_card.dart`.
  Line metrics: `prediction_event_detail_page_part_02.dart` `655 -> 565`,
  new `prediction_order_preview_card.dart` `121`, and
  `predictions_controller.dart` `107`; large-file guardrail stayed within
  baseline.
- 2026-05-27: Initial `flutter test test/features/predictions --reporter=compact`
  failed on missing controller entity imports and then on an invalid radius
  token after extraction; fixed both in packet scope.
- 2026-05-27: `dart format .` passed after Dart edits (`1470` files,
  `0` changed on final run).
- 2026-05-27: `flutter test test/features/predictions --reporter=compact`
  passed (`84` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`11` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S5-02 - Arena governance/report state

Status: `[x]`

Goal:
- Arena governance/report/challenge flows dùng Points-only language và có state rõ.

Scope:
- `flutter_app/lib/features/arena/presentation/pages/arena_governance_gate_page.dart`
- `flutter_app/lib/features/arena/presentation/pages/arena_report_case_page.dart`
- `flutter_app/lib/features/arena/presentation/pages/arena_challenge_detail_page.dart`
- `flutter_app/lib/features/arena/presentation/controllers/arena_controller.dart`
- Arena tests.

Implementation:
- Tách governance sections, report form, challenge detail cards.
- Không dùng payout, wallet, profit, stake-return language cho Arena.

Tests:

```bash
flutter test test/features/arena --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:
- Arena user-facing pages points-only.
- Tests pass.

Verification log:
- 2026-05-27: `git status --short` before S5-02 showed a large dirty working
  tree with existing modified/untracked files; packet edits were limited to
  Arena governance/report/challenge controller state, provider wiring,
  points-only state widgets, focused Arena tests, product copy guardrail, and
  this backlog entry.
- 2026-05-27: Read `arena_governance_gate_page.dart`,
  `arena_report_case_page.dart`, `arena_challenge_detail_page.dart`,
  `arena_controller.dart`, app Arena controller providers, Arena entities, and
  related Arena tests before editing.
- 2026-05-27: Added `ArenaGovernanceController`,
  `ArenaReportCaseController`, `ArenaChallengeDetailController`, typed
  view-state/review models, and provider-family wiring for report/challenge
  detail routes. Pages now read these scoped controllers instead of calling the
  repository read model directly.
- 2026-05-27: Added reusable points-only state cards in
  `lib/features/arena/presentation/widgets/arena_state_cards.dart` and rendered
  Governance state, Moderation review state, and Challenge Points-only review
  surfaces without payout/wallet/profit/stake-return wording.
- 2026-05-27: Line metrics after packet:
  `arena_controller.dart = 180`, new `arena_state_cards.dart = 209`,
  `arena_report_case_page.dart = 857`, `arena_challenge_detail_page.dart = 272`,
  and `arena_governance_gate_page.dart = 403`. Large-file architecture
  baseline stayed within guardrail.
- 2026-05-27: Initial `flutter test test/features/arena --reporter=compact`
  failed because the new review card duplicated the visible `Entry Points`
  label; fixed by renaming the review label to `Entry point cost`.
- 2026-05-27: An attempted parallel rerun hit Flutter cache `engine.stamp`
  contention/network metadata errors; reran Flutter checks sequentially.
- 2026-05-27: `dart format .` passed after Dart edits (`1472` files,
  `0` changed on final run).
- 2026-05-27: `flutter test test/features/arena --reporter=compact` passed
  (`110` tests).
- 2026-05-27: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`12` tests).
- 2026-05-27: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S5-03 - Clean Arena placeholder/future-ready wording

Status: `[x]`

Goal:
- Làm rõ các bề mặt future-ready mà không gọi nhầm là production behavior.

Scope:
- `flutter_app/lib/features/arena/data/fixtures/`
- `flutter_app/test/features/arena/`
- Arena docs nếu cần.

Implementation:
- Đổi copy "placeholder only" sang mô tả rõ hơn như "future-ready local preview"
  nếu route đã là real page.
- Giữ compliance/KYC gate note nếu flow thật chưa sẵn sàng.

Tests:

```bash
flutter test test/features/arena --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
```

Acceptance:
- Copy không gây hiểu nhầm production readiness.
- Arena boundary pass.

Verification log:
- 2026-05-30: `git status --short` before S5-03 showed a large dirty working
  tree with existing modified/untracked files; packet edits were limited to
  Arena release-gated/placeholder wording, Arena focused tests, the product copy
  guardrail, and this backlog entry.
- 2026-05-30: Read Arena fixture parts, verified/release-readiness pages,
  Arena flow/points/bridge tests, and product copy guardrail before editing.
- 2026-05-30: Reworded Verified Challenges and Arena release-readiness surfaces
  from production/placeholder-style copy to release-gated local preview,
  compliance/KYC-gated, and internal handoff language. Arena disclaimers now
  state that Arena Points stay inside Open Arena and are not a trading account
  or prediction performance.
- 2026-05-30: Cleaned Arena/Prediction bridge boundary copy so Arena Points are
  described as social scoring only, with no conversion, withdrawal, or trading.
  Updated Arena test descriptions/assertions to route-edge/local-preview wording
  without changing route behavior.
- 2026-05-30: Fixed S5-03 regressions found during verification: removed a
  malformed positional string in `mock_arena_repository_methods_part_09.dart`,
  restored a missing bridge info-row text, stabilized mojibake-sensitive test
  assertions, and changed the Arena Points claim-all state to
  `All pending rewards claimed`.
- 2026-05-30: `dart format .` passed after Dart/test edits (`1472` files,
  final run `1` changed).
- 2026-05-30: `flutter test test/features/arena --reporter=compact` passed
  (`110` tests).
- 2026-05-30: `flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact`
  passed (`13` tests), including the new release-gated Arena copy check.
- 2026-05-30: `rg "placeholder|future-ready|future ready|production-ready|production ready|Production Ready|Coming Soon|Not available in production yet|placeholder only|safe placeholder|Prize pool" lib/features/arena/data/fixtures lib/features/arena/presentation/pages test/features/arena test/quality/product_copy_guardrails_test.dart -n`
  returned only input/widget `placeholder` props, the guardrail's banned-term
  regex, and legacy `/arena/production-ready` route naming; no prohibited
  user-facing readiness copy remained in the checked Arena surfaces.
- 2026-05-30: Stage S5 verification `flutter analyze` passed (`No issues
  found!`).
- 2026-05-30: Stage S5 verification initial `flutter test --reporter=compact`
  found two Rewards Hub expectations still pinned to old/mojibake rewards copy;
  updated `test/features/rewards/rewards_hub_page_test.dart` to assert stable
  rewards/points UI markers, the shared `All pending rewards claimed` state, and
  `ReferralHomePage` navigation.
- 2026-05-30: `flutter test test/features/rewards/rewards_hub_page_test.dart --reporter=compact`
  passed (`4` tests).
- 2026-05-30: Stage S5 verification rerun `flutter test --reporter=compact`
  passed (`1841` tests).
- 2026-05-30: Stage S5 verification `dart run tool/route_coverage_audit.dart --check`
  passed (`Route coverage artifact is current.`).

## 13. Stage S6 - Earn, Markets, Launchpad large-page cleanup

### S6-01 - Earn large-page batch 1

Status: `[x]`

Goal:
- Giảm các Earn files trên 1200 dòng.

Scope:
- `flutter_app/lib/features/earn/presentation/pages/staking_transaction_reporting_page.dart`
- `flutter_app/lib/features/earn/presentation/pages/savings_comparison_page.dart`
- `flutter_app/lib/features/earn/presentation/pages/savings_export_page.dart`
- `flutter_app/lib/features/earn/presentation/widgets/`
- Earn tests liên quan.

Implementation:
- Tách tables, filters, export panels, comparison cards.
- Không đổi repository behavior.

Tests:

```bash
flutter test test/features/earn --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- Các files được chạm giảm dưới 1200 dòng nếu khả thi.
- Earn tests pass.

Verification log:
- 2026-05-30: `git status --short` before S6-01 showed a large dirty working
  tree with existing modified/untracked files; packet edits were limited to the
  three Earn pages in scope, extracted Earn presentation widget part files, this
  backlog entry, and focused verification.
- 2026-05-30: Read `staking_transaction_reporting_page.dart`,
  `savings_comparison_page.dart`, `savings_export_page.dart`, and related Earn
  tests before editing. Initial line counts were `1265`, `1245`, and `1223`.
- 2026-05-30: Extracted page-private summary/table/filter/export/sheet widgets
  into `lib/features/earn/presentation/widgets/` while keeping public page
  facades and static test keys unchanged. No repository behavior or route
  behavior changed.
- 2026-05-30: Final line metrics: `staking_transaction_reporting_page.dart`
  `1265 -> 170`, `savings_comparison_page.dart` `1245 -> 226`,
  `savings_export_page.dart` `1223 -> 214`. New extracted widget part files are
  all below `600` lines: `470`, `312`, `320`, `437`, `276`, `313`, `293`,
  `292`, and `431`.
- 2026-05-30: Initial architecture guardrail failed because extracting into
  `presentation/pages/*_part_*.dart` increased page part-file debt from `218`
  to `227`; moved the extracted parts to `presentation/widgets/` and updated
  page `part` directives. Page part-file debt returned to `218`.
- 2026-05-30: `dart format .` passed after refactor (`1481` files, final run
  `3` changed).
- 2026-05-30: `flutter test test/features/earn --reporter=compact` passed
  (`354` tests).
- 2026-05-30: A parallel architecture guardrail run timed out while the Earn
  suite was still using Flutter tooling; reran sequentially.
- 2026-05-30: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S6-02 - Markets large-page batch 1

Status: `[x]`

Goal:
- Giảm các Markets files trên 1200 dòng và tách chart/list UI.

Scope:
- `flutter_app/lib/features/markets/presentation/pages/token_info_page.dart`
- `flutter_app/lib/features/markets/presentation/pages/market_correlations_page.dart`
- `flutter_app/lib/features/markets/presentation/pages/social_sentiment_page.dart`
- `flutter_app/lib/features/markets/presentation/pages/pair_detail_page.dart`
- `flutter_app/lib/features/markets/presentation/widgets/`
- Markets tests liên quan.

Implementation:
- Tách token facts, chart cards, correlation grid, sentiment panels.
- Không thêm remote market data.

Tests:

```bash
flutter test test/features/markets --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- Markets large-file debt giảm.
- Tests pass.

Verification log:
- 2026-05-30: `git status --short` before S6-02 showed a large dirty working
  tree with existing modified/untracked files; packet edits were limited to the
  four Markets pages in scope, extracted Markets presentation widget part files,
  this backlog entry, and focused verification.
- 2026-05-30: Read `token_info_page.dart`, `market_correlations_page.dart`,
  `social_sentiment_page.dart`, `pair_detail_page.dart`, and related Markets
  tests before editing. Initial line counts were `1254`, `1244`, `1222`, and
  `1202`.
- 2026-05-30: Extracted token facts/detail widgets, correlation tabs/matrix/
  pairs/diversification widgets, sentiment tabs/overview/token/trends widgets,
  and pair detail header/chart/order/painter widgets into
  `lib/features/markets/presentation/widgets/`. Public page facades, route
  behavior, static test keys, and controller-backed market data reads were kept.
- 2026-05-30: Final line metrics after `dart format .`: `token_info_page.dart`
  `1254 -> 106`, `market_correlations_page.dart` `1244 -> 161`,
  `social_sentiment_page.dart` `1222 -> 140`, and `pair_detail_page.dart`
  `1202 -> 168`. New extracted widget part files are all below `600` lines:
  `418`, `362`, `375`, `173`, `371`, `195`, `353`, `302`, `196`, `306`,
  `287`, `272`, `479`, `181`, and `111`.
- 2026-05-30: Page part-file debt stayed at `218`; extracted parts live under
  `presentation/widgets/`.
- 2026-05-30: `dart format .` passed (`1496` files, `7` changed).
- 2026-05-30: `flutter test test/features/markets --reporter=compact` passed
  (`124` tests).
- 2026-05-30: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S6-03 - Launchpad large-page batch 1

Status: `[x]`

Goal:
- Giảm các Launchpad files trên 1200 dòng.

Scope:
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_page.dart`
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_event_log_page.dart`
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_limit_orders_page.dart`
- `flutter_app/lib/features/launchpad/presentation/pages/launchpad_claim_receipt_page.dart`
- `flutter_app/lib/features/launchpad/presentation/widgets/`
- Launchpad tests liên quan.

Implementation:
- Tách project cards, event rows, limit order widgets, receipt sections.
- Claim/refund vẫn là local placeholder nếu backend contract chưa có.

Tests:

```bash
flutter test test/features/launchpad --reporter=compact
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- Launchpad large-file debt giảm.
- Tests pass.

Verification log:
- 2026-05-30: `git status --short` before S6-03 showed a large dirty working
  tree with existing modified/untracked files; packet edits were limited to the
  four Launchpad pages in scope, extracted Launchpad presentation widget part
  files, this backlog entry, and focused verification.
- 2026-05-30: Read `launchpad_page.dart`, `launchpad_event_log_page.dart`,
  `launchpad_limit_orders_page.dart`, `launchpad_claim_receipt_page.dart`, and
  related Launchpad tests before editing. Initial line counts were `1272`,
  `1268`, `1266`, and `1264`.
- 2026-05-30: Extracted Launchpad home header/project/tool widgets, event-log
  filter/list/export/misc widgets, limit-order header/active/history/create
  widgets, and claim-receipt hero/overview/timeline/claim-sheet/misc widgets
  into `lib/features/launchpad/presentation/widgets/`. Public page facades,
  route behavior, static test keys, and controller-backed launchpad data reads
  were kept.
- 2026-05-30: Final line metrics after `dart format .`: `launchpad_page.dart`
  `1272 -> 122`, `launchpad_event_log_page.dart` `1268 -> 292`,
  `launchpad_limit_orders_page.dart` `1266 -> 196`, and
  `launchpad_claim_receipt_page.dart` `1264 -> 172`. New extracted widget part
  files are all below `600` lines: `184`, `435`, `538`, `219`, `225`, `220`,
  `321`, `122`, `356`, `107`, `494`, `238`, `239`, `231`, `103`, and `292`.
- 2026-05-30: Page part-file debt stayed at `218`; extracted parts live under
  `presentation/widgets/`.
- 2026-05-30: `dart format .` passed (`1512` files, `20` changed).
- 2026-05-30: `flutter test test/features/launchpad --reporter=compact`
  passed (`121` tests).
- 2026-05-30: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

### S6-04 - Re-measure all large files

Status: `[x]`

Goal:
- Cập nhật metric sau các batch cleanup.

Scope:
- `docs/02_FLUTTER_MIGRATION/AI-Sequential-Execution-Backlog.md`
- `docs/02_FLUTTER_MIGRATION/ke-hoac-tong-the.md`
- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-File-Structure-Audit.md` nếu
  cần cập nhật audit snapshot.

Implementation:
- Đo số feature files trên 600 và trên 1200 dòng.
- Cập nhật bảng baseline.
- Ghi next targets.

Tests:

```bash
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
```

Acceptance:
- Metrics mới rõ ràng.
- Guardrail pass.

Verification log:
- 2026-05-30: `git status --short` before S6-04 showed a large dirty working
  tree with existing modified/untracked files; packet edits were limited to the
  backlog, `ke-hoac-tong-the.md`, `Flutter-Enterprise-File-Structure-Audit.md`,
  and the architecture guardrail threshold update.
- 2026-05-30: Read `ke-hoac-tong-the.md`,
  `Flutter-Enterprise-File-Structure-Audit.md`, and
  `architecture_baseline_guardrails_test.dart` before editing.
- 2026-05-30: Re-measured source metrics from `flutter_app/`: `lib` Dart files
  `1087`, `features` Dart files `1006`, `app` `54`, `core` `5`, `shared` `21`,
  `test` Dart files `423`, complete feature modules `23/23`, page/widget data
  imports `0`, controller mock/remote imports `0`, controller data-provider
  exposure `0`, non-controller feature data imports `27`, hardcoded colors
  outside theme `0`, runtime `Colors.*` `0`, page part-file debt `218`.
- 2026-05-30: Large-file metrics are now feature files `>600 = 239` and
  `>1200 = 4`. Remaining `>1200` files are
  `predictions_portfolio_page.dart` (`1249`),
  `prediction_social_page.dart` (`1225`), `trader_profile_page.dart` (`1225`),
  and `vip_page.dart` (`1224`).
- 2026-05-30: Updated docs baseline tables and audit snapshot; tightened
  architecture guardrail large-file thresholds to `>600 <= 239` and
  `>1200 <= 4`.
- 2026-05-30: `dart format .` passed (`1512` files, `0` changed).
- 2026-05-30: `flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests).

- 2026-05-30: Stage S6 verification `flutter analyze` passed with no issues.
- 2026-05-30: Stage S6 verification `flutter test --reporter=compact` passed
  (`1841` tests).
- 2026-05-30: Stage S6 verification `dart run tool/route_coverage_audit.dart --check`
  passed (`Route coverage artifact is current.`).

## 14. Stage S7 - Manual smoke và QA evidence

### S7-01 - Prepare smoke run

Status: `[x]`

Goal:
- Chuẩn bị build và thiết bị/emulator cho full manual smoke.

Scope:
- `docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md`
- Không sửa app source trừ khi build/test fail.

Implementation:
- Chạy preconditions.
- Build debug APK.
- Kiểm tra emulator/device.
- Nếu không có emulator/device, ghi blocker.

Tests:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --reporter=compact
flutter build apk --debug
```

Acceptance:
- Preconditions pass hoặc blocker rõ.

Verification log:
- 2026-05-30: `git status --short` before S7-01 showed a large dirty working
  tree with existing modified/untracked files; packet edits were limited to
  `Flutter-Manual-Smoke-Checklist.md` and this backlog entry.
- 2026-05-30: Read `Flutter-Manual-Smoke-Checklist.md` before editing.
- 2026-05-30: `flutter pub get` passed; dependencies resolved, with `8`
  packages reported as having newer versions incompatible with current
  constraints.
- 2026-05-30: `dart format --output=none --set-exit-if-changed .` passed
  (`1512` files, `0` changed).
- 2026-05-30: `flutter analyze` passed with no issues.
- 2026-05-30: `flutter test --reporter=compact` passed (`1841` tests).
- 2026-05-30: `flutter build apk --debug` passed and produced
  `build/app/outputs/flutter-apk/app-debug.apk` (`158577114` bytes).
- 2026-05-30: `adb devices` reported `emulator-5554 device`; `flutter devices`
  reported `sdk gphone16k x86 64` Android 17 API 37 plus Windows, Chrome, and
  Edge targets.
- 2026-05-30: Added a 2026-05-30 preconditions/build-ready entry to
  `Flutter-Manual-Smoke-Checklist.md`.

### S7-02 - Execute core navigation smoke

Status: `[x]`

Goal:
- Chạy smoke các flow Home, Markets, Trade, Wallet, Profile.

Scope:
- `docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md`
- `flutter_app/run-artifacts/` local artifacts.

Implementation:
- Clean install hoặc reset app data.
- Kiểm tra 360, 440, 480 px nếu tooling/device cho phép.
- Capture screenshot/notes.
- Ghi run log.

Tests:
- Manual/emulator run.

Acceptance:
- Checklist có result thật cho 5 flow core hoặc blocker rõ.

Verification log:
- 2026-05-30: PASS on `emulator-5554` Android 17 API 37 with debug APK
  `build/app/outputs/flutter-apk/app-debug.apk`. Artifacts are under
  `flutter_app/run-artifacts/core-smoke-20260530T202735/`.
- Commands/actions: `adb uninstall com.vittrade.vit_trade_flutter`,
  `adb install -r build/app/outputs/flutter-apk/app-debug.apk`,
  `adb shell am start -n com.vittrade.vit_trade_flutter/.MainActivity`,
  then `adb shell input tap ...` plus `adb shell screencap -p` and
  `adb shell uiautomator dump` for each core flow.
- Result: confirmed Home `SC-007`, Markets `SC-008`, pair detail `SC-044`,
  Trade `SC-048`, Wallet `SC-135`, Deposit `SC-138`, Profile `SC-156`,
  Profile settings/device entry, and clean KYC retake `SC-159` with app back
  returning to `SC-156`. Clean KYC evidence files are
  `profile-kyc-retake-start.*`, `profile-kyc-retake-page.*`, and
  `profile-kyc-retake-back.*`; earlier accidental Lens captures in the same
  folder are superseded by the retake artifacts.
- Crash buffers: `crash-logcat.txt`, `crash-logcat-final.txt`,
  `crash-logcat-profile-relaunch.txt`, and
  `crash-logcat-profile-kyc-retake.txt` were empty.

### S7-03 - Execute high-risk smoke

Status: `[!]`

Goal:
- Chạy smoke Prediction, Arena, Withdraw, Address Add, P2P Payment Add,
  Token Approval Revoke.

Scope:
- `docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md`
- Local artifacts nếu có.

Implementation:
- Kiểm tra copy preview/confirm.
- Kiểm tra Arena points-only.
- Kiểm tra Prediction tách khỏi Arena.
- Không thực hiện side effect thật.

Tests:
- Manual/emulator run.

Acceptance:
- Checklist có result thật hoặc blocker rõ.

Verification log:
- 2026-05-30: PARTIAL PASS with automation blockers on `emulator-5554`
  Android 17 API 37. Artifacts are under
  `flutter_app/run-artifacts/high-risk-smoke-20260530T204000/`.
- Route capture method: rebuilt debug APK after a Withdraw preview fix,
  installed with `adb install -r build/app/outputs/flutter-apk/app-debug.apk`,
  launched direct Flutter initial routes with
  `adb shell am start -n com.vittrade.vit_trade_flutter/.MainActivity --es route <path>`,
  then captured `adb shell screencap -p` and `adb shell uiautomator dump`.
- Passed evidence: Prediction home `SC-027`, event detail `SC-030`, event
  order preview with `$100` amount and Arena-boundary copy
  (`prediction-event-preview-amount.*`), risk calculator `SC-036`, valid
  receipt `SC-035` for `po-1`, portfolio `SC-031`; Arena home `SC-184`,
  challenge detail `SC-190`, and join review `SC-191` stayed points-only;
  Withdraw retake showed amount/network/fee/received/masked address plus
  explicit `Cancel` and `Confirm withdraw`
  (`withdraw-preview-sheet-retake.*`); Token Approval revoke sheet showed
  spender/token/allowance/gas/impact plus `Cancel` and `Confirm`
  (`token-approval-revoke-sheet.*`).
- Code correction made during smoke: `WithdrawPage` preview sheet originally
  lacked explicit confirmation actions; added `Cancel` and `Confirm withdraw`
  buttons in `flutter_app/lib/features/wallet/presentation/pages/withdraw_page.dart`,
  rebuilt APK, reinstalled, and retook the Withdraw evidence.
- Blocker: Address Add `SC-143` initial screen/risk/agreement copy rendered,
  but adb text entry did not populate the label or address fields; the label
  counter remained `0/30` in `address-add-filled-attempt.*`, so the preview
  confirmation could not be opened non-interactively. Owner: QA/manual operator
  or emulator automation harness. Unblock condition: manual interactive text
  entry on emulator/device or a reliable Flutter text-entry hook for adb runs.
- Blocker: P2P Payment Add `SC-232` initial screen rendered, selected
  `Vietcombank`, and adb populated the account field, but the owner-name field
  did not accept adb text in `p2p-payment-add-filled-retry.*`; confirmation
  dialog could not be opened non-interactively. Owner: QA/manual operator or
  emulator automation harness. Unblock condition: manual interactive text entry
  or a reliable Flutter text-entry hook for adb runs.
- Tests/commands after Dart fix: `dart format .` initially failed because a
  generated `build/` intermediate path disappeared while formatting; removed
  only generated `flutter_app/build/` artifacts and reran `dart format .`
  successfully (`1512` files, `0 changed`). `flutter analyze` passed with no
  issues. `flutter test test/features/wallet/withdraw_page_test.dart
  test/features/wallet/wallet_controller_test.dart --reporter=compact` passed
  (`8` tests). `flutter test test/quality/product_copy_guardrails_test.dart
  --reporter=compact` passed (`13` tests). `flutter test
  test/features/predictions/predictions_controller_test.dart
  test/features/p2p/p2p_controller_test.dart
  test/features/arena/arena_controller_test.dart --reporter=compact` passed
  (`11` tests). `flutter build apk --debug` passed. Crash buffers
  `crash-logcat-high-risk-interactions.txt` and
  `crash-logcat-high-risk-after-fix.txt` were empty.

### S7-04 - QA report sync

Status: `[x]`

Goal:
- Đồng bộ `Flutter-Evidence-QA-Report.md` với kết quả smoke mới nhất.

Scope:
- `docs/02_FLUTTER_MIGRATION/Flutter-Evidence-QA-Report.md`
- `docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md`

Implementation:
- Cập nhật status: pass/fail/blocker.
- Không ghi production-ready nếu backend/release vẫn blocked.

Tests:
- Docs-only; không cần Flutter test nếu không sửa source.

Acceptance:
- QA report không mâu thuẫn với checklist.

Verification log:
- 2026-05-30: `git status --short` reviewed before the packet. Read
  `Flutter-Evidence-QA-Report.md`, `Flutter-Manual-Smoke-Checklist.md`, and
  this backlog section. Updated the QA report generated date, evidence
  snapshot, S7 manual smoke matrix, scorecard, findings, and roadmap so it
  matches the 2026-05-30 checklist rows: S7-01 preconditions passed, S7-02 core
  navigation smoke passed, and S7-03 high-risk smoke partially passed with
  Address Add / P2P Payment Add text-entry blockers. Kept backend/release
  production blockers explicit and did not claim production-ready status.
  `git diff --check -- docs/02_FLUTTER_MIGRATION/Flutter-Evidence-QA-Report.md
  docs/02_FLUTTER_MIGRATION/Flutter-Manual-Smoke-Checklist.md
  docs/02_FLUTTER_MIGRATION/AI-Sequential-Execution-Backlog.md` passed.
  `Select-String` stale-term checks for old smoke/test/metric claims returned
  no matches. Docs-only packet; no Flutter test required.

## 15. Stage S8 - Closeout và readiness report

### S8-01 - Final architecture audit refresh

Status: `[x]`

Goal:
- Cập nhật audit cấu trúc file/folder sau khi hoàn tất frontend hardening.

Scope:
- `docs/02_FLUTTER_MIGRATION/Flutter-Enterprise-File-Structure-Audit.md`
- `docs/02_FLUTTER_MIGRATION/ke-hoac-tong-the.md`
- File backlog này.

Implementation:
- Đo lại metrics.
- Ghi rõ phần đã đạt, phần backend/release external vẫn chưa đạt.

Tests:

```bash
flutter test test/quality/architecture_baseline_guardrails_test.dart --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Acceptance:
- Audit snapshot mới khớp code.

Verification log:
- 2026-05-30: `git status --short` reviewed before the packet. Read
  `Flutter-Enterprise-File-Structure-Audit.md`, `ke-hoac-tong-the.md`, and this
  backlog section. Re-measured current architecture metrics: `lib` Dart files
  `1087`, `test` Dart files `423`, total `lib/test/tool` Dart files `1512`,
  feature files `1006`, app `54`, core `5`, shared `21`, feature modules
  `23/23`, page/widget data imports `0`, controller mock/remote imports `0`,
  controller data-provider exposure `0`, non-controller direct feature data
  imports `27`, page part-files `218`, runtime `Colors.*` `0`,
  `Color(0x...)` outside theme `0`, feature files `>600` `239`, and feature
  files `>1200` `4`. Updated `Flutter-Enterprise-File-Structure-Audit.md` and
  `ke-hoac-tong-the.md` so verification evidence and dashboard status reflect
  S7/S8 results, backend/release external blockers, and Address Add / P2P
  Payment Add QA blockers. `flutter test
  test/quality/architecture_baseline_guardrails_test.dart --reporter=compact`
  passed (`10` tests). `dart run tool/route_coverage_audit.dart --check`
  passed (`Route coverage artifact is current.`). `git diff --check --`
  against the updated docs passed.

### S8-02 - Full local verification

Status: `[x]`

Goal:
- Chốt toàn bộ queue bằng full local checks.

Scope:
- Không sửa source trừ khi checks fail.

Tests:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --reporter=compact
dart run tool/route_coverage_audit.dart --check
```

Acceptance:
- Full local checks pass.
- Nếu fail, mở packet sửa lỗi nhỏ trước khi tick `[x]`.

Verification log:
- 2026-05-30: `git status --short` reviewed before the packet. Read S8-02
  scope/tests/acceptance. First `dart format --output=none
  --set-exit-if-changed .` failed on a generated Android `build/` desugar
  directory `PathNotFoundException`, not on source formatting. Verified
  `flutter_app/build/` resolved inside the app workspace, cleaned only that
  generated build directory, then reran the exact command successfully:
  `Formatted 1512 files (0 changed) in 4.20 seconds.` `flutter analyze`
  passed with `No issues found!`. `flutter test --reporter=compact` passed
  (`1841` tests). `dart run tool/route_coverage_audit.dart --check` passed
  (`Route coverage artifact is current.`). No source edits were required.

### S8-03 - Final status summary

Status: `[x]`

Goal:
- Ghi kết luận cuối cho frontend hardening queue.

Scope:
- File backlog này.
- `docs/02_FLUTTER_MIGRATION/ke-hoac-tong-the.md`
- `docs/02_FLUTTER_MIGRATION/Flutter-Evidence-QA-Report.md`

Implementation:
- Ghi các metrics cuối.
- Liệt kê backend blockers còn lại.
- Liệt kê release ops blockers còn lại.
- Nêu rõ frontend hardening done hay còn packet nào `[ ]`, `[~]`, `[!]`.

Tests:
- Docs-only nếu không sửa Dart.

Acceptance:
- Không còn packet `[ ]` hoặc `[~]` trong file này.
- Packet `[!]` nếu có đều có blocker cụ thể và owner ngoài repo.

Verification log:
- 2026-05-30: `git status --short` reviewed before the packet. Read S8-03
  scope/tests/acceptance and current status list. Updated
  `Flutter-Evidence-QA-Report.md` with S8-02 full local verification results and
  a final queue status table. Updated `ke-hoac-tong-the.md` with S8-02 full
  local verification rows and final queue closeout notes.
- Final local frontend hardening queue status: no packet remains `[ ]` or
  `[~]`. Remaining `[!]` packets are `S2-06 - Wallet smoke evidence` and
  `S7-03 - Execute high-risk smoke`.
- `S2-06` blocker owner: QA automation / Android emulator input owner. Unblock
  condition: provide reliable Flutter/emulator text-entry automation or complete
  manual interactive Address Add smoke with evidence.
- `S7-03` blocker owner: QA/manual operator or emulator automation harness.
  Unblock condition: manual interactive text entry or reliable Flutter
  text-entry hook for Address Add and P2P Payment Add confirmation flows.
- Backend blockers remain external: Auth, Wallet, Trade, P2P, Predictions, and
  Arena remote repositories/backend contracts.
- Release ops blockers remain external: Android signing secrets and observed
  hosted CI/store release artifact validation.
- Final metrics recorded in docs: `lib` Dart files `1087`, `test` Dart files
  `423`, `lib/test/tool` Dart files `1512`, route entries `417`, real pages
  `414`, redirect aliases `3`, page/widget data imports `0`, controller
  mock/remote imports `0`, controller data-provider exposure `0`,
  non-controller direct feature data imports `27`, runtime `Colors.*` `0`,
  hardcoded colors outside theme `0`, feature files `>600` `239`, feature files
  `>1200` `4`, page part-files `218`.
- Latest verification: S8-02 `dart format --output=none --set-exit-if-changed
  .` passed (`1512` files, `0` changed) after cleaning generated
  `flutter_app/build/`; `flutter analyze` passed; `flutter test
  --reporter=compact` passed (`1841` tests); `dart run
  tool/route_coverage_audit.dart --check` passed. Docs-only S8-03; no new
  Flutter command required. `git diff --check --` against updated docs passed.

## 16. Backend handoff list

Các mục dưới đây không chặn frontend hardening queue, nhưng vẫn chặn production
enterprise-grade thật:

| Area | Owner | Frontend action allowed | Blocker |
| --- | --- | --- | --- |
| Auth remote APIs | Backend team | Fail-closed UI, controller state, contract skeleton review | Endpoint/auth contract thật |
| Wallet remote APIs | Backend team | Preview/confirm UI, typed error display, mock/fail-closed tests | Wallet API contract thật |
| Trade remote APIs | Backend team | Order/risk UI, local view-state, mock tests | Order execution/market data contract thật |
| P2P remote APIs | Backend team | Payment/dispute/escrow UI states | P2P escrow/payment contract thật |
| Predictions remote APIs | Backend team | Event/order/receipt UI states | Prediction market contract thật |
| Arena remote APIs | Backend team | Points-only UI, governance/report state | Arena contract thật |
| Android release signing | Release/Ops | Fail-closed guardrails, docs | Keystore/CI secrets |

## 17. Quick command snippets for future AI

Đo file lớn:

```powershell
Get-ChildItem lib/features -Recurse -Filter *.dart -File |
  ForEach-Object {
    $count=(Get-Content $_.FullName).Count
    if ($count -gt 600) {
      [PSCustomObject]@{Lines=$count; Path=$_.FullName}
    }
  } | Sort-Object Lines -Descending
```

Đo page part files:

```powershell
Get-ChildItem lib/features -Recurse -Filter *_part_*.dart -File |
  Where-Object { $_.FullName -match '\\presentation\\pages\\' } |
  Measure-Object
```

Đo presentation widgets:

```powershell
Get-ChildItem lib/features -Directory | ForEach-Object {
  [PSCustomObject]@{
    Feature=$_.Name
    Widgets=(Get-ChildItem "$($_.FullName)\presentation\widgets" -Filter *.dart -File -ErrorAction SilentlyContinue).Count
  }
}
```
