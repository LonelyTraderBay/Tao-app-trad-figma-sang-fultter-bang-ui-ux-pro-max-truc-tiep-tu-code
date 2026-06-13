part of '../pages/copy_performance_page.dart';

class _TradesTab extends StatelessWidget {
  const _TradesTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoBox(
          title: 'So sánh từng giao dịch',
          lines: const ['Chênh lệch chủ yếu do slippage và execution delay.'],
        ),
        const SizedBox(height: 12),
        for (final trade in snapshot.tradeComparisons) ...[
          VitCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SidePill(side: trade.side),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trade.pair,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.extraBold,
                        ),
                      ),
                    ),
                    Text(
                      trade.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _TradeColumn(
                        title: 'Provider',
                        color: _performancePurple,
                        entry: trade.providerEntry,
                        exit: trade.providerExit,
                        pnl: trade.providerPnl,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _TradeColumn(
                        title: 'Bạn',
                        color: _performancePrimary,
                        entry: trade.yourEntry,
                        exit: trade.yourExit,
                        pnl: trade.yourPnl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _InlineInfo(
                        icon: Icons.schedule_rounded,
                        label: 'Delay: ${trade.delay}',
                      ),
                    ),
                    Expanded(
                      child: _InlineInfo(
                        icon: Icons.show_chart_rounded,
                        label: 'Slippage: ${trade.slippagePct}%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CostsTab extends StatelessWidget {
  const _CostsTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in snapshot.costAttribution)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: VitCard(
              variant: VitCardVariant.inner,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Color(item.colorHex),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '\$${item.value.toStringAsFixed(0)}',
                    style: AppTextStyles.baseMedium.copyWith(
                      fontWeight: AppTextStyles.extraBold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Divider(color: AppColors.divider, height: 22),
        _SmallMetricCard(
          label: 'Tổng chi phí',
          value: '\$${snapshot.totalCosts.toStringAsFixed(0)}',
          valueColor: _performanceRed,
        ),
      ],
    );
  }
}

class _MetricsTab extends StatelessWidget {
  const _MetricsTab({required this.snapshot});

  final TradeCopyPerformanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final metric in snapshot.metrics)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: VitCard(
              variant: VitCardVariant.inner,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.name,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _SmallMetricCard(
                          label: 'Bạn',
                          value:
                              '${metric.you.toStringAsFixed(2)}${metric.suffix}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SmallMetricCard(
                          label: 'Provider',
                          value:
                              '${metric.provider.toStringAsFixed(2)}${metric.suffix}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: const EdgeInsets.all(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text3,
                size: 13,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $line',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.25,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SmallMetricCard extends StatelessWidget {
  const _SmallMetricCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.extraBold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
