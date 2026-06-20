# VitTrade Screen Real Estate Optimization Strategy

**Date:** 2026-06-19  
**Scope:** Whole Flutter app UI density and phone viewport efficiency  
**Basis:** `VitTrade-Whole-App-Visual-Density-Root-Cause-Report.md`,
`VitTrade-Visual-Density-Root-Cause-Analysis.md`, and the 414-screen density
matrix.

## 1. Goal

Optimize how VitTrade uses phone screen area without weakening enterprise
quality.

The goal is not to make everything smaller. The goal is to make the first
viewport more useful:

- more actionable content above the bottom nav,
- fewer empty vertical stretches,
- less repeated chrome,
- clearer scan hierarchy,
- preserved financial safety,
- preserved accessibility and touch comfort,
- consistent Home-standard density across modules.

## 2. Enterprise-Grade Definition Of "Good"

A screen is optimized only when all five conditions are true:

1. It uses approved shared primitives and theme tokens.
2. It shows useful content within the first phone viewport.
3. It keeps critical actions, risk, fee, limit, and next-step information clear.
4. It remains usable at 360 px width and up.
5. It passes automated density checks and emulator visual QA.

The missing standard today is item 2: first-viewport usefulness.

## 3. Mental Model: Budget The Viewport

Treat every phone screen like a budget.

For the current visual QA frame:

| Item | Approx cost |
| --- | ---: |
| Full viewport | `956 dp` |
| Safe/status/header area | `~100-120 dp` |
| Bottom nav / bottom clearance | `~90-120 dp` |
| Practical first body viewport | `~760-820 dp` |

That means the top stack of a root page must be planned against about `800 dp`,
not against an infinite scroll.

### Budget Targets

| Screen type | First viewport target |
| --- | --- |
| Root module page | show top summary plus at least one full next section/action group |
| Account/settings page | show identity/status plus first 4-6 primary actions |
| Market/list page | show filters/search plus 5-7 useful rows |
| Detail page | show title/summary, key stats, and primary action/next section preview |
| Financial confirm page | show amount/asset, fee/risk/limit, and confirmation path without hiding safety copy |
| Fullscreen tool | use full screen deliberately; verify manually |

## 4. What Not To Do

Do not solve the problem by:

- globally shrinking text,
- removing risk or fee copy,
- hiding important states,
- removing touch target size below safe mobile interaction,
- making everything a dense table,
- deleting shared components,
- replacing tokens with raw numbers,
- making one-off compact hacks in each page.

That would create a fast-looking UI but not an enterprise-grade product.

## 5. Optimization Angles

### 5.1 Product And Workflow Angle

The first viewport must reflect user intent.

For each screen, classify content into:

| Priority | Content type | Placement |
| --- | --- | --- |
| P0 | current value, risk, required action, status | first viewport |
| P1 | frequent next action, primary navigation, active item | first viewport or first scroll gesture |
| P2 | explanation, secondary metrics, historical context | below first viewport |
| P3 | legal/support/deep details | collapsed, tabbed, or lower page |

Example:

- Profile root should not spend nearly all first viewport on identity and two
  large module cards. It should surface account actions earlier.
- Wallet confirm screens must keep risk/fee/limit visible, but they can use
  compact rows rather than tall explanatory panels.
- Analytics pages should show key metrics first, then deeper charts.

### 5.2 Layout And Viewport Angle

Every root/detail screen should have an explicit first-viewport budget.

Recommended checks:

- top hero/card height should usually stay below `140-160 dp` on root pages;
- repeated cards should usually be `64-96 dp` unless they contain charts;
- section gaps should default to `8-14 dp`, not `24-32 dp`;
- first repeated/actionable content should start before `70%` of visible body;
- no primary row should be mostly hidden by bottom nav;
- avoid `Spacer()` inside fixed-height cards unless the visual rhythm is tested.

When content needs more room, prefer:

- two compact rows instead of one tall card,
- a metric strip instead of a hero block,
- horizontal chips instead of stacked pills,
- collapsed details below the primary action,
- segmented tabs instead of long vertical sections.

### 5.3 Shared Component Angle

Shared components need density semantics, not only visual variants.

Add density-aware APIs:

```dart
enum VitDensity { compact, standard, relaxed, hero, tool }
```

Apply it to:

- `VitCard`
- `VitMetricCard`
- `VitModuleHeroCard`
- `VitPageContent`
- `VitSectionHeader`
- `VitServiceTile`
- `VitHighRiskStatePanel`
- `VitStickyFooter`

Expected behavior:

| Density | Usage |
| --- | --- |
| `compact` | root pages, menu rows, list cards, repeated actions |
| `standard` | default detail content |
| `relaxed` | rare education/onboarding/support content |
| `hero` | one primary marketing/product highlight, not repeated |
| `tool` | chart/trading/chat/fullscreen tools |

This lets teams optimize consistently instead of manually reducing random
`SizedBox` values.

### 5.4 Token Governance Angle

Current tokens prove consistency, but not compactness.

Add token categories:

| Token category | Rule |
| --- | --- |
| `Compact` | default for root modules and dense fintech surfaces |
| `Standard` | normal detail pages |
| `Relaxed` | education/support/onboarding only |
| `Hero` | limited per screen |
| `Tool` | fullscreen tools only |

Policy:

- no new `*HeroHeight`, `*CardHeight`, or `*SectionGap` token without assigning
  a density category;
- no feature-specific tall token without a viewport budget note;
- `AppSpacing.*BottomInset*` must be validated against bottom nav and sticky CTA;
- token audit should warn when tokenized heights accumulate above budget.

### 5.5 Information Architecture Angle

Many sparse screens are not just "too much padding"; they are over-stacked.

Prefer these transformations:

| Current pattern | Better pattern |
| --- | --- |
| Tall hero + tall cards | compact summary strip + action grid |
| Three stacked metric cards | one metric row / compact grid |
| Section title + large gap + card | section title integrated into card/header |
| Repeated educational panels | accordion / progressive disclosure |
| Separate warning card + summary card | compact high-risk panel with rows |
| Long card footer links | inline icon actions or trailing chevron |

Enterprise-grade density comes from information structure first, spacing second.

### 5.6 Financial Safety Angle

Financial screens must be compact but never under-inform.

Do not remove:

- fee,
- risk,
- limit,
- lockup,
- network,
- address masking,
- preview/confirm step,
- success/receipt next steps.

Instead:

- put fee/risk/limit in compact key-value rows;
- use one `VitHighRiskStatePanel` instead of multiple warning cards;
- keep primary CTA sticky only when it does not hide essential content;
- show masked sensitive values in one-line rows;
- use expand/collapse for legal detail after the required summary.

Prediction Markets and Open Arena boundaries remain strict:

- Prediction can show positions, probability, receipt, rewards, and P/L.
- Arena must remain points-only, no payout/profit/stake-return language.

### 5.7 Accessibility Angle

Compact UI must still be accessible.

Rules:

- touch targets should remain comfortable, generally `44 dp` or more for
  important actions;
- icon-only actions need `tooltip` or `Semantics(label: ...)`;
- text cannot be made tiny just to fit more content;
- risk states cannot rely only on color;
- dense rows still need readable labels and values;
- screen reader order must follow visual priority.

Compactness should remove empty space, not remove meaning.

### 5.8 Performance Angle

Optimizing area often improves performance if done correctly.

Prefer:

- `ListView.builder` / slivers for long repeated content;
- `const` widgets where possible;
- smaller composable widgets for repeated rows;
- avoiding large nested `Column` trees inside `SingleChildScrollView` for long
  lists;
- avoiding expensive blur/shadow/glow surfaces;
- keeping charts/tools full-screen only where needed.

Do not use performance as an excuse to flatten everything into one giant widget.

### 5.9 QA And Audit Angle

Add a real density gate.

The current audit must be extended to count:

- tokenized fixed heights,
- feature-specific gap tokens,
- `Spacer()` inside fixed-height cards,
- bottom inset pressure,
- top chrome cost,
- first repeated/actionable section position.

For important routes, add widget tests using `tester.getRect`:

- bottom nav top,
- first actionable section top/bottom,
- first repeated card bottom,
- sticky footer top,
- primary risk panel visibility.

Emulator QA should confirm:

- 360 px minimum phone,
- 440x956 QA phone,
- large phone,
- root page first viewport,
- high-risk financial confirmation,
- fullscreen tool pages.

## 6. Optimization By Screen Archetype

### 6.1 Root Module Pages

Examples:

- Home
- Profile
- Wallet
- Markets
- Trade
- Arena
- DCA

Target:

- first viewport shows top summary and next actionable section;
- one hero/summary only;
- avoid stacking multiple `137+ dp` cards before product/action rows;
- first section after hero should start before `50%` of body viewport;
- second section should be visible or clearly previewed above bottom nav.

Recommended structure:

```text
Top chrome
Compact account/module summary
Primary action strip / metric strip
First actionable grid/list
Secondary modules
```

### 6.2 Detail Pages

Target:

- title and context visible immediately;
- key metric row near top;
- primary action or next step visible in first viewport;
- detailed explanation below first viewport.

Avoid:

- large title card plus large summary card plus large stats card before action.

### 6.3 Account And Settings Pages

Target:

- identity/status compact;
- primary settings/actions visible quickly;
- rows are dense but tappable;
- security warnings stay visible.

For Profile specifically:

- reduce hero cost;
- convert VIP + module cards into compact summary/action rows;
- surface Product & Support and menu sections earlier;
- remove `Spacer()` dependence inside fixed-height module cards.

### 6.4 Financial Confirmation Pages

Target:

- amount/asset/network visible;
- fee/risk/limit visible;
- CTA visible but not covering required information;
- next steps or receipt visible after confirmation.

Use:

- compact key-value rows,
- one high-risk panel,
- sticky footer with measured content clearance.

### 6.5 Analytics And Reports

Target:

- first viewport shows KPI strip and the most important chart/table preview;
- secondary charts below;
- compliance/report pages use compact report cards.

Use:

- metric strips,
- compact chart cards,
- tabs or segmented controls for secondary dimensions.

### 6.6 Fullscreen Tools

Examples:

- advanced chart,
- futures,
- chat,
- trading bots.

Target:

- use screen area edge-to-edge;
- keep controls reachable;
- do not force generic compact root layout onto tools;
- manual emulator QA required.

## 7. Priority Order From Current Matrix

Based on the whole-app density matrix:

| Priority | Work |
| --- | --- |
| P0 | 101 screens, fix by archetype first |
| P1 | 67 high-risk screens, batch after P0 reference patterns |
| Tool | 5 fullscreen tools, manual QA |
| P2 | 111 medium screens, compact after shared patterns stabilize |
| P3 | 119 low screens, monitor when touched |
| Pass | 11 screens, use as references |

Recommended module order:

1. `profile`: fastest visible proof; start with `ProfilePage`.
2. `trade`: highest volume and highest max risk.
3. `markets`: overview/signals/screener density.
4. `predictions`: event detail and tournament pages.
5. `wallet`: financial surfaces, health/gas/security.
6. `arena`: `MyArenaPage` and production/foundation pages.
7. `p2p`, `earn`, `launchpad`, `dca`: P0/P1 routes by matrix.

## 8. Enterprise Guardrails

### Definition Of Done For A Screen

A migrated screen is done only when:

- body component audit passes,
- token audit passes,
- density audit passes,
- route/navigation audits pass,
- required financial safety states remain visible,
- 360 px and 440x956 viewport checks pass,
- emulator screenshot review is acceptable,
- no important content is hidden by bottom nav or sticky footer.

### Definition Of Done For A Shared Component

A shared component is done only when:

- it supports compact/standard variants where needed;
- it has stable dimensions;
- it preserves semantics;
- it has tests for compact and normal layouts;
- it avoids hard-coded raw sizes unless justified;
- it can be reused across at least two archetypes.

## 9. Practical Refactor Recipe

For each P0/P1 screen:

1. Read the row in `whole_app_visual_density_root_cause_matrix.csv`.
2. Identify the dominant root cause: height, gap, spacer, manual content,
   bottom inset, or top chrome.
3. Sketch a first-viewport budget before editing.
4. Replace tall repeated cards with compact shared primitives.
5. Replace loose vertical gaps with compact section rhythm.
6. Remove `Spacer()` from fixed-height cards unless visually necessary.
7. Rebudget bottom inset and sticky footer clearance.
8. Run focused widget tests.
9. Run emulator visual QA.
10. Update the matrix/report.

## 10. Concrete Starting Point

Start with `ProfilePage` because:

- the issue is confirmed on emulator;
- it is user-visible immediately;
- it exercises root top chrome, bottom nav, hero, module cards, gaps, and
  spacers;
- its solution can become the account/settings reference pattern.

Target improvement:

- product/support section should be fully visible or clearly previewed above
  bottom nav on 440x956;
- primary account actions should appear earlier;
- no large module stack should consume nearly the whole first viewport.

Then apply the same density model to:

- `ApiKeyCreatePage`,
- `VIPPage`,
- security/settings pages,
- `MyArenaPage`,
- `WalletHealthScorePage`,
- `PredictionEventDetailPage`,
- `MarketOverviewPage`.

## 11. Bottom Line

To optimize screen area correctly, VitTrade should move from:

```text
shared component usage = done
```

to:

```text
shared component usage
+ token compliance
+ domain safety
+ accessibility
+ first-viewport density
+ emulator proof
= done
```

The winning strategy is not smaller UI. It is better information budgeting.
