import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_chart.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_order_book.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_tabs.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_depth_whale_alerts.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

class MarketDepthPage extends ConsumerStatefulWidget {
  const MarketDepthPage({
    super.key,
    this.pairId = 'btcusdt',
    this.backPath = AppRoutePaths.markets,
    this.shellRenderMode,
  });

  static const contentKey = marketDepthContentKey;
  static const depthChartTabKey = marketDepthChartTabKey;
  static const orderBookTabKey = marketDepthOrderBookTabKey;
  static const whaleAlertTabKey = marketDepthWhaleAlertTabKey;

  static Key levelKey(int level) => marketDepthLevelKey(level);

  final String pairId;
  final String backPath;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketDepthPage> createState() => _MarketDepthPageState();
}

class _MarketDepthPageState extends ConsumerState<MarketDepthPage> {
  String _tab = 'depth';
  int _levels = 25;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketControllerProvider)
        .getMarketDepth(pairId: widget.pairId, levels: _levels);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-019 MarketDepthPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: '${snapshot.pair.baseAsset} Depth',
              showBack: true,
              onBack: () => context.go(widget.backPath),
            ),
            MarketDepthTabs(
              activeTab: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MarketDepthPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      MarketDepthPairSummary(pair: snapshot.pair),
                      if (_tab == 'depth')
                        MarketDepthChartView(
                          snapshot: snapshot,
                          levels: _levels,
                          onLevelSelected: (level) =>
                              setState(() => _levels = level),
                        )
                      else if (_tab == 'orderBook')
                        MarketDepthOrderBookView(snapshot: snapshot)
                      else
                        MarketDepthWhaleAlertsView(snapshot: snapshot),
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
