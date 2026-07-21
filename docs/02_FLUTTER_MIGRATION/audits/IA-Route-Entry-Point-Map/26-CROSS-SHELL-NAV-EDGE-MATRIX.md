# Cross-Shell Navigation Edge Matrix

Generated: 2026-07-21  
Sources: `99-ALL-ROUTES.md`, `18-APP-SHELL-BOTTOM-NAV-SPEC.md`, hub wireframes 19–25.

## Legend

| Field | Values |
|-------|--------|
| nav_kind | `go` · `push` · `sheet` · `deep_link` · `auth_shell` |
| active_tab | home · markets · trade · wallet · profile · none |

## Tab roots / header / Home launches

See EP table in `00-INDEX.md`. Secondary products use `push` with `pop_or_<parent>`; active tab follows Option A in `18`.

## GOM canonical homes (no duplicates)

| Bucket | Parent | ~Count |
|--------|--------|-------:|
| Profile → Pháp lý & báo cáo | `/profile` accordion | 39 |
| Earn → Tài liệu & rủi ro | `/earn` sheet | 31 |
| Copy hub → Tuân thủ & audit | `/trade/copy-trading` | 2 |

## Known gaps

Markets heatmap/watchlist · Trade Orders/Positions chrome · Wallet history overflow · Profile Pháp lý UI · Earn legal sheet · News on Home header
