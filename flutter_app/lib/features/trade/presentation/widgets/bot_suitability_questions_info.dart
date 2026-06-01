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
      color: AppColors.transparent,
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
