# Flutter Navigation Routing

Use this file to implement Flutter navigation without drifting from the React route manifest.

## Source Of Truth

- Exact route coverage: `output/flutter-ui-reference/manifest.json`.
- Screen execution status: `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.
- Navigation edges: `Navigation Graph` section in the master plan.
- Unresolved edges marked `NEEDS_MANUAL_CONFIRM` must not be silently ignored.

## Router Decision

- Use `go_router`.
- Put router setup under `flutter_app/lib/app/router/app_router.dart`.
- Add routes screen by screen. Do not generate all 401 screen implementations in one pass.
- Route paths should match manifest `resolvedUrl` for the ported screen unless the user explicitly approves a Flutter-only path change.

## Route Naming

Use stable names tied to checklist IDs:

| Checklist | Example route name |
| --- | --- |
| `SC-001` | `sc001Login` |
| `SC-007` | `sc007Home` |
| `SC-030` | `sc030PredictionEventDetail` |
| `SC-049` | `sc049TradePair` |

The checklist ID remains the migration tracking key even if display names change.

## Dynamic Sample Params

Use the same sample params as the capture pipeline and master plan:

| Param | Sample |
| --- | --- |
| `pairId` | `btcusdt` |
| `asset` | `USDT` |
| `assetId` | `btc` |
| `txId` | `tx001` |
| `eventId` | `pred-1` |
| `orderId` | `p2p001` |
| `adId` | `ad001` |
| `merchantId` | `mc001` |
| `modeId` | `mode001` |
| `creatorId` | `cr001` |
| `challengeId` | `ch003` |
| `providerId` | `provider001` |
| `copyId` | `copy001` |
| `proposalId` | `prop001` |

## Bottom Nav Destinations

| Tab | Route |
| --- | --- |
| Home | `/home` |
| Markets | `/markets` |
| Trade | `/trade` |
| Wallet | `/wallet` |
| Profile | `/profile` |

Prediction Markets, P2P, Arena, Earn, Launchpad, DCA, Referral, Support, and Admin are reached through in-app links, cards, search, or module entry points, not as extra bottom tabs.

## Navigation QA

For each `SC-xxx`:

1. Verify the Flutter route path matches manifest `resolvedUrl`.
2. Verify required incoming links from the Navigation Graph.
3. Verify visible buttons/cards navigate to the same target as React source when the edge is confirmed.
4. If an edge is `NEEDS_MANUAL_CONFIRM`, document the decision before marking QA done.
5. Keep back behavior working on all inner/detail screens.
