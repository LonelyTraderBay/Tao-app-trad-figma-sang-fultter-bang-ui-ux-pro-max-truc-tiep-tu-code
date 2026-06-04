import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum BackNavigationMode { parentRouteOnly, historyThenFallback }

void goBackOrFallback(
  BuildContext context, {
  required String fallbackPath,
  BackNavigationMode mode = BackNavigationMode.parentRouteOnly,
}) {
  final safeFallback = _normalizeInternalPath(fallbackPath) ?? '/home';
  assert(
    _normalizeInternalPath(fallbackPath) != null,
    'fallbackPath must be an internal app route.',
  );

  switch (mode) {
    case BackNavigationMode.parentRouteOnly:
      context.go(safeFallback);
    case BackNavigationMode.historyThenFallback:
      if (context.canPop()) {
        context.pop();
        return;
      }
      context.go(safeFallback);
  }
}

String resolveSafeBackPath({
  required String? candidate,
  required String fallbackPath,
  List<String> allowedPrefixes = const [],
}) {
  final safeFallback = _normalizeInternalPath(fallbackPath) ?? '/home';
  final safeCandidate = _normalizeInternalPath(candidate);
  if (safeCandidate == null) return safeFallback;
  if (!_isAllowedByPrefix(safeCandidate, allowedPrefixes)) {
    return safeFallback;
  }
  return safeCandidate;
}

String? _normalizeInternalPath(String? rawPath) {
  if (rawPath == null) return null;
  final trimmed = rawPath.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith('//')) return null;
  if (trimmed.contains(r'\')) return null;
  if (trimmed.contains('\n') || trimmed.contains('\r')) return null;

  final decoded = _decodePath(trimmed);
  if (decoded == null || decoded.isEmpty) return null;
  if (!decoded.startsWith('/') || decoded.startsWith('//')) return null;
  if (decoded.contains(r'\')) return null;
  if (decoded.contains('\n') || decoded.contains('\r')) return null;
  if (decoded == '/..' ||
      decoded.startsWith('/../') ||
      decoded.endsWith('/..') ||
      decoded.contains('/../')) {
    return null;
  }

  final uri = Uri.tryParse(decoded);
  if (uri == null || uri.hasScheme || uri.hasAuthority) return null;
  if (uri.pathSegments.any((segment) => segment == '..')) return null;
  return decoded;
}

String? _decodePath(String path) {
  try {
    return Uri.decodeComponent(path);
  } on FormatException {
    return null;
  }
}

bool _isAllowedByPrefix(String path, List<String> allowedPrefixes) {
  if (allowedPrefixes.isEmpty) return true;
  for (final prefix in allowedPrefixes) {
    final normalizedPrefix = _normalizeInternalPath(prefix);
    if (normalizedPrefix == null) continue;
    if (path == normalizedPrefix) return true;
    if (path.startsWith('$normalizedPrefix?')) return true;
    if (normalizedPrefix.endsWith('/')) {
      if (path.startsWith(normalizedPrefix)) return true;
    } else if (path.startsWith('$normalizedPrefix/')) {
      return true;
    }
  }
  return false;
}
