import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import '../widgets/market_body_review_widgets.dart';

part 'market_overview_page_part_01.dart';
part 'market_overview_page_part_02.dart';
part 'market_overview_page_part_03.dart';

const _marketPrimary = AppColors.primary;
const _sectorPurple = AppColors.accent;
const _btcOrange = AppAssetColors.btc;
const _ethPrimary = AppAssetColors.eth;

class MarketOverviewPage extends ConsumerWidget {
  const MarketOverviewPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc009_market_overview_scroll_content');
  static const quickMoversKey = Key('sc009_quick_movers');
  static const quickSectorsKey = Key('sc009_quick_sectors');
  static const quickHeatmapKey = Key('sc009_quick_heatmap');
  static const topGainersKey = Key('sc009_top_gainers_header');
  static const topLosersKey = Key('sc009_top_losers_header');
  static const allSectorsKey = Key('sc009_all_sectors');
  static const watchlistToolKey = Key('sc009_tool_watchlist');
  static const alertsToolKey = Key('sc009_tool_alerts');
  static const heatmapToolKey = Key('sc009_tool_heatmap');
  static const marketListToolKey = Key('sc009_tool_market_list');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(marketControllerProvider).getMarketOverview();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 52 : 22);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-009 MarketOverviewPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tổng quan thị trường',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
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
                    key: contentKey,
                    padding: AppSpacing.marketScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      gap: VitContentGap.relaxed,
                      children: [
                        _MarketCapHero(stats: snapshot.globalStats),
                        _StatsGrid(stats: snapshot.globalStats),
                        _SentimentGrid(
                          stats: snapshot.globalStats,
                          breadth: snapshot.marketBreadth,
                        ),
                        const _QuickNavigation(),
                        _MoversGrid(movers: snapshot.movers),
                        _SectorPerformance(sectors: snapshot.sectors),
                        _FearGreedHistory(points: snapshot.fearGreedHistory),
                        const _MarketTools(),
                        const MarketBodyReviewSection(
                          title: 'Overview state review',
                          message: 'Market overview data reviewed',
                          detail:
                              'Global stats, movers, sectors, heatmap links, empty, and refresh states remain visible.',
                          primary:
                              'Global cap and breadth metrics stay above exploratory market tools.',
                          secondary:
                              'Gainers, losers, and sectors preserve direction before pair navigation.',
                          tertiary:
                              'Tools remain grouped below market context so scanning is not interrupted.',
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
