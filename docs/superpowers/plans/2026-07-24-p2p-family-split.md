# P2P Family Split (ADR-012 · A2) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) hoặc `superpowers:executing-plans`. Steps dùng checkbox (`- [ ]`). **Một PR Execute / chat** (Two-Phase). Model: Cursor **Auto** only.

**Goal:** Tách monolith `features/p2p` (~244 Dart / 71 trang) thành `p2p_core` + `p2p_marketplace` + `p2p_orders` + `p2p_account` + `p2p_trust`, giữ nguyên URL `/p2p/*`.

**Architecture:** Kernel leaf `p2p_core` (1 chiều); sibling không import lẫn nhau. Wave-1 **parity Earn:** toàn bộ `P2PRepository` + mock/fixtures provider ở `p2p_core`; sibling chỉ own presentation + domain entities slice + controllers/providers/routes. Tách interface repo theo sibling = **optional wave-1b** (sau PR5) nếu còn bandwidth.

**Tech Stack:** Flutter, Riverpod, GoRouter, VitTrade feature layout, guardrail `module_dependency_cycle_guardrail_test.dart`.

**Spec / ADR:**
- [docs/superpowers/specs/2026-07-24-p2p-family-split-design.md](../specs/2026-07-24-p2p-family-split-design.md)
- [docs/05_ARCHITECTURE/decisions/ADR-012-p2p-family-split.md](../../05_ARCHITECTURE/decisions/ADR-012-p2p-family-split.md)

## Global Constraints

- Không đổi string path trong `p2p_route_ids.dart` / `AppRoutePaths` P2P.
- Copy vi-VN; không thêm chuỗi Anh user-facing.
- Escrow / payment ownership: **không** bỏ preview/confirm.
- `p2p_core` ↛ sibling; sibling ↛ sibling (`maxP2pCoreSiblingEdges = 0`).
- Không commit `main` trực tiếp; mỗi PR squash khi CI xanh.
- GitNexus `impact` trước edit symbol lớn; `detect_changes` trước commit.
- Out of scope: redesign UI, đổi BE behavior, wave-2 tách trust.

---

## File map (target)

```text
flutter_app/lib/features/
  p2p_core/
    domain/entities/          # shared + (tạm) re-export hoặc home cho entities chưa move
    domain/repositories/      # P2PRepository (wave-1)
    data/                     # mock, fail_closed, fixtures, repo provider
    presentation/widgets/     # shared P2P chrome only (nếu có)
  p2p_marketplace/            # pages hub+ads, widgets, controllers, entities slice
  p2p_orders/
  p2p_account/
  p2p_trust/

flutter_app/lib/app/providers/
  p2p_marketplace_controller_providers.dart
  p2p_orders_controller_providers.dart
  p2p_account_controller_providers.dart
  p2p_trust_controller_providers.dart
  # p2p_controller_providers.dart xóa sau khi tách hết

flutter_app/lib/app/router/route_groups/
  p2p_route_ids.dart          # GIỮ
  p2p_marketplace_routes.dart
  p2p_orders_routes.dart
  p2p_account_routes.dart
  p2p_trust_routes.dart
  # p2p_routes.dart xóa sau PR5
```

### Ownership trang

| Package | `presentation/pages/` folders |
| --- | --- |
| marketplace | `hub/`, `ads/` |
| orders | `orders/`, `wallet/` |
| account | `merchant/`, `payment/` |
| trust | `security/`, `dispute/` |

### Repository method → package (providers/UI ownership; repo code stays core wave-1)

**marketplace:** `getHome`, `getExpress`, `getExpressConfirm`, `getDashboard`, `getGuide`, `getSettings`, `getNotificationSettings`, `getTradingLevel`, `getAd*`, `getMyAds`, `getCreateAd`, `getOrderBook`

**orders:** `getOrder*`, `getChat`, `getMyOrders`, `getEscrow*`, `getFundLockHistory`, `getWallet`, `getWalletTransfer`

**account:** `getMerchant*`, `getKyc*`, `getIdentity*`, `getAddressProof`, `getSelfie*`, `getVideo*`, `getPaymentMethod*`

**trust:** `getDispute*`, `getDisputes`, `getInsurance*`, `getContributionHistory`, `getClaimDetail`, `getSecurity*`, `getTwoFactor*`, `getDevice*`, `getAntiPhishing*`, `getLoginHistory`, `getSuspicious*`, `getE2E*`, `getFraud*`, `getLimit*`, `getTransactionLimits`, `getCompliance*`, `getAml*`, `getSourceOfFunds`, `getLargeTransaction*`, `getRisk*`, `getTax*`, `getAchievements`, `getBlacklist*`, `getReviews`, `getReportMerchant`

---

## Verify template (mọi PR)

```powershell
cd flutter_app
dart format --output=none --set-exit-if-changed <touched paths>
flutter analyze <touched packages/files>
flutter test test/quality/module_dependency_cycle_guardrail_test.dart --reporter=compact
# + focused p2p tests for moved screens
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
# regen nếu stale rồi commit CSV
```

---

### Task 0 (PR0): ADR + skeleton `p2p_core` + guardrail

**Files:**
- Keep/update: `docs/05_ARCHITECTURE/decisions/ADR-012-p2p-family-split.md` (status → Đã chốt khi merge)
- Keep: `docs/superpowers/specs/2026-07-24-p2p-family-split-design.md` (status → Approved)
- Create: `flutter_app/lib/features/p2p_core/` skeleton (domain/data barrels tối thiểu)
- Modify: `flutter_app/test/quality/module_dependency_cycle_guardrail_test.dart` — thêm test `p2p_core` leaf giống earn
- **Chưa** xóa `features/p2p`; **chưa** move pages

**Strategy PR0 (minimal ship):**
1. Tạo `p2p_core` với `domain/entities/p2p_errors.dart` + `p2p_shared_entities.dart` **moved** từ `p2p` (hoặc copy+re-export tạm từ old path một PR — ưu tiên **git mv** + fix imports).
2. Update mọi import `features/p2p/domain/entities/p2p_errors` → `features/p2p_core/...`.
3. Guardrail: khi chưa có sibling, edge set rỗng vẫn PASS; khi sibling xuất hiện, core↛sibling = 0.
4. Commit ADR+spec+core skeleton.

- [ ] **Step 1:** Branch `refactor/p2p-family-pr0-core`
- [ ] **Step 2:** Viết test guardrail fail-first nếu cần (copy earn block, đổi tên p2p)
- [ ] **Step 3:** `git mv` shared entity files → `p2p_core`; fix imports (`rg "features/p2p/domain/entities/p2p_(errors|shared)"`)
- [ ] **Step 4:** Analyze + cycle guardrail test PASS
- [ ] **Step 5:** Commit + PR + squash  
  Message: `refactor(p2p): ADR-012 PR0 — skeleton p2p_core + cycle guardrail`

**Done when:** `p2p_core` tồn tại; monolith vẫn chạy app; CI xanh.

---

### Task 1 (PR1): Move `p2p_marketplace`

**Files:**
- Create `features/p2p_marketplace/{domain,data,presentation}/...`
- Move pages: `presentation/pages/hub/*`, `ads/*` (+ widgets/controllers chỉ dùng bởi chúng)
- Move entities: `p2p_home_entities`, `p2p_dashboard_ux_entities`, `p2p_ads_entities` (và deps chỉ marketplace)
- Create `p2p_marketplace_routes.dart`; cắt routes tương ứng khỏi `p2p_routes.dart`
- Create `p2p_marketplace_controller_providers.dart`; chuyển providers marketplace
- Update tests under `test/features/p2p/` → `test/features/p2p_marketplace/` cho page đã move
- `root_routes.dart`: `...p2pMarketplaceRoutes(...), ...p2pRoutes(...)` (p2pRoutes còn phần chưa move)

**Move mechanics:**
```powershell
# Example — adjust paths exactly
git mv flutter_app/lib/features/p2p/presentation/pages/hub flutter_app/lib/features/p2p_marketplace/presentation/pages/hub
git mv flutter_app/lib/features/p2p/presentation/pages/ads flutter_app/lib/features/p2p_marketplace/presentation/pages/ads
```
Rồi `rg` fix `package:vit_trade_flutter/features/p2p/` → marketplace hoặc core.

- [ ] **Step 1:** Branch từ main sau PR0
- [ ] **Step 2:** Tạo cây thư mục sibling + git mv pages/widgets
- [ ] **Step 3:** Move entities slice; import entities từ `p2p_core` khi shared
- [ ] **Step 4:** Split routes + providers; mount marketplace routes **trước** residual `p2pRoutes`
- [ ] **Step 5:** Fix tests imports; chạy focused hub/ads tests
- [ ] **Step 6:** Verify template + regen nav/route nếu stale
- [ ] **Step 7:** PR squash  
  `refactor(p2p): ADR-012 PR1 — tách p2p_marketplace (hub+ads)`

**Done when:** `/p2p`, `/p2p/express`, `/p2p/my-ads`, … resolve từ marketplace package; residual `features/p2p` không còn hub/ads pages.

---

### Task 2 (PR2): Move `p2p_orders`

**High-risk:** escrow / fund lock — **chỉ move**, không đổi UI confirm.

**Move:** `pages/orders/*`, `pages/wallet/*` + widgets/controllers liên quan  
**Entities:** `p2p_orders_entities`, `p2p_escrow_entities`, `p2p_wallet_entities`  
**Providers/routes:** `p2p_orders_*`

- [ ] **Step 1:** Branch + git mv
- [ ] **Step 2:** Fix imports; providers đọc `p2pRepositoryProvider` từ `p2p_core` (như Earn)
- [ ] **Step 3:** Tests orders/escrow/wallet path
- [ ] **Step 4:** Manual checklist: order detail, escrow balance, chat — vẫn preview/confirm nếu có
- [ ] **Step 5:** Verify + PR  
  `refactor(p2p): ADR-012 PR2 — tách p2p_orders (orders+escrow+wallet)`

---

### Task 3 (PR3): Move `p2p_account`

**Move:** `merchant/*`, `payment/*`  
**Entities:** `p2p_merchant_entities`, `p2p_kyc_entities`, `p2p_payments_entities`  
**Financial:** payment ownership / verification — không đổi flow.

- [ ] Same pattern as PR1–2
- [ ] PR message: `refactor(p2p): ADR-012 PR3 — tách p2p_account (merchant+payment)`

---

### Task 4 (PR4): Move `p2p_trust`

**Move:** `security/*`, `dispute/*` (~33 pages)  
**Entities:** `p2p_security_entities`, `p2p_disputes_entities`, `p2p_insurance_entities`, `p2p_compliance_risk_entities`

**Nếu PR quá lớn (CI/context):**  
- **PR4a:** `security/` only → package vẫn `p2p_trust`  
- **PR4b:** `dispute/` (+ insurance pages)  

- [ ] Prefer single PR4 nếu `git diff --stat` < ~300 files; else 4a/4b
- [ ] Message: `refactor(p2p): ADR-012 PR4 — tách p2p_trust (security+dispute)`

---

### Task 5 (PR5): Xóa monolith + dọn

**Files:**
- Delete remaining `features/p2p/**` (không còn page/entity orphan)
- Delete `p2p_routes.dart` nếu empty; `root_routes` chỉ mount 4 sibling routes
- Delete/empty `p2p_controller_providers.dart` nếu đã tách hết
- Update any `export` barrels, docs IA ownership, ADR-012 status **Đã chốt**
- Regenerate: route_coverage, navigation_edge, segment-pill/home/header audits nếu stale
- Update `mock_fixture_baseline` nếu path fixture đổi
- `rg "features/p2p/" flutter_app` → **0 hits** (trừ docs lịch sử / ADR)

- [ ] **Step 1:** `rg` orphan imports
- [ ] **Step 2:** Delete tree; full analyze
- [ ] **Step 3:** `flutter test test/features/p2p_ --reporter=compact` (hoặc từng sibling)
- [ ] **Step 4:** Cycle guardrail + route/nav audits
- [ ] **Step 5:** PR  
  `refactor(p2p): ADR-012 PR5 — xóa monolith features/p2p + dọn audit`

**Definition of Done:** khớp spec § DoD.

---

### Task 6 (optional wave-1b): Tách repository interfaces

Chỉ sau PR5 ổn định:
- `P2PMarketplaceRepository` etc. trong từng sibling **hoặc** core
- Mock implements / delegates
- Không đổi URL/UI

---

## Execution order

```text
PR0 core → PR1 marketplace → PR2 orders → PR3 account → PR4 trust → PR5 delete
```

Không parallel writers trên cùng `p2p_routes.dart` / `p2p_controller_providers.dart` — tuần tự trên `main`.

## Self-check vs spec

| Spec item | Task |
| --- | --- |
| A2 packages | 0–5 |
| URL unchanged | Global + route_ids |
| Cycle guardrail | 0, verified 5 |
| Providers/routes split | 1–4 |
| Delete monolith | 5 |
| Repo split by sibling | Task 6 optional (Earn-parity wave-1) |

---

## Handoff

Plan saved. Options:

1. **Subagent-driven** — implement PR0 rồi review từng task  
2. **Inline Execute** — chat mới: “Execute PR0 theo plan ADR-012”  
3. **Commit docs only** — commit ADR-012 + spec + plan trước, code sau  

**Which approach?**
