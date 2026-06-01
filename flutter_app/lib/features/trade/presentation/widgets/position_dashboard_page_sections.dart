part of '../pages/position_dashboard_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.positions});

  final List<TradeDashboardPosition> positions;

  @override
  Widget build(BuildContext context) {
    final totalPnl = positions.fold<double>(0, (sum, item) => sum + item.pnl);
    final totalValue = positions.fold<double>(
      0,
      (sum, item) => sum + item.notional,
    );
    final totalMargin = positions.fold<double>(
      0,
      (sum, item) => sum + (item.margin ?? 0),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: Container(
        height: 72,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        decoration: BoxDecoration(
          color: _cardBackground,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: _SummaryMetric(
                label: 'Tổng P/L',
                value: _formatSignedMoney(totalPnl),
                color: totalPnl >= 0 ? AppColors.buy : AppColors.sell,
                large: true,
              ),
            ),
            Expanded(
              child: _SummaryMetric(
                label: 'Tổng giá trị',
                value: _formatCompactMoney(totalValue),
              ),
            ),
            Expanded(
              child: _SummaryMetric(
                label: 'Ký quỹ đang dùng',
                value: '\$${_formatMoney(totalMargin)}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.large = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool large;

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
            height: 1.1,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: large ? 18 : 13,
            fontFamily: 'monospace',
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TypeTabs extends StatelessWidget {
  const _TypeTabs({
    required this.active,
    required this.positions,
    required this.onChanged,
  });

  final String active;
  final List<TradeDashboardPosition> positions;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('all', 'Tất cả (${positions.length})'),
      ('spot', 'Spot (${_count(TradePositionType.spot)})'),
      ('futures', 'Futures (${_count(TradePositionType.futures)})'),
      ('margin', 'Margin (${_count(TradePositionType.margin)})'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: _PillButton(
                key: PositionDashboardPage.tabKey(tabs[i].$1),
                label: tabs[i].$2,
                active: active == tabs[i].$1,
                onTap: () => onChanged(tabs[i].$1),
              ),
            ),
            if (i < tabs.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  int _count(TradePositionType type) {
    return positions.where((position) => position.type == type).length;
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final sorts = const [
      ('pnl', 'P/L'),
      ('pnlPct', '%P/L'),
      ('size', 'Kích thước'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Text(
            'SẮP XẾP',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(width: 10),
          for (final sort in sorts) ...[
            _SortChip(
              key: PositionDashboardPage.sortKey(sort.$1),
              label: sort.$2,
              active: active == sort.$1,
              onTap: () => onChanged(sort.$1),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
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
      borderRadius: AppRadii.lgRadius,
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _tradePrimary.withValues(alpha: .16)
              : _chipBackground,
          border: Border.all(
            color: active ? _tradePrimary : AppColors.transparent,
          ),
          borderRadius: AppRadii.lgRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _tradePrimary : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
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
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _tradePrimary.withValues(alpha: .16)
              : _chipBackground,
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? _tradePrimary : AppColors.text3,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}
