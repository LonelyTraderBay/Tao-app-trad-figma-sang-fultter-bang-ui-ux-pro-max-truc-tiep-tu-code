# HomePage Navigation Flow

This file replaces the retired web-source navigation notes for Home.

## Active Sources

- Router: `flutter_app/lib/app/router/app_router.dart`.
- Home screen: `flutter_app/lib/features/home/`.
- Navigation tests: `flutter_app/test/app/router/` and
  `flutter_app/test/features/home/`.

## Current Rules

- Home remains one of the five primary bottom-navigation tabs.
- Prediction Markets, Open Arena, P2P, Earn, Launchpad, DCA, Referral, Support,
  and News remain reachable through contextual entry points rather than new
  bottom-nav tabs unless product docs change.
- Home navigation actions should use named routes or route helpers from the
  Flutter router.

## Verification

Run focused Home/router tests after changing Home navigation:

```bash
cd flutter_app
flutter test test/app/router
flutter test test/features/home
```
