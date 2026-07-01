part of '../pages/copy_trading_page.dart';

class _CopyHeroCard extends StatelessWidget {
  const _CopyHeroCard({required this.snapshot});

  final TradeCopyTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            density: VitDensity.compact,
            padding: AppSpacing.cardPaddingCompact,
            borderColor: AppColors.cardBorder,
            child: Column(
              children: [
                Text(
                  'ASSET UNDER MANAGEMENT',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _copySpace),
                Text(
                  _formatCompact(snapshot.totalAum, prefix: r'$'),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heroNumber,
                ),
                const SizedBox(height: _copySpace),
                _TrendPill(value: snapshot.aumTrendPct),
              ],
            ),
          ),
          const SizedBox(height: _copyCardSpace),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  icon: Icons.groups_rounded,
                  label: 'TRADERS',
                  value: '${snapshot.traders.length}',
                  color: _copyPrimary,
                ),
              ),
              const SizedBox(width: _copySpace),
              Expanded(
                child: _HeroMetric(
                  icon: Icons.how_to_reg_rounded,
                  label: 'COPIERS',
                  value: _formatCompactNumber(snapshot.totalCopiers),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: _copySpace),
          Text(
            'Updated ${snapshot.lastUpdatedLabel}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3.withValues(alpha: .70),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.copyTradingMetricIcon),
              const SizedBox(width: _copySpace),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _copySpace),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPill extends StatelessWidget {
  const _TrendPill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    return Align(
      alignment: Alignment.center,
      child: VitMetricDeltaPill(
        label: '${value.abs().toStringAsFixed(1)}% vs last month',
        tone: positive
            ? VitMetricDeltaTone.positive
            : VitMetricDeltaTone.negative,
        icon: positive
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded,
      ),
    );
  }
}

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: title,
      message: message,
      contractId: 'Copy trading provider risk disclosure',
      density: VitDensity.compact,
    );
  }
}
