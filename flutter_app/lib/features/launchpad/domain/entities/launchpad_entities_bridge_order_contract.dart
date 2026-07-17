part of 'launchpad_entities.dart';

final class LaunchpadRiskAuditDraft {
  const LaunchpadRiskAuditDraft({
    required this.firm,
    required this.date,
    required this.status,
    required this.criticalIssues,
  });

  final String firm;
  final String date;
  final String status;
  final int criticalIssues;
}

final class LaunchpadRiskResourceDraft {
  const LaunchpadRiskResourceDraft({required this.label, required this.url});

  final String label;
  final String url;
}

enum LaunchpadBridgeOrderStatus {
  initiated,
  approved,
  bridging,
  confirming,
  swapping,
  finalizing,
  completed,
  failed,
}

enum LaunchpadBridgeEventLevel { info, success, warning, error, debug, system }

enum LaunchpadBridgeConnectionState {
  connecting,
  connected,
  reconnecting,
  disconnected,
}

final class LaunchpadBridgeOrderSnapshot {
  const LaunchpadBridgeOrderSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.supportRoute,
    required this.txId,
    required this.order,
    required this.events,
    required this.contractNotes,
    required this.supportedStates,
    this.highRiskContractId,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String supportRoute;
  final String txId;
  final LaunchpadBridgeOrderDraft order;
  final List<LaunchpadBridgeEventDraft> events;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
  final String? highRiskContractId;
}

final class LaunchpadBridgeOrderDraft {
  const LaunchpadBridgeOrderDraft({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.projectSymbol,
    required this.accent,
    required this.sourceChain,
    required this.targetChain,
    required this.inputToken,
    required this.outputToken,
    required this.inputAmount,
    required this.expectedOutput,
    required this.routeProvider,
    required this.routeHops,
    required this.slippage,
    required this.gasCost,
    required this.totalFee,
    required this.priceImpact,
    required this.status,
    required this.steps,
    required this.createdAt,
    required this.etaSeconds,
    required this.pollCount,
    required this.sourceTxHash,
    required this.connectionState,
  });

  final String id;
  final String projectId;
  final String projectName;
  final String projectSymbol;
  final AccentTone accent;
  final String sourceChain;
  final String targetChain;
  final String inputToken;
  final String outputToken;
  final double inputAmount;
  final int expectedOutput;
  final String routeProvider;
  final int routeHops;
  final double slippage;
  final String gasCost;
  final String totalFee;
  final double priceImpact;
  final LaunchpadBridgeOrderStatus status;
  final List<LaunchpadBridgeStepDraft> steps;
  final String createdAt;
  final int etaSeconds;
  final int pollCount;
  final String sourceTxHash;
  final LaunchpadBridgeConnectionState connectionState;
}

final class LaunchpadBridgeStepDraft {
  const LaunchpadBridgeStepDraft({
    required this.id,
    required this.status,
    required this.label,
    required this.detail,
    this.timestamp,
    this.txHash,
    this.confirmationsCurrent,
    this.confirmationsRequired,
  });

  final String id;
  final LaunchpadBridgeOrderStatus status;
  final String label;
  final String detail;
  final String? timestamp;
  final String? txHash;
  final int? confirmationsCurrent;
  final int? confirmationsRequired;
}

final class LaunchpadBridgeEventDraft {
  const LaunchpadBridgeEventDraft({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.source,
    required this.message,
    this.txHash,
  });

  final String id;
  final String timestamp;
  final LaunchpadBridgeEventLevel level;
  final String source;
  final String message;
  final String? txHash;
}

enum LaunchpadContractFunctionType { read, write }

enum LaunchpadContractRiskLevel { low, medium, high }

enum LaunchpadTxSimulationStatus { simulating, success, warning, failed }

final class LaunchpadContractSnapshot {
  const LaunchpadContractSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.projectId,
    required this.project,
    required this.networks,
    required this.functions,
    required this.simulations,
    required this.abiDiffRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final String projectId;
  final LaunchpadProjectDraft? project;
  final List<LaunchpadBridgeNetworkDraft> networks;
  final List<LaunchpadContractFunctionDraft> functions;
  final List<LaunchpadTxSimulationDraft> simulations;
  final String abiDiffRoute;
  final String contractNotes;
  final Set<LaunchpadScreenState> supportedStates;
}

final class LaunchpadContractFunctionDraft {
  const LaunchpadContractFunctionDraft({
    required this.name,
    required this.description,
    required this.type,
    required this.riskLevel,
    required this.params,
    this.estimatedGas,
  });

  final String name;
  final String description;
  final LaunchpadContractFunctionType type;
  final LaunchpadContractRiskLevel riskLevel;
  final List<LaunchpadContractParamDraft> params;
  final String? estimatedGas;
}

final class LaunchpadContractParamDraft {
  const LaunchpadContractParamDraft({
    required this.name,
    required this.type,
    required this.label,
    required this.placeholder,
    required this.required,
  });

  final String name;
  final String type;
  final String label;
  final String placeholder;
  final bool required;
}

final class LaunchpadTxSimulationDraft {
  const LaunchpadTxSimulationDraft({
    required this.id,
    required this.functionName,
    required this.chain,
    required this.contractAddress,
    required this.params,
    required this.status,
    required this.gasEstimate,
    required this.gasPrice,
    required this.totalCost,
    required this.expectedOutput,
    required this.warnings,
    required this.stateChanges,
  });

  final String id;
  final String functionName;
  final String chain;
  final String contractAddress;
  final Map<String, String> params;
  final LaunchpadTxSimulationStatus status;
  final String gasEstimate;
  final String gasPrice;
  final String totalCost;
  final String expectedOutput;
  final List<String> warnings;
  final List<String> stateChanges;
}
