# State Coverage by Archetype

Generated: 2026-07-21 · Expanded: STEP-P0.10  

Legend: **Y** = required on surfaces of that archetype; **—** = N/A; example routes are representative GIỮ/HUB/ẨN from IA map.

## Matrix

| Archetype | loading | empty | error | offline | submitting | success / receipt | Example routes |
|-----------|:-------:|:-----:|:-----:|:-------:|:----------:|:-----------------:|----------------|
| **list / hub** | Y | Y | Y | Y | — | — | `/home` (`HomePage`), `/markets` (`MarketListPage`), `/wallet` (`WalletPage`), `/p2p` (`P2PHomePage`), `/earn` (`StakingEarnPage`), `/markets/predictions` (`PredictionsHomePage`), `/arena` (`ArenaHomePage`) |
| **form / high-risk** | Y | — | Y | Y | Y | Y (notice) | `/wallet/withdraw` (`WithdrawPage`), `/wallet/deposit` (`DepositPage`), `/profile/kyc` (`KYCPage`), `/settings/security` (`SecurityPage`), P2P payment-method / escrow critical flows |
| **receipt** | Y | — | Y | — | — | Y | `/trade/order-receipt` (`OrderReceiptPage`), P2P order receipt / claim detail ẨN routes, withdraw success → `showVitNoticeSheet` |
| **empty** | — | Y | — | — | — | — | Empty Markets list; empty Watchlist (`WatchlistPage`); empty Orders (`OrdersHistoryPage`); empty Positions (`PositionDashboardPage`); empty Notifications (`NotificationsPage`) |
| **error** | — | — | Y | — | — | — | Hub `when()` error branch on Wallet/Earn; failed withdraw preview; failed P2P create-ad |
| **offline** | — | — | — | Y | — | — | Tab hubs + list hubs (Home, Markets, Trade shell, Wallet, Profile); Markets movers/overview HUB |
| **submitting** | — | — | Y | Y | Y | → success | Trade ticket submit; Convert; Stake / Gửi tiết kiệm; P2P Express; Prediction trade confirm |

## Legacy checklist (kept)

| Archetype (prior label) | loading | empty | error | offline | submitting | success |
|-------------------------|:-------:|:-----:|:-----:|:-------:|:----------:|:-------:|
| Tab/product hub | Y | Y | Y | Y | — | — |
| List | Y | Y | Y | Y | — | — |
| Transaction form | Y | — | Y | Y | Y | Y |
| Wizard | Y | — | Y | — | Y | Y |
| Legal GOM | Y | — | Y | — | — | — |
| Auth shell | Y | — | Y | — | Y | Y |

## Financial preview required

Withdraw, P2P payment-method change, escrow critical, security/API key changes, copy/bot start — preview **before** confirm; success/error via `showVitNoticeSheet`.

## Owner for missing states

Hub/list empty+error gaps → playbook **STEP-P5.4**.
