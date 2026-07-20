// Origin: dc19f520 (2026-07-17) - feat(a11y): hoàn tất A11Y-1 — semanticIdentifier + nhãn tiếng Việt cho ~420 màn hình, đóng gate GĐ0+GĐ1
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A11Y-1 step 2 (docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv):
/// screen-reader-announced page labels must be real Vietnamese descriptions,
/// not internal screen codes. Before this migration, 409 `semanticLabel:`
/// values across 393 call sites carried an `SC-XXX PageName` code that
/// assistive tech read aloud verbatim ("SC-327 StakingEarnPage"). The code
/// now belongs in `semanticIdentifier:` (mapped to [Semantics.identifier],
/// which is NOT announced) — every page wrapper (VitPageLayout,
/// AdminDashboardPageShell, VitTradeHubScaffold, VitTradeDetailScaffold,
/// VitTradeSimpleShell, VitAutoHidePageScaffold, VitAutoHideHeaderScaffold,
/// VitP2PFlowScaffold, CrossModuleTabbedPageShell, VitWalletDetailScaffold)
/// exposes both params.
///
/// This test scans every `semanticLabel:` argument in lib/ (the ARGUMENT,
/// bounded at its own top-level comma so a following `semanticIdentifier:`
/// line is never misread as part of the label) and fails if any string
/// literal inside it — including ternary branches and interpolation-prefixed
/// variants — starts with `SC-<digits>`. Baseline is 0: a true
/// zero-violations check, not a ratchet.
void main() {
  test(
    'announced semanticLabel values never start with an SC- screen code',
    () {
      final violations = <String>[];
      for (final root in ['lib/features', 'lib/app', 'lib/shared']) {
        final dir = Directory(root);
        if (!dir.existsSync()) continue;
        for (final entity in dir.listSync(recursive: true)) {
          if (entity is! File) continue;
          final path = entity.path.replaceAll('\\', '/');
          if (!path.endsWith('.dart')) continue;
          violations.addAll(_violationsIn(path, entity.readAsLinesSync()));
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Screen codes must live in semanticIdentifier:, not the announced '
            'semanticLabel: (A11Y-1). A screen reader speaks the label aloud '
            'verbatim.\n${violations.join('\n')}',
      );
    },
  );
}

final _labelKeyPattern = RegExp(r'\bsemanticLabel:');
final _scValuePattern = RegExp(r"'(\$\w+ )?SC-\d");

/// `'$screenContract P2PSelfieVerificationPage'`-style labels hide the
/// SC-code inside a variable; the tell is an interpolation immediately
/// followed by a bare `XyzPage` identifier (which the language guardrail
/// deliberately exempts as a page-id shape).
final _interpolatedPageIdPattern = RegExp(
  r"'\$\{?\w+\}? [A-Z][A-Za-z0-9]*Page[' ]",
);

List<String> _violationsIn(String path, List<String> lines) {
  final found = <String>[];
  for (var i = 0; i < lines.length; i++) {
    if (!_labelKeyPattern.hasMatch(lines[i])) continue;

    // Join a short window, then bound the argument at its own top-level
    // comma (string-aware) so the scan never bleeds into the next argument.
    final windowEnd = (i + 6).clamp(0, lines.length);
    final window = lines.sublist(i, windowEnd).join(' ');
    final start = window.indexOf('semanticLabel:') + 'semanticLabel:'.length;
    var inString = false;
    var end = window.length;
    for (var k = start; k < window.length; k++) {
      final ch = window[k];
      if (ch == "'") inString = !inString;
      if (ch == ',' && !inString) {
        end = k;
        break;
      }
    }
    final argument = window.substring(start, end);

    if (_scValuePattern.hasMatch(argument) ||
        _interpolatedPageIdPattern.hasMatch(argument)) {
      found.add('$path:${i + 1}: ${argument.trim()}');
    }
  }
  return found;
}
