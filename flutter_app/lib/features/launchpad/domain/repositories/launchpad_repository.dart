import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';

/// Abstract data-access contract every Launchpad screen depends on; implemented by mock and remote repositories.
///
/// GD4-F4: every read returns `Future<T>` (ADR-001 read idiom). See
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md.
abstract interface class LaunchpadRepository {
  Future<LaunchpadHomeSnapshot> getHome();

  Future<LaunchpadDetailSnapshot> getDetail(String projectId);

  Future<LaunchpadPortfolioSnapshot> getPortfolio();

  Future<LaunchpadReceiptSnapshot> getReceipt(String subscriptionId);

  Future<LaunchpadPerformanceSnapshot> getPerformance();

  Future<LaunchpadStakingSnapshot> getStaking();

  Future<LaunchpadBatchClaimSnapshot> getBatchClaim();

  Future<LaunchpadClaimReceiptSnapshot> getClaimReceipt(String positionId);

  Future<LaunchpadIdoBridgeSnapshot> getIdoBridge(String projectId);

  Future<LaunchpadBridgeCompareSnapshot> getBridgeCompare();

  Future<LaunchpadNotifSoundSnapshot> getNotifSound();

  Future<LaunchpadEventLogSnapshot> getEventLog();

  Future<LaunchpadAbiDiffSnapshot> getAbiDiff(String contractId);

  Future<LaunchpadAddressBookSnapshot> getAddressBook();

  Future<LaunchpadWebhooksSnapshot> getWebhooks();

  Future<LaunchpadGasTrackerSnapshot> getGasTracker();

  Future<LaunchpadRebalanceSnapshot> getRebalance();

  Future<LaunchpadMultisigSnapshot> getMultisig();

  Future<LaunchpadSwapAggregatorSnapshot> getSwapAggregator();

  Future<LaunchpadLimitOrdersSnapshot> getLimitOrders();

  Future<LaunchpadDcaBuilderSnapshot> getDcaBuilder();

  Future<LaunchpadRiskAnalyticsSnapshot> getRiskAnalytics();

  Future<LaunchpadBridgeOrderSnapshot> getBridgeOrder(String txId);

  Future<LaunchpadContractSnapshot> getContract(String projectId);
}
