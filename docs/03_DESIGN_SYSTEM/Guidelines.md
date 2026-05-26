# VitTrade Design Guidelines

Updated: 2026-05-26  
Scope: Flutter-only mobile trading app.

## Product Principles

1. Trust-first: make risk, state, controls, and disclosures clear.
2. Boundary clarity: value/trading surfaces and points-only/social surfaces must
   be visibly and semantically distinct.
3. Clarity over density: optimize for fast scanning and correct decisions.
4. Beginner-first, pro-available: simple defaults with advanced controls nearby.
5. Safety-by-design: risky actions need preview, confirmation, and clear next
   steps.
6. No dark patterns: no FOMO, hype, hidden fees, or casino-like treatment.

## Information Architecture

Primary bottom navigation stays at five tabs unless product docs are updated:

- Home
- Markets
- Trade
- Wallet
- Profile

Do not add separate bottom-nav tabs for Prediction Markets, Open Arena, or P2P
without an explicit IA decision.

## Module Boundaries

Prediction Markets and Open Arena must not merge.

| Area | Prediction Markets | Open Arena |
| --- | --- | --- |
| Currency | Wallet balance | Arena Points |
| Performance | PnL / positions | Points pool / completion |
| History | Orders / receipts | Ledger entries |
| Leaderboard | Trading context | Fair play / completion |

Allowed bridges: topic/category, event context, creator discovery,
search/discovery, and profile sections with clear separation.

## Flutter Visual System

- Use Flutter theme tokens in `flutter_app/lib/app/theme/`.
- Use shared layout/widgets in `flutter_app/lib/shared/`.
- Dark theme is the active baseline.
- Home establishes the global app chrome, neutral surfaces, shared card/CTA
  treatment, and primary brand behavior.
- Module identity is an accent layer only.
- Retired web screenshots are obsolete history and must not drive new native UI.

## Layout Standards

Use Flutter primitives:

- `VitAppShell`
- `VitPageLayout`
- `VitPageContent`
- `VitHeader`
- `VitBottomNav`
- `VitCard`
- `VitCtaButton`
- `VitInput`
- `VitTabBar`
- `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`

Do not build repeated local scaffolds, palettes, spacing systems, or bottom-nav
variants when shared primitives already cover the behavior.

## Financial Safety

High-risk actions require preview/confirm:

- Withdrawals
- Escrow release
- Password/security changes
- Disabling 2FA
- Adding addresses
- Changing P2P payment methods

Show fee/risk/limit breakdowns before confirmation. Mask sensitive wallet,
email, phone, and address data where appropriate.

## Copy Rules

Arena must use points-only language:

- Arena Points
- pool diem
- chot ket qua
- thu thach

Arena must not use wallet, payout USD, profit, or stake-return language.

Prediction Markets may use positions, open orders, probability, event, rewards,
receipt, and P/L. Avoid hype/casino language.

## Verification

For UI changes run:

```bash
cd flutter_app
flutter analyze
flutter test
```

Use emulator/device review when layout, interaction, or visual treatment changes.
