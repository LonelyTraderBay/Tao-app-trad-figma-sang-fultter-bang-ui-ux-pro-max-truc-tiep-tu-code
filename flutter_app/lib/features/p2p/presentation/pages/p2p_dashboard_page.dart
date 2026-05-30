import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part 'p2p_dashboard_page_part_01.dart';
part 'p2p_dashboard_page_part_02.dart';
part 'p2p_dashboard_page_part_03.dart';
part 'p2p_dashboard_page_part_04.dart';

class P2PDashboardPage extends ConsumerStatefulWidget {
  const P2PDashboardPage({super.key, this.shellRenderMode});

  static const filterKey = Key('sc274_p2p_dashboard_filters');
  static const volumeHeroKey = Key('sc274_p2p_dashboard_volume_hero');
  static const metricsKey = Key('sc274_p2p_dashboard_metrics');
  static const weeklyChartKey = Key('sc274_p2p_dashboard_weekly_chart');
  static const monthlyChartKey = Key('sc274_p2p_dashboard_monthly_chart');
  static const assetDistributionKey = Key(
    'sc274_p2p_dashboard_asset_distribution',
  );
  static const levelKey = Key('sc274_p2p_dashboard_level');
  static const comparisonKey = Key('sc274_p2p_dashboard_comparison');
  static const breakdownKey = Key('sc274_p2p_dashboard_breakdown');
  static const merchantsKey = Key('sc274_p2p_dashboard_merchants');
  static const activityKey = Key('sc274_p2p_dashboard_activity');
  static const quickNavKey = Key('sc274_p2p_dashboard_quick_nav');
  static const myOrdersKey = Key('sc274_p2p_dashboard_my_orders');

  static Key filterChipKey(String id) => Key('sc274_p2p_dashboard_filter_$id');

  static Key merchantKey(String id) => Key('sc274_p2p_dashboard_merchant_$id');

  static Key quickActionKey(String id) => Key('sc274_p2p_dashboard_quick_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDashboardPage> createState() => _P2PDashboardPageState();
}

class _P2PDashboardPageState extends ConsumerState<P2PDashboardPage> {
  String _timeFilter = '30d';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pDashboardProvider(_timeFilter));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-274 P2PDashboardPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x5,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FilterRail(
                        snapshot: snapshot,
                        onChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _timeFilter = id);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _VolumeHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _MetricsGrid(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _WeeklyVolumeCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _MonthlyOrdersCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _AssetDistributionCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _LevelCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _PlatformComparisonCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _ExtraStats(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _OrderBreakdownCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _TopMerchantsCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _RecentActivityCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _QuickNavigation(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
