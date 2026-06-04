# VitTrade Dark Professional Flow Implementation Tracking

Generated: 2026-06-02

This tracker converts
`VitTrade-Dark-Professional-Super-App-Flow-Architecture.md` into ordered
implementation work. The architecture and reorder matrix are document-complete;
this file tracks code completion against the same P0/P1/P2 acceptance signals.

## Baseline

| Item | Status | Evidence |
| --- | --- | --- |
| Route inventory coverage | Done | `VitTrade-Product-Capability-Inventory.md` covers 19 product areas, 33 capabilities, 104 flows, and 414 routed screens. |
| Flow architecture coverage | Done | `VitTrade-Dark-Professional-Super-App-Flow-Architecture.md` maps 104 / 104 flows and 414 / 414 screens. |
| Route graph guardrail | Done | Run `dart run tool/route_coverage_audit.dart --check` from `flutter_app/`. |
| Navigation edge guardrail | Done | Run `dart run tool/navigation_edge_audit.dart --check` from `flutter_app/`. |

## Ordered Implementation Passes

| Order | Priority | Workstream | Status | Acceptance Signal |
| ---: | --- | --- | --- | --- |
| 1 | P0 | Product hub IA | Done | Home, Trade, and Profile expose product entry points in the target order with visible state chips, recent/next actions where applicable, and no hidden major product. |
| 2 | P0 | High-risk flow state contracts | Done | Trading, Wallet, P2P, Margin, Earn, Launchpad, Copy, Bots, and Prediction Markets expose setup, preview, confirm, receipt/status, manage/history, and support states through shared contract + screen/repository binding metadata. |
| 3 | P0 | Contextual support | Done | Withdrawal, P2P, KYC, staking, launchpad, security, and order flows open support with product context and case timeline. |
| 4 | P1 | Dynamic route explainability | Done | Route-bearing data uses typed intent contracts and human-readable flow maps for P2P, Earn, Launchpad, Discovery, and cross-module surfaces. |
| 5 | P1 | Dark professional interaction polish | Done | High-risk pages use shared loading, empty, error, offline, submitting, success, and risk-state primitives. |
| 6 | P2 | Admin/dev gating | Done | Internal operations and QA surfaces are inaccessible from customer IA unless explicitly gated. |

## P0-01 Product Hub IA

| Surface | Status | Current Work | Required Next Check |
| --- | --- | --- | --- |
| Home quick actions | Done | Reordered around spot/convert, margin, bots, copy, DCA, wallet, P2P, Earn, Launchpad, Predictions, Arena, Rewards, and Support. Added visible state chips for the first product scan. | Verified by Home controller/page tests, route coverage audit, navigation edge audit, `flutter analyze`, and visual harness screenshot `flutter_app/run-artifacts/flow-implementation/home-product-hub.png`. |
| Trade product hub | Done | Trade quick nav is now a product hub ordered around spot, convert, futures, margin, bots, copy, DCA, wallet, P2P, Earn, Launchpad, Predictions, Arena, Rewards, and Support, with visible state chips. | Verified by `flutter_app/test/features/trade/trade_page_test.dart`. |
| Profile product hub | Done | Profile snapshot now exposes customer-safe product shortcuts for wallet, P2P, Earn, Launchpad, bots, copy, support, and referral; admin/dev routes stay out of the customer hub. | Verified by `flutter_app/test/features/profile/profile_page_test.dart`. |
| Recents and next action | Done | Home snapshot now includes `HomeNextAction` and `HomeRecentProduct` contracts; Home renders a next-action card and recent product strip before the full product grid. | Verified by `flutter_app/test/features/home/home_controller_test.dart` and `flutter_app/test/features/home/home_page_test.dart`. |

## P0-02 High-Risk Flow State Contracts

Required contract:

```text
entry
  -> eligibility_check
  -> setup_or_configuration
  -> risk_and_fee_preview
  -> explicit_confirmation
  -> submitted_state
  -> receipt_or_status_detail
  -> manage_or_history
  -> support_or_recovery
```

| Product | Status | First Files To Audit |
| --- | --- | --- |
| Trading / Margin | Done | `flutter_app/lib/features/trade/` owns spot, futures, margin, bots, and copy surfaces. Shared contract: `flutter_app/lib/core/product_flow/high_risk_flow_contract.dart`; binding source: `flutter_app/lib/core/product_flow/high_risk_flow_binding.dart`; repository metadata: `TradeScreenSnapshot`, `TradeOrderReceiptSnapshot`, `TradeFuturesSnapshot`, `TradeMarginTradingSnapshot`, `TradeBotsSnapshot`, and `TradeCopyTradingSnapshot`. |
| Wallet | Done | `flutter_app/lib/features/wallet/`; contract covers limits, setup, preview, confirmation, submitted state, transaction detail, history, and support. Repository metadata: `WalletWithdrawLimitsSnapshot` and `WalletWithdrawSnapshot`. |
| P2P | Done | `flutter_app/lib/features/p2p/`; contract covers KYC/payment readiness, express setup, escrow preview, order status, timeline, my orders, and dispute recovery. Repository metadata: `P2PHomeSnapshot`, `P2PExpressConfirmSnapshot`, `P2POrderTimelineSnapshot`, `P2POrderSnapshot`, and `P2PClaimDetailSnapshot`. |
| Earn / Savings | Done | `flutter_app/lib/features/earn/`; contract covers terms/risk, validator setup, risk assessment, history, dashboard, and support. Repository metadata: `StakingEarnSnapshot`. |
| Launchpad | Done | `flutter_app/lib/features/launchpad/`; contract covers eligibility, IDO bridge, contract preview, receipt, bridge order, claim receipt, portfolio, and support. Repository metadata: `LaunchpadBridgeOrderSnapshot`. |
| Copy Trading | Done | `flutter_app/lib/features/trade/`; contract covers education, provider configuration, costs, confirmation, active copy, audit log, and dispute recovery. Repository metadata: `TradeCopyTradingSnapshot`. |
| Trading Bots | Done | `flutter_app/lib/features/trade/`; contract covers suitability, backtesting, risk dashboard, security settings, portfolio dashboard, history, and emergency support. Repository metadata: `TradeBotsSnapshot`. |
| Prediction Markets | Done | `flutter_app/lib/features/predictions/`; contract covers event setup, risk calculator, advanced chart preview, receipt, portfolio, and support. Repository metadata: `PredictionHomeSnapshot`, `PredictionEventDetailSnapshot`, and `PredictionOrderReceiptSnapshot`. |

Guardrail tests:

- `flutter_app/test/core/product_flow/high_risk_flow_contract_test.dart`
- `flutter_app/test/core/product_flow/high_risk_flow_binding_test.dart`

Done: the contract registry is bound to actual route, screen, repository method,
snapshot type, and `highRiskContractId` metadata so UI, QA, and support context
can consume the same source of truth.

## Verification Commands

Run from `flutter_app/` after each completed workstream:

```bash
dart format .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

For layout or navigation changes, also validate in emulator and save artifacts
under `flutter_app/run-artifacts/`.

## P0-03 Contextual Support

| Flow | Status | Contract Source | UI Status |
| --- | --- | --- | --- |
| Withdrawal | Done | `flutter_app/lib/core/product_flow/contextual_support_contract.dart` | `WithdrawPage` and wallet transaction detail open `/support?flow=withdrawal...` with reference/source context. |
| P2P order / dispute | Done | `flutter_app/lib/core/product_flow/contextual_support_contract.dart` | P2P guide emergency support and insurance claim detail open `/support?flow=p2p_order...` with case/order context. |
| KYC | Done | `flutter_app/lib/core/product_flow/contextual_support_contract.dart` | P2P KYC requirements, status, and selfie verification support open `/support?flow=kyc...`. |
| Staking / Earn | Done | `flutter_app/lib/core/product_flow/contextual_support_contract.dart` | Savings FAQ and Staking FAQ support actions open `/support?flow=staking...`. |
| Launchpad | Done | `flutter_app/lib/core/product_flow/contextual_support_contract.dart` | Launchpad bridge order support opens `/support?flow=launchpad...` with tx context. |
| Security | Done | `flutter_app/lib/core/product_flow/contextual_support_contract.dart` | Profile security support opens `/support?flow=security...` with account context. |
| Trading order | Done | `flutter_app/lib/core/product_flow/contextual_support_contract.dart` | Trade order receipt support opens `/support?flow=order...` with order id context. |

Guardrail tests:

- `flutter_app/test/core/product_flow/contextual_support_contract_test.dart`
- `flutter_app/test/features/support/support_page_test.dart`
- `flutter_app/test/features/wallet/withdraw_page_test.dart`
- `flutter_app/test/features/wallet/transaction_detail_page_test.dart`
- `flutter_app/test/features/p2p/p2p_kyc_requirements_page_test.dart`
- `flutter_app/test/features/p2p/p2p_kyc_status_page_test.dart`
- `flutter_app/test/features/p2p/p2p_selfie_verification_page_test.dart`
- `flutter_app/test/features/p2p/p2p_guide_page_test.dart`
- `flutter_app/test/features/p2p/p2p_claim_detail_page_test.dart`
- `flutter_app/test/features/earn/savings_faq_page_test.dart`
- `flutter_app/test/features/earn/staking_faq_page_test.dart`
- `flutter_app/test/features/launchpad/launchpad_bridge_order_page_test.dart`
- `flutter_app/test/features/profile/security_page_test.dart`
- `flutter_app/test/features/trade/order_receipt_page_test.dart`

Visual harness evidence:

- `flutter_app/run-artifacts/flow-implementation/support-context-withdrawal.png`

## P1-01 Dynamic Route Explainability

| Scope | Status | Evidence |
| --- | --- | --- |
| P2P, Earn, Launchpad, Discovery, Cross-module | Done | `flutter_app/lib/core/navigation/navigation_intent_contract.dart` defines typed route intent contracts, lifecycle stages, sample route resolution, allowed query keys, and human-readable flow map lines. |
| Router path validation | Done | `flutter_app/test/app/router/dynamic_navigation_route_contract_test.dart` verifies route-bearing data resolves to router paths and exposes human-readable maps. |
| Navigation intent unit coverage | Done | `flutter_app/test/core/navigation/navigation_intent_test.dart` verifies dynamic route contract matching and typed route resolution. |

Verification:

- `flutter test test/core/navigation/navigation_intent_test.dart test/app/router/dynamic_navigation_route_contract_test.dart --reporter=expanded`

## P1-02 Dark Professional Interaction Polish

| Scope | Status | Evidence |
| --- | --- | --- |
| Shared high-risk state primitive | Done | `flutter_app/lib/shared/widgets/vit_high_risk_state_panel.dart` covers loading, empty, error, offline, submitting, success, and risk review states using shared dark UI primitives. |
| Representative high-risk page binding | Done | Trade, Withdraw, P2P Home, Staking Earn, Launchpad Bridge Order, Prediction Home, Prediction Event Detail, and Prediction Receipt include `VitHighRiskStatePanel` with `highRiskContractId`. |
| Guardrail coverage | Done | `flutter_app/test/quality/high_risk_state_primitives_guardrail_test.dart` prevents representative high-risk pages from dropping the shared state primitive. |

Verification:

- `flutter test test/features/trade/trade_page_test.dart test/features/wallet/withdraw_page_test.dart test/shared/widgets/vit_high_risk_state_panel_test.dart test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=expanded`
- `flutter test test/features/p2p/p2p_home_page_test.dart test/features/earn/staking_earn_page_test.dart test/features/launchpad/launchpad_bridge_order_page_test.dart test/features/predictions/predictions_home_page_test.dart test/features/predictions/prediction_event_detail_page_test.dart test/features/predictions/prediction_order_receipt_page_test.dart test/shared/widgets/vit_high_risk_state_panel_test.dart test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact`

## P2-01 Admin / Dev / QA Gating

| Scope | Status | Evidence |
| --- | --- | --- |
| Internal surface policy | Done | `flutter_app/lib/app/router/internal_surface_gate.dart` closes internal routes in release/customer builds unless `VIT_INTERNAL_SURFACES_ENABLED=true` is explicitly supplied. |
| Admin routes | Done | `flutter_app/lib/app/router/route_groups/admin_routes.dart` wraps Admin Home, Analytics, A/B Tests, Funnels, and Settings with `InternalSurfaceGate`. |
| Developer and QA routes | Done | `flutter_app/lib/app/router/route_groups/utility_routes.dart` wraps Route Checker, Performance Monitor, Showcase, Design System, DCA Overview Demo, and Copy Card Demo with `InternalSurfaceGate`. |
| Customer IA guardrail | Done | `flutter_app/test/quality/internal_surface_guardrails_test.dart` checks route groups stay gated and Home/Profile IA fixtures do not expose `/admin`, `/dev`, or `/demo` route namespaces. |

Verification:

- `flutter test test/app/router/internal_surface_gate_test.dart test/quality/internal_surface_guardrails_test.dart test/features/admin test/features/dev test/features/dca/dca_overview_demo_test.dart test/features/trade/copy_trading_card_demo_test.dart test/app/router/critical_navigation_back_behavior_test.dart --reporter=expanded`

## Final Verification Snapshot

Run from `flutter_app/` on 2026-06-02:

- `dart format lib/app/router/app_router.dart lib/app/router/internal_surface_gate.dart lib/app/router/route_groups/admin_routes.dart lib/app/router/route_groups/utility_routes.dart test/app/router/internal_surface_gate_test.dart test/quality/internal_surface_guardrails_test.dart`
- `flutter analyze`
- `dart run tool/route_coverage_audit.dart --check`
- `dart run tool/navigation_edge_audit.dart --check`
- `flutter test --reporter=compact`

Result: all checks passed. Full test suite passed with 1919 tests. The suite
emitted one non-fatal hit-test warning in
`test/features/wallet/wallet_page_test.dart` while tapping
`sc135_wallet_tab_chart`; no test failed.
