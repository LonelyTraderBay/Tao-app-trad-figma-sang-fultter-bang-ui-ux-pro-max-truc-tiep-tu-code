# HomePage Flutter Native Standard

This file records the approved native Flutter UX standard for `SC-007 HomePage`.
It complements the React screenshot baseline; it does not replace it.

## Status

- Screen: `SC-007 HomePage`
- Route: `/home`
- Runtime standard: `ShellRenderMode.native`
- Visual parity mode: `ShellRenderMode.visualQa`
- Approved native runtime target: emulator/real device behavior, not the fake phone frame
- Approved native color direction: Bybit-inspired dark orange on neutral dark/OLED-clean surfaces
- Approved visual standard: current Home native runtime after the softened portfolio shadow pass
- Date recorded: 2026-05-19

## Source Of Truth Boundaries

- Migration coverage still comes from `output/flutter-ui-reference/manifest.json`.
- React parity screenshots remain in `output/flutter-ui-reference/screenshots/`.
- Flutter native approval captures live in `output/flutter-ui-reference/flutter-candidates/screenshots/home/`.
- Do not overwrite the React baseline with native captures.
- Do not tick master plan status unless Flutter UI, navigation, BE draft, and QA acceptance are complete.
- The Bybit-inspired Flutter native palette is an original VitTrade treatment; it is not an exact copy of Bybit brand assets.

## Approved Native Captures

Use these captures as the current Home native UX reference:

| Capture | Purpose |
| --- | --- |
| `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__pixel10-pro-xl-2-latest.png` | Pixel 10 Pro XL (2) latest installed native runtime view. |
| `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__android-native-area-top.png` | Native top state with OS status bar and Home header visible. |
| `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__android-native-area-scroll.png` | Mid-scroll state showing Home header and bottom nav hidden. |
| `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__android-native-area-bottom-final.png` | End-scroll state showing final content clear of app-owned bottom chrome. |
| `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__bybit-orange-top.png` | Native top state after the dark orange brand refresh. |
| `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__bybit-orange-scroll.png` | Mid-scroll state after the dark orange brand refresh, with app chrome hidden. |
| `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__bybit-orange-bottom.png` | Bottom state after the dark orange brand refresh, confirming usable area and contrast. |
| `output/flutter-ui-reference/flutter-candidates/screenshots/home/SC-007__portfolio-shadow-softened-top.png` | Approved Home top state after reducing the portfolio/hero card shadow at the right and bottom edges. |

## Native UX Decisions

- Use the real OS status bar and Flutter/OS safe areas.
- Do not render `VitPhoneFrame`, `VitStatusBar`, fake dynamic island, or fake home indicator in native runtime.
- Home header starts visible, hides on downward vertical scroll, and reappears on upward scroll or near top.
- `VitAppShell` hides the native bottom nav on downward vertical scroll and restores it on upward scroll, top, or route change.
- Native bottom nav uses `DeviceMetrics.nativeBottomChrome = 56`.
- Home native content uses compact section rhythm: outer content gap `12`.
- Home native bottom scroll inset is `DeviceMetrics.nativeBottomChrome + MediaQuery.padding.bottom + 16`.
- Flutter native brand uses `AppColors.primary = 0xFFE58A00`, `AppColors.primaryDark = 0xFFB96000`, and `AppColors.primarySoft = 0xFFF5A524`.
- Flutter native surfaces use neutral charcoal values to reduce the previous blue tint and make the content read cleaner on real devices.
- Portfolio/hero card depth should stay subtle: use a light `VitCardVariant.hero` shadow, not a strong glow on the right or bottom edge.
- Portfolio glow should stay inside the card and act as a soft highlight, not as an outer halo.

## Visual QA Compatibility

Visual QA remains separate:

- `ShellRenderMode.visualQa` uses `VitPhoneFrame`, `VitStatusBar`, fixed `440x956` viewport, and full bottom chrome.
- Visual QA bottom chrome remains `DeviceMetrics.bottomChrome = 90`.
- Home visual QA spacing should not inherit native-only compact spacing unless a future task intentionally updates the React parity target.
- React screenshots in `output/flutter-ui-reference/screenshots/` remain the migration baseline even after native brand refresh captures are approved.

## Guidance For Later Screens

Use this Home screen as the practical native UX bar for future Flutter phone screens:

- Prefer real device safe areas over fake device chrome in native runtime.
- Keep repeated navigation chrome compact and hide it during downward scroll when the screen is scroll-heavy.
- Preserve minimum tap targets and readable financial data; do not trade clarity for density.
- Use the approved Home card treatment as the default for high-value hero cards: dark gradient, soft orange accent, restrained shadow.
- Keep Prediction Markets value surfaces and Open Arena points-only surfaces visually and semantically separate.
