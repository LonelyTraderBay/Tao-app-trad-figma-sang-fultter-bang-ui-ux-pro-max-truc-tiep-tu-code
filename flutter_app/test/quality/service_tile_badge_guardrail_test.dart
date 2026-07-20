// Origin: 905aebcd (2026-07-07) - feat(flutter): chuẩn hóa UI toàn app theo 6 tiêu chuẩn thiết kế
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final repoRoot = Directory.current.path;
  final vitServiceTileFile = File(
    '$repoRoot/lib/shared/widgets/vit_module_components.dart',
  );

  test('VitServiceTile implements mandatory badge safe inset contract', () {
    expect(vitServiceTileFile.existsSync(), isTrue);
    final source = vitServiceTileFile.readAsStringSync();

    expect(source, contains('_contentSafeInsets'));
    expect(source, contains('serviceTileBadgeReserveVertical'));
    expect(source, contains('riskBadgeLabel != null'));
    expect(source, contains('FittedBox'));
    expect(
      source,
      isNot(contains('serviceTileBadgeReserveStart')),
      reason:
          'Do not reintroduce half-width horizontal reserve (shrinks label cell)',
    );
    expect(
      source,
      isNot(contains('serviceTileBadgeReserveEnd')),
      reason:
          'Do not reintroduce half-width horizontal reserve (shrinks label cell)',
    );
  });

  test('AppSpacing exposes service tile badge reserve tokens', () {
    final spacingFile = File('$repoRoot/lib/app/theme/app_spacing.dart');
    final source = spacingFile.readAsStringSync();

    for (final token in [
      'serviceTileBadgeReserveVertical',
      'serviceTileBadgeReserveHorizontal',
      'serviceTileGridAspectStandard',
      'serviceTileGridAspectCompact',
    ]) {
      expect(source, contains(token), reason: 'Missing $token');
    }
  });
}
