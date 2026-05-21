import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _tradeBlue = Color(0xFF3B82F6);
const _chartBlack = Color(0xFF000000);
const _toolbarBg = Color(0xFF202940);

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
        .read(tradeRepositoryProvider)
        .getAdvancedChart(pairId: widget.pairId)
        .indicators
        .toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getAdvancedChart(pairId: widget.pairId);
    final pair = snapshot.pair;
    final enabledIndicators = _indicators
        .where((indicator) => indicator.enabled)
        .toList(growable: false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-055 AdvancedChartPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                _AdvancedHeader(pair: pair),
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

class _AdvancedHeader extends StatelessWidget {
  const _AdvancedHeader({required this.pair});

  final TradePair pair;

  @override
  Widget build(BuildContext context) {
    final logoColor = Color(pair.logoColorHex);
    final changeColor = pair.changePct >= 0 ? AppColors.buy : AppColors.sell;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go(AppRoutePaths.tradePair(pair.id)),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text1,
                size: 23,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            key: AdvancedChartPage.pairSelectorKey,
            onTap: () => context.go(AppRoutePaths.markets),
            borderRadius: AppRadii.mdRadius,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: logoColor.withValues(alpha: .18),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    pair.baseAsset.substring(0, 3),
                    style: AppTextStyles.micro.copyWith(
                      color: logoColor,
                      fontSize: 8,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  pair.symbol,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: 17,
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(pair.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: changeColor,
                    fontSize: 15,
                    fontFamily: 'monospace',
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatPercent(pair.changePct),
                  style: AppTextStyles.micro.copyWith(
                    color: changeColor,
                    fontSize: 11,
                    fontWeight: AppTextStyles.medium,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OhlcvBar extends StatelessWidget {
  const _OhlcvBar({required this.ohlcv});

  final TradeOhlcv ohlcv;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                'Mới nhất',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.sell,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              _OhlcvToken(label: 'O', value: _formatRawPrice(ohlcv.open)),
              _OhlcvToken(
                label: 'H',
                value: _formatRawPrice(ohlcv.high),
                valueColor: AppColors.buy,
              ),
              _OhlcvToken(
                label: 'L',
                value: _formatRawPrice(ohlcv.low),
                valueColor: AppColors.sell,
              ),
              _OhlcvToken(
                label: 'C',
                value: _formatRawPrice(ohlcv.close),
                valueColor: AppColors.sell,
              ),
              _OhlcvToken(label: 'Vol', value: ohlcv.volumeLabel),
            ],
          ),
        ),
      ),
    );
  }
}

class _OhlcvToken extends StatelessWidget {
  const _OhlcvToken({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: RichText(
        maxLines: 1,
        text: TextSpan(
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 10,
            fontFamily: 'monospace',
            height: 1,
          ),
          children: [
            TextSpan(
              text: '$label:',
              style: const TextStyle(color: AppColors.text2),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartToolbar extends StatelessWidget {
  const _ChartToolbar({
    required this.timeframes,
    required this.activeTimeframe,
    required this.activeChartType,
    required this.activeIndicatorCount,
    required this.onTimeframeChanged,
    required this.onChartTypeChanged,
    required this.onIndicators,
  });

  final List<String> timeframes;
  final String activeTimeframe;
  final String activeChartType;
  final int activeIndicatorCount;
  final ValueChanged<String> onTimeframeChanged;
  final ValueChanged<String> onChartTypeChanged;
  final VoidCallback onIndicators;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          for (final timeframe in timeframes)
            _TimeframeButton(
              key: AdvancedChartPage.timeframeKey(timeframe),
              label: timeframe,
              active: activeTimeframe == timeframe,
              onTap: () => onTimeframeChanged(timeframe),
            ),
          Container(
            width: 1,
            height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: AppColors.borderSolid,
          ),
          _ChartTypeButton(
            key: AdvancedChartPage.chartTypeKey('candle'),
            id: 'candle',
            icon: Icons.show_chart_rounded,
            active: activeChartType == 'candle',
            onTap: onChartTypeChanged,
          ),
          _ChartTypeButton(
            key: AdvancedChartPage.chartTypeKey('line'),
            id: 'line',
            icon: Icons.stacked_line_chart_rounded,
            active: activeChartType == 'line',
            onTap: onChartTypeChanged,
          ),
          _ChartTypeButton(
            key: AdvancedChartPage.chartTypeKey('area'),
            id: 'area',
            icon: Icons.bar_chart_rounded,
            active: activeChartType == 'area',
            onTap: onChartTypeChanged,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                key: AdvancedChartPage.indicatorButtonKey,
                onTap: onIndicators,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _toolbarBg,
                    border: Border.all(
                      color: _tradeBlue.withValues(alpha: .45),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.layers_outlined,
                        size: 13,
                        color: _tradeBlue,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$activeIndicatorCount chỉ\nbáo',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.micro.copyWith(
                            color: _tradeBlue,
                            fontSize: 11,
                            fontWeight: AppTextStyles.medium,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeframeButton extends StatelessWidget {
  const _TimeframeButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 39,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _tradeBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? Colors.white : AppColors.text3,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _ChartTypeButton extends StatelessWidget {
  const _ChartTypeButton({
    super.key,
    required this.id,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String id;
  final IconData icon;
  final bool active;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 28,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.borderSolid : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? AppColors.primarySoft : AppColors.text2,
        ),
      ),
    );
  }
}

class _ChartArea extends StatelessWidget {
  const _ChartArea({
    required this.candles,
    required this.indicators,
    required this.chartType,
  });

  final List<TradeCandle> candles;
  final List<TradeChartIndicator> indicators;
  final String chartType;

  @override
  Widget build(BuildContext context) {
    final legend = indicators
        .where((indicator) => indicator.enabled && indicator.id != 'vol')
        .toList(growable: false);

    return Container(
      height: 150,
      color: _chartBlack,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _AdvancedTradeChartPainter(
                candles: candles,
                indicators: indicators,
                chartType: chartType,
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 9,
            child: Row(
              children: [
                for (final indicator in legend) ...[
                  _LegendChip(indicator: indicator),
                  const SizedBox(width: 5),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.indicator});

  final TradeChartIndicator indicator;

  @override
  Widget build(BuildContext context) {
    final color = Color(indicator.colorHex);
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .72),
        border: Border.all(color: color.withValues(alpha: .45)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        indicator.label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: AppTextStyles.medium,
          height: 1,
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TradeActionButton(
              key: AdvancedChartPage.buyKey,
              label: 'MUA',
              color: AppColors.buy,
              onTap: () => context.go(AppRoutePaths.tradePair(pairId)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TradeActionButton(
              key: AdvancedChartPage.sellKey,
              label: 'BÁN',
              color: AppColors.sell,
              onTap: () =>
                  context.go('${AppRoutePaths.tradePair(pairId)}?side=sell'),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            key: AdvancedChartPage.alertKey,
            onTap: () => context.go(AppRoutePaths.marketsAlerts),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _toolbarBg,
                border: Border.all(color: Colors.white12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 19,
                color: AppColors.primarySoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TradeActionButton extends StatelessWidget {
  const _TradeActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .15),
          border: Border.all(color: color.withValues(alpha: .34)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _IndicatorSheet extends StatelessWidget {
  const _IndicatorSheet({
    required this.indicators,
    required this.onToggle,
    required this.onClose,
  });

  final List<TradeChartIndicator> indicators;
  final ValueChanged<String> onToggle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onClose,
        child: ColoredBox(
          color: Colors.black.withValues(alpha: .68),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.borderSolid),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
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
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Chỉ báo kỹ thuật',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        IconButton(
                          key: AdvancedChartPage.closeIndicatorsKey,
                          onPressed: onClose,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.text2,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final indicator in indicators) ...[
                      _IndicatorOption(
                        key: AdvancedChartPage.indicatorKey(indicator.id),
                        indicator: indicator,
                        onTap: () => onToggle(indicator.id),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndicatorOption extends StatelessWidget {
  const _IndicatorOption({
    super.key,
    required this.indicator,
    required this.onTap,
  });

  final TradeChartIndicator indicator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(indicator.colorHex);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: indicator.enabled ? AppColors.surface2 : AppColors.surface,
          border: Border.all(
            color: indicator.enabled
                ? color.withValues(alpha: .34)
                : AppColors.borderSolid,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                indicator.label,
                style: AppTextStyles.body.copyWith(
                  color: indicator.enabled ? AppColors.text1 : AppColors.text2,
                  fontWeight: indicator.enabled
                      ? AppTextStyles.medium
                      : AppTextStyles.normal,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: indicator.enabled ? color : Colors.transparent,
                border: Border.all(
                  color: indicator.enabled ? color : AppColors.borderSolid,
                ),
                shape: BoxShape.circle,
              ),
              child: indicator.enabled
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedTradeChartPainter extends CustomPainter {
  const _AdvancedTradeChartPainter({
    required this.candles,
    required this.indicators,
    required this.chartType,
  });

  final List<TradeCandle> candles;
  final List<TradeChartIndicator> indicators;
  final String chartType;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = _chartBlack;
    canvas.drawRect(Offset.zero & size, bg);

    if (candles.isEmpty) return;

    final chartCandles = _expandedCandles(candles);
    final showVolume = indicators.any(
      (indicator) => indicator.id == 'vol' && indicator.enabled,
    );
    final chartTop = 18.0;
    final chartBottom = showVolume ? size.height - 64 : size.height - 12;
    final chartHeight = chartBottom - chartTop;
    final chartWidth = size.width - 16;
    final left = 8.0;
    final right = left + chartWidth;
    final prices = [
      for (final candle in chartCandles) ...[candle.high, candle.low],
    ];
    final minPrice = prices.reduce(math.min);
    final maxPrice = prices.reduce(math.max);
    final pricePad = (maxPrice - minPrice) * .08;
    final low = minPrice - pricePad;
    final high = maxPrice + pricePad;
    final range = math.max(1, high - low);
    final step = chartWidth / chartCandles.length;

    double xFor(int index) => left + step * index + step / 2;
    double yFor(double value) =>
        chartTop + chartHeight - ((value - low) / range) * chartHeight;

    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .055)
      ..strokeWidth = .7;
    for (var i = 0; i < 4; i++) {
      final y = chartTop + chartHeight * i / 3;
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    }

    if (chartType == 'line' || chartType == 'area') {
      _drawLineOrArea(canvas, chartCandles, yFor, xFor, chartBottom);
    } else {
      _drawCandles(canvas, chartCandles, xFor, yFor, step);
    }

    _drawMovingAverages(canvas, chartCandles, xFor, yFor);

    if (showVolume) {
      _drawVolume(canvas, size, chartCandles, xFor, step);
    }
  }

  void _drawCandles(
    Canvas canvas,
    List<TradeCandle> source,
    double Function(int index) xFor,
    double Function(double value) yFor,
    double step,
  ) {
    final paint = Paint()..strokeWidth = 1;
    final bodyWidth = math.max(2.6, step * .48);

    for (var i = 0; i < source.length; i++) {
      final candle = source[i];
      final isUp = candle.close >= candle.open;
      final color = isUp ? AppColors.buy : AppColors.sell;
      final x = xFor(i);
      final highY = yFor(candle.high);
      final lowY = yFor(candle.low);
      final openY = yFor(candle.open);
      final closeY = yFor(candle.close);
      paint.color = color;
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);
      final top = math.min(openY, closeY);
      final height = math.max(2.2, (openY - closeY).abs());
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - bodyWidth / 2, top, bodyWidth, height),
          const Radius.circular(.8),
        ),
        paint..color = color.withValues(alpha: .88),
      );
    }
  }

  void _drawLineOrArea(
    Canvas canvas,
    List<TradeCandle> source,
    double Function(double value) yFor,
    double Function(int index) xFor,
    double chartBottom,
  ) {
    final path = Path();
    for (var i = 0; i < source.length; i++) {
      final offset = Offset(xFor(i), yFor(source[i].close));
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    if (chartType == 'area') {
      final area = Path.from(path)
        ..lineTo(xFor(source.length - 1), chartBottom)
        ..lineTo(xFor(0), chartBottom)
        ..close();
      canvas.drawPath(area, Paint()..color = _tradeBlue.withValues(alpha: .18));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _tradeBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
  }

  void _drawMovingAverages(
    Canvas canvas,
    List<TradeCandle> source,
    double Function(int index) xFor,
    double Function(double value) yFor,
  ) {
    for (final indicator in indicators) {
      if (!indicator.enabled || indicator.period == null) continue;
      if (!indicator.id.startsWith('ma')) continue;
      final period = indicator.period!;
      final path = Path();
      var started = false;
      for (var i = 0; i < source.length; i++) {
        final start = math.max(0, i - period + 1);
        final slice = source.sublist(start, i + 1);
        final average =
            slice.fold<double>(0, (sum, candle) => sum + candle.close) /
            slice.length;
        final offset = Offset(xFor(i), yFor(average));
        if (!started) {
          path.moveTo(offset.dx, offset.dy);
          started = true;
        } else {
          path.lineTo(offset.dx, offset.dy);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = Color(indicator.colorHex)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.25,
      );
    }
  }

  void _drawVolume(
    Canvas canvas,
    Size size,
    List<TradeCandle> source,
    double Function(int index) xFor,
    double step,
  ) {
    final maxVolume = source.map((candle) => candle.volume).reduce(math.max);
    const baseY = 111.0;
    const maxH = 27.0;
    final paint = Paint();
    for (var i = 0; i < source.length; i++) {
      final candle = source[i];
      final isUp = candle.close >= candle.open;
      final height = math.max(4.0, candle.volume / maxVolume * maxH);
      paint.color = (isUp ? AppColors.buy : AppColors.sell).withValues(
        alpha: .55,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          xFor(i) - step * .28,
          baseY - height,
          math.max(3.0, step * .55),
          height,
        ),
        paint,
      );
    }

    final tp = TextPainter(
      text: TextSpan(
        text: 'VOL',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.sell,
          fontSize: 9,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.width - tp.width - 6, 96));
  }

  List<TradeCandle> _expandedCandles(List<TradeCandle> source) {
    if (source.length < 2) return source;
    final expanded = <TradeCandle>[];
    var previousClose = source.first.open;
    for (var i = 0; i < source.length - 1; i++) {
      final current = source[i];
      final next = source[i + 1];
      for (var step = 0; step < 3; step++) {
        final t = step / 3;
        final close =
            current.close +
            (next.close - current.close) * t +
            math.sin((i * 3 + step) * .9) * 26;
        final open = previousClose;
        final high = math.max(open, close) + 46 + (step % 2) * 15;
        final low = math.min(open, close) - 42 - ((i + step) % 2) * 13;
        final volume =
            current.volume +
            (next.volume - current.volume) * t +
            ((i + step) % 4) * 180;
        expanded.add(
          TradeCandle(
            time: current.time,
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume,
          ),
        );
        previousClose = close;
      }
    }
    expanded.add(source.last);
    return expanded;
  }

  @override
  bool shouldRepaint(covariant _AdvancedTradeChartPainter oldDelegate) {
    return oldDelegate.chartType != chartType ||
        oldDelegate.indicators != indicators ||
        oldDelegate.candles != candles;
  }
}

String _formatRawPrice(double value) => value.toStringAsFixed(2);

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatPrice(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '${buffer.toString()}.${parts.last}';
}
