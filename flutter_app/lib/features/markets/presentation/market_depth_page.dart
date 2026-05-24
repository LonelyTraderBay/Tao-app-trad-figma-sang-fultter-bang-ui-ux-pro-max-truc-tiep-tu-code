import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/market_repository.dart';

const _marketPrimary = AppColors.primary;

class MarketDepthPage extends ConsumerStatefulWidget {
  const MarketDepthPage({
    super.key,
    this.pairId = 'btcusdt',
    this.backPath = AppRoutePaths.markets,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc019_market_depth_scroll_content');
  static const depthChartTabKey = Key('sc019_tab_depth_chart');
  static const orderBookTabKey = Key('sc019_tab_order_book');
  static const whaleAlertTabKey = Key('sc019_tab_whale_alert');

  static Key levelKey(int level) => Key('sc019_depth_level_$level');

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
        .watch(marketRepositoryProvider)
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
            _DepthTabs(
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
                      _PairSummary(pair: snapshot.pair),
                      if (_tab == 'depth') ...[
                        _DepthMiniStats(snapshot: snapshot),
                        _DepthChartCard(
                          snapshot: snapshot,
                          levels: _levels,
                          onLevelSelected: (level) => setState(() {
                            _levels = level;
                          }),
                        ),
                        _DepthRatioCard(depth: snapshot.depth),
                      ] else if (_tab == 'orderBook') ...[
                        _OrderBookHeader(pair: snapshot.pair),
                        _SectionHeader(
                          label: 'Lệnh bán (Ask)',
                          accentColor: AppColors.sell,
                        ),
                        _OrderBookRows(
                          levels: snapshot.depth.asks
                              .take(15)
                              .toList()
                              .reversed,
                          side: MarketOrderSide.sell,
                        ),
                        _MidPriceStrip(depth: snapshot.depth),
                        _SectionHeader(
                          label: 'Lệnh mua (Bid)',
                          accentColor: AppColors.buy,
                        ),
                        _OrderBookRows(
                          levels: snapshot.depth.bids.take(15).toList(),
                          side: MarketOrderSide.buy,
                        ),
                      ] else ...[
                        const _WhaleWarningCard(),
                        _SectionHeader(
                          label: 'Lệnh lớn gần đây',
                          accentColor: AppColors.warn,
                        ),
                        for (final order in snapshot.whaleOrders)
                          _WhaleOrderCard(
                            order: order,
                            baseAsset: snapshot.pair.baseAsset,
                          ),
                        _WhaleSummary(orders: snapshot.whaleOrders),
                      ],
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

class _DepthTabs extends StatelessWidget {
  const _DepthTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            _UnderlinedTab(
              key: MarketDepthPage.depthChartTabKey,
              label: 'Depth Chart',
              value: 'depth',
              active: activeTab == 'depth',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: MarketDepthPage.orderBookTabKey,
              label: 'Order Book',
              value: 'orderBook',
              active: activeTab == 'orderBook',
              onChanged: onChanged,
            ),
            _UnderlinedTab(
              key: MarketDepthPage.whaleAlertTabKey,
              label: 'Whale Alert',
              value: 'whale',
              active: activeTab == 'whale',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedTab extends StatelessWidget {
  const _UnderlinedTab({
    super.key,
    required this.label,
    required this.value,
    required this.active,
    required this.onChanged,
  });

  final String label;
  final String value;
  final bool active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketPrimary : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
              child: FractionallySizedBox(
                widthFactor: active ? 1 : 0,
                child: const ColoredBox(color: _marketPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PairSummary extends StatelessWidget {
  const _PairSummary({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pair.logoColor.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Text(
              pair.baseAsset.substring(0, 2),
              style: AppTextStyles.caption.copyWith(
                color: pair.logoColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair.symbol,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      positive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 12,
                      color: positive ? AppColors.buy : AppColors.sell,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${positive ? '+' : ''}${pair.change24h.toStringAsFixed(2)}%',
                      style: AppTextStyles.micro.copyWith(
                        color: positive ? AppColors.buy : AppColors.sell,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '\$${_formatPrice(pair.price)}',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
          ),
        ],
      ),
    );
  }
}

class _DepthMiniStats extends StatelessWidget {
  const _DepthMiniStats({required this.snapshot});

  final MarketDepthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final depth = snapshot.depth;
    return Row(
      children: [
        Expanded(
          child: _MiniStat(
            label: 'Spread',
            value: '\$${depth.spread.toStringAsFixed(2)}',
            sub: '${depth.spreadPct.toStringAsFixed(4)}%',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStat(
            label: 'Bid Wall',
            value: _formatQuantity(depth.totalBidQuantity),
            sub: snapshot.pair.baseAsset,
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MiniStat(
            label: 'Ask Wall',
            value: _formatQuantity(depth.totalAskQuantity),
            sub: snapshot.pair.baseAsset,
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.sub,
    this.color,
  });

  final String label;
  final String value;
  final String sub;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DepthChartCard extends StatelessWidget {
  const _DepthChartCard({
    required this.snapshot,
    required this.levels,
    required this.onLevelSelected,
  });

  final MarketDepthSnapshot snapshot;
  final int levels;
  final ValueChanged<int> onLevelSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Biểu đồ độ sâu',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              for (final level in snapshot.availableLevels) ...[
                _LevelChip(
                  key: MarketDepthPage.levelKey(level),
                  level: level,
                  active: levels == level,
                  onTap: () => onLevelSelected(level),
                ),
                if (level != snapshot.availableLevels.last)
                  const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(
              painter: _DepthChartPainter(depth: snapshot.depth),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.borderSolid),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LegendItem(label: 'Mua (Bid)', color: AppColors.buy),
              _LegendItem(label: 'Bán (Ask)', color: AppColors.sell),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    super.key,
    required this.level,
    required this.active,
    required this.onTap,
  });

  final int level;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? _marketPrimary.withValues(alpha: .16)
              : Colors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          '${level}L',
          style: AppTextStyles.micro.copyWith(
            color: active ? _marketPrimary : AppColors.text3,
            fontWeight: AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _DepthChartPainter extends CustomPainter {
  const _DepthChartPainter({required this.depth});

  final MarketDepthData depth;

  @override
  void paint(Canvas canvas, Size size) {
    final bids = depth.bids;
    final asks = depth.asks;
    if (bids.isEmpty || asks.isEmpty) return;

    const padding = 8.0;
    final chartHeight = size.height - padding * 2;
    final maxCumulative = math.max(bids.last.cumulative, asks.last.cumulative);
    final minPrice = bids.last.price;
    final maxPrice = asks.last.price;
    final priceRange = maxPrice - minPrice;
    final midX = ((depth.midPrice - minPrice) / priceRange) * size.width;

    Offset pointFor(MarketDepthLevel level) {
      final x = ((level.price - minPrice) / priceRange) * size.width;
      final y =
          size.height -
          padding -
          (level.cumulative / maxCumulative) * chartHeight;
      return Offset(x, y);
    }

    final bidPath = Path()..moveTo(midX, size.height - padding);
    for (var index = 0; index < bids.length; index += 1) {
      final point = pointFor(bids[index]);
      if (index == 0) {
        bidPath.lineTo(point.dx, point.dy);
      } else {
        final previous = pointFor(bids[index - 1]);
        bidPath
          ..lineTo(previous.dx, point.dy)
          ..lineTo(point.dx, point.dy);
      }
    }
    final lastBid = pointFor(bids.last);
    bidPath
      ..lineTo(lastBid.dx, size.height - padding)
      ..close();

    final bidFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x5910B981), Color(0x0D10B981)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(bidPath, bidFill);

    final askPath = Path()..moveTo(midX, size.height - padding);
    for (var index = 0; index < asks.length; index += 1) {
      final point = pointFor(asks[index]);
      if (index == 0) {
        askPath.lineTo(point.dx, point.dy);
      } else {
        final previous = pointFor(asks[index - 1]);
        askPath
          ..lineTo(previous.dx, point.dy)
          ..lineTo(point.dx, point.dy);
      }
    }
    final lastAsk = pointFor(asks.last);
    askPath
      ..lineTo(lastAsk.dx, size.height - padding)
      ..close();

    final askFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x59EF4444), Color(0x0DEF4444)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(askPath, askFill);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.square
      ..color = AppColors.buy;
    _drawSteppedLine(canvas, bids, pointFor, linePaint, midX, size.height);

    linePaint.color = AppColors.sell;
    _drawSteppedLine(canvas, asks, pointFor, linePaint, midX, size.height);

    final dashPaint = Paint()
      ..color = AppColors.sell
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    var y = padding;
    while (y < size.height - padding) {
      canvas.drawLine(Offset(midX, y), Offset(midX, y + 4), dashPaint);
      y += 8;
    }
  }

  void _drawSteppedLine(
    Canvas canvas,
    List<MarketDepthLevel> levels,
    Offset Function(MarketDepthLevel level) pointFor,
    Paint paint,
    double midX,
    double height,
  ) {
    final path = Path()..moveTo(midX, height - 8);
    for (var index = 0; index < levels.length; index += 1) {
      final point = pointFor(levels[index]);
      if (index == 0) {
        path.lineTo(point.dx, point.dy);
      } else {
        final previous = pointFor(levels[index - 1]);
        path
          ..lineTo(previous.dx, point.dy)
          ..lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DepthChartPainter oldDelegate) {
    return oldDelegate.depth != depth;
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .35),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _DepthRatioCard extends StatelessWidget {
  const _DepthRatioCard({required this.depth});

  final MarketDepthData depth;

  @override
  Widget build(BuildContext context) {
    final bidPct = depth.bidRatioPct;
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tỷ lệ tường mua/bán',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              width: double.infinity,
              height: 21,
              child: Row(
                children: [
                  Expanded(
                    flex: (bidPct * 10).round(),
                    child: Container(color: AppColors.buy),
                  ),
                  Expanded(
                    flex: ((100 - bidPct) * 10).round(),
                    child: Container(color: AppColors.sell),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Mua ${bidPct.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Bán ${(100 - bidPct).toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderBookHeader extends StatelessWidget {
  const _OrderBookHeader({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        children: [
          _HeaderCell('Giá (${pair.quoteAsset})'),
          _HeaderCell('Số lượng (${pair.baseAsset})', alignRight: true),
          const _HeaderCell('Tích lũy', alignRight: true),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.alignRight = false});

  final String text;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _OrderBookRows extends StatelessWidget {
  const _OrderBookRows({required this.levels, required this.side});

  final Iterable<MarketDepthLevel> levels;
  final MarketOrderSide side;

  @override
  Widget build(BuildContext context) {
    final list = levels.toList();
    final maxCumulative = list.fold<double>(
      0,
      (maxValue, level) => math.max(maxValue, level.cumulative),
    );
    final color = side == MarketOrderSide.buy ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          for (final level in list)
            _OrderBookRow(
              level: level,
              maxCumulative: maxCumulative,
              color: color,
            ),
        ],
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({
    required this.level,
    required this.maxCumulative,
    required this.color,
  });

  final MarketDepthLevel level;
  final double maxCumulative;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final barPct = maxCumulative == 0 ? 0.0 : level.cumulative / maxCumulative;
    return SizedBox(
      height: 28,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: barPct.clamp(0.0, 1.0),
              heightFactor: 1,
              child: ColoredBox(color: color.withValues(alpha: .08)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _BookCell(_formatPrice(level.price), color: color),
                _BookCell(_formatQuantity(level.quantity), alignRight: true),
                _BookCell(
                  _formatQuantity(level.cumulative),
                  alignRight: true,
                  color: AppColors.text3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCell extends StatelessWidget {
  const _BookCell(this.text, {this.color, this.alignRight = false});

  final String text;
  final Color? color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.caption.copyWith(
          color: color ?? AppColors.text1,
          fontSize: 12,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _MidPriceStrip extends StatelessWidget {
  const _MidPriceStrip({required this.depth});

  final MarketDepthData depth;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.caption,
          children: [
            TextSpan(
              text: '\$${_formatPrice(depth.midPrice)}',
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
            TextSpan(
              text: '   Spread: ${depth.spreadPct.toStringAsFixed(4)}%',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhaleWarningCard extends StatelessWidget {
  const _WhaleWarningCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo cá voi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Các lệnh lớn bất thường trong sổ lệnh BTC/USDT. Không phải tín hiệu giao dịch, chỉ mang tính tham khảo.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.45,
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

class _WhaleOrderCard extends StatelessWidget {
  const _WhaleOrderCard({required this.order, required this.baseAsset});

  final MarketWhaleOrder order;
  final String baseAsset;

  @override
  Widget build(BuildContext context) {
    final buy = order.side == MarketOrderSide.buy;
    final color = buy ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: AppRadii.mdRadius,
            ),
            child: const Icon(Icons.waves_rounded, color: AppColors.text2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .12),
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: Text(
                        buy ? 'MUA' : 'BÁN',
                        style: AppTextStyles.micro.copyWith(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.timeAgo,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${order.quantity.toStringAsFixed(4)} $baseAsset',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@ \$${_formatPrice(order.price)}  ≈ ${_formatCompact(order.usdValue, prefix: r'$')}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhaleSummary extends StatelessWidget {
  const _WhaleSummary({required this.orders});

  final List<MarketWhaleOrder> orders;

  @override
  Widget build(BuildContext context) {
    final buyOrders = [
      for (final order in orders)
        if (order.side == MarketOrderSide.buy) order,
    ];
    final sellOrders = [
      for (final order in orders)
        if (order.side == MarketOrderSide.sell) order,
    ];
    return Row(
      children: [
        Expanded(
          child: _WhaleSummaryCard(
            count: buyOrders.length,
            label: 'Lệnh mua lớn',
            total: buyOrders.fold<double>(
              0,
              (sum, order) => sum + order.usdValue,
            ),
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _WhaleSummaryCard(
            count: sellOrders.length,
            label: 'Lệnh bán lớn',
            total: sellOrders.fold<double>(
              0,
              (sum, order) => sum + order.usdValue,
            ),
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _WhaleSummaryCard extends StatelessWidget {
  const _WhaleSummaryCard({
    required this.count,
    required this.label,
    required this.total,
    required this.color,
  });

  final int count;
  final String label;
  final double total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            '$count',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 2),
          Text(
            _formatCompact(total, prefix: r'$'),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatPrice(double value) {
  final fixed = value >= 1000
      ? value.toStringAsFixed(2)
      : value.toStringAsFixed(4);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    final fromEnd = whole.length - index;
    buffer.write(whole[index]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String _formatQuantity(double value) {
  if (value >= 100) return value.toStringAsFixed(0);
  if (value >= 10) return value.toStringAsFixed(2);
  return value.toStringAsFixed(3);
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000000) {
    return '$prefix${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (abs >= 1000000) return '$prefix${(value / 1000000).toStringAsFixed(2)}M';
  if (abs >= 1000) return '$prefix${(value / 1000).toStringAsFixed(2)}K';
  return '$prefix${value.toStringAsFixed(2)}';
}
