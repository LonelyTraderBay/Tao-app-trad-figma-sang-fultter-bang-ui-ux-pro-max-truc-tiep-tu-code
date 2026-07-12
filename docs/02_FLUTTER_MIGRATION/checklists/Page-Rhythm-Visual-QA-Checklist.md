# Page Rhythm — Visual QA Checklist (360px)

**Date:** 2026-07-07 (Phase 6)  
**Design viewport:** 360×800 logical px (phone-first baseline)  
**Chrome spot check:**

```bash
cd flutter_app
flutter run -d chrome --web-browser-flag="--window-size=360,800"
```

**Android emulator (recommended for phone-first reality):**

```bash
cd flutter_app
flutter test test/quality/page_rhythm_phone_visual_qa_test.dart --reporter=compact
powershell -ExecutionPolicy Bypass -File .\scripts\Capture-PhoneVisualQaScreenshots.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\Capture-PhoneVisualQaDeepRoutes.ps1
```

Device used: **sdk gphone16k x86 64** (`emulator-5554`), physical **1344×2992**, density **480** (~**448×996** logical dp). Screenshots: `flutter_app/run-artifacts/phone-visual-qa/`.

**Pass criteria:** Major section transitions match tier tokens; no orphan raw scale gaps; semantic `pageRhythm*` tokens only in rhythm `SizedBox`; no layout overflow at **360×800** (phone widget test).

---

## Flow checklist

| Step | Route / surface | Expected tier | Section gap | Chrome | Emulator / phone test | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `/` Home tab root | `compact` | 8px | **pass** | **pass** | Tab screenshot `01-home-tab.png`; widget test @ 360×800 |
| 2 | `/wallet/multi-manager` tabs | `standard` panels | 13px | **pass** | **pass** | Widget test; tab nav `tab-wallet.png` |
| 3 | Earn → Savings Guide (sheet/tutorial) | `form` | 16px | **pass** | **pass** | Widget test |
| 4 | P2P Merchant Apply wizard | `form` | 16px | **pass** | **pass** | Widget test |
| 5 | Arena home (spot) | `compact` | 8px | **pass** | **pass** | Fixed `_QuickChip` infinite-width in horizontal scroll; screenshot `05-arena-home.png` |
| 6 | Settings scroll (spot) | `standard` | 13px | **pass** | **pass** | Widget test; tab `tab-profile.png` |
| 7 | Admin analytics dashboard | `standard` | 13px | **pass** | **pass** | Widget test |
| 8 | Copy Trading provider apply wizard | `form` | 16px | **pass** | **pass** | Widget test |
| 9 | Cross-module portfolio overview | `standard` | 13px | **pass** | **pass** | Widget test |
| 10 | Markets depth (flush + form inner) | `flush` / form inner 8px | 16px sections | **pass** | **pass** | Fixed pair-summary price overflow @ 360px; screenshot `10-markets-depth.png` |
| 11 | Home product grid (service tile badges) | Tier B card tile | — | **pass** | **pass** | Widget test; card tile audit 994/994 |
| 12 | Rewards task list (`VitTaskCard`) | Tier E intrinsic | — | **pass** | **pass** | Widget test |
| 13 | `/p2p` home ad price row | `compact` | 8px | **pass** | **pass** | L-07: flexible price + amount |
| 14 | `/dca` overview P/L row | `compact` | 8px | **pass** | **pass** | L-08: flexible delta pill |
| 15 | `/trade/trader/:id` copiers row | `standard` | 13px | **pass** | **pass** | L-09: flexible copiers text |
| 16 | `/referral/history` friend cards | `standard` | 13px | **pass** | **pass** | L-10: Wrap name+pill; loose commission |
| 17 | `/markets/correlations` underline tabs | `standard` | 13px | **pass** | **pass** | L-11: `VitTabBar` underline ellipsis |
| 18 | `/earn/savings/analytics` chart header | `standard` | 13px | **pass** | **pass** | L-12: expanded title |
| 19 | `/arena/leaderboard` season filters | `compact` | 8px | **pass** | **pass** | L-13: horizontal scroll filters |
| 20 | `/wallet/withdraw` form sections | `form` | 16px | **pass** | **pass** | VitPageSection groups; widget test @ 360×800 |
| 21 | `/wallet/deposit` form sections | `form` | 16px | **pass** | **pass** | VitWalletDetailScaffold default form |
| 22 | `/wallet/transfer` form sections | `form` | 16px | **pass** | **pass** | History in VitPageSection |
| 23 | `/wallet/buy-crypto` input wizard | `form` | 16px | **pass** | **pass** | BuyInputContent VitPageSection |
| 24 | `/wallet/address-book/add` wizard | `form` | 16px | **pass** | **pass** | AddressAddForm VitPageSection |
| 25 | `/wallet/dust-converter` form | `form` | 16px | **pass** | **pass** | Select-all header trailing |
| 26 | `/wallet/limits` KYC tier compare | `form` | 16px | **pass** | **pass** | VitPageSection tier cards |
| 27 | `/wallet/token-approval` tabs | `form` | 16px | **pass** | **pass** | Settings/history form tier |
| 28 | `/wallet/history` tx groups | `standard` | 13px | **pass** | **pass** | VitPageSection date groups |
| 29 | `/wallet/asset/btc` chart + tx | `standard` | 13px | **pass** | **pass** | VitPageSection chart/history |
| 30 | `/wallet/address-book` lists | `standard` | 13px | **pass** | **pass** | Favorites/all VitPageSection |
| 31 | `/wallet/portfolio-analytics` | `standard` | 13px | **pass** | **pass** | Overview metrics/chart cards |
| 32 | `/wallet/network-status` list | `standard` | 13px | **pass** | **pass** | Network list VitPageSection |
| 33 | `/wallet` tab root | `compact` | 8px | **pass** | **pass** | VitPageSection assets/tools/DCA |
| 34 | `/wallet/pending-deposits` deposit list | `standard` | 13px | **pass** | **pass** | VitPageSection deposit list |
| 35 | `/wallet/gas-optimizer` tab panels | `standard` | 13px | **pass** | **pass** | Flatten nested VPC + VitPageSection |
| 36 | `/wallet/health-score` tab panels | `standard` | 13px | **pass** | **pass** | Flatten nested VPC + VitPageSection |
| 37 | `/wallet/portfolio-analytics` overview | `standard` | 13px | **pass** | **pass** | Chart/metrics/assets VitPageSection |
| 38 | `/wallet/token-approval` tab panels | `form` | 16px | **pass** | **pass** | Tab VitPageSection groups |
| 39 | `/wallet/multi-manager` tab panels | `standard` | 13px | **pass** | **pass** | Tab VitPageSection groups |
| 40 | `/wallet/transaction/tx001` detail | `standard` | 13px | **pass** | **pass** | Progress + details VitPageSection |

**Phone widget test:** `page_rhythm_phone_visual_qa_test.dart` — **40/40 pass** @ 360×800.

**Emulator deep routes:** `Capture-PhoneVisualQaDeepRoutes.ps1` — **12/12 screenshots** in `run-artifacts/phone-visual-qa/`. Full report: [Page-Rhythm-Phone-Visual-QA-Report.md](../audits/Page-Rhythm-Phone-Visual-QA-Report.md).

---

## Tier transition spot checks

| Transition | Before Phase 6 | After Phase 6 | Visual |
| --- | --- | --- | --- |
| Standard list → bottom sheet | 13→16 (+3px) | unchanged | **pass** |
| Admin enterprise scroll (`x5` customGap) | 21px orphan | 13px standard | **pass** — semantic tier |
| Trade wizard micro (10px compounds) | `x4-x1` | 8px form inner | **pass** — ≤2px delta |
| Tab root → detail scroll | 8→13 (+5px) | unchanged | **pass** — by design |
| Hero intro (provider apply) | 24px icon block | unchanged relaxed | **pass** — allowlisted hero |

---

## Semantic token verification (structural)

| Check | Expected | Result |
| --- | --- | --- |
| Raw `customGap: AppSpacing.x*` in production | 0 | **pass** |
| Plain `SizedBox(height: AppSpacing.x2/x3/x4)` in production (excl. `/dev/`) | 0 | **pass** — x2→`pageRhythmCompactInnerGap` codemod (~1100 replacements) |
| Compound x3/x4 rhythm `SizedBox` heights | 0 | **pass** |
| Magic literal `AppSpacing.x* + digit` in rhythm `SizedBox` | 0 | **pass** — news chips → `rowGap` / `formFieldLabelGap` |
| `pageRhythmRelaxedSectionGap` in production | hero allowlist only | **pass** — `provider_application_progress_intro.dart` |
| Visual-debt manifest `status=open` | 0 | **pass** |
| Audit `--strict-full` | 1385/1385 | **pass** |
| Guardrail (customGap, compound, magic, x2, x3/x4, x5–x7) | all pass | **pass** (8 tests) |

---

## Hero allowlist (`pageRhythmRelaxed*` section/inner)

Production files permitted to use relaxed tier tokens:

- `savings_ladder_hero.dart`, `savings_backtest_hero.dart`, `savings_home_hero.dart`
- `help_center_hero_actions.dart`
- `arena_mode_detail_hero.dart`, `arena_creator_hero_trust.dart`
- `launchpad_claim_receipt_hero_widgets.dart`, `launchpad_bridge_order_hero.dart`, `launchpad_portfolio_hero_tabs.dart`
- `provider_application_progress_intro.dart` (icon→title intro block)

All bottom sheets / guides / wizard panels use **form 16px** (`pageRhythmFormSectionGap`).

---

## Re-QA after Phase 6 semantic burn-down

Re-verified steps 7–12 after customGap/compound/x2 codemod:

- Admin + enterprise: standard 13px — **pass**
- Copy Trading provider apply: form 16px / form inner 8px — **pass**
- P2P order rate + cooling period: form tier (`sc213`, `sc235`) — **pass**
- Card tile / task card / service badge CI — **pass**
- No regression on hero blocks — **pass**

---

## Emulator layout defects found (2026-07-07)

| Screen | Symptom @ 360×800 | Fix |
| --- | --- | --- |
| Arena home quick chips | `BoxConstraints forces an infinite width` | `IntrinsicWidth` wrapper; keep `VitCard` + `contentAlign` |
| Markets depth pair summary | `RenderFlex overflowed by 49px` | `Flexible` + `TextOverflow.ellipsis` on price |
| Savings Guide quick tips | `BoxConstraints negative minimum width` | `_QuickTipsGrid`: bounded `maxWidth` fallback via `MediaQuery` |
| P2P home ad price row | `RenderFlex overflowed by 46px` | `Flexible` + ellipsis on price and available amount |
| DCA home P/L row | `RenderFlex overflowed by 64px` | `Flexible` on `VitMetricDeltaPill` |
| Trader profile copiers | `RenderFlex overflowed by 59px` | `Flexible` + ellipsis on both copier labels |
| Referral history friend card | `RenderFlex overflowed by 69px` | `Wrap` name+pill; `Flexible` commission column |
| Markets correlations tabs | `RenderFlex overflowed by 7px` bottom | `VitTabBar` underline: ellipsis + `x2` vertical padding |
| Savings analytics chart header | `RenderFlex overflowed by 34px` | `Expanded` + ellipsis on title |
| Arena leaderboard season filters | `RenderFlex overflowed by 14px` | `SingleChildScrollView` horizontal on `_SeasonFilters` |

All verified: **19/19** phone widget test. Details: [Page-Rhythm-Phone-Visual-QA-Report.md](../audits/Page-Rhythm-Phone-Visual-QA-Report.md).
