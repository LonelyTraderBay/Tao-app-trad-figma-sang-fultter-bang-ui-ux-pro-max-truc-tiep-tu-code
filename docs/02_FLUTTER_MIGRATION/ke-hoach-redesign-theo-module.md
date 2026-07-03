# Kế hoạch Redesign UI theo Module — VitTrade (token-lite)

**Version:** 2.1 | **Updated:** 2026-07-03

> **Mục tiêu file này:** ~200 dòng — đủ cho AI biết module/batch. Chi tiết màn hình **không** nhúng ở đây.

| Artifact | Khi nào load |
| --- | --- |
| **File này** (sections 1–4) | Mỗi chat redesign — **1 lần** |
| [ke-hoach-redesign-batches.csv](ke-hoach-redesign-batches.csv) | **1 dòng** = batch đang làm |
| [VitTrade-Screen-Redesign-Checklist.csv](VitTrade-Screen-Redesign-Checklist.csv) | Lọc theo `sc_id` của batch — **không** load cả file vào chat |
| [AI_PROMPT_SHELL.md](../01_AI_RULES/AI_PROMPT_SHELL.md) | Workspace rule — không paste lại |
| [DESIGN.md](../../DESIGN.md) | Workspace rule — không paste lại |
| Headroom MCP (`headroom_compress` / `headroom_retrieve`) | **STEP 4** — log test/analyze/audit >500 dòng |

**Không load vào chat redesign:**

- `VitTrade-Screen-Redesign-Checklist.md` (551 dòng — trùng CSV)
- Phiên bản plan cũ section 6 (1950+ dòng)
- `ke-hoach-redesign-batches.csv` toàn bộ — chỉ 1 row
- Full `home_page.dart` — đọc section hero/layout qua GitNexus `context()`

---

## 1. Quy tắc token (Cursor AI)

1. User chỉ định **`batch_id`** (vd. `RD-M02-B01`, `RD-T02`).
2. Load **section 1–4** file này + **1 row** `ke-hoach-redesign-batches.csv`.
3. Resolve path: lọc checklist CSV theo `sc_ids` (split `;`) — tối đa ~10 dòng/batch.
4. Nếu `special_prompt` có giá trị → load **chỉ file đó** (vd. SC-059).
5. Mirror **SC-007 Home** — **không sửa** `home_page.dart`.
6. **Chat mới** sau mỗi batch. Max **5–10 file** code/batch.
7. Verify (STEP 4): gate theo `AI_PROMPT_SHELL.md` — không lặp lại checklist verify trong chat.

### STEP 4 — Headroom (log tool dài)

Áp dụng **sau implementation**, khi chạy `flutter test`, `flutter analyze`, hoặc `dart run tool/*_audit.dart`:

| Khi | Làm |
| --- | --- |
| Output **≤500 dòng** | Đọc trực tiếp; fix lỗi |
| Output **>500 dòng** | MCP `headroom_compress` → đọc summary |
| Cần dòng lỗi / số dòng cụ thể | `headroom_retrieve` (hash + query) |

**Điều kiện:** MCP `headroom` Connected — `scripts/headroom/Start-VitTradeHeadroom.ps1` (xem [scripts/headroom/README.md](../../scripts/headroom/README.md)).

**Không dùng Headroom cho:** plan/CSV/checklist tĩnh; file `.dart` đang sửa trong batch (rule workspace).

**Không thay GitNexus:** `impact()` / `context()` trước edit; Headroom chỉ cho output lệnh verify.

**Thứ tự redesign:** `RD-M02` → `RD-M23`. **`RD-M01` = reference only.**

**Lấy row batch (PowerShell):**

```powershell
Import-Csv docs/02_FLUTTER_MIGRATION/ke-hoach-redesign-batches.csv |
  Where-Object batch_id -eq 'RD-M02-B01'
```

---

## 2. Home reference — RD-M01 (skip redesign)

| sc | route | page | doc |
| --- | --- | --- | --- |
| `sc007Home` | `/home` | `lib/features/home/presentation/pages/home_page.dart` | [Home standard](../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) |

Mirror: hero → CTA → sections; `AppSpacing`/`AppRadii`/`AppTextStyles`; empty + CTA.

---

## 3. Charter (tóm tắt — chi tiết ở AGENTS/DESIGN/shell)

**North Star:** Tin cậy trước · đơn giản trước · chuyên nghiệp luôn.

**Vit* bắt buộc:** `VitPageLayout`, `VitCard`, `VitHeader`, `VitTabBar`, `VitSegmentedChoice`, `VitCtaButton`, `VitStatusPill`.

**Cấm:** card-in-card · tab trong `VitCard` border · local duplicate Vit* · magic radius · hype/casino · sửa Home.

**Product:** Arena = points only · Predictions ≠ casino · financial = preview/confirm · giữ `sc*` test keys.

**Gate batch:** clutter after ≤4/10 · analyze clean · focused tests pass · ≤3 section above fold (hub).

**STEP 0→5:** explore → audit → spec → code → verify → self-check (`vittrade-minimal-review`).

---

## 4. Module & batch index

### 4.1 Module progress (22 redesign + 1 reference)

| module_id | module | hub_sc | màn | accent | status |
| --- | --- | --- | ---: | --- | --- |
| `RD-M01` | **home** | `sc007Home` | 1 | Global foundation | 🔒 reference |
| `RD-M02` | **auth** | `sc001Login` | 6 | Trust, security, clarity | ⬜ (`RD-M02-B01`) |
| `RD-M03` | **onboarding** | `sc397Onboarding` | 1 | Guided first-run | ⬜ (`RD-M03-B01`) |
| `RD-M04` | **markets** | `sc008MarketList` | 22 | Scan, compare, data | ⬜ (`RD-K01`, `RD-K02`, `RD-K03`, `RD-K04`) |
| `RD-M05` | **trade** | `sc048Trade` | 91 | Action, precision, risk | ⬜ (`RD-T01`, `RD-T02`, `RD-T03`, `RD-T04`, `RD-T05`, `RD-T06`, `RD-T07`, `RD-T08`, `RD-T09`, `RD-T10`, `RD-T11`) |
| `RD-M06` | **wallet** | `sc135Wallet` | 21 | Assets, trust, security | ⬜ (`RD-W01`, `RD-W02`, `RD-W03`, `RD-W04`) |
| `RD-M07` | **profile** | `sc156Profile` | 16 | Account, settings | ⬜ (`RD-F01`, `RD-F02`, `RD-F03`) |
| `RD-M08` | **p2p** | `sc282P2PHome` | 77 | Escrow, compliance UX | ⬜ (`RD-P01`, `RD-P02`, `RD-P03`, `RD-P04`, `RD-P05`, `RD-P06`, `RD-P07`, `RD-P08`, `RD-P09`, `RD-P10`, `RD-P11`) |
| `RD-M09` | **earn** | `sc327StakingEarn` | 70 | Yield + risk transparency | ⬜ (`RD-E01`, `RD-E02`, `RD-E03`, `RD-E04`, `RD-E05`, `RD-E06`, `RD-E07`) |
| `RD-M10` | **dca** | `sc169Dca` | 13 | Disciplined investing | ⬜ (`RD-C01`, `RD-C02`, `RD-C03`) |
| `RD-M11` | **predictions** | `sc027PredictionsHome` | 18 | Probability, not casino | ⬜ (`RD-R01`, `RD-R02`, `RD-R03`) |
| `RD-M12` | **arena** | `sc184ArenaHome` | 26 | Points-only | ⬜ (`RD-A01`, `RD-A02`, `RD-A03`, `RD-A04`, `RD-A05`) |
| `RD-M13` | **launchpad** | `sc295Launchpad` | 24 | IDO participation | ⬜ (`RD-L01`, `RD-L02`, `RD-L03`) |
| `RD-M14` | **discovery** | `sc283UnifiedSearch` | 3 | Discovery | ⬜ (`RD-M14-B01`) |
| `RD-M15` | **news** | `sc047News` | 1 | Information | ⬜ (`RD-M15-B01`) |
| `RD-M16` | **notifications** | `sc291Notifications` | 1 | Actionable alerts | ⬜ (`RD-M16-B01`) |
| `RD-M17` | **referral** | `sc290ReferralHome` | 5 | No hype | ⬜ (`RD-M17-B01`) |
| `RD-M18` | **support** | `sc292HelpCenter` | 3 | Help & trust | ⬜ (`RD-M18-B01`) |
| `RD-M19` | **rewards** | `sc319RewardsHub` | 1 | Rewards hub | ⬜ (`RD-M19-B01`) |
| `RD-M20` | **cross_module** | `sc321UnifiedPortfolio` | 4 | Unified views | ⬜ (`RD-M20-B01`) |
| `RD-M21` | **enterprise_states** | `sc320EnterpriseStates` | 1 | Enterprise states | ⬜ (`RD-M21-B01`) |
| `RD-M22` | **admin** | `sc180AdminHome` | 5 | Ops dashboards | ⬜ (`RD-M22-B01`) |
| `RD-M23` | **dev** | `sc399DesignSystem` | 6 | Design system | ⬜ (`RD-M23-B01`) |

Inventory **416** · redesign scope **415** · batches **66**.

### 4.2 Batch table (chi tiết sc_id → `ke-hoach-redesign-batches.csv`)

| batch_id | module_id | title | sc# | special_prompt | status |
| --- | --- | --- | ---: | --- | --- |
| `RD-M02-B01` | `RD-M02` | auth — all | 6 | - | ⬜ |
| `RD-M03-B01` | `RD-M03` | onboarding — all | 1 | - | ⬜ |
| `RD-K01` | `RD-M04` | Hub & overview | 5 | - | ⬜ |
| `RD-K02` | `RD-M04` | Discovery tools | 6 | - | ⬜ |
| `RD-K03` | `RD-M04` | Depth & sentiment | 8 | - | ⬜ |
| `RD-K04` | `RD-M04` | Pair detail | 3 | - | ⬜ |
| `RD-T01` | `RD-M05` | Hub giao dịch cốt lõi | 9 | - | ⬜ |
| `RD-T02` | `RD-M05` | Hub Trading Bots SC-059 | 1 | prompt-redesign-trading-bots-hub-sc059.md | ⬜ |
| `RD-T03` | `RD-M05` | Bot vận hành & analytics | 14 | - | ⬜ |
| `RD-T04` | `RD-M05` | Bot guide & tax | 4 | - | ⬜ |
| `RD-T05` | `RD-M05` | Copy trading hub | 8 | - | ⬜ |
| `RD-T06` | `RD-M05` | Copy provider & performance | 15 | - | ⬜ |
| `RD-T07` | `RD-M05` | Margin & trader | 5 | - | ⬜ |
| `RD-T08` | `RD-M05` | Tools & analytics | 6 | - | ⬜ |
| `RD-T09` | `RD-M05` | Compliance 1 | 12 | - | ⬜ |
| `RD-T10` | `RD-M05` | Compliance 2 & complaints | 15 | - | ⬜ |
| `RD-T11` | `RD-M05` | Orders & receipts | 2 | - | ⬜ |
| `RD-W01` | `RD-M06` | Hub & assets | 6 | - | ⬜ |
| `RD-W02` | `RD-M06` | Deposit | 3 | - | ⬜ |
| `RD-W03` | `RD-M06` | Withdraw | 5 | - | ⬜ |
| `RD-W04` | `RD-M06` | Transfer & buy | 7 | - | ⬜ |
| `RD-F01` | `RD-M07` | Hub & settings | 8 | - | ⬜ |
| `RD-F02` | `RD-M07` | Security & KYC | 6 | - | ⬜ |
| `RD-F03` | `RD-M07` | API keys | 2 | - | ⬜ |
| `RD-P01` | `RD-M08` | Hub & navigation | 6 | - | ⬜ |
| `RD-P02` | `RD-M08` | Express & orders | 8 | - | ⬜ |
| `RD-P03` | `RD-M08` | Ads & merchant | 9 | - | ⬜ |
| `RD-P04` | `RD-M08` | Payment methods | 6 | - | ⬜ |
| `RD-P05` | `RD-M08` | Insurance & escrow | 9 | - | ⬜ |
| `RD-P06` | `RD-M08` | KYC | 9 | - | ⬜ |
| `RD-P07` | `RD-M08` | Security | 8 | - | ⬜ |
| `RD-P08` | `RD-M08` | Wallet & limits | 6 | - | ⬜ |
| `RD-P09` | `RD-M08` | Compliance & tax | 7 | - | ⬜ |
| `RD-P10` | `RD-M08` | Disputes | 5 | - | ⬜ |
| `RD-P11` | `RD-M08` | Social & settings | 4 | - | ⬜ |
| `RD-E01` | `RD-M09` | Staking entry | 6 | - | ⬜ |
| `RD-E02` | `RD-M09` | Staking ops | 7 | - | ⬜ |
| `RD-E03` | `RD-M09` | Staking legal/risk | 9 | - | ⬜ |
| `RD-E04` | `RD-M09` | Staking compliance | 10 | - | ⬜ |
| `RD-E05` | `RD-M09` | Staking community | 14 | - | ⬜ |
| `RD-E06` | `RD-M09` | Savings entry | 6 | - | ⬜ |
| `RD-E07` | `RD-M09` | Savings tools | 18 | - | ⬜ |
| `RD-C01` | `RD-M10` | Hub & schedule | 5 | - | ⬜ |
| `RD-C02` | `RD-M10` | Rebalance | 4 | - | ⬜ |
| `RD-C03` | `RD-M10` | Optimizer | 4 | - | ⬜ |
| `RD-R01` | `RD-M11` | Hub & discovery | 5 | - | ⬜ |
| `RD-R02` | `RD-M11` | Portfolio & social | 7 | - | ⬜ |
| `RD-R03` | `RD-M11` | Tools | 6 | - | ⬜ |
| `RD-A01` | `RD-M12` | Hub & studio | 6 | - | ⬜ |
| `RD-A02` | `RD-M12` | Challenge flow | 7 | - | ⬜ |
| `RD-A03` | `RD-M12` | Points & ledger | 5 | - | ⬜ |
| `RD-A04` | `RD-M12` | Safety & trust | 5 | - | ⬜ |
| `RD-A05` | `RD-M12` | Production bridges | 3 | - | ⬜ |
| `RD-L01` | `RD-M13` | Hub & portfolio | 4 | - | ⬜ |
| `RD-L02` | `RD-M13` | Participation | 7 | - | ⬜ |
| `RD-L03` | `RD-M13` | Advanced tools | 13 | - | ⬜ |
| `RD-M14-B01` | `RD-M14` | discovery — all | 3 | - | ⬜ |
| `RD-M15-B01` | `RD-M15` | news — all | 1 | - | ⬜ |
| `RD-M16-B01` | `RD-M16` | notifications — all | 1 | - | ⬜ |
| `RD-M17-B01` | `RD-M17` | referral — all | 5 | - | ⬜ |
| `RD-M18-B01` | `RD-M18` | support — all | 3 | - | ⬜ |
| `RD-M19-B01` | `RD-M19` | rewards — all | 1 | - | ⬜ |
| `RD-M20-B01` | `RD-M20` | cross_module — all | 4 | - | ⬜ |
| `RD-M21-B01` | `RD-M21` | enterprise_states — all | 1 | - | ⬜ |
| `RD-M22-B01` | `RD-M22` | admin — all | 5 | - | ⬜ |
| `RD-M23-B01` | `RD-M23` | dev — all | 6 | - | ⬜ |

---

## 5. Prompt mẫu (1 template — thay placeholder)

```text
Batch: <batch_id>  Module: <module_id>

Load:
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (rule)
- docs/02_FLUTTER_MIGRATION/ke-hoach-redesign-theo-module.md §1-4
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows matching sc_ids (batch only)
- <special_prompt file if any>

Mirror SC-007 Home (read-only). Không sửa home_page.dart.
STEP 0→5. Max 5-10 files. New chat next batch.

Completion: MODULE UI REDESIGN DONE — <module_id> — <batch_id>
```

**SC-059:** batch `RD-T02` → load `prompt-redesign-trading-bots-hub-sc059.md`.
Completion: `TRADING BOTS HUB UI REDESIGN DONE — SC-059 v2`.

---

## Regenerate

```bash
python flutter_app/tool/gen_redesign_plan.py
python flutter_app/tool/export_screen_checklist.py
```
