part of 'launchpad_bridge_compare_page.dart';

class _InputSummaryHero extends StatelessWidget {
  const _InputSummaryHero({required this.comparison});

  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    final bestRoute = comparison.routes.firstWhere(
      (route) => route.id == comparison.bestOutput,
    );
    return VitCard(
      key: LaunchpadBridgeComparePage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: AppSpacing.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bridge Route Comparison',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${comparison.routes.length} routes',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ChainAmount(
                  chain: comparison.sourceChain,
                  token: comparison.inputToken,
                  amount: _formatNumber(comparison.inputAmount),
                  accent: AppModuleAccents.launchpad,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                children: [
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.portfolioTextMuted,
                    size: AppSpacing.iconMd,
                  ),
                  Text(
                    'bridge',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ChainAmount(
                  chain: comparison.targetChain,
                  token: comparison.outputToken,
                  amount: '~${_formatNumber(bestRoute.outputAmount)}',
                  accent: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChainAmount extends StatelessWidget {
  const _ChainAmount({
    required this.chain,
    required this.token,
    required this.amount,
    required this.accent,
  });

  final String chain;
  final String token;
  final String amount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProviderBadge(
          label: _chainLabel(chain),
          accent: accent,
          size: AppSpacing.launchpadIconHuge,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          amount,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: accent == AppColors.buy ? AppColors.buy : AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          token,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _QuickComparisonCard extends StatelessWidget {
  const _QuickComparisonCard({required this.comparison});

  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeComparePage.quickCompareKey,
      radius: VitCardRadius.lg,
      padding: AppSpacing.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'So sánh nhanh',
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _MetricBars(
            title: 'Output (${comparison.outputToken})',
            routes: comparison.routes,
            metric: _BridgeMetric.output,
            bestRouteId: comparison.bestOutput,
          ),
          const SizedBox(height: AppSpacing.x4),
          _MetricBars(
            title: 'Tổng phí (USD)',
            routes: comparison.routes,
            metric: _BridgeMetric.fee,
            bestRouteId: comparison.bestFee,
          ),
          const SizedBox(height: AppSpacing.x4),
          _MetricBars(
            title: 'Thời gian',
            routes: comparison.routes,
            metric: _BridgeMetric.speed,
            bestRouteId: comparison.bestSpeed,
          ),
        ],
      ),
    );
  }
}

enum _BridgeMetric { output, fee, speed }

class _MetricBars extends StatelessWidget {
  const _MetricBars({
    required this.title,
    required this.routes,
    required this.metric,
    required this.bestRouteId,
  });

  final String title;
  final List<LaunchpadBridgeRouteOptionDraft> routes;
  final _BridgeMetric metric;
  final String bestRouteId;

  @override
  Widget build(BuildContext context) {
    final values = routes.map(_metricValue).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (final route in routes)
          _MetricBarRow(
            route: route,
            value: _metricValue(route),
            label: _metricLabel(route),
            fraction: _fraction(_metricValue(route), minValue, maxValue),
            best: route.id == bestRouteId,
            metric: metric,
          ),
      ],
    );
  }

  double _metricValue(LaunchpadBridgeRouteOptionDraft route) {
    return switch (metric) {
      _BridgeMetric.output => route.outputAmount,
      _BridgeMetric.fee => route.totalFee,
      _BridgeMetric.speed => route.estimatedSeconds.toDouble(),
    };
  }

  String _metricLabel(LaunchpadBridgeRouteOptionDraft route) {
    return switch (metric) {
      _BridgeMetric.output => _formatNumber(route.outputAmount),
      _BridgeMetric.fee => route.totalFeeUsd,
      _BridgeMetric.speed => route.estimatedTime,
    };
  }

  double _fraction(double value, double minValue, double maxValue) {
    if (maxValue == minValue) return 1;
    if (metric == _BridgeMetric.output) {
      return (((value - minValue) / (maxValue - minValue)) * .6 + .4).clamp(
        .15,
        1,
      );
    }
    return (value / maxValue).clamp(.15, 1);
  }
}

class _MetricBarRow extends StatelessWidget {
  const _MetricBarRow({
    required this.route,
    required this.value,
    required this.label,
    required this.fraction,
    required this.best,
    required this.metric,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final double value;
  final String label;
  final double fraction;
  final bool best;
  final _BridgeMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = best
        ? AppColors.buy
        : metric == _BridgeMetric.fee
        ? AppColors.sell
        : route.accent;
    return Padding(
      padding: AppSpacing.launchpadBottomPaddingX2,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.launchpadBox28,
            child: Text(
              route.providerIcon,
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadii.xlRadius,
              child: ColoredBox(
                color: AppColors.surface2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: fraction,
                    child: SizedBox(
                      height: AppSpacing.x4,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: color.withValues(alpha: best ? 1 : .58),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadii.xlRadius,
                          ),
                        ),
                        child: Padding(
                          padding: AppSpacing.launchpadRightPaddingX2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.onAccent,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          SizedBox(
            width: AppSpacing.launchpadIconMd,
            child: best
                ? const Icon(
                    Icons.star_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.launchpadIconXs,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _SortSelector extends StatelessWidget {
  const _SortSelector({
    required this.options,
    required this.activeValue,
    required this.onChanged,
  });

  final List<LaunchpadBridgeSortOptionDraft> options;
  final String activeValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final option in options) ...[
            _SortChip(
              option: option,
              active: option.value == activeValue,
              onTap: () => onChanged(option.value),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final LaunchpadBridgeSortOptionDraft option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: LaunchpadBridgeComparePage.sortKey(option.value),
      label: option.label,
      selected: active,
      onTap: onTap,
      accentColor: AppColors.primary,
      padding: AppSpacing.launchpadPillPadding,
      leading: Icon(
        _sortIcon(option.iconKey),
        size: AppSpacing.launchpadIconSm,
      ),
      semanticLabel: 'Sort bridge routes by ${option.label}',
    );
  }
}
