# App Shell & Bottom Nav Spec

Generated: 2026-07-21 · **STEP-P0.2 thickened**  
Sources:
- `flutter_app/lib/app/router/route_groups/root_routes.dart` (`createAppRouter`, `_appShellRoute`)
- `flutter_app/lib/app/router/visual_qa_route_metadata.dart` (`_activeDestinationForPath`)
- `flutter_app/lib/shared/layout/vit_app_shell.dart`
- `flutter_app/lib/shared/layout/vit_bottom_nav.dart`
- Locked **D1** (playbook §1.2): secondary products highlight **Trade**
- [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) — Home/Profile chrome

**Verify rule:** với mọi path trong shell, bảng §3 trả lời được “highlight tab nào?” **không cần mở code**.

---

## 1. Shell model (current = recommended baseline)

```text
GoRouter
├─ topLevelRoutes .......... Auth / Onboarding / maintenance / force-update
│                            (NO VitAppShell, NO bottom nav) → xem file 25
└─ ShellRoute → VitAppShell
   ├─ (optional) VitPhoneFrame khi ShellRenderMode visual QA
   ├─ Status bar time (visual QA frame only — `_visualQaStatusBarTimeForUri`)
   ├─ Child page (feature content)
   └─ VitBottomNav (5 destinations) — có thể auto-hide trên một số path
```

**Decision (locked):** Keep single `ShellRoute` + **5-tab** bottom nav. Do **not** add a 6th tab trong chương trình reorg này.

---

## 2. Bottom Nav destinations (GIỮ)

| Destination | Label UI | `routePath` | EP |
|-------------|----------|-------------|----|
| `home` | Trang chủ | `/home` | EP-01 |
| `markets` | Thị trường | `/markets` | EP-02 |
| `trade` | Giao dịch | `/trade` | EP-03 |
| `wallet` | Ví | `/wallet` | EP-04 |
| `profile` | Tôi | `/profile` | EP-05 |

Chrome: raised center Trade button + active-state dot + unread badge trên Home (`notificationUnreadCountProvider`).

---

## 3. Path → active tab (canonical từ `_activeDestinationForPath`)

Evaluation order mirrors code (first match wins). Default fallback = **Home**.

### 3.1 Explicit Home (before prefix checks)

| Path / pattern | Active tab |
|----------------|------------|
| `/news` | Home |
| `/search` | Home |
| `/notifications` | Home |
| `/topics` | Home |
| `/topic/*` | Home |
| `/support` | Home |
| `/support/*` | Home |

### 3.2 Explicit Trade (before `/markets` / `/trade` prefixes)

| Path / pattern | Active tab | Note |
|----------------|------------|------|
| `/referral`, `/referral/*` | **Trade** | D1 — product lives under Trade highlight; **menu canonical = Profile** (EP-23) |
| `/enterprise-states` | Trade | DEV-adjacent |
| `/unified-portfolio` | Trade | EP-34 menu = Profile nâng cao |
| `/cross-module-analytics` | Trade | |
| `/smart-alerts` | Trade | |
| `/tax-reports` | Trade | |
| `/route-checker`, `/performance-monitor` | Trade | DEV |
| `/dev/*` showcase / design-system / dca-overview | Trade | DEV |
| `/demo/copy-card` | Trade | DEV |
| `/launchpad`, `/launchpad/*` | **Trade** | D1 · EP-19 menu = Home Khám phá |
| `/dca`, `/dca/*` | **Trade** | D1 · EP-18 |
| `/earn`, `/earn/*` | **Trade** | D1 · EP-15/16 |
| `/admin`, `/admin/*` | **Trade** | DEV |
| `/rewards` | **Trade** | D1 · EP-22 |
| `/p2p`, `/p2p/*` | **Trade** | D1 · EP-17 |
| `/arena`, `/arena/*` | **Trade** | D1 · EP-21 |

### 3.3 Prefix families

| Path / pattern | Active tab |
|----------------|------------|
| `/markets*` (`startsWith(markets)`) | **Markets** |
| `/trade*` (`startsWith(trade)`) | **Trade** |
| `/pair/*` | **Markets** |
| `/wallet*` | **Wallet** |
| `/settings/security`, `/settings/security/*` | **Profile** |
| `/profile*` | **Profile** |
| *(everything else in shell)* | **Home** |

### 3.4 Quick lookup examples

| User opens | Highlight |
|------------|-----------|
| `/home` | Home |
| `/search` | Home |
| `/markets/heatmap` | Markets |
| `/pair/BTCUSDT` | Markets |
| `/trade` | Trade |
| `/trade/orders-history` | Trade |
| `/earn/savings` | Trade (D1) |
| `/p2p/my-orders` | Trade (D1) |
| `/arena` | Trade (D1) |
| `/wallet/deposit` | Wallet |
| `/profile/kyc` | Profile |
| `/settings/security` | Profile |
| `/referral` | Trade highlight / Profile menu home |
| `/auth/login` | *(no shell — file 25)* |

---

## 4. D1 — Active-tab secondary products (LOCKED)

| Option | Behavior | Status |
|--------|----------|--------|
| **A (locked)** | earn / p2p / arena / dca / launchpad / rewards / referral* → highlight **Trade** | **Current code + continuum lock 2026-07-21** |
| B (deferred) | Same routes highlight **Home** | Chỉ mở lại nếu product đổi D1 |

**UX implication:** User trên Earn/P2P vẫn thấy tab Giao dịch sáng — đúng với Option A. Menu entry canonical vẫn theo cột Menu UI (Home nhóm sản phẩm / Discovery / Profile), **không** yêu cầu đổi highlight khi đổi menu home.

---

## 5. Reselect / back matrix

| Action | Behavior (current) | Spec note |
|--------|--------------------|-----------|
| Tap tab khác | `context.go(destination.routePath)` — **replace** stack tới root tab | Không `push` |
| Tap lại tab đang active | Cùng `context.go(root)` — về root tab path | Reset về `/home`/`/markets`/… |
| System / Vit back trên child | `goBackOrFallback` → fallback path theo feature (thường root tab hoặc hub) | Chi tiết edge: file `26` |
| Deep link vào secondary (vd `/earn`) | Shell giữ; active = Trade (D1) | Back về Home hoặc Earn parent theo page |
| Gate maintenance / force-update | `topLevelRoutes` — **không** bottom nav | Redirect khi cờ tắt → `/home` |

---

## 6. Bottom nav visibility / auto-hide

| Concern | Behavior |
|---------|----------|
| Default | Bottom nav **visible** |
| Auto-hide | `VitAppShell` lắng nghe scroll metrics khi `_canAutoHideBottomNav` | Path-gated (xem code `vit_app_shell.dart`) |
| Path change | Khi `currentPath` đổi mà nav đang ẩn → **hiện lại** |
| Visual QA frame | `VitPhoneFrame` bọc shell; status bar time từ metadata |

**Full-bleed / no-shell exceptions:** chỉ `topLevelRoutes` (auth, onboarding, maintenance, force-update) — không phải child trong `ShellRoute`. Không dùng “ẩn bottom nav toàn màn” cho hub production trừ khi đã có pattern auto-hide trên path đó.

---

## 7. Global header actions (cross-shell)

| Action | Path | EP | Active tab when open | Canonical chrome |
|--------|------|----|----------------------|------------------|
| Search | `/search` | EP-06 | Home | Home header (+ có thể reuse icon trên Markets) |
| Notifications | `/notifications` | EP-07 | Home | Home header |
| News | `/news` | EP-30 | Home | **Proposed** Home header `[📰]` (file 17) — gap nếu chrome hiện thiếu |

**Deposit / Withdraw dual entry (giữ):** EP-08/09 = Home Hero/Next-action **và** Wallet primary CTAs — không exclusive.

---

## 8. Section order — shell chrome (conceptual @360×800)

```
┌─────────────────────────────────────────────┐
│ (page-owned VitHeader / auto-hide header)   │  ← không thuộc VitAppShell body
├─────────────────────────────────────────────┤
│ Feature child (GoRouter outlet)             │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade▲] [Wallet] [Profile]│  ← VitBottomNav
└─────────────────────────────────────────────┘
```

---

## 9. File mapping

| Concern | File |
|---------|------|
| Router + shell builder | `flutter_app/lib/app/router/route_groups/root_routes.dart` |
| Path → tab | `flutter_app/lib/app/router/visual_qa_route_metadata.dart` |
| Shell chrome / auto-hide | `flutter_app/lib/shared/layout/vit_app_shell.dart` |
| Nav UI + `routePath` | `flutter_app/lib/shared/layout/vit_bottom_nav.dart` |
| Back helper | `flutter_app/lib/core/navigation/back_navigation.dart` |
| Auth / no-shell | [`25-AUTH-ONBOARDING-SHELL-SPEC.md`](./25-AUTH-ONBOARDING-SHELL-SPEC.md) |
| Edge matrix | [`26-CROSS-SHELL-NAV-EDGE-MATRIX.md`](./26-CROSS-SHELL-NAV-EDGE-MATRIX.md) |

---

## 10. Current vs proposed (shell-only)

| Item | Current | Proposed (P1+) |
|------|---------|----------------|
| 5 tabs | Yes | Keep |
| D1 Trade highlight | Yes | Keep (locked) |
| Reselect = `go(root)` | Yes | Keep |
| News on Home header | Partial / gap | Add per file 17 (P1.2) |
| 6th tab | No | Still no |

---

## 11. Empty / loading / error (shell)

| State | Rule |
|-------|------|
| Child loading | Page-owned; shell + bottom nav stay mounted |
| Route error | `VitRouteErrorPage` via GoRouter `errorBuilder` (tiếng Việt) |
| Offline | Page/feature; shell không thay tab mapping |
| Notification badge | Unread count trên Home tab only |

---

## 12. Open decisions

1. ~~D1 A vs B~~ → **Locked A**
2. News icon trên Home header — implement P1 (không block P0)
3. Referral highlight Trade vs menu Profile — **accepted tension** under D1; document in edge matrix

## 13. Gaps / reachability notes

- Spec này **không** liệt kê 196 menu routes — chỉ path→tab. Hub trees ở `19`–`24` + Home/Profile `17`.
- Cross-shell GIỮ edges → STEP-P0.9 file `26`.
- DEV routes dưới Trade highlight vẫn Ẩn menu (file `16`).
