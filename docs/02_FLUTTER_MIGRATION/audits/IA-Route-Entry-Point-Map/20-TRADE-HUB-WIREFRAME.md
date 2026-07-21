# Trade Hub Wireframe

Generated: 2026-07-21  
Sources: `04-trade.md`, `05-trade-compliance.md`, `trade_page.dart`, `trade_product_navigation.dart`.

## Decision (locked for planning)

`/trade` is a **Spot trading terminal**, not an Orders/Positions tab hub.

| Layer | Role |
|-------|------|
| Product switcher | Spot / Futures / Margin / Convert / Bot |
| Terminal body | Chart/hero + order form + risk + positions snippet |
| Secondary | Orders (EP-26), Positions (EP-27) via **persistent header actions** (proposed) |

## Wireframe (360×800)

```
┌─────────────────────────────────────────────┐
│ Trade   [Lệnh] [Vị thế]     pair ▾          │
│ [Spot] [Futures] [Margin] [Convert] [Bot]   │
├─────────────────────────────────────────────┤
│ Chart / pair hero                           │
│ Order form (Mua / Bán)                      │
│ Risk + next action                          │
│ Positions snippet → all                     │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade] [Wallet] [Profile] │
└─────────────────────────────────────────────┘
```

## GOM

Trade compliance (~30) → Profile › Pháp lý (canonical). Copy-specific audit pages may stay under Copy hub Tuân thủ.
