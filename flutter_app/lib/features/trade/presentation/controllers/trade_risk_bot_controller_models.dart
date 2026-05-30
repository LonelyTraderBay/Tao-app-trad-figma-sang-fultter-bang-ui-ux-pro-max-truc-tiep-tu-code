import 'trade_controller_common.dart';

final class TradeRiskManagementViewState {
  const TradeRiskManagementViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeRiskManagementSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeRiskManagementController {
  const TradeRiskManagementController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeRiskManagementViewState state;
  final TradeRepository _repository;

  TradeOcoOrderResult submitOcoOrder(TradeOcoOrderDraft draft) {
    return _repository.submitOcoOrder(draft);
  }

  String? ocoValidationMessage(TradeOcoOrderDraft draft) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing this OCO order.';
    }
    if (state.status.isBusy) {
      return 'Risk order confirmation is already in progress.';
    }
    if (draft.symbol.trim().isEmpty) {
      return 'Select a symbol before OCO preview.';
    }
    if (draft.quantity <= 0 ||
        draft.limitPrice <= 0 ||
        draft.takeProfitPrice <= 0 ||
        draft.stopPrice <= 0) {
      return 'Enter valid quantity, limit, take-profit, and stop prices.';
    }
    if (draft.side == TradeOrderSide.buy &&
        draft.takeProfitPrice <= draft.limitPrice) {
      return 'Take-profit must be above the buy limit price.';
    }
    if (draft.side == TradeOrderSide.sell &&
        draft.stopPrice >= draft.limitPrice) {
      return 'Stop price must stay below the sell limit price.';
    }
    return null;
  }

  TradePositionSizeResult calculatePositionSize(
    TradePositionSizeRequest request,
  ) {
    return _repository.calculatePositionSize(request);
  }

  String? positionSizeValidationMessage(TradePositionSizeRequest request) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before calculating position size.';
    }
    if (request.accountBalance <= 0 || request.riskPct <= 0) {
      return 'Enter valid balance and risk percent before calculation.';
    }
    if (request.entryPrice <= 0 || request.stopPrice <= 0) {
      return 'Enter valid entry and stop prices before calculation.';
    }
    if (request.entryPrice == request.stopPrice) {
      return 'Entry and stop prices must be different.';
    }
    return null;
  }
}

final class TradeBotEmergencyStopViewState {
  const TradeBotEmergencyStopViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeBotEmergencyStopSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeBotEmergencyStopController {
  const TradeBotEmergencyStopController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeBotEmergencyStopViewState state;
  final TradeRepository _repository;

  bool canSubmit({required String? reasonId, required bool confirmed}) {
    return validationMessage(reasonId: reasonId, confirmed: confirmed) == null;
  }

  String? validationMessage({
    required String? reasonId,
    required bool confirmed,
  }) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before stopping trading bots.';
    }
    if (state.status.isBusy) {
      return 'Emergency stop confirmation is already in progress.';
    }
    if (reasonId == null || reasonId.trim().isEmpty) {
      return 'Select an emergency-stop reason before confirmation.';
    }
    if (!confirmed) {
      return 'Confirm the emergency-stop acknowledgement first.';
    }
    return null;
  }

  TradeBotEmergencyStopResult submit(TradeBotEmergencyStopDraft draft) {
    return _repository.submitBotEmergencyStop(draft);
  }
}

final class TradeBotSecuritySettingsViewState {
  const TradeBotSecuritySettingsViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeBotSecuritySettingsSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeBotSecuritySettingsController {
  const TradeBotSecuritySettingsController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeBotSecuritySettingsViewState state;
  final TradeRepository _repository;

  TradeBotSecuritySettingsResult saveTwoFa(bool enabled) {
    return _repository.patchBotSecuritySettings(
      TradeBotSecuritySettingsDraft(twoFaEnabled: enabled),
    );
  }

  String? saveValidationMessage() {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before saving bot security settings.';
    }
    if (state.status.isBusy) {
      return 'Bot security update is already in progress.';
    }
    return null;
  }
}

final class TradeBotSuitabilityViewState {
  const TradeBotSuitabilityViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeBotSuitabilityAssessmentSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeBotSuitabilityController {
  const TradeBotSuitabilityController({required this.state});

  final TradeBotSuitabilityViewState state;

  int score(Map<String, String> answers) {
    var total = 0;
    for (final entry in answers.entries) {
      final question = state.snapshot.questions.firstWhere(
        (question) => question.id == entry.key,
      );
      final option = question.options.firstWhere(
        (option) => option.id == entry.value,
      );
      total += option.score;
    }
    return total;
  }

  String completionPathFor(TradeBotSuitabilityOutcomeCopy result) {
    return result.outcome == TradeBotSuitabilityOutcome.fail
        ? ''
        : state.snapshot.completionPath;
  }
}

final class TradeBotsViewState {
  const TradeBotsViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeBotsSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeBotsController {
  const TradeBotsController({
    required this.state,
    required TradeRepository repository,
  }) : _repository = repository;

  final TradeBotsViewState state;
  final TradeRepository _repository;

  TradeBotActionResult submitAction({
    required String botId,
    required String action,
  }) {
    return _repository.submitBotAction(
      TradeBotActionRequest(botId: botId, action: action),
    );
  }

  TradeBotCreateResult createBot(TradeBotCreateRequest request) {
    return _repository.createTradingBot(request);
  }

  String? botActionValidationMessage({
    required String botId,
    required String action,
  }) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before changing this bot.';
    }
    if (state.status.isBusy) {
      return 'Bot action is already in progress.';
    }
    if (botId.trim().isEmpty || action.trim().isEmpty) {
      return 'Select a bot action before confirmation.';
    }
    return null;
  }

  String? createValidationMessage(TradeBotCreateRequest request) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before creating a trading bot.';
    }
    if (state.status.isBusy) {
      return 'Bot creation is already in progress.';
    }
    if (request.strategyId.trim().isEmpty) {
      return 'Select a strategy before creating a trading bot.';
    }
    if (request.params.isEmpty) {
      return 'Review bot parameters before creation.';
    }
    return null;
  }
}
