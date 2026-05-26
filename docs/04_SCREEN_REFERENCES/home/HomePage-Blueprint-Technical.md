# HomePage Technical Blueprint

This is the active Flutter-only Home blueprint.

## Implementation Areas

- Home UI: `flutter_app/lib/features/home/`
- Router: `flutter_app/lib/app/router/app_router.dart`
- Shell/layout: `flutter_app/lib/shared/layout/`
- Widgets: `flutter_app/lib/shared/widgets/`
- Theme: `flutter_app/lib/app/theme/`
- Tests: `flutter_app/test/features/home/`

## Acceptance Checklist

- Uses shared page layout and app shell.
- Preserves five-tab primary navigation.
- Uses shared tokens for spacing, radius, text, surfaces, and brand actions.
- Handles loading/empty/error data states where applicable.
- Keeps Prediction and Arena entry points visually and semantically distinct.
- Passes `flutter analyze` and focused Home tests.
