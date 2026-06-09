import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_suitability_questions_info.dart';
part '../widgets/bot_suitability_result_score.dart';
part '../widgets/bot_suitability_breakdown_common.dart';

const _assessmentBackground = AppColors.bg;
const _assessmentPanel = AppColors.surface;
const _assessmentPanel2 = AppColors.surface2;
const _assessmentPrimary = AppColors.primary;
const _assessmentOptionBorder = AppColors.borderSolid;
const _assessmentGreen = AppColors.buy;
const _assessmentAmber = AppColors.caution;
const _assessmentRed = AppColors.sell;

class BotSuitabilityAssessmentPage extends ConsumerStatefulWidget {
  const BotSuitabilityAssessmentPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc119_bot_suitability_content');
  static const resultContentKey = Key('sc119_bot_suitability_result_content');
  static const resultCtaKey = Key('sc119_bot_suitability_result_cta');
  static const infoKey = Key('sc119_bot_suitability_info');

  static Key optionKey(String questionId, String optionId) =>
      Key('sc119_bot_suitability_option_${questionId}_$optionId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotSuitabilityAssessmentPage> createState() =>
      _BotSuitabilityAssessmentPageState();
}

class _BotSuitabilityAssessmentPageState
    extends ConsumerState<BotSuitabilityAssessmentPage> {
  int _currentQuestion = 0;
  bool _showResult = false;
  final Map<String, String> _answers = {};

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(tradeBotSuitabilityControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 104
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-119 BotSuitabilityAssessmentPage',
      child: Material(
        color: _assessmentBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: _showResult ? 'Assessment Result' : 'Suitability Assessment',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: _showResult
                      ? BotSuitabilityAssessmentPage.resultContentKey
                      : BotSuitabilityAssessmentPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 18,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review bot suitability risk',
                        message:
                            'Confirm knowledge, risk limits, automation exposure, and next steps before enabling trading bots.',
                      ),
                      _showResult
                          ? _ResultView(
                              snapshot: snapshot,
                              score: _score(snapshot),
                              answers: _answers,
                              onComplete: _handleComplete,
                            )
                          : _QuestionView(
                              snapshot: snapshot,
                              currentQuestion: _currentQuestion,
                              answers: _answers,
                              onAnswer: _handleAnswer,
                            ),
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

  void _handleAnswer(String optionId) {
    final snapshot = ref
        .read(tradeBotSuitabilityControllerProvider)
        .state
        .snapshot;
    final question = snapshot.questions[_currentQuestion];

    setState(() {
      _answers[question.id] = optionId;
      if (_currentQuestion < snapshot.questions.length - 1) {
        _currentQuestion += 1;
      } else {
        _showResult = true;
      }
    });
  }

  void _handleComplete(TradeBotSuitabilityOutcomeCopy result) {
    if (result.outcome == TradeBotSuitabilityOutcome.fail) return;
    final path = ref
        .read(tradeBotSuitabilityControllerProvider)
        .completionPathFor(result);
    if (path.isNotEmpty) context.go(path);
  }

  int _score(TradeBotSuitabilityAssessmentSnapshot snapshot) {
    return ref.read(tradeBotSuitabilityControllerProvider).score(_answers);
  }
}
