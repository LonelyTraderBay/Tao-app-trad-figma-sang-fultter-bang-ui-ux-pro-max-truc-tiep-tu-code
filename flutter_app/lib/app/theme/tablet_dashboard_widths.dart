/// Shared starting-point width tokens for two-column tablet dashboard pages
/// (see `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`
/// R3/R8). `HomeTabletPage` and `WalletTabletPage` both use these values
/// unchanged as of writing — extracted here once a second screen confirmed
/// the same numbers, per each page's own original doc comment.
///
/// These are defaults, not a hard global rule: a future tablet dashboard
/// with denser or sparser content may empirically need a different
/// threshold or cap. In that case, keep a page-local `static const`
/// override instead of changing these shared values — changing them here
/// would silently shift the proven safety margin (R8) for every page that
/// currently relies on them unchanged.
final class TabletDashboardWidths {
  const TabletDashboardWidths._();

  /// Below this content width, a two-column dashboard doesn't have enough
  /// room per column for widgets sized for phone content without
  /// overflowing — pages fall back to a single column (still tablet shell,
  /// still nav rail, just not side-by-side) down to `AppBreakpoints.tablet`.
  static const double twoColumnMinWidth = 900;

  /// Caps the primary (main-content) column's own width on wide
  /// tablets/landscape so rows and cards built for phone-width content
  /// don't stretch into sparse, oversized layouts.
  static const double primaryColumnMaxWidth = 640;

  /// Caps the secondary (sidebar-panel) column's own width — see
  /// [primaryColumnMaxWidth].
  static const double secondaryColumnMaxWidth = 440;
}
