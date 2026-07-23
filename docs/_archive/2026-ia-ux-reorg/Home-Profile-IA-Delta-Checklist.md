# Home / Profile IA Delta Checklist

Generated: 2026-07-21 · Expanded: STEP-P0.10 · Signed off: STEP-P1.5 (2026-07-22)

Wireframe: [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) · Decisions: playbook §1.2.

## Home

- [x] 4 compact quick actions + sheet
- [x] Groups Giao dịch / Pro / Sinh lời / Khám phá
- [x] Discovery separate
- [x] Support + Referral off Home → Profile
- [x] News on header
- [x] **D3** — Home «Gần đây» strip: **Giữ** dưới Discovery ([playbook D3](./UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md#12-product-decisions-lockboard-phải-chốt-trước-step-p11))
- [x] **D4** — Home market ticker: **Giữ** (compact) ([playbook D4](./UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md#12-product-decisions-lockboard-phải-chốt-trước-step-p11))

## Profile

- [x] Sections + Pháp lý accordion (39 GOM, search, 5 nhóm — STEP-P1.4)
- [x] **D2** — KYC trên Profile: **Banner** + row phụ ([playbook D2](./UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md#12-product-decisions-lockboard-phải-chốt-trước-step-p11)) → EP-33 `/profile/kyc`
- [x] Support + Referral under Profile
- [x] Unified portfolio reachable

## Wiring (STEP-P1.5)

- [x] Home empty `onPressed`/`onTap` stubs = 0
- [x] Profile empty `onPressed`/`onTap` stubs = 0

## D1–D6 lock note (STEP-P0.10)

| ID | Decision | Locked | Implication for this checklist |
|----|----------|:------:|--------------------------------|
| **D1** | Active-tab secondary products = highlight **Trade** (Option A) | [x] | Earn/P2P/Arena/… keep Trade tab; Referral menu home still Profile (tension tracked in Reachability RG-12) |
| **D2** | KYC = **Banner** + row phụ | [x] | Profile checklist item above |
| **D3** | Home «Gần đây» = **Giữ** | [x] | Home checklist item above |
| **D4** | Home ticker = **Giữ** (compact) | [x] | Home checklist item above |
| **D5** | Trade Orders/Positions = **header actions** (not hub tabs) | [x] | Out of Home/Profile scope — see Trade wireframe / RG-03/04 |
| **D6** | Wallet promote history + address-book + health-score | [x] | Out of Home/Profile scope — see Wallet wireframe / RG-05–07 |

> **Lock:** D1–D6 locked 2026-07-21 (playbook continuum). Formal tick in Gate = **STEP-P0.11**. Implementation of Home/Profile deltas starts **STEP-P1.1** after P0.12.  
> **P1.5 sign-off:** checklist 100% `[x]` — 2026-07-22 continuum.
