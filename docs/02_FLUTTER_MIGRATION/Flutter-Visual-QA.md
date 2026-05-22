# Flutter Visual QA

Use this file to verify Flutter visual parity against the React screenshot baseline and native runtime consistency against the Home standard.

## Canonical Reference

- Manifest: `output/flutter-ui-reference/manifest.json`.
- Screenshots: `output/flutter-ui-reference/screenshots/`.
- Gallery: `output/flutter-ui-reference/gallery.html`.
- Baseline viewport: `440x956`.
- Theme: dark.
- Coachmarks: disabled in the React capture baseline.

The React screenshots under `output/flutter-ui-reference/screenshots/` remain the migration baseline and must not be overwritten. Flutter native UX approval images live separately under `output/flutter-ui-reference/flutter-candidates/`.

## Required Images Per Screen

Each screen has two references:

| Image | Purpose |
| --- | --- |
| `__viewport.png` | Exact visible phone viewport. |
| `__fullpage.png` | Full internal scroll content. |

A Flutter screen is not visually complete until both are checked.

## QA Workflow For One Screen

1. Open the `SC-xxx` row in the master plan.
2. Open both reference screenshots.
3. Run the Flutter screen at `440x956`.
4. Capture the viewport screenshot.
5. Capture the full scroll/page screenshot when the screen scrolls.
6. Compare layout, safe areas, typography, colors, spacing, icons, button states, cards, charts, and bottom nav.
7. Fix visual drift before BE wiring.
8. Mark QA done only when drift is accepted or resolved.

## Suggested Output Paths

When Flutter QA tooling is added, write generated Flutter comparison images outside the React baseline:

```text
output/flutter-ui-reference/flutter-candidates/
└── screenshots/
    └── {module}/
        ├── SC-xxx__viewport.png
        └── SC-xxx__fullpage.png
```

Do not overwrite `output/flutter-ui-reference/screenshots/`; that directory is the React baseline.

## Runtime Modes During QA

Use the right shell mode for the QA question:

| Mode | Use for | Expected chrome |
| --- | --- | --- |
| `ShellRenderMode.visualQa` | React screenshot parity at `440x956` | `VitPhoneFrame`, `VitStatusBar`, fake dynamic island/home indicator, full bottom chrome. |
| `ShellRenderMode.native` | Real emulator/device UX approval | OS status bar, real safe areas, compact bottom nav, and native UX optimizations such as auto-hide chrome. |

`SC-007 HomePage` native captures are the current Flutter native UX standard for later phone screens. Keep those captures in `output/flutter-ui-reference/flutter-candidates/screenshots/home/`; do not copy them over the React baseline.

Use `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__portfolio-shadow-softened-top.png` as the approved top-state Home reference for the current native brand treatment: dark orange accents, neutral dark surfaces, real OS safe areas, compact chrome, and softened portfolio/hero card shadow.

## React Parity vs Native Brand

Visual QA has two separate questions:

1. `ShellRenderMode.visualQa`: does the Flutter screen structurally match the React screenshot baseline at `440x956`?
2. `ShellRenderMode.native`: does the Flutter screen follow the approved Home native brand, spacing, safe-area, and chrome standard on a real device/emulator?

When a React screenshot still contains legacy blue brand accents or blue-tinted surfaces, use it to verify hierarchy, spacing, content, and state placement. Do not treat that old color palette as permission to introduce a new screen-local native palette. After parity is structurally correct, normalize native runtime colors back to `AppColors` and the Home native standard unless the screen-specific reference documents a deliberate exception.

## Native Design Gate

After visual-QA parity is checked, review the same screen in `ShellRenderMode.native` or emulator:

- brand, selected state, primary CTA, focus, and active nav use `AppColors.primary`;
- page surfaces use `AppColors.bg`, `surface`, `surface2`, `surface3`, `cardBorder`, `divider`, and `borderSolid`;
- bottom nav uses Home-native active color and native height `56`;
- repeated card radii, input/CTA heights, page padding, and text sizes use `AppRadii`, `AppSpacing`, `DeviceMetrics`, and `AppTextStyles`;
- no repeated local legacy palette such as `#3B82F6`, `#080C14`, `#151A23`, or `#1F263A` remains in the screen.

## Acceptance Criteria

- No blank or partially rendered screen.
- No onboarding/coachmark overlay unless the specific `SC-xxx` is an onboarding screen.
- In `visualQa`, status bar, dynamic island, home indicator, and bottom nav match the React baseline when present.
- In `native`, the app uses the real OS status bar/safe areas and may use approved native chrome behavior such as compact/auto-hidden bottom navigation.
- In `native`, later Flutter screens should align with the approved Home native visual standard unless their screen-specific reference intentionally differs.
- In `native`, page backgrounds, cards, selected states, primary CTAs, and brand accents must use shared `AppColors` tokens; repeated local legacy palettes are not accepted.
- Text fits without clipping at `440x956`.
- Scrollable content reaches the same end state as the reference full-page image.
- Prediction Markets wallet/value UI and Arena Points UI remain visually and semantically separate.

## Manual Review Notes

Automated image diff can assist, but final acceptance is human/AI visual review against the screenshot. Some chart pixels, shadows, and anti-aliasing can differ; spacing, hierarchy, state, and content must still match.
