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

part '../widgets/savings_risk_assessment_questions.dart';
part '../widgets/savings_risk_assessment_result.dart';
part '../widgets/savings_risk_assessment_products_common.dart';

class SavingsRiskAssessmentPage extends ConsumerStatefulWidget {
  const SavingsRiskAssessmentPage({super.key, this.shellRenderMode});

  static const questionCardKey = Key('sc339_question_card');
  static const firstOptionKey = Key('sc339_first_option');
  static const previousButtonKey = Key('sc339_previous_button');
  static const resultCardKey = Key('sc339_result_card');
  static const recommendationsButtonKey = Key('sc339_recommendations_button');
  static const productsButtonKey = Key('sc339_products_button');
  static const resetButtonKey = Key('sc339_reset_button');

  static Key optionKey(String questionId, int value) {
    return Key('sc339_option_${questionId}_$value');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsRiskAssessmentPage> createState() =>
      _SavingsRiskAssessmentPageState();
}

class _SavingsRiskAssessmentPageState
    extends ConsumerState<SavingsRiskAssessmentPage> {
  int _currentQuestion = 0;
  bool _showResult = false;
  final Map<String, int> _answers = {};

  int get _score {
    return ref.read(savingsRiskAssessmentControllerProvider).score(_answers);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(savingsRiskAssessmentControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-339 SavingsRiskAssessmentPage',
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
                              title: 'Risk assessment in review',
                              message:
                                  'Answers are used only to classify suitability, risk tolerance, lockup comfort and next-step product review.',
                              contractId: 'savings-risk-assessment',
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

  void _selectOption(SavingsRiskQuestionDraft question, int value) {
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
        .read(savingsRiskAssessmentControllerProvider)
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
