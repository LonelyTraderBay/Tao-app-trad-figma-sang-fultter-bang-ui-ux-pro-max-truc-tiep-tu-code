part of '../pages/bot_suitability_assessment_page.dart';

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
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      variant: VitCardVariant.inner,
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
    return VitCard(
      padding: padding,
      borderColor: AppColors.cardBorder,
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
