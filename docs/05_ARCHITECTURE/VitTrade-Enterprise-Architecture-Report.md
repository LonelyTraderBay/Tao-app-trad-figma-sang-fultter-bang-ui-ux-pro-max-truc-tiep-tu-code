# VitTrade Enterprise Architecture Report
## Comprehensive Technical Documentation for Flutter Migration

**Version:** 1.0.0  
**Date:** March 27, 2026  
**Classification:** Enterprise Fintech Architecture  
**Total Screens:** 401  
**Platform Support:** iOS, Android, Web, Tablet
**Current Migration Baseline:** 401 phone screens from `output/flutter-ui-reference/manifest.json`; this architecture report is reference material and must not override `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [System Architecture Overview](#2-system-architecture-overview)
3. [Module Inventory](#3-module-inventory)
4. [Data Models & Entities](#4-data-models--entities)
5. [UI/UX Architecture](#5-uiux-architecture)
6. [Security & Compliance](#6-security--compliance)
7. [API Integration Patterns](#7-api-integration-patterns)
8. [Flutter Migration Roadmap](#8-flutter-migration-roadmap)

---

## 1. Executive Summary

### 1.1 Project Overview

VitTrade is an enterprise-grade crypto trading application. Current Flutter migration coverage is `401` phone screens from `output/flutter-ui-reference/manifest.json`.

### 1.2 Key Statistics

| Metric | Value |
|--------|-------|
| **Total Screens** | 401 |
| **Core Modules** | 12 |
| **Sub-modules** | 45+ |
| **Data Entities** | 80+ |
| **Platform Shells** | 3 (Phone/Tablet/Web) |
| **Min Screen Width** | 360px |
| **Design System** | 4pt base grid, 8pt rhythm |

### 1.3 Module Distribution

Current screen counts are generated from `output/flutter-ui-reference/manifest.json`. Historical estimates in older architecture notes must not override these counts.

| Module | Screens |
| --- | ---: |
| trade | 87 |
| p2p | 73 |
| earn | 70 |
| arena | 26 |
| launchpad | 24 |
| markets | 22 |
| wallet | 21 |
| predictions | 17 |
| profile | 13 |
| dca | 11 |
| auth | 6 |
| referral | 5 |
| dev | 5 |
| admin | 4 |
| cross-module | 4 |
| discovery | 3 |
| support | 3 |
| home | 1 |
| news | 1 |
| notifications | 1 |
| rewards | 1 |
| enterprise-states | 1 |
| onboarding | 1 |
| demo | 1 |

---

## 2. System Architecture Overview

### 2.1 3-Shell Architecture

VitTrade sử dụng kiến trúc **3-Shell** để hỗ trợ đa nền tảng:

#### Shell 1: Phone Shell (`/`)
- **Target:** Mobile devices (360px - 428px)
- **Characteristics:**
  - Touch-first interactions
  - Single-column layout
  - Gesture-heavy navigation
  - Bottom navigation bar
  - Native mobile patterns

#### Shell 2: Tablet Shell (`/t/`)
- **Target:** Tablets (768px - 834px)
- **Characteristics:**
  - Split-view layouts
  - Floating sidebar
  - 2-column grids
  - Touch + mouse hybrid

#### Shell 3: Web Shell (`/w/`)
- **Target:** Desktop (1280px+)
- **Characteristics:**
  - Multi-panel layouts
  - Full sidebar navigation
  - Command bar
  - Keyboard shortcuts
  - Mouse-optimized

### 2.2 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      ROOT LAYOUT                             │
│                    (RootLayout.tsx)                          │
└──────────────────────┬──────────────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
┌──────────────┐ ┌────────────┐ ┌──────────────┐
│ PHONE SHELL  │ │TABLET SHELL│ │  WEB SHELL   │
│   (/)        │ │   (/t/)    │ │    (/w/)     │
├──────────────┤ ├────────────┤ ├──────────────┤
│ AppLayout    │ │TabletShell │ │  WebShell    │
│ BottomNav    │ │Split View  │ │Sidebar+Cmd   │
│ Touch-first  │ │2-col Grid  │ │Multi-panel   │
└──────────────┘ └────────────┘ └──────────────┘
```

### 2.3 Route Structure

```typescript
// Route Configuration Pattern
const phoneOverrides: ShellOverrides = {
  HomePage, MarketListPage, PairDetailPage, 
  TradePage, WalletPage, ProfilePage, P2PHomePage
};

const tabletOverrides: ShellOverrides = {
  HomePage: ResponsiveHomePage,  // Responsive variants
  // ...
};

const webOverrides: ShellOverrides = {
  HomePage: WebHomePage,  // Desktop-optimized
  // ...
};
```

---

## 3. Module Inventory

### 3.1 Authentication Module (6 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Login | `/auth/login` | User authentication |
| Register | `/auth/register` | Account creation |
| OTP | `/auth/otp` | 2FA verification |
| 2FA Setup | `/auth/2fa-setup` | Two-factor setup |
| Forgot Password | `/auth/forgot-password` | Password recovery |
| Reset Password | `/auth/reset-password` | Password reset |

**Features:**
- Multi-factor authentication
- Biometric login support
- Session management
- Device trust verification
- Anti-phishing codes

---

### 3.2 Core Trading Module (87 captured screens)

#### 3.2.1 Spot Trading (15 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Trade | `/trade` | Main trading interface |
| Trade (Pair) | `/trade/:pairId` | Specific pair trading |
| Orders History | `/trade/orders-history` | Order history |
| Order Receipt | `/trade/order-receipt` | Order confirmation |
| Advanced Chart | `/trade/advanced-chart/:pairId` | Technical analysis |
| Convert | `/trade/convert` | Quick convert |
| Futures | `/trade/:pairId/futures` | Futures trading |
| Leverage | `/trade/:pairId/futures/leverage` | Leverage settings |
| Trade Settings | `/trade/settings` | Trading preferences |
| Positions | `/trade/positions` | Position dashboard |
| Export | `/trade/export` | History export |

**Order Types:**
- Market orders
- Limit orders
- Stop-limit orders
- Stop-market orders
- Time-in-force: GTC, IOC, FOK

#### 3.2.2 Margin Trading (10 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Margin Trading | `/trade/margin` | Margin interface |
| Margin Hub | `/trade/margin/hub` | Margin dashboard |
| Advanced Demo | `/trade/margin/advanced-demo` | Demo mode |
| Market Data Analytics | `/trade/margin/market-data-analytics` | Analytics |
| Live Analytics | `/trade/margin/live-market-data-analytics` | Real-time |
| Advanced Analytics | `/trade/margin/advanced-analytics` | Deep analysis |

**Features:**
- Cross/isolated margin
- Auto-margin call
- Risk ratio monitoring
- Liquidation alerts

#### 3.2.3 Copy Trading (included in trade baseline)

| Screen | Path | Description |
|--------|------|-------------|
| Copy Trading | `/trade/copy-trading` | Copy trading hub |
| Provider Detail | `/trade/copy-provider/:id` | Trader profile |
| Pre-Copy Assessment | `/trade/copy-provider/:id/assessment` | Risk assessment |
| Configuration | `/trade/copy-provider/:id/configuration` | Copy settings |
| Confirmation | `/trade/copy-provider/:id/confirmation` | Confirm copy |
| Active Copies | `/trade/copy-trading/active` | Active copies |
| Performance | `/trade/copy-performance/:id` | Copy performance |
| Attribution | `/trade/copy-performance/:id/attribution` | Return analysis |
| Comparison | `/trade/copy-trading/comparison` | Provider compare |
| Audit Log | `/trade/copy-audit-log/:id` | Activity log |
| Risk Analysis | `/trade/copy-trading/risk-analysis` | Portfolio risk |
| Leaderboard | `/trade/copy-trading/leaderboard` | Top providers |
| Safety Center | `/trade/copy-trading/safety` | Safety education |
| Provider Governance | `/trade/copy-provider-governance` | Governance |
| Dispute Resolution | `/trade/copy-dispute-resolution` | Disputes |
| Regulatory Disclosures | `/trade/copy-regulatory-disclosures` | Compliance |

**Regulatory Compliance Screens (Phase 4):**
- Transaction Reporting
- Best Execution Reports
- Client Categorization
- Product Governance
- Cost Transparency (Ex-Ante/Ex-Post)
- KID Generator
- Complaints Handling
- Audit Trail

#### 3.2.4 Trading Bots (included in trade baseline)

| Screen | Path | Description |
|--------|------|-------------|
| Trading Bots | `/trade/bots` | Bot marketplace |
| Terms of Service | `/trade/bots/terms-of-service` | Legal terms |
| Risk Disclosure | `/trade/bots/risk-disclosure` | Risk warning |
| Suitability Assessment | `/trade/bots/suitability-assessment` | User fit |
| Risk Dashboard | `/trade/bots/risk-dashboard` | Bot risk |
| Emergency Stop | `/trade/bots/emergency-stop` | Kill switch |
| Security Settings | `/trade/bots/security-settings` | Bot security |
| History | `/trade/bots/history` | Bot history |
| Performance Analytics | `/trade/bots/performance-analytics` | Analytics |
| Backtesting | `/trade/bots/backtesting` | Strategy test |
| Strategy Compare | `/trade/bots/strategy-compare` | Compare bots |
| Optimization | `/trade/bots/optimization` | Optimize params |
| Portfolio Dashboard | `/trade/bots/portfolio-dashboard` | Bot portfolio |
| Drawdown Analyzer | `/trade/bots/drawdown-analyzer` | Risk analysis |
| Equity Curve | `/trade/bots/equity-curve` | Performance chart |
| Guide | `/trade/bots/guide` | User guide |
| FAQ | `/trade/bots/faq` | Frequently asked |
| Tax Reporting | `/trade/bots/tax-reporting` | Tax documents |
| API Documentation | `/trade/bots/api-documentation` | Developer docs |

**Bot Strategies:**
- Grid trading
- DCA bots
- Arbitrage bots
- Market making
- Trend following
- Custom strategies

---

### 3.3 Wallet Module (21 captured screens)

| Screen | Path | Description |
|--------|------|-------------|
| Wallet | `/wallet` | Main wallet |
| History | `/wallet/history` | Transaction history |
| Deposit | `/wallet/deposit` | Crypto deposit |
| Deposit (Asset) | `/wallet/deposit/:asset` | Specific asset |
| Withdraw | `/wallet/withdraw` | Crypto withdrawal |
| Transaction Detail | `/wallet/transaction/:txId` | TX details |
| Portfolio Analytics | `/wallet/portfolio-analytics` | Portfolio view |
| Address Book | `/wallet/address-book` | Saved addresses |
| Add Address | `/wallet/address-book/add` | New address |
| Buy Crypto | `/wallet/buy-crypto` | Fiat on-ramp |
| Transfer | `/wallet/transfer` | Internal transfer |
| Asset Detail | `/wallet/asset/:assetId` | Asset info |
| Multi Manager | `/wallet/multi-manager` | Multi-account |
| Gas Optimizer | `/wallet/gas-optimizer` | Fee optimization |
| Token Approval | `/wallet/token-approval` | Approve tokens |
| Health Score | `/wallet/health-score` | Security score |
| Pending Deposits | `/wallet/pending-deposits` | Pending TXs |
| Withdraw Limits | `/wallet/limits` | Limit settings |
| Dust Converter | `/wallet/dust-converter` | Convert small amounts |
| Network Status | `/wallet/network-status` | Blockchain status |

**Features:**
- Multi-chain support
- Hardware wallet integration
- Batch transactions
- Gas optimization
- Token approvals management
- Dust conversion

---

### 3.4 P2P Trading Module (73 captured screens)

#### 3.4.1 Core P2P (30 screens)

| Screen | Path | Description |
|--------|------|-------------|
| P2P Home | `/p2p` | Marketplace |
| Create Ad | `/p2p/create` | Post offer |
| My Ads | `/p2p/my-ads` | User's offers |
| Ad Detail | `/p2p/ad/:id` | Offer details |
| Ad Analytics | `/p2p/ad-analytics/:id` | Performance |
| Payment Methods | `/p2p/payment-methods` | Manage methods |
| Add Payment | `/p2p/payment-method/add` | New method |
| My Orders | `/p2p/my-orders` | Order history |
| Order | `/p2p/order/:orderId` | Order detail |
| Chat | `/p2p/chat/:orderId` | Order chat |
| Order Timeline | `/p2p/order/timeline/:orderId` | Order history |
| Order Rate | `/p2p/order/rate/:orderId` | Rate counterparty |
| Order Cancel | `/p2p/order/cancel/:orderId` | Cancel order |
| Order Proof | `/p2p/order/proof/:orderId` | Payment proof |
| Merchant Profile | `/p2p/merchant/:id` | Merchant info |
| Merchant Apply | `/p2p/merchant-apply` | Become merchant |
| Report Merchant | `/p2p/report/:id` | Report user |
| Reviews | `/p2p/reviews` | User reviews |
| Trading Level | `/p2p/trading-level` | User level |
| Dashboard | `/p2p/dashboard` | Analytics |
| Order Book | `/p2p/order-book` | Market depth |
| Achievements | `/p2p/achievements` | User badges |
| Express | `/p2p/express` | Quick trade |
| Express Confirm | `/p2p/express/confirm` | Confirm trade |
| Guide | `/p2p/guide` | User guide |
| E2E Info | `/p2p/e2e-info` | Encryption info |
| Settings | `/p2p/settings` | P2P settings |
| Blacklist | `/p2p/blacklist` | Blocked users |

#### 3.4.2 KYC & Verification (10 screens)

| Screen | Path | Description |
|--------|------|-------------|
| KYC Requirements | `/p2p/kyc/requirements` | KYC info |
| KYC Status | `/p2p/kyc/status` | Verification status |
| Identity Verification | `/p2p/kyc/identity` | ID verification |
| Address Proof | `/p2p/kyc/address` | Address check |
| Selfie Verification | `/p2p/kyc/selfie` | Face match |
| Video Verification | `/p2p/kyc/video` | Video KYC |

#### 3.4.3 Security & Compliance (15 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Security Center | `/p2p/security/center` | Security hub |
| 2FA Settings | `/p2p/security/2fa` | Two-factor auth |
| Device Management | `/p2p/security/devices` | Device control |
| Anti-Phishing | `/p2p/security/anti-phishing` | Phishing protection |
| Login History | `/p2p/security/login-history` | Access log |
| Suspicious Activity | `/p2p/security/suspicious-activity` | Security alerts |
| Fraud Prevention | `/p2p/fraud-prevention` | Fraud protection |
| Compliance Overview | `/p2p/compliance/overview` | Compliance status |
| AML Screening | `/p2p/compliance/aml-screening` | AML checks |
| Source of Funds | `/p2p/compliance/source-of-funds` | SOF verification |
| Large Transaction | `/p2p/compliance/large-transaction` | Large TX justification |
| Risk Assessment | `/p2p/compliance/risk-assessment` | Risk scoring |
| Tax Reporting | `/p2p/tax-reporting` | Tax documents |

#### 3.4.4 Payment Method Verification (5 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Method Verification | `/p2p/payment-method/verification/:id` | Verify method |
| Ownership Proof | `/p2p/payment-method/ownership/:id` | Prove ownership |
| Cooling Period | `/p2p/payment-method/cooling-period` | Wait period |
| Method History | `/p2p/payment-method/history` | Change log |

#### 3.4.5 Wallet & Limits (8 screens)

| Screen | Path | Description |
|--------|------|-------------|
| P2P Wallet | `/p2p/wallet` | P2P balance |
| Wallet Transfer | `/p2p/wallet/transfer` | Move funds |
| Escrow Balance | `/p2p/escrow/balance` | Escrow info |
| Escrow Detail | `/p2p/escrow/:orderId` | Order escrow |
| Fund Lock History | `/p2p/wallet/fund-lock-history` | Lock records |
| Transaction Limits | `/p2p/limits` | Trading limits |
| Limit Tracker | `/p2p/limits/tracker` | Limit usage |

#### 3.4.6 Insurance Fund (7 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Insurance Fund | `/p2p/insurance` | Fund overview |
| Certificate | `/p2p/insurance/certificate` | Coverage cert |
| Insurance Score | `/p2p/insurance/score` | User score |
| Policy | `/p2p/insurance/policy` | Policy details |
| Contribution History | `/p2p/insurance/contribution-history` | Payments |
| Claim Detail | `/p2p/insurance/claim/:id` | Claim status |

#### 3.4.7 Dispute Resolution (5 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Dispute | `/p2p/dispute/:orderId` | Open dispute |
| Disputes List | `/p2p/disputes` | All disputes |
| Dispute Detail | `/p2p/dispute/detail/:id` | Case details |
| Dispute Evidence | `/p2p/dispute/evidence/:id` | Submit evidence |
| Dispute Resolution | `/p2p/dispute/resolution/:id` | Resolution |

---

### 3.5 Arena Module (26 screens)

**IMPORTANT:** Arena là module social gaming với **Arena Points** (KHÔNG phải tiền thật).

| Screen | Path | Description |
|--------|------|-------------|
| Arena Home | `/arena` | Arena lobby |
| Studio | `/arena/studio` | Create challenges |
| Smart Rules | `/arena/studio/smart-rules` | Rule builder |
| Presets | `/arena/studio/presets` | Template library |
| Governance Gate | `/arena/studio/governance` | Publishing approval |
| Mode Detail | `/arena/mode/:modeId` | Game mode info |
| Challenge Detail | `/arena/challenge/:id` | Challenge view |
| Join Challenge | `/arena/join/:challengeId` | Enter challenge |
| Resolution Center | `/arena/resolution` | Resolve disputes |
| Creator Profile | `/arena/creator/:creatorId` | Creator info |
| Leaderboard | `/arena/leaderboard` | Rankings |
| Verified Challenges | `/arena/verified` | Official challenges |
| Points | `/arena/points` | Points overview |
| Flow Map | `/arena/flow-map` | User journey |
| Safety Center | `/arena/safety` | Safety info |
| Trust Breakdown | `/arena/trust/:userId` | Trust metrics |
| Points Ledger | `/arena/ledger` | Transaction history |
| Ledger Entry | `/arena/ledger/entry/:id` | Entry detail |
| My Arena | `/arena/my` | User's arena |
| Report Case | `/arena/report/:caseId` | Report violation |
| Blocked Users | `/arena/blocked` | Blocked list |
| My Reports | `/arena/my-reports` | User's reports |
| Production Ready | `/arena/production` | Launch checklist |
| Prediction Bridge | `/arena/bridge` | Arena-Prediction link |
| Ecosystem | `/arena/ecosystem` | Connected features |
| Guide | `/arena/guide` | User guide |

**Arena Features:**
- Creator-driven challenges
- Points-only economy (no real money)
- Trust & safety scoring
- Community moderation
- Resolution center

---

### 3.6 Prediction Markets Module (17 captured screens)

**IMPORTANT:** Prediction Markets sử dụng **tiền thật** (khác với Arena).

| Screen | Path | Description |
|--------|------|-------------|
| Predictions Home | `/markets/predictions` | Market listing |
| Search | `/markets/predictions/search` | Find events |
| Breaking | `/markets/predictions/breaking` | Urgent events |
| Event Detail | `/markets/predictions/event/:id` | Event trading |
| Portfolio | `/markets/predictions/portfolio` | User positions |
| Rewards | `/markets/predictions/rewards` | Incentives |
| Leaderboard | `/markets/predictions/leaderboard` | Top traders |
| Global Activity | `/markets/predictions/activity` | Market feed |
| Order Receipt | `/markets/predictions/receipt/:id` | Trade confirm |
| Risk Calculator | `/markets/predictions/risk-calculator` | Risk tool |
| Market Maker | `/markets/predictions/market-maker` | Provide liquidity |
| Portfolio Analyzer | `/markets/predictions/portfolio-analyzer` | Analysis |
| Event Calendar | `/markets/predictions/event-calendar` | Schedule |
| Social | `/markets/predictions/social` | Community |
| Advanced Chart | `/markets/predictions/advanced-chart/:pairId` | Charts |
| Tournaments | `/markets/predictions/tournaments` | Competitions |
| Data Integration | `/markets/predictions/data-integration` | External data |

**Event Categories:**
- Crypto
- Macro
- Politics
- Sports
- Tech
- AI
- Culture

---

### 3.7 Earn/Staking Module (70 captured screens)

#### 3.7.1 Savings (25 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Savings | `/earn/savings` | Savings hub |
| Product Detail | `/earn/savings/product/:id` | Product info |
| Portfolio | `/earn/savings/portfolio` | User savings |
| History | `/earn/savings/history` | Past activity |
| Redeem | `/earn/savings/redeem` | Withdraw savings |
| Receipt | `/earn/savings/receipt` | Transaction proof |
| Guide | `/earn/savings/guide` | User guide |
| FAQ | `/earn/savings/faq` | Common questions |
| Notifications | `/earn/savings/notifications` | Alert settings |
| Goals | `/earn/savings/goals` | Savings targets |
| Ladder | `/earn/savings/ladder` | Maturity ladder |
| DCA | `/earn/savings/dca` | Auto-invest |
| Analytics | `/earn/savings/analytics` | Performance |
| Auto-Pilot | `/earn/savings/auto-pilot` | Automated saving |
| Auto-Rebalance | `/earn/savings/auto-rebalance` | Rebalance settings |
| Backtest | `/earn/savings/backtest` | Historical test |
| Comparison | `/earn/savings/comparison` | Product compare |
| Recommendations | `/earn/savings/recommendations` | Suggestions |
| Smart Suggestions | `/earn/savings/smart-suggestions` | AI advice |
| What-If | `/earn/savings/what-if` | Scenario modeling |
| Risk Assessment | `/earn/savings/risk-assessment` | Risk check |
| Export | `/earn/savings/export` | Data export |

#### 3.7.2 Staking (45 screens)

| Screen | Path | Description |
|--------|------|-------------|
| Staking | `/earn/staking` | Staking hub |
| Staking Earn | `/earn/staking/earn` | Earn interface |
| Dashboard | `/earn/staking/dashboard` | Overview |
| Analytics | `/earn/staking/analytics` | Performance |
| History | `/earn/staking/history` | Staking log |
| Earnings Calendar | `/earn/staking/earnings-calendar` | Reward schedule |
| Validator Selection | `/earn/staking/validators` | Choose validator |
| Auto-Compound | `/earn/staking/auto-compound` | Compound settings |
| Liquid Staking | `/earn/staking/liquid` | Liquid options |
| Insurance | `/earn/staking/insurance` | Staking protection |
| Guide | `/earn/staking/guide` | How to stake |
| FAQ | `/earn/staking/faq` | Common questions |
| Notifications | `/earn/staking/notifications` | Alert settings |
| Recommendations | `/earn/staking/recommendations` | Suggestions |
| Governance | `/earn/staking/governance` | Voting |
| Proposals | `/earn/staking/proposals` | Active votes |
| Voting | `/earn/staking/voting` | Cast votes |
| Forum | `/earn/staking/forum` | Community |
| Social Feed | `/earn/staking/social` | Updates |

**Compliance & Risk (Phase 5-6):**
- Regulatory Framework
- Audit Reports
- Custody Info
- Suitability Assessment
- Insurance Fund Transparency
- Proof of Reserves
- Risk Dashboard
- Slashing History
- Validator Health Monitor
- Emergency Actions
- Contingency Plans

**Advanced (Phase 3, 8):**
- Advanced Orders
- Multi-Chain Staking
- Institutional Services
- API Documentation
- Webhooks
- Data Export
- Third-Party Integrations
- Developer Console

---

### 3.8 DCA Module (11 captured screens)

| Screen | Path | Description |
|--------|------|-------------|
| DCA | `/dca` | DCA dashboard |
| Rebalance Config | `/dca/rebalance/config` | Rebalance setup |
| Rebalance Dashboard | `/dca/rebalance/:id` | Rebalance view |
| Schedule Config | `/dca/schedule/config` | Schedule setup |
| Schedule Analytics | `/dca/schedule/:id` | Schedule view |
| Portfolio Optimizer | `/dca/portfolio-optimizer` | Optimize allocation |
| Dynamic Amount | `/dca/dynamic-amount` | Variable amounts |
| Backtester | `/dca/backtester` | Test strategy |
| Multi-Asset | `/dca/multi-asset` | Multi-coin DCA |
| Performance Compare | `/dca/performance-compare` | Compare vs lump sum |
| Smart Rules | `/dca/smart-rules` | Auto-adjust rules |

---

### 3.9 Launchpad Module (24 captured screens)

| Screen | Path | Description |
|--------|------|-------------|
| Launchpad | `/launchpad` | IDO listing |
| Detail | `/launchpad/:id` | Project details |
| Portfolio | `/launchpad/portfolio` | User investments |
| Performance | `/launchpad/performance` | ROI tracking |
| Staking | `/launchpad/staking` | Launchpad staking |
| IDO Bridge | `/launchpad/idobridge/:id` | Cross-chain IDO |
| Contract | `/launchpad/contract/:id` | Smart contract |
| Receipt | `/launchpad/receipt/:id` | Purchase proof |
| Claim Receipt | `/launchpad/claim-receipt/:id` | Claim proof |
| Bridge Order | `/launchpad/bridge-order/:txId` | Bridge status |
| Batch Claim | `/launchpad/batch-claim` | Multi-claim |
| Bridge Compare | `/launchpad/bridge-compare` | Bridge options |
| Notification Sound | `/launchpad/notif-sound` | Alert settings |
| Event Log | `/launchpad/event-log` | Activity log |
| ABI Diff | `/launchpad/abi-diff/:id` | Contract changes |
| Address Book | `/launchpad/address-book` | Saved addresses |
| Webhooks | `/launchpad/webhooks` | Webhook config |
| Gas Tracker | `/launchpad/gas-tracker` | Fee monitor |
| Rebalance | `/launchpad/rebalance` | Rebalance IDO tokens |
| Multisig | `/launchpad/multisig` | Multi-sig setup |
| Swap Aggregator | `/launchpad/swap-aggregator` | Best price swap |
| Limit Orders | `/launchpad/limit-orders` | Set buy orders |
| DCA Builder | `/launchpad/dca-builder` | Auto-invest IDO |
| Risk Analytics | `/launchpad/risk-analytics` | Risk assessment |
| Airdrop Claim | `/launchpad/airdrop-claim` | Claim airdrops |
| Vesting Tracker | `/launchpad/vesting-tracker` | Token unlocks |
| LP Monitor | `/launchpad/lp-monitor` | Liquidity tracking |

---

### 3.10 Profile & Settings Module (13 captured screens)

| Screen | Path | Description |
|--------|------|-------------|
| Profile | `/profile` | User profile |
| Edit Profile | `/profile/edit` | Update info |
| Security | `/profile/security` | Security settings |
| KYC | `/profile/kyc` | Verification |
| Settings | `/profile/settings` | App preferences |
| Activity Log | `/profile/activity` | Account activity |
| API Management | `/profile/api` | API keys |
| Create API Key | `/profile/api/create` | New API key |
| VIP | `/profile/vip` | VIP program |
| Device Management | `/profile/devices` | Connected devices |
| Sub-accounts | `/profile/sub-accounts` | Sub-account mgmt |
| Predictions Bridge | `/profile/predictions` | Prediction portfolio |
| Arena Bridge | `/profile/arena` | Arena profile |

---

### 3.11 Markets Module (22 captured screens)

| Screen | Path | Description |
|--------|------|-------------|
| Markets | `/markets` | Market listing |
| Overview | `/markets/overview` | Market summary |
| Movers | `/markets/movers` | Top gainers/losers |
| Sectors | `/markets/sectors` | By category |
| Watchlist | `/markets/watchlist` | Favorites |
| Heatmap | `/markets/heatmap` | Visual map |
| Alerts | `/markets/alerts` | Price alerts |
| Screener | `/markets/screener` | Filter assets |
| Compare | `/markets/compare` | Side-by-side |
| Calendar | `/markets/calendar` | Economic events |
| Derivatives | `/markets/derivatives` | Futures/options |
| Depth | `/markets/depth` | Order book depth |
| Social Sentiment | `/markets/social-sentiment` | Social signals |
| Portfolio Tracker | `/markets/portfolio-tracker` | External tracking |
| News | `/markets/news` | Market news |
| Advanced Charts | `/markets/advanced-charts` | Pro charts |
| Token Unlocks | `/markets/unlocks` | Unlock schedule |
| Social Signals | `/markets/signals` | Trading signals |
| Correlations | `/markets/correlations` | Asset correlation |

---

### 3.12 Cross-Module Features (4 captured cross-module screens)

| Screen | Path | Description |
|--------|------|-------------|
| Unified Portfolio | `/unified-portfolio` | All-in-one view |
| Cross-Module Analytics | `/cross-module-analytics` | Holistic analysis |
| Smart Alerts | `/smart-alerts` | Unified alerts |
| Tax Reports | `/tax-reports` | Tax center |

---

## 4. Data Models & Entities

### 4.1 Core Entities

#### User
```typescript
interface User {
  id: string;
  email: string;
  username?: string;
  avatarUrl?: string;
  kycLevel: 'none' | 'basic' | 'advanced';
  createdAt: Date;
}
```

#### Asset
```typescript
interface Asset {
  symbol: string;
  name: string;
  iconUrl?: string;
  decimals: number;
}
```

### 4.2 Trading Entities

#### TradingPair
```typescript
interface TradingPair {
  symbol: string;              // e.g., "BTCUSDT"
  baseAsset: string;           // e.g., "BTC"
  quoteAsset: string;          // e.g., "USDT"
  status: 'active' | 'suspended' | 'delisted';
  minOrderSize: number;
  maxOrderSize: number;
  pricePrecision: number;
  quantityPrecision: number;
}
```

#### Order
```typescript
interface Order {
  id: string;
  symbol: string;
  side: 'buy' | 'sell';
  type: 'market' | 'limit' | 'stop_limit' | 'stop_market';
  status: 'pending' | 'open' | 'filled' | 'partially_filled' | 'cancelled' | 'expired' | 'rejected';
  price?: number;
  quantity: number;
  filledQuantity: number;
  remainingQuantity: number;
  averagePrice?: number;
  totalCost?: number;
  fee?: number;
  feeAsset?: string;
  timeInForce?: 'GTC' | 'IOC' | 'FOK';
  stopPrice?: number;
  createdAt: Date;
  updatedAt: Date;
  filledAt?: Date;
}
```

#### Position
```typescript
interface Position {
  asset: string;
  quantity: number;
  availableQuantity: number;
  lockedQuantity: number;
  averagePrice: number;
  currentPrice: number;
  value: number;
  pnl: number;
  pnlPercentage: number;
  allocation: number;
}
```

### 4.3 P2P Entities

#### P2PAd
```typescript
interface P2PAd {
  id: string;
  merchantId: string;
  merchantName: string;
  type: 'buy' | 'sell';
  asset: string;
  fiatCurrency: string;
  price: number;
  availableAmount: number;
  minOrderAmount: number;
  maxOrderAmount: number;
  paymentMethods: P2PPaymentMethod[];
  paymentTimeLimit: number;
  terms?: string;
  completedOrders: number;
  completionRate: number;
  avgReleaseTime: number;
  status: 'active' | 'paused' | 'inactive' | 'deleted';
  createdAt: Date;
  updatedAt: Date;
}
```

#### P2POrder
```typescript
interface P2POrder {
  id: string;
  adId: string;
  buyerId: string;
  buyerName: string;
  sellerId: string;
  sellerName: string;
  merchantId: string;
  asset: string;
  fiatCurrency: string;
  amount: number;
  price: number;
  totalPrice: number;
  fee: number;
  paymentMethod: P2PPaymentMethod;
  paymentTimeLimit: number;
  paymentDeadline: Date;
  paymentProof?: string[];
  status: 'created' | 'pending_payment' | 'payment_sent' | 'confirming' | 'completed' | 'cancelled' | 'disputed' | 'refunded';
  escrowStatus: 'pending' | 'locked' | 'released' | 'refunded';
  createdAt: Date;
  paymentSentAt?: Date;
  releasedAt?: Date;
  completedAt?: Date;
}
```

### 4.4 Arena Entities

#### ArenaRoom
```typescript
interface ArenaRoom {
  id: string;
  creatorId: string;
  creatorName: string;
  title: string;
  description: string;
  modeId: string;
  modeName: string;
  category: 'crypto' | 'sports' | 'politics' | 'entertainment' | 'tech' | 'gaming' | 'community';
  visibility: 'public' | 'unlisted' | 'private';
  status: 'draft' | 'pending_review' | 'published' | 'active' | 'settling' | 'settled' | 'void';
  rules: ArenaRules;
  totalPool: number;           // Arena Points
  entryFee: number;
  minParticipants: number;
  maxParticipants: number;
  currentParticipants: number;
  createdAt: Date;
  startsAt: Date;
  endsAt: Date;
  trustScore?: number;
  safetyTier?: 'safe' | 'moderate' | 'risky';
}
```

#### PointsTransaction
```typescript
interface PointsTransaction {
  id: string;
  userId: string;
  type: 'entry_fee' | 'payout' | 'refund' | 'bonus' | 'penalty' | 'daily_reward';
  amount: number;
  balance: number;
  reason: string;
  roomId?: string;
  challengeId?: string;
  timestamp: Date;
  status: 'pending' | 'completed' | 'reversed';
}
```

### 4.5 Prediction Entities

#### PredictionEvent
```typescript
interface PredictionEvent {
  id: string;
  title: string;
  description: string;
  category: 'crypto' | 'macro' | 'politics' | 'sports' | 'tech' | 'ai' | 'culture';
  status: 'upcoming' | 'trading' | 'closed' | 'settling' | 'settled' | 'void';
  outcomes: PredictionOutcome[];
  totalVolume: number;
  totalShares: number;
  liquidity: number;
  tradingStartsAt: Date;
  tradingEndsAt: Date;
  resolutionDate: Date;
  resolutionSource: string;
  winningOutcomeId?: string;
}
```

#### PredictionPosition
```typescript
interface PredictionPosition {
  id: string;
  eventId: string;
  outcomeId: string;
  userId: string;
  shares: number;
  averagePrice: number;
  totalCost: number;
  currentValue: number;
  pnl: number;
  pnlPercentage: number;
  isSettled: boolean;
  payout?: number;
  openedAt: Date;
  closedAt?: Date;
  settledAt?: Date;
}
```

### 4.6 DCA Entities

```typescript
interface DCAPlan {
  id: string;
  coinSymbol: string;
  coinName: string;
  coinIcon: string;
  frequency: 'daily' | 'weekly' | 'monthly';
  amountPerPurchase: number;
  nextExecution: Date;
  status: 'active' | 'paused' | 'error';
  totalInvested: number;
  currentHoldings: number;
  averageCost: number;
  createdAt: Date;
  lastPurchaseAt?: Date;
}
```

---

## 5. UI/UX Architecture

### 5.1 Layout System

#### PageLayout (Mandatory Wrapper)
```typescript
// Variants: 'default' | 'surface' | 'flush' | 'immersive'
<PageLayout variant="default">
  <Header title="Page Title" back />
  <PageContent>
    {/* Content */}
  </PageContent>
</PageLayout>
```

**Constraints:**
- NEVER use `h-screen` or `calc(100vh)` inside layouts
- ALWAYS use `flex flex-col min-h-full`
- Bottom padding: 32px (safe area for BottomNav)

#### Header Component
```typescript
interface HeaderProps {
  variant?: 'standard' | 'page' | 'custom';
  title?: string;
  subtitle?: string;
  back?: boolean;
  right?: 'bell' | 'search' | 'more' | 'none' | ReactNode;
  action?: { icon: LucideIcon; onClick: () => void; label?: string };
  badge?: number;
  transparent?: boolean;
  breadcrumb?: boolean;
}
```

**Specifications:**
- Height: 52pt (44pt iOS standard + 8pt breathing room)
- Horizontal padding: 20px
- Title font: 17px weight 600 (iOS nav bar exception)

### 5.2 Spacing System

**Base Grid:** 4pt
**Rhythm:** 8pt for layout

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Micro spacing |
| sm | 8px | Tight spacing |
| md | 16px | Standard spacing |
| lg | 24px | Section spacing |
| xl | 32px | Major sections |
| 2xl | 40px | Page sections |

### 5.3 Color System

```typescript
interface ThemeColors {
  // Background
  bg: string;
  surface1: string;
  surface2: string;
  surface3: string;
  
  // Text
  text1: string;    // Primary
  text2: string;    // Secondary
  text3: string;    // Tertiary
  
  // Semantic
  primary: string;
  secondary: string;
  success: string;
  warning: string;
  error: string;
  
  // Trading
  buy: string;
  sell: string;
  
  // Borders
  border: string;
  borderSolid: string;
  
  // Interactive
  hover: string;
  active: string;
  disabled: string;
}
```

### 5.4 Component Hierarchy

```
PageLayout
├── Header
│   ├── Back Button (optional)
│   ├── Title/Subtitle
│   └── Right Actions
├── PageContent
│   ├── PageSection (optional)
│   │   └── Section Label + Accent Bar
│   └── Components
│       ├── Cards (TrCard)
│       ├── Forms (Input, Select)
│       ├── Lists
│       └── Charts
└── StickyFooter (optional)
    └── CTAButton
```

---

## 6. Security & Compliance

### 6.1 Security Features

#### Authentication
- Multi-factor authentication (SMS, Email, Authenticator)
- Biometric authentication (Face ID, Touch ID)
- Device trust verification
- Anti-phishing codes
- Session management
- Login activity monitoring

#### Transaction Security
- Withdrawal whitelist
- Address book verification
- Transaction confirmation screens
- Fee breakdown display
- Emergency stop for bots

#### Data Protection
- End-to-end encryption for P2P chat
- Encrypted API keys
- Secure storage for sensitive data
- Data export capabilities

### 6.2 Regulatory Compliance

#### KYC/AML
- Identity verification (ID, selfie, video)
- Address proof verification
- Source of funds verification
- Large transaction justification
- AML screening
- Risk assessment scoring

#### Reporting
- Tax reporting center
- Transaction history export
- Audit trails
- Regulatory reports
- Best execution reports

#### Client Protection
- Client categorization
- Product governance
- Target market definition
- Cost transparency (Ex-Ante/Ex-Post)
- KID (Key Information Document)
- Complaints handling
- Ombudsman referral

### 6.3 Module Boundaries (CRITICAL)

#### Arena vs Prediction Markets
| Aspect | Arena | Prediction Markets |
|--------|-------|-------------------|
| Currency | Arena Points | Real money (USDT) |
| Performance | Points pool | PnL |
| History | Ledger entries | Order receipts |
| Leaderboard | Fair play/Completion | Trading volume |

**NEVER Merge:**
- Arena Points with wallet balance
- Arena performance with trading PnL
- Arena history with order receipts

---

## 7. API Integration Patterns

### 7.1 API Response Structure

```typescript
interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
  timestamp: number;
}

interface ApiPaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    total: number;
    page: number;
    pageSize: number;
    totalPages: number;
  };
}
```

### 7.2 State Management

```typescript
interface AsyncState<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
}

type LoadingState = 'idle' | 'loading' | 'success' | 'error';
```

### 7.3 WebSocket Patterns

- Real-time price updates
- Order book updates
- Trade execution notifications
- P2P chat messages
- Arena state changes

### 7.4 Integration Points

| Service | Purpose |
|---------|---------|
| Trading Engine | Order execution |
| Market Data | Price feeds, charts |
| Wallet Service | Deposits, withdrawals |
| P2P Engine | Peer-to-peer matching |
| Notification Service | Push, email, SMS |
| KYC Provider | Identity verification |
| Blockchain Nodes | On-chain transactions |

---

## 8. Flutter Migration Roadmap

### 8.1 Architecture Mapping

#### React → Flutter

| React Concept | Flutter Equivalent |
|---------------|-------------------|
| React Router | GoRouter / Navigator 2.0 |
| Context API | Provider / Riverpod / Bloc |
| useState | StatefulWidget / ValueNotifier |
| useEffect | initState / didChangeDependencies |
| Custom Hooks | Service Classes / Mixins |
| CSS/Tailwind | ThemeData / Custom Widgets |
| React Query | Dio + Cache Manager |

### 8.2 Project Structure (Flutter)

```
lib/
├── main.dart                    # App entry
├── app.dart                     # App configuration
├── config/
│   ├── routes.dart              # Route definitions
│   ├── theme.dart               # Theme configuration
│   └── constants.dart           # App constants
├── core/
│   ├── models/                  # Data models
│   ├── services/                # API services
│   ├── repositories/            # Data repositories
│   └── utils/                   # Utilities
├── features/
│   ├── auth/                    # Auth module
│   ├── trading/                 # Trading module
│   ├── wallet/                  # Wallet module
│   ├── p2p/                     # P2P module
│   ├── arena/                   # Arena module
│   ├── predictions/             # Predictions module
│   ├── earn/                    # Earn/Staking module
│   ├── dca/                     # DCA module
│   ├── launchpad/               # Launchpad module
│   ├── profile/                 # Profile module
│   └── markets/                 # Markets module
├── shared/
│   ├── widgets/                 # Common widgets
│   ├── layouts/                 # Layout templates
│   └── components/              # UI components
└── shell/
    ├── phone_shell.dart         # Mobile layout
    ├── tablet_shell.dart        # Tablet layout
    └── web_shell.dart           # Web layout
```

### 8.3 Widget Mapping

| React Component | Flutter Widget |
|-----------------|----------------|
| PageLayout | Scaffold + SafeArea |
| Header | AppBar (custom) |
| PageContent | SingleChildScrollView + Padding |
| StickyFooter | BottomSheet / Container |
| CTAButton | ElevatedButton (custom) |
| TrCard | Card (custom) |
| TabBar | TabBar + TabBarView |
| BottomSheet | BottomSheet / DraggableScrollableSheet |

### 8.4 State Management Recommendation

**Recommended:** Riverpod + Freezed

```dart
// Example: Trading State
@freezed
class TradingState with _$TradingState {
  const factory TradingState({
    @Default(AsyncLoading()) AsyncValue<List<Order>> orders,
    @Default(AsyncLoading()) AsyncValue<Portfolio> portfolio,
    @Default(null) String? selectedPair,
  }) = _TradingState;
}

@riverpod
class TradingController extends _$TradingController {
  @override
  TradingState build() => const TradingState();
  
  Future<void> loadOrders() async {
    state = state.copyWith(orders: const AsyncLoading());
    try {
      final orders = await ref.read(tradingRepositoryProvider).getOrders();
      state = state.copyWith(orders: AsyncData(orders));
    } catch (e, st) {
      state = state.copyWith(orders: AsyncError(e, st));
    }
  }
}
```

### 8.5 3-Shell Implementation

```dart
// Shell router configuration
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Phone Shell
      ShellRoute(
        builder: (context, state, child) => PhoneShell(child: child),
        routes: _phoneRoutes,
      ),
      // Tablet Shell
      ShellRoute(
        path: '/t',
        builder: (context, state, child) => TabletShell(child: child),
        routes: _tabletRoutes,
      ),
      // Web Shell
      ShellRoute(
        path: '/w',
        builder: (context, state, child) => WebShell(child: child),
        routes: _webRoutes,
      ),
    ],
  );
});
```

### 8.6 Package Recommendations

| Functionality | Package |
|---------------|---------|
| Routing | go_router |
| State Management | flutter_riverpod |
| HTTP Client | dio |
| Local Storage | hive / isar |
| Charts | fl_chart / graphic |
| WebSocket | web_socket_channel |
| Biometric | local_auth |
| Push Notifications | firebase_messaging |
| Deep Linking | app_links |
| Crypto | pointycastle |

### 8.7 Migration Phases

#### Phase 1: Foundation (Weeks 1-4)
- Project setup
- Theme system
- Core layouts
- Navigation shell
- Auth module

#### Phase 2: Core Trading (Weeks 5-8)
- Market data
- Trading interface
- Orders
- Wallet (basic)

#### Phase 3: P2P Module (Weeks 9-14)
- P2P marketplace
- Orders & chat
- Escrow system
- Dispute resolution

#### Phase 4: Advanced Modules (Weeks 15-22)
- Copy trading
- Trading bots
- Arena
- Predictions

#### Phase 5: Earn & Staking (Weeks 23-28)
- Savings
- Staking
- DCA
- Launchpad

#### Phase 6: Polish (Weeks 29-32)
- Profile & settings
- Notifications
- Analytics
- Performance optimization

### 8.8 Testing Strategy

```dart
// Unit Tests
flutter test

// Widget Tests
testWidgets('OrderForm submits correctly', (tester) async {
  await tester.pumpWidget(ProviderScope(child: MaterialApp(home: OrderForm())));
  // Test interactions
});

// Integration Tests
flutter test integration_test/app_test.dart
```

---

## Appendix A: Complete Screen Count by Module

| Module | Screens | Priority |
|--------|---------|----------|
| P2P Trading | 73 | P0 |
| Earn/Staking | 70 | P0 |
| Trade (Core, including copy trading and bots) | 87 | P0 |
| Copy Trading | Included in trade baseline | P1 |
| Trading Bots | Included in trade baseline | P1 |
| Launchpad | 24 | P1 |
| Arena | 26 | P2 |
| Predictions | 17 | P2 |
| Wallet | 21 | P0 |
| Profile/Settings | 13 | P1 |
| Markets | 22 | P0 |
| DCA | 11 | P2 |
| Auth | 6 | P0 |
| **TOTAL** | **401** | - |

---

## Appendix B: Key Design Principles

1. **Trust-first** — UI must convey trustworthiness, control, and clear disclosures
2. **Boundary Clarity** — Users must always understand if they're on trading/value surfaces vs. points-only/social surfaces
3. **Clarity over Density** — Prioritize quick scanning and correct decisions
4. **Beginner-first, Pro-available** — New users can complete tasks without getting lost
5. **Safety-by-design** — Risky actions have preview, confirm, and state indicators
6. **No Dark Patterns** — No FOMO, hype, hidden fees, or casino-like experiences

---

**Document End**

*This report provides a comprehensive technical specification for migrating VitTrade to Flutter. All modules, screens, data models, and architectural patterns are documented for enterprise-level development.*
