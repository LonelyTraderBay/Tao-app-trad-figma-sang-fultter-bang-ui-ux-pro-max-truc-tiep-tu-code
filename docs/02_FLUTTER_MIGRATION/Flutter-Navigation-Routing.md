# Flutter Navigation And Routing

Use this file to keep Flutter navigation consistent.

## Source Of Truth

- Router: `flutter_app/lib/app/router/app_router.dart`.
- Route tests: `flutter_app/test/app/router/` and feature tests.
- Screen coverage tracker: `docs/02_FLUTTER_MIGRATION/Flutter-Port-Master-Plan.md`.

## Rules

- Use `go_router` route names and path helpers already defined in the router.
- Keep dynamic route ids stable and test representative sample ids.
- Prefer redirects over duplicate route implementations when two paths represent
  the same screen state.
- Do not add Arena or Prediction bottom-nav tabs unless product docs are updated.
- For new routes, add route registration, screen implementation, repository/mock
  data, and tests in the same change.

## Verification

Run from `flutter_app/`:

```bash
flutter test test/app/router
flutter test test/features/<module>
```

Run full `flutter test` when route shell behavior or shared navigation changes.
