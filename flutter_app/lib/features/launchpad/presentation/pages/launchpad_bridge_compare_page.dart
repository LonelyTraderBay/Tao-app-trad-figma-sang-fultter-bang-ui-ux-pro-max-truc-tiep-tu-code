import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';

class LaunchpadBridgeComparePage extends ConsumerStatefulWidget {
  const LaunchpadBridgeComparePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc305_launchpad_bridge_compare_content');
  static const heroKey = Key('sc305_launchpad_bridge_compare_hero');
  static const quickCompareKey = Key(
    'sc305_launchpad_bridge_compare_quick_compare',
  );
  static const sortKeyPrefix = 'sc305_launchpad_bridge_compare_sort_';
  static const footerKey = Key('sc305_launchpad_bridge_compare_footer');
  static const confirmKey = Key('sc305_launchpad_bridge_compare_confirm');
  static const riskKey = Key('sc305_launchpad_bridge_compare_risk');

  static Key sortKey(String value) => Key('$sortKeyPrefix$value');
  static Key routeKey(String id) =>
      Key('sc305_launchpad_bridge_compare_route_$id');
  static Key routeSelectKey(String id) =>
      Key('sc305_launchpad_bridge_compare_route_select_$id');
  static Key expandKey(String id) =>
      Key('sc305_launchpad_bridge_compare_expand_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadBridgeComparePage> createState() =>
      _LaunchpadBridgeComparePageState();
}

class _LaunchpadBridgeComparePageState
    extends ConsumerState<LaunchpadBridgeComparePage> {
  var _sortMode = 'recommended';
  String? _selectedRouteId;
  String? _expandedRouteId;
  var _confirmVisible = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getBridgeCompare();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final footerHeight = _selectedRouteId == null ? 0.0 : 122.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + footerHeight;
    final routes = _sortedRoutes(snapshot.comparison.routes);
    final selectedRoutes = snapshot.comparison.routes
        .where((route) => route.id == _selectedRouteId)
        .toList();
    final selectedRoute = selectedRoutes.isEmpty ? null : selectedRoutes.first;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-305 LaunchpadBridgeComparePage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                  trailing: _RefreshButton(
                    onPressed: () {
                      setState(() {
                        _sortMode = 'recommended';
                        _selectedRouteId = null;
                        _expandedRouteId = null;
                        _confirmVisible = false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadBridgeComparePage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
                        _InputSummaryHero(comparison: snapshot.comparison),
                        _QuickComparisonCard(comparison: snapshot.comparison),
                        _SortSelector(
                          options: snapshot.sortOptions,
                          activeValue: _sortMode,
                          onChanged: (value) =>
                              setState(() => _sortMode = value),
                        ),
                        for (final route in routes)
                          _RouteCard(
                            route: route,
                            rank: routes.indexOf(route) + 1,
                            comparison: snapshot.comparison,
                            selected: _selectedRouteId == route.id,
                            expanded: _expandedRouteId == route.id,
                            onSelect: () => setState(() {
                              _selectedRouteId = _selectedRouteId == route.id
                                  ? null
                                  : route.id;
                            }),
                            onExpand: () => setState(() {
                              _expandedRouteId = _expandedRouteId == route.id
                                  ? null
                                  : route.id;
                            }),
                          ),
                        const _RiskDisclosure(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (selectedRoute != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: _SelectedRouteFooter(
                  route: selectedRoute,
                  outputToken: snapshot.comparison.outputToken,
                  onConfirm: () => setState(() => _confirmVisible = true),
                ),
              ),
            if (_confirmVisible && selectedRoute != null)
              _RouteConfirmOverlay(
                route: selectedRoute,
                comparison: snapshot.comparison,
                onClose: () => setState(() => _confirmVisible = false),
                onExecute: () => context.go(snapshot.bridgeOrderRoute),
              ),
          ],
        ),
      ),
    );
  }

  List<LaunchpadBridgeRouteOptionDraft> _sortedRoutes(
    List<LaunchpadBridgeRouteOptionDraft> routes,
  ) {
    final sorted = [...routes];
    switch (_sortMode) {
      case 'output':
        sorted.sort((a, b) => b.outputAmount.compareTo(a.outputAmount));
        break;
      case 'fee':
        sorted.sort((a, b) => a.totalFee.compareTo(b.totalFee));
        break;
      case 'speed':
        sorted.sort((a, b) => a.estimatedSeconds.compareTo(b.estimatedSeconds));
        break;
      case 'security':
        sorted.sort((a, b) => b.securityScore.compareTo(a.securityScore));
        break;
      case 'recommended':
      default:
        sorted.sort(
          (a, b) => _recommendedRank(a).compareTo(_recommendedRank(b)),
        );
        break;
    }
    return sorted;
  }

  int _recommendedRank(LaunchpadBridgeRouteOptionDraft route) {
    if (route.recommended) return 0;
    return route.id.codeUnitAt(route.id.length - 1);
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.searchBg,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadii.mdRadius,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppColors.text1,
            size: AppSpacing.iconSm,
          ),
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
        _ProviderBadge(label: _chainLabel(chain), accent: accent, size: 32),
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
      padding: const EdgeInsets.all(AppSpacing.x4),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          SizedBox(
            width: 28,
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
              borderRadius: BorderRadius.circular(AppRadii.xl),
              child: ColoredBox(
                color: AppColors.surface2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(
                      height: AppSpacing.x4,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.x2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: best ? 1 : .58),
                        borderRadius: BorderRadius.circular(AppRadii.xl),
                      ),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: Colors.white,
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
          const SizedBox(width: AppSpacing.x2),
          SizedBox(
            width: 14,
            child: best
                ? const Icon(Icons.star_rounded, color: AppColors.buy, size: 12)
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
      physics: const BouncingScrollPhysics(),
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
    return InkWell(
      key: LaunchpadBridgeComparePage.sortKey(option.value),
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary08 : AppColors.surface2,
          border: Border.all(
            color: active
                ? AppColors.primary.withValues(alpha: .24)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _sortIcon(option.iconKey),
              color: active ? AppColors.primary : AppColors.text3,
              size: 13,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              option.label,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.primary : AppColors.text3,
                fontWeight: active ? AppTextStyles.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                  color: Colors.white,
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

class _HopChip extends StatelessWidget {
  const _HopChip({required this.label, required this.subtitle});

  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
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
      ),
    );
  }
}

class _RiskDisclosure extends StatelessWidget {
  const _RiskDisclosure();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadBridgeComparePage.riskKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Lưu ý rủi ro đầu tư',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _SelectedRouteFooter extends StatelessWidget {
  const _SelectedRouteFooter({
    required this.route,
    required this.outputToken,
    required this.onConfirm,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final String outputToken;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return VitStickyFooter(
      key: LaunchpadBridgeComparePage.footerKey,
      backgroundColor: AppColors.surface.withValues(alpha: .94),
      child: Column(
        children: [
          Row(
            children: [
              _ProviderBadge(
                label: route.providerIcon,
                accent: route.accent,
                size: 34,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.provider,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${_formatNumber(route.outputAmount)} $outputToken · ${route.totalFeeUsd} fee · ${route.estimatedTime}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCtaButton(
            onPressed: onConfirm,
            child: const Text('Chọn route này'),
          ),
        ],
      ),
    );
  }
}

class _RouteConfirmOverlay extends StatelessWidget {
  const _RouteConfirmOverlay({
    required this.route,
    required this.comparison,
    required this.onClose,
    required this.onExecute,
  });

  final LaunchpadBridgeRouteOptionDraft route;
  final LaunchpadBridgeComparisonDraft comparison;
  final VoidCallback onClose;
  final VoidCallback onExecute;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: .74),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            key: LaunchpadBridgeComparePage.confirmKey,
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 620),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x5,
              AppSpacing.x4,
              AppSpacing.x5,
              AppSpacing.x6,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.xl),
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
                    borderRadius: AppRadii.inputRadius,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Xác nhận route',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                _ProviderBadge(
                  label: route.providerIcon,
                  accent: route.accent,
                  size: 56,
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  route.provider,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${route.hops} hops · ${route.estimatedTime}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x4),
                VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.lg,
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ConfirmAmount(
                          label: 'Bạn gửi',
                          value: _formatNumber(comparison.inputAmount),
                          token: comparison.inputToken,
                          chain: comparison.sourceChain,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.iconSm,
                      ),
                      Expanded(
                        child: _ConfirmAmount(
                          label: 'Nhận',
                          value: _formatNumber(route.outputAmount),
                          token: comparison.outputToken,
                          chain: comparison.targetChain,
                          color: AppColors.buy,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                _DetailsRow(
                  label: 'Price impact',
                  value: '${_trimDouble(route.priceImpact)}%',
                ),
                _DetailsRow(label: 'Tổng phí', value: route.totalFeeUsd),
                _DetailsRow(
                  label: 'Security',
                  value: '${route.securityScore}/100',
                ),
                const SizedBox(height: AppSpacing.x4),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  decoration: BoxDecoration(
                    color: AppColors.primary08,
                    border: Border.all(color: AppColors.primary12),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    'Đây là chế độ mô phỏng. Kết quả thực tế có thể khác theo điều kiện thị trường.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                VitCtaButton(
                  onPressed: onExecute,
                  child: Text('Xác nhận Bridge qua ${route.provider}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmAmount extends StatelessWidget {
  const _ConfirmAmount({
    required this.label,
    required this.value,
    required this.token,
    required this.chain,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final String token;
  final String chain;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          '$token · $chain',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

IconData _sortIcon(String iconKey) {
  return switch (iconKey) {
    'trending' => Icons.trending_up_rounded,
    'fuel' => Icons.local_gas_station_outlined,
    'clock' => Icons.schedule_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.star_border_rounded,
  };
}

String _chainLabel(String chain) {
  if (chain == 'Ethereum') return 'ET';
  if (chain == 'Polygon') return 'PG';
  return chain.length > 2 ? chain.substring(0, 2).toUpperCase() : chain;
}

String _formatNumber(num value) {
  final fixed = value is int || value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1 && parts.last.isNotEmpty) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}

String _trimDouble(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}
