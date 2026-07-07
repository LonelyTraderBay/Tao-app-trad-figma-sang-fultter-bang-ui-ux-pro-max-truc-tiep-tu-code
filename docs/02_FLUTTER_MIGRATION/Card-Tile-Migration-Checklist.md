# Card Tile Migration Checklist

**Mandatory standard:** [Card-Tile-Standard.md](./Card-Tile-Standard.md)  
**Reference:** [vit_compact_product_card.dart](../../flutter_app/lib/shared/widgets/vit_compact_product_card.dart)

## Pick a tier

| Pattern | Tier | Fixed height? | `contentAlign.center`? |
| --- | --- | --- | --- |
| Horizontal strip tile (product, ticker, chip strip) | A | Yes | Yes |
| Grid / service tile | B | Aspect ratio | Internal only |
| Row card (next action, discovery) | C | No | No |
| Hero / chart cell | D | Optional | No — use `allow-start` |
| List container | E | No | No |

## Per strip tile (Tier A)

1. Prefer `VitCompactProductCard` / `VitMarketTickerCard` or new shared strip widget.
2. `VitCard.height` or `minHeight` + `contentAlign: VitCardContentAlign.center`.
3. `padding: AppSpacing.cardTilePadding`, inner gaps `AppSpacing.cardTileInnerGap`.
4. ListView / `SizedBox` slot height matches tile token.
5. Skeleton uses same dimensions.

## Per fixed-height non-strip (Tier D/E)

Add comment on the line above `VitCard(`:

```dart
// card-tile: allow-start — fixed chart cell, not horizontal strip tile
```

## Verify before batch complete

```bash
cd flutter_app
dart run tool/card_tile_audit.dart --check --strict-full
dart run tool/card_tile_manifest.dart --check
flutter test test/quality/card_tile_guardrail_test.dart --reporter=compact
```

## Full-repo status

See [Card-Tile-Compliance-Report.md](./Card-Tile-Compliance-Report.md) — **993/993 pass** as of 2026-07-07.
