# Markets Hub Wireframe

Generated: 2026-07-21  
Sources: `03-markets.md`, `99-ALL-ROUTES.md`, `market_list_page.dart`, `market_list_tools.dart`.

## Wireframe (360×800)

```
┌─────────────────────────────────────────────┐
│ Markets              [Overview] [⋯] [🔔]   │
├─────────────────────────────────────────────┤
│ [Search pairs........................]      │
│ [Tất cả] [Spot] [Futures] [Yêu thích]       │
├─────────────────────────────────────────────┤
│ Top movers + tool chips (HUB tools)         │
├─────────────────────────────────────────────┤
│ Pair list ................................  │
├─────────────────────────────────────────────┤
│ Discover: Predictions | Arena (shortcut)    │
├─────────────────────────────────────────────┤
│ [Home] [Markets] [Trade] [Wallet] [Profile] │
└─────────────────────────────────────────────┘
```

## Current vs proposed

| Item | Current | Proposed |
|------|---------|----------|
| Hub model | List-first + mid-scroll chips | Keep list-first; stable tool entry |
| heatmap / watchlist | HUB in IA, weak/no route entry | Add on-page entries |
| Discover footer | Predictions + Arena | Shortcut only; Home canonical |

## Gaps

- `marketsHeatmap`, `marketsWatchlist` need inbound UI
- Several chips may point at routes classified ẨN — reconcile in Phase 2
