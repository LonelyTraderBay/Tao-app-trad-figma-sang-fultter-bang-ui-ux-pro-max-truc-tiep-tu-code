part of 'portfolio_tracker_page.dart';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TopHoldings extends StatelessWidget {
  const _TopHoldings({
    required this.holdings,
    required this.hidden,
    required this.onTap,
  });

  final List<PortfolioHolding> holdings;
  final bool hidden;
  final ValueChanged<PortfolioHolding> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final holding in holdings) ...[
          _HoldingRow(
            key: PortfolioTrackerPage.holdingKey(holding.id),
            holding: holding,
            hidden: hidden,
            onTap: () => onTap(holding),
          ),
          if (holding != holdings.last) const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _HoldingRow extends StatelessWidget {
  const _HoldingRow({
    super.key,
    required this.holding,
    required this.hidden,
    required this.onTap,
  });

  final PortfolioHolding holding;
  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pnlColor = holding.pnlPct >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _TokenBadge(holding: holding, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${_mask(holding.quantity.toStringAsFixed(4), hidden)} - ${holding.allocation.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 54,
            height: 22,
            child: CustomPaint(
              painter: _SparklinePainter(
                values: holding.sparkline,
                color: holding.change24h >= 0 ? AppColors.buy : AppColors.sell,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 86,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _mask(_formatUsd(holding.value), hidden),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  _formatSignedPercent(holding.pnlPct),
                  style: AppTextStyles.micro.copyWith(
                    color: pnlColor,
                    fontWeight: AppTextStyles.bold,
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

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.stats});

  final PortfolioStats stats;

  @override
  Widget build(BuildContext context) {
    final balanced = stats.stableAllocation > 20;
    final color = balanced ? AppColors.buy : AppColors.warn;
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đánh giá rủi ro',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: AppRadii.smRadius,
                ),
                child: Text(
                  balanced ? 'Cân bằng' : 'Rủi ro cao',
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Stablecoin',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${stats.stableAllocation.toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 5,
              child: Stack(
                children: [
                  Container(color: AppColors.surface2),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: stats.stableAllocation / 100,
                    child: Container(color: AppColors.buy),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Danh mục có ${stats.stableAllocation.toStringAsFixed(1)}% stablecoin, giúp giảm biến động. Khuyến nghị duy trì ít nhất 10-20% stablecoin cho quản lý rủi ro.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({required this.active, required this.onSelected});

  final MarketPortfolioSort active;
  final ValueChanged<MarketPortfolioSort> onSelected;

  @override
  Widget build(BuildContext context) {
    const chips = {
      MarketPortfolioSort.value: 'Giá trị',
      MarketPortfolioSort.pnl: 'Lãi/Lỗ',
      MarketPortfolioSort.change: 'Thay đổi 24h',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in chips.entries) ...[
            _ChipButton(
              key: PortfolioTrackerPage.sortKey(entry.key),
              label: entry.value,
              active: active == entry.key,
              onTap: () => onSelected(entry.key),
            ),
            if (entry.key != chips.keys.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _TimeFilterChips extends StatelessWidget {
  const _TimeFilterChips({required this.active, required this.onSelected});

  final String active;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const filters = ['24h', '7d', '30d', 'Tất cả'];
    return Row(
      children: [
        for (final filter in filters) ...[
          _ChipButton(
            label: filter,
            active: active == filter,
            onTap: () => onSelected(filter),
          ),
          if (filter != filters.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .15)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? _marketPrimary.withValues(alpha: .35)
                : AppColors.transparent,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? _marketPrimary : AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _HoldingDetailCard extends StatelessWidget {
  const _HoldingDetailCard({
    super.key,
    required this.holding,
    required this.hidden,
    required this.onTap,
  });

  final PortfolioHolding holding;
  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _TokenBadge(holding: holding, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holding.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      holding.name,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _mask(_formatUsd(holding.value), hidden),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${holding.allocation.toStringAsFixed(1)}%',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _HoldingMetric(
                label: 'Số lượng',
                value: _mask(holding.quantity.toStringAsFixed(4), hidden),
              ),
              _HoldingMetric(
                label: 'Giá TB mua',
                value: '\$${_formatPrice(holding.avgBuyPrice)}',
              ),
              _HoldingMetric(
                label: 'Giá hiện tại',
                value: '\$${_formatPrice(holding.currentPrice)}',
              ),
              _HoldingMetric(
                label: 'Lãi/Lỗ',
                value: _mask(_formatSignedPercent(holding.pnlPct), hidden),
                color: holding.pnlPct >= 0 ? AppColors.buy : AppColors.sell,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HoldingMetric extends StatelessWidget {
  const _HoldingMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceChartCard extends StatelessWidget {
  const _PerformanceChartCard({required this.stats, required this.points});

  final PortfolioStats stats;
  final List<PortfolioPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giá trị danh mục',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                _formatSignedPercent(stats.totalPnlPct),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: CustomPaint(painter: _PerformancePainter(points: points)),
          ),
        ],
      ),
    );
  }
}
