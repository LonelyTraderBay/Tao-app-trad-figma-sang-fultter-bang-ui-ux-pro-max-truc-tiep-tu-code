import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/features/wallet/data/providers/wallet_repository_provider.dart';
import 'package:vit_trade_flutter/features/wallet/data/repositories/mock_wallet_repository.dart';

ProviderContainer _mockContainer() {
  return ProviderContainer(
    overrides: [
      walletRepositoryProvider.overrideWithValue(
        const MockWalletRepository(loadDelay: Duration.zero),
      ),
    ],
  );
}

void main() {
  test(
    'Withdraw controller exposes preview state and validation boundary',
    () async {
      final container = _mockContainer();
      addTearDown(container.dispose);

      const request = (asset: 'USDT', assetScoped: false);
      await container.read(walletWithdrawSnapshotProvider(request).future);
      final controller = container
          .read(withdrawControllerProvider(request))
          .requireValue;
      final network = controller.selectedNetwork('trc20');

      expect(controller.state.snapshot.asset, 'USDT');
      expect(network.name, 'TRC20 (TRON)');
      expect(
        controller.canPreview(
          address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
          amount: '100',
          network: network,
        ),
        isTrue,
      );
      expect(
        controller.canPreview(address: 'short', amount: '1', network: network),
        isFalse,
      );
      expect(
        controller.validationMessage(
          address: 'short',
          amount: '1',
          network: network,
        ),
        'Enter a complete destination address before preview.',
      );
      expect(
        controller.validationMessage(
          address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
          amount: '0',
          network: network,
        ),
        'Nhập số tiền rút hợp lệ trước khi xem trước.',
      );
      expect(
        WithdrawController(
          state: WithdrawViewState(
            snapshot: controller.state.snapshot,
            status: WalletHighRiskFlowStatus.offline,
          ),
        ).validationMessage(
          address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
          amount: '100',
          network: network,
        ),
        'Offline: reconnect before previewing this withdrawal.',
      );
      expect(WalletHighRiskFlowStatus.confirming.isBusy, isTrue);
      expect(WalletHighRiskFlowStatus.preview.hasPreview, isTrue);
      expect(WalletHighRiskFlowStatus.validationError.isFailure, isTrue);

      final preview = controller.preview(
        address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
        amount: '100',
        network: network,
      );

      expect(preview.amountLabel, '100 USDT');
      expect(preview.networkName, 'TRC20 (TRON)');
      expect(preview.feeLabel, '1 USDT');
      expect(preview.receivedLabel, '99 USDT');
      expect(preview.maskedAddress, 'TQnKxx...z123');
    },
  );

  test(
    'Address add controller builds high-risk confirmation preview',
    () async {
      final container = _mockContainer();
      addTearDown(container.dispose);

      await container.read(walletAddressAddSnapshotProvider.future);
      final controller = container
          .read(addressAddControllerProvider)
          .requireValue;

      expect(controller.state.snapshot.networks, isNotEmpty);
      expect(
        controller.canPreview(
          label: 'Personal cold wallet',
          address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
          agreed: true,
        ),
        isTrue,
      );
      expect(
        controller.canPreview(
          label: 'Personal cold wallet',
          address: 'short',
          agreed: true,
        ),
        isFalse,
      );
      expect(
        controller.validationMessage(
          label: '',
          address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
          agreed: true,
        ),
        'Enter an address label before preview.',
      );
      expect(
        AddressAddController(
          state: AddressAddViewState(
            snapshot: controller.state.snapshot,
            status: WalletHighRiskFlowStatus.offline,
          ),
        ).validationMessage(
          label: 'Personal cold wallet',
          address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
          agreed: true,
        ),
        'Offline: reconnect before previewing this address.',
      );

      final preview = controller.preview(
        label: ' Personal cold wallet ',
        address: 'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
        memo: '',
        selectedNetworkId: 'trc20',
        selectedAsset: 'USDT',
        whitelist: true,
      );

      expect(preview.label, 'Personal cold wallet');
      expect(preview.networkLabel, 'TRC20');
      expect(preview.asset, 'USDT');
      expect(preview.maskedAddress, 'TQnKxx...z123');
      expect(
        preview.auditTrailNote,
        'High-risk action: preview + confirm + audit trail required.',
      );
    },
  );

  test('Token approval controller owns revoke confirmation copy', () async {
    final container = _mockContainer();
    addTearDown(container.dispose);

    await container.read(walletTokenApprovalsSnapshotProvider.future);
    final controller = container
        .read(tokenApprovalControllerProvider)
        .requireValue;
    final approval = controller.state.riskSortedApprovals.first;

    expect(controller.state.snapshot.criticalCount, 1);
    expect(approval.token, 'WETH');

    final single = controller.revokePreview(approval);
    expect(controller.revokeValidationMessage(approval), isNull);
    expect(single.title, 'Revoke WETH approval');
    expect(single.bulk, isFalse);
    expect(single.body, contains('bên chi tiêu, token, hạn mức'));

    final bulk = controller.revokePreview(null);
    expect(controller.revokeValidationMessage(null), isNull);
    expect(bulk.title, 'Revoke all high-risk approvals');
    expect(bulk.bulk, isTrue);
  });
}
