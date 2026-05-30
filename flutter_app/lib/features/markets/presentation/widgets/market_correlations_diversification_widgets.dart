part of '../pages/market_correlations_page.dart';

class _DiversificationHero extends StatelessWidget {
  const _DiversificationHero({required this.score});

  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score.score);
    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chỉ số đa dạng hóa',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${score.score}',
                style: AppTextStyles.heroNumber.copyWith(color: color),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ 100',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SmallPill(label: score.label, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: score.score / 100,
                backgroundColor: AppColors.surface2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kém',
                style: AppTextStyles.micro.copyWith(color: AppColors.sell),
              ),
              Text(
                'TB',
                style: AppTextStyles.micro.copyWith(color: AppColors.warn),
              ),
              Text(
                'Tốt',
                style: AppTextStyles.micro.copyWith(color: AppColors.buy),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _DiversificationMetrics extends StatelessWidget {
  const _DiversificationMetrics({required this.score});

  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tương quan TB',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 5),
                Text(
                  score.avgCorrelation.toStringAsFixed(2),
                  style: AppTextStyles.base.copyWith(
                    color: score.avgCorrelation > .7
                        ? AppColors.sell
                        : AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cặp ít tương quan nhất',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 5),
                Text(
                  score.lowestCorr.pair,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  score.lowestCorr.value.toStringAsFixed(2),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeframeScoreCard extends StatelessWidget {
  const _TimeframeScoreCard({required this.repo});

  final MarketRepository repo;

  @override
  Widget build(BuildContext context) {
    const timeframes = [
      MarketCorrelationTimeframe.d7,
      MarketCorrelationTimeframe.d30,
      MarketCorrelationTimeframe.d90,
    ];
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final timeframe in timeframes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TimeframeScoreRow(
                label: _timeframeLabel(timeframe),
                score: repo
                    .getMarketCorrelations(timeframe: timeframe)
                    .diversificationScore,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeframeScoreRow extends StatelessWidget {
  const _TimeframeScoreRow({required this.label, required this.score});

  final String label;
  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score.score);
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: score.score / 100,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 30,
          child: Text(
            '${score.score}',
            textAlign: TextAlign.right,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _CorrelationDisclaimer extends StatelessWidget {
  const _CorrelationDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 12,
            color: AppColors.warn,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tương quan quá khứ không đảm bảo tương lai. Trong giai đoạn biến động mạnh, tương quan giữa crypto thường tăng cao (risk-on/risk-off). Chỉ mang tính tham khảo.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

double _correlationValueFor(
  CorrelationPairDraft pair,
  MarketCorrelationTimeframe timeframe,
) {
  return switch (timeframe) {
    MarketCorrelationTimeframe.d7 => pair.correlation7d,
    MarketCorrelationTimeframe.d30 => pair.correlation30d,
    MarketCorrelationTimeframe.d90 => pair.correlation90d,
  };
}

Color _correlationColor(double value) {
  if (value >= .85) return AppDataVizColors.correlationVeryHigh;
  if (value >= .70) return AppColors.sell;
  if (value >= .50) return AppColors.warn;
  if (value >= .30) return AppColors.buy;
  if (value >= .0) return AppDataVizColors.correlationVeryLow;
  return _marketPrimary;
}

String _correlationLabel(double value) {
  if (value >= .85) return 'Rất cao';
  if (value >= .70) return 'Cao';
  if (value >= .50) return 'Trung bình';
  if (value >= .30) return 'Thấp';
  return 'Rất thấp';
}

String _timeframeLabel(MarketCorrelationTimeframe timeframe) {
  return switch (timeframe) {
    MarketCorrelationTimeframe.d7 => '7d',
    MarketCorrelationTimeframe.d30 => '30d',
    MarketCorrelationTimeframe.d90 => '90d',
  };
}

Color _scoreColor(int score) {
  if (score >= 50) return AppColors.buy;
  if (score >= 30) return AppColors.warn;
  return AppColors.sell;
}
