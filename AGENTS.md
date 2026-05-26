# AGENTS.md - VitTrade Flutter Enterprise Mono-Repo

**Project:** VitTrade - Enterprise Crypto Trading App  
**Tech Stack:** Flutter, Dart, Riverpod, GoRouter  
**Package Manager:** Flutter/Dart pub  
**Test Framework:** flutter_test  
**Last Updated:** 2026-05-26

Read `docs/00_START_HERE.md` before using long-form design, architecture, or QA
guidance.

## Source Of Truth

- App package: `flutter_app/`
- App source: `flutter_app/lib/`
- Public router import: `flutter_app/lib/app/router/app_router.dart`
- Tests: `flutter_app/test/`
- Generated QA artifacts: `flutter_app/run-artifacts/`

Do not recreate root npm, Vite, React, Tailwind, or web screenshot capture
tooling. The former web baseline is obsolete historical context only.

## Architecture

Use the enterprise Flutter module layout:

```text
flutter_app/lib/
├── app/
├── core/
├── features/
│   └── <feature>/
│       ├── domain/
│       ├── data/
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── controllers/
└── shared/
```

Rules:

- Keep app bootstrap, theme, router facade, and shell composition in `app/`.
- Keep non-UI cross-cutting boundaries in `core/`.
- Keep reusable UI primitives in `shared/`.
- Keep screen widgets under `features/<feature>/presentation/pages/`.
- Put repository contracts and value objects under `domain/`.
- Put mock/remote implementations and Riverpod providers under `data/`.
- Prefer `package:vit_trade_flutter/...` imports across modules.

## Product Boundaries

Prediction Markets and Open Arena must stay separate.

| Boundary | Prediction Markets | Open Arena |
| --- | --- | --- |
| Currency | Wallet balance | Arena Points |
| Performance | PnL / positions | Points pool / completion |
| History | Orders / receipts | Ledger entries |
| Leaderboard | Trading context | Fair play / completion |

Allowed bridges: topic/category, event context, creator discovery,
search/discovery, and profile surfaces with clearly separated sections.

## UI Rules

- Use shared layout primitives before creating local scaffolds:
  `VitAppShell`, `VitPageLayout`, `VitPageContent`, `VitHeader`,
  `VitBottomNav`, `VitCard`, `VitCtaButton`, `VitInput`, and `VitTabBar`.
- Use theme tokens from `flutter_app/lib/app/theme/`.
- Keep dark theme as the active baseline.
- Support phone-first layouts at 360 px and up.
- Include loading, empty, error, offline, submitting, and success states where
  the flow needs them.

## Financial Safety

- Preview and confirm withdrawals, escrow release, security changes, address
  additions, and P2P payment-method changes.
- Show fees, risk, limits, and next steps before high-risk confirmation.
- Mask sensitive account, wallet, email, phone, and address data.
- Arena copy must stay points-only. Do not use payout, wallet, profit, or
  stake-return language for Arena.
- Prediction Markets may use positions, probability, receipt, rewards, and P/L;
  avoid hype or casino language.

## Commands

Run from `flutter_app/`:

```bash
flutter pub get
dart format .
flutter analyze
flutter test --reporter=compact
flutter run
```

Use focused tests for touched modules and full tests for router, shared layout,
repository, or broad structural changes.

## Repo Hygiene

- Do not commit `.idea/`, `*.iml`, logs, `build/`, `.dart_tool/`,
  `flutter_app/tmp/`, `flutter_app/run-artifacts/`, or root `output/`.
- Keep Android, iOS, web, Dart source, tests, and package metadata under
  `flutter_app/`.
- Treat `docs/02_FLUTTER_MIGRATION/` as the retained path for Flutter coverage
  and QA docs, not as a dependency on old React code.
