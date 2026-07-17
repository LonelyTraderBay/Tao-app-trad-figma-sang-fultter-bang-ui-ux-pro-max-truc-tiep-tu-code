import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Single seam every uncaught-error path in the app reports through.
///
/// [NoopErrorReporter] is the only implementation during the mock-data
/// phase — swap it for a Crashlytics/Sentry-backed implementation behind
/// [errorReporterProvider] when a backend/telemetry vendor is chosen; no
/// other file should need to change.
abstract interface class ErrorReporter {
  void report(Object error, StackTrace stack, {String? context});
}

class NoopErrorReporter implements ErrorReporter {
  const NoopErrorReporter();

  @override
  void report(Object error, StackTrace stack, {String? context}) {}
}

final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => const NoopErrorReporter(),
);
