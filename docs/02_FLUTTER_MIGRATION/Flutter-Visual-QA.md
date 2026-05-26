# Flutter Visual QA

Use this file to verify Flutter-native visual quality after the 2026-05-26
Flutter-only cleanup.

## Active QA Targets

- Runtime shell uses native safe areas and app chrome correctly.
- Shared spacing, radii, typography, cards, CTAs, and bottom navigation match the
  Flutter design tokens.
- Module accents remain controlled and do not replace global app chrome.
- Loading, empty, error, offline, and confirmation states are visible where
  relevant.
- Text fits at supported phone widths and does not overlap controls.

## Review Modes

| Mode | Purpose |
| --- | --- |
| `ShellRenderMode.native` | Primary runtime review on emulator/device. |
| `ShellRenderMode.visualQa` | Optional fixed-frame local inspection for layout consistency. |

Generated screenshots or review artifacts should be written under
`flutter_app/run-artifacts/`.

## Verification

Run from `flutter_app/`:

```bash
flutter analyze
flutter test
flutter run
```

For screen-level QA, inspect the target screen on a phone-sized emulator or
device and compare against the current Flutter-native design rules, not deleted
web screenshots.
