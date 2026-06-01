part of '../pages/dca_portfolio_optimizer_page.dart';

class _ComparisonHero extends StatelessWidget {
  const _ComparisonHero({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Comparison',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Hiện tại vs Tối ưu',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              _ScoreBadge(score: snapshot.score),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _MetricStrip(snapshot: snapshot),
          const SizedBox(height: AppSpacing.x5),
          for (final allocation in snapshot.currentAllocations) ...[
            _AllocationRow(allocation: allocation),
            if (allocation != snapshot.currentAllocations.last)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: AppColors.portfolioBtnGhostBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Score',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            '$score',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.buy,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            '/100',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip({required this.snapshot});

  final DcaPortfolioOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        label: 'Sharpe tối ưu',
        value: snapshot.optimalSharpe.toStringAsFixed(2),
        color: AppColors.accent,
      ),
      (
        label: 'Return/năm',
        value: '+${snapshot.optimalReturnPercent.toStringAsFixed(0)}%',
        color: AppColors.buy,
      ),
      (
        label: 'Drift hiện tại',
        value: '${snapshot.driftPercent.toStringAsFixed(1)}%',
        color: AppColors.sell,
      ),
    ];

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          for (final metric in metrics) ...[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x4,
                ),
                child: Column(
                  children: [
                    Text(
                      metric.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      metric.value,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: metric.color,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (metric != metrics.last)
              Container(
                width: 1,
                height: AppSpacing.x7,
                color: AppColors.border,
              ),
          ],
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.allocation});

  final DcaPortfolioAllocation allocation;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(allocation.accent);
    final diff = allocation.diffPercent;
    final maxPercent = math.max(
      1.0,
      math.max(allocation.currentPercent, allocation.optimalPercent),
    );

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x3,
                height: AppSpacing.x3,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  allocation.symbol,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallPill(
                label: '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(0)}%',
                color: diff > 0
                    ? AppColors.buy
                    : diff < 0
                    ? AppColors.sell
                    : AppColors.text3,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _PercentBar(
            label: 'Hiện tại',
            value: allocation.currentPercent,
            maxValue: maxPercent,
            color: accent.withValues(alpha: .65),
            valueColor: AppColors.portfolioTextDim,
          ),
          const SizedBox(height: AppSpacing.x2),
          _PercentBar(
            label: 'Tối ưu',
            value: allocation.optimalPercent,
            maxValue: maxPercent,
            color: accent,
            valueColor: AppColors.text1,
          ),
        ],
      ),
    );
  }
}

class _PercentBar extends StatelessWidget {
  const _PercentBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.valueColor,
  });

  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.x7,
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.inputRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: value / maxValue,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        SizedBox(
          width: AppSpacing.x6,
          child: Text(
            '${value.toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
