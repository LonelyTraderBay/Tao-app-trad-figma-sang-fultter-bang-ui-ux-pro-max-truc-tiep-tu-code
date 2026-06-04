import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part 'p2p_ad_analytics_page_part_01.dart';
part 'p2p_ad_analytics_page_part_02.dart';
part 'p2p_ad_analytics_page_part_03.dart';

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

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
                        _AdIdentityCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _KpiGrid(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _QuickStats(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _ConversionFunnel(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _PerformanceCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _VolumeCard(points: snapshot.dailyPerformance),
                        const SizedBox(height: AppSpacing.x4),
                        _HeatmapCard(points: snapshot.hourlyHeatmap),
                        const SizedBox(height: AppSpacing.x4),
                        _PaymentBreakdownCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _CompetitorCard(rows: snapshot.competitorComparison),
                        const SizedBox(height: AppSpacing.x4),
                        _TipsCard(tips: snapshot.optimizationTips),
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
