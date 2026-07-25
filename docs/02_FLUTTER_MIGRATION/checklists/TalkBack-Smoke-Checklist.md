# Android TalkBack — P0 Smoke Checklist

**Date:** 2026-07-25  
**Scope:** Manual TalkBack smoke for five P0 money / auth / security surfaces.  
**Harness:** `flutter_app/test/quality/accessibility_semantics_critical_flows_test.dart` (D1).  
**Not a substitute for:** full release smoke in `Flutter-Manual-Smoke-Checklist.md`.

## Preconditions

1. Debug or staging build on a physical Android device or emulator with **TalkBack** on.
2. Locale / spoken language: Vietnamese (or device TTS that can read Vietnamese labels).
3. Mock data OK for UI-only smoke (`enableMockData`); do not claim production API evidence.
4. Optional harness gate before device run:

```bash
cd flutter_app
flutter test test/quality/accessibility_semantics_critical_flows_test.dart --reporter=compact
```

## How to score

| Mark | Meaning |
| --- | --- |
| Pass | TalkBack announces the expected cue (exact or clearly matching the label below) |
| Fail | Missing label, English-only internal ID, or wrong control announced |
| Blocked | Cannot reach step (form entry / nav) — note why |

Record date, build SHA / APK path, device, and Pass/Fail in the run log.

---

## P0 flows

### 1. Login — `/auth/login` (SC-001)

| Step | Action | Expected spoken cue (from Semantics / control text) |
| --- | --- | --- |
| 1.1 | Land on login | Page: **Đăng nhập** |
| 1.2 | Focus identifier field | **Email / Số điện thoại** |
| 1.3 | Focus password field | **Mật khẩu** |
| 1.4 | Focus password visibility toggle | **Hiện mật khẩu** or **Ẩn mật khẩu** |
| 1.5 | Focus primary CTA | **Đăng nhập** (button) |

Harness note: Login is **not** in `accessibility_semantics_critical_flows_test.dart`; cues come from `VitPageLayout.semanticLabel`, `VitInput` labels, and CTA child text.

### 2. Wallet withdraw confirm — `/wallet/withdraw` (SC-139)

| Step | Action | Expected spoken cue |
| --- | --- | --- |
| 2.1 | Focus amount | **Số tiền rút** |
| 2.2 | Focus destination | **Địa chỉ nhận rút** (or matching address field label) |
| 2.3 | Focus preview CTA | **Xem trước lệnh rút** |
| 2.4 | Open preview sheet → focus cancel | **Hủy xem trước lệnh rút** |
| 2.5 | Focus confirm | **Xác nhận rút** |

Harness: SC-139 in `accessibility_semantics_critical_flows_test.dart`.

### 3. Trade MUA / BÁN — `/trade` (SC-048)

| Step | Action | Expected spoken cue |
| --- | --- | --- |
| 3.1 | Focus side MUA | **Chọn mua** |
| 3.2 | Focus side BÁN | **Chọn bán** |
| 3.3 | Focus quantity (buy side) | **Số lượng mua …** (asset suffix) |
| 3.4 | Empty form → focus submit | **Nhập số lượng để tiếp tục đặt lệnh** |
| 3.5 | After qty → focus submit (buy) | **Xác nhận mua lệnh Spot** |
| 3.6 | Confirm sheet cancel | **Huỷ xem trước lệnh giao dịch** |
| 3.7 | Confirm sheet confirm | **Xác nhận gửi lệnh giao dịch** |

Harness: SC-048. Sell submit may announce **Đặt lệnh bán Spot** when side is BÁN.

### 4. P2P payment confirm — `/p2p/payment-method/add` (SC-232)

| Step | Action | Expected spoken cue |
| --- | --- | --- |
| 4.1 | Focus bank / e-wallet type | **Chọn ngân hàng** / **Chọn ví điện tử** |
| 4.2 | Focus method option (e.g. VCB) | **… phương thức thanh toán** (e.g. Vietcombank…) |
| 4.3 | Focus account / owner fields | **Số tài khoản thanh toán P2P**, **Tên chủ tài khoản thanh toán P2P** |
| 4.4 | Focus primary form CTA | **Xem trước và thêm phương thức thanh toán P2P** |
| 4.5 | Confirm sheet title (visible) | **Xác nhận thêm phương thức?** |
| 4.6 | Confirm sheet buttons | **Hủy**, **Xác nhận** (button text via shared preview sheet) |

Harness: SC-232 covers steps through the preview CTA label. Sheet confirm uses shared `showVitPreviewConfirmSheet` default button labels (no extra Semantics wrapper beyond CTA button role + child text).

### 5. Security save — `/profile/security` (SC-158)

| Step | Action | Expected spoken cue |
| --- | --- | --- |
| 5.1 | Focus anti-phishing field | **Mã chống lừa đảo** |
| 5.2 | Focus save CTA | **Lưu mã chống lừa đảo** (or **Đang lưu mã chống lừa đảo** while saving) |

Harness: SC-158.

---

## Fail criteria (any P0)

- TalkBack reads an internal screen id as the primary page name (e.g. bare `SC-xxx` without Vietnamese page label).
- Confirm / money CTA announces only a generic English word with no Vietnamese money/security context where D1 required an explicit label (`Xác nhận rút`, `Xác nhận gửi lệnh giao dịch`, `Lưu mã chống lừa đảo`, P2P preview CTA).
- Side switch announces only visible `MUA`/`BÁN` without **Chọn mua** / **Chọn bán**.

## Run log

| Date | Build | Device | Tester | Result | Notes |
| --- | --- | --- | --- | --- | --- |
| 2026-07-25 | Checklist prepared | — | Implementer | Not executed | Docs + D1 harness already green; device TalkBack run still required for release evidence. |

## Related

- D1 Semantics CTA tiền: UI trust polish SDD (Wave A) — labels above.
- Widget harness: `test/quality/accessibility_semantics_critical_flows_test.dart`
- Broader manual QA: `Flutter-Manual-Smoke-Checklist.md`
- Production plan pointer: `ke-hoach-san-sang-production.md` § P1.2
