# VitTrade Flutter

Enterprise Flutter mobile app for VitTrade crypto trading, wallet, P2P,
Prediction Markets, Open Arena, Earn, DCA, and account operations.

## Source of Truth

- App source: `lib/`
- Router facade: `lib/app/router/app_router.dart`
- Tests: `test/`
- QA docs: `../docs/02_FLUTTER_MIGRATION/`

## Development

Run from `flutter_app/`:

```bash
flutter pub get
dart format .
flutter analyze
flutter test --reporter=compact
flutter build apk --debug
```

For production-like runs, pass Dart defines instead of changing code:

```bash
flutter run \
  --dart-define=APP_ENV=staging \
  --dart-define=API_BASE_URL=https://staging-api.vittrade.example
```

`APP_ENV=production` disables mock repositories by default. Critical feature
repositories fail closed until remote implementations are configured.

## Release Notes

Android release builds require signing through `android/key.properties` or the
`VITTRADE_KEYSTORE_PATH`, `VITTRADE_KEYSTORE_PASSWORD`,
`VITTRADE_KEY_ALIAS`, and `VITTRADE_KEY_PASSWORD` environment variables.
Unsigned release tasks fail before producing an artifact.
