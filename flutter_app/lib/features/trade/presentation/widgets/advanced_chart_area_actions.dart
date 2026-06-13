part of '../pages/advanced_chart_page.dart';

class _ChartArea extends StatelessWidget {
  const _ChartArea({
    required this.candles,
    required this.indicators,
    required this.chartType,
  });

  final List<TradeCandle> candles;
  final List<TradeChartIndicator> indicators;
  final String chartType;

  @override
  Widget build(BuildContext context) {
    final legend = indicators
        .where((indicator) => indicator.enabled && indicator.id != 'vol')
        .toList(growable: false);

    return Container(
      height: 150,
      color: _chartBlack,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _AdvancedTradeChartPainter(
                candles: candles,
                indicators: indicators,
                chartType: chartType,
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 9,
            child: Row(
              children: [
                for (final indicator in legend) ...[
                  _LegendChip(indicator: indicator),
                  const SizedBox(width: 5),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.indicator});

  final TradeChartIndicator indicator;

  @override
  Widget build(BuildContext context) {
    final color = Color(indicator.colorHex);
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.dynamicIslandBg.withValues(alpha: .72),
        border: Border.all(color: color.withValues(alpha: .45)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        indicator.label,
        style: AppTextStyles.navLabel.copyWith(color: color, height: 1),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TradeActionButton(
              key: AdvancedChartPage.buyKey,
              label: 'MUA',
              color: AppColors.buy,
              onTap: () => context.go(AppRoutePaths.tradePair(pairId)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TradeActionButton(
              key: AdvancedChartPage.sellKey,
              label: 'BÁN',
              color: AppColors.sell,
              onTap: () =>
                  context.go('${AppRoutePaths.tradePair(pairId)}?side=sell'),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            key: AdvancedChartPage.alertKey,
            onTap: () => context.go(AppRoutePaths.marketsAlerts),
            borderRadius: AppRadii.cardRadius,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _toolbarBackground,
                border: Border.all(
                  color: AppColors.onAccent.withValues(alpha: .12),
                ),
                borderRadius: AppRadii.cardRadius,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 19,
                color: AppColors.primarySoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeActionButton extends StatelessWidget {
  const _TradeActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .15),
          border: Border.all(color: color.withValues(alpha: .34)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _IndicatorSheet extends StatelessWidget {
  const _IndicatorSheet({
    required this.indicators,
    required this.onToggle,
    required this.onClose,
  });

  final List<TradeChartIndicator> indicators;
  final ValueChanged<String> onToggle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: ColoredBox(
          color: AppColors.dynamicIslandBg.withValues(alpha: .68),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.borderSolid),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderSolid,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Chỉ báo kỹ thuật',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          key: AdvancedChartPage.closeIndicatorsKey,
                          onPressed: onClose,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.text2,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final indicator in indicators) ...[
                      _IndicatorOption(
                        key: AdvancedChartPage.indicatorKey(indicator.id),
                        indicator: indicator,
                        onTap: () => onToggle(indicator.id),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndicatorOption extends StatelessWidget {
  const _IndicatorOption({
    super.key,
    required this.indicator,
    required this.onTap,
  });

  final TradeChartIndicator indicator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(indicator.colorHex);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: AppSpacing.inputHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: indicator.enabled ? AppColors.surface2 : AppColors.surface,
          border: Border.all(
            color: indicator.enabled
                ? color.withValues(alpha: .34)
                : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                indicator.label,
                style: AppTextStyles.body.copyWith(
                  color: indicator.enabled ? AppColors.text1 : AppColors.text2,
                  fontWeight: indicator.enabled
                      ? AppTextStyles.medium
                      : AppTextStyles.normal,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: indicator.enabled ? color : AppColors.transparent,
                border: Border.all(
                  color: indicator.enabled ? color : AppColors.borderSolid,
                ),
                shape: BoxShape.circle,
              ),
              child: indicator.enabled
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onAccent,
                      size: 14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
