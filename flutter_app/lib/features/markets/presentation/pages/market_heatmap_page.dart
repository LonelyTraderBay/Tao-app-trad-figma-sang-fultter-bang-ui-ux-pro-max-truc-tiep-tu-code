import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_heatmap_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_heatmap_panels.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_heatmap_summary.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_heatmap_treemap.dart';
import '../widgets/market_body_review_widgets.dart';

class MarketHeatmapPage extends ConsumerStatefulWidget {
  const MarketHeatmapPage({super.key, this.shellRenderMode});

  static const contentKey = MarketHeatmapKeys.content;
  static const metric24hKey = MarketHeatmapKeys.metric24h;
  static const metric7dKey = MarketHeatmapKeys.metric7d;
  static const detailButtonKey = MarketHeatmapKeys.detailButton;

  static Key categoryKey(String category) =>
      MarketHeatmapKeys.category(category);

  static Key tileKey(String id) => MarketHeatmapKeys.tile(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketHeatmapPage> createState() => _MarketHeatmapPageState();
}

class _MarketHeatmapPageState extends ConsumerState<MarketHeatmapPage> {
  String _category = 'Tất cả';
  String _metric = '24h';
  String? _selectedCoinId;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(marketControllerProvider).getMarketHeatmap();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 50 : 20);
    final visibleCoins = _visibleCoins(snapshot);
    final selectedCoin = marketHeatmapFindCoin(snapshot.coins, _selectedCoinId);
    final totalMarketCap = visibleCoins.fold<double>(
      0,
      (sum, coin) => sum + coin.marketCap,
    );
    final averageChange = visibleCoins.isEmpty
        ? 0.0
        : visibleCoins.fold<double>(0, (sum, coin) => sum + _changeFor(coin)) /
              visibleCoins.length;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-013 MarketHeatmapPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Market Heatmap',
            subtitle: 'Bản đồ · Markets',
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
                    key: MarketHeatmapPage.contentKey,
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.relaxed,
                      customGap: 28,
                      children: [
                        MarketHeatmapSummaryStrip(
                          totalMarketCap: totalMarketCap,
                          averageChange: averageChange,
                          metric: _metric,
                          count: visibleCoins.length,
                        ),
                        MarketHeatmapControls(
                          metrics: snapshot.metrics,
                          activeMetric: _metric,
                          categories: snapshot.screenFilters.categories,
                          activeCategory: _category,
                          onMetricSelected: (value) {
                            setState(() {
                              _metric = value;
                              _selectedCoinId = null;
                            });
                          },
                          onCategorySelected: (value) {
                            setState(() {
                              _category = value;
                              _selectedCoinId = null;
                            });
                          },
                        ),
                        MarketHeatmapTreemap(
                          coins: visibleCoins,
                          totalMarketCap: totalMarketCap,
                          metric: _metric,
                          selectedCoinId: _selectedCoinId,
                          onCoinSelected: (coin) {
                            setState(() {
                              _selectedCoinId = _selectedCoinId == coin.id
                                  ? null
                                  : coin.id;
                            });
                          },
                        ),
                        const MarketHeatmapLegend(),
                        if (selectedCoin != null)
                          MarketHeatmapSelectedCoinCard(
                            coin: selectedCoin,
                            onDetail: () => context.go(
                              AppRoutePaths.pairDetail(
                                '${selectedCoin.id}usdt',
                              ),
                            ),
                          ),
                        MarketHeatmapTrendPanels(
                          coins: visibleCoins,
                          metric: _metric,
                        ),
                        const MarketBodyReviewSection(
                          title: 'Heatmap state review',
                          message: 'Market heatmap data reviewed',
                          detail:
                              'Metric, category, selected tile, empty, and refresh states remain visible in the heatmap flow.',
                          primary:
                              'Treemap selection keeps the active coin context close to the detail card.',
                          secondary:
                              'Category and metric controls stay above the visualization for fast recovery.',
                          tertiary:
                              'Trend panels share the same market-data status language as the rest of Markets.',
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

  List<HeatmapCoin> _visibleCoins(MarketHeatmapSnapshot snapshot) {
    final coins = _category == 'Tất cả'
        ? snapshot.coins
        : snapshot.coins.where((coin) => coin.category == _category).toList();
    return [...coins]..sort((a, b) => b.marketCap.compareTo(a.marketCap));
  }

  double _changeFor(HeatmapCoin coin) {
    return _metric == '7d' ? coin.change7d : coin.change24h;
  }
}
