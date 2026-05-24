import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2POrderBookPage extends ConsumerStatefulWidget {
  const P2POrderBookPage({super.key, this.shellRenderMode});

  static const assetRailKey = Key('sc273_p2p_order_book_assets');
  static const tickerKey = Key('sc273_p2p_order_book_ticker');
  static const refreshKey = Key('sc273_p2p_order_book_refresh');
  static const depthChartKey = Key('sc273_p2p_order_book_depth_chart');
  static const bestPricesKey = Key('sc273_p2p_order_book_best_prices');
  static const orderListsKey = Key('sc273_p2p_order_book_lists');

  static Key assetKey(String asset) => Key('sc273_p2p_order_book_asset_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderBookPage> createState() => _P2POrderBookPageState();
}

class _P2POrderBookPageState extends ConsumerState<P2POrderBookPage> {
  String _selectedAsset = 'USDT';
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getOrderBook(selectedAsset: _selectedAsset);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-273 P2POrderBookPage',
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
                      _AssetSelector(
                        snapshot: snapshot,
                        selectedAsset: _selectedAsset,
                        onChanged: (asset) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedAsset = asset);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _MarketTicker(
                        snapshot: snapshot,
                        isRefreshing: _isRefreshing,
                        onRefresh: _refresh,
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _DepthChartCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _BestPriceCards(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _OrderBookLists(snapshot: snapshot),
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

  Future<void> _refresh() async {
    if (_isRefreshing) return;
    HapticFeedback.mediumImpact();
    setState(() => _isRefreshing = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isRefreshing = false);
  }
}

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({
    required this.snapshot,
    required this.selectedAsset,
    required this.onChanged,
  });

  final P2POrderBookSnapshot snapshot;
  final String selectedAsset;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: P2POrderBookPage.assetRailKey,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final market in snapshot.markets) ...[
            _AssetChip(
              market: market,
              selected: market.asset == selectedAsset,
              onTap: () => onChanged(market.asset),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _AssetChip extends StatelessWidget {
  const _AssetChip({
    required this.market,
    required this.selected,
    required this.onTap,
  });

  final P2POrderBookMarketDraft market;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = market.changePct >= 0 ? AppColors.buy : AppColors.sell;
    return Material(
      key: P2POrderBookPage.assetKey(market.asset),
      color: selected ? AppColors.warn10 : AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: Container(
          constraints: const BoxConstraints(minWidth: 110, minHeight: 64),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadii.cardRadius,
            border: Border.all(
              width: selected ? 1.5 : 1,
              color: selected ? AppModuleAccents.p2p : AppColors.borderSolid,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${market.asset}/VND',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                _formatChange(market.changePct),
                style: AppTextStyles.micro.copyWith(
                  color: tone,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketTicker extends StatelessWidget {
  const _MarketTicker({
    required this.snapshot,
    required this.isRefreshing,
    required this.onRefresh,
  });

  final P2POrderBookSnapshot snapshot;
  final bool isRefreshing;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final market = snapshot.selectedAsset;
    final tone = market.changePct >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: P2POrderBookPage.tickerKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '${market.asset}/VND',
                style: AppTextStyles.pageTitle.copyWith(
                  fontSize: 24,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _ChangePill(value: market.changePct),
              const Spacer(),
              Material(
                key: P2POrderBookPage.refreshKey,
                color: AppColors.surface2,
                borderRadius: AppRadii.inputRadius,
                child: InkWell(
                  onTap: onRefresh,
                  borderRadius: AppRadii.inputRadius,
                  child: SizedBox(
                    width: AppSpacing.buttonCompact,
                    height: AppSpacing.buttonCompact,
                    child: AnimatedRotation(
                      turns: isRefreshing ? 1 : 0,
                      duration: const Duration(milliseconds: 600),
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.text2,
                        size: AppSpacing.iconSm,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _TickerMetric(
                  label: 'Giá hiện tại',
                  value: _formatVnd(market.lastPriceVnd),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: '24h High',
                  value: _formatVnd(market.high24hVnd),
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: '24h Low',
                  value: _formatVnd(market.low24hVnd),
                  color: AppColors.sell,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _TickerMetric(
                  label: 'Volume 24h',
                  value: market.volume24hLabel,
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: 'Lệnh 24h',
                  value: _formatWhole(market.trades24h),
                  color: AppColors.text1,
                ),
              ),
              Expanded(
                child: _TickerMetric(
                  label: 'Spread',
                  value: '${snapshot.spreadPercent.toStringAsFixed(3)}%',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              market.changePct >= 0
                  ? 'Thanh khoản đang tăng nhẹ'
                  : 'Biến động cần theo dõi',
              style: AppTextStyles.micro.copyWith(color: tone),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePill extends StatelessWidget {
  const _ChangePill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final tone = value >= 0 ? AppColors.buy : AppColors.sell;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.withValues(alpha: .12),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          children: [
            Icon(
              value >= 0
                  ? Icons.arrow_outward_rounded
                  : Icons.south_east_rounded,
              color: tone,
              size: 11,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              _formatChange(value),
              style: AppTextStyles.micro.copyWith(
                color: tone,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TickerMetric extends StatelessWidget {
  const _TickerMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _DepthChartCard extends StatelessWidget {
  const _DepthChartCard({required this.snapshot});

  final P2POrderBookSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2POrderBookPage.depthChartKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Biểu đồ độ sâu',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const _LegendDot(color: AppColors.buy, label: 'Mua'),
              const SizedBox(width: AppSpacing.x3),
              const _LegendDot(color: AppColors.sell, label: 'Bán'),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 180,
            child: CustomPaint(painter: _DepthChartPainter(snapshot)),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.xsRadius,
          ),
          child: const SizedBox(width: 12, height: 12),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _BestPriceCards extends StatelessWidget {
  const _BestPriceCards({required this.snapshot});

  final P2POrderBookSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2POrderBookPage.bestPricesKey,
      children: [
        Expanded(
          child: _BestPriceCard(
            title: 'BID CAO NHẤT',
            icon: Icons.trending_up_rounded,
            entry: snapshot.bestBid,
            asset: snapshot.selectedAsset.asset,
            tone: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _BestPriceCard(
            title: 'ASK THẤP NHẤT',
            icon: Icons.trending_down_rounded,
            entry: snapshot.bestAsk,
            asset: snapshot.selectedAsset.asset,
            tone: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _BestPriceCard extends StatelessWidget {
  const _BestPriceCard({
    required this.title,
    required this.icon,
    required this.entry,
    required this.asset,
    required this.tone,
  });

  final String title;
  final IconData icon;
  final P2POrderBookEntryDraft entry;
  final String asset;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      variant: VitCardVariant.inner,
      borderColor: tone.withValues(alpha: .28),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: tone, size: 14),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: tone,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            _formatVnd(entry.priceVnd),
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _MiniLine(
            label: 'Volume',
            value: '${_formatVolume(entry.volume)} $asset',
          ),
          const SizedBox(height: AppSpacing.x2),
          _MiniLine(label: 'Lệnh', value: '${entry.orders}'),
        ],
      ),
    );
  }
}

class _MiniLine extends StatelessWidget {
  const _MiniLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderBookLists extends StatelessWidget {
  const _OrderBookLists({required this.snapshot});

  final P2POrderBookSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2POrderBookPage.orderListsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _OrderBookSide(
            title: 'MUA (BID)',
            entries: snapshot.bids,
            maxTotal: snapshot.maxTotal,
            tone: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _OrderBookSide(
            title: 'BÁN (ASK)',
            entries: snapshot.asks,
            maxTotal: snapshot.maxTotal,
            tone: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _OrderBookSide extends StatelessWidget {
  const _OrderBookSide({
    required this.title,
    required this.entries,
    required this.maxTotal,
    required this.tone,
  });

  final String title;
  final List<P2POrderBookEntryDraft> entries;
  final double maxTotal;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: tone,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final entry in entries)
            _OrderBookRow(entry: entry, maxTotal: maxTotal, tone: tone),
        ],
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({
    required this.entry,
    required this.maxTotal,
    required this.tone,
  });

  final P2POrderBookEntryDraft entry;
  final double maxTotal;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final widthFactor = (entry.total / maxTotal).clamp(.08, 1.0).toDouble();
    return SizedBox(
      height: 24,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: .08),
                  borderRadius: AppRadii.xsRadius,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
            child: Row(
              children: [
                Text(
                  _formatBookPrice(entry.priceVnd),
                  style: AppTextStyles.micro.copyWith(
                    color: tone,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatVolume(entry.volume),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
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

class _DepthChartPainter extends CustomPainter {
  const _DepthChartPainter(this.snapshot);

  final P2POrderBookSnapshot snapshot;

  @override
  void paint(Canvas canvas, Size size) {
    const chartTop = 12.0;
    const chartLeft = 38.0;
    const chartRight = 8.0;
    const chartBottom = 28.0;
    final chartHeight = size.height - chartTop - chartBottom;
    final chartWidth = size.width - chartLeft - chartRight;
    final origin = Offset(chartLeft, chartTop + chartHeight);
    final axisPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .25)
      ..strokeWidth = .7;

    canvas.drawLine(Offset(chartLeft, chartTop), origin, axisPaint);
    canvas.drawLine(
      origin,
      Offset(size.width - chartRight, origin.dy),
      axisPaint,
    );

    const maxAxis = 3200.0;
    final ticks = <double>[0, 800, 1600, 2400, 3200];
    for (final tick in ticks) {
      final y = origin.dy - chartHeight * (tick / maxAxis);
      if (tick > 0) {
        canvas.drawLine(
          Offset(chartLeft, y),
          Offset(size.width - chartRight, y),
          gridPaint,
        );
      }
      _paintText(
        canvas,
        _formatAxis(tick),
        Offset(0, y - 7),
        AppColors.text3,
        9,
        width: chartLeft - 6,
        align: TextAlign.right,
      );
    }

    final entries = [...snapshot.bids.reversed, ...snapshot.asks];
    final totalBars = entries.length;
    final gap = 4.0;
    final barWidth = (chartWidth - gap * (totalBars - 1)) / totalBars;

    for (var index = 0; index < entries.length; index++) {
      final entry = entries[index];
      final color = index < snapshot.bids.length
          ? AppColors.buy
          : AppColors.sell;
      final height = math.max(4.0, chartHeight * (entry.total / maxAxis));
      final left = chartLeft + index * (barWidth + gap);
      final top = origin.dy - height;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, height),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, Paint()..color = color);
    }

    final labels = ['25.0k', '25.1k', '25.2k', '25.4k', '25.5k', '25.6k'];
    for (var i = 0; i < labels.length; i++) {
      final x = chartLeft + (chartWidth / (labels.length - 1)) * i;
      _paintText(
        canvas,
        labels[i],
        Offset(x - 16, origin.dy + 7),
        AppColors.text3,
        9,
        width: 36,
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DepthChartPainter oldDelegate) {
    return oldDelegate.snapshot.selectedAsset.asset !=
        snapshot.selectedAsset.asset;
  }
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  Color color,
  double size, {
  double? width,
  TextAlign align = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w500,
      ),
    ),
    textAlign: align,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width ?? double.infinity);
  painter.paint(canvas, offset);
}

String _formatChange(double value) {
  final prefix = value >= 0 ? '+' : '';
  return '$prefix${value.toStringAsFixed(2)}%';
}

String _formatVnd(double value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}B';
  }
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
  }

  final hasDecimal = value % 1 != 0;
  final whole = value.floor().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  if (hasDecimal) {
    final decimal = ((value - value.floor()) * 10).round();
    return '${buffer.toString()},$decimal';
  }
  return buffer.toString();
}

String _formatWhole(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}

String _formatBookPrice(double value) => (value / 1000).toStringAsFixed(2);

String _formatVolume(double value) => value.toStringAsFixed(4);

String _formatAxis(double value) {
  if (value == 0) return '0';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
