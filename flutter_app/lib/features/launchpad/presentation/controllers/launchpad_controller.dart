import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/repositories/launchpad_repository.dart';

export 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
export 'package:vit_trade_flutter/features/launchpad/domain/repositories/launchpad_repository.dart';

final class LaunchpadController implements LaunchpadRepository {
  const LaunchpadController(this._repository);

  final LaunchpadRepository _repository;

  @override
  LaunchpadHomeSnapshot getHome() => _repository.getHome();

  @override
  LaunchpadDetailSnapshot getDetail(String projectId) {
    return _repository.getDetail(projectId);
  }

  @override
  LaunchpadPortfolioSnapshot getPortfolio() => _repository.getPortfolio();

  @override
  LaunchpadReceiptSnapshot getReceipt(String subscriptionId) {
    return _repository.getReceipt(subscriptionId);
  }

  @override
  LaunchpadPerformanceSnapshot getPerformance() {
    return _repository.getPerformance();
  }

  @override
  LaunchpadStakingSnapshot getStaking() => _repository.getStaking();

  @override
  LaunchpadBatchClaimSnapshot getBatchClaim() {
    return _repository.getBatchClaim();
  }

  @override
  LaunchpadClaimReceiptSnapshot getClaimReceipt(String positionId) {
    return _repository.getClaimReceipt(positionId);
  }

  @override
  LaunchpadIdoBridgeSnapshot getIdoBridge(String projectId) {
    return _repository.getIdoBridge(projectId);
  }

  @override
  LaunchpadBridgeCompareSnapshot getBridgeCompare() {
    return _repository.getBridgeCompare();
  }

  @override
  LaunchpadNotifSoundSnapshot getNotifSound() {
    return _repository.getNotifSound();
  }

  @override
  LaunchpadEventLogSnapshot getEventLog() => _repository.getEventLog();

  @override
  LaunchpadAbiDiffSnapshot getAbiDiff(String contractId) {
    return _repository.getAbiDiff(contractId);
  }

  @override
  LaunchpadAddressBookSnapshot getAddressBook() {
    return _repository.getAddressBook();
  }

  @override
  LaunchpadWebhooksSnapshot getWebhooks() => _repository.getWebhooks();

  @override
  LaunchpadGasTrackerSnapshot getGasTracker() {
    return _repository.getGasTracker();
  }

  @override
  LaunchpadRebalanceSnapshot getRebalance() {
    return _repository.getRebalance();
  }

  @override
  LaunchpadMultisigSnapshot getMultisig() => _repository.getMultisig();

  @override
  LaunchpadSwapAggregatorSnapshot getSwapAggregator() {
    return _repository.getSwapAggregator();
  }

  @override
  LaunchpadLimitOrdersSnapshot getLimitOrders() {
    return _repository.getLimitOrders();
  }

  @override
  LaunchpadDcaBuilderSnapshot getDcaBuilder() {
    return _repository.getDcaBuilder();
  }

  @override
  LaunchpadRiskAnalyticsSnapshot getRiskAnalytics() {
    return _repository.getRiskAnalytics();
  }

  @override
  LaunchpadBridgeOrderSnapshot getBridgeOrder(String txId) {
    return _repository.getBridgeOrder(txId);
  }

  @override
  LaunchpadContractSnapshot getContract(String projectId) {
    return _repository.getContract(projectId);
  }
}
