# Flutter App Foundation

This file defines the baseline Flutter app architecture before any screen UI is ported.

## Project Location

- Create the Flutter project inside this repo at `flutter_app/`.
- Keep React reference code, docs, screenshots, and Flutter app in the same repo during migration.
- Do not move `output/flutter-ui-reference/`; Flutter QA must read screenshots from that stable repo-root path.

## Migration Unit

- The migration unit is one `SC-xxx` row from `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.
- Implement exactly one screen per task unless the user explicitly says otherwise.
- Do not create a full-module implementation pass.
- Do not generate 401 screen-specific blueprint files up front. Create a screen-specific blueprint only when starting that `SC-xxx`.

## Required Flutter Defaults

| Area | Decision |
| --- | --- |
| Routing | `go_router` |
| State management | `flutter_riverpod` |
| Network layer | Repository interfaces first, mock implementations before real BE |
| Theme | Dark baseline first |
| Target frame | Phone-first, `440x956` visual QA baseline for parity capture |
| Runtime mode | `ShellRenderMode.native` is the default for emulator, APK, and real devices |
| App shell | `VitAppShell` owns native runtime shell and visual QA frame behavior |
| UI source | Screenshots first, React source second, Flutter-native widgets for implementation |

## Runtime Shell Modes

Flutter now has two explicit shell modes:

| Mode | Purpose | Required behavior |
| --- | --- | --- |
| `ShellRenderMode.native` | Default user/runtime mode for emulator, APK, and real devices | Uses the OS status bar, real safe areas, compact native bottom chrome, and user-space optimizations such as header/bottom-nav auto-hide where implemented. |
| `ShellRenderMode.visualQa` | Screenshot parity mode for comparing against the React baseline | Uses `VitPhoneFrame`, `VitStatusBar`, fixed `440x956` frame, fake dynamic island/home indicator, and visual QA bottom chrome. |

Do not use the visual QA frame as the production or emulator default. Native runtime is allowed to improve the real-device experience as long as visual QA parity mode remains available for screenshot comparison.

`SC-007 HomePage` is the current approved Flutter native UX standard for the phone runtime. It should guide later screen implementations for native safe areas, compact bottom navigation, scroll-driven chrome hiding, and the Bybit-inspired dark orange Flutter brand palette. See `docs/04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md`.

## Initial App Structure

Use this structure for `flutter_app/lib/`:

```text
lib/
├── main.dart
├── app/
│   ├── vit_trade_app.dart
│   ├── router/app_router.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_gradients.dart
│       ├── app_radii.dart
│       ├── app_spacing.dart
│       ├── app_text_styles.dart
│       └── device_metrics.dart
├── core/
│   ├── data/
│   ├── models/
│   ├── repositories/
│   └── utils/
├── features/
│   ├── auth/
│   ├── home/
│   ├── markets/
│   ├── predictions/
│   ├── trade/
│   ├── wallet/
│   ├── profile/
│   ├── dca/
│   ├── arena/
│   ├── p2p/
│   ├── earn/
│   └── launchpad/
└── shared/
    ├── layout/
    ├── widgets/
    └── states/
```

## Foundation Build Order

1. Create the Flutter project in `flutter_app/`.
2. Add dependencies: `go_router`, `flutter_riverpod`, `dio`, and visual-test tooling chosen for the Flutter version in use.
3. Implement dark theme tokens from `Flutter-Design-Tokens.md`.
4. Implement shell/layout primitives from `Flutter-Component-Mapping.md`.
5. Add the route skeleton needed for the first target screen only.
6. Port `SC-007 HomePage` first as the app-shell proof before expanding to other screens.

## Hard Rules

- Visual parity must be checked before BE wiring is considered done.
- Mock data is acceptable until the screen visually matches the reference.
- BE contracts in the master plan are drafts, not final endpoint specs.
- Do not overwrite `output/flutter-ui-reference/screenshots/`; it remains the React migration baseline.
- Do not tick master plan screen status until Flutter UI, navigation, BE draft, and QA acceptance are actually complete.
- `ui-ux-pro-max` can assist QA and Flutter best practices, but it cannot override screenshots, master plan, or `Guidelines.md`.
