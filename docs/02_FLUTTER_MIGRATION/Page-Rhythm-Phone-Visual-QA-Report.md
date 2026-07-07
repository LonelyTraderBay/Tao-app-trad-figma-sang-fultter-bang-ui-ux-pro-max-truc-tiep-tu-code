# Page Rhythm — Phone Visual QA Report (Emulator)

**Date:** 2026-07-07  
**Device:** sdk gphone16k x86 64 (`emulator-5554`), 1344×2992 @ density 480 (~448 logical dp)  
**Design baseline:** 360×800 logical px (`page_rhythm_phone_visual_qa_test.dart`)  
**Artifacts:** `flutter_app/run-artifacts/phone-visual-qa/` (12 PNG + `capture-report.json`; flows 13–19 widget-gated in CI)

---

## Execution summary

| Layer | Scope | Result |
| --- | --- | --- |
| Widget QA @ 360×800 | 40 flows | **40/40 pass** (CI: `page_rhythm_phone_visual_qa_test.dart`) |
| Emulator screenshots | 12 deep routes (`Capture-PhoneVisualQaDeepRoutes.ps1`) | **12/12 captured** (flows 1–12; 13–19 widget-only gate) |
| Logcat overflow scan | Flows 1–12 | **0 RenderFlex overflow** after layout fixes |
| CI guardrails | page rhythm, card tile, segment pill | **pass** |

---

## Flow results (emulator)

| # | Route | Screenshot | Emulator | Widget @ 360 |
| --- | --- | --- | --- | --- |
| 1 | `/home` | `01-home-tab.png` | pass | pass |
| 2 | `/wallet/multi-manager` | `02-wallet-multi-manager.png` | pass | pass |
| 3 | `/earn/savings/guide` | `03-savings-guide.png` | pass (after fix) | pass |
| 4 | `/p2p/merchant-apply` | `04-p2p-merchant-apply.png` | pass | pass |
| 5 | `/arena` | `05-arena-home.png` | pass | pass |
| 6 | `/profile/settings` | `06-settings.png` | pass | pass |
| 7 | `/admin/analytics` | `07-admin-analytics.png` | pass | pass |
| 8 | `/trade/copy-provider-apply` | `08-provider-apply.png` | pass | pass |
| 9 | `/unified-portfolio` | `09-unified-portfolio.png` | pass | pass |
| 10 | `/markets/depth` | `10-markets-depth.png` | pass | pass |
| 11 | `/home` (product grid scroll) | `11-home-product-grid.png` | pass | pass |
| 12 | `/rewards` | `12-rewards.png` | pass | pass |
| 13 | `/p2p` | — | widget-only | pass |
| 14 | `/dca` | — | widget-only | pass |
| 15 | `/trade/trader/demo` | — | widget-only | pass |
| 16 | `/referral/history` | — | widget-only | pass |
| 17 | `/markets/correlations` | — | widget-only | pass |
| 18 | `/earn/savings/analytics` | — | widget-only | pass |
| 19 | `/arena/leaderboard` | — | widget-only | pass |

---

## Defects found → enterprise disposition

### P0 — Phone layout break (fixed)

| ID | Screen | Symptom | Root cause | Fix | Standard |
| --- | --- | --- | --- | --- | --- |
| **L-01** | Arena home quick chips | `BoxConstraints forces infinite width` @ 360px | `VitCard` + `contentAlign: center` (Column stretch) inside horizontal `SingleChildScrollView` | Wrap chip in `IntrinsicWidth`; keep `contentAlign` + card tile tokens | Card-Tile-Standard, VitCard contract |
| **L-02** | Markets depth pair summary | `RenderFlex overflowed by 49px` @ 360px | Price `Text` not flexible in summary `Row` | `Flexible` + `TextOverflow.ellipsis` on price | Phone-first 360px, AGENTS.md layout primitives |
| **L-03** | Savings Guide quick tips grid | `BoxConstraints negative minimum width (-2.5)` on emulator | `_QuickTipsGrid` `LayoutBuilder` used `constraints.maxWidth` when unbounded/zero during warm-up | Fallback to `MediaQuery` content width; guard `maxWidth <= x2` | Form tier page; bounded layout before `SizedBox(width:)` |

| **L-04** | Market sector control chips | Same class as L-01 (horizontal `ListView` + `VitCard` + `contentAlign`) | `IntrinsicWidth` on `_ChipButton` | Card-Tile-Standard (proactive) |
| **L-05** | Copy notifications unread summary | `RenderFlex overflowed by 34px` @ 360px | `Flexible` + ellipsis on CTA and unread text | Phone-first 360px |
| **L-06** | Savings recommendations simulator | `RenderFlex overflowed by 39px` @ 360px | `Expanded` + ellipsis on title | Phone-first 360px |
| **L-07** | P2P home ad price row | `RenderFlex overflowed by 46px` @ 360px | `Flexible` + ellipsis on price and available amount | Phone-first 360px |
| **L-08** | DCA home P/L summary | `RenderFlex overflowed by 64px` @ 360px | `Flexible` on `VitMetricDeltaPill` | Phone-first 360px |
| **L-09** | Trader profile copiers row | `RenderFlex overflowed by 59px` @ 360px | `Flexible` + ellipsis on copier labels | Phone-first 360px |
| **L-10** | Referral history friend card | `RenderFlex overflowed by 69px` @ 360px | `Wrap` name+pill; `Flexible` commission column | Phone-first 360px |
| **L-11** | Markets correlations underline tabs | `RenderFlex overflowed by 7px` bottom @ 360px | `VitTabBar` underline: `maxLines: 1`, ellipsis, `x2` padding | Shared `VitTabBar` contract |
| **L-12** | Savings analytics chart header | `RenderFlex overflowed by 34px` @ 360px | `Expanded` + ellipsis on title | Phone-first 360px |
| **L-13** | Arena leaderboard season filters | `RenderFlex overflowed by 14px` @ 360px | `SingleChildScrollView` horizontal on `_SeasonFilters` | Segment-Pill-Standard S4 scroll pattern |

### P1 — QA pipeline (fixed)

| ID | Issue | Fix |
| --- | --- | --- |
| **Q-01** | Emulator screenshots taken before first frame (98KB blank shots) | Script waits for logcat `Sending viewport metrics to the engine` + 5s settle |
| **Q-02** | Card tile audit stale after Arena chip change | Regenerated audit; `IntrinsicWidth` restores `contentAlign` compliance |
| **Q-03** | Phone QA not in CI | Added `page_rhythm_phone_visual_qa_test.dart` to `flutter-ci.yml` |
| **Q-04** | Extended scan defects not CI-gated | Expanded phone QA to **19 flows** (L-07–L-13 routes) |

### P2 — Performance (monitor, no layout change)

| ID | Observation | Decision |
| --- | --- | --- |
| **P-01** | Cold start: `Skipped 100–180 frames` on several flows | Accept for debug cold start; track separately in performance sprint |
| **P-02** | Emulator ~448dp vs design 360dp | Document; use widget test for 360px gate, emulator for real-device feel |

### P3 — No action (by design)

| Item | Decision |
| --- | --- |
| Tab root → detail +5px section gap | Intentional tier transition (compact 8 → standard 13) |
| Page rhythm semantic tokens | CI locked; no visual regression |

---

## Fix decisions (Enterprise-Grade)

1. **Prefer shared primitives over page hacks** — Arena chips stay on `VitCard` + card tile tokens; `IntrinsicWidth` solves unbounded width without dropping `contentAlign`.
2. **Phone-first overflow = P0** — Any `@ 360×800` overflow or constraint violation blocks batch; guard with `page_rhythm_phone_visual_qa_test.dart`.
3. **LayoutBuilder in scroll/form pages** — Must handle unbounded/zero `maxWidth` (fallback to `MediaQuery` minus `contentPad`); never pass negative width to `SizedBox`.
4. **Emulator QA complements, not replaces, widget gate** — Emulator catches cold-start + density; widget test enforces 360px contract in CI.
5. **Regenerate audit CSVs** when card-tile-affecting edits land — run `dart run tool/card_tile_audit.dart` before batch complete.

---

## Commands (repeat QA)

```bash
cd flutter_app
flutter test test/quality/page_rhythm_phone_visual_qa_test.dart --reporter=compact
powershell -ExecutionPolicy Bypass -File .\scripts\Capture-PhoneVisualQaDeepRoutes.ps1
dart run tool/card_tile_audit.dart --check --strict-full
```

---

## Files changed in this QA cycle

- `arena_home_page_part_01.dart` — `_QuickChip`: `IntrinsicWidth` + `contentAlign`
- `market_depth_common.dart` — flexible price label
- `savings_guide_tutorials.dart` — `_QuickTipsGrid` bounded width guard
- `market_sector_controls.dart` — `_ChipButton`: `IntrinsicWidth` (L-04 proactive)
- `copy_notifications_page_sections.dart` — L-05 unread summary + filter pill
- `savings_recommendations_page_part_01.dart` — L-06 simulator title
- `p2p_home_page_part_02.dart` — L-07 flexible price/amount row
- `dca_page_part_01.dart` — L-08 flexible delta pill
- `trader_profile_hero.dart` — L-09 flexible copiers row
- `referral_history_page_common.dart` — L-10 Wrap + flexible commission
- `vit_tab_bar.dart` — L-11 underline tab ellipsis + padding
- `savings_analytics_charts_metrics.dart` — L-12 expanded chart title
- `arena_leaderboard_controls.dart` — L-13 season filter horizontal scroll
- `page_rhythm_phone_visual_qa_test.dart` — flows 13–19
- `scripts/Capture-PhoneVisualQaDeepRoutes.ps1` — 12-flow capture with viewport wait
