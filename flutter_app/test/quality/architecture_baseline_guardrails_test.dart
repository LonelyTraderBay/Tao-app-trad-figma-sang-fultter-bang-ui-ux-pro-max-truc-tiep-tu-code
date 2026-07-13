import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('architecture baseline guardrails', () {
    test(
      'all feature modules expose domain, data, and presentation layers',
      () {
        final featureDirs = Directory(
          'lib/features',
        ).listSync().whereType<Directory>().toList();
        final missing = <String>[];

        for (final feature in featureDirs) {
          final path = _normalize(feature.path);
          for (final layer in ['domain', 'data', 'presentation']) {
            final layerPath = '$path/$layer';
            if (!Directory(layerPath).existsSync()) {
              missing.add(layerPath);
            }
          }
        }

        expect(missing, isEmpty);
      },
    );

    test('presentation page and widget files do not import data facades', () {
      final imports = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data",
        ),
        pathFilter: (path) =>
            path.contains('/presentation/pages/') ||
            path.contains('/presentation/widgets/'),
      );

      expect(
        imports,
        isEmpty,
        reason: 'Pages/widgets must read domain/controller facades, not data.',
      );
    });

    test('presentation controllers avoid mock and remote repositories', () {
      final imports = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data/repositories/(mock|remote)_",
        ),
        pathFilter: (path) => path.contains('/presentation/controllers/'),
      );

      expect(
        imports,
        isEmpty,
        reason:
            'Presentation controllers may depend on same-feature providers, '
            'but must not expose mock or remote repositories.',
      );
    });

    test('non-controller direct feature data imports do not increase', () {
      final imports = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(r"^import 'package:vit_trade_flutter/features/.*/data"),
        pathFilter: (path) => !path.contains('/presentation/controllers/'),
      );

      expect(
        imports.length,
        // Baseline raised 27 -> 28: Phase 0 of the trade module split moved
        // the base `tradeRepositoryProvider` out of
        // `features/trade/data/providers/trade_repository_provider.dart`
        // into `features/trade_core/data/providers/trade_repository_provider.dart`.
        // The 6 narrow per-domain providers stay in `features/trade/data/`
        // for now and must `import` the relocated base provider — a
        // necessary cross-feature data import during the split. This count
        // should trend back down as narrow providers move into their own
        // sibling modules in later phases.
        //
        // Baseline raised 28 -> 29: Phase 1 Batch 1 (trade_compliance
        // extraction) added
        // `features/trade_compliance/data/providers/trade_repository_provider.dart`,
        // which imports the `trade_core` base provider to expose the
        // narrow `tradeRegulatoryRepositoryProvider` — the same
        // necessary-during-the-split cross-feature data import pattern as
        // the 27 -> 28 bump above, now repeated for the regulatory domain's
        // new sibling module. Trends back down once no narrow provider
        // needs to reach across to `trade_core` directly.
        //
        // Baseline raised 29 -> 31: Phase 1 Batch 3 (trade_compliance mock
        // repository decoupling) gave `trade_compliance` its own
        // independent `MockTradeRegulatoryRepository` /
        // `FailClosedTradeRegulatoryRepository`, so:
        // (a) `features/trade_compliance/data/providers/trade_repository_provider.dart`
        // now constructs those two directly instead of narrowing
        // `trade_core`'s union provider (net +1 import there — it trades
        // the old `trade_core` import for two new same-feature-family
        // `trade_compliance/data/repositories/*` imports); and
        // (b) `features/trade/data/repositories/mock_trade_repository.dart`
        // now imports `MockTradeRegulatoryRepository` to delegate its
        // `TradeRegulatoryRepository` surface to it (+1), since the 4
        // regulatory/execution-analytics mixins that used to implement
        // that surface directly moved to `trade_compliance` with their
        // fixtures. Both are necessary cross-feature data imports during
        // the split and should trend back down once `trade`'s remaining
        // domains extract into their own sibling modules and no longer
        // need this delegation.
        //
        // Baseline raised 31 -> 32: Phase 2 Batch 1 (trade_copy extraction)
        // added
        // `features/trade_copy/data/providers/trade_repository_provider.dart`,
        // which imports the `trade_core` base provider to expose the
        // narrow `tradeCopyTradingRepositoryProvider` — the same
        // necessary-during-the-split cross-feature data import pattern as
        // the 28 -> 29 bump above, now repeated for the copy-trading
        // domain's new sibling module. Trends back down once no narrow
        // provider needs to reach across to `trade_core` directly.
        //
        // Baseline raised 32 -> 34: Phase 2 Batch 3 (trade_copy mock
        // repository decoupling) gave `trade_copy` its own independent
        // `MockTradeCopyTradingRepository` / `FailClosedTradeCopyTradingRepository`,
        // so: (a) `features/trade_copy/data/providers/trade_repository_provider.dart`
        // now constructs those two directly instead of narrowing
        // `trade_core`'s union provider (net +1 import there — it trades the
        // old `trade_core` import for two new same-feature-family
        // `trade_copy/data/repositories/*` imports); and (b)
        // `features/trade/data/repositories/mock_trade_repository.dart` now
        // imports `MockTradeCopyTradingRepository` to delegate its
        // `TradeCopyTradingRepository` surface to it (+1), since the 3
        // copy-trading mixins that used to implement that surface directly
        // moved to `trade_copy` with their fixtures. Both are necessary
        // cross-feature data imports during the split and should trend back
        // down once `trade`'s remaining domains extract into their own
        // sibling modules and no longer need this delegation.
        //
        // Baseline raised 34 -> 35: Phase 3 Batch 1 (trade_bots extraction)
        // added
        // `features/trade_bots/data/providers/trade_repository_provider.dart`,
        // which imports the `trade_core` base provider to expose the narrow
        // `tradingBotsRepositoryProvider`/`tradeBotAnalyticsRepositoryProvider`
        // pair — the same necessary-during-the-split cross-feature data
        // import pattern as the 31 -> 32 bump above, now repeated for the
        // trading-bots domain's new sibling module. Trends back down once
        // no narrow provider needs to reach across to `trade_core` directly.
        //
        // Baseline raised 35 -> 37: Phase 3 Batch 3 (trade_bots mock
        // repository decoupling) gave `trade_bots` its own independent
        // `MockTradeBotsRepository` / `FailClosedTradeBotsRepository` (one
        // combined pair covering both `TradingBotsRepository` and
        // `TradeBotAnalyticsRepository` — see that class's doc comment for
        // why), so: (a)
        // `features/trade_bots/data/providers/trade_repository_provider.dart`
        // now constructs those two directly instead of narrowing
        // `trade_core`'s union provider (net +1 import there — it trades
        // the old `trade_core` import for two new same-feature-family
        // `trade_bots/data/repositories/*` imports); and (b)
        // `features/trade/data/repositories/mock_trade_repository.dart` now
        // imports `MockTradeBotsRepository` to delegate its
        // `TradingBotsRepository`/`TradeBotAnalyticsRepository` surface to
        // it (+1), since the 2 bot mixins that used to implement that
        // surface directly moved to `trade_bots` with their fixtures. Both
        // are necessary cross-feature data imports during the split and
        // should trend back down once `trade`'s remaining domains extract
        // into their own sibling modules and no longer need this
        // delegation.
        //
        // Baseline unchanged at 37: Phase 4 Batch 1 (trade_terminal
        // extraction, the final domain phase) added
        // `features/trade_terminal/data/providers/trade_repository_provider.dart`,
        // which imports the `trade_core` base provider to expose the narrow
        // `spotTradeRepositoryProvider`/`tradeFuturesMarginRepositoryProvider`
        // pair — the same necessary-during-the-split cross-feature data
        // import pattern as the earlier per-domain bumps above, now
        // repeated for the spot/futures-margin domain's new sibling module
        // (+1 import). This is net-neutral because it replaces the one
        // matching import that used to live in
        // `features/trade/data/providers/trade_repository_provider.dart`
        // (also importing the `trade_core` base provider), which is now
        // deleted (-1 import) since Phase 4 Batch 1 was the last of the 6
        // narrow providers to move out of `features/trade/data/`.
        //
        // Baseline raised 37 -> 38: Phase 4 Batch 3 (trade_terminal mock
        // repository decoupling — the final domain of the trade module
        // split) gave `trade_terminal` its own independent
        // `MockTradeTerminalRepository` / `FailClosedTradeTerminalRepository`
        // (one combined pair covering both `SpotTradeRepository` and
        // `TradeFuturesMarginRepository` — see that class's doc comment for
        // why), so: (a)
        // `features/trade_terminal/data/providers/trade_repository_provider.dart`
        // now constructs those two directly instead of narrowing
        // `trade_core`'s union provider (net +1 import there — it trades
        // the one old `trade_core` import for two new same-feature-family
        // `trade_terminal/data/repositories/*` imports); and (b) the
        // `MockTradeRepository` delegation hub now imports
        // `MockTradeTerminalRepository` to delegate its
        // `SpotTradeRepository`/`TradeFuturesMarginRepository` surface to
        // it (+1), since the 4 terminal mixins that used to implement that
        // surface directly moved to `trade_terminal` with their fixtures.
        // That delegation hub — formerly
        // `features/trade/data/repositories/mock_trade_repository.dart` —
        // also relocated in this batch to
        // `features/trade_core/data/repositories/mock_trade_repository.dart`,
        // since removing the last domain mixin left it with no logic of its
        // own beyond delegating the full `TradeRepository` union, making
        // `trade_core` (the module that owns that union) its natural home.
        // That relocation is itself a net -1: `trade_core`'s base provider
        // used to reach across features for an absolute
        // `features/trade/data/repositories/mock_trade_repository.dart`
        // import; now that the hub lives inside `trade_core` alongside the
        // provider, the same dependency is a same-feature relative import
        // and no longer matches this cross-feature-data-import pattern.
        // Net effect: +1 (a) +1 (b) -1 (relocation) = +1 overall. This was
        // the final domain extraction of the trade module split — no more
        // per-domain batches remain to reduce this further via delegation.
        lessThanOrEqualTo(38),
        reason:
            'Non-controller feature data imports are a tracked architecture '
            'debt metric.',
      );
    });

    test('presentation controller data-provider exposure does not increase', () {
      final imports = _sourceMatches(
        root: 'lib/features',
        pattern: RegExp(
          r"^(import|export) 'package:vit_trade_flutter/features/.*/data/providers/",
        ),
        pathFilter: (path) => path.contains('/presentation/controllers/'),
      );

      expect(
        imports.length,
        lessThanOrEqualTo(0),
        reason:
            'Controller files may temporarily bridge same-feature providers, '
            'but this exposure must trend down to zero.',
      );
    });

    test('presentation controllers exist for migrated high-risk state', () {
      final controllers = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<Directory>()
          .where((directory) {
            final path = _normalize(directory.path);
            return path.endsWith('/presentation/controllers');
          })
          .toList();

      expect(controllers, isNotEmpty);
    });

    test('presentation page part-file debt does not increase', () {
      final pagePartFiles = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<File>()
          .map((file) => _normalize(file.path))
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
          Directory(
            'lib/features/wallet/presentation/widgets',
          ).listSync().whereType<File>().where((file) {
            return file.path.endsWith('.dart');
          }).toList();

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
          _sourceMatches(root: 'lib', pattern: RegExp(r'Color\(0x')).length +
          _sourceMatches(root: 'test', pattern: RegExp(r'Color\(0x')).length;
      final runtimeHardcoded = _sourceMatches(
        root: 'lib',
        pattern: RegExp(r'Color\(0x'),
      );
      final runtimeHardcodedOutsideTheme = _sourceMatches(
        root: 'lib',
        pattern: RegExp(r'Color\(0x'),
        pathFilter: (path) => !path.startsWith('lib/app/theme/'),
      );
      final materialColors = _sourceMatches(
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
  });
}

List<String> _sourceMatches({
  required String root,
  required RegExp pattern,
  bool Function(String path)? pathFilter,
}) {
  final directory = Directory(root);
  if (!directory.existsSync()) return const [];

  final findings = <String>[];
  for (final file
      in directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final path = _normalize(file.path);
    if (pathFilter != null && !pathFilter(path)) continue;

    final lines = file.readAsLinesSync();
    for (var index = 0; index < lines.length; index += 1) {
      final line = lines[index];
      if (pattern.hasMatch(line)) {
        findings.add('$path:${index + 1}');
      }
    }
  }
  return findings;
}

String _normalize(String path) => path.replaceAll('\\', '/');

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
      findings.add('${_normalize(file.path)}:$lines');
    }
  }
  return findings;
}
