# Flutter Native Design Standard

This is the global Flutter native design contract for VitTrade phone screens.

`SC-007 HomePage` is the approved native reference for color, sizing, chrome behavior, spacing rhythm, and high-value card treatment. Use this file before building or converting any Flutter screen from the old React codebase.

## Authority

- Native runtime source of truth: `SC-007 HomePage` plus `docs/04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md`.
- Token source of truth: `flutter_app/lib/app/theme/` and `docs/02_FLUTTER_MIGRATION/Flutter-Design-Tokens.md`.
- React screenshots remain the source of truth for `ShellRenderMode.visualQa` structure, content, and scroll parity.
- React screenshots do not override the Flutter native Home standard for global brand color, neutral dark surfaces, native chrome size, card treatment, CTA styling, or shared component sizing.

## Required Native Palette

Use shared tokens only. Do not introduce repeated screen-local `Color(0x...)` palettes.

| Purpose | Token | Value |
| --- | --- | --- |
| App background | `AppColors.bg` | `0xFF07090D` |
| Primary card/panel surface | `AppColors.surface` | `0xFF10141B` |
| Secondary surface/input/chip | `AppColors.surface2` | `0xFF171C24` |
| Raised/strong surface | `AppColors.surface3` | `0xFF222936` |
| Solid border/focus off state | `AppColors.borderSolid` | `0xFF2D3440` |
| Soft card border | `AppColors.cardBorder` | `0x12FFFFFF` |
| Divider | `AppColors.divider` | `0x0DFFFFFF` |
| Brand primary | `AppColors.primary` | `0xFFE58A00` |
| Brand dark gradient stop | `AppColors.primaryDark` | `0xFFB96000` |
| Brand soft/warning | `AppColors.primarySoft` / `AppColors.warn` | `0xFFF5A524` |
| Success / buy / verified | `AppColors.buy` | `0xFF10B981` |
| Danger / sell / destructive | `AppColors.sell` | `0xFFEF4444` |
| Secondary domain accent | `AppColors.accent` | `0xFF8B5CF6` |
| Primary text | `AppColors.text1` | `0xFFF5F7FA` |
| Secondary text | `AppColors.text2` | `0xFFA7AFBF` |
| Muted text/nav inactive | `AppColors.text3` | `0xFF667085` |

Legacy React blue values such as `#3B82F6` are historical visual-QA colors. They are not the Flutter native brand.

## Required Native Sizes

Use Home-native dimensions unless a screen-specific reference documents a deliberate exception.

| Purpose | Token/value |
| --- | --- |
| Visual QA viewport | `DeviceMetrics.width = 440`, `DeviceMetrics.height = 956` |
| Native bottom nav/chrome | `DeviceMetrics.nativeBottomChrome = 56` |
| Visual QA bottom chrome | `DeviceMetrics.bottomChrome = 90` |
| Tab bar row | `DeviceMetrics.tabBar = 56` |
| Horizontal page padding | `AppSpacing.contentPad = 20` |
| Standard section gap | `AppSpacing.sectionGap = 20` |
| Home/native compact outer gap | `12` |
| Row vertical padding | `AppSpacing.rowPy = 14` |
| Input height | `AppSpacing.inputHeight = 52` |
| CTA height | `AppSpacing.ctaHeight = 52` |
| Compact button | `AppSpacing.buttonCompact = 34` |
| Standard button | `AppSpacing.buttonStandard = 55` |
| Hero action button | `AppSpacing.buttonHero = 89` |
| Small/medium/large icons | `13 / 21 / 34` |
| Input radius | `AppRadii.input = 14` |
| Standard card radius | `AppRadii.card = 16` |
| Large/hero card radius | `AppRadii.cardLarge = 24` |
| Large sheet/panel radius | `AppRadii.lg = 21` |

## Typography Scale

Do not create new repeated text sizes inside screens.

| Token | Size | Use |
| --- | ---: | --- |
| `AppTextStyles.micro` | 10 | timestamps, badges, dense labels |
| `AppTextStyles.caption` | 13 | secondary descriptions |
| `AppTextStyles.body` | 14 | standard rows and list text |
| `AppTextStyles.base` | 16 | readable labels and primary text |
| `AppTextStyles.sectionTitle` | 21 | section headings |
| `AppTextStyles.pageTitle` | 26 | page titles |
| `AppTextStyles.heroNumber` | 34 | balances, prices, major financial numbers |
| `AppTextStyles.display` | 43 | rare display/onboarding |
| `AppTextStyles.jumbo` | 55 | rare splash/hero only |

Financial values should use tabular figures where possible.

## Shared Component Contract

- Use `VitPageLayout`, `VitPageContent`, `VitHeader`, `VitBottomNav`, `VitCard`, `VitCtaButton`, `VitIconButton`, `VitInput`, `VitTabBar`, and shared state widgets before creating screen-local equivalents.
- `VitBottomNav` uses the same active brand color across Home, Markets, Trade, Wallet, and Profile. Do not add per-module active nav colors.
- Center Trade nav uses `AppGradients.navCenter`.
- `VitCtaButtonVariant.primary` and `VitCtaButtonVariant.auth` use `AppGradients.navCenter`.
- High-value balance/account/portfolio cards use `VitCardVariant.hero` or the documented Home hero treatment.
- Hero-card shadow must stay subtle: `AppColors.primary08`, restrained blur, no strong right/bottom glow.
- Semantic colors stay semantic: buy/success is green, sell/destructive is red, warning is amber, Prediction/Open Arena separation can use `AppColors.accent` or `AppColors.warn` as domain markers.

## React Conversion Rule

When converting a React screen:

1. Use React source and screenshots to understand structure, content, state, navigation, and scroll behavior.
2. Implement Flutter with mock data using shared widgets and tokens first.
3. Match visual-QA structure in `ShellRenderMode.visualQa`.
4. Normalize native runtime color, sizing, chrome, cards, and CTAs back to the Home standard.
5. Add a screen-specific exception only when the target screen has a deliberate, documented product/design reason.

## Exception Process

A non-Home color or size is allowed only if all are true:

- The exception is screen-specific and not a repeated pattern.
- The reason is documented in the `SC-xxx` blueprint, master-plan notes, or a dedicated reference doc.
- It does not reintroduce the legacy blue brand palette as default native styling.
- If the value repeats across screens, it is promoted to `flutter_app/lib/app/theme/` before reuse.
- Visual QA and native review both pass after the exception.

## Gate Checklist

Before marking a Flutter screen complete:

- No repeated local background/surface/brand palette.
- No hardcoded legacy blue brand values such as `#3B82F6`.
- Page padding, CTA/input heights, card radii, bottom insets, and nav chrome follow Home tokens.
- `ShellRenderMode.visualQa` still captures React parity at `440x956`.
- `ShellRenderMode.native` matches Home native brand and sizing.
- `flutter analyze` and relevant tests pass.
