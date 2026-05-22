# Flutter Migration Execution Runbook

This is the single execution-order file for AI agents working on the Flutter migration. Read it before creating or editing Flutter code.

## How To Prompt AI Later

Use this prompt when assigning Flutter migration work:

```text
Read AGENTS.md and docs/02_FLUTTER_MIGRATION/Flutter-Migration-Execution-Runbook.md.
Follow the current stage only. Do not skip gates. Do not port more than one SC-xxx screen unless explicitly instructed.
```

## Non-Negotiable Rules

- Follow this runbook for what to do first, next, and last.
- Use `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md` for the exact screen list and checklist status.
- Use `output/flutter-ui-reference/manifest.json` for exact route coverage.
- Use `output/flutter-ui-reference/screenshots/` for visual truth.
- Implement one `SC-xxx` screen per task unless the user explicitly overrides that rule.
- Do not port a whole module in one pass.
- Do not treat P0/P1/P2/P3 as module batching. Phases define order only.
- Do not overwrite the React screenshot baseline.
- Treat `SC-007 HomePage` as the Flutter native runtime standard for global brand colors, neutral surfaces, native chrome, and shared card treatment.
- Do not introduce repeated screen-local legacy palettes for Flutter native runtime. Use `AppColors` tokens; local aliases may point to tokens only.
- Read `Flutter-Native-Design-Standard.md` before every new or converted Flutter screen.

## Current Stage Checklist

- [ ] Stage 0 docs checked
- [ ] Stage 1 `flutter_app/` created
- [ ] Stage 2 tokens created
- [ ] Stage 3 shell created
- [ ] Stage 4 routing created
- [ ] Stage 5 shared widgets created
- [ ] Stage 6 `SC-007 HomePage` visual QA passed
- [ ] Stage 7 screen-by-screen loop started

## Execution Stages

| Stage | Goal | Required files to read | Allowed work | Done gate | Next stage |
| --- | --- | --- | --- | --- | --- |
| 0 | Confirm baseline and rules before code | `AGENTS.md`, `docs/00_START_HERE.md`, `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md`, `docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`, this runbook | Read docs, verify manifest/screenshots exist, confirm current target stage | Manifest has 401 routes, screenshot set has 802 PNGs, no source-of-truth conflict | Stage 1 |
| 1 | Create Flutter project container | `Flutter-App-Foundation.md` | Create `flutter_app/`, add Flutter dependencies, keep generated Flutter app isolated from React runtime | `flutter_app/` runs a default app without changing React app behavior | Stage 2 |
| 2 | Create Flutter design tokens | `Flutter-Native-Design-Standard.md`, `Flutter-Design-Tokens.md`, `src/styles/theme.css`, `src/app/hooks/useThemeColors.ts` | Implement `AppColors`, `AppGradients`, `AppSpacing`, `AppRadii`, `AppTextStyles`, `DeviceMetrics` | Tokens match the Home native standard and are used by sample app shell | Stage 3 |
| 3 | Create app shell and layout primitives | `Flutter-App-Foundation.md`, `Flutter-Component-Mapping.md`, React `MobileFrame`, `StatusBar`, `PageLayout`, `PageContent`, `Header`, `BottomNav` source | Implement `VitTradeApp`, `VitPhoneFrame`, `VitStatusBar`, `VitPageLayout`, `VitPageContent`, `VitHeader`, `VitBottomNav` | Empty shell visually matches the 440x956 baseline frame, safe areas, and bottom chrome | Stage 4 |
| 4 | Create routing and bottom nav skeleton | `Flutter-Navigation-Routing.md`, master plan `Navigation Graph` | Add `go_router`, `/home`, bottom nav destinations, typed route names for the first target screen | `/home` opens inside shell and bottom nav active state works | Stage 5 |
| 5 | Create shared widgets needed by Home proof | `Flutter-Component-Mapping.md`, `Flutter-Design-Tokens.md` | Implement only shared widgets needed for `SC-007`: cards, CTA buttons, icon buttons, search/action buttons, status pills, skeleton/error primitives if needed | Home can be built without screen-local copies of shared primitives | Stage 6 |
| 6 | Port `SC-007 HomePage` as shell proof | `Flutter-Port-Master-Plan.md` row `SC-007`, Home screenshots, Home React source, Home screen references under `docs/04_SCREEN_REFERENCES/home/` | Implement only `SC-007 HomePage`, mock data first, route `/home`, no unrelated screens | Home viewport/full-page captures pass visual QA and native captures establish the global Home standard | Stage 7 |
| 7 | Start screen-by-screen migration loop | `Flutter-Native-Design-Standard.md`, `Flutter-Port-Master-Plan.md`, `Flutter-Visual-QA.md`, target screen React source | Pick the next `SC-xxx` by master plan phase/order, implement one screen, wire only needed navigation, add mock repository contract | One target screen has Flutter UI, route, BE draft, React-parity QA, and Home-native design check | Stage 8 |
| 8 | Close the target screen task | Target `SC-xxx` checklist row, `Flutter-Visual-QA.md` | Update screen status only after acceptance; document unresolved navigation or BE gaps | Flutter, BE, and QA status accurately reflect reality | Repeat Stage 7 for next screen |

## Stage 0 Gate

Before any Flutter code work, verify:

- `output/flutter-ui-reference/manifest.json` exists.
- `output/flutter-ui-reference/screenshots/` exists.
- The manifest has `401` routes.
- The screenshot baseline has `802` PNG files.
- `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md` has `401` Flutter status rows, `401` BE status rows, and `401` QA status rows.

If any check fails, stop and repair the baseline before coding Flutter.

## First Screen Rule

`SC-007 HomePage` must be the first real Flutter UI proof screen because it validates:

- phone frame,
- dark theme,
- status bar,
- bottom nav,
- core spacing,
- shared cards/buttons,
- Home entry navigation.
- global native color and size standard for the rest of the app.

After `SC-007` passes visual QA, return to the master plan and continue by phase/order. Do not keep building Home-related screens unless the next task explicitly selects one.

## Home Native Standard Gate

For every Flutter screen, the Home native standard is mandatory:

- Use `AppColors.primary = 0xFFE58A00`, `primaryDark = 0xFFB96000`, and `primarySoft/warn = 0xFFF5A524` for brand, selected state, primary CTA, focus, and active nav.
- Use neutral dark surfaces: `AppColors.bg`, `surface`, `surface2`, `surface3`, `cardBorder`, `divider`, and `borderSolid`.
- Use Home-native sizing: `contentPad = 20`, standard section gap `20`, compact Home rhythm `12` where the shared layout calls for it, input/CTA height `52`, standard card radius `16`, large/hero card radius `24`, native bottom chrome `56`.
- Do not use legacy React blue (`#3B82F6`) as Flutter native brand color.
- Do not use per-module bottom-nav active colors. Bottom nav active color is the Home brand color across all five tabs.
- Screen-local constants may alias `AppColors` or `AppSpacing`, but repeated local `Color(0x...)`, radius, spacing, or shadow palettes are not accepted.

## Screen-By-Screen Loop

For every screen after Home:

1. Select exactly one `SC-xxx` row from the master plan.
2. Open its viewport and full-page screenshots.
3. Read the React source from the master plan `Source File Index`.
4. Check `Flutter-Native-Design-Standard.md` plus shared tokens/components/routing docs.
5. Implement Flutter UI with mock data first.
6. Wire only navigation needed by that screen.
7. Add or update the draft repository/BE contract for that screen.
8. Normalize Flutter native colors and shared treatment to the Home native standard unless the screen-specific reference documents an exception.
9. Capture Flutter viewport and full-page screenshots.
10. Compare against the React baseline for structure and against Home native for runtime brand consistency.
11. Tick status only when Flutter UI, navigation, BE draft, and visual QA are actually complete.

## Stop Conditions

Stop and report instead of guessing when:

- a screenshot path is missing,
- React source listed in the master plan is missing,
- route behavior conflicts with the Navigation Graph,
- a `NEEDS_MANUAL_CONFIRM` edge affects the current screen,
- a screen appears to mix Prediction wallet/value with Arena Points,
- visual QA cannot be run or cannot produce a nonblank screenshot.

## File Roles

| File | Role |
| --- | --- |
| This runbook | Decides execution order. |
| `Flutter-Port-Master-Plan.md` | Decides screen coverage, checklist status, phase/order, source lookup, navigation draft, BE draft. |
| `Flutter-App-Foundation.md` | Explains Flutter app structure and defaults. |
| `Flutter-Design-Tokens.md` | Explains token values. |
| `Flutter-Component-Mapping.md` | Explains shared widget mapping. |
| `Flutter-Navigation-Routing.md` | Explains routing and bottom nav rules. |
| `Flutter-Visual-QA.md` | Explains screenshot comparison and visual acceptance. |
