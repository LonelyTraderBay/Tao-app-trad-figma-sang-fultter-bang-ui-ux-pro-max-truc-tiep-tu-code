part of 'active_copies_page.dart';

class _ReturnBar extends StatelessWidget {
  const _ReturnBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    final widthFactor = (value.abs() * .05).clamp(.0, 1.0).toDouble();

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      height: 41,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Return',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1,
                ),
              ),
              const Spacer(),
              Text(
                _formatPercent(value),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: widthFactor,
              backgroundColor: AppColors.borderSolid,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedCopyDetails extends StatelessWidget {
  const _ExpandedCopyDetails({
    required this.copy,
    required this.onViewDetails,
    required this.onConfigure,
    required this.onStop,
  });

  final TradeActiveCopy copy;
  final VoidCallback onViewDetails;
  final VoidCallback onConfigure;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Performance (30 ngày)',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontWeight: AppTextStyles.medium,
              ),
            ),
            const SizedBox(height: 8),
            _MiniPerformanceStrip(points: copy.performanceHistory),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DetailStat(
                    label: 'Số lượng trades',
                    value: '${copy.trades}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DetailStat(
                    label: 'Win rate',
                    value: '${copy.winRate.toStringAsFixed(1)}%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DetailStat(
                    label: 'Copy mode',
                    value: _copyModeLabel(copy),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DetailStat(
                    label: 'Stop-loss',
                    value: copy.hasCustomStopLoss
                        ? '-${copy.stopLossLevel?.toStringAsFixed(0)}%'
                        : 'Provider',
                  ),
                ),
              ],
            ),
            if (copy.recentTrades.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Trades gần đây',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    key: ActiveCopiesPage.detailsKey(copy.id),
                    onTap: onViewDetails,
                    child: Text(
                      'Xem tất cả',
                      style: AppTextStyles.micro.copyWith(
                        color: _copyPrimary,
                        fontSize: 11,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final trade in copy.recentTrades.take(3)) ...[
                _RecentTradeRow(trade: trade),
                if (trade != copy.recentTrades.take(3).last)
                  const SizedBox(height: 7),
              ],
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    key: ActiveCopiesPage.configureKey(copy.id),
                    label: 'Điều chỉnh',
                    icon: Icons.settings_rounded,
                    onTap: onConfigure,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ActionButton(
                    key: ActiveCopiesPage.stopKey(copy.id),
                    label: 'Dừng copy',
                    icon: Icons.stop_rounded,
                    danger: true,
                    onTap: onStop,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPerformanceStrip extends StatelessWidget {
  const _MiniPerformanceStrip({required this.points});

  final List<TradeCopyPerformancePoint> points;

  @override
  Widget build(BuildContext context) {
    final first = points.isEmpty ? 0.0 : points.first.value;
    final last = points.isEmpty ? 0.0 : points.last.value;
    final positive = last >= first;
    final color = positive ? AppColors.buy : AppColors.sell;

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      height: 54,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < points.length; i++) ...[
            Expanded(
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: _barHeight(points, i),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .72),
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
            ),
            if (i < points.length - 1) const SizedBox(width: 5),
          ],
        ],
      ),
    );
  }

  double _barHeight(List<TradeCopyPerformancePoint> points, int index) {
    if (points.isEmpty) return .2;
    final min = points
        .map((point) => point.value)
        .reduce((a, b) => a < b ? a : b);
    final max = points
        .map((point) => point.value)
        .reduce((a, b) => a > b ? a : b);
    final spread = max - min;
    if (spread <= 0) return .28;
    return (.24 + ((points[index].value - min) / spread) * .76)
        .clamp(.24, 1.0)
        .toDouble();
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTradeRow extends StatelessWidget {
  const _RecentTradeRow({required this.trade});

  final TradeCopyRecentTrade trade;

  @override
  Widget build(BuildContext context) {
    final sideColor = trade.side == TradeOrderSide.buy
        ? AppColors.buy
        : AppColors.sell;

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(9),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: sideColor,
              borderRadius: AppRadii.xsRadius,
            ),
            child: Text(
              trade.side == TradeOrderSide.buy ? 'BUY' : 'SELL',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.onAccent,
                fontSize: 9,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              trade.pair,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          Text(
            _formatSignedUsd(trade.pnl),
            style: AppTextStyles.micro.copyWith(
              color: trade.pnl >= 0 ? AppColors.buy : AppColors.sell,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: danger
          ? VitCtaButtonVariant.danger
          : VitCtaButtonVariant.secondary,
      height: 42,
      leading: Icon(icon),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(label),
    );
  }
}

class _EmptyCopiesState extends StatelessWidget {
  const _EmptyCopiesState({required this.history, required this.onExplore});

  final bool history;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      title: history ? 'Chưa có lịch sử copy' : 'Chưa có copy nào đang chạy',
      message: history
          ? 'Lịch sử copy sẽ hiển thị ở đây.'
          : 'Bắt đầu copy từ trader chuyên nghiệp để tự động hóa giao dịch của bạn.',
      icon: history ? Icons.history_rounded : Icons.groups_rounded,
      actionLabel: history ? null : 'Khám phá traders',
      onAction: history ? null : onExplore,
    );
  }
}
