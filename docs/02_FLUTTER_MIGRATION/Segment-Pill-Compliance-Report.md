# Segment-Pill Compliance Report

**Tool:** `flutter_app/tool/segment_pill_audit.dart`

## Executive summary

| Metric | Count |
| --- | ---: |
| Audit rows | 322 |
| Files with shared widgets | 283 |
| Compliance pass | 226 |
| Compliance warn | 0 |
| Compliance review | 96 |
| Interactive local classes | 0 |
| P0 local classes | 0 |

## Shared widget call sites

| Family | Call sites |
| --- | ---: |
| VitTabBar | 120 |
| VitChoicePill | 130 |
| VitSegmentedChoice | 80 |
| VitSegmentedTabBar | 26 |
| VitPresetChipRow | 30 |
| VitFilterChip | 41 |

## Module heat map

| Module | Audit rows |
| --- | ---: |
| admin | 1 |
| arena | 14 |
| auth | 1 |
| cross_module | 5 |
| dca | 12 |
| dev | 7 |
| discovery | 2 |
| earn | 51 |
| enterprise_states | 2 |
| home | 1 |
| launchpad | 23 |
| markets | 32 |
| news | 1 |
| notifications | 1 |
| p2p | 46 |
| predictions | 28 |
| profile | 5 |
| referral | 3 |
| rewards | 1 |
| support | 2 |
| trade | 66 |
| wallet | 18 |

## Migration status

**Complete** — CI gate: `dart run tool/segment_pill_audit.dart --check --strict-full`.

## P0 migration targets

No P0 local classes remain.

## Regenerate

```bash
cd flutter_app
dart run tool/segment_pill_audit.dart
dart run tool/segment_pill_manifest.dart
dart run tool/segment_pill_audit.dart --check --strict-full
```
