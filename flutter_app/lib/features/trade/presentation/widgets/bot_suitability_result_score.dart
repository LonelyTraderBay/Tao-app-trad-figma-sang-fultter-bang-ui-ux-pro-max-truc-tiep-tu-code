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
        VitCtaButton(
          key: BotSuitabilityAssessmentPage.resultCtaKey,
          onPressed: () => onComplete(result),
          height: 44,
          variant: result.outcome == TradeBotSuitabilityOutcome.fail
              ? VitCtaButtonVariant.danger
              : VitCtaButtonVariant.success,
          child: Text(
            result.ctaLabel,
            style: AppTextStyles.body.copyWith(
              color: AppColors.onAccent,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
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
