part of '../pages/bot_suitability_assessment_page.dart';

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
        const SizedBox(height: AppSpacing.tradeBotRowGap),
        Center(
          child: CircleAvatar(
            radius: AppSpacing.tradeBotResultIconBox / 2,
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(
              _iconForResult(result.outcome),
              color: color,
              size: AppSpacing.tradeBotResultIcon,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotCheckbox),
        Text(
          result.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            height: AppSpacing.tradeBotSuitabilityResultTitleLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        Text(
          result.message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            height: AppSpacing.tradeBotLineHeightLong,
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotCheckbox),
        _ScoreCard(
          score: score,
          maxScore: maxScore,
          percent: percent,
          color: color,
        ),
        const SizedBox(height: AppSpacing.x5),
        _SectionLabel('Category Breakdown'),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _CategoryBreakdown(snapshot: snapshot, answers: answers),
        const SizedBox(height: AppSpacing.x5),
        _SectionLabel('Recommendations'),
        const SizedBox(height: AppSpacing.tradeBotCardGap),
        _RecommendationsCard(result: result, color: color),
        const SizedBox(height: AppSpacing.tradeBotContentGap),
        _RegulatoryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.tradeBotSelectionDot),
        VitCtaButton(
          key: BotSuitabilityAssessmentPage.resultCtaKey,
          onPressed: () => onComplete(result),
          height: AppSpacing.tradeBotSheetActionHeight,
          variant: result.outcome == TradeBotSuitabilityOutcome.fail
              ? VitCtaButtonVariant.danger
              : VitCtaButtonVariant.success,
          child: Text(
            result.ctaLabel,
            style: AppTextStyles.body.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightTight,
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
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
              ),
              Text(
                '$score / $maxScore',
                style: AppTextStyles.baseMedium.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.tradeBotLineHeightTight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.tradeBotPageTopGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: percent,
              minHeight: AppSpacing.tradeBotScoreProgressHeight,
              backgroundColor: _assessmentPanel2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: AppSpacing.tradeBotSmallGap),
          Text(
            '${(percent * 100).toStringAsFixed(0)}% proficiency',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: AppSpacing.tradeBotLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}
