part of '../pages/bot_history_page.dart';

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
      padding: AppSpacing.tradeBotCardPaddingLoose,
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
        const SizedBox(height: AppSpacing.tradeBotRowGap),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(color: color),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      height: AppSpacing.tradeBotControlHeight,
      padding: AppSpacing.tradeBotChipPadding,
      borderColor: AppColors.borderSolid,
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.tradeBotRowGap),
          Expanded(
            child: Text(
              'Search by bot name or pair...',
              style: AppTextStyles.body.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.filter,
    required this.trades,
    required this.onChanged,
  });

  final _HistoryFilter filter;
  final List<TradeBotHistoryTrade> trades;
  final ValueChanged<_HistoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_HistoryFilter.all, 'All (${trades.length})'),
      (
        _HistoryFilter.buy,
        'Buy (${trades.where((t) => t.side == TradeBotHistorySide.buy).length})',
      ),
      (
        _HistoryFilter.sell,
        'Sell (${trades.where((t) => t.side == TradeBotHistorySide.sell).length})',
      ),
    ];

    return VitTabBar(
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.$1.name,
            label: tab.$2,
            widgetKey: BotHistoryPage.filterKey(tab.$1.name),
          ),
      ],
      activeKey: filter.name,
      onChanged: (key) => onChanged(
        _HistoryFilter.values.firstWhere((filter) => filter.name == key),
      ),
      variant: VitTabBarVariant.segment,
    );
  }
}
