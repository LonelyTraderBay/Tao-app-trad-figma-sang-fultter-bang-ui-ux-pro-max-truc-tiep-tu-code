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
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';

part '../widgets/pair_detail_header_widgets.dart';
part '../widgets/pair_detail_chart_widgets.dart';
part '../widgets/pair_detail_order_widgets.dart';
part '../widgets/pair_detail_painter_widgets.dart';

const _marketPrimary = AppColors.primary;

enum _PairView { chart, orderBook, trades }

class PairDetailPage extends ConsumerStatefulWidget {
  const PairDetailPage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc044_pair_detail_content');
  static const chartTabKey = Key('sc044_view_chart');
  static const orderBookTabKey = Key('sc044_view_orderbook');
  static const tradesTabKey = Key('sc044_view_trades');
  static const infoButtonKey = Key('sc044_token_info');
  static const depthButtonKey = Key('sc044_market_depth');
  static const dcaButtonKey = Key('sc044_dca_button');
  static const buyButtonKey = Key('sc044_buy');
  static const sellButtonKey = Key('sc044_sell');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PairDetailPage> createState() => _PairDetailPageState();
}

class _PairDetailPageState extends ConsumerState<PairDetailPage> {
  _PairView _activeView = _PairView.chart;
  String _timeframe = '1H';
  final Set<String> _indicators = {'MA', 'Vol'};
  late bool _favorite;

  @override
  void initState() {
    super.initState();
    _favorite = true;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketControllerProvider)
        .getPairDetail(widget.pairId);
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? AppSpacing.pairDetailVisualBottomExtra
            : AppSpacing.pairDetailNativeBottomExtra);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-044 PairDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            _PairHeader(
              pair: pair,
              favorite: _favorite,
              onBack: () => goBackOrFallback(
                context,
                fallbackPath: AppRoutePaths.markets,
                mode: BackNavigationMode.historyThenFallback,
              ),
              onPairTap: () => context.go(AppRoutePaths.markets),
              onFavorite: () => setState(() => _favorite = !_favorite),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PairDetailPage.contentKey,
                  padding: AppSpacing.pairDetailScrollPadding(bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PriceOverview(pair: pair),
                      _ViewTabs(
                        activeView: _activeView,
                        onChanged: (view) => setState(() => _activeView = view),
                      ),
                      if (_activeView == _PairView.chart) ...[
                        _TimeframeRow(
                          active: _timeframe,
                          onChanged: (value) =>
                              setState(() => _timeframe = value),
                        ),
                        _IndicatorRow(
                          active: _indicators,
                          onToggle: (value) => setState(() {
                            if (_indicators.contains(value)) {
                              _indicators.remove(value);
                            } else {
                              _indicators.add(value);
                            }
                          }),
                          onAdvanced: () => context.go(
                            AppRoutePaths.tradeAdvancedChart(pair.id),
                          ),
                        ),
                        _PairChart(series: snapshot.activeChartSeries),
                      ] else if (_activeView == _PairView.orderBook) ...[
                        _OrderBookPanel(snapshot: snapshot),
                      ] else ...[
                        _TradesPanel(trades: snapshot.recentTrades),
                      ],
                      const _RiskWarning(),
                      VitPageSection(
                        children: [
                          _LinkCard(
                            key: PairDetailPage.dcaButtonKey,
                            icon: Icons.repeat_rounded,
                            iconColor: AppColors.accent,
                            title: 'Mua dinh ky BTC',
                            subtitle:
                                'Tu dong mua theo lich - Giam rui ro bien dong',
                            onTap: () => context.go(AppRoutePaths.dca),
                          ),
                          _LinkCard(
                            key: PairDetailPage.infoButtonKey,
                            icon: Icons.info_outline_rounded,
                            iconColor: _marketPrimary,
                            title: 'Thong tin ${pair.baseAsset}',
                            subtitle: 'Tokenomics - On-chain - Du an',
                            onTap: () =>
                                context.go(AppRoutePaths.pairInfo(pair.id)),
                          ),
                          _LinkCard(
                            key: PairDetailPage.depthButtonKey,
                            icon: Icons.layers_rounded,
                            iconColor: AppAssetColors.cyanChain,
                            title: 'Do sau thi truong',
                            subtitle: 'Depth chart - Whale alerts - So lenh',
                            onTap: () =>
                                context.go(AppRoutePaths.pairDepth(pair.id)),
                          ),
                        ],
                      ),
                      _TradeCtas(pairId: pair.id),
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
