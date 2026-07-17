# ADR-001 — Idiom lỗi async cho đường ghi tài chính

- **Trạng thái:** Đã chốt (GĐ2 · ERR-35, 2026-07-17)
- **Phạm vi:** mọi controller có mutation/async trên đường ghi tài chính (trade spot/futures/leverage, predictions, và các flow high-risk về sau)
- **Implementation tham chiếu:** `TradeOrderController` (`flutter_app/lib/features/trade/presentation/controllers/trade_order_controller_models.dart`)

## Bối cảnh

Trước ERR-35, mọi đường ghi (submitOrder/submitFuturesOrder/submitFuturesLeverage) là **đồng bộ giả-vờ-thành-công**: controller const trả receipt ngay, UI điều hướng receipt lập tức, 10 trạng thái của `TradeHighRiskFlowStatus` tồn tại nhưng phần lớn là dead branch (panel high-risk hardcode `riskReview`). Khi backend thật về, mọi đường ghi sẽ là network call có độ trễ và có thể lỗi — code phải sẵn khuôn từ bây giờ.

## Quyết định

1. **Đường ghi repository là `Future<T>`.** Mock repo mô phỏng mạng bằng `loadDelay` (mặc định 300ms) + `simulateError` (ném `StateError`); test truyền `Duration.zero`. Khuôn: `MockTradeTerminalRepository`.
2. **Controller write-path là `Notifier` (`NotifierProvider[.autoDispose].family`, arg qua constructor — idiom Riverpod 3).** View-state bất biến + `copyWith`; view chỉ `ref.watch` state và gọi method notifier.
3. **KHÔNG dùng `AsyncValue<ViewState>` cho máy trạng thái high-risk.** Trục trạng thái là enum `TradeHighRiskFlowStatus` (10 giá trị, giàu ngữ nghĩa hơn 3 pha của AsyncValue). `AsyncNotifier`/`AsyncValue.guard` dành cho đường ĐỌC (home/news fetch).
4. **Lỗi offline phân loại riêng** qua marker `OfflineFailure` (`flutter_app/lib/core/data/offline_failure.dart`) → status `offline`; mọi lỗi khác → `error` + `errorMessage` tiếng Việt. Controller không bao giờ ném ra UI.
5. **Sau `await` bắt buộc guard `ref.mounted`** (notifier autoDispose có thể bị dispose khi user rời trang giữa chừng) và `context.mounted` ở tầng widget.

## Bảng ghi 10 trạng thái (điểm ghi production)

| Status | Điểm ghi |
|---|---|
| `draft` | `build()` khi form trống (amount/margin ≤ 0) |
| `validationError` | `build()` khi có input nhưng validation fail |
| `ready` | `build()` khi đủ điều kiện submit |
| `preview` | `enterPreview()` — mở sheet 'Xem lại lệnh' |
| `confirming` | đầu `submit()` — người dùng vừa xác nhận trong sheet (`cancelPreview()` đưa về `ready` khi đóng sheet) |
| `submitting` | `submit()` ngay trước khi await repo |
| `submitted` | `submit()` sau khi repo trả receipt (state giữ receipt) |
| `success` | cuối `submit()` thành công — view điều hướng receipt |
| `error` | catch `Object` trong `submit()` + `errorMessage` |
| `offline` | catch `OfflineFailure` trong `submit()` |

## Bảng map 10 status → 7 `VitHighRiskUiState`

Mapper dùng chung: `flutter_app/lib/features/trade_core/presentation/widgets/trade_high_risk_status_ui.dart`.

| `TradeHighRiskFlowStatus` | `VitHighRiskUiState` |
|---|---|
| draft, ready, validationError, preview, confirming | `riskReview` |
| submitting, submitted | `submitting` |
| success | `success` |
| error | `error` |
| offline | `offline` |

## Hệ quả / nợ còn lại

- Các đường ghi phụ (`submitOrderAction`, `submitConvert`, `submitOcoOrder`, `patchTradeSettings`, ...) vẫn đồng bộ — migrate dần khi chạm tới, cùng khuôn này.
- STATE-S22 nhân idiom sang futures order + leverage; ERR-36 sang predictions; STATE-S26 ghi pattern vào AGENTS.md + guardrail ratchet.
- Khi backend thật về: thay body mock bằng network call, giữ nguyên chữ ký và máy trạng thái.
