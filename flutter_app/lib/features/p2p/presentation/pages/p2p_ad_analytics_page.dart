import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part 'p2p_ad_analytics_page_part_01.dart';
part 'p2p_ad_analytics_page_part_02.dart';
part 'p2p_ad_analytics_page_part_03.dart';

const double _p2pAdAnalyticsVisualNavClearance = 112;
const double _p2pAdAnalyticsNativeNavClearance = 88;
const double _p2pAdAnalyticsIdentityExtent =
    AppSpacing.p2pMarketplaceAnalyticsIdentityHeight;
const double _p2pAdAnalyticsMetricCardExtent =
    AppSpacing.p2pMarketplaceAnalyticsMetricCardHeight;
const double _p2pAdAnalyticsMetricIconExtent = AppSpacing.x6;
const double _p2pAdAnalyticsQuickStatsExtent =
    AppSpacing.p2pMarketplaceAnalyticsQuickStatsHeight;
const double _p2pAdAnalyticsLegendDotExtent =
    AppSpacing.p2pMarketplaceAnalyticsLegendDot;
const double _p2pAdAnalyticsDividerExtent =
    AppSpacing.p2pMarketplaceAnalyticsDividerHeight;
const double _p2pAdAnalyticsChartLargeExtent =
    AppSpacing.p2pMarketplaceAnalyticsChartLargeHeight;
const double _p2pAdAnalyticsChartTallExtent =
    AppSpacing.p2pMarketplaceAnalyticsChartTallHeight;
const double _p2pAdAnalyticsRadarExtent =
    AppSpacing.p2pMarketplaceAnalyticsRadarHeight;
const double _p2pAdAnalyticsTightLine =
    AppSpacing.p2pMarketplaceAnalyticsTightLineHeight;
const double _p2pAdAnalyticsBodyLine =
    AppSpacing.p2pMarketplaceAnalyticsBodyLineHeight;

class P2PAdAnalyticsPage extends ConsumerWidget {
  const P2PAdAnalyticsPage({
    super.key,
    required this.adId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc223_p2p_ad_analytics_content');
  static const funnelKey = Key('sc223_p2p_ad_analytics_funnel');

  final String adId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pAdAnalyticsProvider(adId));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _p2pAdAnalyticsVisualNavClearance
        : _p2pAdAnalyticsNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-223 P2PAdAnalyticsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích quảng cáo',
            subtitle: 'Phân tích · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: P2PAdAnalyticsPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.contentPad,
                      AppSpacing.x3,
                      AppSpacing.contentPad,
                      scrollEndPadding,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      density: VitDensity.compact,
                      children: [
                        _AdIdentityCard(snapshot: snapshot),
                        _KpiGrid(snapshot: snapshot),
                        _QuickStats(snapshot: snapshot),
                        _ConversionFunnel(snapshot: snapshot),
                        _PerformanceCard(snapshot: snapshot),
                        _VolumeCard(points: snapshot.dailyPerformance),
                        _HeatmapCard(points: snapshot.hourlyHeatmap),
                        _PaymentBreakdownCard(snapshot: snapshot),
                        _CompetitorCard(rows: snapshot.competitorComparison),
                        _TipsCard(tips: snapshot.optimizationTips),
                        const VitPageSection(
                          density: VitDensity.compact,
                          children: [
                            VitCard(
                              variant: VitCardVariant.inner,
                              padding: AppSpacing
                                  .p2pMarketplaceAnalyticsCompactPadding,
                              child: VitHighRiskStatePanel(
                                density: VitDensity.compact,
                                state: VitHighRiskUiState.riskReview,
                                title: 'Ad performance review',
                                message:
                                    'Ad identity, conversion funnel, volume trend, payment mix, competitor spread and optimization next step are reviewed before changes.',
                                contractId: 'p2p-ad-analytics-review',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
