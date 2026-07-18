import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_errors.dart';
import 'package:vit_trade_flutter/features/wallet/domain/repositories/wallet_repository.dart';

final class FailClosedWalletRepository implements WalletRepository {
  const FailClosedWalletRepository();

  static const _endpoint = '/api/mobile/wallet/pending-contract';
  static const _states = [WalletScreenState.error, WalletScreenState.offline];

  static String get _unavailableMessage =>
      const WalletBackendContractMissingException().userMessage;

  @override
  Future<WalletSnapshot> getWallet() async {
    return WalletSnapshot(
      totalUsd: 0,
      totalBtc: 0,
      availableUsd: 0,
      inOrderUsd: 0,
      frozenUsd: 0,
      actions: const [],
      dca: const WalletDcaSnapshot(
        title: 'Unavailable',
        subtitle: 'Backend contract required',
        returnLabel: 'Paused',
        activePlans: 0,
        invested: 0,
        nextTrade: 'Paused',
      ),
      tools: const [],
      assets: const [],
      endpoint: _endpoint,
      actionDraft: _unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  Future<WalletPendingDepositsSnapshot> getPendingDeposits() async {
    return WalletPendingDepositsSnapshot(
      deposits: const [],
      endpoint: _endpoint,
      actionDraft: _unavailableMessage,
      supportedStates: _states,
    );
  }

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const WalletBackendContractMissingException();
  }
}
