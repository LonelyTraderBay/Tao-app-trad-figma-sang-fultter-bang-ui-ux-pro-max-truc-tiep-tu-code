part of 'launchpad_bridge_compare_page.dart';

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.rank,
    required this.comparison,
    required this.selected,
    required this.expanded,
    required this.onSelect,
    required this.onExpand,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final int rank;
  final LaunchpadBridgeComparisonDraft comparison;
  final bool selected;
  final bool expanded;
  final VoidCallback onSelect;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeComparePage.routeKey(route.id),
      radius: VitCardRadius.lg,
      borderColor: selected
          ? route.accent.withValues(alpha: .48)
          : route.recommended
          ? AppColors.primary.withValues(alpha: .24)
          : AppColors.cardBorder,
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          InkWell(
            key: LaunchpadBridgeComparePage.routeSelectKey(route.id),
            onTap: onSelect,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RankedProviderBadge(route: route, rank: rank),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                route.provider,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.base.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            if (route.recommended) const _RecommendedBadge(),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        _RouteTags(route: route, comparison: comparison),
                        const SizedBox(height: AppSpacing.x3),
                        _RouteMetrics(route: route, comparison: comparison),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? route.accent : AppColors.borderSolid,
                    size: AppSpacing.iconMd,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          InkWell(
            key: LaunchpadBridgeComparePage.expandKey(route.id),
            onTap: onExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chi tiết',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            _ExpandedRouteDetails(route: route, comparison: comparison),
        ],
      ),
    );
  }
}

class _RankedProviderBadge extends StatelessWidget {
  const _RankedProviderBadge({required this.route, required this.rank});

  final LaunchpadBridgeRouteOptionDraft route;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _ProviderBadge(
          label: route.providerIcon,
          accent: route.accent,
          size: 40,
        ),
        if (rank == 1)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              width: 17,
              height: 17,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Text(
                '1',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProviderBadge extends StatelessWidget {
  const _ProviderBadge({
    required this.label,
    required this.accent,
    required this.size,
  });

  final String label;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .16),
        border: Border.all(color: accent.withValues(alpha: .28)),
        borderRadius: BorderRadius.circular(size / 2.8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: accent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  const _RecommendedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        'KHUYẾN NGHỊ',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.primary,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _RouteTags extends StatelessWidget {
  const _RouteTags({required this.route, required this.comparison});

  final LaunchpadBridgeRouteOptionDraft route;
  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    final tags = <_RouteTag>[
      if (route.id == comparison.bestOutput)
        const _RouteTag('Best output', AppColors.buy),
      if (route.id == comparison.bestFee)
        const _RouteTag('Lowest fee', AppColors.buy),
      if (route.id == comparison.bestSpeed)
        const _RouteTag('Fastest', AppColors.warn),
      if (route.id == comparison.bestSecurity)
        const _RouteTag('Most secure', AppColors.accent),
      for (final tag in route.tags.where(
        (tag) => ![
          'Best output',
          'Lowest fee',
          'Fastest',
          'Most secure',
        ].contains(tag),
      ))
        _RouteTag(tag, AppColors.accent),
      for (final warning in route.warnings) _RouteTag(warning, AppColors.sell),
    ];

    return Wrap(
      spacing: AppSpacing.x1,
      runSpacing: AppSpacing.x1,
      children: [for (final tag in tags) _MetricTag(tag: tag)],
    );
  }
}

class _RouteTag {
  const _RouteTag(this.label, this.color);

  final String label;
  final Color color;
}

class _MetricTag extends StatelessWidget {
  const _MetricTag({required this.tag});

  final _RouteTag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: tag.color.withValues(alpha: .10),
        border: Border.all(color: tag.color.withValues(alpha: .16)),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        tag.label,
        style: AppTextStyles.micro.copyWith(
          color: tag.color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _RouteMetrics extends StatelessWidget {
  const _RouteMetrics({required this.route, required this.comparison});

  final LaunchpadBridgeRouteOptionDraft route;
  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    final outputDiff =
        ((route.outputAmount - _bestOutput(comparison)) /
                _bestOutput(comparison) *
                100)
            .toStringAsFixed(2);
    return Row(
      children: [
        Expanded(
          child: _RouteMetric(
            label: 'Output',
            value: _formatNumber(route.outputAmount),
            subvalue: route.id == comparison.bestOutput ? null : '$outputDiff%',
            color: route.id == comparison.bestOutput
                ? AppColors.buy
                : AppColors.text1,
            subvalueColor: AppColors.sell,
          ),
        ),
        Expanded(
          child: _RouteMetric(
            label: 'Phí',
            value: route.totalFeeUsd,
            color: route.id == comparison.bestFee
                ? AppColors.buy
                : AppColors.text1,
          ),
        ),
        Expanded(
          child: _RouteMetric(
            label: 'Thời gian',
            value: route.estimatedTime,
            color: route.id == comparison.bestSpeed
                ? AppColors.buy
                : AppColors.text1,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  _SecurityDots(score: route.securityScore),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    '${route.securityScore}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _bestOutput(LaunchpadBridgeComparisonDraft comparison) {
    return comparison.routes
        .firstWhere((route) => route.id == comparison.bestOutput)
        .outputAmount;
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({
    required this.label,
    required this.value,
    this.subvalue,
    this.color = AppColors.text1,
    this.subvalueColor = AppColors.text3,
  });

  final String label;
  final String value;
  final String? subvalue;
  final Color color;
  final Color subvalueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        if (subvalue != null)
          Text(
            subvalue!,
            style: AppTextStyles.micro.copyWith(
              color: subvalueColor,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
      ],
    );
  }
}

class _SecurityDots extends StatelessWidget {
  const _SecurityDots({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final filled = ((score / 100) * 5).round();
    return Row(
      children: [
        for (var i = 0; i < 5; i++)
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: i < filled
                  ? AppColors.buy
                  : AppColors.text3.withValues(alpha: .30),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

class _ExpandedRouteDetails extends StatelessWidget {
  const _ExpandedRouteDetails({required this.route, required this.comparison});

  final LaunchpadBridgeRouteOptionDraft route;
  final LaunchpadBridgeComparisonDraft comparison;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x3,
        AppSpacing.x4,
        AppSpacing.x4,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Route path (${route.hops} hops)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final hop in route.path) ...[
                  _HopChip(label: hop.fromToken, subtitle: hop.chain),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.x1),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.text3,
                      size: 12,
                    ),
                  ),
                  _HopChip(label: hop.dex, subtitle: 'DEX'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.x1),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.text3,
                      size: 12,
                    ),
                  ),
                  _HopChip(label: hop.toToken, subtitle: hop.chain),
                  const SizedBox(width: AppSpacing.x2),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _DetailsRow(
            label: 'Gas cost',
            value: '\$${route.gasCost.toStringAsFixed(2)}',
          ),
          _DetailsRow(
            label: 'Bridge fee',
            value: '\$${route.bridgeFee.toStringAsFixed(2)}',
          ),
          _DetailsRow(
            label: 'Price impact',
            value: '${_trimDouble(route.priceImpact)}%',
          ),
          _DetailsRow(
            label: 'Slippage tolerance',
            value: '${_trimDouble(route.slippage)}%',
          ),
          _DetailsRow(label: 'Liquidity depth', value: route.liquidityDepth),
        ],
      ),
    );
  }
}
