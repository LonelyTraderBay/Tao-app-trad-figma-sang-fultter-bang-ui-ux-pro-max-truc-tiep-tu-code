import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _assessmentBackground = AppColors.bg;
const _assessmentPanel = AppColors.surface;
const _assessmentPanel2 = AppColors.surface2;
const _assessmentPrimary = AppColors.primary;
const _assessmentOptionBorder = AppColors.borderSolid;
const _assessmentGreen = Color(0xFF10B981);
const _assessmentAmber = Color(0xFFF59E0B);
const _assessmentRed = Color(0xFFEF4444);

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
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getBotSuitabilityAssessment();
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
        child: Column(
          children: [
            VitHeader(
              title: _showResult
                  ? 'Assessment Result'
                  : 'Suitability Assessment',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: _showResult
                    ? BotSuitabilityAssessmentPage.resultContentKey
                    : BotSuitabilityAssessmentPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: _showResult
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAnswer(String optionId) {
    final snapshot = ref
        .read(tradeRepositoryProvider)
        .getBotSuitabilityAssessment();
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
    final snapshot = ref
        .read(tradeRepositoryProvider)
        .getBotSuitabilityAssessment();
    context.go(snapshot.completionPath);
  }

  int _score(TradeBotSuitabilityAssessmentSnapshot snapshot) {
    var total = 0;
    for (final entry in _answers.entries) {
      final question = snapshot.questions.firstWhere((q) => q.id == entry.key);
      final option = question.options.firstWhere((o) => o.id == entry.value);
      total += option.score;
    }
    return total;
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.snapshot,
    required this.currentQuestion,
    required this.answers,
    required this.onAnswer,
  });

  final TradeBotSuitabilityAssessmentSnapshot snapshot;
  final int currentQuestion;
  final Map<String, String> answers;
  final ValueChanged<String> onAnswer;

  @override
  Widget build(BuildContext context) {
    final question = snapshot.questions[currentQuestion];
    final totalQuestions = snapshot.questions.length;
    final progress = answers.length / totalQuestions;
    final selected = answers[question.id];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProgressBar(
          currentQuestion: currentQuestion + 1,
          totalQuestions: totalQuestions,
          progress: progress,
        ),
        const SizedBox(height: 38),
        _QuestionHeader(question: question),
        const SizedBox(height: 55),
        for (final option in question.options) ...[
          _OptionCard(
            questionId: question.id,
            option: option,
            selected: selected == option.id,
            onTap: () => onAnswer(option.id),
          ),
          if (option != question.options.last) const SizedBox(height: 14),
        ],
        const SizedBox(height: 41),
        _InfoCard(snapshot: snapshot),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progress,
  });

  final int currentQuestion;
  final int totalQuestions;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Question $currentQuestion of $totalQuestions',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% Complete',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: _assessmentPanel2,
              valueColor: const AlwaysStoppedAnimation<Color>(
                _assessmentPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  const _QuestionHeader({required this.question});

  final TradeBotSuitabilityQuestion question;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _assessmentPrimary.withValues(alpha: .08),
            borderRadius: AppRadii.mdRadius,
          ),
          child: const Icon(
            Icons.assignment_turned_in_outlined,
            color: _assessmentPrimary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.category.name.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                  height: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                question.question,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.questionId,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final String questionId;
  final TradeBotSuitabilityOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: BotSuitabilityAssessmentPage.optionKey(questionId, option.id),
        borderRadius: AppRadii.cardRadius,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          decoration: BoxDecoration(
            color: selected
                ? _assessmentPrimary.withValues(alpha: .12)
                : _assessmentPanel,
            border: Border.all(
              color: selected ? _assessmentPrimary : _assessmentOptionBorder,
              width: 2,
            ),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? _assessmentPrimary
                        : _assessmentOptionBorder,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: _assessmentPrimary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  option.text,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? _assessmentPrimary : AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.medium,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.snapshot});

  final TradeBotSuitabilityAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: BotSuitabilityAssessmentPage.infoKey,
      constraints: const BoxConstraints(minHeight: 91),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _assessmentPrimary.withValues(alpha: .08),
        border: Border.all(color: _assessmentPrimary.withValues(alpha: .22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontFamily: 'Roboto',
            fontSize: 12,
            height: 1.55,
          ),
          children: [
            TextSpan(
              text: '${snapshot.infoTitle} ',
              style: const TextStyle(fontWeight: AppTextStyles.bold),
            ),
            TextSpan(text: snapshot.infoDescription),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.snapshot,
    required this.score,
    required this.answers,
    required this.onComplete,
  });

  final TradeBotSuitabilityAssessmentSnapshot snapshot;
  final int score;
  final Map<String, String> answers;
  final ValueChanged<TradeBotSuitabilityOutcomeCopy> onComplete;

  @override
  Widget build(BuildContext context) {
    final maxScore = snapshot.maxScore;
    final percent = maxScore == 0 ? 0.0 : score / maxScore;
    final result = _resultForPercent(percent);
    final color = _colorForResult(result.outcome);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
            ),
            child: Icon(_iconForResult(result.outcome), color: color, size: 48),
          ),
        ),
        const SizedBox(height: 23),
        Text(
          result.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontSize: 20,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          result.message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        _ScoreCard(
          score: score,
          maxScore: maxScore,
          percent: percent,
          color: color,
        ),
        const SizedBox(height: 21),
        _SectionLabel('Category Breakdown'),
        const SizedBox(height: 12),
        _CategoryBreakdown(snapshot: snapshot, answers: answers),
        const SizedBox(height: 21),
        _SectionLabel('Recommendations'),
        const SizedBox(height: 12),
        _RecommendationsCard(result: result, color: color),
        const SizedBox(height: 18),
        _RegulatoryCard(snapshot: snapshot),
        const SizedBox(height: 16),
        SizedBox(
          key: BotSuitabilityAssessmentPage.resultCtaKey,
          height: 44,
          child: FilledButton(
            onPressed: () => onComplete(result),
            style: FilledButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
            ),
            child: Text(
              result.ctaLabel,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TradeBotSuitabilityOutcomeCopy _resultForPercent(double percent) {
    if (percent >= .75) return snapshot.pass;
    if (percent >= .50) return snapshot.warning;
    return snapshot.fail;
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.score,
    required this.maxScore,
    required this.percent,
    required this.color,
  });

  final int score;
  final int maxScore;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _ResultCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Your Score',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 13,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '$score / $maxScore',
                style: AppTextStyles.baseMedium.copyWith(
                  color: color,
                  fontSize: 18,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 12,
              backgroundColor: _assessmentPanel2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(percent * 100).toStringAsFixed(0)}% proficiency',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.snapshot, required this.answers});

  final TradeBotSuitabilityAssessmentSnapshot snapshot;
  final Map<String, String> answers;

  @override
  Widget build(BuildContext context) {
    final categories = TradeBotSuitabilityCategory.values;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.47,
      children: [
        for (final category in categories)
          _CategoryScoreCard(
            label: _categoryLabel(category),
            score: _categoryScore(category),
            maxScore: _categoryMaxScore(category),
          ),
      ],
    );
  }

  int _categoryScore(TradeBotSuitabilityCategory category) {
    var score = 0;
    for (final question in snapshot.questions.where(
      (q) => q.category == category,
    )) {
      final answer = answers[question.id];
      if (answer == null) continue;
      score += question.options.firstWhere((o) => o.id == answer).score;
    }
    return score;
  }

  int _categoryMaxScore(TradeBotSuitabilityCategory category) {
    return snapshot.questions.where((q) => q.category == category).length * 3;
  }
}

class _CategoryScoreCard extends StatelessWidget {
  const _CategoryScoreCard({
    required this.label,
    required this.score,
    required this.maxScore,
  });

  final String label;
  final int score;
  final int maxScore;

  @override
  Widget build(BuildContext context) {
    final percent = maxScore == 0 ? 0.0 : score / maxScore;
    final color = percent >= .75
        ? _assessmentGreen
        : percent >= .50
        ? _assessmentAmber
        : _assessmentRed;

    return _ResultCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '$score/$maxScore',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: _assessmentPanel2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard({required this.result, required this.color});

  final TradeBotSuitabilityOutcomeCopy result;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _ResultCard(
      child: Column(
        children: [
          for (final recommendation in result.recommendations) ...[
            _RecommendationRow(
              text: recommendation,
              color: color,
              icon: _iconForResult(result.outcome),
            ),
            if (recommendation != result.recommendations.last)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _RecommendationRow extends StatelessWidget {
  const _RecommendationRow({
    required this.text,
    required this.color,
    required this.icon,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _RegulatoryCard extends StatelessWidget {
  const _RegulatoryCard({required this.snapshot});

  final TradeBotSuitabilityAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: _assessmentPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.regulatoryTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            snapshot.regulatoryDescription,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontSize: 16,
        fontWeight: AppTextStyles.bold,
        height: 1,
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _assessmentPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

Color _colorForResult(TradeBotSuitabilityOutcome outcome) {
  return switch (outcome) {
    TradeBotSuitabilityOutcome.pass => _assessmentGreen,
    TradeBotSuitabilityOutcome.warning => _assessmentAmber,
    TradeBotSuitabilityOutcome.fail => _assessmentRed,
  };
}

IconData _iconForResult(TradeBotSuitabilityOutcome outcome) {
  return switch (outcome) {
    TradeBotSuitabilityOutcome.pass => Icons.check_circle_outline_rounded,
    TradeBotSuitabilityOutcome.warning => Icons.warning_amber_rounded,
    TradeBotSuitabilityOutcome.fail => Icons.cancel_outlined,
  };
}

String _categoryLabel(TradeBotSuitabilityCategory category) {
  final name = category.name;
  return '${name.substring(0, 1).toUpperCase()}${name.substring(1)}';
}
