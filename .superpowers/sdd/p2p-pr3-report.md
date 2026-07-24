# P2P PR3 Report — tách `p2p_account` (merchant + payment / KYC)

**Status:** DONE_WITH_CONCERNS  
**Branch:** `refactor/p2p-family-pr3-account`  
**Base HEAD before work:** `2acfefcb`  
**Commit:** `d8676bbda486f7e959a2a90d000367c20fad4d1a`

## What shipped

- Created `features/p2p_account/` with `domain/`, `data/`, `presentation/` (empty layers via `.gitkeep`).
- `git mv` pages `merchant/` + `payment/` and widgets `merchant/` + `payment/` into `p2p_account`.
- Moved KYC address-proof page from residual `pages/security/` → `p2p_account/.../pages/merchant/` (parts → `widgets/merchant/`).
- Split routes → `p2p_account_routes.dart` (merchant/KYC/payment only). Residual keeps report-merchant + reviews + security/dispute.
- Mount order in `root_routes.dart`: marketplace → orders → **account** → residual `p2pRoutes`.
- Split providers → `p2p_account_controller_providers.dart`; residual facade **re-exports** account providers.
- Kept in residual until PR4: `p2pReportMerchantProvider`, `p2pReviewsProvider` (+ pages/routes).
- Moved 14 account page tests → `test/features/p2p_account/`.
- Fixed imports across lib/test + i18n baseline / product-copy / high-risk path strings.
- Regenerated Static CI audits (incl. page_rhythm screen rollup + coverage matrix + home-ref `'p2p_account': 0`).

## High-risk financial surfaces

Payment method ownership / verification / cooling: **MOVE ONLY** — no preview/confirm UX or copy changes.

## Entity deferral (Earn-aligned wave-1)

**Did NOT** move `p2p_merchant_entities` / `p2p_kyc_entities` / `p2p_payments_entities` out of residual `features/p2p` monolith part library.

Account pages keep reading entities via residual `p2p` controller / shared imports. Moving entity slices while `P2PRepository` + mock remain in residual `p2p` would force `p2p → p2p_account` (or core→sibling) and risk a temporary cycle.

**Carry-forward:** move entity slices when repository lands in `p2p_core` (later PR / wave-1 completion).

## Cycle notes

- Residual `features/p2p` does **not** import `p2p_account`.
- Account pages still import residual helpers (`p2p_formatters`) and `VitP2PFlowScaffold` from `p2p_core` (one-way, OK).
- No shared chrome needed to move to `p2p_core` this PR.

## Verify evidence

| Check | Result |
| --- | --- |
| `Test-Path .../p2p/.../pages/merchant` | False |
| `Test-Path .../p2p/.../pages/payment` | False |
| Report/reviews still residual | True |
| `flutter analyze` (account/p2p/p2p_core/marketplace/orders/router/providers) | No issues |
| `module_dependency_cycle_guardrail_test` | PASS (`p2p_core` leaf) |
| `architecture_layer_boundary_guardrails_test` | PASS |
| `flutter test test/features/p2p_account` | All passed (64) |
| All brief audit `--check` gates (home-ref incl. `p2p_account: 0`, page-rhythm rollup/matrix, card/segment/token/header/nav/route, …) | PASS |
| `dart format` (touched Dart paths) | PASS |

## GitNexus

- `impact(p2pRoutes)` pre-edit: LOW (direct: root_routes).
- `detect_changes(scope: all)` before commit: risk **low**; index sparse for renames — proceeded carefully.

## Concerns / carry-forward

1. Entity part-files still in residual `p2p` (see above).
2. Account still imports residual `p2p` presentation helpers — temporary until shared chrome / trust split.
3. Residual security/dispute (+ report/reviews) remain until PR4–PR5.
4. Full-tree `dart format .` hits a Windows `build/` PathNotFound flake; verified format on touched paths instead.
5. GitNexus index stale for moved paths until refresh.
6. Report Commit field may lag one amend SHA if re-amended after write (verify with `git rev-parse HEAD`).
