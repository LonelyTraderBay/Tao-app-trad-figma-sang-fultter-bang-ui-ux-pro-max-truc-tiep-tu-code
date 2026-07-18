part of 'p2p_controller.dart';

final class P2PPaymentMethodAddViewState {
  const P2PPaymentMethodAddViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PPaymentMethodAddSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PPaymentMethodPreview {
  const P2PPaymentMethodPreview({
    required this.method,
    required this.account,
    required this.maskedAccount,
    required this.ownerName,
    required this.ownershipRiskMessage,
    required this.limitMessage,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.saveRoute,
  });

  final String method;
  final String account;
  final String maskedAccount;
  final String ownerName;
  final String ownershipRiskMessage;
  final String limitMessage;
  final String confirmTitle;
  final String confirmMessage;
  final String saveRoute;
}

final class P2PPaymentMethodAddController {
  const P2PPaymentMethodAddController({required this.state});

  final P2PPaymentMethodAddViewState state;

  List<String> optionsFor({required bool bankType}) {
    return bankType
        ? state.snapshot.bankOptions
        : state.snapshot.ewalletOptions;
  }

  bool canPreview({
    required String? selectedMethod,
    required String account,
    required String ownerName,
  }) {
    return validationMessage(
          selectedMethod: selectedMethod,
          account: account,
          ownerName: ownerName,
        ) ==
        null;
  }

  String? validationMessage({
    required String? selectedMethod,
    required String account,
    required String ownerName,
  }) {
    if (state.status == P2PHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before adding a payment method.';
    }
    if (state.status.isBusy) {
      return 'Confirmation is already in progress.';
    }
    if (selectedMethod == null || selectedMethod.trim().isEmpty) {
      return 'Select a payment method before preview.';
    }
    if (account.trim().isEmpty) {
      return 'Nhập số tài khoản hoặc địa chỉ ví trước khi xem trước.';
    }
    if (ownerName.trim().isEmpty) {
      return 'Nhập tên chủ sở hữu đã xác minh trước khi xem trước.';
    }
    return null;
  }

  P2PPaymentMethodPreview preview({
    required String selectedMethod,
    required String account,
    required String ownerName,
  }) {
    return P2PPaymentMethodPreview(
      method: selectedMethod.trim(),
      account: account.trim(),
      maskedAccount: _maskPaymentAccount(account.trim()),
      ownerName: ownerName.trim(),
      ownershipRiskMessage:
          'Xem xét quyền sở hữu: chủ tài khoản phải khớp với hồ sơ P2P đã xác minh trước khi kích hoạt.',
      limitMessage:
          'Limits: new payment methods stay under security review before high-value orders.',
      confirmTitle: state.snapshot.confirmTitle,
      confirmMessage: state.snapshot.confirmMessage,
      saveRoute: state.snapshot.saveRoute,
    );
  }
}

final class P2PPaymentMethodOwnershipViewState {
  const P2PPaymentMethodOwnershipViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PPaymentMethodOwnershipSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PPaymentMethodOwnershipSubmitPreview {
  const P2PPaymentMethodOwnershipSubmitPreview({
    required this.confirmTitle,
    required this.confirmMessage,
    required this.saveRoute,
    required this.requiredUploaded,
    required this.requiredTotal,
  });

  final String confirmTitle;
  final String confirmMessage;
  final String saveRoute;
  final int requiredUploaded;
  final int requiredTotal;
}

final class P2PPaymentMethodOwnershipController {
  const P2PPaymentMethodOwnershipController({required this.state});

  final P2PPaymentMethodOwnershipViewState state;

  List<P2POwnershipDocumentDraft> get requiredDocuments {
    return [
      for (final document in state.snapshot.documents)
        if (!document.optional) document,
    ];
  }

  bool canSubmit(Set<String> uploadedDocumentIds) {
    return requiredDocuments.every(
      (document) => uploadedDocumentIds.contains(document.id),
    );
  }

  P2PPaymentMethodOwnershipSubmitPreview submitPreview(
    Set<String> uploadedDocumentIds,
  ) {
    final uploadedRequired = requiredDocuments
        .where((document) => uploadedDocumentIds.contains(document.id))
        .length;
    return P2PPaymentMethodOwnershipSubmitPreview(
      confirmTitle: state.snapshot.confirmTitle,
      confirmMessage: state.snapshot.confirmMessage,
      saveRoute: state.snapshot.saveRoute,
      requiredUploaded: uploadedRequired,
      requiredTotal: requiredDocuments.length,
    );
  }
}

final class P2PPaymentMethodCoolingPeriodViewState {
  const P2PPaymentMethodCoolingPeriodViewState({
    required this.snapshot,
    this.status = P2PHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final P2PPaymentMethodCoolingPeriodSnapshot snapshot;
  final P2PHighRiskFlowStatus status;
  final String? errorMessage;
}

final class P2PPaymentMethodCoolingPeriodController {
  const P2PPaymentMethodCoolingPeriodController({required this.state});

  final P2PPaymentMethodCoolingPeriodViewState state;

  int get daysLeft => state.snapshot.hoursRemaining ~/ 24;

  int get hoursLeft => state.snapshot.hoursRemaining % 24;

  String get remainingLabel => '${daysLeft}d ${hoursLeft}h';
}
