import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import '../../fixtures/high_risk_flow_binding.dart';
import 'package:vit_trade_flutter/core/product_flow/high_risk_flow_contract.dart';
import 'package:vit_trade_flutter/features/earn/data/repositories/mock_earn_repository.dart';
import 'package:vit_trade_flutter/features/earn/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/data/repositories/mock_launchpad_repository.dart';
import 'package:vit_trade_flutter/features/p2p/data/repositories/mock_p2p_repository.dart';
import 'package:vit_trade_flutter/features/predictions/data/repositories/mock_predictions_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/repositories/mock_trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/repositories/mock_trade_copy_trading_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/repositories/mock_trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/wallet/data/repositories/mock_wallet_repository.dart';

void main() {
  test('every high-risk contract has one screen binding', () {
    final contractIds = HighRiskFlowContracts.contracts
        .map((contract) => contract.id)
        .toSet();
    final bindingIds = HighRiskFlowBindings.bindings
        .map((binding) => binding.contractId)
        .toSet();

    expect(bindingIds, contractIds);
    expect(bindingIds, hasLength(HighRiskFlowBindings.bindings.length));
  });

  test('screen bindings cover lifecycle stages and contract routes', () {
    for (final binding in HighRiskFlowBindings.bindings) {
      expect(
        binding.coversRequiredStages,
        isTrue,
        reason:
            '${binding.contractId} misses '
            '${binding.missingRequiredStages.map((stage) => stage.key)}',
      );
      expect(
        binding.coversContractRoutes,
        isTrue,
        reason: '${binding.contractId} must cover contract route paths',
      );
      expect(binding.repositoryName.trim(), isNotEmpty);
      expect(binding.primarySnapshotType.trim(), isNotEmpty);
      expect(binding.supportContextFlowKey.trim(), isNotEmpty);

      for (final screen in binding.screenBindings) {
        expect(screen.routePath, startsWith('/'));
        expect(screen.screenName.trim(), isNotEmpty);
        expect(screen.repositoryMethod.trim(), isNotEmpty);
        expect(screen.snapshotType.trim(), isNotEmpty);
        expect(screen.stateKey.trim(), isNotEmpty);
        for (final routePath in screen.relatedRoutePaths) {
          expect(routePath, startsWith('/'));
        }
      }
    }
  });

  test('route lookup resolves representative product routes', () {
    expect(
      HighRiskFlowBindings.findByRoute(
        AppRoutePaths.tradePair('btcusdt'),
      )?.contractId,
      HighRiskFlowContractIds.tradeSpotOrder,
    );
    expect(
      HighRiskFlowBindings.findByRoute(
        AppRoutePaths.tradeMarginBtcusdt,
      )?.contractId,
      HighRiskFlowContractIds.tradeMarginFutures,
    );
    expect(
      HighRiskFlowBindings.findByRoute(
        AppRoutePaths.tradeBotEmergencyStop,
      )?.contractId,
      HighRiskFlowContractIds.tradeBots,
    );
    expect(
      HighRiskFlowBindings.findByRoute(
        AppRoutePaths.tradeCopyAuditLog('copy001'),
      )?.contractId,
      HighRiskFlowContractIds.tradeCopy,
    );
    expect(
      HighRiskFlowBindings.findByRoute(
        AppRoutePaths.walletWithdrawAsset('USDT'),
      )?.contractId,
      HighRiskFlowContractIds.walletMoneyMovement,
    );
    expect(
      HighRiskFlowBindings.findByRoute(
        AppRoutePaths.p2pOrder('order001'),
      )?.contractId,
      HighRiskFlowContractIds.p2pEscrowOrder,
    );
    expect(
      HighRiskFlowBindings.findByRoute(AppRoutePaths.earnStaking)?.contractId,
      HighRiskFlowContractIds.earnSavingsStaking,
    );
    expect(
      HighRiskFlowBindings.findByRoute(
        AppRoutePaths.launchpadBridgeOrderTx001,
      )?.contractId,
      HighRiskFlowContractIds.launchpadTokenAccess,
    );
    expect(
      HighRiskFlowBindings.findByRoute(
        AppRoutePaths.marketsPredictionReceipt('receipt001'),
      )?.contractId,
      HighRiskFlowContractIds.predictionMarketEvent,
    );
  });

  test(
    'mock repository snapshots expose high-risk contract metadata',
    () async {
      const trade = MockTradeTerminalRepository(loadDelay: Duration.zero);
      expect(
        (await trade.getTrade()).highRiskContractId,
        HighRiskFlowContractIds.tradeSpotOrder,
      );
      expect(
        (await trade.getOrderReceipt()).highRiskContractId,
        HighRiskFlowContractIds.tradeSpotOrder,
      );
      expect(
        (await trade.getFutures()).highRiskContractId,
        HighRiskFlowContractIds.tradeMarginFutures,
      );
      expect(
        (await trade.getMarginTrading()).highRiskContractId,
        HighRiskFlowContractIds.tradeMarginFutures,
      );

      const bots = MockTradeBotsRepository(loadDelay: Duration.zero);
      expect(
        (await bots.getTradingBots()).highRiskContractId,
        HighRiskFlowContractIds.tradeBots,
      );

      const copy = MockTradeCopyTradingRepository(loadDelay: Duration.zero);
      expect(
        (await copy.getCopyTrading()).highRiskContractId,
        HighRiskFlowContractIds.tradeCopy,
      );

      const wallet = MockWalletRepository(loadDelay: Duration.zero);
      expect(
        (await wallet.getWithdrawLimits()).highRiskContractId,
        HighRiskFlowContractIds.walletMoneyMovement,
      );
      expect(
        (await wallet.getWithdraw('USDT')).highRiskContractId,
        HighRiskFlowContractIds.walletMoneyMovement,
      );

      const p2p = MockP2PRepository();
      expect(
        p2p.getHome().highRiskContractId,
        HighRiskFlowContractIds.p2pEscrowOrder,
      );
      expect(
        p2p.getExpressConfirm(fiatAmount: 5000000).highRiskContractId,
        HighRiskFlowContractIds.p2pEscrowOrder,
      );
      expect(
        p2p.getOrderTimeline('order001').highRiskContractId,
        HighRiskFlowContractIds.p2pEscrowOrder,
      );
      expect(
        p2p.getOrder('order001').highRiskContractId,
        HighRiskFlowContractIds.p2pEscrowOrder,
      );
      expect(
        p2p.getClaimDetail('sample').highRiskContractId,
        HighRiskFlowContractIds.p2pEscrowOrder,
      );

      const staking = MockStakingEarnRepository();
      expect(
        staking
            .getStakingEarn(route: StakingEarnRoute.staking)
            .highRiskContractId,
        HighRiskFlowContractIds.earnSavingsStaking,
      );

      const launchpad = MockLaunchpadRepository();
      expect(
        launchpad.getBridgeOrder('tx001').highRiskContractId,
        HighRiskFlowContractIds.launchpadTokenAccess,
      );

      const predictions = MockPredictionsRepository();
      expect(
        predictions.getHome().highRiskContractId,
        HighRiskFlowContractIds.predictionMarketEvent,
      );
      expect(
        predictions.getEventDetail('event001').highRiskContractId,
        HighRiskFlowContractIds.predictionMarketEvent,
      );
      expect(
        predictions.getOrderReceipt('receipt001').highRiskContractId,
        HighRiskFlowContractIds.predictionMarketEvent,
      );
    },
  );
}
