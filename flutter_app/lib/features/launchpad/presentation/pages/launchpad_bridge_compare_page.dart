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
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

part 'launchpad_bridge_compare_page_part_01.dart';
part 'launchpad_bridge_compare_page_part_02.dart';
part 'launchpad_bridge_compare_page_part_03.dart';

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
    final snapshot = ref.watch(launchpadControllerProvider).getBridgeCompare();
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
