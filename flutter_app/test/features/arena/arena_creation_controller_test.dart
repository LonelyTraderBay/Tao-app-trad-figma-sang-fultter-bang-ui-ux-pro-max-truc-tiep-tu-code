import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';

ArenaCreateChallengeDraft _buildDraft({
  String title = 'BTC Weekly Predict',
  String domainLabel = 'Crypto / Markets',
  String challengeTypeLabel = 'Yes / No',
  String winCondition = 'BTC vượt mốc \$100K sẽ thắng.',
  String description = 'Dự đoán giá BTC theo tuần.',
  String endDate = '2026-03-15',
  String tieRule = 'Chia đều pool',
  String voidRule = 'Không đủ bằng chứng -> hủy',
  String resultDeadline = '24 giờ sau kết thúc',
  int clarityScore = 60,
  bool pointsBoundaryAccepted = true,
  bool ruleReviewAccepted = true,
  bool moderationAccepted = true,
  int entryPoints = 100,
  int slotsTotal = 24,
}) {
  return ArenaCreateChallengeDraft(
    title: title,
    domainLabel: domainLabel,
    challengeTypeLabel: challengeTypeLabel,
    winCondition: winCondition,
    description: description,
    endDate: endDate,
    tieRule: tieRule,
    voidRule: voidRule,
    resultDeadline: resultDeadline,
    clarityScore: clarityScore,
    pointsBoundaryAccepted: pointsBoundaryAccepted,
    ruleReviewAccepted: ruleReviewAccepted,
    moderationAccepted: moderationAccepted,
    entryPoints: entryPoints,
    slotsTotal: slotsTotal,
  );
}

void main() {
  ProviderContainer container() {
    final value = ProviderContainer();
    addTearDown(value.dispose);
    return value;
  }

  test(
    'ArenaCreationController preview() succeeds for a valid draft and stores the preview',
    () {
      final value = container();
      final controller = value.read(arenaCreationProvider.notifier);
      final draft = _buildDraft();

      final result = controller.preview(draft);
      final state = value.read(arenaCreationProvider);

      expect(result.ok, isTrue);
      expect(state.phase, ArenaCreationCommandPhase.previewReady);
      expect(state.previewDraft, draft);
    },
  );

  test(
    'ArenaCreationController preview() fails validation for a short title',
    () {
      final value = container();
      final controller = value.read(arenaCreationProvider.notifier);
      final draft = _buildDraft(title: 'Hi');

      final result = controller.preview(draft);
      final state = value.read(arenaCreationProvider);

      expect(draft.coreValidationErrors(), isNotEmpty);
      expect(result.ok, isFalse);
      expect(state.phase, ArenaCreationCommandPhase.error);
    },
  );

  test(
    'ArenaCreationController saveDraft() succeeds and appends a draft challenge',
    () {
      final value = container();
      final controller = value.read(arenaCreationProvider.notifier);
      final draft = _buildDraft();

      final result = controller.saveDraft(draft);
      final state = value.read(arenaCreationProvider);

      expect(result.ok, isTrue);
      expect(result.challengeId, 'draft-1');
      expect(state.phase, ArenaCreationCommandPhase.draftSaved);
      expect(state.savedDrafts, hasLength(1));
      expect(state.savedDrafts.first.id, 'draft-1');
    },
  );

  test(
    'ArenaCreationController saveDraft() fails validation for a short title',
    () {
      final value = container();
      final controller = value.read(arenaCreationProvider.notifier);
      final draft = _buildDraft(title: 'Hi');

      final result = controller.saveDraft(draft);
      final state = value.read(arenaCreationProvider);

      expect(result.ok, isFalse);
      expect(state.savedDrafts, isEmpty);
      expect(state.phase, ArenaCreationCommandPhase.error);
    },
  );

  test(
    'ArenaCreationController submitForReview() succeeds when all three gates are accepted',
    () {
      final value = container();
      final controller = value.read(arenaCreationProvider.notifier);
      final draft = _buildDraft();

      final result = controller.submitForReview(draft);
      final state = value.read(arenaCreationProvider);

      expect(draft.submitValidationErrors(), isEmpty);
      expect(result.ok, isTrue);
      expect(result.challengeId, isNotNull);
      expect(state.phase, ArenaCreationCommandPhase.submitted);
      expect(state.lastChallengeId, result.challengeId);
      expect(state.createdChallenges, hasLength(1));
    },
  );

  test(
    'ArenaCreationController submitForReview() fails when pointsBoundaryAccepted is false',
    () {
      final value = container();
      final controller = value.read(arenaCreationProvider.notifier);
      final draft = _buildDraft(pointsBoundaryAccepted: false);

      final result = controller.submitForReview(draft);
      final state = value.read(arenaCreationProvider);

      expect(result.ok, isFalse);
      expect(result.errors, ['Xác nhận challenge chỉ dùng Arena Points.']);
      expect(state.phase, ArenaCreationCommandPhase.error);
      expect(state.createdChallenges, isEmpty);
    },
  );

  test(
    'ArenaCreationController submitForReview() fails when ruleReviewAccepted is false',
    () {
      final controller = container().read(arenaCreationProvider.notifier);
      final draft = _buildDraft(ruleReviewAccepted: false);

      final result = controller.submitForReview(draft);

      expect(result.ok, isFalse);
      expect(result.errors, [
        'Xác nhận luật thắng, hòa, hủy và hạn kết quả đã rõ.',
      ]);
    },
  );

  test(
    'ArenaCreationController submitForReview() fails when moderationAccepted is false',
    () {
      final controller = container().read(arenaCreationProvider.notifier);
      final draft = _buildDraft(moderationAccepted: false);

      final result = controller.submitForReview(draft);

      expect(result.ok, isFalse);
      expect(result.errors, [
        'Xác nhận challenge sẽ qua moderation trước khi mở rộng.',
      ]);
    },
  );

  test('ArenaCreationController clearStatus() resets phase to idle', () {
    final value = container();
    final controller = value.read(arenaCreationProvider.notifier);
    controller.preview(_buildDraft());
    expect(
      value.read(arenaCreationProvider).phase,
      ArenaCreationCommandPhase.previewReady,
    );

    controller.clearStatus();

    expect(
      value.read(arenaCreationProvider).phase,
      ArenaCreationCommandPhase.idle,
    );
  });

  test(
    'ArenaCreateChallengeDraft exposes prizePoolPreview, normalizedTitle, formatLabel, and hasRequiredShape',
    () {
      final priced = _buildDraft(entryPoints: 150, slotsTotal: 10);
      final trimmed = _buildDraft(title: '  BTC Weekly  ');
      final noFormat = _buildDraft(challengeTypeLabel: '');
      final invalid = _buildDraft(title: 'Hi');

      expect(priced.prizePoolPreview, 1500);
      expect(trimmed.normalizedTitle, 'BTC Weekly');
      expect(noFormat.formatLabel, 'Custom Rule');
      expect(_buildDraft().formatLabel, 'Yes / No');
      expect(_buildDraft().hasRequiredShape, isTrue);
      expect(invalid.hasRequiredShape, isFalse);
    },
  );
}
