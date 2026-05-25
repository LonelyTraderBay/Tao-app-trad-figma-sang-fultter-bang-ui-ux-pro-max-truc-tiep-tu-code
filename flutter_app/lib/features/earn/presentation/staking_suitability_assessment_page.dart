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
    final snapshot = ref
        .watch(stakingSuitabilityAssessmentRepositoryProvider)
        .getAssessment();
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
                          onPressed: _isAnswered(snapshot.questions[_step])
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
    final snapshot = ref
        .read(stakingSuitabilityAssessmentRepositoryProvider)
        .getAssessment();
    var total = 0;
    for (final question in snapshot.questions) {
      final answer = _answers[question.id];
      if (question.type == StakingSuitabilityQuestionType.single &&
          answer != null) {
        total += question.options[answer].weight;
      } else if (question.type == StakingSuitabilityQuestionType.slider &&
          answer != null) {
        total += answer * (question.weight ?? 1);
      } else if (question.type == StakingSuitabilityQuestionType.quiz) {
        for (var i = 0; i < question.quizQuestions.length; i++) {
          if (_quizAnswers[i] == question.quizQuestions[i].correctIndex) {
            total += question.weight ?? 1;
          }
        }
      }
    }
    return total.clamp(0, 100);
  }

  void _selectAnswer(String questionId, int value) {
    HapticFeedback.selectionClick();
    setState(() => _answers[questionId] = value);
  }

  void _selectQuizAnswer(int questionIndex, int optionIndex) {
    HapticFeedback.selectionClick();
    setState(() => _quizAnswers[questionIndex] = optionIndex);
  }

  bool _isAnswered(StakingSuitabilityQuestionDraft question) {
    if (question.type == StakingSuitabilityQuestionType.quiz) {
      return _quizAnswers.length == question.quizQuestions.length;
    }
    return _answers.containsKey(question.id);
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

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (current + 1) / total;
    return Column(
      key: StakingSuitabilityAssessmentPage.progressKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Question ${current + 1} of $total',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
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
    required this.selected,
    required this.quizAnswers,
    required this.onSelect,
    required this.onQuizSelect,
  });

  final StakingSuitabilityQuestionDraft question;
  final int? selected;
  final Map<int, int> quizAnswers;
  final void Function(String questionId, int value) onSelect;
  final void Function(int questionIndex, int optionIndex) onQuizSelect;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSuitabilityAssessmentPage.questionCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.question,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 18,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          if (question.type == StakingSuitabilityQuestionType.single)
            for (var i = 0; i < question.options.length; i++) ...[
              _OptionTile(
                key: StakingSuitabilityAssessmentPage.optionKey(question.id, i),
                label: question.options[i].label,
                selected: selected == i,
                onTap: () => onSelect(question.id, i),
              ),
              if (i != question.options.length - 1)
                const SizedBox(height: AppSpacing.x3),
            ]
          else if (question.type == StakingSuitabilityQuestionType.slider)
            _SliderQuestion(
              question: question,
              value: selected ?? question.min ?? 1,
              onChanged: (value) => onSelect(question.id, value),
            )
          else
            for (var q = 0; q < question.quizQuestions.length; q++) ...[
              _QuizQuestion(
                index: q,
                quiz: question.quizQuestions[q],
                selected: quizAnswers[q],
                onSelect: (option) => onQuizSelect(q, option),
              ),
              if (q != question.quizQuestions.length - 1)
                const SizedBox(height: AppSpacing.x3),
            ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface3,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        borderRadius: AppRadii.xlRadius,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 1.5,
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
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? AppColors.primary : AppColors.primary30,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliderQuestion extends StatelessWidget {
  const _SliderQuestion({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final StakingSuitabilityQuestionDraft question;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Conservative',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const Spacer(),
            Text(
              'Aggressive',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        Slider(
          min: (question.min ?? 1).toDouble(),
          max: (question.max ?? 10).toDouble(),
          divisions: ((question.max ?? 10) - (question.min ?? 1)),
          value: value.toDouble(),
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surface3,
          onChanged: (next) => onChanged(next.round()),
        ),
        Text(
          '$value',
          style: AppTextStyles.heroNumber.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}

class _QuizQuestion extends StatelessWidget {
  const _QuizQuestion({
    required this.index,
    required this.quiz,
    required this.selected,
    required this.onSelect,
  });

  final int index;
  final StakingSuitabilityQuizDraft quiz;
  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${index + 1}. ${quiz.question}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (var i = 0; i < quiz.options.length; i++) ...[
            _QuizOption(
              key: StakingSuitabilityAssessmentPage.quizOptionKey(index, i),
              label: quiz.options[i],
              selected: selected == i,
              onTap: () => onSelect(i),
            ),
            if (i != quiz.options.length - 1)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  const _QuizOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.bg,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        borderRadius: AppRadii.lgRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primary : AppColors.text2,
              fontWeight: selected ? AppTextStyles.bold : AppTextStyles.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSuitabilityAssessmentPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  body,
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
    );
  }
}

class _ResultView extends ConsumerWidget {
  const _ResultView({
    required this.snapshot,
    required this.score,
    required this.onReset,
  });

  final StakingSuitabilityAssessmentSnapshot snapshot;
  final int score;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = snapshot.profiles.firstWhere(
      (item) => score >= item.minScore && score <= item.maxScore,
      orElse: () => snapshot.profiles.last,
    );
    final color = _profileColor(profile.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: StakingSuitabilityAssessmentPage.resultCardKey,
          radius: VitCardRadius.lg,
          borderColor: color.withValues(alpha: 0.6),
          padding: const EdgeInsets.all(AppSpacing.x5),
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  border: Border.all(color: color, width: 3),
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$score',
                          style: AppTextStyles.heroNumber.copyWith(
                            color: color,
                          ),
                        ),
                        Text(
                          '/ 100',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                '${profile.label} Investor',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle.copyWith(color: color),
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                profile.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        VitPageSection(
          label: 'Recommended Products',
          accentColor: color,
          children: [
            for (final product in profile.products)
              _RecommendedProduct(product: product, color: color),
          ],
        ),
        if (profile.warning != null)
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn15,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Text(
              profile.warning!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
          ),
        VitCtaButton(
          key: StakingSuitabilityAssessmentPage.exploreButtonKey,
          onPressed: () => context.go(snapshot.stakingRoute),
          trailing: const Icon(Icons.arrow_forward_rounded),
          child: const Text('Explore Recommended Products'),
        ),
        VitCtaButton(
          key: StakingSuitabilityAssessmentPage.resetButtonKey,
          variant: VitCtaButtonVariant.secondary,
          onPressed: onReset,
          leading: const Icon(Icons.refresh_rounded),
          child: const Text('Retake Assessment'),
        ),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Text(
            'This assessment is valid until ${snapshot.validUntil}. You must re-assess annually or if your financial situation changes significantly.',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendedProduct extends StatelessWidget {
  const _RecommendedProduct({required this.product, required this.color});

  final String product;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(child: Text(product, style: AppTextStyles.baseMedium)),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

Color _profileColor(StakingSuitabilityProfileLevel level) {
  return switch (level) {
    StakingSuitabilityProfileLevel.conservative => AppColors.buy,
    StakingSuitabilityProfileLevel.moderate => AppColors.primarySoft,
    StakingSuitabilityProfileLevel.aggressive => AppColors.warn,
  };
}
