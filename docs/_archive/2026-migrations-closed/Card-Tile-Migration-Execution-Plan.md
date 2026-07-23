# Card Tile Migration — Execution Plan

> **Status:** Complete — `pending = 0` (2026-07-07)
>
> **Manifest:** [VitTrade-Card-Tile-Migration-Manifest.csv](./VitTrade-Card-Tile-Migration-Manifest.csv)  
> **Audit:** [VitTrade-Card-Tile-Audit.csv](./VitTrade-Card-Tile-Audit.csv)  
> **Report:** [Card-Tile-Compliance-Report.md](./Card-Tile-Compliance-Report.md)

## Final metrics

| Metric | Value |
| --- | --- |
| Files with VitCard | 993 |
| pass | 993 |
| warn | 0 |
| fail | 0 |
| Strip fixed-height blocks | 6 |
| Tier A violations resolved | 5 |

## What was done

### Phase 0 — Tooling

- Extended [card_tile_audit.dart](../../flutter_app/tool/card_tile_audit.dart) — full-repo scan, tier classifier, compliance report
- Added [card_tile_manifest.dart](../../flutter_app/tool/card_tile_manifest.dart) — migration manifest batches
- Added [card_tile_baseline.dart](../../flutter_app/tool/card_tile_baseline.dart) — bulk `allow-start` for non-strip fixed height

### Phase 1 — Inventory

Baseline audit: 832 pass, 156 warn, 5 fail.

Tier A strip failures (fixed + horizontal scroll, no center):

1. `arena_home_page_part_01.dart` — `_QuickChip` → `contentAlign.center` + `cardTilePadding`
2. `arena_mode_detail_related.dart` — related mode strip → center + `cardTilePadding`
3. `market_screener_filters.dart` — preset scroller → `contentAlign.center`
4. `market_sector_controls.dart` — sector chip → `contentAlign.center`
5. `copy_notifications_page_sections.dart` — filter pill → center; summary row → `allow-start`

### Phase 2 — Baseline

- `dart run tool/card_tile_baseline.dart` — 156 files, 214 `allow-start` comments for chart/stat/square fixed-height surfaces

### Phase 3 — CI

- `dart run tool/card_tile_audit.dart --check --strict-full`
- `dart run tool/card_tile_manifest.dart --check`
- `flutter test test/quality/card_tile_guardrail_test.dart`

## Verify (regression)

```bash
cd flutter_app
dart run tool/card_tile_audit.dart --check --strict-full
dart run tool/card_tile_manifest.dart --check
flutter test test/quality/card_tile_guardrail_test.dart --reporter=compact
flutter test test/features/home/home_page_test.dart --reporter=compact
flutter analyze
```

## New/changed presentation pages

1. Tier A horizontal strip → canonical widget or `contentAlign.center` + tokens
2. Other fixed height → `// card-tile: allow-start` with reason
3. Regenerate: `dart run tool/card_tile_audit.dart && dart run tool/card_tile_manifest.dart`

## Checkpoint AI

| Batch | Cluster | Status |
| --- | --- | --- |
| 01 | shared | done |
| 02 | home | done |
| 03 | tab_roots (arena, markets, trade strip fixes) | done |
| 04–07 | financial / growth / other (baseline allow-start) | done |

**Next batch:** 00 (none — program complete)
