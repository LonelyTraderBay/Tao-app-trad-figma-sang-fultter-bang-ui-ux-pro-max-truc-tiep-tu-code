import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
import 'package:vit_trade_flutter/features/arena/domain/repositories/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_creation_controller.dart';

export 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';
export 'package:vit_trade_flutter/features/arena/domain/repositories/arena_repository.dart';

typedef ArenaReadModelController = ArenaRepository;

enum ArenaLocalFlowStatus {
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

extension ArenaLocalFlowStatusX on ArenaLocalFlowStatus {
  bool get isBusy {
    return this == ArenaLocalFlowStatus.confirming ||
        this == ArenaLocalFlowStatus.submitting;
  }

  bool get isFailure {
    return this == ArenaLocalFlowStatus.validationError ||
        this == ArenaLocalFlowStatus.error ||
        this == ArenaLocalFlowStatus.offline;
  }

  bool get hasPreview {
    return switch (this) {
      ArenaLocalFlowStatus.preview ||
      ArenaLocalFlowStatus.confirming ||
      ArenaLocalFlowStatus.submitting ||
      ArenaLocalFlowStatus.submitted ||
      ArenaLocalFlowStatus.success => true,
      _ => false,
    };
  }
}

final class ArenaJoinViewState {
  const ArenaJoinViewState({
    required this.snapshot,
    this.status = ArenaLocalFlowStatus.ready,
    this.errorMessage,
  });

  final ArenaJoinSnapshot snapshot;
  final ArenaLocalFlowStatus status;
  final String? errorMessage;
}

final class ArenaJoinController {
  const ArenaJoinController({required this.state});

  final ArenaJoinViewState state;

  bool canJoin({required bool readRules, required bool understandPoints}) {
    return validationMessage(
          readRules: readRules,
          understandPoints: understandPoints,
        ) ==
        null;
  }

  String? validationMessage({
    required bool readRules,
    required bool understandPoints,
  }) {
    if (state.status == ArenaLocalFlowStatus.offline) {
      return 'Offline: reconnect before joining with Arena Points.';
    }
    if (state.status.isBusy) {
      return 'Arena join confirmation is already in progress.';
    }
    if (state.snapshot.currentBalance < state.snapshot.challenge.entryPoints) {
      return 'Insufficient Arena Points for this join preview.';
    }
    if (!readRules) {
      return 'Review the rules before joining.';
    }
    if (!understandPoints) {
      return 'Confirm the Arena Points review before joining.';
    }
    return null;
  }
}

final class ArenaGovernanceViewState {
  const ArenaGovernanceViewState({
    required this.snapshot,
    this.status = ArenaLocalFlowStatus.ready,
    this.statusLabel,
  });

  final ArenaGovernanceSnapshot snapshot;
  final ArenaLocalFlowStatus status;
  final String? statusLabel;
}

final class ArenaGovernanceController {
  const ArenaGovernanceController({required this.state});

  final ArenaGovernanceViewState state;

  String? validationMessage({required bool canProceed}) {
    if (state.status == ArenaLocalFlowStatus.offline) {
      return 'Offline: reconnect before submitting governance review.';
    }
    if (state.status.isBusy) {
      return 'Governance review is already in progress.';
    }
    if (!canProceed) {
      return 'Complete fair-play and Arena Points rule checks first.';
    }
    return null;
  }

  ArenaGovernanceActionState actionState({
    required bool canProceed,
    required String nextAction,
    String? statusLabel,
  }) {
    return ArenaGovernanceActionState(
      canContinue: canProceed,
      footerLabel: statusLabel ?? nextAction,
      boundaryNote:
          'Governance only reviews rules, completion, fair play, and Arena Points.',
    );
  }
}

final class ArenaGovernanceActionState {
  const ArenaGovernanceActionState({
    required this.canContinue,
    required this.footerLabel,
    required this.boundaryNote,
  });

  final bool canContinue;
  final String footerLabel;
  final String boundaryNote;
}

final class ArenaReportCaseViewState {
  const ArenaReportCaseViewState({
    required this.snapshot,
    this.status = ArenaLocalFlowStatus.ready,
    this.errorMessage,
  });

  final ArenaReportCaseSnapshot snapshot;
  final ArenaLocalFlowStatus status;
  final String? errorMessage;
}

final class ArenaReportCaseController {
  const ArenaReportCaseController({required this.state});

  final ArenaReportCaseViewState state;

  bool canAppeal({required bool appealSubmitted}) {
    return appealValidationMessage(appealSubmitted: appealSubmitted) == null;
  }

  String? appealValidationMessage({required bool appealSubmitted}) {
    if (state.status == ArenaLocalFlowStatus.offline) {
      return 'Offline: reconnect before requesting report review.';
    }
    if (state.status.isBusy) {
      return 'Report review request is already in progress.';
    }
    final reportCase = state.snapshot.reportCase;
    if (reportCase == null) {
      return 'Report case is unavailable for review.';
    }
    if (appealSubmitted) {
      return 'Report review request is already recorded.';
    }
    if (reportCase.status != ArenaReportCaseStatus.actionTaken) {
      return 'Report can only request review after moderation action.';
    }
    return null;
  }

  ArenaReportReviewState reviewState({required bool appealSubmitted}) {
    final reportCase = state.snapshot.reportCase;
    if (reportCase == null) {
      return const ArenaReportReviewState(
        title: 'Report unavailable',
        description: 'No local report case is available for this route.',
        statusLabel: 'Empty',
        canAppeal: false,
      );
    }

    final canAppeal = this.canAppeal(appealSubmitted: appealSubmitted);
    return ArenaReportReviewState(
      title: appealSubmitted
          ? 'Appeal review recorded'
          : 'Moderation review state',
      description: canAppeal
          ? 'Appeal opens a local review request for moderation notes and rule evidence.'
          : 'Report handling stays limited to safety, rule clarity, and fair-play review.',
      statusLabel: appealSubmitted
          ? 'Review requested'
          : _reportStatusLabel(reportCase.status),
      canAppeal: canAppeal,
    );
  }

  List<ArenaReportCaseDraft> relatedReportsExcludingCurrent() {
    return state.snapshot.relatedReports
        .where((report) => report.id != state.snapshot.caseId)
        .toList(growable: false);
  }
}

final class ArenaReportReviewState {
  const ArenaReportReviewState({
    required this.title,
    required this.description,
    required this.statusLabel,
    required this.canAppeal,
  });

  final String title;
  final String description;
  final String statusLabel;
  final bool canAppeal;
}

final class ArenaChallengeDetailViewState {
  const ArenaChallengeDetailViewState({
    required this.snapshot,
    this.status = ArenaLocalFlowStatus.ready,
    this.errorMessage,
  });

  final ArenaChallengeDetailSnapshot snapshot;
  final ArenaLocalFlowStatus status;
  final String? errorMessage;
}

final class ArenaChallengeDetailController {
  const ArenaChallengeDetailController({required this.state});

  final ArenaChallengeDetailViewState state;

  ArenaChallengePointsReview pointsReview() {
    final challenge = state.snapshot.challenge;
    return ArenaChallengePointsReview(
      entryPointsLabel: formatArenaPoints(challenge.entryPoints),
      poolLabel: formatArenaPoints(challenge.prizePool),
      netPoolLabel: formatArenaPoints(challenge.netPrizePool),
      feeLabel:
          '${challenge.platformFeePercent}% platform / ${challenge.creatorCutPercent}% creator',
      boundaryNote:
          'Arena Points only. Completion, fair-play review, and Points pool stay inside Open Arena.',
    );
  }
}

final class ArenaChallengePointsReview {
  const ArenaChallengePointsReview({
    required this.entryPointsLabel,
    required this.poolLabel,
    required this.netPoolLabel,
    required this.feeLabel,
    required this.boundaryNote,
  });

  final String entryPointsLabel;
  final String poolLabel;
  final String netPoolLabel;
  final String feeLabel;
  final String boundaryNote;
}

String formatArenaPoints(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toString();
}

String _reportStatusLabel(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => 'Submitted',
    ArenaReportCaseStatus.underReview => 'Under review',
    ArenaReportCaseStatus.actionTaken => 'Action taken',
    ArenaReportCaseStatus.closed => 'Closed',
    ArenaReportCaseStatus.appealOpen => 'Appeal open',
  };
}

final class ArenaSmartRuleFormDraft {
  const ArenaSmartRuleFormDraft({
    required this.title,
    required this.domainId,
    required this.challengeTypeId,
    required this.subject,
    required this.action,
    required this.metric,
    required this.winType,
    required this.deadlineContext,
    required this.customWinCondition,
    required this.description,
    required this.endDate,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
    required this.rematchEnabled,
    required this.saveAsMode,
    required this.ruleReviewAccepted,
    required this.pointsBoundaryAccepted,
    required this.moderationAccepted,
  });

  final String title;
  final String domainId;
  final String challengeTypeId;
  final String subject;
  final String action;
  final String metric;
  final String winType;
  final String deadlineContext;
  final String customWinCondition;
  final String description;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;
  final bool rematchEnabled;
  final bool saveAsMode;
  final bool ruleReviewAccepted;
  final bool pointsBoundaryAccepted;
  final bool moderationAccepted;
}

final class ArenaSmartRuleBuilderViewState {
  const ArenaSmartRuleBuilderViewState({required this.snapshot});
  final ArenaSmartRulesSnapshot snapshot;
}

final class ArenaSmartRuleBuilderController {
  const ArenaSmartRuleBuilderController({required this.state});
  final ArenaSmartRuleBuilderViewState state;

  ArenaSmartOptionDraft? selectedDomain(ArenaSmartRuleFormDraft form) {
    if (form.domainId.isEmpty) return null;
    for (final domain in state.snapshot.domains) {
      if (domain.id == form.domainId) return domain;
    }
    return null;
  }

  ArenaSmartOptionDraft? selectedChallengeType(ArenaSmartRuleFormDraft form) {
    if (form.challengeTypeId.isEmpty) return null;
    for (final type in state.snapshot.challengeTypes) {
      if (type.id == form.challengeTypeId) return type;
    }
    return null;
  }

  List<String> quickSuggestions(ArenaSmartRuleFormDraft form) {
    if (form.domainId == 'crypto') {
      return [
        'Giá gần đúng nhất?',
        'Vượt mốc giá?',
        'Token nào tăng mạnh nhất?',
      ];
    }
    return state.snapshot.titleSuggestions;
  }

  String generatedWinCondition(ArenaSmartRuleFormDraft form) {
    final parts = <String>[
      if (form.subject.isNotEmpty) form.subject,
      if (form.action.isNotEmpty) form.action,
      if (form.metric.isNotEmpty) form.metric,
      if (form.deadlineContext.isNotEmpty) form.deadlineContext,
      if (form.winType.isNotEmpty) form.winType,
    ];
    if (parts.isNotEmpty) return '${parts.join(' ')}.';
    if (form.customWinCondition.trim().isNotEmpty) {
      return form.customWinCondition;
    }
    return '-';
  }

  int clarityScore(ArenaSmartRuleFormDraft form) {
    var score = 0;
    if (form.title.length >= 5) {
      score += 10;
    } else if (form.title.length >= 3) {
      score += 5;
    }
    if (form.domainId.isNotEmpty) score += 10;
    if (form.challengeTypeId.isNotEmpty) score += 10;
    if (form.subject.isNotEmpty) score += 8;
    if (form.action.isNotEmpty) score += 8;
    if (form.metric.isNotEmpty) score += 6;
    if (form.winType.isNotEmpty) score += 5;
    if (form.deadlineContext.isNotEmpty) score += 5;
    if (form.customWinCondition.length >= 10) {
      score += 15;
    } else if (form.customWinCondition.length >= 5) {
      score += 8;
    }
    if (form.description.length >= 20) {
      score += 8;
    } else if (form.description.length >= 5) {
      score += 4;
    }
    if (form.tieRule.isNotEmpty) score += 8;
    if (form.voidRule.isNotEmpty) score += 8;
    if (form.resultDeadline.isNotEmpty) score += 8;
    if (form.endDate.isNotEmpty) score += 5;
    return score.clamp(0, 100);
  }

  bool canProceed(ArenaSmartRuleFormDraft form) {
    final hasStructuredRule = form.subject.isNotEmpty && form.action.isNotEmpty;
    final hasCustomRule = form.customWinCondition.trim().length >= 5;
    return form.title.trim().length >= 3 &&
        form.domainId.isNotEmpty &&
        form.challengeTypeId.isNotEmpty &&
        (hasStructuredRule || hasCustomRule);
  }

  bool canSubmit(ArenaSmartRuleFormDraft form, int clarityScore) {
    return canProceed(form) &&
        clarityScore >= 35 &&
        form.tieRule.isNotEmpty &&
        form.voidRule.isNotEmpty &&
        form.resultDeadline.isNotEmpty &&
        form.ruleReviewAccepted &&
        form.pointsBoundaryAccepted &&
        form.moderationAccepted;
  }

  String missingCoreRequirement(ArenaSmartRuleFormDraft form) {
    if (form.title.trim().length < 3) {
      return 'Nhập tên challenge tối thiểu 3 ký tự.';
    }
    if (form.domainId.isEmpty) return 'Chọn lĩnh vực để phân loại challenge.';
    if (form.challengeTypeId.isEmpty) return 'Chọn loại challenge.';
    if (generatedWinCondition(form) == '-') {
      return 'Chọn điều kiện thắng hoặc tự nhập rule.';
    }
    return 'Hoàn thiện thêm rule để tiếp tục.';
  }

  ArenaCreateChallengeDraft buildCreationDraft(
    ArenaSmartRuleFormDraft form,
    int clarityScore,
  ) {
    return ArenaCreateChallengeDraft(
      title: form.title,
      domainLabel: selectedDomain(form)?.label ?? '',
      challengeTypeLabel: selectedChallengeType(form)?.label ?? '',
      winCondition: generatedWinCondition(form),
      description: form.description,
      endDate: form.endDate,
      tieRule: form.tieRule,
      voidRule: form.voidRule,
      resultDeadline: form.resultDeadline,
      clarityScore: clarityScore,
      rematchEnabled: form.rematchEnabled,
      saveAsMode: form.saveAsMode,
      pointsBoundaryAccepted: form.pointsBoundaryAccepted,
      ruleReviewAccepted: form.ruleReviewAccepted,
      moderationAccepted: form.moderationAccepted,
    );
  }
}
