part of 'market_data_analytics_page.dart';

class _MetricBubble extends StatelessWidget {
  const _MetricBubble({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.bg = _analyticsPanel2,
  });

  final String label;
  final String value;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 57),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.cardRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({
    required this.text,
    this.bg = _analyticsSurface3,
    this.iconColor = _analyticsPrimary,
  });

  final String text;
  final Color bg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.cardRadius),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: iconColor, size: 14),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 10,
                height: 1.42,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleBar extends StatelessWidget {
  const _ToggleBar({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _analyticsPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _analyticsPrimary,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Text(
                left,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                right,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                  fontWeight: AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PctLabel extends StatelessWidget {
  const _PctLabel({
    required this.label,
    required this.color,
    required this.icon,
    this.iconAfter = false,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool iconAfter;

  @override
  Widget build(BuildContext context) {
    final children = [
      Icon(icon, color: color, size: 15),
      const SizedBox(width: 4),
      Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconAfter ? children.reversed.toList() : children,
    );
  }
}

class _RatioBar extends StatelessWidget {
  const _RatioBar({required this.longPct});

  final double longPct;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 12,
        child: Row(
          children: [
            Expanded(
              flex: (longPct * 10).round(),
              child: const ColoredBox(color: _analyticsGreen),
            ),
            Expanded(
              flex: ((100 - longPct) * 10).round(),
              child: const ColoredBox(color: _analyticsRed),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _HeatmapRow extends StatelessWidget {
  const _HeatmapRow({required this.cluster});

  final TradeLiquidationCluster cluster;

  @override
  Widget build(BuildContext context) {
    final isCurrent = cluster.intensity == 0;
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            '\$${cluster.price.toStringAsFixed(0)}',
            style: AppTextStyles.caption.copyWith(
              color: isCurrent ? _analyticsPrimary : AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 18,
              color: _analyticsPanel2,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: math.max(cluster.intensity / 100, .02),
                child: ColoredBox(
                  color:
                      (cluster.shortLiquidations >= cluster.longLiquidations
                              ? _analyticsRed
                              : _analyticsGreen)
                          .withValues(alpha: isCurrent ? .18 : .78),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 58,
          child: Text(
            isCurrent ? 'Mark' : _formatCompactUsd(cluster.total),
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: isCurrent ? _analyticsPrimary : AppColors.text3,
              fontSize: 10,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _LiquidationRow extends StatelessWidget {
  const _LiquidationRow({required this.liquidation});

  final TradeRecentLiquidation liquidation;

  @override
  Widget build(BuildContext context) {
    final isLong = liquidation.side == 'long';
    final color = isLong ? _analyticsGreen : _analyticsRed;
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _analyticsPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          _SmallBadge(label: liquidation.side.toUpperCase(), color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${liquidation.pair} @ \$${_formatMoney(liquidation.price)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            _formatCompactUsd(liquidation.size),
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SentimentComponentRow extends StatelessWidget {
  const _SentimentComponentRow({required this.component});

  final TradeSentimentComponent component;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _analyticsPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  component.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallBadge(label: component.weight, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            component.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImplicationRow extends StatelessWidget {
  const _ImplicationRow({required this.implication});

  final TradeSentimentImplication implication;

  @override
  Widget build(BuildContext context) {
    final color = Color(implication.colorHex);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _analyticsPanel2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  implication.condition,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  implication.action,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1.4,
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
