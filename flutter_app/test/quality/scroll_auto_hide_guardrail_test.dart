// Origin: 1ed62fcf (2026-07-10) - feat(flutter): chuẩn hóa design system toàn app — tiêu chuẩn UI, spacing token, guardrail và audit
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks the scroll auto-hide contract from
/// `docs/02_FLUTTER_MIGRATION/standards/Scroll-Auto-Hide-Standard.md`.
///
/// Collapsing chrome via layout height (`heightFactor` / removing a Column
/// child above an Expanded scroll body) shrinks [ScrollMetrics.maxScrollExtent]
/// and can clamp the offset back to the top on short pages. Only the shared
/// scaffold may do that collapse, and it must keep the `_canHideHeader` gate.
void main() {
  const sharedScaffoldPath =
      'lib/shared/layout/vit_auto_hide_header_scaffold.dart';

  test(
    'shared auto-hide scaffold keeps the short-list collapse budget gate',
    () {
      final file = File(sharedScaffoldPath);
      expect(file.existsSync(), isTrue, reason: 'Missing $sharedScaffoldPath');

      final source = file.readAsStringSync();
      expect(
        source.contains('_canHideHeader'),
        isTrue,
        reason:
            'VitAutoHideHeaderScaffold must keep _canHideHeader so short lists '
            'do not snap scroll offset when the header collapses.',
      );
      expect(
        source.contains('_collapseBudget'),
        isTrue,
        reason:
            'VitAutoHideHeaderScaffold must keep _collapseBudget (header-height '
            'reserve) before hiding the header.',
      );
      expect(
        source.contains('maxScrollExtent'),
        isTrue,
        reason:
            'Collapse gate must compare pixels against maxScrollExtent after '
            'accounting for header height.',
      );
    },
  );

  test('app code does not hand-roll layout-collapsing auto-hide headers', () {
    final scanRoots = [
      Directory('lib/app'),
      Directory('lib/features'),
      Directory('lib/shared'),
    ];
    final headerVisibleViolations = <String>[];
    final heightFactorViolations = <String>[];

    for (final root in scanRoots) {
      if (!root.existsSync()) {
        continue;
      }

      for (final entity in root.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }

        final path = entity.path.replaceAll('\\', '/');
        if (path.endsWith(sharedScaffoldPath)) {
          continue;
        }

        final lines = entity.readAsLinesSync();
        for (var index = 0; index < lines.length; index += 1) {
          final line = lines[index];
          final trimmed = line.trim();
          if (trimmed.contains('_headerVisible')) {
            headerVisibleViolations.add('$path:${index + 1}: $trimmed');
          }
          // Layout-collapsing hide tied to a visibility flag — the snap-back
          // anti-pattern. Chart/progress heightFactor usages without `visible`
          // are unrelated and ignored.
          if (trimmed.contains('heightFactor:') &&
              trimmed.contains('visible')) {
            heightFactorViolations.add('$path:${index + 1}: $trimmed');
          }
        }
      }
    }

    expect(
      headerVisibleViolations,
      isEmpty,
      reason:
          'Use VitAutoHideHeaderScaffold / VitAutoHidePageScaffold — do not '
          'hand-roll _headerVisible collapse.\n'
          '${headerVisibleViolations.join('\n')}',
    );
    expect(
      heightFactorViolations,
      isEmpty,
      reason:
          'Do not collapse scroll chrome with heightFactor tied to visibility '
          'outside vit_auto_hide_header_scaffold.dart (overlay hide instead).\n'
          '${heightFactorViolations.join('\n')}',
    );
  });
}
