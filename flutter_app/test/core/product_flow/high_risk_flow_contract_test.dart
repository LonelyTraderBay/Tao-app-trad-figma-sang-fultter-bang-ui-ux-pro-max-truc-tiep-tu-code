import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';

void main() {
  test('registry covers every P0 high-risk product family', () {
    final ids = HighRiskFlowContracts.contracts
        .map((contract) => contract.id)
        .toSet();

    expect(
      ids,
      containsAll({
        'trade_spot_order',
        'trade_margin_futures',
        'trade_bots',
        'trade_copy',
        'wallet_money_movement',
        'p2p_escrow_order',
        'earn_savings_staking',
        'launchpad_token_access',
        'prediction_market_event',
      }),
    );
  });

  test('contracts include the required lifecycle sequence', () {
    for (final contract in HighRiskFlowContracts.contracts) {
      expect(
        contract.coversRequiredStages,
        isTrue,
        reason:
            '${contract.id} misses '
            '${contract.missingRequiredStages.map((stage) => stage.key)}',
      );
      expect(contract.steps.first.stage, HighRiskFlowStage.entry);
      expect(contract.steps.last.stage, HighRiskFlowStage.supportOrRecovery);
      expect(
        contract.steps.map((step) => step.stage).toList(),
        HighRiskFlowContracts.requiredStages,
        reason: '${contract.id} must preserve the enterprise flow order',
      );
      expect(
        contract.steps.every((step) => step.label.trim().isNotEmpty),
        isTrue,
        reason: '${contract.id} has an empty step label',
      );
    }
  });

  test('route-bearing contract fields use absolute app paths', () {
    for (final contract in HighRiskFlowContracts.contracts) {
      expect(contract.entryRoute, startsWith('/'));
      expect(contract.supportRoute, startsWith('/'));

      for (final step in contract.steps) {
        final routePath = step.routePath;
        if (routePath == null) continue;

        expect(
          routePath,
          startsWith('/'),
          reason: '${contract.id} ${step.stage.key} route must be absolute',
        );
      }
    }
  });

  test('contract ids are stable and unique', () {
    final ids = HighRiskFlowContracts.contracts
        .map((contract) => contract.id)
        .toList();

    expect(ids.toSet(), hasLength(ids.length));
    expect(HighRiskFlowContracts.findById('p2p_escrow_order')?.module, 'p2p');
    expect(HighRiskFlowContracts.findById('missing'), isNull);
  });
}
