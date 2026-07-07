part of '../pages/staking_risk_assessment_page.dart';

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
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: SizedBox(
            height: AppSpacing.pageRhythmCompactInnerGap,
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
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
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
                    height: AppTextStyles.baseMedium.height,
                  ),
                ),
              ),
            ],
          ),
          if (question.helpText != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              question.helpText!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: AppTextStyles.caption.height,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
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
              const SizedBox(height: AppSpacing.rowGap),
          ],
          if (index > 0) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
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
      decoration: const ShapeDecoration(
        color: AppColors.primary12,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.primary30),
          borderRadius: AppRadii.xlRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
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
      child: VitCard(
        variant: VitCardVariant.inner,
        radius: VitCardRadius.large,
        borderColor: selected ? AppColors.primary : AppColors.borderSolid,
        padding: EarnSpacingTokens.earnCardPaddingX3,
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: AppTextStyles.caption.copyWith(
                      color: selected ? AppColors.primary : AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height: AppTextStyles.caption.height,
                    ),
                  ),
                  if (option.description != null) ...[
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      option.description!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: AppTextStyles.micro.height,
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
      padding: EarnSpacingTokens.earnCardPaddingX3,
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
                height: AppTextStyles.micro.height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
