# Flutter Design Tokens

Use this file to translate React/CSS tokens into Flutter constants. Source of truth: `src/styles/theme.css` and `src/app/hooks/useThemeColors.ts`.

`SC-007 HomePage` now defines the approved native Flutter brand treatment: a Bybit-inspired dark orange palette on a cleaner neutral dark background. This is a Flutter native runtime standard and does not overwrite the React screenshot baseline under `output/flutter-ui-reference/screenshots/`.

## Token Rules

- Do not hardcode repeated colors, spacing, radii, typography, or device metrics inside screens.
- Add shared values to `flutter_app/lib/app/theme/` first.
- If this file conflicts with screenshots, the screenshot wins and this file must be updated.
- If a one-off screen value is required, document it in the screen-specific blueprint for that `SC-xxx`.

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

React utility spacing may use 4pt/Tailwind values. When a screenshot proves a value, match the screenshot even if the token scale differs.

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
