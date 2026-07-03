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

## Section order (SC-007)

1. Header (`VitTopChrome`)
2. Announcement banner (priority: security → risk → campaign)
3. Portfolio hero card
4. Next action (optional, dismissible per session)
5. Market ticker (3 pairs)
6. Product quick actions (Prediction/Arena excluded — see Discovery)
7. Recent products (horizontal list or empty state)
8. Discovery bridge (Prediction Markets + Open Arena)
9. Market tabbed list (Hot / Tăng / Giảm / Mới)

Removed from Home scroll: trending carousel, separate top gainers/losers blocks
(content lives in market tabs).

## Enterprise states (reference pattern)

| State | UI |
| --- | --- |
| Loading | Portfolio + market skeletons via `VitSkeleton` / `VitSkeletonList` |
| Data | Full section stack above |
| Error | `VitErrorState` with retry → `ref.invalidate(homeSnapshotProvider)` |
| Refresh | `RefreshIndicator` on `VitInsetScrollView` + `AlwaysScrollableScrollPhysics` |

Data flow: `homeSnapshotProvider` (`FutureProvider`) → `HomeController` for
derived market lists. Other screens should mirror this async + refresh pattern
when wiring live APIs.

## Verification

Run from `flutter_app/`:

```bash
flutter analyze
flutter test test/features/home
dart run tool/home_entry_back_navigation_audit.dart --check
```

Use emulator/device review for visual changes.
