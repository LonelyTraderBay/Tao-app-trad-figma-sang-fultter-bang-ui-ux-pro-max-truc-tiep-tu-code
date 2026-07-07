import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final repoRoot = Directory.current.path;
  final vitTaskCardFile = File('$repoRoot/lib/shared/widgets/vit_task_card.dart');

  test('VitTaskCard implements mandatory intrinsic-height contract', () {
    expect(vitTaskCardFile.existsSync(), isTrue);
    final source = vitTaskCardFile.readAsStringSync();

    expect(source, contains('taskCardPadding'));
    expect(source, contains('VitAccentIconBox'));
    expect(source, contains('taskCardProgressHeight'));
    expect(source, contains('mainAxisSize: MainAxisSize.min'));
    expect(
      source,
      isNot(contains('buttonHero + AppSpacing.x7 + AppSpacing.x5')),
      reason: 'Task cards must not use legacy CTA-reserve minHeight',
    );
    expect(
      source,
      isNot(contains('constraints:')),
      reason: 'VitTaskCard must not set VitCard constraints minHeight',
    );
    expect(
      source,
      isNot(contains('VitCardContentAlign.center')),
      reason: 'Tier E task rows align content from the top',
    );
  });

  test('AppSpacing exposes task card tokens', () {
    final spacingFile = File('$repoRoot/lib/app/theme/app_spacing.dart');
    final source = spacingFile.readAsStringSync();

    for (final token in [
      'taskCardPadding',
      'taskCardIconSize',
      'taskCardProgressHeight',
      'taskCardTitleSubtitleGap',
      'taskCardProgressSectionGap',
      'taskCardRewardRowGap',
      'taskCardListGap',
      'taskCardSubtitleMaxLines',
    ]) {
      expect(source, contains(token), reason: 'Missing $token');
    }
  });

  test('Rewards and Arena task lists use VitTaskCard — no local _TaskCard', () {
    for (final relativePath in [
      'lib/features/rewards/presentation/pages/rewards_hub_page_part_02.dart',
      'lib/features/arena/presentation/pages/arena_points_page_part_02.dart',
    ]) {
      final file = File('$repoRoot/$relativePath');
      expect(file.existsSync(), isTrue, reason: relativePath);
      final source = file.readAsStringSync();

      expect(source, contains('VitTaskCard'), reason: relativePath);
      expect(
        source,
        isNot(contains('class _TaskCard')),
        reason: '$relativePath must not define local _TaskCard',
      );
      expect(
        source,
        isNot(contains('buttonHero + AppSpacing.x7 + AppSpacing.x5')),
        reason: '$relativePath must not use legacy task minHeight',
      );
    }
  });
}
