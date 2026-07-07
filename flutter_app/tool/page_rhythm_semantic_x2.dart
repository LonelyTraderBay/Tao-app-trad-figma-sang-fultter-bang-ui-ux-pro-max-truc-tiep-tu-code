import 'dart:io';

/// Codemod: SizedBox(height: AppSpacing.x2) → pageRhythmCompactInnerGap.
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
          'onboarding',
        ]
      : args;

  var changedFiles = 0;
  var replacements = 0;
  for (final module in modules) {
    final dir = Directory('lib/features/$module/presentation');
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final relative = entity.path.replaceAll('\\', '/');
      if (relative.contains('/dev/')) continue;

      final original = entity.readAsStringSync();
      final converted = original.replaceAll(
        _plainX2Height,
        'SizedBox(height: AppSpacing.pageRhythmCompactInnerGap',
      );
      if (converted != original) {
        entity.writeAsStringSync(converted);
        changedFiles++;
        replacements += _plainX2Height.allMatches(original).length;
      }
    }
  }
  stdout.writeln(
    'Semantic x2 migration: $changedFiles files, $replacements replacements.',
  );
}

final _plainX2Height = RegExp(
  r'SizedBox\s*\(\s*height:\s*AppSpacing\.x2\b',
);
