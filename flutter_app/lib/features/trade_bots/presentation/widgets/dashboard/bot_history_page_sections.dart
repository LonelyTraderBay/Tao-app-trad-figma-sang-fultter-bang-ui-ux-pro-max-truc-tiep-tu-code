part of '../../pages/dashboard/bot_history_page.dart';

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.totalTrades,
    required this.totalPnL,
    required this.totalFees,
  });

  final int totalTrades;
  final double totalPnL;
  final double totalFees;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: VitDensity.compact.cardPadding,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              label: 'Total Trades',
              value: '$totalTrades',
              color: AppColors.text1,
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: 'Total PnL',
              value:
                  '${totalPnL >= 0 ? '+' : ''}${totalPnL.toStringAsFixed(2)}',
              color: totalPnL >= 0 ? _historyGreen : _historyRed,
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: 'Total Fees',
              value: totalFees.toStringAsFixed(2),
              color: AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
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
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(value, style: AppTextStyles.sectionTitle.copyWith(color: color)),
      ],
    );
  }
}
