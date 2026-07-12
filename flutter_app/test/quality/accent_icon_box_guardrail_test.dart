import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final repoRoot = Directory.current.path;
  final accentIconBoxFile = File(
    '$repoRoot/lib/shared/widgets/vit_accent_icon_box.dart',
  );
  final vitTaskCardFile = File(
    '$repoRoot/lib/shared/widgets/vit_task_card.dart',
  );
  final featuresRoot = Directory('$repoRoot/lib/features');

  test('VitAccentIconBox implements mandatory accent icon contract', () {
    expect(accentIconBoxFile.existsSync(), isTrue);
    final source = accentIconBoxFile.readAsStringSync();

    expect(source, contains('accentIconBoxSize'));
    expect(source, contains('accentIconFillAlpha'));
    expect(source, contains('accentIconBorderAlpha'));
    expect(source, contains('AppRadii.mdRadius'));
    expect(source, contains('muted'));
  });

  test('AppSpacing exposes accent icon box tokens', () {
    final spacingFile = File('$repoRoot/lib/app/theme/app_spacing.dart');
    final source = spacingFile.readAsStringSync();

    for (final token in [
      'accentIconBoxSize',
      'accentIconFillAlpha',
      'accentIconBorderAlpha',
    ]) {
      expect(source, contains(token), reason: 'Missing $token');
    }
    expect(
      source,
      contains('taskCardIconSize = accentIconBoxSize'),
      reason: 'Task card icon size must alias accent icon box size',
    );
  });

  test(
    'VitTaskCard uses VitAccentIconBox — no local accent icon duplicate',
    () {
      expect(vitTaskCardFile.existsSync(), isTrue);
      final source = vitTaskCardFile.readAsStringSync();

      expect(source, contains('VitAccentIconBox'));
      expect(
        source,
        isNot(contains('_VitTaskCardAccentIcon')),
        reason: 'VitTaskCard must not define local accent icon widget',
      );
    },
  );

  test('Feature modules must not define local _AccentIcon classes', () {
    expect(featuresRoot.existsSync(), isTrue);

    const bannedClassNames = ['_AccentIcon', '_IconBubble'];

    for (final entity in featuresRoot.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final source = entity.readAsStringSync();
      for (final bannedName in bannedClassNames) {
        expect(
          source,
          isNot(contains('class $bannedName')),
          reason:
              '${entity.path} must not define local $bannedName — use '
              'VitAccentIconBox',
        );
      }
    }
  });
}
