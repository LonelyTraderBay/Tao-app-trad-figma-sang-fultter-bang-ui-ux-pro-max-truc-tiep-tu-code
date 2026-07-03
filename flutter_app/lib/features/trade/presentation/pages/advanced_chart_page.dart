import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_terminal_header.dart';

part '../widgets/advanced_chart_header_toolbar.dart';
part '../widgets/advanced_chart_area_actions.dart';
part '../widgets/advanced_chart_painter.dart';

const _tradePrimary = AppColors.primary;
const _chartBlack = AppColors.dynamicIslandBg;

class AdvancedChartPage extends ConsumerStatefulWidget {
  const AdvancedChartPage({
    super.key,
    required this.pairId,
    this.shellRenderMode,
  });

  static const pairSelectorKey = Key('sc055_pair_selector');
  static const indicatorButtonKey = Key('sc055_indicator_button');
  static const buyKey = Key('sc055_buy');
  static const sellKey = Key('sc055_sell');
  static const alertKey = Key('sc055_alert');
  static const closeIndicatorsKey = Key('sc055_close_indicators');

  static Key timeframeKey(String id) => Key('sc055_timeframe_$id');
  static Key chartTypeKey(String id) => Key('sc055_chart_type_$id');
  static Key indicatorKey(String id) => Key('sc055_indicator_$id');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedChartPage> createState() => _AdvancedChartPageState();
}

class _AdvancedChartPageState extends ConsumerState<AdvancedChartPage> {
  String _timeframe = '1h';
  String _chartType = 'candle';
  late List<TradeChartIndicator> _indicators;
  bool _showIndicators = false;

  @override
  void initState() {
    super.initState();
    _indicators = ref
        .read(tradeReadModelControllerProvider)
        .getAdvancedChart(pairId: widget.pairId)
        .indicators
        .toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getAdvancedChart(pairId: widget.pairId);
    final pair = snapshot.pair;
    final enabledIndicators = _indicators
        .where((indicator) => indicator.enabled)
        .toList(growable: false);
    final productTabs = tradeShellWithProductTabs(
      context: context,
      activeProductId: 'spot',
      productPair: pair,
      children: const [],
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-055 AdvancedChartPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitTradeTerminalHeader(
                  symbol: pair.symbol,
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradePair(pair.id)),
                  pairTapKey: AdvancedChartPage.pairSelectorKey,
                  onPairTap: () => context.go(AppRoutePaths.markets),
                  priceLabel: formatTradePrice(pair.price),
                  changePct: pair.changePct,
                ),
                ...productTabs,
                _OhlcvBar(ohlcv: snapshot.ohlcv),
                _ChartToolbar(
                  timeframes: snapshot.timeframes,
                  activeTimeframe: _timeframe,
                  activeChartType: _chartType,
                  activeIndicatorCount: enabledIndicators.length,
                  onTimeframeChanged: (value) =>
                      setState(() => _timeframe = value),
                  onChartTypeChanged: (value) =>
                      setState(() => _chartType = value),
                  onIndicators: () => setState(() => _showIndicators = true),
                ),
                _ChartArea(
                  candles: snapshot.candles,
                  indicators: _indicators,
                  chartType: _chartType,
                ),
                _ActionBar(pairId: pair.id),
                const Expanded(child: SizedBox.expand()),
              ],
            ),
            if (_showIndicators)
              _IndicatorSheet(
                indicators: _indicators,
                onToggle: _toggleIndicator,
                onClose: () => setState(() => _showIndicators = false),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleIndicator(String id) {
    setState(() {
      _indicators = [
        for (final indicator in _indicators)
          indicator.id == id
              ? indicator.copyWith(enabled: !indicator.enabled)
              : indicator,
      ];
    });
  }
}
