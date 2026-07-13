import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('representative high-risk pages use shared state primitives', () {
    const targets = {
      'lib/features/trade_terminal/presentation/pages/trade_page_part_01.dart',
      'lib/features/wallet/presentation/pages/withdraw_page.dart',
      'lib/features/p2p/presentation/widgets/p2p_home_page_part_01.dart',
      'lib/features/earn/presentation/pages/staking_earn_page.dart',
      'lib/features/launchpad/presentation/pages/launchpad_bridge_order_page.dart',
      'lib/features/predictions/presentation/pages/predictions_home_page.dart',
      'lib/features/predictions/presentation/pages/prediction_event_detail_page.dart',
      'lib/features/predictions/presentation/widgets/prediction_order_receipt_page_sections.dart',
      'lib/features/wallet/presentation/widgets/wallet_address_add_agreement.dart',
      'lib/features/profile/presentation/pages/security_page.dart',
      'lib/features/p2p/presentation/pages/p2p_payment_method_add_page.dart',
      'lib/features/p2p/presentation/pages/p2p_payment_method_ownership_page.dart',
      'lib/features/p2p/presentation/pages/p2p_payment_method_cooling_period_page.dart',
    };

    final missing = <String>[];
    for (final path in targets) {
      final source = File(path).readAsStringSync();
      if (!source.contains('VitHighRiskStatePanel') ||
          !source.contains('highRiskContractId')) {
        missing.add(path);
      }
    }

    expect(
      missing,
      isEmpty,
      reason:
          'P1 dark professional polish requires high-risk pages with '
          'contract metadata to use the shared high-risk state primitive.',
    );
  });
}
