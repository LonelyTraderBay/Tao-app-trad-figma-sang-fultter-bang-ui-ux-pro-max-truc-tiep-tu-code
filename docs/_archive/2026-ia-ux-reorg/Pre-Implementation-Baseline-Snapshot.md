# Pre-Implementation Baseline Snapshot

Generated: 2026-07-21  

## Automated gates

| Gate | Result |
|------|--------|
| `route_coverage_audit --check` | PASS (artifact current) |
| `navigation_edge_audit --check` | PASS (artifact current) |

## IA inventory

| Class | Count |
|-------|------:|
| GIỮ | 33 |
| HUB | 91 |
| GOM | 72 |
| ẨN | 205 |
| DEV | 12 |
| **Total** | **413** |
| Menu-visible | **196** |

## Density baseline (existing audits)

| Metric | Value |
|--------|------:|
| P0_CRITICAL_DENSITY_REVIEW | 13 |
| P1_HIGH_DENSITY_REVIEW | 54 |
| shared_component_compliant_but_sparse | 156 |

## Known IA ↔ code mismatches

1. Trade terminal vs Orders/Positions hub labels
2. Profile Pháp lý UI missing
3. Earn legal sheet missing
4. Markets heatmap/watchlist weak inbound
5. Secondary products highlight Trade tab
