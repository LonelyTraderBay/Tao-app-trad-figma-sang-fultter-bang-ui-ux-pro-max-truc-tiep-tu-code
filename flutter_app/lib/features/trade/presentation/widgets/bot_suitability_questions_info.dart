part of '../pages/bot_suitability_assessment_page.dart';

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
        const SizedBox(height: AppSpacing.tradeBotControlCompact),
        _QuestionHeader(question: question),
        const SizedBox(height: AppSpacing.x7),
        for (final option in question.options) ...[
          _OptionCard(
            questionId: question.id,
            option: option,
            selected: selected == option.id,
            onTap: () => onAnswer(option.id),
          ),
          if (option != question.options.last)
            const SizedBox(height: AppSpacing.tradeBotPageTopGap),
        ],
        const SizedBox(height: AppSpacing.tradeBotControlCompact),
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
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% Complete',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: AppSpacing.tradeBotLineHeightTight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: SizedBox(
            height: AppSpacing.tradeBotProgressHeight,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppSpacing.tradeBotProgressHeight,
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
        VitCard(
          width: AppSpacing.tradeBotQuestionIconBox,
          height: AppSpacing.tradeBotQuestionIconBox,
          alignment: Alignment.center,
          variant: VitCardVariant.inner,
          borderColor: _assessmentPrimary.withValues(alpha: .22),
          child: const Icon(
            Icons.assignment_turned_in_outlined,
            color: _assessmentPrimary,
            size: AppSpacing.tradeBotQuestionIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.tradeBotCardIconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.category.name.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
              const SizedBox(height: AppSpacing.tradeBotRowGap),
              Text(
                question.question,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  height: AppSpacing.tradeBotLineHeightLoose,
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
    return VitCard(
      key: BotSuitabilityAssessmentPage.optionKey(questionId, option.id),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.tradeBotOptionMinHeight,
      ),
      padding: AppSpacing.tradeBotOptionPadding,
      borderColor: selected ? _assessmentPrimary : _assessmentOptionBorder,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? _assessmentPrimary : _assessmentOptionBorder,
            size: AppSpacing.tradeBotQuestionIcon,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Text(
              option.text,
              style: AppTextStyles.caption.copyWith(
                color: selected ? _assessmentPrimary : AppColors.text1,
                fontWeight: AppTextStyles.medium,
                height: AppSpacing.tradeBotLineHeightLoose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.snapshot});

  final TradeBotSuitabilityAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      key: BotSuitabilityAssessmentPage.infoKey,
      state: VitHighRiskUiState.riskReview,
      title: snapshot.infoTitle,
      message: snapshot.infoDescription,
    );
  }
}
