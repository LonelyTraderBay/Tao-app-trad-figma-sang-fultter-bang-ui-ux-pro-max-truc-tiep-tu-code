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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_suitability_assessment_page_sections.dart';
part '../widgets/staking_suitability_assessment_page_common.dart';

class StakingSuitabilityAssessmentPage extends ConsumerStatefulWidget {
  const StakingSuitabilityAssessmentPage({super.key, this.shellRenderMode});

  static const progressKey = Key('sc376_progress');
  static const questionCardKey = Key('sc376_question_card');
  static const infoKey = Key('sc376_info');
  static const previousButtonKey = Key('sc376_previous_button');
  static const nextButtonKey = Key('sc376_next_button');
  static const resultCardKey = Key('sc376_result_card');
  static const exploreButtonKey = Key('sc376_explore_button');
  static const resetButtonKey = Key('sc376_reset_button');

  static Key optionKey(String questionId, int index) {
    return Key('sc376_option_${questionId}_$index');
  }

  static Key quizOptionKey(int questionIndex, int optionIndex) {
    return Key('sc376_quiz_${questionIndex}_$optionIndex');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingSuitabilityAssessmentPage> createState() =>
      _StakingSuitabilityAssessmentPageState();
}

class _StakingSuitabilityAssessmentPageState
    extends ConsumerState<StakingSuitabilityAssessmentPage> {
  int _step = 0;
  bool _showResult = false;
  final Map<String, int> _answers = {};
  final Map<int, int> _quizAnswers = {};

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(stakingSuitabilityControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final footerBottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-376 StakingSuitabilityAssessmentPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: _showResult ? snapshot.resultTitle : snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: _showResult
                      ? [
                          _ResultView(
                            snapshot: snapshot,
                            profile: controller.profileForScore(_score),
                            score: _score,
                            onReset: _reset,
                          ),
                        ]
                      : [
                          _ProgressHeader(
                            current: _step,
                            total: snapshot.questions.length,
                          ),
                          _QuestionCard(
                            question: snapshot.questions[_step],
                            selected: _answers[snapshot.questions[_step].id],
                            quizAnswers: _quizAnswers,
                            onSelect: _selectAnswer,
                            onQuizSelect: _selectQuizAnswer,
                          ),
                          if (_step == 0)
                            _InfoBanner(
                              title: snapshot.infoTitle,
                              body: snapshot.infoBody,
                            ),
                        ],
                ),
              ),
            ),
            if (!_showResult)
              Padding(
                padding: EdgeInsets.only(bottom: footerBottomInset),
                child: VitStickyFooter(
                  child: Row(
                    children: [
                      if (_step > 0) ...[
                        Expanded(
                          child: VitCtaButton(
                            key: StakingSuitabilityAssessmentPage
                                .previousButtonKey,
                            variant: VitCtaButtonVariant.secondary,
                            height: AppSpacing.ctaHeight,
                            onPressed: _previous,
                            child: const Text('Previous'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                      ],
                      Expanded(
                        child: VitCtaButton(
                          key: StakingSuitabilityAssessmentPage.nextButtonKey,
                          height: AppSpacing.ctaHeight,
                          onPressed:
                              _isAnswered(controller, snapshot.questions[_step])
                              ? () => _next(snapshot)
                              : null,
                          child: Text(
                            _step == snapshot.questions.length - 1
                                ? 'Submit'
                                : 'Next',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  int get _score {
    return ref
        .read(stakingSuitabilityControllerProvider)
        .score(answers: _answers, quizAnswers: _quizAnswers);
  }

  void _selectAnswer(String questionId, int value) {
    HapticFeedback.selectionClick();
    setState(() => _answers[questionId] = value);
  }

  void _selectQuizAnswer(int questionIndex, int optionIndex) {
    HapticFeedback.selectionClick();
    setState(() => _quizAnswers[questionIndex] = optionIndex);
  }

  bool _isAnswered(
    StakingSuitabilityController controller,
    StakingSuitabilityQuestionDraft question,
  ) {
    return controller.isAnswered(
      question,
      answers: _answers,
      quizAnswers: _quizAnswers,
    );
  }

  void _next(StakingSuitabilityAssessmentSnapshot snapshot) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_step < snapshot.questions.length - 1) {
        _step += 1;
        _quizAnswers.clear();
      } else {
        _showResult = true;
      }
    });
  }

  void _previous() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_step > 0) _step -= 1;
    });
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() {
      _step = 0;
      _showResult = false;
      _answers.clear();
      _quizAnswers.clear();
    });
  }
}
