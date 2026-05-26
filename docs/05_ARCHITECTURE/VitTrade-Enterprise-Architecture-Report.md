# VitTrade Enterprise Architecture Report

Updated: 2026-05-26  
Status: Flutter-only architecture summary.

The former web migration architecture report was replaced after the Flutter-only
cleanup. `flutter_app/` is now the source of truth for app architecture,
routing, repositories, theme, and tests.

## Active Architecture

| Area | Location |
| --- | --- |
| App entry | `flutter_app/lib/main.dart` |
| App shell | `flutter_app/lib/app/vit_trade_app.dart` |
| Routing | `flutter_app/lib/app/router/app_router.dart` |
| Theme | `flutter_app/lib/app/theme/` |
| Feature modules | `flutter_app/lib/features/` |
| Shared layout/widgets | `flutter_app/lib/shared/` |
| Tests | `flutter_app/test/` |

## Platform Targets

- Android
- iOS
- Web target under `flutter_app/web/` when needed

## Module Inventory

| Module | Role |
| --- | --- |
| auth | Login, registration, OTP, 2FA, password reset |
| home | Primary dashboard and module discovery |
| markets | Market lists, details, charts, alerts, analytics |
| trade | Spot/margin/futures, copy trading, bots, compliance |
| wallet | Deposits, withdrawals, transfers, portfolio surfaces |
| p2p | Marketplace, order room, KYC/risk, escrow concepts |
| predictions | Wallet/value prediction-market surfaces |
| arena | Points-only creator and challenge surfaces |
| earn | Savings, staking, risk, reporting, governance surfaces |
| launchpad | Token-sale, bridge, contract, portfolio surfaces |
| dca | DCA plans, schedules, analytics, rebalancing |
| profile | Settings, security, KYC, API management |
| support/referral/rewards/news/notifications | Supporting user journeys |
| admin/dev/cross-module | Internal, diagnostic, and aggregate surfaces |

## Architecture Rules

- Feature data access goes through repositories and mock implementations until
  real backend contracts are confirmed.
- Navigation uses GoRouter and named route helpers from the Flutter router.
- Shared visual behavior belongs in `shared/layout`, `shared/widgets`, and
  `app/theme`.
- Domain boundaries must remain explicit, especially Prediction Markets
  wallet/value behavior vs Open Arena points-only behavior.

## Verification

Run from `flutter_app/`:

```bash
flutter analyze
flutter test
```
