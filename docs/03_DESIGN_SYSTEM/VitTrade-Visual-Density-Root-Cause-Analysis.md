# VitTrade Visual Density Root Cause Analysis

**Date:** 2026-06-19  
**Scope:** Whole Flutter app UI density, first-viewport usage, and Home-standard consistency  
**Primary reproduction:** `ProfilePage` / `AppRoutePaths.profile` / `SC-156 ProfilePage`

## 1. Executive Finding

The root problem is not that many screens are missing shared components.

The root problem is that the current migration and audit system mostly validates
**component usage, token usage, route render safety, and bottom-nav clipping**.
It does not yet validate **how much useful information appears inside the first
phone viewport**.

Because of that, a screen can pass the official audits while still feeling sparse:

- It uses `VitPageLayout`, `VitAutoHideHeaderScaffold`, `VitTopChrome`,
  `VitPageContent`, `VitCard`, `VitEmptyState`, and other shared primitives.
- It uses tokenized spacing and heights from `AppSpacing`.
- It renders at 360 px / 440 px / 480 px without Flutter layout errors.
- But the first viewport is consumed by large fixed cards, generous gaps, top
  chrome, bottom navigation, and additional bottom inset.

This is why the UI can be technically compliant but visually not yet aligned
with the compact Home standard.

## 2. Concrete Reproduction: Profile Page

### Real Emulator Evidence

Device:

- Physical size: `1344x2992`
- Physical density: `480`
- Logical size: approximately `448x997 dp`

Current foreground route:

- `SC-156 ProfilePage`
- Header: `Tài khoản`
- Bottom nav selected: `Tôi`

Screenshot artifact:

- `flutter_app/run-artifacts/emulator-ui/vittrade_profile_density.png`

UI tree bounds from the emulator:

| Element | Physical bounds | Approx dp bounds |
| --- | ---: | ---: |
| Screen | `[0,0][1344,2992]` | `448 x 997` |
| Profile page starts | `y=159` | `53 dp` |
| Scroll body starts | `y=327` | `109 dp` |
| Bottom nav starts | `y=2734` | `911 dp` |
| Useful body height before nav | `2734 - 327 = 2407 px` | `802 dp` |
| First product row starts | `y=2607` | `869 dp` |
| First product row ends | `y=2829` | `943 dp` |

Result: the first product row begins at about `869 dp`, while bottom nav begins
at about `911 dp`. Only about `42 dp` of a `74 dp` product tile is visible
before the bottom nav area. This matches the user's visual feedback: the page
feels too spread out and does not use the phone viewport efficiently.

### Profile Composition Budget

Profile uses shared components, but its first viewport is consumed by a long
vertical stack:

| Segment | Source token / source code | Height impact |
| --- | --- | ---: |
| Root top chrome | `VitTopChromeType.rootModule` + `rootMinHeight=56` + top/bottom padding | header consumes first viewport |
| Scroll top padding | `profileScrollPadding` | `AppSpacing.x4` top |
| Hero card | `profileHeroHeight` | `216` |
| Hero to VIP gap | `profileHeroToVipGap` | `24` |
| VIP card | `profileVipCardHeight` | `92` |
| VIP to section gap | `profileVipToSectionGap` | `26` |
| Section label | `_SectionLabel` | about `27` on emulator |
| Label gap | `profileSectionLabelGap` | `11` |
| Prediction card | `profileModuleCardHeight` | `137` |
| Prediction to Arena gap | `profilePredictionToArenaGap` | `14` |
| Arena card | `profileModuleCardHeight` | `137` |
| Section gap | `profileSectionGap` | `25` |
| Product section label | `_SectionLabel` | about `27` on emulator |
| Label gap before product grid | `profileSectionLabelGap` | `11` |

Approximate body consumption before the product grid:

```text
top padding 13
+ hero 216
+ gap 24
+ vip 92
+ gap 26
+ section label 27
+ gap 11
+ prediction 137
+ gap 14
+ arena 137
+ gap 25
+ product section label 27
+ gap 11
= about 760 dp after scroll start
```

The useful body region before bottom nav is about `802 dp`. Therefore the next
section only gets about `42 dp` before the nav begins.

This is the exact root-cause shape: each individual token looks reasonable, but
the combined first-viewport budget is overdrawn.

## 3. Why Official Audits Did Not Catch It

### 3.1 Body Component Audit Measures Structure, Not Visual Density

`body_component_consistency_audit.dart` grades a route as `A` when:

- there are no warn statuses,
- `sharedComponentCount >= 5`,
- `customBodyCount <= 35`.

It can also miss tokenized large sizes because `_fixedSizeCount` only matches
raw numeric sizes:

```dart
r'\b(height|width):\s*([0-9]+(?:\.[0-9]+)?)'
```

So this is counted:

```dart
height: 216
```

But this is not counted:

```dart
height: AppSpacing.profileHeroHeight
```

That means a page can use many large tokenized heights and still avoid the
`fixed_size_pressure_needs_mobile_qa` issue.

### 3.2 Design Token Audit Rewards Tokenization, Not Compactness

`design_token_consistency_audit.dart` also checks raw numeric `height:` and
`width:` patterns. It is designed to find local hard-coded styling debt.

It correctly encourages token usage, but it does not answer:

- Is this token too tall for a phone-first root page?
- Is this token appropriate for a repeated card?
- Does the sum of tokenized heights exceed first-viewport budget?
- Does this screen match the compact Home density?

So `AppSpacing.profileHeroHeight = 216` is token-compliant, even though it is a
large first-viewport cost.

### 3.3 Fullscreen Density Audit Has a Token Blind Spot

`ui_fullscreen_density_audit.dart` currently counts:

- `VitContentPadding.relaxed`
- `VitContentGap.loose`
- `VitContentGap.relaxed`
- a limited set of large generic gaps such as `AppSpacing.x8` to `x12`
- `Center`, `MainAxisAlignment.center`, `maxWidth`, `ConstrainedBox`
- low count of `VitSectionHeader` / `VitCard`

It does not count the feature-specific density tokens that create the real
visual pressure:

- `AppSpacing.profileHeroHeight`
- `AppSpacing.profileVipCardHeight`
- `AppSpacing.profileModuleCardHeight`
- `AppSpacing.profileSectionGap`
- `AppSpacing.profileBottomInsetVisual`
- `Spacer()` inside fixed-height cards

This explains why `ProfilePage` can have a low official density score while
the emulator proves it is visually spacious.

### 3.4 Responsive Visual QA Checks Render Safety, Not Information Density

`responsive_visual_qa_matrix_test.dart` checks priority routes at:

- `360x800`
- `440x956`
- `480x1040`

The test verifies:

- route renders,
- semantic label exists,
- exactly one bottom nav exists,
- bottom nav is not clipped.

It does not assert:

- number of visible sections in first viewport,
- first actionable card position,
- percentage of viewport consumed by fixed-height cards,
- overlap between content and bottom nav,
- comparison against Home density.

So it can catch broken layout, but not overly loose layout.

## 4. Five Whys

### Problem

Many screens look too sparse and do not use the phone screen as efficiently as
the Home page.

### Why 1

Because many screens use tall fixed-height cards, generous section gaps, large
bottom insets, and visible top chrome in the first viewport.

### Why 2

Because the shared-component migration focused on replacing local scaffolds and
raw widgets with shared primitives, but did not enforce a first-viewport content
budget.

### Why 3

Because the audit tools treat tokenized layout values as safer than raw values,
but do not classify tokenized values by density risk.

### Why 4

Because `AppSpacing` has many feature-specific height/gap tokens with no
global compact/default/relaxed tier contract and no root-page budget cap.

### Why 5

Because the project currently has no automated guardrail that compares every
screen against Home-standard visual density using real viewport constraints.

## 5. Root Cause Tree

```text
Sparse UI on many screens
|
+-- A. Measurement blind spot
|   |
|   +-- Audit counts shared-component compliance
|   +-- Audit counts raw fixed sizes
|   +-- Audit misses tokenized fixed heights and feature gaps
|   +-- Responsive QA checks render safety, not visible-content density
|
+-- B. Token governance gap
|   |
|   +-- Feature tokens encode large heights as "approved"
|   +-- No root-page first-viewport budget
|   +-- No compact/default/relaxed density tier per component type
|
+-- C. Component semantics gap
|   |
|   +-- VitCard allows large height without density context
|   +-- VitPageContent can remove padding/gap but cannot budget children
|   +-- VitAutoHideHeaderScaffold header still consumes first viewport at top
|
+-- D. Migration objective gap
|   |
|   +-- "Use shared components" became the measurable target
|   +-- "Match Home density" remained mostly visual/manual
|
+-- E. QA coverage gap
    |
    +-- Only priority routes get widget viewport QA
    +-- Full 414-route audit is static, not visual
    +-- No screenshot-derived density metric for all routes
```

## 6. Why This Spreads Beyond Profile

The same pattern appears across modules because many migrated screens share the
same structural recipe:

```text
Root/detail top chrome
+ SingleChildScrollView
+ VitPageContent
+ hero/summary card
+ section header
+ repeated cards
+ manual SizedBox gaps
+ bottom nav inset
```

The previous whole-app scan showed the highest tokenized visual-risk areas:

| Feature | Screens | Avg tokenized visual risk | Max | Main signal |
| --- | ---: | ---: | ---: | --- |
| `trade` | 91 | 37.42 | 117 | many fixed heights, gaps, manual content refs |
| `predictions` | 19 | 31.32 | 68 | portfolio/detail cards and spacers |
| `markets` | 22 | 30.77 | 110 | analytics/detail screens with tall cards |
| `profile` | 14 | 29.71 | 55 | account/settings rows/cards/gaps |
| `arena` | 26 | 23.92 | 66 | large challenge/detail surfaces |
| `wallet` | 21 | 20.81 | 49 | account/asset/security cards |

This means Profile is not an isolated defect. It is a visible example of a
system-level density guardrail gap.

## 7. Non-Causes

These are not the root cause:

- **Not Flutter itself.** The emulator renders exactly what the layout asks it
  to render.
- **Not simply missing shared components.** Profile already uses the expected
  shared layout and card primitives.
- **Not only the Account/Profile screen.** The tokenized visual-risk scan shows
  similar risk in `trade`, `markets`, `predictions`, `arena`, and `wallet`.
- **Not only bottom nav.** Bottom nav reduces available height, but the main
  issue is that first-viewport content is not budgeted against it.
- **Not tokenization failure.** Tokenization is mostly successful; the problem
  is missing density semantics for the tokens.

## 8. Corrective Actions

### P0: Add A Real Visual Density Guardrail

Add or extend a tool that scores every routed screen with these signals:

- tokenized fixed heights:
  - `height: AppSpacing.*Height`
  - `height: AppSpacing.*CardHeight`
  - `height: AppSpacing.*HeroHeight`
  - `height: AppSpacing.*TileHeight`
- feature-specific gaps:
  - `*SectionGap`
  - `*HeaderGap`
  - `*FooterGap`
  - `*BottomInset*`
- `Spacer()` inside fixed-height cards,
- top chrome type,
- bottom nav mode,
- estimated first-viewport consumption,
- first meaningful content after top hero,
- first actionable element position vs bottom nav.

Recommended hard fail candidates:

- root page first section stack consumes more than `75%` of visible body before
  the second major section,
- first repeated/actionable list begins below `80%` of visible body,
- content row overlaps bottom nav,
- tokenized fixed vertical heights exceed a route-specific budget.

### P0: Add Profile As A Golden Density Reproduction

Use `ProfilePage` as the first regression case because it clearly reproduces
the problem and has emulator evidence.

Minimum assertions:

- at `440x956`, product hub first row must be fully above bottom nav,
- at `360x800`, at least the first product row or next primary section must be
  meaningfully visible without scrolling,
- root page top stack must not consume nearly the whole first viewport.

### P1: Define Home-Standard Density Budgets

Create explicit token budgets for root pages, detail pages, and tools.

Suggested starting policy:

| Surface | Hero / lead card | Repeated card | Section gap | Bottom extra inset |
| --- | ---: | ---: | ---: | ---: |
| Root module page | compact by default | compact/default | compact | nav + small clearance |
| Detail page | default allowed | compact/default | default | nav + small clearance |
| Fullscreen tool | custom budget | custom budget | custom | manual QA |

This does not mean every screen must be tiny. It means tall surfaces must be
intentional, rare, and proven in the first viewport.

### P1: Add Density Semantics To Shared Components

Shared components need density-aware APIs, for example:

- `VitCardDensity.compact/default/hero`
- `VitModuleCard.compact`
- `VitMetricCard.compact`
- `VitPageSection(gap: VitSectionGap.compact)`
- `VitFirstViewportBudget` helper for root pages

The goal is to make compactness reusable, not hand-tuned per screen.

### P1: Refactor High-Risk Screens By Archetype

Do not fix random screens one by one. Fix by repeated archetype:

1. Root module pages with tall hero + cards.
2. Account/profile/settings pages with menu rows and large gaps.
3. Trading/markets pages with fixed analytics cards.
4. Prediction/arena pages with two or more tall module cards.
5. Wallet/security/financial confirmation pages with bottom CTA/inset pressure.

### P2: Extend Responsive QA From "No Error" To "Useful Viewport"

For selected high-risk routes, add widget checks using `tester.getRect`:

- first major card top/bottom,
- second section label top,
- first repeated row/card top/bottom,
- bottom nav top,
- minimum visible content count.

For full-route coverage, keep static scanning cheap but make it density-aware.

## 9. Recommended Next Execution Order

1. Implement the density-aware static audit first.
2. Use it to produce a route-ranked backlog.
3. Fix `ProfilePage` and `SettingsPage` as the reference account pattern.
4. Re-run emulator and verify product/menu sections are visible earlier.
5. Apply the same compact pattern to wallet, predictions, markets, arena, and
   trade archetypes.
6. Add widget viewport assertions for the reference patterns.
7. Update the implementation plan so completion means:
   - shared-component compliance,
   - token compliance,
   - financial/domain safety,
   - and first-viewport density compliance.

## 10. Bottom Line

The root cause is a **measurement and design-system governance gap**, not a
single ProfilePage mistake.

The project successfully moved many screens toward shared components, but the
definition of "done" did not include a measurable Home-standard density budget.
Until the audits and shared component APIs understand tokenized fixed heights,
section gaps, bottom inset pressure, and first-viewport content, more screens
will continue to pass automated checks while still feeling too loose in real
phone usage.
