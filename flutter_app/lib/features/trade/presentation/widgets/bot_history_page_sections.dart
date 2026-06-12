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
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(color: color, height: 1),
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
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      borderColor: AppColors.borderSolid,
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.text3, size: 19),
          const SizedBox(width: 11),
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

    return Row(
      children: [
        for (final tab in tabs) ...[
          Expanded(
            child: _FilterPill(
              key: BotHistoryPage.filterKey(tab.$1.name),
              label: tab.$2,
              active: tab.$1 == filter,
              onTap: () => onChanged(tab.$1),
            ),
          ),
          if (tab != tabs.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _historyPrimary.withValues(alpha: .12)
              : _historyPanel2,
          border: active
              ? Border.all(color: _historyPrimary.withValues(alpha: .55))
              : null,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _historyPrimary : AppColors.text3,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}
