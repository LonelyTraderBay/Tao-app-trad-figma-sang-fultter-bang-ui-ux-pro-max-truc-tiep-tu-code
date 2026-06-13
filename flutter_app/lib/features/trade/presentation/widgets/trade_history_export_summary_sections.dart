part of '../pages/trade_history_export_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.stats});

  final TradeExportStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Tổng lệnh',
                    value: _formatInteger(stats.totalTrades),
                  ),
                ),
                Expanded(
                  child: _SummaryMetric(
                    label: 'Tổng KL giao dịch',
                    value: _formatCompact(stats.totalVolume),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Tổng phí',
                    value: _formatMoney(stats.totalFees),
                    color: AppColors.primarySoft,
                    small: true,
                  ),
                ),
                Expanded(
                  child: _SummaryMetric(
                    label: 'Lãi/Lỗ ròng',
                    value: '+${_formatMoney(stats.netPnl)}',
                    color: AppColors.buy,
                    small: true,
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

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.small = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (small ? AppTextStyles.body : AppTextStyles.baseMedium)
              .copyWith(
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 14,
              decoration: BoxDecoration(
                color: _tradePrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTextStyles.captionSm.copyWith(
                color: AppColors.textMutedLight,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
