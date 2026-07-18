import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

ArenaSmartRuleFormDraft _smartRuleForm({
  String title = '',
  String domainId = '',
  String challengeTypeId = '',
  String subject = '',
  String action = '',
  String metric = '',
  String winType = '',
  String deadlineContext = '',
  String customWinCondition = '',
  String description = '',
  String endDate = '',
  String tieRule = '',
  String voidRule = '',
  String resultDeadline = '',
  bool rematchEnabled = false,
  bool saveAsMode = false,
  bool ruleReviewAccepted = false,
  bool pointsBoundaryAccepted = false,
  bool moderationAccepted = false,
}) {
  return ArenaSmartRuleFormDraft(
    title: title,
    domainId: domainId,
    challengeTypeId: challengeTypeId,
    subject: subject,
    action: action,
    metric: metric,
    winType: winType,
    deadlineContext: deadlineContext,
    customWinCondition: customWinCondition,
    description: description,
    endDate: endDate,
    tieRule: tieRule,
    voidRule: voidRule,
    resultDeadline: resultDeadline,
    rematchEnabled: rematchEnabled,
    saveAsMode: saveAsMode,
    ruleReviewAccepted: ruleReviewAccepted,
    pointsBoundaryAccepted: pointsBoundaryAccepted,
    moderationAccepted: moderationAccepted,
  );
}

void main() {
  test(
    'Arena join controller gates points-only acknowledgement state',
    () async {
      const repository = MockArenaRepository(loadDelay: Duration.zero);
      final controller = ArenaJoinController(
        state: ArenaJoinViewState(
          snapshot: await repository.getArenaJoin('ch003'),
        ),
      );

      expect(
        controller.canJoin(readRules: true, understandPoints: true),
        isTrue,
      );
      expect(
        controller.validationMessage(readRules: false, understandPoints: true),
        'Review the rules before joining.',
      );
      expect(ArenaLocalFlowStatus.confirming.isBusy, isTrue);
      expect(ArenaLocalFlowStatus.preview.hasPreview, isTrue);
      expect(ArenaLocalFlowStatus.validationError.isFailure, isTrue);
      expect(
        ArenaJoinController(
          state: ArenaJoinViewState(
            snapshot: await repository.getArenaJoin('ch003'),
            status: ArenaLocalFlowStatus.offline,
          ),
        ).validationMessage(readRules: true, understandPoints: true),
        'Offline: reconnect before joining with Arena Points.',
      );
    },
  );

  test(
    'Arena governance controller exposes action state boundary copy',
    () async {
      const repository = MockArenaRepository(loadDelay: Duration.zero);
      final controller = ArenaGovernanceController(
        state: ArenaGovernanceViewState(
          snapshot: await repository.getArenaGovernance(),
        ),
      );

      final state = controller.actionState(
        canProceed: false,
        nextAction: 'Add tie rule',
      );

      expect(state.canContinue, isFalse);
      expect(state.footerLabel, 'Add tie rule');
      expect(state.boundaryNote, contains('Arena Points'));
      expect(
        controller.validationMessage(canProceed: false),
        'Complete fair-play and Arena Points rule checks first.',
      );
      expect(controller.validationMessage(canProceed: true), isNull);
    },
  );

  test('Arena report controller owns appeal review state', () async {
    const repository = MockArenaRepository(loadDelay: Duration.zero);
    final controller = ArenaReportCaseController(
      state: ArenaReportCaseViewState(
        snapshot: await repository.getArenaReportCase('rpt001'),
      ),
    );

    final ready = controller.reviewState(appealSubmitted: false);
    final submitted = controller.reviewState(appealSubmitted: true);

    expect(ready.canAppeal, isTrue);
    expect(controller.canAppeal(appealSubmitted: false), isTrue);
    expect(ready.description, contains('rule evidence'));
    expect(submitted.canAppeal, isFalse);
    expect(submitted.statusLabel, 'Review requested');
    expect(
      controller.appealValidationMessage(appealSubmitted: true),
      'Report review request is already recorded.',
    );
    expect(controller.relatedReportsExcludingCurrent().map((item) => item.id), [
      'rpt002',
      'rpt003',
    ]);
  });

  test('Arena challenge controller builds points-only review model', () async {
    const repository = MockArenaRepository(loadDelay: Duration.zero);
    final controller = ArenaChallengeDetailController(
      state: ArenaChallengeDetailViewState(
        snapshot: await repository.getArenaChallengeDetail('ch003'),
      ),
    );

    final review = controller.pointsReview();

    expect(review.entryPointsLabel, '200');
    expect(review.poolLabel, '7.2K');
    expect(review.netPoolLabel, isNotEmpty);
    expect(review.boundaryNote, contains('Arena Points only'));
  });

  test(
    'Arena smart rule builder controller resolves options, generates rule copy, and gates submission',
    () async {
      const repository = MockArenaRepository(loadDelay: Duration.zero);
      final snapshot = await repository.getArenaSmartRules();
      final controller = ArenaSmartRuleBuilderController(
        state: ArenaSmartRuleBuilderViewState(snapshot: snapshot),
      );

      final cryptoForm = _smartRuleForm(
        domainId: 'crypto',
        challengeTypeId: 'yes_no',
      );
      expect(controller.selectedDomain(cryptoForm)?.label, 'Crypto / Markets');
      expect(controller.selectedChallengeType(cryptoForm)?.label, 'Yes / No');
      expect(
        controller.selectedDomain(_smartRuleForm(domainId: 'unknown')),
        isNull,
      );
      expect(controller.selectedDomain(_smartRuleForm()), isNull);
      expect(
        controller.selectedChallengeType(
          _smartRuleForm(challengeTypeId: 'unknown'),
        ),
        isNull,
      );
      expect(controller.selectedChallengeType(_smartRuleForm()), isNull);

      expect(controller.quickSuggestions(cryptoForm), [
        'Giá gần đúng nhất?',
        'Vượt mốc giá?',
        'Token nào tăng mạnh nhất?',
      ]);
      expect(
        controller.quickSuggestions(_smartRuleForm(domainId: 'sports')),
        snapshot.titleSuggestions,
      );

      final composedForm = _smartRuleForm(
        subject: 'Đội',
        action: 'đạt điểm cao nhất',
        metric: 'điểm số',
        deadlineContext: 'vào ngày kết thúc',
        winType: 'sẽ thắng',
      );
      expect(
        controller.generatedWinCondition(composedForm),
        'Đội đạt điểm cao nhất điểm số vào ngày kết thúc sẽ thắng.',
      );
      expect(
        controller.generatedWinCondition(
          _smartRuleForm(
            customWinCondition: 'Người thắng có bằng chứng hợp lệ',
          ),
        ),
        'Người thắng có bằng chứng hợp lệ',
      );
      expect(controller.generatedWinCondition(_smartRuleForm()), '-');

      expect(controller.clarityScore(_smartRuleForm()), 0);
      final fullForm = _smartRuleForm(
        title: 'BTC Weekly Predict',
        domainId: 'crypto',
        challengeTypeId: 'yes_no',
        subject: 'Đội',
        action: 'đạt điểm cao nhất',
        metric: 'điểm số',
        winType: 'sẽ thắng',
        deadlineContext: 'vào ngày kết thúc',
        customWinCondition: 'BTC vượt mốc 100K sẽ thắng chung cuộc',
        description:
            'Mô tả chi tiết cho challenge kèm điều kiện thắng rõ ràng.',
        endDate: '2026-03-15',
        tieRule: 'Chia đều pool',
        voidRule: 'Không đủ bằng chứng -> hủy',
        resultDeadline: '24 giờ sau kết thúc',
        ruleReviewAccepted: true,
        pointsBoundaryAccepted: true,
        moderationAccepted: true,
      );
      final fullScore = controller.clarityScore(fullForm);
      expect(fullScore, 100, reason: 'raw score exceeds 100 and must clamp');

      expect(controller.canProceed(_smartRuleForm()), isFalse);
      expect(controller.canProceed(fullForm), isTrue);
      expect(controller.canSubmit(fullForm, fullScore), isTrue);
      expect(controller.canSubmit(fullForm, 10), isFalse);

      final missingGate = _smartRuleForm(
        title: 'BTC Weekly Predict',
        domainId: 'crypto',
        challengeTypeId: 'yes_no',
        subject: 'Đội',
        action: 'đạt điểm cao nhất',
        tieRule: 'Chia đều pool',
        voidRule: 'Không đủ bằng chứng -> hủy',
        resultDeadline: '24 giờ sau kết thúc',
        pointsBoundaryAccepted: true,
        moderationAccepted: true,
      );
      expect(controller.canSubmit(missingGate, fullScore), isFalse);

      expect(
        controller.missingCoreRequirement(_smartRuleForm()),
        'Nhập tên challenge tối thiểu 3 ký tự.',
      );
      expect(
        controller.missingCoreRequirement(_smartRuleForm(title: 'BTC Weekly')),
        'Chọn lĩnh vực để phân loại challenge.',
      );
      expect(
        controller.missingCoreRequirement(
          _smartRuleForm(title: 'BTC Weekly', domainId: 'crypto'),
        ),
        'Chọn loại challenge.',
      );
      expect(
        controller.missingCoreRequirement(
          _smartRuleForm(
            title: 'BTC Weekly',
            domainId: 'crypto',
            challengeTypeId: 'yes_no',
          ),
        ),
        'Chọn điều kiện thắng hoặc tự nhập rule.',
      );

      final draft = controller.buildCreationDraft(fullForm, fullScore);
      expect(draft.domainLabel, 'Crypto / Markets');
      expect(draft.challengeTypeLabel, 'Yes / No');
      expect(draft.winCondition, controller.generatedWinCondition(fullForm));
    },
  );
}
