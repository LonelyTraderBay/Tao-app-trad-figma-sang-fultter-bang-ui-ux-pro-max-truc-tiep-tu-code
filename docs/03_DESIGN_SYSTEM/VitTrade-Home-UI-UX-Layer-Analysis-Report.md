# VitTrade Home UI/UX Layer Analysis Report

**Status:** Reference report for AI-assisted design and implementation  
**Surface:** `SC-007 HomePage`  
**Generated:** 2026-06-13  
**Purpose:** Help future AI agents understand how the current Home screen is layered, why each layer exists, and how to reuse the pattern safely for Wallet or other financial modules.

---

## 1. Source Of Truth

Use these files as the implementation source of truth:

| Area | File |
| --- | --- |
| Home page shell and top-screen layout | `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` |
| Discovery, market, trending, ranked sections | `flutter_app/lib/features/home/presentation/pages/home_page_part_02.dart` |
| Ranked row, coin avatar, glow, sparkline helpers | `flutter_app/lib/features/home/presentation/pages/home_page_part_03.dart` |
| Home page public widget and keys | `flutter_app/lib/features/home/presentation/pages/home_page.dart` |
| Shared cards | `flutter_app/lib/shared/widgets/vit_card.dart` |
| Shared service tiles | `flutter_app/lib/shared/widgets/vit_module_components.dart` |
| Shared top chrome | `flutter_app/lib/shared/layout/vit_top_chrome.dart` |
| Shared bottom nav | `flutter_app/lib/shared/layout/vit_bottom_nav.dart` |
| Theme spacing tokens | `flutter_app/lib/app/theme/app_spacing.dart` |
| Theme color tokens | `flutter_app/lib/app/theme/app_colors.dart` |
| Theme typography tokens | `flutter_app/lib/app/theme/app_text_styles.dart` |

Captured emulator evidence:

| State | Artifact |
| --- | --- |
| Top of Home | `flutter_app/run-artifacts/home_ui_analysis_top.png` |
| Mid-scroll Home | `flutter_app/run-artifacts/home_ui_analysis_mid.png` |
| Lower-scroll Home | `flutter_app/run-artifacts/home_ui_analysis_lower.png` |
| Top UI tree | `flutter_app/run-artifacts/home_ui_analysis_top.xml` |
| Mid UI tree | `flutter_app/run-artifacts/home_ui_analysis_mid.xml` |
| Lower UI tree | `flutter_app/run-artifacts/home_ui_analysis_lower.xml` |

External UI/UX reference used only as a secondary lens:

- Fintech crypto mobile trading dark dashboard.
- Pattern: dense mobile command center with visible navigation, dark/OLED foundation, financial action hierarchy, compact discovery cards, and market-data lists.
- Do not replace VitTrade tokens or local design patterns with external fonts, colors, or landing-page structures.

---

## 2. Executive Summary

Home is designed as a **financial command center**, not a marketing landing page.

The screen prioritizes:

1. App identity and global actions.
2. Financial account overview.
3. Primary money actions.
4. Resume/recent workflows.
5. Product launcher.
6. Discovery for adjacent modules.
7. Market data and ranked trading signals.

The important design idea is the sequence:

```text
Brand chrome
-> compact announcement
-> hero portfolio card
-> next action
-> recent products
-> product grid
-> discovery boundary
-> market data
-> trending/ranked lists
-> persistent bottom nav
```

This creates a clear reading order:

- **First viewport:** identity, balance, money actions, next task.
- **Second viewport:** tools/products and discovery.
- **Lower content:** data-heavy market exploration.

---

## 3. Layer Stack

### Layer 0 - App Shell And Persistent Navigation

Implementation:

- `VitPageLayout`
- `VitAppShell`
- `VitBottomNav`
- `ShellRenderMode`

Observed behavior:

- The Home route sits inside the shared app shell.
- Bottom navigation remains fixed.
- Active destination is `home`.
- Scroll content receives bottom inset so lower content is not hidden behind the bottom nav.

UX role:

- Keeps the user oriented at all times.
- Supports fast cross-module movement: Home, Markets, Trade, Wallet, Profile.
- Makes Home feel like the app's operating center rather than a one-off screen.

AI implementation rule:

- Do not remove bottom inset when changing Home or Home-like pages.
- If a page follows Home layout, reserve enough bottom padding for bottom nav and native safe area.
- Never place critical actions only under the bottom nav overlay area.

---

### Layer 1 - Root Brand Header

Implementation:

- `_CollapsibleHomeHeader`
- `_HomeHeader`
- `VitTopChrome(type: VitTopChromeType.rootBrand)`

Content:

- Title: `VitTrade`
- Action: search
- Action: notifications with unread count

Behavior:

- Header is visible at the top.
- It collapses on downward scroll.
- It returns when scrolling upward.
- Animation uses align, opacity, and slide.

UX role:

- Establishes app identity.
- Provides global actions without competing with portfolio data.
- Saves vertical space after the user starts exploring content.

AI implementation rule:

- Use `rootBrand` only for Home or true app-level root surfaces.
- Module pages should usually use module headers such as `rootModule`, not the brand header.
- If copying Home rhythm to another page, copy the spacing and hierarchy, not the `VitTrade` brand title.

---

### Layer 2 - Announcement Banner

Implementation:

- `_AnnouncementBanner`
- `VitCard(radius: VitCardRadius.sm)`

Content example:

- `Phi giao dich 0% cho BTC/USDT trong 7 ngay!`
- Gift icon
- Chevron
- Carousel dots

UX role:

- Small promotional/status layer.
- Gives timely product context without stealing hero priority.
- The dots imply a carousel/news rail, even when only the first item is visible.

Visual role:

- Compact card.
- Low-height row.
- Primary accent border.
- Muted text with icon lead.

AI implementation rule:

- Keep announcements short.
- Use this layer for status, campaign, fee, or operational notices.
- Do not turn this into a large hero. Home's hero is the portfolio card.

---

### Layer 3 - Portfolio Hero

Implementation:

- `_PortfolioCard`
- `VitCard(variant: VitCardVariant.hero, radius: VitCardRadius.lg)`
- `_PortfolioGlow`
- `VitCtaButton`

Content:

- Label: `Tong tai san (USDT)`
- Eye toggle for privacy.
- Main balance.
- Daily PnL chip.
- Context label: `hom nay`
- Primary actions: `Nap`, `Rut`, `Vi`

UX role:

- This is the screen's highest-priority information block.
- It answers: "How much do I have?" and "What can I do next with money?"
- It also proves privacy support through the visibility toggle.

Visual role:

- Largest card on screen.
- Hero variant and glow create depth.
- Large numeric text gives financial hierarchy.
- CTA row anchors the card and converts overview into action.

AI implementation rule:

- Preserve privacy/masking behavior.
- Preserve financial action safety paths.
- Use tokenized typography such as `AppTextStyles.heroNumber`.
- Use `VitCtaButton` for the action row.
- Do not replace financial copy with marketing copy.

Reusable pattern for Wallet:

```text
Module title
-> wallet-specific hero label
-> masked/unmasked balance
-> equivalent/sub-balance
-> primary money actions
-> secondary wallet actions
```

---

### Layer 4 - Next Action

Implementation:

- `_HomeCommandCenter`
- `_SectionHeader(title: 'Tiep theo')`
- `_NextActionCard`
- `_CommandChip`

Content example:

- Title: `Hoan tat rut USDT`
- State: `Next`
- Subtitle: `TRC20 san sang, can xem lai phi va xac nhan 2FA`
- CTA: `Tiep tuc`

UX role:

- Turns Home into a resume hub.
- Reduces unfinished high-risk flows.
- Helps users continue a withdrawal or other task with context.

Financial safety role:

- The subtitle explicitly references fees and 2FA.
- This is not decorative copy; it is safety guidance.

AI implementation rule:

- Do not delete fee, risk, confirmation, 2FA, or next-step copy.
- For financial tasks, keep the pending action context specific.
- Use one clear CTA label.

---

### Layer 5 - Recent Products

Implementation:

- `_HomeCommandCenter`
- `_SectionHeader(title: 'Gan day')`
- `_RecentProductTile`
- Horizontal `ListView.separated`

Content examples:

- `Spot / BTC/USDT / Spot order`
- `P2P / P2P USDT/VND / Escrow`
- `Earn / ETH staking / Earn`

UX role:

- Provides memory of recent activity.
- Lets users jump back into recently used contexts.
- Reduces reliance on the larger product grid.

Visual role:

- Horizontal cards.
- Fixed-width tiles.
- Compact icon + status chip + title + context.

AI implementation rule:

- Keep recent items horizontally scrollable.
- Keep labels compact.
- Ensure each tile has a real destination route.

---

### Layer 6 - Product Grid

Implementation:

- `_SectionHeader(title: 'San pham')`
- `_QuickActionsGrid`
- `VitServiceTile`
- `VitServiceTileDensity.compact` below the Home density breakpoint

Content examples:

- `Mua nhanh`
- `Convert`
- `Nap/Rut`
- `P2P`
- `Mua dinh ky`
- `Staking`
- `Tiet kiem`
- `Launchpad`
- `Du doan`

Behavior:

- Compact screens show fewer primary actions.
- Remaining products are available via `Xem them` bottom sheet.

UX role:

- This is the app launcher.
- It balances broad product access with scan-friendly 3-column density.

Visual role:

- 3-column grid.
- Small cards.
- Icon, label, and badge.
- Accent strip/color helps category differentiation.

AI implementation rule:

- Do not blind-add every route into the primary grid.
- Prioritize by usage, money relevance, and user task frequency.
- Keep compact density safe for 360px width.
- Use `VitServiceTile`, not custom local grid cards.

Known current note:

- Market tab labels currently include emoji-like text. If strict enterprise polish is required, replace with icon widgets from the app icon system instead of text emoji.

---

### Layer 7 - Discovery Boundary

Implementation:

- `_HomeDiscoverySection`
- `_DiscoveryCard`
- `VitStatusPill`

Content:

- `Prediction Markets`
- `Open Arena`
- Boundary copy: Predictions use real positions; Arena uses Points, not real money.

UX role:

- Introduces adjacent product areas after core product access.
- Makes the Prediction/Arena distinction explicit.

Financial safety role:

- Keeps wallet/cash concepts separate from Arena Points.
- Prevents misleading payout or profit expectations in Arena.

AI implementation rule:

- Never merge Prediction and Arena financial language.
- Arena copy must stay points-only.
- Prediction copy may use positions, probability, portfolio, and P/L where appropriate.

---

### Layer 8 - Market Section

Implementation:

- `_MarketSection`
- `_SectionHeader(title: 'Thi truong')`
- `VitTabBar`
- `_MarketRow`
- `_SparklinePainter`

Content:

- Tabs: Hot, gainers, losers, new.
- Rows: coin avatar, pair, volume, sparkline, price, percent change.

UX role:

- Gives market pulse inside Home.
- Allows transition from account overview to trading context.
- Makes Home useful even when the user is not performing a wallet task.

Visual role:

- Data-dense card.
- Rows with clear left/middle/right structure.
- Green/red movement colors.
- Sparkline adds trend recognition without requiring a full chart.

AI implementation rule:

- Preserve tab switching.
- Keep numeric values tabular.
- Use buy/sell color tokens only for directional movement.
- Do not rely on color alone where compliance copy matters.

---

### Layer 9 - Trending And Ranked Lists

Implementation:

- `_TrendingSection`
- `_RankedListSection`
- `_RankedRow`
- `_CoinAvatar`

Content:

- `Xu huong`
- `Top tang gia`
- `Top giam gia`

UX role:

- Creates lower-page market discovery.
- Encourages exploration into pair detail routes.
- Separates broad market overview from ranked lists.

Visual role:

- Trending uses horizontal cards.
- Ranked lists use vertical rows.
- Percent badges carry green/red emphasis.

AI implementation rule:

- Keep ranked rows compact.
- Keep rank, asset, and movement easy to scan.
- Do not use oversized cards for every market item; the lower page should stay dense.

---

## 4. Screen Reading Order

For AI agents, the practical hierarchy is:

```text
1. Global identity and global actions
2. Timely notice
3. Account balance and money actions
4. Resume task
5. Recent contexts
6. Product launcher
7. Product discovery with safety boundaries
8. Market pulse
9. Market exploration and ranked lists
```

If applying Home style to another screen, preserve this order conceptually:

```text
Module identity
-> module-specific hero
-> primary action cluster
-> resume/status/context card
-> local tools or recent items
-> data lists
-> secondary discovery
```

---

## 5. Design Tokens And Visual Language

### Color

Home uses VitTrade dark financial tokens:

| Token Type | Examples |
| --- | --- |
| Background/surface | `AppColors.surface`, `surface2`, `cardBg` |
| Primary/trust | `AppColors.primary`, `primary08`, `primary12`, `primary20` |
| Financial movement | `AppColors.buy`, `buy10`, `buy15`, `sell`, `sell10`, `sell20` |
| Discovery/accent | `AppColors.accent`, `accent15`, `accent20` |
| Warning/Arena | `AppColors.warn`, `warn10`, `warn15`, `warningBorder` |
| Text | `AppColors.text1`, `text2`, `text3` |

Rules:

- Use primary/gold for trust and main actions.
- Use green/red only for directional market movement.
- Use purple/accent for discovery or advanced product paths.
- Use warning/amber for Arena or caution-adjacent surfaces.
- Do not invent local colors in Home-like financial screens.

### Typography

Home uses `AppTextStyles` tokens:

| Purpose | Token Examples |
| --- | --- |
| Hero balance | `heroNumber` |
| Section title | `sectionTitle` |
| Body row title | `body` |
| Small metadata | `caption`, `micro` |
| Numeric values | token style plus `AppTextStyles.tabularFigures` |

Rules:

- Use tabular figures for money, price, percentage, and market values.
- Keep section titles prominent but not hero-sized.
- Do not use local `TextStyle(...)`, local `fontSize`, or local `fontFamily` outside theme.

### Spacing

Important Home spacing tokens:

| Purpose | Token |
| --- | --- |
| Page side padding | `AppSpacing.contentPad` |
| Native shell gap | `AppSpacing.homeNativeShellCustomGap` |
| Hero action height | `AppSpacing.homeHeroActionHeight` |
| Recent product size | `homeRecentProductWidth`, `homeRecentProductHeight` |
| Section header line height | `homeSectionHeaderTitleLineHeight` |
| Market row/card gaps | `homeMarketIconGap`, `homeMarketSectionGap` |
| Bottom safety inset | `homeBottomSheetScrollInset`, `homeBottomSheetScrollInsetVisual` |

Rules:

- Keep Home dense but not cramped.
- Use compact gaps for command-center blocks.
- Use stronger spacing before major section transitions.
- Always account for bottom nav.

---

## 6. Measurement Model

All dimensions in this report use **Flutter logical dp** unless explicitly
marked as physical pixels. Do not use physical pixels as layout constants.

Current observed emulator evidence:

| Metric | Value |
| --- | --- |
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

Home uses `AppSpacing.contentPad = 20`, so content width is:

| Viewport | Formula | `contentWidth` |
| --- | --- | --- |
| Minimum phone | `360 - 40` | `320 dp` |
| QA phone | `440 - 40` | `400 dp` |
| Current emulator | `448 - 40` | `408 dp` |
| Large phone | `480 - 40` | `440 dp` |

Primary Home cards fill `contentWidth`. They should not add local external
horizontal margin. Internal card padding can vary by component, but the outer
card should align to the same left and right content rail.

Implementation anchors:

- `VitPageContent` adds `left/right = AppSpacing.contentPad`.
- Home uses `VitContentPadding.compact`, so top content padding is `8`.
- Home native vertical gap uses `AppSpacing.homeNativeShellCustomGap = 12`.
- Shared default card padding is `AppSpacing.cardPadding = 16`.
- Shared compact card padding is `AppSpacing.cardPaddingCompact = 12`.

---

## 7. Typography Matrix

Use this matrix when deciding Home-like typography. These are source tokens
from `AppTextStyles`; do not recreate them locally.

| Token | Size | Height | Approx line box | Weight baseline | Primary Home use |
| --- | ---: | ---: | ---: | --- | --- |
| `microTiny` | `7` | `1.0` | `7 dp` | `normal` | Tiny internal labels only |
| `micro` | `10` | `1.5` | `15 dp` | `normal` | Metadata, badges, helper text |
| `captionSm` | `12` | `1.5` | `18 dp` | `normal` | Compact labels when `micro` is too small |
| `caption` | `13` | `1.5` | `19.5 dp` | `normal` | Banner text, chips, section actions |
| `body` | `14` | `1.5` | `21 dp` | `normal` | Row titles, card titles |
| `base` | `16` | `1.5` | `24 dp` | `normal` | Secondary numeric emphasis |
| `sectionTitle` | `21` | `1.272` | `~26.7 dp` | `bold` | Home section headers |
| `pageTitle` | `26` | `1.272` | `~33.1 dp` | `bold` | Page-level titles outside compact panels |
| `heroNumber` | `34` | `1.272` | `~43.2 dp` | `bold` | Portfolio balance hero |

Home-specific typography rules:

- Money, price, percentage, amount, and market values use tabular figures.
- `heroNumber` already includes `AppTextStyles.tabularFigures`.
- If a numeric value uses another token, add
  `fontFeatures: AppTextStyles.tabularFigures`.
- Section headers use `sectionTitle` with
  `height: AppSpacing.homeSectionHeaderTitleLineHeight`.
- Compact service tiles use `micro` in compact density and `caption` in
  standard density.
- Do not use local `TextStyle(...)`, local `fontSize`, local `fontFamily`, or
  direct hardcoded `FontWeight.w800/w900` outside theme.
- Do not scale font size with viewport width. Change layout density, wrapping,
  max lines, or token choice instead.

Recommended token mapping for Home-like modules:

| UI part | Preferred token |
| --- | --- |
| Hero balance | `heroNumber` |
| Hero label | `caption` + medium weight |
| Hero PnL chip | `caption` + medium/bold weight |
| Hero supporting text | `micro` |
| Section header | `sectionTitle` |
| Section action | `caption` + medium weight |
| Card title | `body` + bold/medium weight |
| Card metadata | `micro` |
| Grid tile label compact | `micro` + bold weight |
| Grid tile label standard | `caption` + bold weight |
| Market row symbol | `body` + medium weight |
| Market row price | `body` + tabular figures |
| Market row change | `micro` + medium weight |

---

## 8. Card And Spacing Metrics

This section describes how Home cards consume screen width. All outer primary
cards align to the same `contentWidth` rail unless the component is explicitly
horizontal-scroll content.

### Announcement Banner

Implementation: `_AnnouncementBanner`

| Metric | Value |
| --- | --- |
| Outer width | `contentWidth` |
| Card radius | `VitCardRadius.sm` |
| Horizontal padding | `14` |
| Vertical padding | `10` |
| Leading icon | `18` |
| Icon-to-text gap | `12` |
| Trailing chevron | `16` |
| Text token | `caption` |
| Dot active size | `16w x 5h` |
| Dot inactive size | `5w x 5h` |
| Dot gap | `5` |

Width math:

```text
innerWidth = contentWidth - 28
textWidth = innerWidth - 18 icon - 12 gap - 8 arrowGap - 16 chevron
```

At `360dp`, `textWidth ~= 238 dp`. Keep announcement copy short and use one
line with ellipsis.

### Portfolio Hero

Implementation: `_PortfolioCard`

| Metric | Value |
| --- | --- |
| Outer width | `contentWidth` |
| Variant | `VitCardVariant.hero` |
| Radius | `VitCardRadius.lg` |
| Horizontal padding | `14` |
| Top padding | `homePortfolioBadgeVerticalPadding + x1 = 7` |
| Bottom padding | `4` |
| Header eye icon | `18` |
| Header eye tap padding | `6` |
| Hero number token | `heroNumber` |
| PnL chip padding | `10h / 4v` |
| PnL icon | `12` |
| Action row top gap | `8` |
| CTA height | `44` |
| CTA gap | `10` |

CTA width formula:

```text
buttonWidth = (contentWidth - heroHorizontalPaddingTotal - actionGapsTotal) / 3
buttonWidth = (contentWidth - 28 - 20) / 3
```

CTA widths by viewport:

| Viewport | Content | Button width |
| --- | ---: | ---: |
| `360dp` | `320` | `90.67 dp` |
| `440dp` | `400` | `117.33 dp` |
| `448dp` emulator | `408` | `120 dp` |
| `480dp` | `440` | `130.67 dp` |

Rules:

- Keep three CTAs only when labels are short.
- If a module needs longer labels, use two primary buttons plus secondary
  chips below.
- Preserve the privacy toggle and numeric hierarchy.

### Next Action Card

Implementation: `_NextActionCard`

| Metric | Value |
| --- | --- |
| Outer width | `contentWidth` |
| Padding | `14` |
| Icon box | `42w x 42h` |
| Icon size | `20` |
| Icon-to-text gap | `12` |
| Inner label gap | `6` |
| Chip min height | `20` |
| Chip padding | `7h / 4v` |
| Chevron gap | `4` |
| Chevron size | `18` |
| Title token | `body` |
| Subtitle token | `micro` |
| CTA token | `caption` |

Layout model:

```text
cardWidth = contentWidth
innerWidth = contentWidth - 28 padding
textColumnWidth = innerWidth - 42 icon - 12 gap - ctaWidth - 4 gap - 18 chevron
```

Keep title and subtitle to one line with ellipsis. This card is a resume
surface, not a long explanation block.

### Recent Product Rail

Implementation: `_RecentProductTile`

| Metric | Value |
| --- | --- |
| Tile size | `146w x 86h` |
| Rail height | `86` |
| Tile horizontal gap | `10` |
| Tile padding | `12h / 5v` |
| Icon box | `28w x 28h` |
| Icon text size | `15` |
| Title token | `caption` |
| Metadata token | `micro` |

Visible capacity:

| Viewport | Content | Approx visible tiles |
| --- | ---: | ---: |
| `360dp` | `320` | `2 full + partial` |
| `440dp` | `400` | `2 full + strong partial` |
| `448dp` emulator | `408` | `2 full + strong partial` |
| `480dp` | `440` | `2 full + near-full partial` |

The partial trailing tile is intentional; it signals horizontal scroll without
requiring additional text.

### Product Grid

Implementation: `_QuickActionsGrid` + `VitServiceTile`

| Metric | Compact | Standard |
| --- | ---: | ---: |
| Density breakpoint | `<410dp` | `>=410dp` |
| Primary item count | `9` | `12` |
| Columns | `3` | `3` |
| Cross/main gap | `8` | `8` |
| Aspect ratio | `1.88` | `1.68` |
| Tile padding | `6` | `8` |
| Icon box | `22` | `26` |
| Icon size | `16` | `20` |
| Label gap | `2` | `3` |
| Label token | `micro` | `caption` |
| Badge max width | `52` | `52` |
| Top stripe | `2h` | `2h` |

Grid formula:

```text
tileWidth = (contentWidth - (gridGap * 2)) / 3
tileHeight = tileWidth / aspectRatio
```

Grid sizes:

| Viewport | Density | Content | Tile width | Tile height |
| --- | --- | ---: | ---: | ---: |
| `360dp` | Compact | `320` | `101.33` | `53.90` |
| `440dp` | Standard | `400` | `128.00` | `76.19` |
| `448dp` emulator | Standard | `408` | `130.67` | `77.78` |
| `480dp` | Standard | `440` | `141.33` | `84.13` |

Rules:

- Tile height derives from aspect ratio, not fixed hardcode.
- Keep label to one line.
- Keep badge short because badge max width is `52`.
- If a tile needs more explanatory copy, it does not belong in this grid.

### Discovery Card

Implementation: `_DiscoveryCard`

| Metric | Value |
| --- | --- |
| Outer width | `contentWidth` |
| Padding | `16` |
| Icon box | `44w x 44h` |
| Icon size | `20` |
| Icon-to-content gap | `12` |
| Title token | `body` |
| Subtitle token | `micro` |
| Action token | `micro` |
| Trailing chevron | `16` |

Layout model:

```text
innerWidth = contentWidth - 32
contentColumn = innerWidth - 44 icon - 12 gap - 16 chevron
```

At `360dp`, `contentColumn ~= 216 dp`, so title/subtitle must stay compact.

### Market Row

Implementation: `_MarketRow`

| Metric | Value |
| --- | --- |
| Outer width | `contentWidth` |
| Row padding | `16h / 14v` |
| Coin avatar | `34w x 34h` |
| Avatar gap | `12` |
| Sparkline | `64w x 30h` |
| Sparkline gap | `12` |
| Right value column | `85w` |
| Divider height | `1` |
| Symbol token | `body` |
| Volume token | `micro` |
| Price token | `body` + tabular figures |
| Change token | `micro` |

Content width model:

```text
rowInnerWidth = contentWidth - 32
leftTextColumn = rowInnerWidth - 34 avatar - 12 gap - 64 sparkline - 12 gap - 85 valueColumn
```

At `360dp`, `leftTextColumn ~= 81 dp`; symbols must be short and secondary
text should be ellipsized if needed.

### Trending Rail

Implementation: `_TrendingSection`

| Metric | Value |
| --- | --- |
| Rail height | `128` |
| Tile width | `148` |
| Tile padding | `16` |
| Tile gap | `12` |
| Icon size | `28` |
| Asset token | `body` |
| Price token | `base` + tabular figures |
| Change token | `micro` |

Visible capacity:

| Viewport | Content | Approx visible tiles |
| --- | ---: | ---: |
| `360dp` | `320` | `2 full + partial` |
| `440dp` | `400` | `2 full + strong partial` |
| `480dp` | `440` | `2 full + near-full partial` |

### Ranked Row

Implementation: `_RankedRow`

| Metric | Value |
| --- | --- |
| Outer width | `contentWidth` |
| Row padding | `16h / 14v` |
| Rank chip width | `20` |
| Row item gap | `12` |
| Coin avatar | `34` |
| Percent badge padding | `12h / 6v` |
| Rank token | `caption` |
| Pair token | `body` |
| Percent token | `caption` |

Rules:

- Use vertical ranked rows for dense comparative scanning.
- Keep rank, asset, and percentage visible.
- Avoid additional metadata unless the row height is intentionally increased.

---

## 9. Screen Utilization Rules

### Full-Width Content Rule

Primary vertical cards use the available `contentWidth`:

```text
outerCardWidth = viewportWidthDp - 40
```

This keeps the screen filled while preserving a consistent 20dp left/right
touch-safe gutter. Do not add another horizontal margin around primary cards.

### Horizontal Scroll Rule

Recent and trending rails use fixed item widths and intentionally expose a
partial next card:

```text
visibleHint = contentWidth - (fullTiles * itemWidth) - gaps
```

This hint teaches scrollability without adding instructional text. Use it only
for optional discovery content, not mandatory financial actions.

### Dense Grid Rule

The product launcher fills 3 columns:

```text
tileWidth = (contentWidth - 16) / 3
tileHeight = tileWidth / densityAspectRatio
```

Use compact density below `410dp`. Do not force four columns on phone. Do not
increase copy length inside the tile to compensate for missing navigation.

### Vertical Density Rule

Home uses a descending density pattern:

```text
hero = largest block
next action = medium block
recent/products = compact navigation
market/ranked = dense data
```

Do not make every section a hero card. The screen works because the largest
visual treatment appears once, then the rest becomes progressively denser.

### Bottom Safety Rule

Bottom navigation reserves shell space:

| Mode | Bottom chrome |
| --- | ---: |
| Native | `72 dp` |
| Visual QA | `90 dp` |

Home adds extra scroll inset:

| Mode | Extra inset |
| --- | ---: |
| Native | `homeBottomSheetScrollInset = 16` |
| Visual QA | `homeBottomSheetScrollInsetVisual = 40` |

Keep this pattern for Home-like pages so the last row can scroll above the
bottom nav and remain tappable.

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

Use `rootBrand` for Home only. Module pages should use module chrome while
keeping the same content rail and section rhythm.

### Touch Target Rule

Use these minimums:

- Hero CTAs: `44h`.
- Header action buttons: `40w x 40h`.
- Bottom nav item area: `52h`.
- Compact chips: `20h`, only for status labels, not primary actions.
- Financial actions should not be smaller than compact CTA height.

---

## 10. Interaction Model

| Interaction | Behavior | UX Intent |
| --- | --- | --- |
| Scroll down | Header collapses | Give content more vertical space |
| Scroll up | Header returns | Restore global actions |
| Eye toggle | Masks/unmasks portfolio balance | Privacy in public spaces |
| Hero CTA | Opens deposit, withdraw, wallet | Direct financial action |
| Next action card | Resumes pending workflow | Reduce abandoned financial task |
| Recent tile | Opens recent product context | Fast return |
| Product tile | Opens module route | App launcher |
| `Xem them` | Opens more products sheet | Keep primary grid compact |
| Market tab | Switches market list | Explore market subsets |
| Market/ranked row | Opens pair detail | Convert insight to action |

---

## 11. Accessibility And UX Notes

Strengths:

- Most interactive surfaces expose semantic labels through Flutter widgets.
- Bottom navigation remains visible.
- Balance masking is present.
- Financial actions are large enough for touch.
- Home route is covered by responsive visual QA.

Risks:

- Some labels in source appear mojibake in file display, though emulator UI renders Vietnamese correctly.
- Market tab labels include emoji-like characters. These are visually expressive but less enterprise-consistent than icon widgets.
- Header collapse can hide search/notification while deep-scrolling.
- Horizontal lists require users to discover sideways scrolling.

AI recommendations:

- If changing tabs, replace text emoji with icon widgets and keep labels.
- Keep horizontal scroll sections only where recency/trending is valuable.
- Do not hide critical financial actions only inside horizontal scroll.
- Validate at 360px, 440px, and 480px phone widths.

---

## 12. Home As A Template For Wallet

When using Home as the visual standard for Wallet, copy these concepts:

1. A strong hero card.
2. Large financial number.
3. Privacy toggle.
4. Primary CTA row.
5. Compact secondary action row or chips.
6. Section headers with optional action link.
7. Card hierarchy: hero first, dense lists below.
8. Bottom nav clearance.

Do not copy:

- `VitTrade` brand header into module pages.
- Product launcher wholesale.
- Prediction/Arena discovery unless the module needs it.
- Home-specific market rankings into wallet-specific surfaces.

Wallet-specific adaptation:

```text
Vi tai san
-> wallet balance hero
-> deposit / withdraw / transfer
-> buy / history compact actions
-> Tai san / Phan bo
-> search/filter/assets
-> DCA card
-> wallet tools
```

Safety requirements:

- Preserve masking.
- Preserve available/in-order/frozen breakdown.
- Preserve deposit, withdraw, transfer, buy, history navigation.
- Preserve service unavailable and fail-closed copy.
- Do not remove fee, limit, risk, preview, confirmation, masking, or next-step copy.

---

## 13. AI Implementation Checklist

Before changing Home or a Home-like page:

- [ ] Read `AGENTS.md`.
- [ ] Read `docs/00_START_HERE.md`.
- [ ] Inspect current screen source files.
- [ ] Inspect shared primitives before creating local widgets.
- [ ] Use `VitPageLayout`, `VitPageContent`, `VitCard`, `VitCtaButton`, `VitTabBar`, `VitServiceTile` where applicable.
- [ ] Use `AppColors`, `AppSpacing`, `AppTextStyles`, and density tokens.
- [ ] Preserve route paths and semantic keys unless the task explicitly changes them.
- [ ] Preserve financial safety copy.
- [ ] Verify 360px layout does not overflow.
- [ ] Run focused tests for touched module.
- [ ] Run `flutter analyze`.
- [ ] Run `dart run tool/design_token_consistency_audit.dart --check`.

---

## 14. Recommended Verification For Home-Like Changes

Run from `flutter_app/`:

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

If validating on emulator:

```bash
flutter run -d emulator-5554 --debug --no-resident
adb -s emulator-5554 exec-out screencap -p > run-artifacts/home_after_change.png
adb -s emulator-5554 exec-out uiautomator dump /dev/tty > run-artifacts/home_after_change.xml
```

---

## 15. Key Takeaways For Future AI Agents

- Home is the app command center, not a marketing page.
- The first viewport must answer: identity, assets, money actions, next task.
- Use Home's hierarchy and rhythm for Wallet, but keep Wallet's module identity.
- Financial UI must preserve safety, masking, fees, risk, and confirmation context.
- Use shared primitives and tokens; do not create local hardcoded typography or colors.
- Keep dense market/product sections below the financial hero.
- Validate every visual change against small-phone responsive QA.
