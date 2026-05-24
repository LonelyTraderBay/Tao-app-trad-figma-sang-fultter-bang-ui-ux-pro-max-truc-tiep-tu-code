# Flutter Component Mapping

Use this file before implementing any Flutter screen. It maps React primitives to Flutter shared widgets so screens do not reinvent layout, styling, color, or sizing. The native color and size authority is `Flutter-Native-Design-Standard.md`.

## Mapping Table

| React source | Flutter shared widget | Rule |
| --- | --- | --- |
| `MobileFrame` | `VitPhoneFrame` | Fixed visual QA frame at `440x956`, dynamic island, home indicator; use only in `ShellRenderMode.visualQa`. |
| `StatusBar` | `VitStatusBar` | Mock status bar for reference screenshots; use only in `ShellRenderMode.visualQa`. |
| `RootLayout` / `AppLayout` | `VitAppShell` | Owns route child, native/visual QA shell mode, and bottom nav visibility. |
| `PageLayout` | `VitPageLayout` | Enforces background, bottom padding, and page landmark. |
| `PageContent` | `VitPageContent` | Owns horizontal padding, top padding, and section gaps. |
| `PageSection` | `VitPageSection` | Labeled groups for cards, controls, and settings. |
| `Header` | `VitHeader` | Standard back button, centered title, optional subtitle/action/search/bell. |
| `BottomNav` | `VitBottomNav` | Five tabs only: Home, Markets, Trade, Wallet, Profile; compact and auto-hide in native mode; active color is always the Home brand token. |
| `TabBar` | `VitTabBar` | Variants: underline, pill, segment. |
| `TrCard` | `VitCard` | Dark surface card with tokenized border/radius. Use `VitCardVariant.hero` for native hero/portfolio cards with the approved Home gradient and restrained shadow. |
| `CTAButton` | `VitCtaButton` | Primary/auth use Home orange gradient; default height `52`, standard action height `55`. |
| `IconButton` | `VitIconButton` | Fixed touch target, token background, icon-only action. |
| `BottomSheetV2` | `VitBottomSheet` | Modal/bottom sheet with token radius and safe bottom. |
| `StatusPill` | `VitStatusPill` | Semantic status colors, no ad hoc pill styling. |
| Service/action tile grids | `VitServiceTile` | Primary service/action grids use typed icons plus controlled accent tokens; do not use emoji strings as UI icons. |
| Module hero panels | `VitModuleHeroCard` | Module-specific hero treatment must keep global surface/card rules and use accent only for border/glow/icon treatment. |
| Metric/stat cards | `VitMetricCard` | Repeated metric panels use shared surface, radius, spacing, typography, and optional semantic/accent icon treatment. |
| Section headers with module action | `VitModuleSectionHeader` | Repeated module section headers use shared text scale and optional controlled accent/action treatment. |
| `SearchBar` | `VitSearchBar` | Shared search field with 52px height and search tokens. |
| `InputField` / `TrInput` | `VitInput` | 52px height, 14px radius, validation/error state. |
| `EmptyState` | `VitEmptyState` | Shared empty state. |
| `ErrorState` | `VitErrorState` | Shared error/retry state. |
| `OfflineBanner` | `VitOfflineBanner` | Shared offline state. |
| `Skeleton` | `VitSkeleton` | Shared loading skeleton. |

## Shell Render Mode Rules

| Mode | Shell components | Bottom chrome |
| --- | --- | --- |
| `ShellRenderMode.native` | `VitAppShell` uses OS status bar and Flutter/OS safe areas. It must not render `VitPhoneFrame` or `VitStatusBar`. | `VitBottomNav` uses compact native height and may auto-hide on vertical scroll to maximize usable screen area. |
| `ShellRenderMode.visualQa` | `VitAppShell` is wrapped by `VitPhoneFrame` and renders `VitStatusBar` for reference captures. | `VitBottomNav` stays visible and uses the full visual QA bottom chrome. |

The current native UX standard is `SC-007 HomePage`: Home header hides on downward scroll, reappears on upward scroll, and the native bottom nav hides on downward scroll through `VitAppShell`. Use the approved Home dark orange brand, neutral dark surfaces, and softened portfolio/hero card treatment for later native Flutter screens.

## Home Native Component Sizes

| Component | Required native sizing |
| --- | --- |
| Page horizontal padding | `AppSpacing.contentPad = 20` |
| Standard section gap | `AppSpacing.sectionGap = 20` |
| Compact Home rhythm | `12` where used by shared Home/native layout |
| Input/search field | `AppSpacing.inputHeight = 52`, `AppRadii.input = 14` |
| Primary CTA | `AppSpacing.ctaHeight = 52`, Home orange gradient |
| Standard action button | `AppSpacing.buttonStandard = 55` |
| Compact chip/button | `AppSpacing.buttonCompact = 34` |
| Card | `AppRadii.card = 16`, `AppColors.surface`, `AppColors.cardBorder` |
| Hero card | `AppRadii.cardLarge = 24`, Home portfolio gradient/treatment |
| Native bottom nav | `DeviceMetrics.nativeBottomChrome = 56` |
| Visual QA bottom nav | `DeviceMetrics.bottomChrome = 90` |

## Card Rules

- Use `VitCard` for repeated cards and high-value hero panels; do not create screen-local card shells when an existing `VitCard` variant fits.
- Use `VitCardVariant.hero` for portfolio, balance, account-summary, or high-value CTA panels that need the approved dark gradient treatment.
- Keep hero-card shadow subtle in native runtime: use the documented `AppColors.primary08` shadow and avoid strong right/bottom glow.
- Use semantic `buy`, `sell`, `warn`, and `accent` colors for domain meaning; do not recolor gain/loss states with the brand orange.
- Module identity belongs in the accent layer only: icon color, pill/badge, chart marker, hero border/glow, or empty-state illustration. It must not become a page background, ordinary card background, input background, bottom-nav active color, or new radius/spacing scale.

## Layout Variants

Map React `PageLayout` variants directly:

| React variant | Flutter enum | Behavior |
| --- | --- | --- |
| `default` | `VitPageVariant.defaultPage` | `AppColors.bg`, bottom padding 32 |
| `surface` | `VitPageVariant.surface` | `AppColors.surface`, bottom padding 32 |
| `flush` | `VitPageVariant.flush` | `AppColors.bg`, no bottom padding; page owns sticky CTA |
| `immersive` | `VitPageVariant.immersive` | No default background; page owns hero/chart background |

## Header Rules

- Inner/detail screens use `VitHeader(title: ..., showBack: true)`.
- Module index screens may use page-style header with optional bell/search.
- Do not create custom header rows inside screens unless React source has a deliberate custom trading/chart header and screenshot confirms it.
- Breadcrumb behavior can be deferred in Flutter v1, but spacing must reserve the same visual structure when shown in the reference.

## Bottom Navigation Rules

- The only bottom nav tabs are Home, Markets, Trade, Wallet, Profile.
- Do not add Arena, P2P, Predictions, Earn, or Launchpad as bottom nav tabs.
- The center Trade tab uses the primary gradient button treatment.
- Do not assign module-specific active colors to bottom nav. Active nav uses `AppColors.navActive` for every tab.
- Native runtime uses compact bottom chrome and scroll-driven auto-hide.
- Visual QA runtime keeps the full bottom chrome visible for screenshot parity.
- Use the screenshot as the final authority for active tab state and badge placement.

## Screen Implementation Rule

Before building a screen:

1. Check whether a mapped shared widget already exists.
2. If missing, add the shared widget first.
3. Build the screen using shared widgets.
4. Only add screen-local widgets for content that is truly unique to that screen.
5. If screen-local constants are needed, they may alias shared tokens only.

Do not copy one-off styling into multiple screens. Promote repeated UI into `shared/widgets/` or `shared/layout/`.
