part of '../pages/bot_strategy_compare_page.dart';

class _StrategySelectionGrid extends StatelessWidget {
  const _StrategySelectionGrid({
    required this.strategies,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<TradeBotCompareStrategy> strategies;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: AppSpacing.tradeBotGridColumns,
      crossAxisSpacing: AppSpacing.tradeBotRowGap,
      mainAxisSpacing: AppSpacing.tradeBotRowGap,
      childAspectRatio: AppSpacing.tradeBotStrategyGridAspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        for (final strategy in strategies)
          _StrategyCard(
            key: BotStrategyComparePage.strategyKey(strategy.id),
            strategy: strategy,
            selected: selectedIds.contains(strategy.id),
            onTap: () => onToggle(strategy.id),
          ),
      ],
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    super.key,
    required this.strategy,
    required this.selected,
    required this.onTap,
  });

  final TradeBotCompareStrategy strategy;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return VitCard(
      onTap: onTap,
      borderColor: selected ? color : AppColors.borderSolid,
      padding: AppSpacing.tradeBotStrategyCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                selected
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? color : AppColors.borderSolid,
                size: AppSpacing.tradeBotActionIcon,
              ),
              const SizedBox(width: AppSpacing.tradeBotDisclosureGap),
              Expanded(
                child: Text(
                  strategy.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? color : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Return',
                  value: '+${strategy.metrics.totalReturn.toStringAsFixed(1)}%',
                  color: _compareGreen,
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Sharpe',
                  value: strategy.metrics.sharpeRatio.toStringAsFixed(2),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppSpacing.tradeBotLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.tradeBotMetricGap),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.tradeBotLineHeightTight,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _BestStrategyCard extends StatelessWidget {
  const _BestStrategyCard({required this.strategy});

  final TradeBotCompareStrategy strategy;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .30),
      padding: AppSpacing.tradeBotCardPaddingLoose,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            color: color,
            size: AppSpacing.tradeBotHeroIcon,
          ),
          const SizedBox(width: AppSpacing.tradeBotStatusGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Risk-Adjusted Returns',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: color,
                    height: AppSpacing.tradeBotLineHeightTight,
                  ),
                ),
                const SizedBox(height: AppSpacing.tradeBotRowGap),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: strategy.name,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' has the highest Sharpe ratio (${strategy.metrics.sharpeRatio.toStringAsFixed(2)}) among selected strategies, indicating superior risk-adjusted performance.',
                      ),
                    ],
                  ),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppSpacing.tradeBotLineHeightLong,
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
