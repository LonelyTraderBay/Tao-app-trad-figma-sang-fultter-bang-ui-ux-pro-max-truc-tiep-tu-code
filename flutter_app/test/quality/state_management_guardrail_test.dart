import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Scalar/record-of-scalar key types that are safe as a `Provider.family`
/// key without `.autoDispose` — Dart records built only from these fields
/// have structural (value) equality and a naturally bounded key space, so
/// they do not leak an element per rebuild the way an object-with-identity
/// key (e.g. a mutable draft class) does.
const _safeKeyTypes = {'String', 'int', 'double', 'num', 'bool'};

void main() {
  group('state management guardrails', () {
    test('Provider.family with a non-scalar key uses autoDispose', () {
      // Baseline (2026-07-16, A-Plus roadmap STATE-S24): these already
      // key a Provider.family by a record/class that is not a bare
      // scalar and are not yet autoDispose. Fixing them is PERF-HN1 /
      // STATE-S22's job (draft-keyed leak, idiom migration) — this
      // guardrail's job is to stop the pattern from spreading further.
      // Remove an entry here only once the referenced provider is fixed.
      const allowlist = {
        // tradeOrderControllerProvider / tradeFuturesOrderControllerProvider
        // fixed by PERF-HN1 (2026-07-16): now .autoDispose.family, and
        // their draft key types (TradeOrderDraft/TradeFuturesOrderDraft)
        // gained value equality — no longer need an allowlist entry.
        'lib/app/providers/trade_controller_providers.dart:tradeLeverageControllerProvider',
        'lib/app/providers/trade_controller_providers.dart:tradeMarginControllerProvider',
        'lib/app/providers/p2p_controller_providers.dart:p2pHomeProvider',
        'lib/app/providers/p2p_controller_providers.dart:p2pExpressConfirmProvider',
        'lib/app/providers/p2p_controller_providers.dart:p2pTaxReportingProvider',
        'lib/app/providers/p2p_controller_providers.dart:p2pWalletTransferProvider',
        'lib/app/providers/trade_copy_controller_providers.dart:tradeCopyConfirmationControllerProvider',
        'lib/app/providers/trade_copy_controller_providers.dart:tradeCopyConfigurationControllerProvider',
        'lib/app/providers/wallet_controller_providers.dart:walletDepositControllerProvider',
        'lib/app/providers/wallet_controller_providers.dart:withdrawControllerProvider',
      };

      final violations = <String>[];
      for (final file in Directory(
        'lib/app/providers',
      ).listSync().whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final source = file.readAsStringSync();
        final path = file.path.replaceAll('\\', '/');

        for (final match in RegExp(
          r'final\s+(\w+)\s*=\s*Provider(\.autoDispose)?\.family<([^,]+),\s*([^>]+(?:<[^>]*>)?[^>]*)>\(',
          dotAll: true,
        ).allMatches(source)) {
          final providerName = match.group(1)!;
          final hasAutoDispose = match.group(2) != null;
          final keyType = match.group(4)!.trim();
          if (hasAutoDispose) continue;
          if (_safeKeyTypes.contains(keyType)) continue;

          final id = '$path:$providerName';
          if (allowlist.contains(id)) continue;
          violations.add(id);
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'New Provider.family declarations with a non-scalar key must '
            'use .autoDispose.family (or key by a bare scalar id instead '
            'of a record/class) to avoid leaking one cache element per '
            'rebuild: $violations',
      );
    });

    test('presentation pages do not seed a mutable local list from ref.read '
        '(dual-source state)', () {
      // Baseline (2026-07-16, A-Plus roadmap STATE-S24 / S2.3): these
      // pages already seed a `late List<...>` field from `ref.read(...)`
      // in initState and mutate it locally with setState, instead of
      // going through a Notifier — this is the "two sources of truth"
      // pattern S2.3 migrates away from. otp_page.dart's `late final
      // List<TextEditingController>` is a legitimate UI controller list,
      // not domain state, and is correctly NOT in this baseline.
      const allowlist = {
        'lib/features/arena/presentation/pages/governance/arena_blocked_users_page.dart',
        'lib/features/dca/presentation/pages/portfolio/dca_rebalance_config_page.dart',
        'lib/features/earn/presentation/pages/savings/savings_notification_preferences_page.dart',
        'lib/features/launchpad/presentation/pages/tools/launchpad_address_book_page.dart',
        'lib/features/launchpad/presentation/pages/tools/launchpad_gas_tracker_page.dart',
        'lib/features/launchpad/presentation/pages/tools/launchpad_multisig_page.dart',
        'lib/features/launchpad/presentation/pages/tools/launchpad_webhooks_page.dart',
        'lib/features/markets/presentation/pages/hub/watchlist_page.dart',
        'lib/features/markets/presentation/pages/portfolio/price_alerts_page.dart',
        'lib/features/markets/presentation/pages/tools/comparison_tool_page.dart',
        'lib/features/p2p/presentation/pages/security/p2p_2fa_settings_page.dart',
        'lib/features/p2p/presentation/pages/security/p2p_device_management_page.dart',
        'lib/features/p2p/presentation/pages/security/p2p_fraud_prevention_page.dart',
        'lib/features/p2p/presentation/pages/security/p2p_suspicious_activity_page.dart',
        'lib/features/trade/presentation/pages/hub/trade_history_export_page.dart',
        'lib/features/trade_terminal/presentation/pages/tools/advanced_chart_page.dart',
        'lib/features/wallet/presentation/pages/address/address_book_page.dart',
      };

      final violations = <String>[];
      for (final file in Directory(
        'lib/features',
      ).listSync(recursive: true).whereType<File>()) {
        final path = file.path.replaceAll('\\', '/');
        if (!path.endsWith('.dart')) continue;
        if (!path.contains('/presentation/pages/')) continue;

        final source = file.readAsStringSync();
        final hasMutableLateList = RegExp(
          r'late\s+List<\w+>\s+_\w+;',
        ).hasMatch(source);
        if (!hasMutableLateList) continue;
        if (!source.contains('ref.read(')) continue;

        if (allowlist.contains(path)) continue;
        violations.add(path);
      }

      expect(
        violations,
        isEmpty,
        reason:
            'New pages seed a mutable local list from ref.read(...) '
            'instead of a Notifier, reintroducing the dual-source-of-truth '
            'pattern S2.3 migrates away from: $violations',
      );
    });
  });
}
