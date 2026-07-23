# Trade Redesign V2 — "Command Center" Charter

**Version:** 1.0 | **Created:** 2026-07-19
**Scope:** toàn bộ họ Trade — 6 module (`trade`, `trade_core`, `trade_terminal`, `trade_bots`,
`trade_copy`, `trade_compliance`), 91 màn hình theo kiểm kê sống 2026-07-19.
**Quan hệ với v1:** kế thừa 100% phần không-thị-giác của
[ke-hoach-redesign-theo-module.md](ke-hoach-redesign-theo-module.md) §3 (Vit* bắt buộc, states,
financial safety, cấm, product boundaries) — **chỉ thay đổi phần thị giác** (density, radius,
typography, layout mandate). Không đụng 22 module khác (RD-M01, RD-M04, RD-M06..RD-M23) —
những module đó **giữ nguyên charter v1**.

**Lý do có v2 riêng cho Trade:** người dùng chọn hướng "Command Center" (dân trader chuyên,
mật độ cao) cho riêng Trade — khác hẳn North Star v1 ("đơn giản trước") vốn áp cho toàn app.
Trade là module duy nhất được xác nhận đổi hướng.

---

## 1. North Star v2 (chỉ Trade)

**Chính xác trước · Dữ liệu luôn hiện · Không trang trí thừa.**

Đối tượng: người dùng đã quen giao dịch, ưu tiên xem được nhiều số liệu cùng lúc hơn là
giao diện "mềm mại". Đây là thay đổi có chủ đích, đánh đổi lấy mật độ thông tin — không áp
dụng cho user mới (màn hình onboarding-trade nếu có, xem §5 ngoại lệ).

## 2. Token thị giác v2 — dùng token CÓ SẴN, không tạo token mới

Xác minh trực tiếp trên `lib/app/theme/`, không đoán:

| Trục | v1 hiện tại (mix) | v2 Command Center (bắt buộc) | Token thật |
| --- | --- | --- | --- |
| Density | `.standard`/`.relaxed` lẫn `.compact` tuỳ trang | **`VitDensity.tool`** cho mọi trang Trade (đã tồn tại, `cardVerticalPadding` 8px — chặt hơn cả `.compact`) | `lib/app/theme/app_density.dart:5` |
| Radius card/control | `AppRadii.input` (14px) / `AppRadii.card` (16px) | **`AppRadii.sm`** (8px) cho card/control thường | `lib/app/theme/app_radii.dart:21` |
| Radius hero | `AppRadii.cardLarge` (24px, `VitCardVariant.hero`) | **`AppRadii.card`** (16px) — hero không còn to hơn hẳn card thường | `lib/app/theme/app_radii.dart:32` |
| Số liệu tài chính | `tabularFigures` đã dùng ở hầu hết nhưng KHÔNG 100% | **100% không ngoại lệ** — ratchet mới, guardrail test sẽ chặn số liệu mới không có `fontFeatures: tabularFigures` | `AppTextStyles.tabularFigures` (đã có, 22+ chỗ dùng) |
| Số liệu phụ (order id, funding rate, mã lệnh) | Font mặc định | **`AppTextStyles.monoCode`** (đã có, `fontFamily: 'monospace'`) | `app_text_styles.dart:159` |

**Không tạo token mới.** Mọi giá trị trên đã tồn tại trong theme — v2 chỉ thay đổi TẦN SUẤT áp
dụng (dùng nhất quán 100% thay vì tuỳ trang), không thêm biến thể mới vào `VitDensity`/`AppRadii`.

## 3. Yêu cầu layout mới (khác v1)

- Mọi trang có hero giá (archetype `form`/`detail-stat` gắn với 1 cặp giao dịch) phải luôn hiện
  **biểu đồ mini (sparkline) + cao/thấp/khối lượng 24h** ngay trong viewport đầu — không giấu
  sau nút "xem thêm"/tab. (v1 không yêu cầu điều này; nhiều trang Simple-mode hiện chỉ có giá +
  % thay đổi, không có sparkline/stat row — xem `vit_trade_simple_hero.dart`, cần bổ sung.)
- Toggle Mua/Bán, order-type, timeframe: dùng chip/segment CHẶT (`VitDensity.tool` height 44px),
  không dùng full-width button cho action phụ.

## 4. Giữ nguyên 100% từ v1 (không đổi)

- **Vit\* bắt buộc:** `VitPageLayout`, `VitPageContent`, `VitCard`, `VitHeader`, `VitTabBar`,
  `VitSegmentedChoice`, `VitCtaButton`, `VitInput`, `VitPresetChipRow`, `VitStatusPill`.
- **States:** loading · empty · error · offline · submitting · success — không được bỏ bớt vì
  "dày đặc hơn".
- **Financial safety:** preview + confirm bắt buộc trước withdraw/lệnh rủi ro cao — **không
  rút gọn thành 1 bước** dù mục tiêu là giảm thao tác. Tốc độ không được đánh đổi lấy an toàn.
- **Cấm (giữ nguyên + thêm 1 mục):** card-in-card · tab trong `VitCard` border · local duplicate
  Vit\* · magic radius (giá trị số không qua `AppRadii`) · hype/casino · sửa Home. **Thêm cho
  v2:** không hạ mật độ xuống dưới `VitDensity.tool` dù màn hình "trông trống" — đặc tính module
  Trade v2 là dày đặc có chủ đích, không phải thiếu nội dung.
- **Giữ `sc*` test key** — đổi UI không được đổi `Key('scNNN_...')` đã có (xem bài học
  `SC-099`/`SC-042` — nếu 1 trang thật sự có 2 danh tính khác nhau, xác nhận ID đúng qua route
  name trước khi đổi).

## 5. Ngoại lệ

- Không áp v2 cho Home (`sc007Home`, RD-M01 reference — quy tắc cũ giữ nguyên).
- Screen archetype `other` (FAQ, guide, API docs, terms — 8 màn, xem batch plan) không bắt buộc
  sparkline/stat-row của §3 vì không gắn với 1 cặp giao dịch; vẫn áp density/radius/typography.
- `trade_core` (0 màn hình riêng, kernel widget dùng chung) — sửa tại đây lan toả tự động sang
  5 module con qua các widget `VitTradeHubHero`/`VitTradeDetailHero`/`VitTradeAnalyticsHero`/
  `VitTradeComplianceHero`; ưu tiên sửa Ở ĐÂY trước khi sửa từng trang riêng lẻ.

## 6. Gate mỗi batch

- `flutter analyze` sạch.
- Test scoped batch pass (không chạy full suite mỗi batch, chạy full suite cuối module).
- Không giảm density xuống dưới `.tool` ở bất kỳ trang nào trong batch.
- Không có `Color(0x`/magic radius mới ngoài `AppRadii`/`AppColors`.
- Guardrail hiện có (`architecture_*`, `design_token_consistency`, `home_reference_consistency`)
  vẫn xanh — v2 không được phá vỡ ranh giới kiến trúc đã xác lập trong phiên dọn dẹp trước đó.

## Liên quan

- [ke-hoach-redesign-theo-module.md](ke-hoach-redesign-theo-module.md) — charter v1, vẫn áp dụng cho 22 module khác
- [Trade-Redesign-V2-Batch-Plan.csv](Trade-Redesign-V2-Batch-Plan.csv) — batch thực thi, 91 màn hình, đường dẫn file hiện tại (post ADR-002 split)
- [Trade-Hero-Section-Archetype-Standard.md](../standards/Trade-Hero-Section-Archetype-Standard.md) — 4 hero widget, không đổi bởi v2
- [ADR-002](../../05_ARCHITECTURE/decisions/ADR-002-trade-family-split.md) — lý do 6 module hiện tại
