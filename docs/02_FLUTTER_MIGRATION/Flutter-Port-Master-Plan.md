# Flutter Screen Coverage Tracker

Updated: 2026-05-26  
Status: Flutter-only source of truth.

The former React-to-Flutter migration tracker has been retired. Root React/Vite
source, web capture tooling, and `output/flutter-ui-reference` artifacts were
removed on 2026-05-26. This file now tracks Flutter screen coverage at a module
level. Use current Flutter code and tests for implementation details.

## Active Sources

| Area | Source |
| --- | --- |
| Routes | `flutter_app/lib/app/router/app_router.dart` |
| Feature UI | `flutter_app/lib/features/` |
| Shared layout/widgets | `flutter_app/lib/shared/` |
| Theme/tokens | `flutter_app/lib/app/theme/` |
| Tests | `flutter_app/test/` |
| Generated artifacts | `flutter_app/run-artifacts/` |

## Module Coverage Baseline

The current Flutter app keeps the historical 401-screen coverage target as a
tracking number, but coverage is now validated through Flutter routes, feature
source, and tests rather than deleted web manifests or screenshots.

| Module | Screens |
| --- | ---: |
| trade | 87 |
| p2p | 73 |
| earn | 70 |
| arena | 26 |
| launchpad | 24 |
| markets | 22 |
| wallet | 21 |
| predictions | 17 |
| profile | 13 |
| dca | 11 |
| auth | 6 |
| referral | 5 |
| dev | 5 |
| admin | 4 |
| cross-module | 4 |
| discovery | 3 |
| support | 3 |
| home | 1 |
| news | 1 |
| notifications | 1 |
| rewards | 1 |
| enterprise-states | 1 |
| onboarding | 1 |
| demo | 1 |
| **Total** | **401** |

## Completion Standard

A screen or flow is complete when:

- The route is registered or intentionally redirected in `app_router.dart`.
- The Flutter UI uses shared layout/widgets and app theme tokens.
- Repository/mock data covers the visible state required by the flow.
- Product boundaries are preserved, especially Prediction Markets vs Open Arena.
- Relevant widget/router/repository tests pass.
- `flutter analyze` passes for the app.

## Verification Commands

Run from `flutter_app/`:

```bash
flutter pub get
flutter analyze
flutter test
```

Use `flutter run` for emulator/device review when UI behavior is part of the
change.

## Retired Sections

The old per-screen screenshot table, source file index, navigation graph derived
from web source, and BE draft generated from web routes were removed from active
guidance. If a future task needs detailed route inventory, regenerate it from
`flutter_app/lib/app/router/app_router.dart` and commit it as Flutter-native
coverage data.
