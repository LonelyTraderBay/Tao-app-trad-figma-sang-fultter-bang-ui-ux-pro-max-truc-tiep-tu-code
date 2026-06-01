part of '../pages/copy_trading_page.dart';

class _CopyHeroCard extends StatelessWidget {
  const _CopyHeroCard({required this.snapshot});

  final TradeCopyTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _copyPanelTone,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: AppRadii.inputRadius,
            ),
            child: Column(
              children: [
                Text(
                  'ASSET UNDER MANAGEMENT',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _formatCompact(snapshot.totalAum, prefix: r'$'),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heroNumber.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 10),
                _TrendPill(value: snapshot.aumTrendPct),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
              const SizedBox(width: 10),
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
          const SizedBox(height: 12),
          Text(
            'Updated ${snapshot.lastUpdatedLabel}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3.withValues(alpha: .70),
              fontSize: 10,
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _copyPanelTone,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 24,
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
    final color = positive ? AppColors.buy : AppColors.sell;
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .08),
          border: Border.all(color: color.withValues(alpha: .18)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              positive
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: color,
              size: 13,
            ),
            const SizedBox(width: 4),
            Text(
              '${value.abs().toStringAsFixed(1)}%',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'vs last month',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
              ),
            ),
          ],
        ),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warningText,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warningText,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warningText.withValues(alpha: .90),
                    fontSize: 10,
                    height: 1.4,
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
