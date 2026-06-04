part of '../repositories/mock_launchpad_repository.dart';

mixin _MockLaunchpadRepositoryMethodsPart02 on _MockLaunchpadRepositoryBase {
  @override
  LaunchpadBridgeOrderSnapshot getBridgeOrder(String txId) {
    final normalizedId = txId.trim();
    return LaunchpadBridgeOrderSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-bridge-order-$normalizedId',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Chi tiet Bridge',
      backRoute: '/launchpad/idobridge/sample',
      supportRoute: ContextualSupportContracts.supportRouteFor(
        ContextualSupportFlow.launchpad,
        referenceId: normalizedId,
        sourceRoute: '/launchpad/bridge-order/tx001',
        issueLabel: 'Launchpad bridge order support',
      ),
      txId: normalizedId,
      order: _bridgeOrder,
      events: _bridgeEvents,
      contractNotes:
          'Launchpad bridge order returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, selected bridge order, polling steps, websocket event summary, action routes, and screenState. Captured route tx001 follows the Flutter fallback to the first bridge history order while preserving the route-scoped endpoint.',
      highRiskContractId: HighRiskFlowContractIds.launchpadTokenAccess,
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      },
    );
  }

  @override
  LaunchpadContractSnapshot getContract(String projectId) {
    final normalizedId = projectId.trim();
    final matchingProjects = _launchpadProjects.where(
      (project) => project.id == normalizedId,
    );
    return LaunchpadContractSnapshot(
      endpoint: '/api/mobile/launchpad/launchpad-contract-$normalizedId',
      actionDraft: 'POST /launchpad/subscribe|claim|bridge where applicable',
      title: 'Contract',
      backRoute: '/launchpad',
      projectId: normalizedId,
      project: matchingProjects.isEmpty ? null : matchingProjects.first,
      networks: _bridgeNetworks,
      functions: _contractFunctions,
      simulations: _txSimulations,
      abiDiffRoute: '/launchpad/abi-diff/contract001',
      contractNotes:
          'Launchpad contract returns launchpadProjects, subscriptions, claims, bridgeOrders, contracts, bridgeNetworks, contractFunctions, txSimulations, abiDiffRoute, and screenState. ABI diff route is kept on the safe contract001 placeholder because encoded contract-address navigation requires backend confirmation.',
      supportedStates: const {
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      },
    );
  }
}
