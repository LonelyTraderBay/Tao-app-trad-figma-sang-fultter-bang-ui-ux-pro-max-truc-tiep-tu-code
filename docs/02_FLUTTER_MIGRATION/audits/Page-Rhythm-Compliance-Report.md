# Page Rhythm Compliance Report

Generated: 2026-07-27

Source: `VitTrade-Page-Rhythm-Screen-Compliance.csv`

## Summary

Screen rollup: 412 real_page routes, L1 pass 395, L2 pass 395 warn 0, unknown 17, documented exceptions 1.
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
| AppRouteNames.sc180AdminHome | `InternalSurfaceGate>AdminHomePage` | unmapped |
| AppRouteNames.sc182AbTestDashboard | `InternalSurfaceGate>ABTestDashboardPage` | unmapped |
| AppRouteNames.sc181AnalyticsDashboard | `InternalSurfaceGate>AnalyticsDashboardPage` | unmapped |
| AppRouteNames.sc183FunnelDashboard | `InternalSurfaceGate>FunnelDashboardPage` | unmapped |
| AppRouteNames.sc410AdminSettings | `InternalSurfaceGate>AdminSettingsPage` | unmapped |
| AppRouteNames.sc004TwoFaSetup | `AuthRouteShell>TwoFASetupPage` | unmapped |
| AppRouteNames.sc005ForgotPassword | `AuthRouteShell>ForgotPasswordPage` | unmapped |
| AppRouteNames.sc001Login | `AuthRouteShell>LoginPage` | unmapped |
| AppRouteNames.sc003Otp | `AuthRouteShell>buildOtpPage` | unmapped |
| AppRouteNames.sc002Register | `AuthRouteShell>RegisterPage` | unmapped |
| AppRouteNames.sc006ResetPassword | `AuthRouteShell>ResetPasswordPage` | unmapped |
| AppRouteNames.sc401CopyTradingCardDemo | `InternalSurfaceGate>CopyTradingCardDemo` | unmapped |
| AppRouteNames.sc400DcaOverviewDemo | `InternalSurfaceGate>DCAOverviewDemo` | unmapped |
| AppRouteNames.sc399DesignSystem | `InternalSurfaceGate>DesignSystemPage` | unmapped |
| AppRouteNames.sc398MissingScreensShowcase | `InternalSurfaceGate>MissingScreensShowcasePage` | unmapped |
| AppRouteNames.sc326PerformanceMonitor | `InternalSurfaceGate>PerformanceMonitor` | unmapped |
| AppRouteNames.sc325RouteChecker | `InternalSurfaceGate>RouteChecker` | unmapped |

## By module

### app (17 routes, L2 warn 0, unknown 17)

### arena (25 routes, L2 warn 0, unknown 0)

### cross_module (4 routes, L2 warn 0, unknown 0)

### dca (13 routes, L2 warn 0, unknown 0)

### discovery (3 routes, L2 warn 0, unknown 0)

### earn_savings (24 routes, L2 warn 0, unknown 0)

### earn_staking (46 routes, L2 warn 0, unknown 0)

### enterprise_states (3 routes, L2 warn 0, unknown 0)

### home (1 routes, L2 warn 0, unknown 0)

### launchpad (24 routes, L2 warn 0, unknown 0)

### markets (22 routes, L2 warn 0, unknown 0)

### news (1 routes, L2 warn 0, unknown 0)

### notifications (1 routes, L2 warn 0, unknown 0)

### onboarding (1 routes, L2 warn 0, unknown 0)

### p2p_account (16 routes, L2 warn 0, unknown 0)

### p2p_dispute (10 routes, L2 warn 0, unknown 0)

### p2p_marketplace (13 routes, L2 warn 0, unknown 0)

### p2p_orders (13 routes, L2 warn 0, unknown 0)

### p2p_security (24 routes, L2 warn 0, unknown 0)

### predictions (18 routes, L2 warn 0, unknown 0)

### profile (14 routes, L2 warn 0, unknown 0)

### referral (5 routes, L2 warn 0, unknown 0)

### rewards (1 routes, L2 warn 0, unknown 0)

### support (3 routes, L2 warn 0, unknown 0)

### trade (13 routes, L2 warn 0, unknown 0)

### trade_bots (19 routes, L2 warn 0, unknown 0)

### trade_compliance (30 routes, L2 warn 0, unknown 0)

### trade_copy (21 routes, L2 warn 0, unknown 0)

### trade_terminal (6 routes, L2 warn 0, unknown 0)

### wallet (21 routes, L2 warn 0, unknown 0)

