import 'dart:io';

/// One-shot codemod: SizedBox(height: AppSpacing.x3|x4) → pageRhythm* / rowGap.
void main(List<String> args) {
  final modules = args.isEmpty
      ? [
          'earn',
          'dca',
          'trade',
          'p2p',
          'markets',
          'arena',
          'rewards',
          'referral',
          'launchpad',
          'wallet',
          'profile',
          'support',
          'cross_module',
          'auth',
          'admin',
          'enterprise_states',
          'home',
          'predictions',
          'discovery',
          'notifications',
          'settings',
          'vip',
          'news',
        ]
      : args;

  var changedFiles = 0;
  for (final module in modules) {
    final dir = Directory('lib/features/$module/presentation');
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final relative = entity.path.replaceAll('\\', '/');
      if (relative.contains('/dev/')) continue;

      final original = entity.readAsStringSync();
      final converted = _convertFile(original, relative);
      if (converted != original) {
        entity.writeAsStringSync(converted);
        changedFiles++;
      }
    }
  }
  stdout.writeln('Semantic x3/x4 migration: $changedFiles files updated.');
}

String _convertFile(String source, String path) {
  final isHero = RegExp(
    r'hero|hero_actions|ladder_hero|backtest_hero|claim_receipt_hero',
  ).hasMatch(path);
  final lines = source.split('\n');
  final out = <String>[];

  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];
    if (_isCompoundHeight(line)) {
      out.add(line);
      continue;
    }

    if (_plainX3Height.hasMatch(line)) {
      final prev = lines.sublist(i > 3 ? i - 3 : 0, i + 1).join(' ');
      if (_listItemContext.hasMatch(prev) || _listItemContext.hasMatch(line)) {
        line = line.replaceAll(
          _plainX3Height,
          'SizedBox(height: AppSpacing.rowGap',
        );
      } else {
        line = line.replaceAll(
          _plainX3Height,
          'SizedBox(height: AppSpacing.pageRhythmStandardInnerGap',
        );
      }
    }

    if (_plainX4Height.hasMatch(line)) {
      if (isHero) {
        line = line.replaceAll(
          _plainX4Height,
          'SizedBox(height: AppSpacing.pageRhythmRelaxedInnerGap',
        );
      } else {
        final prev = lines.sublist(i > 3 ? i - 3 : 0, i + 1).join(' ');
        if (_listItemContext.hasMatch(prev) ||
            _listItemContext.hasMatch(line)) {
          line = line.replaceAll(
            _plainX4Height,
            'SizedBox(height: AppSpacing.rowGap',
          );
        } else {
          line = line.replaceAll(
            _plainX4Height,
            'SizedBox(height: AppSpacing.pageRhythmStandardSectionGap',
          );
        }
      }
    }

    out.add(line);
  }
  return out.join('\n');
}

bool _isCompoundHeight(String line) {
  return RegExp(r'SizedBox\s*\(\s*height:\s*[^)]*[\+\-]').hasMatch(line);
}

final _plainX3Height = RegExp(r'SizedBox\s*\(\s*height:\s*AppSpacing\.x3\b');
final _plainX4Height = RegExp(r'SizedBox\s*\(\s*height:\s*AppSpacing\.x4\b');
final _listItemContext = RegExp(
  r'if\s*\(\s*(?:i|index|j)\b[^)]*(?:!=|\.length|last)',
);
