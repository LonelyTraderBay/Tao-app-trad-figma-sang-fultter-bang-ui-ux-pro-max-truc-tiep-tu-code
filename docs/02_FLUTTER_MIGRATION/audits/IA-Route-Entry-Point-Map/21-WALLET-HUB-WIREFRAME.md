# Wallet Hub Wireframe

Generated: 2026-07-21  
Sources: `07-wallet.md`, `wallet_page.dart`.

## Wireframe (360×800)

```
┌─────────────────────────────────────────────┐
│ Wallet                        [⋯ overflow]  │
│ Total balance + 24h                         │
│ [ Nạp ] [ Rút ]                             │
├─────────────────────────────────────────────┤
│ Assets | Allocation                         │
│ Asset list ................................ │
├─────────────────────────────────────────────┤
│ Công cụ ví (tile grid)                      │
│ DCA card                                    │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade] [Wallet] [Profile] │
└─────────────────────────────────────────────┘
```

## Gaps

- `walletHistory` buried in overflow — promote
- Decide promote vs keep ẨN: address-book, gas-optimizer, health-score, multi-manager, token-approval
- Deposit/Withdraw dual entry with Home hero retained (EP-08/09)
