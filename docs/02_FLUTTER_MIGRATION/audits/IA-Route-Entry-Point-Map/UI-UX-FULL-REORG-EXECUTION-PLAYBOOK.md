# UI/UX Full Reorg — Execution Playbook (AI Step Tracker)

Generated: 2026-07-21  
Authority: `AGENTS.md` · `Two-Phase-Cursor-Workflow.md` · this file  
Entry index: [`00-INDEX.md`](./00-INDEX.md)

**Mục tiêu:** Sắp xếp lại navigation + hub composition để user **không bị rỗi / lạc**, tìm được sản phẩm trong ≤3 tap từ entry điểm, mỗi hub có nội dung actionable (không blank/sparse).

**Phạm vi:** Toàn app VitTrade Flutter (`flutter_app/`).  
**Không thuộc phạm vi:** Backend thật, đổi package structure, thêm bottom-nav tab thứ 6 (trừ khi product đổi quyết định).

---

## 0. Cách AI dùng file này (BẮT BUỘC)

### 0.1 Chính sách chat (đã chọn): **cùng một chat, làm tuần tự theo STEP**

User muốn AI **làm theo thứ tự trong cùng một chat**, không bắt buộc 1 chat = 1 STEP.

| Chế độ | Khi nào dùng |
|--------|----------------|
| **A — Same-chat continuum (mặc định)** | Làm `STEP` kế tiếp trong **cùng chat** sau khi STEP trước `done` + tick dashboard + log |
| **B — New chat** | Chỉ khi chạm **hard stop** §0.3 (context bẩn / fail chồng / đổi phase lớn / user yêu cầu) |

**Không** được nhảy STEP (ví dụ P0.1 → P0.5).  
**Không** được mở song song 2 STEP code cùng lúc trên cùng worktree.

### 0.2 Phân tích: cùng chat được không?

| Khía cạnh | Cùng 1 chat (A) | 1 chat / 1 STEP (B) |
|-----------|-----------------|---------------------|
| Tiến độ liên tục | Tốt — AI nhớ quyết định D1–D6, style docs vừa viết | Phải `@` playbook + re-orient mỗi lần |
| Bỏ sót STEP | Thấp nếu **bắt buộc tick checklist** sau mỗi STEP | Thấp nếu user nhớ mở đúng STEP |
| Context Cursor (~40% soft ceiling) | **Rủi ro chính** — chat dài → AI quên rule / hallucinate file | An toàn hơn, tốn công mở chat |
| Docs-only (P0) | **Nên cùng chat** — ít token, cùng family wireframe | Không cần thiết |
| Code batch (P1+) | Cùng chat **được** nếu mỗi STEP vẫn ≤5–10 file + verify xong mới sang STEP sau | Bắt buộc new chat nếu analyze/test fail chồng hoặc đụng >10 file |

**Kết luận phân tích:** Làm tuần tự trong **một chat là được và phù hợp P0 + chuỗi STEP nhỏ**. Vẫn phải giữ **ranh giới STEP** (xong → tick → verify → mới STEP kế). Không biến cả 51 STEP thành một “big bang” không checkpoint.

### 0.3 Quy trình trong cùng chat (mỗi STEP)

1. Đọc đúng `STEP-x.y` đang `pending` / được chỉ định.  
2. Đọc file nguồn STEP liệt kê.  
3. Nếu sửa Dart: GitNexus `impact` trước khi sửa symbol.  
4. Làm **hết** must-do của STEP; không kéo việc của STEP sau vào.  
5. Chạy **verify của STEP**; ghi evidence ngắn.  
6. Tick `[x]` ở checkbox STEP **và** cập nhật §1 Dashboard + §1.1 Log.  
7. **Tự chuyển** sang STEP kế trong playbook (báo user: `Done STEP-… → next STEP-…`) — **không hỏi** “có làm tiếp không?” trừ khi `blocked`.  
8. Model: Cursor **Auto only**.

### 0.4 Soft ceiling (cùng chat vẫn tiếp tục được, nhưng AI phải cảnh báo)

Sau mỗi STEP, nếu **một** điều sau đúng → ghi log `soft_warn` và **đề xuất** new chat (user có thể bảo “cứ tiếp tục”):

- Context / chat đã rất dài (statusline > ~40% nếu có)  
- Vừa xong **cả một phase** (P0.12, P1.6, P2.9, …)  
- Vừa sửa **>8 file Dart** trong STEP  
- Verify có warning lặp lại 2 lần

### 0.5 Hard stop — **phải** dừng chat hiện tại / new chat (không thương lượng)

Dừng continuum, mở chat mới (vẫn bám STEP kế, không nhảy):

1. STEP `blocked` (thiếu quyết định product / conflict)  
2. `flutter analyze` hoặc test **FAIL** và đã thử fix **1 lần** trong chat mà vẫn fail  
3. User bảo rewind / đổi hướng  
4. Bắt đầu **P1 lần đầu** sau P0 (ranh giới docs→code): **khuyến nghị mạnh** new chat; nếu user nói “cùng chat” thì được, nhưng AI nhắc soft_warn  
5. Hai phase code khác nhau trên file chồng chéo (ví dụ P2 Trade + P3 Earn) trong cùng lúc

### 0.6 Giới hạn gộp STEP (tránh bỏ sót)

| Loại | Trong cùng chat | Gộp nhiều STEP? |
|------|-----------------|-----------------|
| Docs-only (P0.2–P0.8) | Có | Được gộp **tối đa 2 STEP hub** liên tiếp nếu cùng template và user không cấm; vẫn tick **từng** STEP |
| Docs matrix/ledgers (P0.9–P0.12) | Có | **Không gộp** — từng STEP |
| Code (P1+) | Có (continuum) | **Không gộp** 2 STEP code; xong verify mới STEP sau |
| Checkpoint STEP (`*.6`, `*.9`, `P0.12`, `P6.5`) | Có | **Không gộp** với STEP khác |

### 0.7 Prompt Execute — continuum (cùng chat)

```text
Làm tuần tự theo playbook (cùng chat được):
@docs/02_FLUTTER_MIGRATION/audits/IA-Route-Entry-Point-Map/UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md

Bắt đầu từ STEP-<id> (hoặc STEP pending đầu tiên).
Chế độ: Same-chat continuum (§0.1 A).

Ràng buộc:
- Làm lần lượt theo thứ tự; không nhảy STEP; không gộp 2 STEP code
- Docs P0: có thể gộp tối đa 2 STEP hub (P0.2–P0.8) nếu cùng template — vẫn tick từng STEP
- Mỗi STEP xong: verify → tick checkbox + §1 Dashboard + §1.1 Log → báo next STEP → tiếp tục
- Hard stop §0.5: dừng và nói rõ lý do
- Soft ceiling §0.4: cảnh báo nhưng tiếp tục nếu user đã chọn continuum
- Auto only; Dart: GitNexus impact trước khi sửa symbol
- P0: không sửa flutter_app/lib (trừ khi STEP ghi rõ)
```

### 0.8 Prompt Execute — một STEP (khi hard stop / user muốn tách)

```text
Thực hiện đúng STEP-<id> trong:
@docs/02_FLUTTER_MIGRATION/audits/IA-Route-Entry-Point-Map/UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md

Ràng buộc: chỉ STEP đó; tick + log; verify; báo next STEP id — chờ chat mới nếu đang ở chế độ tách chat.
```

---

## 1. Progress Dashboard (AI cập nhật sau mỗi STEP)

| Phase | Status | Done / Total STEPs | % |
|-------|--------|-------------------:|--:|
| P0 Spec depth | `done` | 12 / 12 | 100% |
| P1 Home+Profile | `in_progress` | 2 / 6 | 33% |
| P2 Markets+Trade+Wallet | `pending` | 0 / 9 | 0% |
| P3 Earn+P2P | `pending` | 0 / 8 | 0% |
| P4 Discovery | `pending` | 0 / 6 | 0% |
| P5 Density+States | `pending` | 0 / 5 | 0% |
| P6 Wiring+VisualQA | `pending` | 0 / 5 | 0% |
| **TỔNG** | | **14 / 51** | **27%** |

Status values: `pending` · `in_progress` · `blocked` · `done`

### 1.1 Run log (append-only)

| When | STEP | Agent/chat | Result | Evidence (1 dòng) |
|------|------|------------|--------|-------------------|
| 2026-07-21 | P0.1 | continuum | done | INDEX badge DEPTH PARTIAL; Trade terminal wording; pack links; EP-26/27 D5 |
| 2026-07-21 | P0.2 | continuum | done | `18` path→tab full + D1 + reselect/back |
| 2026-07-21 | P0.3 | continuum | done | `19` Markets deep; heatmap/watchlist inbound=no |
| 2026-07-21 | P0.4 | continuum | done | `20` Trade terminal-first + D5 header; no Orders hub-tab |
| 2026-07-21 | P0.5 | continuum | done | `21` Wallet D6 promote history/address-book/health-score |
| 2026-07-21 | P0.6 | continuum | done | `22` Earn 31 GOM in 5 clusters + dual hub |
| 2026-07-21 | P0.7 | continuum | done | `23` P2P ≤3-tap Express/Create/Orders |
| 2026-07-21 | P0.8 | continuum | done | `24` boundary Pred/Arena + `25` auth no-shell |
| 2026-07-21 | P0.9 | continuum | done | `26` 33/33 GIỮ edges + HUB family rules |
| 2026-07-21 | P0.10 | continuum | done | Ledgers RG-01–13, 33 Visual QA, hub contracts |
| 2026-07-21 | P0.11 | continuum | done | Gate D1–D6 locked; DEPTH READY |
| 2026-07-21 | P0.12 | continuum | done | INDEX `SPEC DEPTH READY FOR P1`; P0=done |
| 2026-07-21 | — | continuum | soft_warn | Phase P0 complete → prefer new chat before STEP-P1.1 code |
| 2026-07-21 | P1.1 | continuum | done | Home 4 quick + 4 groups; Support/Referral off; analyze+75 tests PASS |
| 2026-07-21 | P1.2 | continuum | done | News header EP-30; D3 recent under Discovery; D4 ticker kept; 78 tests |
| 2026-07-21 | — | continuum | soft_warn | P1.1+P1.2 code done → prefer new chat before STEP-P1.3 Profile |

### 1.2 Product decisions lockboard (phải chốt trước STEP-P1.1)

| ID | Decision | Default nếu user im lặng | Locked? |
|----|----------|--------------------------|---------|
| D1 | Active-tab secondary products | **A** = highlight Trade (giữ code) | [x] locked 2026-07-21 continuum |
| D2 | KYC trên Profile | **Banner** + row phụ | [x] locked 2026-07-21 continuum |
| D3 | Home “Gần đây” strip | **Giữ** dưới Discovery | [x] locked 2026-07-21 continuum |
| D4 | Home market ticker | **Giữ** (compact) | [x] locked 2026-07-21 continuum |
| D5 | Trade Orders/Positions | **Header actions** (không đổi `/trade` thành hub tab) | [x] locked 2026-07-21 continuum |
| D6 | Wallet tools bị chôn | **Promote 3**: history, address-book, health-score; còn lại overflow | [x] locked 2026-07-21 continuum |

> D1–D6 **đã khóa** (defaults + user khởi động continuum 2026-07-21). STEP-P1.1 được phép sau P0.12.

---

## 2. Definition of Done toàn chương trình

Chương trình **DONE** chỉ khi:

- [ ] Mọi STEP P0–P6 = `done`
- [ ] 196 GIỮ/HUB/GOM có menu home duy nhất + inbound verified hoặc exception có lý do
- [ ] Home không còn 17 quick-action phẳng; có nhóm sản phẩm + Discovery tách
- [ ] Profile có Pháp lý accordion; Support/Referral không còn trên Home quick actions
- [ ] Trade = terminal-first + Orders/Positions header (theo D5)
- [ ] Sparse P0 có fix hoặc exception documented
- [ ] Home+Profile button empty-stubs = 0; hub modules đã sweep
- [ ] 33 GIỮ có Visual QA tier và P0 bottom-nav đã có evidence @360×800
- [ ] `route_coverage` + `navigation_edge` + `flutter analyze` PASS trên branch cuối

---

## 3. PHASE P0 — Làm dày bằng chứng (CHƯA sửa Flutter UI)

**Mục tiêu:** Đưa file `18`–`26` + ledgers lên chuẩn độ sâu gần [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md).  
**Cấm:** Sửa `flutter_app/lib/**` trong P0 (trừ regenerate audit artifacts nếu tool yêu cầu ghi `docs/…/audits/*.md|csv`).

### Chuẩn template mỗi hub wireframe (áp dụng STEP-P0.2 → P0.8)

Mỗi file hub phải có đủ section:

1. Generated date + sources (IA module + production paths)
2. ASCII wireframe @360×800 (hiện tại **và** đề xuất nếu khác)
3. Section order (top→bottom)
4. Menu tree: mọi route **GIỮ + HUB + GOM** thuộc shell (path + page class + phân loại)
5. Current vs proposed table
6. Empty / loading / error rules
7. File mapping (widget file → section)
8. Open decisions (nếu còn)
9. Gaps / reachability notes

---

### STEP-P0.1 — Sửa INDEX + đồng bộ Trade wording

- [x] **Status:** done  

- **Làm gì:**
  1. Cập nhật [`00-INDEX.md`](./00-INDEX.md): thêm section link đủ `18`–`26` + toàn bộ ledger/gate/playbook.
  2. Đổi badge “Evidence pack COMPLETE” → **`FRAME COMPLETE / DEPTH PARTIAL`** cho đến hết P0.
  3. Sửa legend “Trade hub → Lệnh” → **“Trade terminal (Spot) + Orders/Positions secondary”** (khớp `20` + D5).
  4. Link playbook này ở đầu INDEX.
- **Files:** `00-INDEX.md`, (optional) `UI-UX-REORG-MASTER-PLAN.md` trỏ sang playbook này  
- **Verify:** Mọi file trong folder readiness đều có link từ INDEX; không còn mâu thuẫn Trade hub-tab.  
- **Next:** STEP-P0.2

---

### STEP-P0.2 — Làm dày `18-APP-SHELL-BOTTOM-NAV-SPEC.md`

- [x] **Status:** done  

- **Làm gì:** Bổ sung: reselect/back matrix; bảng path→active_tab đầy đủ theo `_activeDestinationForPath`; full-bleed exceptions; header Search/Notifications/News; D1 documented.  
- **Đọc:** `root_routes.dart`, `vit_app_shell.dart`, `vit_bottom_nav.dart`, `visual_qa_route_metadata.dart`  
- **Verify:** Spec có thể trả lời “path X highlight tab nào?” không cần mở code.  
- **Next:** STEP-P0.3

---

### STEP-P0.3 — Làm dày `19-MARKETS-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Template §3 đủ; liệt kê 10 HUB Markets; ghi rõ gap heatmap/watchlist; Discover footer = shortcut only.  
- **Đọc:** `market_list_page.dart`, `market_list_tools.dart`, `03-markets.md`  
- **Verify:** Mỗi HUB Markets có dòng “inbound UI: yes/no + widget”.  
- **Next:** STEP-P0.4

---

### STEP-P0.4 — Làm dày `20-TRADE-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Khóa terminal-first; map product switcher; EP-26/27 header actions (D5); GOM compliance → Profile; file mapping `trade_page` / `trade_product_navigation`.  
- **Verify:** Không còn đề xuất “Trade = Orders tab hub”.  
- **Next:** STEP-P0.5

---

### STEP-P0.5 — Làm dày `21-WALLET-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Section order thật; EP-08/09 dual entry; promote list theo D6; financial preview notes.  
- **Verify:** History không chỉ “buried” — có proposed entry.  
- **Next:** STEP-P0.6

---

### STEP-P0.6 — Làm dày `22-EARN-SAVINGS-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Dual entry EP-15/16/28/29; list **31 GOM** nhóm 5 cluster; hub tile model vs stacked cards; Hub-Content-Contract.  
- **Đọc:** `06-earn.md`, staking/savings pages  
- **Verify:** 31 GOM đều xuất hiện trong tree sheet.  
- **Next:** STEP-P0.7

---

### STEP-P0.7 — Làm dày `23-P2P-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Marketplace vs Công cụ drawer; map ~11 HUB; ghi ẨN flows contextual; insurance → Pháp lý.  
- **Verify:** User path Express / Create offer / My orders rõ ≤3 tap.  
- **Next:** STEP-P0.8

---

### STEP-P0.8 — Làm dày `24` + `25`

- [x] **Status:** done  

- **Làm gì:**  
  - `24`: bảng boundary Predictions vs Arena; Discovery dedup Home/Markets/Profile; canonical portfolio routes.  
  - `25`: auth ngoài shell; flow graph; post-auth `/home`; mock no-guard note.  
- **Verify:** Không mixed wallet/points copy trong Arena wireframe.  
- **Next:** STEP-P0.9

---

### STEP-P0.9 — Làm dày `26-CROSS-SHELL-NAV-EDGE-MATRIX.md`

- [x] **Status:** done  

- **Làm gì:** Bảng đầy đủ mọi **GIỮ** (source, target, nav_kind, back_fallback, active_tab, EP). Rule block cho mọi **HUB** family. GOM canonical homes không trùng.  
- **Verify:** Đếm GIỮ rows = 33 (hoặc giải thích thiếu EP-10/25).  
- **Next:** STEP-P0.10

---

### STEP-P0.10 — Làm dày ledgers usability

- [x] **Status:** done  

- **Làm gì:** Mở rộng từng file tới mức actionable:
  - `Reachability-Gap-Report.md` — bảng gap + exception + owner STEP
  - `Sparse-Screen-Watchlist.md` — đủ 13 P0 + batch id
  - `Hub-Content-Contract.md` — đủ hub Tier-A
  - `State-Coverage-by-Archetype.md` — giữ + ví dụ route
  - `Visual-QA-Route-Manifest.md` — list 33 GIỮ
  - `Button-Wiring-Baseline-Ledger.md` — scope matrix modules
  - `Home-Profile-IA-Delta-Checklist.md` — giữ nguyên + link D2–D4
- **Verify:** Mỗi ledger ≥1 bảng cụ thể, không chỉ 5 dòng trống.  
- **Next:** STEP-P0.11

---

### STEP-P0.11 — Chốt D1–D6 + cập nhật Gate

- [x] **Status:** done  

- **Làm gì:** Hỏi user hoặc áp default §1.2; tick Locked; cập nhật `UI-UX-Pre-Implementation-Gate.md` (DEPTH sau P0.1–P0.10).  
- **Verify:** D1–D6 đều `[x]` Locked.  
- **Next:** STEP-P0.12

---

### STEP-P0.12 — Gate P0 exit + cập nhật Dashboard

- [x] **Status:** done  

- **Làm gì:**  
  1. Đổi INDEX badge → **`SPEC DEPTH READY FOR P1`** (chỉ khi P0.1–P0.11 done).  
  2. Cập nhật §1 Dashboard P0 = `done`.  
  3. Regenerate note: `route_coverage` + `navigation_edge` vẫn PASS.  
- **Cấm vào P1 nếu:** bất kỳ STEP P0 unchecked.  
- **Next:** STEP-P1.1

---

## 4. PHASE P1 — Home + Profile (code)

**Spec chính:** [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) + delta checklist + D1–D6.

### STEP-P1.1 — Home product data / nhóm sản phẩm

- [x] **Status:** done  
- **Files (≤8):** `home_mock_data.dart`, widgets products/quick-actions liên quan, tests home nếu có. Tránh rewrite cả `home_page.dart` trừ khi bắt buộc.  
- **Must-do:**
  1. 4 compact quick actions + sheet “Xem thêm”
  2. Groups: Giao dịch / Pro / Sinh lời / Khám phá
  3. Discovery tách Predictions + Arena
  4. Gỡ Support + Referral khỏi Home quick actions
  5. i18n vi-VN đủ dấu
- **Verify:**
  ```bash
  cd flutter_app
  flutter analyze
  flutter test test/features/home --reporter=compact
  ```
- **Acceptance:** Delta checklist Home items (trừ News/header) = `[x]`  
- **Next:** STEP-P1.2

---

### STEP-P1.2 — Home header News + D3/D4 layout

- [x] **Status:** done  
- **Files:** `home_header.dart`, sections ticker/recent nếu đụng D3/D4, tests.  
- **Must-do:** News EP-30; áp D3/D4 (giữ/bỏ theo lock).  
- **Verify:** analyze + focused home tests; visual spot @360 nếu có test sẵn.  
- **Next:** STEP-P1.3

---

### STEP-P1.3 — Profile section model

- [ ] **Status:** pending  
- **Files:** `profile_page.dart` / `profile_home_menu_actions.dart` / fixtures menu, tests.  
- **Must-do:** Sections: Tài khoản · Bảo mật · Portfolio nâng cao · Giới thiệu · Hỗ trợ · Pháp lý (scaffold); KYC theo D2; Referral + Support vào Profile.  
- **Verify:** analyze + `test/features/profile`  
- **Next:** STEP-P1.4

---

### STEP-P1.4 — Profile Pháp lý accordion (39 GOM)

- [ ] **Status:** pending  
- **Files:** Profile legal UI widgets + navigation tới compliance routes (từ `99` / GOM list).  
- **Must-do:** Search; nhóm Copy / Bots / P2P / Arena / Launchpad; mỗi item `push` route thật.  
- **Verify:** navigation_edge vẫn PASS; ít nhất 1 widget test mở accordion.  
- **Next:** STEP-P1.5

---

### STEP-P1.5 — Home/Profile wiring + IA delta sign-off

- [ ] **Status:** pending  
- **Làm gì:** Grep empty `onPressed`/`onTap` trong home+profile; tick toàn bộ `Home-Profile-IA-Delta-Checklist.md`.  
- **Verify:** empty stubs = 0; checklist 100% `[x]`.  
- **Next:** STEP-P1.6

---

### STEP-P1.6 — Checkpoint P1

- [ ] **Status:** pending  
- **Verify block:**
  ```bash
  cd flutter_app
  dart format --output=none --set-exit-if-changed .
  dart run tool/route_coverage_audit.dart --check
  dart run tool/navigation_edge_audit.dart --check
  flutter analyze
  flutter test test/features/home test/features/profile --reporter=compact
  ```
- **Dashboard:** P1 = `done`  
- **Next:** STEP-P2.1

---

## 5. PHASE P2 — Markets + Trade + Wallet

### STEP-P2.1 — Markets: inbound heatmap + watchlist

- [ ] pending — Spec `19`. Thêm entry UI; không để HUB mồ côi.  
- **Verify:** analyze + markets tests; cập nhật Reachability gap row = closed.

### STEP-P2.2 — Markets: tool strip vs HUB reconcile

- [ ] pending — Chip ẨN vs HUB; Discover footer shortcut-only.

### STEP-P2.3 — Checkpoint Markets

- [ ] pending — route/nav + analyze + markets tests; Hub-Content-Contract Markets.

### STEP-P2.4 — Trade: header Orders + Positions (D5)

- [ ] pending — Spec `20`. Persistent actions → EP-26/27. Không đổi terminal thành tab hub.

### STEP-P2.5 — Trade: product switcher clarity + risk badges

- [ ] pending — Spot/Futures/Margin/Convert/Bot labels vi-VN; badge rủi ro Margin/Bot.

### STEP-P2.6 — Checkpoint Trade

- [ ] pending — analyze + trade tests; Reachability Orders/Positions closed.

### STEP-P2.7 — Wallet: promote tools (D6) + history

- [ ] pending — Spec `21`. Surface history; promote 3 tools.

### STEP-P2.8 — Wallet: deposit/withdraw preview still intact

- [ ] pending — Financial safety; notice sheet; không regress preview/confirm.

### STEP-P2.9 — Checkpoint P2

- [ ] pending — full verify block + Dashboard P2=`done` → P3.1

---

## 6. PHASE P3 — Earn / Savings + P2P

### STEP-P3.1 — Earn hub tile model (không stack rỗng)

- [ ] pending — Spec `22` + Hub-Content-Contract; ≤3 sections above fold.

### STEP-P3.2 — Earn legal sheet (31 GOM)

- [ ] pending — Sheet “Tài liệu & rủi ro” 5 cluster; mọi GOM reachable.

### STEP-P3.3 — Savings tools density

- [ ] pending — Giảm stacked cards; map HUB tools; batch `SAVINGS-TOOLS-DENSITY`.

### STEP-P3.4 — Checkpoint Earn

- [ ] pending — analyze + earn tests; Sparse P0 earn rows updated.

### STEP-P3.5 — P2P marketplace clarity

- [ ] pending — Spec `23`; Express + Create + orders entry rõ.

### STEP-P3.6 — P2P hub drawer (11 HUB tools)

- [ ] pending — Drawer/Công cụ; không nhét 79 route lên home.

### STEP-P3.7 — P2P copy/safety

- [ ] pending — Escrow language; payment-method preview; product-copy tests.

### STEP-P3.8 — Checkpoint P3

- [ ] pending — Dashboard P3=`done` → P4.1

---

## 7. PHASE P4 — Discovery family

### STEP-P4.1 — Predictions home boundary + empty states

- [ ] pending — Spec `24`; wallet/PnL OK.

### STEP-P4.2 — Arena points-only audit + UI

- [ ] pending — Zero wallet/payout/profit copy; points-only.

### STEP-P4.3 — Discovery dedup Home/Markets/Profile

- [ ] pending — Home canonical; others shortcut.

### STEP-P4.4 — Launchpad + Topics + Rewards entry polish

- [ ] pending — Khám phá group consistency.

### STEP-P4.5 — Canonical portfolio / MyArena routes

- [ ] pending — Một canonical + shortcut; cập nhật `26`.

### STEP-P4.6 — Checkpoint P4

- [ ] pending — product_copy + prediction/arena guardrails; P4=`done`

---

## 8. PHASE P5 — Sparse density + states

### STEP-P5.1 — Regenerate density/body audits

- [ ] pending  
  ```bash
  dart run tool/visual_density_risk_audit.dart --check
  dart run tool/body_component_consistency_audit.dart --check
  ```
  Cập nhật `Sparse-Screen-Watchlist.md`.

### STEP-P5.2 — Fix EARN-LEGAL-DENSITY P0 batch

- [ ] pending — 5–10 files; không bỏ safety copy.

### STEP-P5.3 — Fix SAVINGS / ARENA / DCA / PRED P0

- [ ] pending — Theo watchlist; 1 batch hoặc tách nếu >10 files.

### STEP-P5.4 — State widgets trên list hubs thiếu empty/error

- [ ] pending — Theo `State-Coverage-by-Archetype.md`.

### STEP-P5.5 — Checkpoint P5

- [ ] pending — P0 critical = 0 hoặc exception documented; P5=`done`

---

## 9. PHASE P6 — Wiring + Visual QA

### STEP-P6.1 — Button wiring sweep trade+markets+wallet

- [ ] pending — Ledger `broken=0` hoặc legitimate.

### STEP-P6.2 — Button wiring earn+p2p+discovery

- [ ] pending — Tương tự.

### STEP-P6.3 — Expand Visual QA manifest — 5 bottom-nav GIỮ

- [ ] pending — Evidence @360×800.

### STEP-P6.4 — Expand Visual QA — remaining GIỮ

- [ ] pending — Widget/spot theo tier.

### STEP-P6.5 — Final program gate

- [ ] pending — Chạy §2 DoD; INDEX badge → **`UI/UX REORG PROGRAM COMPLETE`**; Dashboard tổng 51/51.

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

---

## 10. Dependency graph (không phá thứ tự)

```text
P0.1 INDEX
  └─ P0.2 Shell 18
       ├─ P0.3 Markets 19
       ├─ P0.4 Trade 20
       ├─ P0.5 Wallet 21
       ├─ P0.6 Earn 22
       ├─ P0.7 P2P 23
       ├─ P0.8 Discovery+Auth 24/25
       └─ P0.9 Nav matrix 26  ◄── needs 19–25
            └─ P0.10 Ledgers
                 └─ P0.11 Lock D1–D6
                      └─ P0.12 Exit
                           └─ P1.1 … P1.6
                                └─ P2 … P6
```

P0.3–P0.8 có thể song song **chỉ docs**, mỗi worktree/chat một file — nhưng **P0.9 phải sau** khi 19–25 đủ sâu.

---

## 11. Risks & stop conditions

| Risk | Stop / mitigation |
|------|-------------------|
| AI sửa Flutter trong P0 | Stop; revert; chỉ docs |
| Batch >10 files | Split STEP |
| Đụng `home_page.dart` không cần thiết | Prefer data/sections; ghi lý do nếu đụng |
| Arena wallet language | Fail product-copy; fix trước merge |
| Bỏ preview withdraw | Fail financial safety; không merge |
| INDEX vẫn nói COMPLETE trong khi P0 chưa xong | P0.1 phải sửa badge |

---

## 12. Related files

| File | Role |
|------|------|
| [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) | Spec P1 |
| [`99-ALL-ROUTES.md`](./99-ALL-ROUTES.md) | Route truth |
| [`UX-Evidence-Matrix.csv`](./UX-Evidence-Matrix.csv) | Per-route UX columns |
| [`UI-UX-Pre-Implementation-Gate.md`](./UI-UX-Pre-Implementation-Gate.md) | Gate summary |
| [`UI-UX-REORG-MASTER-PLAN.md`](./UI-UX-REORG-MASTER-PLAN.md) | Short outline (playbook này = chi tiết) |
| `docs/01_AI_RULES/Two-Phase-Cursor-Workflow.md` | Plan→Execute |

---

## 13. First action for human

1. Review + lock **D1–D6** (§1.2) — hoặc bảo AI dùng defaults.  
2. Mở chat mới, paste Execute prompt, chạy **`STEP-P0.1`**.  
3. Không bắt đầu code Home cho đến **STEP-P0.12** xong.
