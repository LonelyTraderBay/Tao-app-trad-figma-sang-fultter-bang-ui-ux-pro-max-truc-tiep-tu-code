# VitTrade Home UI/UX Layer Analysis Report

**Status:** Reference report for AI-assisted design and implementation
**Surface:** `SC-007 HomePage`
**Generated:** 2026-06-14
**Purpose:** Help future AI agents understand how the current Home screen is layered, measured, and reused safely for Wallet or other financial modules.

For module-by-module rollout guidance, use
`docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-Rollout-Playbook.md`. This report
explains Home's layers; the playbook maps those layers to other modules,
required shared components, token rules, safety rules, and verification.

---

## 1. Source Of Truth

This report reflects the current Flutter source inspected on 2026-06-14. It is
documentation-only and does not depend on screenshot artifacts being current.

| Area | Source |
| --- | --- |
| Home public widget, keys, density and surface order enums | `flutter_app/lib/features/home/presentation/pages/home_page.dart` |
| Home shell, header, announcement, portfolio, next action, ticker, products, recent rail | `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` |
| Discovery, market, trending, and market row sections | `flutter_app/lib/features/home/presentation/pages/home_page_part_02.dart` |
| Ranked row and formatting helpers | `flutter_app/lib/features/home/presentation/pages/home_page_part_03.dart` |
| Auto-hide header scaffold | `flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart` |
| Top chrome | `flutter_app/lib/shared/layout/vit_top_chrome.dart` |
| Page layout/content primitives | `flutter_app/lib/shared/layout/vit_page_layout.dart`, `flutter_app/lib/shared/layout/vit_page_content.dart` |
| Inset scroll primitive | `flutter_app/lib/shared/widgets/vit_inset_scroll_view.dart` |
| Announcement banner | `flutter_app/lib/shared/widgets/vit_announcement_banner.dart` |
| Section header | `flutter_app/lib/shared/widgets/vit_section_header.dart` |
| Portfolio card foundation and CTA | `flutter_app/lib/shared/widgets/vit_card.dart`, `flutter_app/lib/shared/widgets/vit_cta_button.dart` |
| Hero glow and metric delta | `flutter_app/lib/shared/widgets/vit_hero_glow.dart`, `flutter_app/lib/shared/widgets/vit_metric_delta_pill.dart` |
| Next action card | `flutter_app/lib/shared/widgets/vit_next_action_card.dart` |
| Market ticker | `flutter_app/lib/shared/widgets/vit_market_ticker.dart` |
| Product grid and tiles | `flutter_app/lib/shared/widgets/vit_action_tile_grid.dart`, `flutter_app/lib/shared/widgets/vit_module_components.dart`, `flutter_app/lib/shared/widgets/vit_compact_product_card.dart` |
| Discovery cards | `flutter_app/lib/shared/widgets/vit_discovery_action_card.dart` |
| Market avatars, rows, ranked rows, sparklines | `flutter_app/lib/shared/widgets/vit_asset_avatar.dart`, `flutter_app/lib/shared/widgets/vit_market_rows.dart`, `flutter_app/lib/shared/widgets/vit_sparkline.dart` |
| Theme tokens | `flutter_app/lib/app/theme/app_colors.dart`, `flutter_app/lib/app/theme/app_spacing.dart`, `flutter_app/lib/app/theme/app_text_styles.dart`, `flutter_app/lib/app/theme/device_metrics.dart` |

Captured artifacts under `flutter_app/run-artifacts/` can be regenerated for
visual QA, but this report does not claim existing artifact files are current.

External UI/UX references are secondary only. The current VitTrade shared
primitives, tokens, and financial safety rules win over external dashboard
patterns.

---

## 2. Executive Summary

Home is a **financial command center**. It starts with account context and money
actions, then moves into resume flows, product access, discovery boundaries, and
market data.

Current reading sequence:

```text
App shell
-> auto-hide root brand header
-> compact announcement
-> portfolio hero
-> next action
-> market ticker
-> product launcher
-> recent products
-> discovery boundary
-> market tabs/list
-> trending rail
-> ranked gainers
-> ranked losers
-> persistent bottom nav
```

The updated Home implementation is more shared-primitive driven than earlier
iterations. Section headers, announcements, action cards, product cards, market
rows, ranked rows, avatars, ticker cards, and scroll insets are reusable shared
components rather than local one-off Home-only widgets.

Design intent:

1. Keep global identity and notifications available at the top.
2. Make portfolio value and money actions the first major visual block.
3. Keep unfinished work visible through a single resume card.
4. Show live market pulse before broad product navigation fatigue sets in.
5. Put `Sản phẩm` before `Gần đây` in the current source order.
6. Keep Prediction Markets and Open Arena separated by explicit safety copy.
7. Move data-heavy market exploration lower on the page.

---

## 3. Layer Stack

### Layer 0 - App Shell And Persistent Navigation

Implementation:

- `VitPageLayout`
- `ShellRenderMode`
- `VitAppShell`
- `VitBottomNav`
- `DeviceMetrics`

Behavior:

- Native shell uses `VitPageVariant.flush`.
- Visual QA shell uses the default page variant.
- Bottom navigation remains persistent outside the Home scroll body.
- Home computes `bottomScrollInset` from bottom chrome, safe-area bottom padding,
  and Home-specific scroll inset tokens.

Bottom inset formula:

```text
bottomScrollInset =
  bottomChrome
  + MediaQuery.padding.bottom
  + modeSpecificHomeExtraInset
```

Mode-specific tokens:

| Mode | Bottom chrome | Extra inset |
| --- | ---: | ---: |
| Native shell | `DeviceMetrics.nativeBottomChrome = 72` | `AppSpacing.homeBottomSheetScrollInset = 16` |
| Visual QA frame | `DeviceMetrics.bottomChrome = 90` | `AppSpacing.homeBottomSheetScrollInsetVisual = 40` |

AI implementation rule:

- Do not remove bottom inset when changing Home-like pages.
- Do not place critical financial actions where bottom navigation can cover
  them.
- Keep route and shell semantics unchanged unless the route contract itself is
  being changed.

---

### Layer 1 - Auto-Hide Root Brand Header

Implementation:

- `VitAutoHideHeaderScaffold`
- `_HomeHeader`
- `VitTopChrome(type: VitTopChromeType.rootBrand)`
- `VitHeaderActionItem`

Content:

- Title: `VitTrade`
- Search action routes to `/search`
- Notifications action routes to `/notifications`
- Notification badge uses `notificationUnreadCountProvider`

Behavior:

| Token / Prop | Value |
| --- | ---: |
| Hide threshold | `AppSpacing.homeScrollHideThreshold = 24` |
| Show-at-top threshold | `AppSpacing.homeScrollShowThreshold = 8` |
| Hidden slide offset | `AppSpacing.homeSlideOffsetUp = 0.25` |
| Animation duration | `180ms` |
| Animation curve | `Curves.easeOutCubic` |

UX role:

- Establishes app identity without spending the whole first viewport on chrome.
- Search and notifications are available at the top and return when the user
  scrolls upward.
- Header collapse gives the dense dashboard more vertical room after exploration
  begins.

AI implementation rule:

- Use `rootBrand` only for Home or true app-level root surfaces.
- Module pages should keep module identity even if they copy Home spacing.
- Do not fork a local header behavior when `VitAutoHideHeaderScaffold` fits.

---

### Layer 2 - Compact Announcement

Implementation:

- `_visibleAnnouncements(HomeSnapshot)`
- `_handleHomeScrollNotification(...)`
- `_AnnouncementBanner`
- `VitAnnouncementBanner(variant: compact)`

Visibility logic:

- Announcement must be active.
- Announcement type must be allowed on Home through `surfacesOnHome`.
- Announcement ID must not be in `_sessionHiddenAnnouncementIds`.
- The first visible announcement is rendered.

Behavior:

- The close action hides the current announcement for the session.
- Campaign announcements auto-hide after vertical scroll reaches
  `AppSpacing.homeAnnouncementAutoHideScrollOffset = 96`.
- Compact variant uses a one-line text row with ellipsis.

Visual metrics:

| Metric | Value |
| --- | ---: |
| Outer width | `contentWidth` |
| Card radius | `VitCardRadius.sm` |
| Compact padding | `12h / 8v` |
| Standard padding | `14h / 10v` |
| Leading icon | `18` |
| Icon gap | `12` |
| Arrow/close gap | `8` |
| Chevron | `16` |
| Text token | `caption` |

AI implementation rule:

- Keep announcements short and operational.
- Use this layer for campaign, risk, security, or info notices.
- Do not turn the announcement into the page hero.

---

### Layer 3 - Portfolio Hero

Implementation:

- `_PortfolioCard`
- `VitCard(variant: VitCardVariant.hero, radius: VitCardRadius.lg)`
- `VitHeroGlow`
- `VitMetricDeltaPill`
- `VitInlineIconAction`
- `VitCtaButton`

Content:

- Label: `Tổng tài sản (USDT)`
- Eye toggle for balance masking.
- Main balance using `AppTextStyles.heroNumber`.
- Positive daily PnL pill.
- Context label: `hôm nay`.
- Three CTAs: `Nạp`, `Rút`, `Ví`.

Visual metrics:

| Metric | Value |
| --- | ---: |
| Outer width | `contentWidth` |
| Radius | `VitCardRadius.lg` |
| Padding | `14 left/right`, `7 top`, `4 bottom` |
| Eye icon | `18` |
| Eye tap padding | `6` |
| Hero number token | `heroNumber` |
| PnL chip padding | `10h / 4v` |
| PnL chip icon | `12` |
| Action row gap | `8` |
| CTA height | `44` |
| CTA gap | `10` |

CTA width formula:

```text
buttonWidth = (contentWidth - 28 horizontalCardPadding - 20 actionGaps) / 3
```

| Viewport | Content width | CTA width |
| --- | ---: | ---: |
| `360dp` | `320` | `90.67dp` |
| `440dp` | `400` | `117.33dp` |
| `448dp` emulator | `408` | `120dp` |
| `480dp` | `440` | `130.67dp` |

AI implementation rule:

- Preserve masking and route behavior.
- Preserve financial action labels and safety paths.
- Use tabular figures for financial values.
- Keep this as the only hero-weight card in the first viewport.

---

### Layer 4 - Next Action

Implementation:

- `_NextActionSection`
- `VitSectionHeader(title: 'Tiếp theo')`
- `VitNextActionCard`

Content:

- Icon from `HomeNextAction.icon`.
- Title from `HomeNextAction.title`.
- Status label from `HomeNextAction.stateLabel`.
- Subtitle from `HomeNextAction.subtitle`.
- CTA label from `HomeNextAction.ctaLabel`.
- Route from `HomeNextAction.routePath`.

Visual metrics:

| Metric | Value |
| --- | ---: |
| Outer width | `contentWidth` |
| Card padding | `14` |
| Icon box | `42w x 42h` |
| Icon size | `20` |
| Icon-to-content gap | `12` |
| Title token | `body` + bold |
| Subtitle token | `micro` |
| CTA token | `caption` + bold |
| Chevron gap | `4` |
| Chevron size | `18` |

UX role:

- Makes Home a resume hub.
- Keeps unfinished financial workflows discoverable without adding another
  large hero.

AI implementation rule:

- Do not delete fee, risk, confirmation, 2FA, limit, masking, or next-step copy
  from financial next actions.
- Keep title and subtitle compact with ellipsis.

---

### Layer 5 - Market Ticker

Implementation:

- `_MarketTickerSection`
- `VitMarketTickerStrip`
- `VitMarketTickerCard`
- `VitMarketTickerData`
- `VitAssetAvatar`

Content:

- Uses `controller.hotPairs.take(3)`.
- Each item shows avatar, symbol, price, change label, and directional tone.
- Each card routes to `/pair/{pair.id}`.

Visual metrics:

| Metric | Value |
| --- | ---: |
| Card width | `146` |
| Card min height | `74` |
| Strip gap | `AppSpacing.x3` |
| Card padding | `12` |
| Avatar size | `28` |
| Title token | `caption` + bold |
| Price token | `caption` + tabular figures |
| Change token | `micro` + bold |

UX role:

- Gives a compact market pulse before product navigation.
- Uses horizontal affordance without blocking core financial actions.
- Keeps market movement visible without making the user scroll to the full
  market list.

AI implementation rule:

- Use buy/sell directional tokens for movement only.
- Keep prices and percentages tabular.
- Do not add required user actions only inside this horizontal strip.

---

### Layer 6 - Product Launcher

Implementation:

- `_ProductsSection`
- `HomeSurfaceOrder.productsBeforeRecent`
- `VitSectionHeader(title: 'Sản phẩm')`
- `_QuickActionsGrid`
- `VitActionTileGrid`
- `VitServiceTile`
- `_MoreProductsSheet`
- `VitSheetPanel`

Current order:

```text
Product launcher appears before recent products.
```

Density logic:

| Condition | Density | Primary item count |
| --- | --- | ---: |
| `screenWidth <= 480dp` | Compact | `6` |
| `screenWidth > 480dp` | Standard | `9` |

Grid metrics:

| Metric | Compact | Standard |
| --- | ---: | ---: |
| Columns | `3` | `3` |
| Gap | `8` | `8` |
| Aspect ratio | `1.88` | `1.68` |
| Tile padding | `6` | `8` |
| Icon box | `22` | `26` |
| Icon size | `16` | `20` |
| Label token | `micro` | `caption` |
| Badge max width | `52` | `52` |
| Top stripe | `2h` | `2h` |

Grid formula:

```text
tileWidth = (contentWidth - (gridGap * 2)) / 3
tileHeight = tileWidth / densityAspectRatio
```

Current compact sizes:

| Viewport | Content width | Tile width | Tile height |
| --- | ---: | ---: | ---: |
| `360dp` | `320` | `101.33` | `53.90` |
| `440dp` | `400` | `128.00` | `68.09` |
| `448dp` emulator | `408` | `130.67` | `69.50` |
| `480dp` | `440` | `141.33` | `75.18` |

Standard example above breakpoint:

| Viewport | Content width | Tile width | Tile height |
| --- | ---: | ---: | ---: |
| `520dp` | `480` | `154.67` | `92.06` |

AI implementation rule:

- Keep the 3-column grid; do not force four columns on phone.
- Keep labels and badges short.
- Use the bottom sheet for overflow products.
- Do not add every route to the primary grid without prioritization.

---

### Layer 7 - Recent Products

Implementation:

- `_RecentProductsSection`
- `VitSectionHeader(title: 'Gần đây')`
- `_RecentProductTile`
- `VitCompactProductCard`
- Horizontal `ListView.separated`

Visual metrics:

| Metric | Value |
| --- | ---: |
| Tile width | `146` |
| Rail height | `86` |
| Tile gap | `10` |
| Tile padding | `12h / 5v` |
| Icon box | `28w x 28h` |
| Icon size | `15` |
| Title token | `caption` + bold |
| Metadata token | `micro` |

Visible capacity:

| Viewport | Content width | Approx visible tiles |
| --- | ---: | --- |
| `360dp` | `320` | `2 full + partial` |
| `440dp` | `400` | `2 full + strong partial` |
| `448dp` emulator | `408` | `2 full + strong partial` |
| `480dp` | `440` | `2 full + near-full partial` |

UX role:

- Gives quick return paths to recently used contexts.
- The partial trailing tile communicates horizontal scroll.
- It is lower priority than current product access in the current source order.

AI implementation rule:

- Keep recent items horizontally scrollable.
- Ensure each tile keeps a real route.
- Do not put mandatory financial actions only in this optional rail.

---

### Layer 8 - Discovery Boundary

Implementation:

- `_HomeDiscoverySection`
- `VitSectionHeader(title: 'Dự đoán & Thách đấu')`
- `VitDiscoveryActionCard(variant: compact)`
- `VitStatusPill`

Content:

- `Prediction Markets`
- `Open Arena`
- Boundary copy: Predictions use real positions; Arena uses Points, not real
  money.

Compact card metrics:

| Metric | Value |
| --- | ---: |
| Outer width | `contentWidth` |
| Padding | `12h / 10v` |
| Icon box | `34w x 34h` |
| Icon size | `16` |
| Icon-to-content gap | `12` |
| Title token | `caption` + bold |
| Subtitle token | `micro` |
| Action token | `micro` + medium |
| Trailing chevron | `16` |

Financial safety role:

- Prediction Markets and Open Arena remain separate.
- Arena copy stays points-only.
- Prediction copy can mention positions, probability, portfolio, and P/L where
  appropriate.

AI implementation rule:

- Never merge Prediction and Arena financial language.
- Do not remove the boundary copy.
- Keep discovery compact; it supports the page, not replaces the portfolio hero.

---

### Layer 9 - Market Section

Implementation:

- `_MarketSection`
- `VitSectionHeader(title: 'Thị trường')`
- `VitTabBar`
- `VitTabItem` with Material icons and text labels
- `VitCard`
- `VitMarketPairRow`
- `VitAssetAvatar`
- `VitSparkline`

Tabs:

| Key | Label | Icon |
| --- | --- | --- |
| `hot` | `Hot` | `Icons.local_fire_department_rounded` |
| `gainers` | `Tăng` | `Icons.trending_up_rounded` |
| `losers` | `Giảm` | `Icons.trending_down_rounded` |
| `new` | `Mới` | `Icons.fiber_new_rounded` |

Market row metrics:

| Metric | Value |
| --- | ---: |
| Row padding | `16h / 14v` |
| Avatar | `34w x 34h` |
| Avatar gap | `12` |
| Sparkline | `64w x 30h` |
| Sparkline gap | `12` |
| Right value column | `85w` |
| Divider | `1h` |
| Symbol token | `body` + medium |
| Volume token | `micro` |
| Price token | `body` + tabular figures |
| Change token | `micro` + medium |

Width model:

```text
rowInnerWidth = contentWidth - 32
leftTextColumn =
  rowInnerWidth
  - 34 avatar
  - 12 avatarGap
  - 64 sparkline
  - 12 sparklineGap
  - 85 valueColumn
```

At `360dp`, `leftTextColumn` is about `81dp`, so symbols and volume text must
remain compact and ellipsized.

AI implementation rule:

- Preserve tab switching.
- Use tabular figures for price and percent values.
- Use directional colors only for movement.
- Keep rows dense; do not convert every row into a large card.

---

### Layer 10 - Trending And Ranked Lists

Implementation:

- `_TrendingSection`
- `_RankedListSection`
- `_RankedRow`
- `VitAssetAvatar`
- `VitRankedAssetRow`

Trending rail metrics:

| Metric | Value |
| --- | ---: |
| Rail height | `128` |
| Tile width | `148` |
| Tile padding | `16` |
| Tile gap | `12` |
| Avatar size | `28` |
| Asset token | `body` |
| Price token | `base` + tabular figures |
| Change token | `micro` |

Ranked row metrics:

| Metric | Value |
| --- | ---: |
| Row padding | `16h / 14v` |
| Rank chip width | `20` |
| Avatar | `34` |
| Badge padding | `12h / 6v` |
| Rank token | `caption` + bold |
| Pair token | `body` + medium |
| Percent token | `caption` + bold |

UX role:

- Trending rail supports exploratory browsing.
- Ranked gainers and losers provide dense comparative scanning.
- Pair rows route to pair detail pages.

AI implementation rule:

- Keep lower-page market content dense.
- Keep rank, asset, and movement visible.
- Avoid adding extra metadata unless row height is intentionally redesigned.

---

## 4. Screen Reading Order

For AI agents, the current practical hierarchy is:

```text
1. Global identity and global actions
2. Timely operational/campaign notice
3. Account balance and money actions
4. Resume task
5. Fast market pulse
6. Product launcher
7. Recent contexts
8. Prediction/Arena discovery with safety boundary
9. Market tabs and rows
10. Trending and ranked market exploration
```

For Home-like module pages, keep the concept but replace the identity and data
with module-specific content:

```text
Module header
-> module hero
-> primary action cluster
-> resume/status/context card
-> local tools
-> recent or secondary shortcuts
-> module data lists
-> optional discovery
```

---

## 5. Design Tokens And Visual Language

### Color

Home uses VitTrade dark financial tokens:

| Role | Tokens |
| --- | --- |
| Background/surface | `AppColors.bg`, `surface`, `surface2`, `cardBg` |
| Primary/trust | `AppColors.primary`, `primary08`, `primary12`, `primary20` |
| Financial movement | `AppColors.buy`, `buy10`, `buy15`, `sell`, `sell10`, `sell20` |
| Discovery/accent | `AppColors.accent`, `accent15`, `accent20` |
| Warning/Arena | `AppColors.warn`, `warn10`, `warn15`, `warningBorder` |
| Text | `AppColors.text1`, `text2`, `text3`, `onAccent` |

Rules:

- Use primary/gold for trust and main actions.
- Use green/red only for directional market movement.
- Use accent tones for discovery and advanced product paths.
- Use warning/amber for Arena or caution-adjacent states.
- Do not invent local colors in Home-like financial screens.

### Typography

Home uses `AppTextStyles` tokens:

| Purpose | Token |
| --- | --- |
| Hero balance | `heroNumber` |
| Section title | `sectionTitle` |
| Card and row title | `body` |
| Price emphasis | `base` or `body` + `AppTextStyles.tabularFigures` |
| Banner and compact actions | `caption` |
| Metadata, badges, helper text | `micro` |

Rules:

- Use tabular figures for money, price, amount, percentage, and market values.
- Keep section titles prominent but never hero-sized.
- Do not use local `TextStyle(...)`, local `fontSize`, or local `fontFamily`
  outside theme.
- Do not scale font size with viewport width. Change density, wrapping,
  max lines, or token choice instead.

### Spacing

Important Home spacing tokens:

| Purpose | Token |
| --- | --- |
| Page side padding | `AppSpacing.contentPad` |
| Native shell custom gap | `AppSpacing.homeNativeShellCustomGap` |
| Header behavior | `homeScrollHideThreshold`, `homeScrollShowThreshold`, `homeSlideOffsetUp` |
| Announcement | `homeAnnouncementCardPaddingCompact`, `homeAnnouncementAutoHideScrollOffset` |
| Hero CTA height | `AppSpacing.homeHeroActionHeight` |
| Product density | `homeQuickActionDensityBreakpoint`, `homeQuickActionCompactCount`, `homeQuickActionStandardCount` |
| Recent product size | `homeRecentProductWidth`, `homeRecentProductHeight` |
| Market ticker | `homeMarketTickerCardWidth`, `homeMarketTickerCardMinHeight` |
| Market rows | `homeSparklineWidth`, `homeSparklineHeight`, `homeRankedValueColumnWidth` |
| Bottom safety | `homeBottomSheetScrollInset`, `homeBottomSheetScrollInsetVisual` |

---

## 6. Measurement Model

All dimensions in this report use **Flutter logical dp** unless explicitly
marked as physical pixels. Physical pixels are evidence only, not layout
constants.

Observed emulator reference:

| Metric | Value |
| --- | ---: |
| Physical size | `1344x2992 px` |
| Android density | `480 dpi` |
| Flutter density factor | `3.0` |
| Logical viewport | `448x997.33 dp` |
| QA minimum phone | `360x800 dp` |
| QA standard phone | `440x956 dp` |
| QA large phone | `480x1040 dp` |

Core formulas:

```text
viewportWidthDp = physicalWidthPx / devicePixelRatio
viewportHeightDp = physicalHeightPx / devicePixelRatio
contentWidth = viewportWidthDp - (AppSpacing.contentPad * 2)
```

With `AppSpacing.contentPad = 20`:

| Viewport | Formula | Content width |
| --- | --- | ---: |
| Minimum phone | `360 - 40` | `320dp` |
| QA phone | `440 - 40` | `400dp` |
| Current emulator | `448 - 40` | `408dp` |
| Large phone | `480 - 40` | `440dp` |

Primary vertical cards fill `contentWidth`. They should not add another local
horizontal margin outside the shared page/content rail.

---

## 7. Typography Matrix

These source tokens come from `AppTextStyles`. Do not recreate them locally.

| Token | Size | Height | Approx line box | Primary Home use |
| --- | ---: | ---: | ---: | --- |
| `microTiny` | `7` | `1.0` | `7dp` | Tiny internal labels only |
| `micro` | `10` | `1.5` | `15dp` | Metadata, badges, helper text |
| `captionSm` | `12` | `1.5` | `18dp` | Compact labels where `micro` is too small |
| `caption` | `13` | `1.5` | `19.5dp` | Banner text, actions, ticker values |
| `body` | `14` | `1.5` | `21dp` | Row titles, card titles |
| `base` | `16` | `1.5` | `24dp` | Secondary numeric emphasis |
| `sectionTitle` | `21` | `1.272` | `~26.7dp` | Home section headers |
| `pageTitle` | `26` | `1.272` | `~33.1dp` | Page-level titles outside compact panels |
| `heroNumber` | `34` | `1.272` | `~43.2dp` | Portfolio balance hero |

Recommended mapping:

| UI part | Preferred token |
| --- | --- |
| Hero balance | `heroNumber` |
| Hero label | `caption` + medium |
| Hero supporting text | `micro` |
| Section header | `sectionTitle` with `homeSectionHeaderTitleLineHeight` |
| Section action | `caption` + medium |
| Card title | `body` + bold/medium |
| Card metadata | `micro` |
| Service tile compact label | `micro` + bold |
| Service tile standard label | `caption` + bold |
| Market row symbol | `body` + medium |
| Market row price | `body` + tabular figures |
| Market row change | `micro` + medium |
| Ticker title/value | `caption` + bold/medium |

---

## 8. Screen Utilization Rules

### Full-Width Content Rule

Primary vertical surfaces use:

```text
outerWidth = viewportWidthDp - 40
```

This keeps a consistent `20dp` left/right gutter while still using the whole
phone width effectively.

### Horizontal Scroll Rule

Market ticker, recent products, and trending use fixed item widths to expose a
partial next card:

```text
visibleHint = contentWidth - (fullTiles * itemWidth) - gaps
```

Use this only for optional discovery content. Required money actions must remain
fully visible.

### Dense Grid Rule

Product launcher uses 3 columns:

```text
tileWidth = (contentWidth - 16) / 3
tileHeight = tileWidth / densityAspectRatio
```

Compact density applies through `480dp` screen width. Standard density starts
above that breakpoint.

### Vertical Density Rule

Home uses a descending density pattern:

```text
portfolio hero = largest block
next action = medium resume block
market ticker = compact pulse
product/recent = compact navigation
market/ranked = dense data
```

Do not make every section a hero card. The page works because visual weight is
reserved for the portfolio hero.

### Header Space Rule

Root header metrics:

| Metric | Value |
| --- | ---: |
| Root min height | `56` |
| Horizontal padding | `20` |
| Root top padding | `8` |
| Root bottom padding | `12` |
| Action button | `40` |
| Action icon | `20` |
| Action gap | `8` |

### Touch Target Rule

Minimums:

- Hero CTAs: `44h`.
- Header action buttons: `40w x 40h`.
- Bottom nav item area: `52h`.
- Compact chips: `20h`, only for status labels.
- Financial actions should not be smaller than compact CTA height.

---

## 9. Interaction Model

| Interaction | Behavior | UX intent |
| --- | --- | --- |
| Scroll down | Header hides after `24dp` threshold | Give content more vertical room |
| Scroll near top | Header returns at `8dp` threshold | Restore global identity/actions |
| Scroll up | Header returns | Let users reach search/notifications quickly |
| Announcement close | Hides current announcement for the session | Reduce repeated noise |
| Campaign scroll past `96dp` | Hides campaign announcements for the session | Keep campaign content from occupying exploration space |
| Eye toggle | Masks/unmasks portfolio balance | Privacy in public spaces |
| Hero CTA | Opens deposit, withdraw, wallet routes | Direct financial action |
| Next action card | Opens pending workflow route | Reduce abandoned financial tasks |
| Market ticker card | Opens pair detail | Quick market pulse to detail |
| Product tile | Opens module route | App launcher |
| `Xem thêm` | Opens more products bottom sheet | Keep primary grid compact |
| Recent tile | Opens recent product context | Fast return |
| Market tab | Switches market list | Explore market subsets |
| Market/ranked row | Opens pair detail | Convert insight to action |

---

## 10. Accessibility And UX Notes

Strengths:

- Header is wrapped in shared semantics through the auto-hide scaffold.
- Section headers use `Semantics(header: true)`.
- Product tiles expose button semantics and labels.
- Announcement banner exposes a semantic announcement label.
- Balance masking is present.
- Financial CTAs are large enough for touch.
- Bottom navigation remains visible.

Risks to watch:

- Header can be hidden while deep-scrolling, so important global actions should
  not be the only way to complete a local task.
- Horizontal rails require discoverability; the partial next card is the main
  affordance.
- Dense market rows leave limited text width at `360dp`; keep symbols and
  subtitles short.
- Some Vietnamese text may appear mojibake in terminal displays; validate the
  actual Flutter UI before treating terminal rendering as UI truth.

AI recommendations:

- Keep icon tabs paired with text labels.
- Keep horizontal scroll sections optional.
- Do not hide critical financial actions only inside horizontal rails or sheets.
- Validate at `360dp`, `440dp`, and `480dp` phone widths for Home-like changes.

---

## 11. Home As A Template For Wallet

When using Home as the visual standard for Wallet, copy these concepts:

1. A strong module-specific hero card.
2. Large financial number.
3. Privacy toggle.
4. Primary CTA row.
5. Compact secondary action or tools area.
6. Shared section headers with optional action links.
7. Clear hierarchy: hero first, dense lists below.
8. Bottom nav clearance.

Do not copy:

- The `VitTrade` root brand header into module pages.
- The Home product launcher wholesale.
- Prediction/Arena discovery unless the module explicitly needs it.
- Home-specific market ranking into wallet-specific surfaces.

Wallet-specific adaptation:

```text
Ví tài sản
-> wallet balance hero
-> deposit / withdraw / transfer
-> buy / history compact actions
-> Tài sản / Phân bổ
-> search/filter/assets
-> DCA card
-> wallet tools
```

Safety requirements:

- Preserve masking.
- Preserve available, in-order, and frozen balance breakdowns.
- Preserve deposit, withdraw, transfer, buy, and history navigation.
- Preserve service unavailable and fail-closed copy.
- Do not remove fee, limit, risk, preview, confirmation, masking, or next-step
  copy.

---

## 12. AI Implementation Checklist

Before changing Home or a Home-like page:

- [ ] Read `AGENTS.md`.
- [ ] Read `docs/00_START_HERE.md`.
- [ ] Inspect current screen source files.
- [ ] Inspect shared primitives before creating local widgets.
- [ ] Use `VitPageLayout`, `VitPageContent`, `VitCard`, `VitCtaButton`,
  `VitTabBar`, `VitSectionHeader`, `VitActionTileGrid`, and `VitServiceTile`
  where applicable.
- [ ] Use `VitAutoHideHeaderScaffold` for Home-like auto-hide header behavior.
- [ ] Use `VitInsetScrollView` or equivalent bottom-inset pattern where bottom
  chrome can overlap content.
- [ ] Use `AppColors`, `AppSpacing`, `AppTextStyles`, and density tokens.
- [ ] Preserve route paths and semantic keys unless the task explicitly changes
  them.
- [ ] Preserve financial safety copy.
- [ ] Verify `360dp` layout does not overflow.
- [ ] Run focused tests for touched module when code changes.
- [ ] Run `flutter analyze` when code changes.
- [ ] Run `dart run tool/design_token_consistency_audit.dart --check` when code
  or token usage changes.

---

## 13. Recommended Verification For Home-Like Changes

Documentation-only change:

```bash
git diff --check -- docs/03_DESIGN_SYSTEM/VitTrade-Home-UI-UX-Layer-Analysis-Report.md
```

Code or UI change:

```bash
dart format <changed files>
flutter analyze
flutter test --reporter=compact test/features/home/home_page_test.dart
flutter test --reporter=compact test/quality/responsive_visual_qa_matrix_test.dart
dart run tool/design_token_consistency_audit.dart --check
```

If design-token audit reports stale artifacts:

```bash
dart run tool/design_token_consistency_audit.dart
dart run tool/design_token_consistency_audit.dart --check
```

If validating on emulator, regenerate fresh evidence instead of relying on old
run artifacts:

```bash
flutter run -d emulator-5554 --debug --no-resident
adb -s emulator-5554 exec-out screencap -p > run-artifacts/home_after_change.png
adb -s emulator-5554 exec-out uiautomator dump /dev/tty > run-artifacts/home_after_change.xml
```

---

## 14. Key Takeaways For Future AI Agents

- Home is the app command center, not a marketing page.
- The first viewport must answer: identity, assets, money actions, and next task.
- Current Home uses shared primitives for header, scroll inset, section headers,
  cards, ticker, product tiles, market rows, avatars, and ranked rows.
- Product launcher currently appears before recent products.
- Compact product density applies through `480dp` screen width.
- Use Home's hierarchy and rhythm for Wallet, but keep Wallet's module identity.
- Financial UI must preserve safety, masking, fees, risk, confirmation, and
  next-step context.
- Keep dense market/product sections below the financial hero.
- Validate every visual change against small-phone responsive QA.
