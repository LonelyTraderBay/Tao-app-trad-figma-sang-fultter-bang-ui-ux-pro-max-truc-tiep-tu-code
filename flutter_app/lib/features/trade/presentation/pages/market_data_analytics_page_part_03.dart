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
    return VitCard(
      constraints: const BoxConstraints(minHeight: 57),
      padding: AppSpacing.tradeBotCompactCardPadding,
      variant: VitCardVariant.inner,
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
              height: AppSpacing.tradeBotLineHeightShort,
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppSpacing.tradeBotLineHeightTight,
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
    final status = color == _analyticsGreen
        ? VitStatusPillStatus.success
        : color == _analyticsRed
        ? VitStatusPillStatus.error
        : color == _analyticsAmber
        ? VitStatusPillStatus.warning
        : VitStatusPillStatus.info;
    return VitStatusPill(
      label: label,
      status: status,
      size: VitStatusPillSize.sm,
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
    return VitCard(
      padding: AppSpacing.tradeReceiptNoticePadding,
      variant: VitCardVariant.inner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: iconColor, size: 14),
          const SizedBox(width: AppSpacing.tradeReceiptTotalGap),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: AppSpacing.tradeBotLineHeightMedium,
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
    return VitCard(
      height: AppSpacing.tradeBotControlCompact - AppSpacing.hairlineStroke,
      padding: AppSpacing.tradeBotCompactPanelPadding,
      variant: VitCardVariant.inner,
      child: Row(
        children: [
          Expanded(
            child: VitStatusPill(
              label: left,
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.lg,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                right,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.medium,
                  height: AppSpacing.tradeBotLineHeightTight,
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
      const SizedBox(width: AppSpacing.hairlineStroke * 2),
      Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: AppSpacing.tradeBotLineHeightTight,
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
      borderRadius: AppRadii.pillRadius,
      child: SizedBox(
        height: AppSpacing.x4 - AppSpacing.x1,
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
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
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
          width:
              AppSpacing.tradeBotRiskRingInnerSize -
              AppSpacing.tradeBotCheckboxIcon,
          child: Text(
            '\$${cluster.price.toStringAsFixed(0)}',
            style: AppTextStyles.caption.copyWith(
              color: isCurrent ? _analyticsPrimary : AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: SizedBox(
              height: AppSpacing.ctaLoadingIcon,
              child: ColoredBox(
                color: _analyticsPanel2,
                child: Align(
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
          ),
        ),
        SizedBox(
          width: AppSpacing.x7 + AppSpacing.x2 - AppSpacing.hairlineStroke,
          child: Text(
            isCurrent ? 'Mark' : _formatCompactUsd(cluster.total),
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: isCurrent ? _analyticsPrimary : AppColors.text3,
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
    return VitCard(
      padding: AppSpacing.tradeBotCompactCardPadding,
      variant: VitCardVariant.inner,
      child: Row(
        children: [
          _SmallBadge(label: liquidation.side.toUpperCase(), color: color),
          const SizedBox(width: AppSpacing.x3 + AppSpacing.hairlineStroke),
          Expanded(
            child: Text(
              '${liquidation.pair} @ \$${_formatMoney(liquidation.price)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            _formatCompactUsd(liquidation.size),
            style: AppTextStyles.caption.copyWith(
              color: color,
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
    return VitCard(
      padding: AppSpacing.tradeBotAttributionPanelPadding,
      variant: VitCardVariant.inner,
      child: VitPageContent(
        padding: VitContentPadding.none,
        customGap: AppSpacing.tradeBotNarrowIconGap,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  component.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallBadge(label: component.weight, color: AppColors.primary),
            ],
          ),
          Text(
            component.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
    return VitCard(
      padding: AppSpacing.tradeBotAttributionPanelPadding,
      variant: VitCardVariant.inner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.x1 + AppSpacing.hairlineStroke,
            height: AppSpacing.buttonCompact + AppSpacing.x3 - AppSpacing.x1,
            child: ColoredBox(color: color),
          ),
          const SizedBox(width: AppSpacing.x3 + AppSpacing.hairlineStroke),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  implication.condition,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.tradeBotLineHeightCaption,
                  ),
                ),
                Text(
                  implication.action,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppSpacing.tradeBotLineHeightMedium,
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
