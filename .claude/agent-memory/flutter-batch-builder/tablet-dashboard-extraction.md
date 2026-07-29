---
name: tablet-dashboard-extraction
description: Batch-by-batch trap ledger for the 6-batch VitTwoColumnTabletDashboard extraction (Markets/Wallet/Home/Trade/Profile to shared widget). Read when doing another batch in this specific series.
metadata:
  type: feedback
---

Bối cảnh: tách scaffold Row/Align/ConstrainedBox/VitCard hand-rolled lặp lại
ở 5 trang tablet dashboard (Markets batch 1, Wallet batch 2, Home batch 3,
Trade batch 4, Profile batch 5) thành `VitTwoColumnTabletDashboard`
(`lib/shared/layout/vit_two_column_tablet_dashboard.dart`). Batch 6/6 còn
lại (nội dung chưa rõ tại thời điểm ghi — có thể là cleanup/consolidation
cuối, ví dụ cập nhật `Tablet-Adaptive-Standard.md` để nhắc widget dùng
chung, xem mục cuối).

## Audit tool hay stale ngoài danh sách verify của task — 4 tool đã gặp

Khi trích 1 block `VitCard`/`VitPageContent`/token khỏi 1 page ra shared
widget, full suite có thể lộ guardrail KHÔNG nằm trong danh sách lệnh verify
của task, dù nguyên nhân là chính file mình sửa (HOẶC — xem case Profile
batch 5/6 bên dưới — do 1 batch KHÁC đang chạy song song):

- `tool/card_tile_manifest.dart` ghi `VitTrade-Card-Tile-Migration-
  Manifest.csv` — KHÁC `card_tile_audit.dart`'s "legacy manifest"
  (`VitTrade-Card-Tile-Manifest.csv`, tên gần giống nhưng 2 tool/2 file
  riêng). `card_tile_audit.dart --check` xanh KHÔNG có nghĩa manifest này
  cũng current.
- `tool/design_token_consistency_audit.dart` stale ngay khi có file `lib/`
  mới (kể cả 0 debt) — cần 1 dòng cho file đó.
- `tool/navigation_edge_audit.dart` stale ngay cả khi CHỈ xoá import (dịch
  số dòng `context.go`/`push`, không đổi logic điều hướng) — KHÔNG wire vào
  bất kỳ `flutter test` guardrail nào (artifact-check only) → full suite
  xanh KHÔNG đảm bảo nó current, phải tự `--check` riêng.
- `tool/back_navigation_behavior_audit.dart` (guardrail:
  `test/quality/back_navigation_behavior_guardrail_test.dart`) — MỚI phát
  hiện ở Profile batch 5/6: stale chỉ từ dịch số dòng `VitHeader`/
  `VitTopChrome` back-callback trong `VitTrade-Header-Back-Navigation-
  Behavior-Audit.{csv,md}`. Khác 3 tool trên: đây là tool DUY NHẤT trong
  nhóm này có guardrail trong `test/quality/` nhưng KHÔNG nằm trong
  checklist verify của bất kỳ batch nào 1-5/6 — chỉ full suite bắt được.
  Case cụ thể: Profile không hề xuất hiện trong diff của tool này — 2 dòng
  đổi (172→170, 130→129) đều thuộc `trade_tablet_page.dart`/
  `wallet_tablet_page.dart`, tức do batch 4 và batch 2 (đang/đã chạy song
  song trong CÙNG working tree — xem mục riêng bên dưới) gây ra, không
  phải do edit của Profile. Vẫn phải tự regenerate + verify vì full suite
  của TASK MÌNH yêu cầu xanh — đừng bỏ qua chỉ vì "không phải lỗi do
  mình", nhưng báo cáo đúng nguyên nhân, đừng nhận vơ hay đổ oan.
- Xử lý đúng cho cả 4 tool trên: regenerate (không `--check`), diff xem
  đúng là hệ quả cơ học (số dòng dịch/literal biến mất), không lẫn nội
  dung batch khác đang dở dang trong cùng worktree, rồi `--check` lại +
  rerun guardrail test.
- Doc comment ngay trước method bị sửa: nếu mô tả chi tiết implementation
  của đúng block vừa xoá (vd tham chiếu trực tiếp `TabletDashboardWidths`),
  nó stale NGAY do chính edit — sửa gọn lại cùng lúc, coi là hệ quả
  trong-scope (đã làm nhất quán ở Wallet/Home/Trade/Profile, cùng 1 khuôn
  câu "are owned by [VitTwoColumnTabletDashboard] (`TabletDashboardWidths`
  defaults) — ...").
- 2 audit tool biểu diễn "đóng góp của 1 file biến mất" KHÁC NHAU:
  `page_rhythm_audit.dart` giữ nguyên row (mỗi file presentation luôn có 1
  row) nhưng field rhythm rỗng đi khi literal `VitPageRhythm` rời khỏi
  file; `card_tile_audit.dart`/`card_tile_manifest.dart` XOÁ hẳn row khi
  file hết `VitCard` literal. Đừng ngạc nhiên khi 1 audit "shrink" còn audit
  kia "disappear" cho cùng 1 edit.
- `page_content_width_audit.dart` và `design_token_consistency_audit.dart`
  KHÔNG bị chạm bởi kiểu xoá `VitCard`/`VitPageRhythm` literal này (0 diff
  ở cả Home/Wallet/Trade/Profile) — nhưng vẫn cứ chạy `--check` đủ cả danh
  sách, đừng suy đoán "chắc cũng như batch trước nên bỏ qua".
- `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md` (R1-R9)
  CHƯA cập nhật để nhắc `VitTwoColumnTabletDashboard` qua hết cả 5 batch —
  vẫn mô tả như từng trang tự hand-roll Row/Align/ConstrainedBox/VitCard.
  Biết vậy khi đọc nó ở bước "Read before editing"; đừng tự sửa doc này nếu
  task không nêu rõ — chỉ note lại trong báo cáo (đã note ở Wallet/Home/
  Trade/Profile; có thể là việc của batch 6/6).

## Bất biến tài chính/UI giữ nguyên qua swap sang shared widget

- Trade (batch 4/6): risk panel không có `VitCard` ancestor, positions
  panel có — 0 sửa test, cả 7 case xanh. Bọc `secondaryChildren` trong
  `VitCard(inner)`/để `primaryChildren` trần an toàn cho cả nội dung nhạy
  cảm tài chính, miễn giữ đúng which-children-goes-where.
- Profile (batch 5/6): tương tự — legal accordion (39-item GOM) ở
  `primaryChildren` (KHÔNG có `VitCard` ancestor), VIP/Prediction/Arena ở
  `secondaryChildren` (CÓ `VitCard` ancestor) — test xác nhận cả 2 chiều
  (positive + differentiator sanity check trong cùng 1 case), 0 sửa test,
  cả 7 case xanh.

## Nhiều batch-builder song song trong CÙNG 1 working tree (không worktree riêng)

- Quan sát thực tế ở Profile batch 5/6: đầu phiên, git status snapshot chỉ
  có Home (batch 3) là uncommitted; giữa phiên, Wallet (batch 2) và Trade
  (batch 4) CŨNG xuất hiện "M" với đúng diff pattern migration — tức có
  agent khác đang/đã chạy batch 2 và 4 CÙNG lúc, trong CÙNG working tree
  (vi phạm khuyến nghị worktree ở `.claude/rules/session-discipline.md`,
  dù không agent nào tự ý bật worktree cho series này). Không có xung đột
  file trực tiếp (mỗi batch chỉ sửa đúng 1 page file, disjoint), nhưng bề
  mặt va chạm THỰC là: (a) global audit artifact (card-tile, page-rhythm,
  navigation-edges, back-nav — xem mục trên) phản ánh CHUNG trạng thái cả
  cây, không tách được phần đóng góp của batch nào nếu không tự diff so
  nội dung; (b) chính MEMORY.md (repo root) — 1 lần quan sát thấy `git
  status` báo "M" cho MEMORY.md trong khi Glob/Read tại đúng path đó báo
  "không có file" (khả năng cao do 1 agent khác đang ghi/dọn giữa chừng).
  Xử lý đúng: đừng cố "dọn" file ngoài scope batch của mình — chỉ
  regenerate/verify phần global-artifact cần cho CHÍNH task mình, diff để
  xác nhận thay đổi hợp lý (không lẫn nội dung dở dang của batch khác), và
  báo cáo minh bạch kiểu "X/Y file này tôi không sửa, thấy đã đổi khi tôi
  bắt đầu — khả năng cao do batch song song", đừng suy diễn xa hơn bằng
  chứng có.

## Vụn vặt

- Task prompt ghi sai số case 1 file test đôi lúc (Trade batch 4/6: nói
  "8" nhưng thực tế chỉ có 7 `testWidgets(`) — grep đếm thật trước khi
  trích số vào báo cáo, đừng tin số trong prompt. (Profile batch 5/6: prompt
  nói "7", grep ra đúng 7 — không phải lần nào cũng sai, nhưng grep xác
  nhận mỗi lần vẫn rẻ và đáng làm.)
- `tokensave_callers`/`tokensave_impact` cần node_id thật từ
  `tokensave_search` trước — gọi thẳng tên class (vd
  `VitTwoColumnTabletDashboard`) báo "node not found: cần dùng
  tokensave_search hoặc tokensave_callers_for". Việc đơn giản kiểu "còn ai
  dùng shared widget X" thì Grep `lib/` rẻ hơn nhiều, khỏi tốn budget 7
  lệnh tokensave/project — tái xác nhận ở Profile batch 5/6, không phải
  lỗi một lần.

## Tablet-Adaptive batch (R1-R9) — chi tiết implementation

- Nếu phone page có state switch LỒNG bên trong provider (vd
  `snapshot.screenState` enum riêng bên trong `FutureProvider<Snapshot>`,
  ngoài `AsyncValue.when` chuẩn), tablet page cần switch lồng tương tự —
  đừng chỉ port outer `.when()`. Nếu 1 nhánh lồng (vd `offline`) vừa show
  banner VỪA render dashboard bên dưới (không phải "thay vì" dashboard), đặt
  banner làm item ĐẦU của `primaryChildren` (giống `WalletUnavailableBanner`
  trong `WalletTabletPage`) — đừng bịa thêm outer-layout branch thứ 3.
- `if (context.mounted) context.go(...)` sau `await`, trong closure async
  của 1 METHOD PHỤ của State (không phải trực tiếp `build()`), có thể vẫn
  bị `use_build_context_synchronously` bắt dù cùng cú pháp guard chạy sạch
  khi viết trực tiếp trong `build()`. Fix đã verify (Wallet; tái xác nhận
  nguyên trạng ở Profile — không cần sửa gì thêm vì file đã đúng sẵn):
  capture `final navContext = context;` đầu closure TRƯỚC await, dùng biến
  local đó thay vì gọi lại getter `context`.
