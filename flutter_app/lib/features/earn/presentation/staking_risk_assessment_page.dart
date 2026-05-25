import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

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

  int get _score => _answers.values.fold(0, (sum, value) => sum + value);

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingRiskAssessmentRepositoryProvider)
        .getRiskAssessment();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-357 StakingRiskAssessmentPage',
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
                            result: _result(snapshot),
                            score: _score,
                            maxScore: snapshot.questions.length * 3,
                            onReset: _reset,
                          ),
                        ]
                      : [
                          _ProgressHeader(
                            currentQuestion: _currentQuestion,
                            totalQuestions: snapshot.questions.length,
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
        .read(stakingRiskAssessmentRepositoryProvider)
        .getRiskAssessment()
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

  StakingRiskProfileResultDraft _result(
    StakingRiskAssessmentSnapshot snapshot,
  ) {
    return snapshot.results.firstWhere(
      (result) => _score >= result.minScore && _score <= result.maxScore,
      orElse: () => snapshot.results.last,
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.currentQuestion,
    required this.totalQuestions,
  });

  final int currentQuestion;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions == 0
        ? 0.0
        : (currentQuestion + 1) / totalQuestions;
    final percent = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Câu hỏi ${currentQuestion + 1}/$totalQuestions',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: SizedBox(
            height: AppSpacing.x2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0, 1),
                  child: const ColoredBox(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.index,
    required this.selectedValue,
    required this.onSelected,
    required this.onPrevious,
  });

  final StakingRiskQuestionDraft question;
  final int index;
  final int? selectedValue;
  final void Function(StakingRiskQuestionDraft question, int value) onSelected;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskAssessmentPage.questionCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuestionNumber(number: index + 1),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  question.question,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          if (question.helpText != null) ...[
            const SizedBox(height: AppSpacing.x3),
            Text(
              question.helpText!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x5),
          for (var index = 0; index < question.options.length; index++) ...[
            _RiskOptionTile(
              key: index == 0 ? StakingRiskAssessmentPage.firstOptionKey : null,
              semanticKey: StakingRiskAssessmentPage.optionKey(
                question.id,
                question.options[index].value,
              ),
              option: question.options[index],
              selected: selectedValue == question.options[index].value,
              onTap: () => onSelected(question, question.options[index].value),
            ),
            if (index != question.options.length - 1)
              const SizedBox(height: AppSpacing.x3),
          ],
          if (index > 0) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCtaButton(
              key: StakingRiskAssessmentPage.previousButtonKey,
              variant: VitCtaButtonVariant.ghost,
              height: AppSpacing.buttonCompact,
              leading: const Icon(Icons.chevron_left_rounded),
              onPressed: onPrevious,
              child: const Text('Quay lại câu trước'),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuestionNumber extends StatelessWidget {
  const _QuestionNumber({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary12,
        border: Border.all(color: AppColors.primary30),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            '$number',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.primary,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}

class _RiskOptionTile extends StatelessWidget {
  const _RiskOptionTile({
    super.key,
    required this.semanticKey,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final Key semanticKey;
  final StakingRiskOptionDraft option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: semanticKey,
      child: Material(
        color: selected ? AppColors.primary12 : AppColors.surface2,
        borderRadius: AppRadii.xlRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.xlRadius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.borderSolid,
              ),
              borderRadius: AppRadii.xlRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.label,
                          style: AppTextStyles.caption.copyWith(
                            color: selected
                                ? AppColors.primary
                                : AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                            height: 1.35,
                          ),
                        ),
                        if (option.description != null) ...[
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            option.description!,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.chevron_right_rounded,
                    color: selected ? AppColors.primary : AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.snapshot,
    required this.result,
    required this.score,
    required this.maxScore,
    required this.onReset,
  });

  final StakingRiskAssessmentSnapshot snapshot;
  final StakingRiskProfileResultDraft result;
  final int score;
  final int maxScore;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final accent = _profileAccent(result.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: StakingRiskAssessmentPage.resultCardKey,
          radius: VitCardRadius.lg,
          borderColor: accent,
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ResultIcon(color: accent),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hồ sơ rủi ro của bạn:',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          result.label,
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          result.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              _ScoreMeter(score: score, maxScore: maxScore, color: accent),
            ],
          ),
        ),
        VitPageSection(
          label: 'Gợi ý cho bạn',
          accentColor: accent,
          children: [
            for (final recommendation in result.recommendations)
              _BulletRow(text: recommendation, color: accent),
          ],
        ),
        VitPageSection(
          label: 'Sản phẩm phù hợp',
          accentColor: AppColors.buy,
          children: [
            for (final product in result.products)
              _ProductTile(product: product),
          ],
        ),
        VitPageSection(
          label: 'Lưu ý',
          accentColor: AppColors.warn,
          children: [
            for (final warning in result.warnings)
              _BulletRow(text: warning, color: AppColors.warn),
          ],
        ),
        _InfoBanner(text: snapshot.footerDisclaimer),
        VitCtaButton(
          key: StakingRiskAssessmentPage.exploreButtonKey,
          onPressed: () {
            HapticFeedback.selectionClick();
            context.go(snapshot.stakingRoute);
          },
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Khám phá sản phẩm'),
        ),
        VitCtaButton(
          key: StakingRiskAssessmentPage.resetButtonKey,
          variant: VitCtaButtonVariant.secondary,
          leading: const Icon(Icons.refresh_rounded),
          onPressed: onReset,
          child: const Text('Làm lại'),
        ),
      ],
    );
  }
}

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color, width: 1.5),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Icon(
            Icons.shield_outlined,
            color: color,
            size: AppSpacing.iconLg,
          ),
        ),
      ),
    );
  }
}

class _ScoreMeter extends StatelessWidget {
  const _ScoreMeter({
    required this.score,
    required this.maxScore,
    required this.color,
  });

  final int score;
  final int maxScore;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = maxScore == 0 ? 0.0 : score / maxScore;

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Điểm của bạn:',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '$score/$maxScore điểm',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              height: AppSpacing.x2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: AppColors.surface3),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress.clamp(0, 1),
                    child: ColoredBox(color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final StakingRiskAssessmentProductDraft product;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Rủi ro: ${product.risk}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.apy,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'APY',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _profileAccent(StakingRiskProfileLevel level) {
  return switch (level) {
    StakingRiskProfileLevel.conservative => AppColors.buy,
    StakingRiskProfileLevel.moderate => AppColors.warn,
    StakingRiskProfileLevel.aggressive => AppColors.sell,
  };
}
