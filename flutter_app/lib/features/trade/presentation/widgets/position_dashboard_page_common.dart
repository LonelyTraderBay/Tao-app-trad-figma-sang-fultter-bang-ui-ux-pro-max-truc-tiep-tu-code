part of '../pages/position_dashboard_page.dart';

class _PositionTile extends StatelessWidget {
  const _PositionTile({required this.position});

  final TradeDashboardPosition position;

  @override
  Widget build(BuildContext context) {
    final isProfit = position.pnl >= 0;
    final pnlColor = isProfit ? AppColors.buy : AppColors.sell;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 19),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _TypeBadge(type: position.type),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  position.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SideBadge(position: position),
              const SizedBox(width: 8),
              Text(
                _formatSignedMoney(position.pnl),
                style: AppTextStyles.amountSm.copyWith(
                  color: pnlColor,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _PositionMetric(
                  label: 'KL',
                  value: _formatAmount(position.size),
                ),
              ),
              Expanded(
                child: _PositionMetric(
                  label: 'Giá vào',
                  value: _formatMoney(position.entryPrice),
                ),
              ),
              Expanded(
                child: _PositionMetric(
                  label: 'Giá hiện tại',
                  value: _formatMoney(position.currentPrice),
                ),
              ),
              Expanded(
                child: _PositionMetric(
                  label: '%P/L',
                  value: _formatSignedPct(position.pnlPct),
                  valueColor: pnlColor,
                  alignRight: true,
                ),
              ),
            ],
          ),
          if (position.takeProfit != null || position.stopLoss != null) ...[
            const SizedBox(height: 11),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (position.takeProfit != null)
                  _RiskChip(
                    icon: Icons.my_location_rounded,
                    label: 'TP ${_formatMoney(position.takeProfit!)}',
                    color: AppColors.buy,
                  ),
                if (position.stopLoss != null)
                  _RiskChip(
                    icon: Icons.shield_outlined,
                    label: 'SL ${_formatMoney(position.stopLoss!)}',
                    color: AppColors.sell,
                  ),
                if (position.liquidPrice != null)
                  _RiskChip(
                    icon: Icons.warning_amber_rounded,
                    label: 'Liq ${_formatMoney(position.liquidPrice!)}',
                    color: AppColors.warn,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final TradePositionType type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      TradePositionType.spot => _tradePrimary,
      TradePositionType.futures => _futuresColor,
      TradePositionType.margin => _marginColor,
    };
    final label = switch (type) {
      TradePositionType.spot => 'Spot',
      TradePositionType.futures => 'Futures',
      TradePositionType.margin => 'Margin',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(label, style: AppTextStyles.badge.copyWith(color: color)),
    );
  }
}

class _SideBadge extends StatelessWidget {
  const _SideBadge({required this.position});

  final TradeDashboardPosition position;

  @override
  Widget build(BuildContext context) {
    final isLong = position.side == TradePositionSide.long;
    final color = isLong ? AppColors.buy : AppColors.sell;
    final leverage = position.leverage == null ? '' : ' ${position.leverage}x';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        '${isLong ? 'LONG' : 'SHORT'}$leverage',
        style: AppTextStyles.badge.copyWith(color: color),
      ),
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.alignRight = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.numericCode.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

class _RiskChip extends StatelessWidget {
  const _RiskChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.micro.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _EmptyPositions extends StatelessWidget {
  const _EmptyPositions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.borderSolid,
            size: 44,
          ),
          const SizedBox(height: 12),
          Text(
            'Không có vị thế nào',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

String _formatSignedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatMoney(value.abs())}';
}

String _formatSignedPct(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${value.abs().toStringAsFixed(2)}%';
}

String _formatCompactMoney(double value) {
  if (value.abs() >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(1)}K';
  }
  return '\$${_formatMoney(value)}';
}

String _formatMoney(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}

String _formatAmount(double value) {
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}
