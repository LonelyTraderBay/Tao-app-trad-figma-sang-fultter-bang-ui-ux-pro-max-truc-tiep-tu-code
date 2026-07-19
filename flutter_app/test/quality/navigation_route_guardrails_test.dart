// Origin: 3a76a6e8 (2026-06-02) - feat: chuẩn hoá điều hướng và audit route enterprise
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presentation navigation raw route literals do not increase', () {
    final findings = _rawPresentationRouteLiteralCalls();

    expect(
      findings.length,
      lessThanOrEqualTo(28),
      reason:
          'Presentation navigation should prefer AppRoutePaths or typed '
          'NavigationIntent values instead of direct raw route strings. '
          'Existing raw-string debt may be reduced by module passes, but new '
          'direct raw route calls must not be added.',
    );
  });
}

List<String> _rawPresentationRouteLiteralCalls() {
  final roots = [
    Directory('lib/features'),
    Directory('lib/shared'),
    Directory('lib/app'),
  ];
  final rawRouteCall = RegExp(
    r"""\bcontext\.(?:go|push|replace)\(\s*(?:"/|'/)""",
  );
  final findings = <String>[];

  for (final root in roots.where((directory) => directory.existsSync())) {
    for (final file
        in root
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      final path = _normalize(file.path);
      if (!_isPresentationSource(path)) continue;

      final lines = file.readAsLinesSync();
      for (var index = 0; index < lines.length; index += 1) {
        final line = lines[index];
        if (rawRouteCall.hasMatch(line)) {
          findings.add('$path:${index + 1}: ${line.trim()}');
        }
      }
    }
  }

  return findings;
}

bool _isPresentationSource(String path) {
  if (path.contains('/app/router/')) return false;
  return path.contains('/presentation/') ||
      path.startsWith('lib/shared/') ||
      path.startsWith('lib/app/');
}

String _normalize(String path) => path.replaceAll('\\', '/');
