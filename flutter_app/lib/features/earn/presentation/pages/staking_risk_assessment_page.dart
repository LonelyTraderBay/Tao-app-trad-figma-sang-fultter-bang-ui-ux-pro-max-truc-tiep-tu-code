import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_risk_assessment_page_sections.dart';
part '../widgets/staking_risk_assessment_page_common.dart';

class StakingRiskAssessmentPage extends ConsumerStatefulWidget {
  const StakingRiskAssessmentPage({super.key, this.shellRenderMode});

  static const questionCardKey = Key('sc357_question_card');
  static const firstOptionKey = Key('sc357_first_option');
  static const previousButtonKey = Key('sc357_previous_button');
  static const resultCardKey = Key('sc357_result_card');
  static const exploreButtonKey = Key('sc357_explore_button');
  static const resetButtonKey = Key('sc357_reset_button');

  static Key optionKey(String questionId, int value) {
    return Key('sc357_option_${questionId}_$value');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRiskAssessmentPage> createState() =>
      _StakingRiskAssessmentPageState();
}

class _StakingRiskAssessmentPageState
    extends ConsumerState<StakingRiskAssessmentPage> {
  int _currentQuestion = 0;
  bool _showResult = false;
  final Map<String, int> _answers = {};

  int get _score {
    return ref.read(stakingRiskAssessmentControllerProvider).score(_answers);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(stakingRiskAssessmentControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-357 StakingRiskAssessmentPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: _showResult ? snapshot.resultTitle : snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(
                    bottom: scrollTailReserve,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.tight,
                    children: _showResult
                        ? [
                            _ResultView(
                              snapshot: snapshot,
                              result: controller.resultForAnswers(_answers),
                              score: _score,
                              maxScore: controller.state.maxScore,
                              onReset: _reset,
                            ),
                          ]
                        : [
                            _ProgressHeader(
                              currentQuestion: _currentQuestion,
                              totalQuestions: snapshot.questions.length,
                            ),
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Staking risk review active',
                              message:
                                  'Answers classify staking knowledge, liquidity need, risk reaction and allocation limits before product selection.',
                              contractId: 'staking-risk-assessment',
                            ),
                            _QuestionCard(
                              question: snapshot.questions[_currentQuestion],
                              index: _currentQuestion,
                              selectedValue:
                                  _answers[snapshot
                                      .questions[_currentQuestion]
                                      .id],
                              onSelected: _selectOption,
                              onPrevious: _previous,
                            ),
                            _InfoBanner(text: snapshot.infoText),
                          ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectOption(StakingRiskQuestionDraft question, int value) {
    HapticFeedback.selectionClick();
    setState(() {
      _answers[question.id] = value;
      if (_currentQuestion < _questionsLength - 1) {
        _currentQuestion += 1;
      } else {
        _showResult = true;
      }
    });
  }

  int get _questionsLength {
    return ref
        .read(stakingRiskAssessmentControllerProvider)
        .state
        .snapshot
        .questions
        .length;
  }

  void _previous() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_currentQuestion > 0) _currentQuestion -= 1;
    });
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() {
      _currentQuestion = 0;
      _showResult = false;
      _answers.clear();
    });
  }
}
