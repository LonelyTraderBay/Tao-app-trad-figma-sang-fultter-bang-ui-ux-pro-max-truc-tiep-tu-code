# Flutter Evidence QA Report

Generated: 2026-05-26  
Scope: post-cleanup Flutter-only evidence status.

## Executive Verdict

The repo has been converted to Flutter-only. The former web app, root npm/Vite
tooling, and generated screenshot baseline were removed. Visual QA is now based
on current Flutter-native implementation, shared tokens, tests, and manual
device/emulator review.

## Current Evidence Sources

| Area | Source |
| --- | --- |
| App source | `flutter_app/lib/` |
| Routes | `flutter_app/lib/app/router/app_router.dart` |
| Tests | `flutter_app/test/` |
| Theme/tokens | `flutter_app/lib/app/theme/` |
| Shared layout/widgets | `flutter_app/lib/shared/` |
| Generated artifacts | `flutter_app/run-artifacts/` |

## Required Verification

Run from `flutter_app/`:

```bash
flutter pub get
flutter analyze
flutter test
```

Optional runtime validation:

```bash
flutter run
```

## Notes

- Claims about old web screenshot parity are obsolete.
- Future QA reports should cite Flutter command output, router/test evidence,
  and current emulator/device review artifacts.
