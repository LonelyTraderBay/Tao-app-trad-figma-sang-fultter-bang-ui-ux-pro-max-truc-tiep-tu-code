# Flutter Design Tokens

Flutter tokens live in `flutter_app/lib/app/theme/`. The current Flutter source
is authoritative for token names and values.

## Token Files

| File | Purpose |
| --- | --- |
| `app_colors.dart` | Brand, semantic, text, border, and surface colors |
| `app_gradients.dart` | Approved gradients |
| `app_spacing.dart` | Spacing scale |
| `app_radii.dart` | Radius scale |
| `app_text_styles.dart` | Typography |
| `device_metrics.dart` | Runtime sizing and safe-area helpers |
| `app_module_accents.dart` | Controlled module accent layer |

## Rules

- Use shared tokens instead of hardcoded repeated values.
- Keep dark theme as the primary baseline.
- Module accents are allowed only as accents; backgrounds, cards, bottom nav,
  and primary CTAs should stay globally consistent.
- Do not add a screen-local palette unless the product/design docs document a
  deliberate exception.
- When tokens and implementation disagree, inspect the active Flutter code and
  update this doc or the implementation in the same change.
