export 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
export 'package:vit_trade_flutter/features/wallet/domain/repositories/wallet_repository.dart';

import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';

enum WalletHighRiskFlowStatus {
  draft,
  ready,
  validationError,
  preview,
  confirming,
  submitting,
  submitted,
  success,
  error,
  offline,
}

extension WalletHighRiskFlowStatusX on WalletHighRiskFlowStatus {
  bool get isBusy {
    return this == WalletHighRiskFlowStatus.confirming ||
        this == WalletHighRiskFlowStatus.submitting;
  }

  bool get isFailure {
    return this == WalletHighRiskFlowStatus.validationError ||
        this == WalletHighRiskFlowStatus.error ||
        this == WalletHighRiskFlowStatus.offline;
  }

  bool get hasPreview {
    return switch (this) {
      WalletHighRiskFlowStatus.preview ||
      WalletHighRiskFlowStatus.confirming ||
      WalletHighRiskFlowStatus.submitting ||
      WalletHighRiskFlowStatus.submitted ||
      WalletHighRiskFlowStatus.success => true,
      _ => false,
    };
  }
}

final class WithdrawViewState {
  const WithdrawViewState({
    required this.snapshot,
    this.status = WalletHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final WalletWithdrawSnapshot snapshot;
  final WalletHighRiskFlowStatus status;
  final String? errorMessage;
}

final class WithdrawPreview {
  const WithdrawPreview({
    required this.asset,
    required this.amountLabel,
    required this.maskedAddress,
    required this.networkName,
    required this.feeLabel,
    required this.receivedLabel,
    required this.requiresMemo,
  });

  final String asset;
  final String amountLabel;
  final String maskedAddress;
  final String networkName;
  final String feeLabel;
  final String receivedLabel;
  final bool requiresMemo;
}

final class WithdrawController {
  const WithdrawController({required this.state});

  final WithdrawViewState state;

  WalletWithdrawNetwork selectedNetwork(String? selectedNetworkId) {
    final networks = state.snapshot.networks;
    if (selectedNetworkId != null) {
      for (final network in networks) {
        if (network.id == selectedNetworkId) return network;
      }
    }
    return networks.first;
  }

  bool canPreview({
    required String address,
    required String amount,
    required WalletWithdrawNetwork network,
  }) {
    return validationMessage(
          address: address,
          amount: amount,
          network: network,
        ) ==
        null;
  }

  String? validationMessage({
    required String address,
    required String amount,
    required WalletWithdrawNetwork network,
  }) {
    if (state.status == WalletHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this withdrawal.';
    }
    if (state.status.isBusy) {
      return 'Confirmation is already in progress.';
    }
    if (address.trim().length <= 8) {
      return 'Enter a complete destination address before preview.';
    }
    final parsedAmount = double.tryParse(amount.trim().replaceAll(',', ''));
    if (parsedAmount == null || parsedAmount <= 0) {
      return 'Enter a valid withdrawal amount before preview.';
    }
    if (parsedAmount < network.minWithdraw) {
      return 'Amount is below the network minimum.';
    }
    if (parsedAmount > network.maxWithdraw) {
      return 'Amount exceeds the network limit.';
    }
    if (parsedAmount > state.snapshot.available) {
      return 'Amount exceeds the available balance.';
    }
    return null;
  }

  WithdrawPreview preview({
    required String address,
    required String amount,
    required WalletWithdrawNetwork network,
  }) {
    final parsedAmount =
        double.tryParse(amount.trim().replaceAll(',', '')) ?? 0;
    final received = parsedAmount - network.fee;
    return WithdrawPreview(
      asset: state.snapshot.asset,
      amountLabel: '${_formatAmount(parsedAmount)} ${state.snapshot.asset}',
      maskedAddress: _maskAddress(address.trim()),
      networkName: network.name,
      feeLabel: '${_formatAmount(network.fee)} ${state.snapshot.asset}',
      receivedLabel:
          '${_formatAmount(received < 0 ? 0 : received)} ${state.snapshot.asset}',
      requiresMemo: network.requiresMemo,
    );
  }
}

final class AddressAddViewState {
  const AddressAddViewState({
    required this.snapshot,
    this.status = WalletHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final WalletAddressAddSnapshot snapshot;
  final WalletHighRiskFlowStatus status;
  final String? errorMessage;
}

final class AddressAddPreview {
  const AddressAddPreview({
    required this.label,
    required this.networkLabel,
    required this.asset,
    required this.maskedAddress,
    required this.memo,
    required this.whitelistLabel,
    required this.auditTrailNote,
  });

  final String label;
  final String networkLabel;
  final String asset;
  final String maskedAddress;
  final String? memo;
  final String whitelistLabel;
  final String auditTrailNote;
}

final class AddressAddController {
  const AddressAddController({required this.state});

  final AddressAddViewState state;

  WalletAddressNetwork selectedNetwork(String selectedNetworkId) {
    for (final network in state.snapshot.networks) {
      if (network.id == selectedNetworkId) return network;
    }
    return state.snapshot.networks.first;
  }

  bool canPreview({
    required String label,
    required String address,
    required bool agreed,
  }) {
    return validationMessage(label: label, address: address, agreed: agreed) ==
        null;
  }

  String? validationMessage({
    required String label,
    required String address,
    required bool agreed,
  }) {
    if (state.status == WalletHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this address.';
    }
    if (state.status.isBusy) {
      return 'Address confirmation is already in progress.';
    }
    if (label.trim().isEmpty) {
      return 'Enter an address label before preview.';
    }
    if (address.trim().length <= 8) {
      return 'Enter a complete destination address before preview.';
    }
    if (!agreed) {
      return 'Accept the address safety review before preview.';
    }
    return null;
  }

  AddressAddPreview preview({
    required String label,
    required String address,
    required String memo,
    required String selectedNetworkId,
    required String selectedAsset,
    required bool whitelist,
  }) {
    final network = selectedNetwork(selectedNetworkId);
    final trimmedMemo = memo.trim();
    return AddressAddPreview(
      label: label.trim(),
      networkLabel: network.label,
      asset: selectedAsset,
      maskedAddress: _maskAddress(address.trim()),
      memo: trimmedMemo.isEmpty ? null : trimmedMemo,
      whitelistLabel: whitelist ? 'Có' : 'Không',
      auditTrailNote: state.snapshot.auditTrailNote,
    );
  }
}

final class TokenApprovalViewState {
  const TokenApprovalViewState({
    required this.snapshot,
    this.status = WalletHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final WalletTokenApprovalSnapshot snapshot;
  final WalletHighRiskFlowStatus status;
  final String? errorMessage;

  List<WalletTokenApproval> get riskSortedApprovals =>
      snapshot.riskSortedApprovals;
}

final class TokenRevokePreview {
  const TokenRevokePreview({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.bulk,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final bool bulk;
}

final class TokenApprovalController {
  const TokenApprovalController({required this.state});

  final TokenApprovalViewState state;

  String? revokeValidationMessage(WalletTokenApproval? approval) {
    if (state.status == WalletHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing token revocation.';
    }
    if (state.status.isBusy) {
      return 'Token revocation is already in progress.';
    }
    if (approval != null &&
        !state.snapshot.approvals.any((item) => item.id == approval.id)) {
      return 'Token approval is no longer available for review.';
    }
    if (approval == null && state.riskSortedApprovals.isEmpty) {
      return 'No token approvals are available for review.';
    }
    return null;
  }

  TokenRevokePreview revokePreview(WalletTokenApproval? approval) {
    final bulk = approval == null;
    final body = bulk
        ? 'Review the spender, token, allowance, gas estimate, and impacted permissions before confirming this revocation.\n'
              'Spender: multiple high-risk contracts\n'
              'Token: multiple approved assets\n'
              'Allowance: high-risk or unlimited approvals\n'
              'Gas estimate: one revoke transaction per approval; network fee must be reviewed before broadcast.\n'
              'Impact: removes the highlighted high-risk permissions only.'
        : 'Review the spender, token, allowance, gas estimate, and impacted permissions before confirming this revocation.\n'
              'Spender: ${approval.spenderName} (${approval.maskedSpender})\n'
              'Token: ${approval.token}\n'
              'Allowance: ${approval.amountLabel}\n'
              'Gas estimate: preview required before broadcast; network fee must be confirmed.\n'
              'Impact: removes this token allowance for the selected spender.';
    return TokenRevokePreview(
      title: bulk
          ? 'Revoke all high-risk approvals'
          : 'Revoke ${approval.token} approval',
      body: body,
      confirmLabel: 'Xác nhận',
      bulk: bulk,
    );
  }
}

String _formatAmount(double value) {
  final fixed = value.toStringAsFixed(value < 1 ? 4 : 2);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}

String _maskAddress(String value) => maskAddress(value);
