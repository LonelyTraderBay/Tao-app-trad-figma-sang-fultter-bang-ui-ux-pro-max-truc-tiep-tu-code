import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'architecture_baseline_guardrails_test_utils.dart';

void main() {
  group('architecture baseline guardrails - size and style debt', () {
    // ARCH-A4 (A-Plus GĐ3): suffix `_part_NN` = tách CƠ HỌC tạm thời (nợ theo
    // dõi). Toàn lib/ hiện = 0 (đã trả sạch, migrate về tên vai trò ổn định
    // _sections/_common/_widgets). Khóa ở 0 để chặn tái lập tách cơ học mới —
    // part-file mới phải mang tên vai trò ổn định, không phải số thứ tự. Quy
    // ước: AGENTS.md mục "Quy ước part-file".
    test('không tái lập part-file tách cơ học _part_NN (ARCH-A4)', () {
      final mechanicalParts = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .map((file) => normalizePath(file.path))
          .where((path) => RegExp(r'_part_\d+\.dart$').hasMatch(path))
          .toList();

      expect(
        mechanicalParts,
        isEmpty,
        reason:
            'part-file _part_NN là tách cơ học tạm (nợ đã trả về 0) — đặt tên '
            'vai trò ổn định (_sections/_common/_widgets) thay vì số thứ tự '
            '(AGENTS.md "Quy ước part-file"): $mechanicalParts',
      );
    });

    test('presentation page part-file debt does not increase', () {
      final pagePartFiles = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<File>()
          .map((file) => normalizePath(file.path))
          .where(
            (path) =>
                path.contains('/presentation/pages/') &&
                RegExp(r'_part_.*\.dart$').hasMatch(path),
          )
          .toList();

      expect(
        pagePartFiles.length,
        lessThanOrEqualTo(218),
        reason:
            'Page part-files are tracked refactor debt. New reusable UI '
            'should move into presentation/widgets/ instead of adding more '
            'presentation/pages/*_part_*.dart files.',
      );
    });

    test('wallet uses presentation widgets for high-volume UI', () {
      final walletWidgetFiles =
          Directory('lib/features/wallet/presentation/widgets')
              .listSync(recursive: true)
              .whereType<File>()
              .where((file) => file.path.endsWith('.dart'))
              .toList();

      expect(
        walletWidgetFiles,
        isNotEmpty,
        reason:
            'Wallet is a high-volume feature. Reusable wallet UI should live '
            'under presentation/widgets/ instead of adding more page-local '
            'or part-file widgets.',
      );
    });

    test('hardcoded color usage does not increase', () {
      final allHardcoded =
          sourceMatches(root: 'lib', pattern: RegExp(r'Color\(0x')).length +
          sourceMatches(root: 'test', pattern: RegExp(r'Color\(0x')).length;
      final runtimeHardcoded = sourceMatches(
        root: 'lib',
        pattern: RegExp(r'Color\(0x'),
      );
      final runtimeHardcodedOutsideTheme = sourceMatches(
        root: 'lib',
        pattern: RegExp(r'Color\(0x'),
        pathFilter: (path) => !path.startsWith('lib/app/theme/'),
      );
      final materialColors = sourceMatches(
        root: 'lib',
        pattern: RegExp(r'\bColors\.'),
      );

      // Baselines raised after TOKEN-WARN-01 added 4 new canonical color
      // literals in lib/app/theme/app_colors.dart (riskWarning,
      // riskWarning08/10/15) plus 2 matching regression assertions in
      // test/app/theme/app_tokens_test.dart. New literals live in the
      // canonical theme file, which runtimeHardcodedOutsideTheme below
      // still requires to stay at zero.
      expect(allHardcoded, lessThanOrEqualTo(216));
      expect(runtimeHardcoded.length, lessThanOrEqualTo(189));
      expect(runtimeHardcodedOutsideTheme.length, lessThanOrEqualTo(0));
      expect(materialColors.length, lessThanOrEqualTo(0));
    });

    test('large-file architecture debt does not increase', () {
      final over600 = _dartFilesOver(root: 'lib/features', lineCount: 600);
      final over1200 = _dartFilesOver(root: 'lib/features', lineCount: 1200);

      expect(over600.length, lessThanOrEqualTo(239));
      expect(over1200.length, lessThanOrEqualTo(4));
    });

    test('non-delegating String _format* declarations do not increase', () {
      // A-Plus roadmap DEBT-83 (2026-07-16). 288 non-delegating `_format*`
      // functions existed at the time this test was added (verified live,
      // not the roadmap's older "312" estimate) — most are legitimate
      // module-specific formatting (dates, enum labels, counts), not money
      // duplication, so this is a ratchet on the total count rather than a
      // named allowlist (288 entries would be unmaintainable). DEBT-84's
      // money_copy_guardrail_test.dart separately targets the specific
      // dollar-sign/toStringAsFixed money-copy-drift pattern. Reduce this
      // number only by migrating a function to delegate (DEBT-82); do not
      // raise it for a new function that could delegate instead.
      //
      // Baseline lowered 288 -> 286: DEBT-81 (2026-07-16) migrated
      // earn/presentation/widgets/hub/auto_compound_settings_shared.dart's
      // `_formatUsd` and earn/presentation/widgets/staking/
      // staking_auto_compound_shared.dart's `_formatCurrency` to delegate
      // to EarnFormatters.usd / VitFormat.usd+usdWhole, fixing the exact
      // money-copy drift bug DEBT-84 guards against ($1234.50 vs
      // $1,234.50 for the same feature).
      // Lowered 286 -> 281 after DEBT-82 lô 5 (2026-07-16): 5 non-delegating
      // vote/request/ETH-count and USD-whole formatters in the earn/staking
      // module now delegate to VitFormat.count / VitFormat.usdWhole.
      final count = _nonDelegatingFormatCount(root: 'lib/features');
      expect(count, lessThanOrEqualTo(281));
    });
  });
}

List<String> _dartFilesOver({required String root, required int lineCount}) {
  final directory = Directory(root);
  if (!directory.existsSync()) return const [];

  final findings = <String>[];
  for (final file
      in directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final lines = file.readAsLinesSync().length;
    if (lines > lineCount) {
      findings.add('${normalizePath(file.path)}:$lines');
    }
  }
  return findings;
}

final _formatDeclRe = RegExp(r'String\s+_format\w*\s*\(');
final _delegatesRe = RegExp(r'VitFormat\.|Formatters\.');

int _nonDelegatingFormatCount({required String root}) {
  final directory = Directory(root);
  if (!directory.existsSync()) return 0;

  var count = 0;
  for (final file
      in directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i += 1) {
      if (!_formatDeclRe.hasMatch(lines[i])) continue;
      final window = lines
          .sublist(i, (i + 5).clamp(0, lines.length))
          .join('\n');
      if (!_delegatesRe.hasMatch(window)) count += 1;
    }
  }
  return count;
}
