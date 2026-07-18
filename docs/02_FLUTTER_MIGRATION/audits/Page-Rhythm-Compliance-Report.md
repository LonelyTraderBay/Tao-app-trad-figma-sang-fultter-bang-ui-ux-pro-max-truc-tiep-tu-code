# Page Rhythm Compliance Report

Generated: 2026-07-18

Source: `VitTrade-Page-Rhythm-Screen-Compliance.csv`

## Summary

Screen rollup: 415 real_page routes, L1 pass 405, L2 pass 405 warn 0, unknown 10, documented exceptions 1.
| Level | Meaning |
| --- | --- |
| L1 | Wiring: rhythm, orphan gaps, nested VPC |
| L2 | Structural: direct children, tab-root tier |
| L3 | Visual parity (tab-root + representative QA) |

## Tab roots

| Screen | Route | L1 | L2 | L3 |
| --- | --- | --- | --- | --- |
| AppRouteNames.sc049TradePair | `'/trade/:pairId'` | pass | pass | pass |
| AppRouteNames.sc007Home | `AppRoutePaths.home` | pass | pass | pass |
| AppRouteNames.sc027PredictionsHome | `AppRoutePaths.marketsPredictions` | pass | pass | pass |
| AppRouteNames.sc156Profile | `AppRoutePaths.profile` | pass | pass | pass |
| AppRouteNames.sc048Trade | `AppRoutePaths.trade` | pass | pass | pass |
| AppRouteNames.sc135Wallet | `AppRoutePaths.wallet` | pass | pass | pass |

## L2 warn routes

| Screen | Page | Notes |
| --- | --- | --- |

## Unknown / unmapped routes

| Screen | Page | Pattern |
| --- | --- | --- |
| AppRouteNames.sc140WithdrawUsdt | `WithdrawPage` | shared_shell |
| AppRouteNames.sc401CopyTradingCardDemo | `InternalSurfaceGate` | direct_vpc |
| AppRouteNames.sc399DesignSystem | `InternalSurfaceGate` | direct_vpc |
| AppRouteNames.sc398MissingScreensShowcase | `InternalSurfaceGate` | direct_vpc |
| AppRouteNames.sc326PerformanceMonitor | `InternalSurfaceGate` | direct_vpc |
| AppRouteNames.sc325RouteChecker | `InternalSurfaceGate` | direct_vpc |
| AppRouteNames.sc411ClientOptUpRequest | `ClientOptUpRequestPage` | direct_vpc |
| AppRouteNames.sc145BuyCrypto | `BuyCryptoPage` | shared_shell |
| AppRouteNames.sc146Transfer | `TransferPage` | shared_shell |
| AppRouteNames.sc139Withdraw | `WithdrawPage` | shared_shell |

## By module

### admin (5 routes, L2 warn 0, unknown 0)

### arena (26 routes, L2 warn 0, unknown 0)

### auth (6 routes, L2 warn 0, unknown 0)

### cross_module (4 routes, L2 warn 0, unknown 0)

### dca (14 routes, L2 warn 0, unknown 0)

### dev (4 routes, L2 warn 0, unknown 4)

### discovery (3 routes, L2 warn 0, unknown 0)

### earn (70 routes, L2 warn 0, unknown 0)

### enterprise_states (3 routes, L2 warn 0, unknown 0)

### home (1 routes, L2 warn 0, unknown 0)

### launchpad (24 routes, L2 warn 0, unknown 0)

### markets (22 routes, L2 warn 0, unknown 0)

### news (1 routes, L2 warn 0, unknown 0)

### notifications (1 routes, L2 warn 0, unknown 0)

### onboarding (1 routes, L2 warn 0, unknown 0)

### p2p (77 routes, L2 warn 0, unknown 0)

### predictions (19 routes, L2 warn 0, unknown 0)

### profile (14 routes, L2 warn 0, unknown 0)

### referral (5 routes, L2 warn 0, unknown 0)

### rewards (1 routes, L2 warn 0, unknown 0)

### support (3 routes, L2 warn 0, unknown 0)

### trade (15 routes, L2 warn 0, unknown 2)

### trade_bots (19 routes, L2 warn 0, unknown 0)

### trade_compliance (29 routes, L2 warn 0, unknown 0)

### trade_copy (21 routes, L2 warn 0, unknown 0)

### trade_terminal (6 routes, L2 warn 0, unknown 0)

### wallet (21 routes, L2 warn 0, unknown 4)

