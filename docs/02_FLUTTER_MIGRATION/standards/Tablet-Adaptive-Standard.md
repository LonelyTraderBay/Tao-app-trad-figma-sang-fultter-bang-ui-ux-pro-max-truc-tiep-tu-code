# Tablet-Adaptive Standard (mandatory for any screen with a dedicated tablet layout)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · `AGENTS.md` UI Rules · Reference screen: Home (SC-007)
**Enforcement:** No dedicated audit tool yet — single reference implementation. Enforced via (a) the page's own widget test at/above its two-column threshold, (b) the existing whole-repo structural audits (page rhythm, card tile, page content width), which already scan every file under `lib/features/**/presentation` regardless of phone/tablet.
**Reference screens:** `home_responsive_entry.dart` + `home_tablet_page.dart` (first); `wallet_responsive_entry.dart` + `wallet_tablet_page.dart` (second, confirmed R9's header-promotion pattern generalizes)

## Scope

This standard governs screens that build a **dedicated tablet-specific layout**
— not just inheriting the shell. The shell-level adaptation (bottom nav vs
`VitNavigationRail` via `VitAppShell` / `AppBreakpoints.tablet` = 600px) is
already app-wide and out of scope here; every screen gets that for free.

## When to build a dedicated tablet page

Build one when a screen is a **dashboard/hub with 2+ independent content
groupings** that benefit from side-by-side layout — content users scan or
compare at once (portfolio + market data + quick actions, in Home's case).

Skip it for linear detail pages, single-purpose forms/wizards, and
confirmation/receipt screens — these already render correctly as-is inside
the tablet shell (nav rail + full-width single column), and a bespoke tablet
layout would be extra surface with no real information-density gain. When in
doubt, ship without one: adding it later is cheap, removing a shipped one
that turned out unnecessary is not.

## Invariant

```text
Same route, same data provider, same SC-NNN identifier as the phone page.
Only the WIDGET BUILT at that route changes, dispatched by width via a
LayoutBuilder-based responsive entry widget — never a second route/path.
```

## Mandatory rules

| # | Rule |
| --- | --- |
| R1 | **Dispatcher, not a new route.** `<Feature>ResponsiveEntry` (`LayoutBuilder` + `AppBreakpoints.isTablet(constraints.maxWidth)` → `<Feature>TabletPage`, else the phone page unchanged) wired at the *existing* route builder. Register the dispatcher class in `tool/page_rhythm_layout_registry.dart`'s `widgetClassPageOverrides` map, pointing at the phone reference file, so structural audits keep inspecting real content instead of the thin dispatcher — and in `top_header_visual_archetype_audit.dart`'s `_noHeaderDecisions` map (the dispatcher has no header of its own). See `HomeResponsiveEntry`. |
| R2 | **Never touch the phone reference.** Don't edit the phone page or its `part` family to build a tablet variant. Reuse its already-public presentation widgets directly. For a section that's `private` inside another page's part family, write a new public tablet-specific widget instead — naming `<feature>_<section>_panel.dart` (see `home_market_watchlist_panel.dart`, `home_discovery_panel.dart`). |
| R3 | **Verify the threshold empirically, don't invent a new global breakpoint tier.** Below some min-width, fall back to a single column (still tablet shell, still nav rail). Start from `TabletDashboardWidths.twoColumnMinWidth` (`lib/app/theme/tablet_dashboard_widths.dart`) — both existing dashboards confirmed 900 by pumping real widgets at candidate widths, not guessing — but re-verify against your own page's content rather than assuming it holds; if it doesn't, keep a page-local `static const` override instead of editing the shared value (see that file's own doc comment). Never invent a second `AppBreakpoints` tier for one screen. |
| R4 | **Independent-scroll columns**: `Row` + `Expanded` per column, each wrapping its own `SingleChildScrollView` — never one `SingleChildScrollView` wrapping the whole `Row`. A `Row` of unbounded natural height inside a single outer scrollview breaks once any child needs a bounded height; two independently height-bounded scrolling columns is the supported shape. |
| R5 | **Width-cap *inside* each column's `SingleChildScrollView` child** (`Align` + `ConstrainedBox` wrapping that column's `VitPageContent`) — never on the outer `Row`. `SingleChildScrollView` is what loosens *only* the height axis while keeping width bounded; that's the one place a width cap can actually narrow a column without also loosening the `Row`'s own tight-height stretch (which independent scrolling depends on). A `ConstrainedBox` placed directly on a tightly-constrained ancestor is a no-op — tight incoming constraints always win over a descendant's tighter bound. |
| R6 | **Two-column path uses `VitContentPadding.relaxed` + `VitPageRhythm.relaxed`** — `.compact` is the phone/space-constrained tier. The single-column fallback below the page's own threshold (R3) keeps `.compact`. |
| R7 | **Frame the secondary/sidebar column as a distinct panel** — `VitCard(variant: VitCardVariant.inner, padding: EdgeInsets.zero)` wrapping that column's `VitPageContent` — so the independent-scroll seam (R4) reads as an intentional sidebar boundary, not an accidental gap between two loose stacks. The primary/main column stays flush against the page background (its own sections already carry their own card framing). |
| R8 | **Preserve the proven safety margin.** `TabletDashboardWidths.primaryColumnMaxWidth`/`secondaryColumnMaxWidth` (640/440) are the per-column pixel widths confirmed not to overflow at the shared threshold (R3), on two independent content sets. Adding a gutter, changing the flex ratio, or lowering the threshold all eat into that margin — re-verify with your page's real content before trusting the shared numbers, don't just eyeball it. |
| R9 | **Promote the header to a fixed sibling, not a scrolling child.** The phone page's header (`VitTopChrome`, or whatever it wraps inside `VitAutoHidePageScaffold`/a leading widget in its `SingleChildScrollView`) has no single scroll offset to auto-hide against once R4 splits the body into two independently-scrolling columns. Reuse the exact same header widget/call — don't rebuild it — just move it to be a `Column` sibling above `Expanded(dashboard)`, outside any scaffold that ties it to one scrollable's offset. This is still "reusing the public widget" (R2), only its position changes. |

## Step checklist (new tablet page)

1. Confirm the screen qualifies — see "When to build a dedicated tablet page."
2. Add `<Feature>ResponsiveEntry` + wire it at the existing route (R1).
3. Build `<Feature>TabletPage`, reusing phone widgets (R2); write new public panel widgets only for sections that are private to the phone page's part family.
4. Pick the two-column threshold empirically (R3, R8).
5. Row/Expanded/independent-scroll structure (R4); per-column `Align`+`ConstrainedBox` width caps (R5); relaxed rhythm (R6); secondary-column panel framing (R7); header promoted to a fixed `Column` sibling (R9).
6. Register the dispatcher in `page_rhythm_layout_registry.dart` and `top_header_visual_archetype_audit.dart` (R1).
7. Add a widget test that pumps at the page's own two-column width and asserts `tester.takeException()` is `null` (the overflow guard) plus both columns' key content is present — the phone-width tests in the same file do **not** exercise this path.
8. Run the existing check suite (§5 of `Flutter-Design-System-Reference.md`) — a new tablet file is scanned by the same page-rhythm/card-tile/content-width audits as any phone file; no separate command exists yet.

## Anti-patterns

| Anti-pattern | Result |
| --- | --- |
| `ConstrainedBox(maxWidth: …)` directly on the `Row`/`Expanded` instead of inside each column's `SingleChildScrollView` child | No-op — the tight incoming constraint from `Expanded` wins; width never actually caps |
| One `SingleChildScrollView` wrapping the whole two-column `Row` | Unbounded-height layout errors once any column's content needs a bounded height |
| Editing the phone reference page "to share more code" with the tablet variant | Violates R2 — breaks that page's own locked reference-consistency audit/golden |
| A second global breakpoint constant for one screen's own fallback width | Should be a local, documented, page-scoped constant instead (R3) |
| Skipping the ≥threshold widget test because the phone-width tests already pass | Leaves the actual two-column layout completely unverified |
| Keeping the phone page's `VitAutoHidePageScaffold`/scroll-leading header as-is in the tablet page | Header has no single scroll offset to hide/show against once R4 splits the body — either breaks or silently no-ops |

## Limitations

- No dedicated audit tool — this is prose plus a required widget-test pattern, not a `tool/*_audit.dart` script. Whether every tablet file actually follows R1–R8 is not automatically checked; review is manual until enough tablet screens exist for a real automatable pattern to emerge.
- Two reference implementations (`HomeTabletPage`, `WalletTabletPage`) as of writing — enough to confirm R1-R9 generalize, not yet enough to promote pattern deviations into hard rules. R8's safety-margin numbers (640/440 caps, 900 threshold) held unchanged for both; re-validate before assuming they hold for a third screen with different content density.

## Upgrade path

1. ~~When a second dedicated tablet screen ships, extract its width constants into a shared file if they match the first screen's.~~ Done — `lib/app/theme/tablet_dashboard_widths.dart`, after `WalletTabletPage` confirmed `HomeTabletPage`'s numbers unchanged. Next: when a third screen ships, evaluate whether a `tool/tablet_dashboard_audit.dart` (mirroring `card_tile_audit.dart`'s shape) is now worth building — two data points confirmed R1-R9 generalize, but that's not yet enough signal for what an automated check should assert.
2. If a screen needs a width tier beyond `AppBreakpoints.tablet`, promote it to a real global breakpoint only once ≥2 screens independently need the same cutoff.

## Verify

```bash
cd flutter_app
flutter analyze <touched tablet page file>
flutter test <touched tablet page test file> --reporter=compact
dart run tool/page_rhythm_audit.dart --check --strict-full
dart run tool/card_tile_audit.dart --check --strict-full
dart run tool/page_content_width_audit.dart --check
```
