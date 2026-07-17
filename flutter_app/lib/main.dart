import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:vit_trade_flutter/app/error_fallback_screen.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/observability/error_reporter.dart';

// Single reporter instance for the two error paths below, which run before
// (and independently of) the widget tree's ProviderScope, so they cannot
// go through `errorReporterProvider`/`ref.read` — that provider exists for
// in-tree code (widgets, controllers) to report through the same seam.
const ErrorReporter _globalErrorReporter = NoopErrorReporter();

void main() {
  _disableDebugVisualOverlays();

  FlutterError.onError = (FlutterErrorDetails details) {
    _globalErrorReporter.report(
      details.exception,
      details.stack ?? StackTrace.empty,
      context: 'FlutterError.onError: ${details.context}',
    );
    FlutterError.presentError(details);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) =>
      const VitErrorFallbackScreen();

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _globalErrorReporter.report(
      error,
      stack,
      context: 'PlatformDispatcher.onError',
    );
    return true;
  };

  runZonedGuarded(
    () => runApp(const VitTradeApp()),
    (Object error, StackTrace stack) {
      _globalErrorReporter.report(error, stack, context: 'runZonedGuarded');
    },
  );
}

void _disableDebugVisualOverlays() {
  assert(() {
    debugPaintBaselinesEnabled = false;
    return true;
  }());
}
