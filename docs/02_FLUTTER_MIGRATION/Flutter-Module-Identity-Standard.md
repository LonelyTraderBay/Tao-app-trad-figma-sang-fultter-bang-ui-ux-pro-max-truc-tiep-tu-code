# Flutter Module Identity Standard

This document defines how VitTrade Flutter screens can keep module-specific character without breaking the Home-native foundation.

`SC-007 HomePage` remains the global source of truth for background, card treatment, spacing, typography, radii, bottom navigation, and primary brand behavior. Module identity is an accent layer only.

## Three-Layer Model

1. **Global foundation** is mandatory across the app: `AppColors.bg`, `surface`, `surface2`, `surface3`, `cardBorder`, `borderSolid`, `divider`, `AppSpacing`, `AppRadii`, `AppTextStyles`, and `DeviceMetrics`.
2. **Semantic tokens** express meaning across modules: `buy`, `sell`, `warn`, `warningBg`, `warningBorder`, `accent`, and primary brand tokens.
3. **Module identity** is allowed only through controlled accents: icons, badges, chart markers, hero-card border/glow, pills, tab indicators, and empty-state illustration accents.

## Allowed Module Identity

| Module | Role | Accent intent |
| --- | --- | --- |
| Home | Overview, discovery, routing | Strongest use of `AppModuleAccents.home` / primary brand |
| Markets | Scan, compare, discover data | Charts, analytics badges, trend markers via `markets` / semantic buy-sell |
| Trade | Action, precision, risk | Primary action/focus plus buy-sell and warning disclosures |
| Wallet | Assets, trust, security | Balance hero border/glow, deposit/withdraw statuses, security markers |
| Profile | Account, identity, settings | Neutral status, verified/security badges, restrained warnings |
| Predictions | Value-based probability markets | `predictions` accent for domain separation; no casino styling |
| Arena | Points-only social challenge area | `arena` accent for points-only boundary; no wallet/PnL styling |

## Non-Negotiable Rules

- Do not use module-specific card, page, input, or bottom-nav background colors.
- Do not make bottom navigation active state module-specific; it always uses `AppColors.navActive`.
- Do not use emojis as primary UI icons in service/action grids.
- Do not introduce repeated local `Color(0x...)` palettes for backgrounds, surfaces, borders, brands, controls, or hero gradients.
- Do not create new repeated sizes or radii inside screens; promote them to shared tokens first.

## Shared Implementation Path

- Use `AppModuleAccents` for module accent tokens.
- Use `VitServiceTile` for Home/service grids and primary shortcut grids.
- Corner badges (`badgeLabel`, `riskBadgeLabel`) follow [Service-Tile-Badge-Standard.md](./Service-Tile-Badge-Standard.md).
- Use `VitModuleHeroCard`, `VitMetricCard`, `VitStatusPill`, `VitModuleSectionHeader`, and `VitAccentIconBox` for repeated module patterns before creating local equivalents.
- Keep card backgrounds neutral; apply module character through `VitAccentIconBox` color, pill color, chart series, or copy.

## Review Checklist

- Foundation matches Home: background, surfaces, card radii, spacing, typography, CTA/input heights, bottom chrome.
- Module character is visible but restrained.
- Accent use is semantic or module-token based.
- No local dark/blue surface palette is reintroduced.
- Static audit passes before visual QA.
- Visual QA verifies representative Home, Markets, Trade, Wallet, and Profile screens.
