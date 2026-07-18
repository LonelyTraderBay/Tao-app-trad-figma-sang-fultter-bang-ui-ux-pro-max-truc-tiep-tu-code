import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/repositories/launchpad_repository.dart';

export 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
export 'package:vit_trade_flutter/features/launchpad/domain/repositories/launchpad_repository.dart';

/// GD4-F4: forwards the now-`Future<T>` [LaunchpadRepository] contract
/// unchanged — see docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md.
final class LaunchpadController implements LaunchpadRepository {
  const LaunchpadController(this._repository);

  final LaunchpadRepository _repository;

  @override
  Future<LaunchpadHomeSnapshot> getHome() => _repository.getHome();

  @override
  Future<LaunchpadDetailSnapshot> getDetail(String projectId) {
    return _repository.getDetail(projectId);
  }

  @override
  Future<LaunchpadPortfolioSnapshot> getPortfolio() =>
      _repository.getPortfolio();

  @override
  Future<LaunchpadReceiptSnapshot> getReceipt(String subscriptionId) {
    return _repository.getReceipt(subscriptionId);
  }

  @override
  Future<LaunchpadPerformanceSnapshot> getPerformance() {
    return _repository.getPerformance();
  }

  @override
  Future<LaunchpadStakingSnapshot> getStaking() => _repository.getStaking();

  @override
  Future<LaunchpadBatchClaimSnapshot> getBatchClaim() {
    return _repository.getBatchClaim();
  }

  @override
  Future<LaunchpadClaimReceiptSnapshot> getClaimReceipt(String positionId) {
    return _repository.getClaimReceipt(positionId);
  }

  @override
  Future<LaunchpadIdoBridgeSnapshot> getIdoBridge(String projectId) {
    return _repository.getIdoBridge(projectId);
  }

  @override
  Future<LaunchpadBridgeCompareSnapshot> getBridgeCompare() {
    return _repository.getBridgeCompare();
  }

  @override
  Future<LaunchpadNotifSoundSnapshot> getNotifSound() {
    return _repository.getNotifSound();
  }

  @override
  Future<LaunchpadEventLogSnapshot> getEventLog() => _repository.getEventLog();

  @override
  Future<LaunchpadAbiDiffSnapshot> getAbiDiff(String contractId) {
    return _repository.getAbiDiff(contractId);
  }

  @override
  Future<LaunchpadAddressBookSnapshot> getAddressBook() {
    return _repository.getAddressBook();
  }

  @override
  Future<LaunchpadWebhooksSnapshot> getWebhooks() => _repository.getWebhooks();

  @override
  Future<LaunchpadGasTrackerSnapshot> getGasTracker() {
    return _repository.getGasTracker();
  }

  @override
  Future<LaunchpadRebalanceSnapshot> getRebalance() {
    return _repository.getRebalance();
  }

  @override
  Future<LaunchpadMultisigSnapshot> getMultisig() => _repository.getMultisig();

  @override
  Future<LaunchpadSwapAggregatorSnapshot> getSwapAggregator() {
    return _repository.getSwapAggregator();
  }

  @override
  Future<LaunchpadLimitOrdersSnapshot> getLimitOrders() {
    return _repository.getLimitOrders();
  }

  @override
  Future<LaunchpadDcaBuilderSnapshot> getDcaBuilder() {
    return _repository.getDcaBuilder();
  }

  @override
  Future<LaunchpadRiskAnalyticsSnapshot> getRiskAnalytics() {
    return _repository.getRiskAnalytics();
  }

  @override
  Future<LaunchpadBridgeOrderSnapshot> getBridgeOrder(String txId) {
    return _repository.getBridgeOrder(txId);
  }

  @override
  Future<LaunchpadContractSnapshot> getContract(String projectId) {
    return _repository.getContract(projectId);
  }
}
