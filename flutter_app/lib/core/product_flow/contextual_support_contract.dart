enum ContextualSupportFlow {
  withdrawal,
  p2pOrder,
  kyc,
  staking,
  launchpad,
  security,
  order,
}

extension ContextualSupportFlowX on ContextualSupportFlow {
  String get key => switch (this) {
    ContextualSupportFlow.withdrawal => 'withdrawal',
    ContextualSupportFlow.p2pOrder => 'p2p_order',
    ContextualSupportFlow.kyc => 'kyc',
    ContextualSupportFlow.staking => 'staking',
    ContextualSupportFlow.launchpad => 'launchpad',
    ContextualSupportFlow.security => 'security',
    ContextualSupportFlow.order => 'order',
  };
}

final class ContextualSupportContract {
  const ContextualSupportContract({
    required this.flow,
    required this.productArea,
    required this.module,
    required this.defaultIssueLabel,
    required this.caseQueueLabel,
    required this.slaLabel,
  });

  final ContextualSupportFlow flow;
  final String productArea;
  final String module;
  final String defaultIssueLabel;
  final String caseQueueLabel;
  final String slaLabel;
}

final class ProductSupportContext {
  const ProductSupportContext({
    required this.flow,
    required this.productArea,
    required this.module,
    required this.issueLabel,
    required this.caseQueueLabel,
    required this.slaLabel,
    this.referenceId,
    this.sourceRoute,
  });

  factory ProductSupportContext.fromContract(
    ContextualSupportContract contract, {
    String? referenceId,
    String? sourceRoute,
    String? issueLabel,
  }) {
    return ProductSupportContext(
      flow: contract.flow,
      productArea: contract.productArea,
      module: contract.module,
      issueLabel: _nonEmpty(issueLabel) ?? contract.defaultIssueLabel,
      caseQueueLabel: contract.caseQueueLabel,
      slaLabel: contract.slaLabel,
      referenceId: _nonEmpty(referenceId),
      sourceRoute: _safeRoute(sourceRoute),
    );
  }

  final ContextualSupportFlow flow;
  final String productArea;
  final String module;
  final String issueLabel;
  final String caseQueueLabel;
  final String slaLabel;
  final String? referenceId;
  final String? sourceRoute;

  List<String> get timelineLabels => [
    'Context captured from ${flow.key}',
    caseQueueLabel,
    slaLabel,
  ];

  Map<String, String> toQueryParameters() {
    final query = {
      'flow': flow.key,
      'product': productArea,
      'module': module,
      'issue': issueLabel,
    };
    final referenceId = this.referenceId;
    if (referenceId != null) query['ref'] = referenceId;
    final sourceRoute = this.sourceRoute;
    if (sourceRoute != null) query['source'] = sourceRoute;
    return query;
  }

  String toSupportRoute({String supportPath = '/support'}) {
    return Uri(
      path: supportPath,
      queryParameters: toQueryParameters(),
    ).toString();
  }

  static ProductSupportContext? fromQuery(Map<String, String> query) {
    final flowKey = _nonEmpty(query['flow']);
    if (flowKey == null) return null;

    final contract = ContextualSupportContracts.findByFlowKey(flowKey);
    if (contract == null) return null;

    return ProductSupportContext.fromContract(
      contract,
      referenceId: query['ref'],
      sourceRoute: query['source'],
      issueLabel: query['issue'],
    );
  }

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  static String? _safeRoute(String? value) {
    final route = _nonEmpty(value);
    if (route == null || !route.startsWith('/')) return null;
    return route;
  }
}

final class ContextualSupportContracts {
  const ContextualSupportContracts._();

  static const requiredFlows = [
    ContextualSupportFlow.withdrawal,
    ContextualSupportFlow.p2pOrder,
    ContextualSupportFlow.kyc,
    ContextualSupportFlow.staking,
    ContextualSupportFlow.launchpad,
    ContextualSupportFlow.security,
    ContextualSupportFlow.order,
  ];

  static const contracts = [
    ContextualSupportContract(
      flow: ContextualSupportFlow.withdrawal,
      productArea: 'Wallet and Treasury',
      module: 'wallet',
      defaultIssueLabel: 'Withdrawal delayed or failed',
      caseQueueLabel: 'Wallet operations queue reviews network and limits',
      slaLabel: 'Next update after transaction status check',
    ),
    ContextualSupportContract(
      flow: ContextualSupportFlow.p2pOrder,
      productArea: 'P2P Trading',
      module: 'p2p',
      defaultIssueLabel: 'P2P order, escrow, or dispute issue',
      caseQueueLabel: 'P2P escrow queue reviews order timeline and evidence',
      slaLabel: 'Next update after counterparty and escrow review',
    ),
    ContextualSupportContract(
      flow: ContextualSupportFlow.kyc,
      productArea: 'Identity and Access',
      module: 'profile',
      defaultIssueLabel: 'KYC or verification issue',
      caseQueueLabel: 'Identity queue reviews document and selfie checks',
      slaLabel: 'Next update after verification status refresh',
    ),
    ContextualSupportContract(
      flow: ContextualSupportFlow.staking,
      productArea: 'Earn and Savings',
      module: 'earn',
      defaultIssueLabel: 'Staking, redeem, reward, or validator issue',
      caseQueueLabel: 'Earn operations queue reviews position and validator',
      slaLabel: 'Next update after reward or unstake status check',
    ),
    ContextualSupportContract(
      flow: ContextualSupportFlow.launchpad,
      productArea: 'Launchpad and Token Access',
      module: 'launchpad',
      defaultIssueLabel: 'Launchpad subscription, bridge, or claim issue',
      caseQueueLabel: 'Launchpad queue reviews allocation and transaction',
      slaLabel: 'Next update after claim or bridge status check',
    ),
    ContextualSupportContract(
      flow: ContextualSupportFlow.security,
      productArea: 'Profile and Account',
      module: 'profile',
      defaultIssueLabel: 'Security change or device issue',
      caseQueueLabel: 'Security queue reviews device and account activity',
      slaLabel: 'Next update after security event review',
    ),
    ContextualSupportContract(
      flow: ContextualSupportFlow.order,
      productArea: 'Trading Execution',
      module: 'trade',
      defaultIssueLabel: 'Order execution, receipt, or position issue',
      caseQueueLabel: 'Trading queue reviews order receipt and execution logs',
      slaLabel: 'Next update after order status reconciliation',
    ),
  ];

  static ContextualSupportContract? findByFlow(ContextualSupportFlow flow) {
    for (final contract in contracts) {
      if (contract.flow == flow) return contract;
    }
    return null;
  }

  static ContextualSupportContract? findByFlowKey(String flowKey) {
    for (final contract in contracts) {
      if (contract.flow.key == flowKey) return contract;
    }
    return null;
  }

  static String supportRouteFor(
    ContextualSupportFlow flow, {
    String? referenceId,
    String? sourceRoute,
    String? issueLabel,
  }) {
    final contract = findByFlow(flow);
    if (contract == null) return '/support';

    return ProductSupportContext.fromContract(
      contract,
      referenceId: referenceId,
      sourceRoute: sourceRoute,
      issueLabel: issueLabel,
    ).toSupportRoute();
  }
}
