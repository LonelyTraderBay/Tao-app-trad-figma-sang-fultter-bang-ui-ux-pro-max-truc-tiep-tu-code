# Page Rhythm Migration Checklist

**Mandatory standard:** [Page-Rhythm-Standard.md](./standards/Page-Rhythm-Standard.md) (governance + CI).  
Reference: Home (`home_page_part_01.dart`) — `VitPageContent(rhythm: VitPageRhythm.compact)`.

## Pick a tier

| Screen type | `VitPageRhythm` | Section gap | Inner gap |
| --- | --- | --- | --- |
| Feed / tab root (Home, Markets list, Predictions feed) | `compact` | 8px | 5px |
| Standard scroll (Wallet, Profile, Earn lists) | `standard` | 13px | 8px |
| Long forms / wizard / KYC | `form` | 16px | 8px |
| Hero / onboarding | `relaxed` | 24px | 13px |
| Chart / terminal / flush | `flush` | 0 | 0 |

Wire once on the page:

```dart
VitPageContent(
  rhythm: VitPageRhythm.compact,
  padding: VitContentPadding.compact,
  density: VitDensity.compact,
  children: [...],
)
```

## Per-page steps

1. Flatten to **one** top-level `VitPageContent` (no nested content wrappers for gap only).
2. Set `rhythm` (or `customGap: rhythm.sectionGap` if mixed constraints).
3. Section widgets: use `pageRhythm*InnerGap` after headers; remove trailing `SizedBox` between sibling sections.
4. Run audit: `dart run tool/page_rhythm_audit.dart --check` (CI gate; structural debt baselined in CSV).

## Anti-patterns

- `SizedBox(height: AppSpacing.sectionGap)` between `VitPageContent` children (double gap).
- Nested `VitPageContent` only to inject spacing.
- Module `*SectionGap = 16` when `pageRhythmStandardSectionGap` applies.

## Verify

```bash
cd flutter_app
flutter analyze lib/features/<cluster>
flutter test test/features/<cluster>/ --reporter=compact
dart run tool/page_rhythm_audit.dart
```

Exceptions: `/dev/*`, CustomPainter charts, bottom sheets, tab panel internals.

**Kế hoạch đầy đủ (AI tự động):** [Page-Rhythm-Migration-Execution-Plan.md](./Page-Rhythm-Migration-Execution-Plan.md) — 359 file, 41 batch, manifest CSV.
