import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';

abstract interface class LaunchpadRepository {
  LaunchpadHomeSnapshot getHome();

  LaunchpadDetailSnapshot getDetail(String projectId);

  LaunchpadPortfolioSnapshot getPortfolio();

  LaunchpadReceiptSnapshot getReceipt(String subscriptionId);

  LaunchpadPerformanceSnapshot getPerformance();

  LaunchpadStakingSnapshot getStaking();

  LaunchpadBatchClaimSnapshot getBatchClaim();

  LaunchpadClaimReceiptSnapshot getClaimReceipt(String positionId);

  LaunchpadIdoBridgeSnapshot getIdoBridge(String projectId);

  LaunchpadBridgeCompareSnapshot getBridgeCompare();

  LaunchpadNotifSoundSnapshot getNotifSound();

  LaunchpadEventLogSnapshot getEventLog();

  LaunchpadAbiDiffSnapshot getAbiDiff(String contractId);

  LaunchpadAddressBookSnapshot getAddressBook();

  LaunchpadWebhooksSnapshot getWebhooks();

  LaunchpadGasTrackerSnapshot getGasTracker();

  LaunchpadRebalanceSnapshot getRebalance();

  LaunchpadMultisigSnapshot getMultisig();

  LaunchpadSwapAggregatorSnapshot getSwapAggregator();

  LaunchpadLimitOrdersSnapshot getLimitOrders();

  LaunchpadDcaBuilderSnapshot getDcaBuilder();

  LaunchpadRiskAnalyticsSnapshot getRiskAnalytics();

  LaunchpadBridgeOrderSnapshot getBridgeOrder(String txId);

  LaunchpadContractSnapshot getContract(String projectId);
}
