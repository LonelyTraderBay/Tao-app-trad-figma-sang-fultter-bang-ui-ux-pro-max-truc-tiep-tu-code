# Flutter Component Mapping

Use this file to keep screens aligned with the shared Flutter component system.
It replaces the old web-to-Flutter mapping role.

## Shared Layout

| Need | Flutter primitive | Rule |
| --- | --- | --- |
| App shell | `VitAppShell` | Owns route child, shell mode, bottom nav visibility, and app chrome. |
| Fixed review frame | `VitPhoneFrame` | Use only for explicit local QA/review flows. |
| Page scaffold | `VitPageLayout` | Default page wrapper for feature screens. |
| Scroll/content area | `VitPageContent` | Use for normal page content and consistent padding. Set `fullBleed: true` when the scroll view already applies horizontal `contentPad` — see [Page-Content-Width-Standard.md](./standards/Page-Content-Width-Standard.md). |
| Bottom scroll clearance | `VitInsetScrollView` | Preferred scroll wrapper for Recipe A: bottom inset only; horizontal pad owned by `VitPageContent`. |
| Header | `VitHeader` | Use for standard title/back/action rows. |
| Bottom nav | `VitBottomNav` | Use shared navigation behavior and active brand token. |

## Shared Widgets

| Need | Flutter widget |
| --- | --- |
| Primary CTA | `VitCtaButton` |
| Cards/surfaces | `VitCard` |
| Inputs | `VitInput` |
| Icon buttons | `VitIconButton` |
| Search | `VitSearchBar` |
| Tabs | `VitTabBar` |
| Status labels | `VitStatusPill` |
| Empty/error/offline states | `VitEmptyState`, `VitErrorState`, `VitOfflineBanner` |
| Loading placeholders | `VitSkeleton` |

## Rules

- Reuse shared widgets before building local screen-specific components.
- Use theme constants from `flutter_app/lib/app/theme/`.
- Keep custom painters, charts, and complex visual controls local only when the
  shared system cannot express the behavior.
- If a local component repeats across two or more modules, move it into
  `flutter_app/lib/shared/widgets/` with focused tests.
