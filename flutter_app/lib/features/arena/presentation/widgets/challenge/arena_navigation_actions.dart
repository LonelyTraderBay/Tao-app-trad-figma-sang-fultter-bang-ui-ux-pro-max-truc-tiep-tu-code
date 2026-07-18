import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Shared haptic-navigation helper for the Arena page family.
///
/// Pages keep a thin per-page `_close()` wrapper that calls
/// `goBackOrFallback` (see `lib/core/navigation/back_navigation.dart`) so the
/// per-page fallback route stays a plain parameter and `onBack: _close`-style
/// tear-offs keep working, while back-navigation logic stays consolidated in
/// the app-wide helper rather than duplicated per page.
extension ArenaNavigationActions on BuildContext {
  /// Selection-click haptic feedback followed by `context.go(route)`.
  void goHaptic(String route) {
    unawaited(HapticFeedback.selectionClick());
    go(route);
  }
}
