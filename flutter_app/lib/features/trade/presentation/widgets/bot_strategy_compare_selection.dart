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
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.36,
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
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? color : AppColors.borderSolid,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check_circle_outline, color: color, size: 14)
                    : null,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  strategy.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? color : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
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
            height: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
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
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.workspace_premium_outlined, color: color, size: 25),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Risk-Adjusted Returns',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: strategy.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text:
                            ' has the highest Sharpe ratio (${strategy.metrics.sharpeRatio.toStringAsFixed(2)}) among selected strategies, indicating superior risk-adjusted performance.',
                      ),
                    ],
                  ),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.6,
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
