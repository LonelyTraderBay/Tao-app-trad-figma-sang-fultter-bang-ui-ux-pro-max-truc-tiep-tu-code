# Auth / Onboarding Shell Spec (EP-35 + gates)

Generated: 2026-07-21 · **STEP-P0.8 part B thickened**  
Nguồn:
- [`02-auth.md`](./02-auth.md) — **1 GIỮ + 6 ẨN** (7 routes auth/onboarding group)
- `flutter_app/lib/app/router/route_groups/auth_routes.dart` — `topLevelRoutes(...)`
- `flutter_app/lib/app/router/route_groups/root_routes.dart` — `createAppRouter` redirect + shell split
- `flutter_app/lib/app/router/route_groups/auth_route_ids.dart` — path constants
- Gates: `UtilityRoutePaths.maintenanceGate` `/maintenance`, `forceUpdateGate` `/force-update` (đăng ký trong `topLevelRoutes`, điều khiển bởi `AppConfig`)
- Shell contrast: [`18-APP-SHELL-BOTTOM-NAV-SPEC.md`](./18-APP-SHELL-BOTTOM-NAV-SPEC.md) — auth **không** có `VitBottomNav`
- Post-auth landing: **`/home`** (EP-01)

**Verify rule:** đọc spec này phải trả lời được (1) auth có nằm trong shell không, (2) graph login→home, (3) mock-era có bắt buộc login không, (4) maintenance/force-update ưu tiên thế nào — **không cần mở code**.

---

## 1. Shell model — Auth **ngoài** `VitAppShell`

```text
GoRouter (createAppRouter)
│
├─ redirect (global)
│  ├─ AppConfig.maintenanceMode     → /maintenance   (trừ khi đã ở đó)
│  ├─ AppConfig.forceUpdateRequired → /force-update  (trừ khi đã ở đó)
│  └─ đang ở gate mà cả 2 cờ tắt    → /home
│
├─ topLevelRoutes(shellRenderMode) .......... KHÔNG VitAppShell, KHÔNG bottom nav
│  ├─ /                    → redirect /home
│  ├─ /auth/login          AuthRouteShell + LoginPage          [GIỮ EP-35]
│  ├─ /auth/register       AuthRouteShell + RegisterPage       [ẨN]
│  ├─ /auth/otp            AuthRouteShell + OtpPage            [ẨN]
│  ├─ /auth/2fa-setup      AuthRouteShell + TwoFASetupPage     [ẨN]
│  ├─ /auth/forgot-password  AuthRouteShell + ForgotPassword   [ẨN]
│  ├─ /auth/reset-password   AuthRouteShell + ResetPassword    [ẨN]
│  ├─ /onboarding          OnboardingFlow                      [ẨN]
│  ├─ /maintenance         MaintenanceGatePage                 [gate]
│  └─ /force-update        ForceUpdateGatePage                 [gate]
│
└─ ShellRoute → VitAppShell + VitBottomNav
   └─ home / markets / trade / wallet / profile / p2p / arena / …
```

**Decision (locked for reorg P0):**  
- Auth + onboarding + kill-switch gates = **top-level only**.  
- Do **not** wrap Login/Register trong `VitAppShell`.  
- Do **not** add bottom nav chrome lên auth screens.

`AuthRouteShell` = khung visual QA / phone frame + auth chrome nội bộ — **không** phải app shell 5 tab.

---

## 2. Route inventory (auth module + gates)

### 2.1 Từ `02-auth.md` (7)

| # | Path | Page / builder | Phân loại | Menu |
|--:|------|----------------|-----------|------|
| 1 | `/auth/login` | `_AuthRouteShell` → `LoginPage` | **GIỮ** | Auth shell (Login) EP-35 |
| 2 | `/auth/register` | → `RegisterPage` | ẨN | Flow |
| 3 | `/auth/otp` | → OTP (`buildOtpPage`) | ẨN | Flow |
| 4 | `/auth/2fa-setup` | → `TwoFASetupPage` | ẨN | Flow |
| 5 | `/auth/forgot-password` | → `ForgotPasswordPage` | ẨN | Flow |
| 6 | `/auth/reset-password` | → `ResetPasswordPage` | ẨN | Flow |
| 7 | `/onboarding` | `OnboardingFlow` | ẨN | Flow |

### 2.2 Top-level gates (cùng `topLevelRoutes`, ngoài bảng 02-auth)

| Path | Page | Role |
|------|------|------|
| `/` | redirect | → `/home` |
| `/maintenance` | `MaintenanceGatePage` | Kill-switch bảo trì |
| `/force-update` | `ForceUpdateGatePage` | Kill-switch bắt buộc cập nhật |

### 2.3 Thống kê auth group

| Phân loại | Số |
|-----------|---:|
| GIỮ | 1 (`/auth/login`) |
| ẨN | 6 |
| Gates (top-level utility) | 2 (+ root redirect) |

---

## 3. Flow graph

### 3.1 Happy path — đăng ký / đăng nhập → Home

```text
                    ┌─────────────┐
                    │ /onboarding │  (ẨN — lần đầu / marketing mock)
                    └──────┬──────┘
                           │ CTA «Bắt đầu» / «Đăng nhập»
                           ▼
              ┌────────────────────────┐
              │ /auth/register  (ẨN)   │──── quên? ──► xem §3.2
              └───────────┬────────────┘
                          │ gửi OTP
                          ▼
              ┌────────────────────────┐
              │ /auth/otp       (ẨN)   │
              └───────────┬────────────┘
                          │ (optional) bật 2FA
                          ▼
              ┌────────────────────────┐
              │ /auth/2fa-setup (ẨN)   │  ← có thể skip trong mock
              └───────────┬────────────┘
                          │
                          ▼
              ┌────────────────────────┐
     ┌───────►│ /auth/login   [GIỮ]    │◄──── logout / session hết (tương lai)
     │        └───────────┬────────────┘
     │                    │ success
     │                    ▼
     │        ┌────────────────────────┐
     │        │ /home          [EP-01] │  ← post-auth landing (trong shell)
     │        └────────────────────────┘
     │
     └── deep link «Đã có tài khoản?» từ register
```

**Post-auth landing (locked):** mọi hoàn tất login / register / OTP / 2FA setup **đi tới `/home`**, không tới `/trade` hay `/wallet` trừ khi query `redirect=` được product chốt sau (P0: mặc định `/home`).

### 3.2 Forgot / reset password

```text
/auth/login
   │ «Quên mật khẩu»
   ▼
/auth/forgot-password  (ẨN)
   │ gửi mã / link
   ▼
/auth/otp              (ẨN — nếu dùng chung OTP)
   │
   ▼
/auth/reset-password   (ẨN)
   │ success
   ▼
/auth/login            [GIỮ]
   │ success
   ▼
/home
```

### 3.3 Gate priority (toàn cục)

```text
Mọi navigation (kể cả /auth/* và /home)
        │
        ▼
maintenanceMode == true  ──────────────► /maintenance
        │ false
        ▼
forceUpdateRequired == true  ──────────► /force-update
        │ false
        ▼
đang đứng /maintenance|/force-update
   và cả 2 cờ false  ──────────────────► /home
        │
        ▼
tiếp tục route bình thường
   (auth top-level HOẶC shell)
```

**Lưu ý:** Khi maintenance/force-update bật, user **không** hoàn tất auth flow trên UI thường — gate thắng. Khi cờ tắt, không nhốt user trên trang gate (redirect `/home`).

---

## 4. ASCII — Auth chrome @360×800 (representative)

### 4.1 Login (GIỮ)

```
┌─────────────────────────────────────────────┐
│                                             │  ← NO bottom nav
│            VitTrade                         │
│         Đăng nhập                           │
├─────────────────────────────────────────────┤
│ Email / SĐT                                 │
│ Mật khẩu                                    │
│ [ Đăng nhập ]                               │
│ Quên mật khẩu?  ·  Tạo tài khoản            │
├─────────────────────────────────────────────┤
│ (không VitBottomNav)                        │
└─────────────────────────────────────────────┘
```

### 4.2 Onboarding (ẨN)

```
┌─────────────────────────────────────────────┐
│  [Bỏ qua]                                   │
│  Carousel giá trị sản phẩm (vi-VN)          │
│  [ Tiếp tục ] / [ Bắt đầu ]                 │
│  → /auth/register hoặc /auth/login          │
└─────────────────────────────────────────────┘
```

### 4.3 Maintenance / Force-update

```
┌─────────────────────────────────────────────┐
│  Bảo trì hệ thống / Cần cập nhật ứng dụng   │
│  Copy vi-VN · CTA hỗ trợ / mở store         │
│  (chặn vào shell cho đến khi cờ tắt / update)│
└─────────────────────────────────────────────┘
```

---

## 5. Current vs proposed (reorg P0)

| Item | Current (production mock) | Proposed (P0 docs / Phase 1) |
|------|---------------------------|------------------------------|
| Auth in shell? | **Không** — `topLevelRoutes` | **Giữ** ngoài shell |
| GIỮ login | `/auth/login` | Giữ EP-35 |
| Post-auth | Thường `/home` | **Khóa** `/home` |
| Auth guard | **Mock-era: có thể boot thẳng `/home`** không qua login | **Document as reality** — không invent fake login wall trong Phase 1 reorg |
| Onboarding | Route tồn tại | ẨN flow; không bottom nav |
| Gates | `AppConfig` + redirect | Giữ; ưu tiên trên auth |
| Menu IA | Auth không vào Home/Profile menu | Giữ — không EP menu trong-app |

---

## 6. Mock-era auth guard note (IMPORTANT)

Giai đoạn mock-UI hiện tại:

- App thường `initialLocation` → **`/home`** (hoặc visual-QA path) **không** bắt buộc session.  
- Các route `/auth/*` vẫn **reachable** (deep link, Visual QA, manual `go`) để thiết kế / regression.  
- **Không** thêm `redirect: mustLogin` giả trong Phase 1 IA reorg — tránh phá Visual QA + route coverage.  
- Khi backend auth thật: thêm guard riêng (ADR / SEC sprint) — ngoài phạm vi P0 wireframe docs.

Spec này **mô tả** graph đúng sản phẩm; implementation guard = việc sau.

---

## 7. Empty / loading / error / submitting (auth forms)

| State | Login / Register / OTP / Reset | Gates |
|-------|--------------------------------|-------|
| **Loading** | Disable CTA; inline progress trên nút | Skeleton / static wait copy |
| **Submitting** | `VitCtaButton` loading; chặn double-submit | N/A |
| **Validation error** | Inline field + `VitBanner` form | — |
| **Auth error** | `showVitNoticeSheet` hoặc banner «Sai mật khẩu / OTP» | — |
| **Success** | Navigate `/home` (hoặc bước OTP tiếp) | Khi cờ tắt → `/home` |
| **Offline** | Banner offline; không spam submit | Gate vẫn hiện (kill-switch) |
| **Empty** | N/A (forms) | N/A |

Financial / security: đổi mật khẩu / 2FA — preview/confirm khi có bước irreversible (AGENTS.md); mock có thể rút gọn nhưng spec giữ chỗ.

---

## 8. File mapping

| File | Responsibility |
|------|----------------|
| `app/router/route_groups/auth_routes.dart` | `topLevelRoutes` — auth + onboarding + gates |
| `app/router/route_groups/auth_route_ids.dart` | Path + sc00x names |
| `app/router/route_groups/root_routes.dart` | `createAppRouter`, global redirect, shell mount |
| `app/router/route_groups/utility_route_ids.dart` | `/maintenance`, `/force-update` constants |
| `features/auth/presentation/pages/login_page.dart` | GIỮ login |
| `features/auth/presentation/pages/register_page.dart` | Register |
| `features/auth/presentation/pages/forgot_password_page.dart` | Forgot |
| `features/auth/presentation/pages/reset_password_page.dart` | Reset |
| `features/auth/presentation/pages/two_fa_setup_page.dart` | 2FA setup |
| OTP builder (`buildOtpPage` / otp page) | OTP step |
| `features/onboarding/presentation/pages/onboarding_flow.dart` | Onboarding |
| `features/enterprise_states/.../maintenance_gate_page.dart` | Maintenance |
| `features/enterprise_states/.../force_update_gate_page.dart` | Force update |
| `AuthRouteShell` (app router / auth shell widget) | Top-level auth chrome + visual QA frame |
| `shared/layout/vit_app_shell.dart` | **Không** dùng cho auth |

---

## 9. Cross-links với shell IA

| From | To | Note |
|------|-----|------|
| Auth success | `/home` | Vào shell; tab Home |
| Profile «Đăng xuất» (tương lai) | `/auth/login` | Top-level |
| Deep link `/auth/login` lúc đang maintenance | `/maintenance` | Redirect thắng |
| File 18 path matrix | `/auth/login` | *(no shell)* |
| File 26 nav edge | Auth edges | source top-level → `/home` |

---

## 10. Open decisions

1. **`redirect=` query sau login:** có hỗ trợ deep-link return (vd. `/wallet/withdraw`) sau mock không? P0: chưa — luôn `/home`.  
2. **Onboarding bắt buộc vs skip:** mock cho skip; product lock sau.  
3. **OTP dùng chung** cho register vs forgot vs 2FA challenge — một page + query `purpose` hay nhiều route? Hiện một `/auth/otp`.  
4. **Force-update vs maintenance đồng thời:** code hiện check maintenance **trước** force-update — giữ thứ tự đó trong spec.  
5. Visual QA: auth pages dùng `AuthRouteShell(renderMode:)` — đảm bảo manifest Visual QA không kỳ vọng bottom nav.

---

## 11. Gaps / reachability notes

| Gap | Severity | Note |
|-----|----------|------|
| Không có real auth guard | **Expected mock** | §6 — không «fix» bằng fake wall P0 |
| Logout → login chưa chuẩn hóa mọi surface | P2 | Khi có session thật |
| English residual trên auth fixtures | P3 | i18n when touch |
| Gate pages ngoài `02-auth.md` count | OK | Documented §2.2 |
| Root `/` → `/home` bypasses onboarding | OK mock | Onboarding deep / first-run flag sau |

---

## 12. GIỮ tree (auth)

```text
AUTH (ngoài shell)
├─ [GIỮ] LoginPage → /auth/login (EP-35)
│  ├─ → Register (/auth/register) [ẨN]
│  ├─ → Forgot (/auth/forgot-password) [ẨN]
│  ├─ → OTP (/auth/otp) [ẨN]
│  ├─ → 2FA setup (/auth/2fa-setup) [ẨN]
│  ├─ → Reset (/auth/reset-password) [ẨN]
│  └─ success → /home [shell EP-01]
├─ [ẨN] OnboardingFlow → /onboarding → login/register
└─ [GATES] /maintenance · /force-update  (AppConfig kill-switch)
```

**Verify:** Auth ngoài shell — §1.  
**Verify:** Post-auth `/home` — §3.1.  
**Verify:** Mock no-guard — §6.  
**Verify:** Gate priority maintenance → force-update → clear → home — §3.3.
