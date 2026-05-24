# Flutter Design Tokens

Use this file to define Flutter constants for the native app. The global native source of truth is `docs/02_FLUTTER_MIGRATION/Flutter-Native-Design-Standard.md` and the approved `SC-007 HomePage` native implementation. React/CSS tokens in `src/styles/theme.css` and `src/app/hooks/useThemeColors.ts` are historical inputs for visual-QA parity, not authority for Flutter native brand drift.

`SC-007 HomePage` now defines the approved native Flutter brand treatment: a Bybit-inspired dark orange palette on a cleaner neutral dark background. This is a Flutter native runtime standard and does not overwrite the React screenshot baseline under `output/flutter-ui-reference/screenshots/`.

For module-level identity rules, see `docs/02_FLUTTER_MIGRATION/Flutter-Module-Identity-Standard.md`. Module identity is an accent layer and must not override the Home foundation tokens below.

## Token Rules

- Do not hardcode repeated colors, spacing, radii, typography, or device metrics inside screens.
- Add shared values to `flutter_app/lib/app/theme/` first.
- If this file conflicts with screenshots during `ShellRenderMode.visualQa`, the screenshot wins for React parity and this file must be updated when the token is wrong.
- In `ShellRenderMode.native`, the approved `SC-007 HomePage` native standard wins for global brand color, neutral dark surfaces, chrome sizing, and shared card treatment unless the `SC-xxx` blueprint explicitly documents a screen-specific exception.
- If a one-off screen value is required, document it in the screen-specific blueprint for that `SC-xxx`.
- If a repeated value is needed by more than one screen, add it to `flutter_app/lib/app/theme/` before reuse.

## Native Brand Enforcement

The Flutter native runtime must use Home as the practical brand standard, not a per-screen legacy React palette.

- Use `AppColors.primary`, `AppColors.primaryDark`, and `AppColors.primarySoft` for brand accents, selected states, primary CTAs, focus borders, active chips, and active nav.
- Use `AppColors.bg`, `AppColors.surface`, `AppColors.surface2`, `AppColors.surface3`, `AppColors.cardBorder`, `AppColors.divider`, and `AppColors.borderSolid` for page backgrounds, cards, panels, dividers, and inputs.
- Legacy React blue values such as `#3B82F6` are not the default Flutter native brand color. Use them only when a screen-specific reference documents a non-brand semantic accent.
- Screen-local color aliases are allowed only as readability aliases to shared tokens, for example `const _apiBg = AppColors.bg;`. Do not introduce repeated local `Color(0x...)` palettes for backgrounds, surfaces, borders, or brand accents.
- Keep semantic state colors separate: success uses `AppColors.buy`, danger uses `AppColors.sell`, warning uses `AppColors.warn`, and secondary technical accents can use `AppColors.accent` when the screen meaning requires it.
- Bottom navigation active state is not module-specific. Home, Markets, Trade, Wallet, and Profile all use `AppColors.navActive`.

## AppColors

| Flutter token | React token | Value |
| --- | --- | --- |
| `AppColors.bg` | Flutter native brand override | `0xFF07090D` |
| `AppColors.surface` | Flutter native brand override | `0xFF10141B` |
| `AppColors.surface2` | Flutter native brand override | `0xFF171C24` |
| `AppColors.surface3` | Flutter native brand override | `0xFF222936` |
| `AppColors.borderSolid` | Flutter native brand override | `0xFF2D3440` |
| `AppColors.primary` | Flutter native brand override | `0xFFE58A00` |
| `AppColors.primaryDark` | Flutter native brand override | `0xFFB96000` |
| `AppColors.primarySoft` | Flutter native brand override | `0xFFF5A524` |
| `AppColors.buy` | `--tr-buy` | `0xFF10B981` |
| `AppColors.sell` | `--tr-sell` | `0xFFEF4444` |
| `AppColors.warn` | Flutter native brand override | `0xFFF5A524` |
| `AppColors.accent` | `--tr-accent` | `0xFF8B5CF6` |
| `AppColors.text1` | Flutter native brand override | `0xFFF5F7FA` |
| `AppColors.text2` | Flutter native brand override | `0xFFA7AFBF` |
| `AppColors.text3` | Flutter native brand override | `0xFF667085` |
| `AppColors.navInactive` | Flutter native brand override | `0xFF667085` |
| `AppColors.navActive` | Flutter native brand override | `0xFFE58A00` |
| `AppColors.searchBg` | Flutter native brand override | `0xFF171C24` |
| `AppColors.searchBorder` | Flutter native brand override | `0xFF2D3440` |
| `AppColors.statusBattery` | `--tr-status-bar-battery` | `0xFF34D399` |

## AppModuleAccents

Use `AppModuleAccents` when a module needs a restrained identity marker for icons, badges, chart markers, hero borders, or pills. Do not use these tokens for page backgrounds, ordinary card backgrounds, inputs, bottom navigation, or CTA sizing.

| Flutter token | Intended use |
| --- | --- |
| `AppModuleAccents.home` | Home discovery, shortcut, and brand-forward accents |
| `AppModuleAccents.markets` | Markets analytics, chart metadata, and discovery accents |
| `AppModuleAccents.trade` | Trade action/focus accents that are not buy/sell |
| `AppModuleAccents.wallet` | Wallet asset/security accents |
| `AppModuleAccents.profile` | Profile/account neutral accents |
| `AppModuleAccents.predictions` | Prediction Markets domain accents |
| `AppModuleAccents.arena` | Arena Points-only domain accents |

Alpha tokens should be implemented as named helpers, for example:

```dart
static const primary12 = Color(0x1FE58A00);
static const buy15 = Color(0x2610B981);
static const sell15 = Color(0x26EF4444);
static const warn08 = Color(0x14F5A524);
```

## AppGradients

| Flutter token | React token | Value |
| --- | --- | --- |
| `AppGradients.navCenter` | Flutter native brand override | `#E58A00 -> #B96000`, 135deg |
| `AppGradients.portfolio` | Flutter native brand override | `#2A1A05 -> #15120D -> #07090D`, 145deg |
| `AppGradients.frameOuter` | Flutter native brand override | radial top glow `#17110A -> #050607` |

Use `LinearGradient` or `RadialGradient` in shared widgets, not inside each screen.

## Native Hero/Portfolio Card Treatment

Use the approved `SC-007 HomePage` portfolio card as the native standard for high-value hero cards:

| Treatment | Native standard |
| --- | --- |
| Hero card widget | `VitCard(variant: VitCardVariant.hero)` |
| Hero card gradient | `AppGradients.portfolio` |
| Hero card shadow | `BoxShadow(color: AppColors.primary08, blurRadius: 12, spreadRadius: -4, offset: Offset(0, 4))` |
| Portfolio inner glow | `RadialGradient(center: Alignment(0.58, -0.68), radius: 0.82)` |
| Portfolio glow colors | `AppColors.primary12 -> AppColors.primary08.withValues(alpha: 0.08) -> Colors.transparent` |
| Portfolio glow stops | `[0, 0.36, 1]` |

Do not increase right-edge or bottom-edge glow on native hero cards unless a screen-specific reference explicitly requires it.

## AppTextStyles

| Token | Size | Use |
| --- | ---: | --- |
| `micro` | 10 | timestamps, badges, dense labels |
| `caption` | 13 | secondary descriptions |
| `body` | 14 | standard rows and list text |
| `base` | 16 | readable labels and primary text |
| `sectionTitle` | 21 | section headings |
| `pageTitle` | 26 | page titles |
| `heroNumber` | 34 | balances, prices, major numbers |
| `display` | 43 | onboarding/display headings |
| `jumbo` | 55 | rare splash/hero use only |

Font weights:

| Token | Weight |
| --- | ---: |
| `normal` | 400 |
| `medium` | 600 |
| `bold` | 700 |

Use tabular figures for financial values where possible.

## AppSpacing

| Token | Value |
| --- | ---: |
| `x1` | 3 |
| `x2` | 5 |
| `x3` | 8 |
| `x4` | 13 |
| `x5` | 21 |
| `x6` | 34 |
| `x7` | 55 |
| `contentPad` | 20 |
| `sectionGap` | 20 |
| `rowPy` | 14 |
| `inputHeight` | 52 |
| `ctaHeight` | 52 |
| `buttonCompact` | 34 |
| `buttonStandard` | 55 |
| `buttonHero` | 89 |
| `iconSm` | 13 |
| `iconMd` | 21 |
| `iconLg` | 34 |

React utility spacing may use 4pt/Tailwind values in the legacy source. In Flutter native, prefer the Home token scale above; match screenshots for structure in `ShellRenderMode.visualQa`, then normalize repeated native spacing back to these tokens.

## AppRadii

| Token | Value |
| --- | ---: |
| `xs` | 5 |
| `sm` | 8 |
| `md` | 13 |
| `input` | 14 |
| `card` | 16 |
| `lg` | 21 |
| `cardLarge` | 24 |
| `xl` | 34 |
| `device` | 55 |

## DeviceMetrics

| Token | Value |
| --- | ---: |
| `width` | 440 |
| `height` | 956 |
| `safeTop` | 59 |
| `safeBottom` | 34 |
| `tabBar` | 56 |
| `bottomChrome` | 90 |
| `nativeBottomChrome` | 56 |
| `contentPad` | 20 |
| `dynamicIslandWidth` | 126 |
| `dynamicIslandHeight` | 37 |
| `dynamicIslandTop` | 11 |
| `homeBarWidth` | 134 |
| `homeBarHeight` | 5 |

Flutter screenshots for visual QA must use `440x956`.

`bottomChrome` is the visual QA bottom chrome height used with the fake phone frame. `nativeBottomChrome` is the real-device/emulator bottom navigation height used by `ShellRenderMode.native`.

## Native Home Layout Standard

`SC-007 HomePage` is the current Flutter native UX standard:

| Value | Native standard |
| --- | --- |
| Home outer content gap | `12` |
| Home bottom scroll inset | `DeviceMetrics.nativeBottomChrome + MediaQuery.padding.bottom + 16` |
| Native bottom nav | Compact `56` height, auto-hides on downward vertical scroll |
| Visual QA bottom nav | Full `90` height, always visible for reference parity |
| Flutter native brand color | Bybit-inspired dark orange `0xFFE58A00`, with `0xFFB96000` as the darker gradient stop |
| Flutter native background | Neutral dark/OLED-clean charcoal, not blue-tinted |
| Flutter native hero card | Dark portfolio gradient with restrained orange shadow/glow |

Do not apply native spacing changes to `ShellRenderMode.visualQa` unless the visual QA reference is intentionally updated.

## Conversion Gate

Before a new Flutter screen is marked done:

- repeated background/surface/brand colors use `AppColors`;
- repeated spacing and dimensions use `AppSpacing` or `DeviceMetrics`;
- repeated radii use `AppRadii`;
- repeated text sizes use `AppTextStyles`;
- any exception is documented in the screen-specific `SC-xxx` reference or master-plan notes.
