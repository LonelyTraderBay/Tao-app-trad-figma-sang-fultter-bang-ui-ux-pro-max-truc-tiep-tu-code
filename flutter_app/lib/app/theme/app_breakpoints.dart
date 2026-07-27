/// Screen-width thresholds for tablet-adaptive layout. Phone-first stays the
/// baseline (`AGENTS.md` UI Rules) — these mark where the shell and, module
/// by module, page content switch to a tablet composition.
final class AppBreakpoints {
  const AppBreakpoints._();

  /// Material 3 "medium" window-size-class start. At or above this width,
  /// [VitAppShell] renders a navigation rail instead of the bottom nav, and
  /// tablet-adaptive pages (starting with Home, SC-007) switch layout.
  static const double tablet = 600;

  static bool isTablet(double width) => width >= tablet;
}
