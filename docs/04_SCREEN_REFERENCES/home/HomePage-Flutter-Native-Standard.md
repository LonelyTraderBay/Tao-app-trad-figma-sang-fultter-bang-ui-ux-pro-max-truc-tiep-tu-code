# HomePage Flutter Native Standard

This file is the active Home reference after the 2026-05-26 Flutter-only
cleanup. It no longer depends on deleted web screenshots.

## Source Of Truth

- Home implementation: `flutter_app/lib/features/home/`.
- App shell/layout: `flutter_app/lib/shared/layout/`.
- Theme tokens: `flutter_app/lib/app/theme/`.
- Home tests: `flutter_app/test/features/home/`.

## Standard

- Home establishes the global dark runtime treatment for shared app chrome.
- Use neutral dark backgrounds and surfaces.
- Use the shared orange brand token for selected states and primary actions.
- Keep bottom navigation globally consistent across modules.
- Respect native safe areas and avoid fake device chrome in production runtime.
- Use compact, scannable financial UI with clear risk/disclosure states.

## Verification

Run from `flutter_app/`:

```bash
flutter analyze
flutter test test/features/home
```

Use emulator/device review for visual changes.
