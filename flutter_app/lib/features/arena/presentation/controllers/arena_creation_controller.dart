import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/arena/domain/entities/arena_entities.dart';

enum ArenaCreationCommandPhase {
  idle,
  previewReady,
  draftSaved,
  submitting,
  submitted,
  error,
}

final class ArenaCreateChallengeDraft {
  const ArenaCreateChallengeDraft({
    required this.title,
    required this.domainLabel,
    required this.challengeTypeLabel,
    required this.winCondition,
    required this.description,
    required this.endDate,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
    required this.clarityScore,
    required this.pointsBoundaryAccepted,
    required this.ruleReviewAccepted,
    required this.moderationAccepted,
    this.entryPoints = 100,
    this.slotsTotal = 24,
    this.rematchEnabled = false,
    this.saveAsMode = false,
  });

  static const endpoint = 'POST /arena/challenges';

  final String title;
  final String domainLabel;
  final String challengeTypeLabel;
  final String winCondition;
  final String description;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;
  final int clarityScore;
  final int entryPoints;
  final int slotsTotal;
  final bool rematchEnabled;
  final bool saveAsMode;
  final bool pointsBoundaryAccepted;
  final bool ruleReviewAccepted;
  final bool moderationAccepted;

  String get normalizedTitle => title.trim();

  String get formatLabel {
    final label = challengeTypeLabel.trim();
    return label.isEmpty ? 'Custom Rule' : label;
  }

  int get prizePoolPreview => entryPoints * slotsTotal;

  bool get hasRequiredShape => coreValidationErrors().isEmpty;

  List<String> coreValidationErrors() {
    final errors = <String>[];
    if (normalizedTitle.length < 3) {
      errors.add('Nhập tên challenge tối thiểu 3 ký tự.');
    }
    if (domainLabel.trim().isEmpty) {
      errors.add('Chọn lĩnh vực để backend phân loại challenge.');
    }
    if (challengeTypeLabel.trim().isEmpty) {
      errors.add('Chọn loại challenge.');
    }
    if (winCondition.trim().isEmpty || winCondition.trim() == '-') {
      errors.add('Bổ sung điều kiện thắng rõ ràng.');
    }
    if (endDate.trim().isEmpty) {
      errors.add('Chọn thời hạn kết thúc.');
    }
    if (tieRule.trim().isEmpty) {
      errors.add('Chọn luật hòa để xử lý kết quả ngang nhau.');
    }
    if (voidRule.trim().isEmpty) {
      errors.add('Chọn luật hủy bỏ để xử lý sự kiện không hợp lệ.');
    }
    if (resultDeadline.trim().isEmpty) {
      errors.add('Chọn hạn chốt kết quả trước khi preview payload.');
    }
    if (clarityScore < 35) {
      errors.add('Rule clarity cần đạt tối thiểu 35 trước khi gửi.');
    }
    return errors;
  }

  List<String> submitValidationErrors() {
    final errors = coreValidationErrors();
    if (!ruleReviewAccepted) {
      errors.add('Xác nhận luật thắng, hòa, hủy và hạn kết quả đã rõ.');
    }
    if (!pointsBoundaryAccepted) {
      errors.add('Xác nhận challenge chỉ dùng Arena Points.');
    }
    if (!moderationAccepted) {
      errors.add('Xác nhận challenge sẽ qua moderation trước khi mở rộng.');
    }
    return errors;
  }

  ArenaChallengeDraft toChallengeDraft({required String id}) {
    return ArenaChallengeDraft(
      id: id,
      title: normalizedTitle,
      format: formatLabel,
      slotsFilled: 0,
      slotsTotal: slotsTotal,
      entryPoints: entryPoints,
      prizePool: prizePoolPreview,
      state: ArenaChallengeState.open,
    );
  }

  ArenaDraftChallenge toDraftChallenge({required String id}) {
    return ArenaDraftChallenge(
      id: id,
      title: normalizedTitle.isEmpty ? 'Challenge nháp' : normalizedTitle,
      format: formatLabel,
      updatedAt: 'Vừa lưu',
      entryPoints: entryPoints,
    );
  }

  List<String> backendPayloadRows() {
    return [
      endpoint,
      'title=$normalizedTitle',
      'domain=$domainLabel',
      'type=$challengeTypeLabel',
      'entryPoints=$entryPoints',
      'slotsTotal=$slotsTotal',
      'endDate=$endDate',
      'clarityScore=$clarityScore',
    ];
  }
}

final class ArenaCreationCommandResult {
  const ArenaCreationCommandResult({
    required this.ok,
    required this.statusLabel,
    this.challengeId,
    this.errors = const [],
  });

  final bool ok;
  final String statusLabel;
  final String? challengeId;
  final List<String> errors;
}

final class ArenaCreationViewState {
  const ArenaCreationViewState({
    this.phase = ArenaCreationCommandPhase.idle,
    this.statusLabel,
    this.errorMessage,
    this.previewDraft,
    this.lastChallengeId,
    this.createdChallenges = const [],
    this.savedDrafts = const [],
  });

  final ArenaCreationCommandPhase phase;
  final String? statusLabel;
  final String? errorMessage;
  final ArenaCreateChallengeDraft? previewDraft;
  final String? lastChallengeId;
  final List<ArenaChallengeDraft> createdChallenges;
  final List<ArenaDraftChallenge> savedDrafts;

  bool get hasLocalWork =>
      createdChallenges.isNotEmpty || savedDrafts.isNotEmpty;

  bool get isSubmitting => phase == ArenaCreationCommandPhase.submitting;

  ArenaCreationViewState copyWith({
    ArenaCreationCommandPhase? phase,
    String? statusLabel,
    String? errorMessage,
    ArenaCreateChallengeDraft? previewDraft,
    String? lastChallengeId,
    List<ArenaChallengeDraft>? createdChallenges,
    List<ArenaDraftChallenge>? savedDrafts,
    bool clearError = false,
  }) {
    return ArenaCreationViewState(
      phase: phase ?? this.phase,
      statusLabel: statusLabel ?? this.statusLabel,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      previewDraft: previewDraft ?? this.previewDraft,
      lastChallengeId: lastChallengeId ?? this.lastChallengeId,
      createdChallenges: List.unmodifiable(
        createdChallenges ?? this.createdChallenges,
      ),
      savedDrafts: List.unmodifiable(savedDrafts ?? this.savedDrafts),
    );
  }
}

final class ArenaCreationController extends Notifier<ArenaCreationViewState> {
  @override
  ArenaCreationViewState build() => const ArenaCreationViewState();

  ArenaCreationCommandResult preview(ArenaCreateChallengeDraft draft) {
    final errors = draft.coreValidationErrors();
    if (errors.isNotEmpty) return _fail(errors);
    state = state.copyWith(
      phase: ArenaCreationCommandPhase.previewReady,
      previewDraft: draft,
      statusLabel: 'Payload sẵn sàng cho BE',
      clearError: true,
    );
    return const ArenaCreationCommandResult(
      ok: true,
      statusLabel: 'Payload sẵn sàng cho BE',
    );
  }

  ArenaCreationCommandResult saveDraft(ArenaCreateChallengeDraft draft) {
    final errors = draft.normalizedTitle.length < 3
        ? ['Nhập tên challenge tối thiểu 3 ký tự trước khi lưu nháp.']
        : const <String>[];
    if (errors.isNotEmpty) return _fail(errors);

    final draftId = _nextId('draft');
    state = state.copyWith(
      phase: ArenaCreationCommandPhase.draftSaved,
      previewDraft: draft,
      statusLabel: 'Đã lưu nháp',
      savedDrafts: [
        draft.toDraftChallenge(id: draftId),
        ...state.savedDrafts,
      ],
      clearError: true,
    );
    return ArenaCreationCommandResult(
      ok: true,
      statusLabel: 'Đã lưu nháp',
      challengeId: draftId,
    );
  }

  ArenaCreationCommandResult submitForReview(ArenaCreateChallengeDraft draft) {
    final errors = draft.submitValidationErrors();
    if (errors.isNotEmpty) return _fail(errors);

    final challengeId = _nextId('local-challenge');
    state = state.copyWith(
      phase: ArenaCreationCommandPhase.submitted,
      previewDraft: draft,
      lastChallengeId: challengeId,
      statusLabel: 'Đã gửi kiểm duyệt',
      createdChallenges: [
        draft.toChallengeDraft(id: challengeId),
        ...state.createdChallenges,
      ],
      clearError: true,
    );
    return ArenaCreationCommandResult(
      ok: true,
      statusLabel: 'Đã gửi kiểm duyệt',
      challengeId: challengeId,
    );
  }

  void clearStatus() {
    state = state.copyWith(
      phase: ArenaCreationCommandPhase.idle,
      statusLabel: '',
      clearError: true,
    );
  }

  ArenaCreationCommandResult _fail(List<String> errors) {
    final label = errors.first;
    state = state.copyWith(
      phase: ArenaCreationCommandPhase.error,
      statusLabel: label,
      errorMessage: label,
    );
    return ArenaCreationCommandResult(
      ok: false,
      statusLabel: label,
      errors: List.unmodifiable(errors),
    );
  }

  String _nextId(String prefix) {
    final count = state.createdChallenges.length + state.savedDrafts.length + 1;
    return '$prefix-$count';
  }
}
