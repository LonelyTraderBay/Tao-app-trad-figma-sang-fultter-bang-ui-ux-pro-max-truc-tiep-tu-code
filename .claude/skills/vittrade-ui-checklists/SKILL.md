---
name: vittrade-ui-checklists
description: >
  When building, polishing, or reviewing VitTrade Flutter UI screens and
  shared components — accessibility, motion performance, visual hierarchy,
  loading/empty/error states, phone-first layout — while preserving AGENTS.md,
  Vit* primitives, financial safety, and Prediction Markets / Open Arena
  boundaries.
---

# VitTrade UI Checklists

Borrow external checklist *ideas*; VitTrade tokens and `Vit*` widgets stay
authoritative. Do not import web/React/Tailwind patterns.

## Source priority

1. `AGENTS.md` (UI Rules + Financial Safety)
2. `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md`
3. Matching `docs/02_FLUTTER_MIGRATION/standards/<Domain>-Standard.md`
4. Current Flutter theme + `shared/widgets`
5. At most one external checklist from the allowlist below

## Allowlist (optional)

- Accessibility / forms / focus → translate `ibelick/fixing-accessibility`
- Motion / jank → translate `ibelick/fixing-motion-performance`
- Light polish only → `ibelick/baseline-ui`

Prefer pinned read-only retrieval if needed:

```powershell
npx ui-skills@0.2.2 get ibelick/fixing-accessibility
```

Never `curl | sh`. If offline, use the translation table and continue.

## Flutter translation (high signal)

| External idea | VitTrade |
| --- | --- |
| aria-label on icon buttons | `tooltip` / `Semantics(label: …)` |
| Focus visible | FocusTraversal + visible focus state |
| Field errors | Inline near `VitInput` |
| Loading status | Skeletons / progress; liveRegion when critical |
| Avoid layout thrash | No expensive blur / rebuild-heavy list anim |
| Responsive breakpoints | Phone-first @ 360px; `LayoutBuilder` |
| Design tokens | `AppColors` / `AppSpacing` / `AppRadii` / `AppTextStyles` |

## Delivery checklist

- Shared primitives before local scaffolds.
- Dark theme baseline; vi-VN copy with đủ dấu.
- Preview/confirm intact on high-risk flows.
- Notice success/error → `showVitNoticeSheet` (not SnackBar toasts).
- Focused `flutter analyze` + tests for touched UI.

## Gotchas

- Do not wrap `VitTabBar` / `VitSegmentedTabBar` in bordered `VitCard`.
- Binary MUA/BÁN / Long-Short → `VitSegmentedChoice`, not full-width pill rows.
- No raw `BorderRadius.circular()` outside `app_radii.dart`.
