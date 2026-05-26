import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';

const _marketPrimary = AppColors.primary;
const _sectorPurple = Color(0xFF8B5CF6);
const _btcOrange = Color(0xFFF7931A);
const _ethPrimary = Color(0xFF627EEA);

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
    final snapshot = ref.watch(marketRepositoryProvider).getMarketOverview();
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
        child: Column(
          children: [
            VitHeader(
              title: 'Tổng quan thị trường',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.markets),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
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

class _MarketCapHero extends StatelessWidget {
  const _MarketCapHero({required this.stats});

  final GlobalMarketStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface2, AppColors.surface, AppColors.bg],
          stops: [0, 0.55, 1],
        ),
        border: Border.all(color: _marketPrimary.withValues(alpha: 0.24)),
        borderRadius: AppRadii.cardLargeRadius,
        boxShadow: [
          BoxShadow(
            color: _marketPrimary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.language_rounded,
                color: _marketPrimary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Tổng vốn hóa thị trường',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  _formatCompact(stats.totalMarketCap, prefix: r'$'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heroNumber.copyWith(
                    fontSize: 26,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _ChangePill(value: stats.totalMarketCapChange24h),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'BTC Dominance',
                  value: '${stats.btcDominance.toStringAsFixed(1)}%',
                  valueColor: _btcOrange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroMetric(
                  label: 'ETH Dominance',
                  value: '${stats.ethDominance.toStringAsFixed(1)}%',
                  valueColor: _ethPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroMetric(
                  label: 'KL 24h',
                  value: _formatCompact(stats.total24hVolume, prefix: r'$'),
                  valueColor: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final GlobalMarketStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'DeFi TVL',
                value: _formatCompact(stats.defiTVL, prefix: r'$'),
                change: stats.defiTVLChange24h,
                icon: Icons.layers_rounded,
                color: _sectorPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Stablecoin Vol',
                value: _formatCompact(stats.stablecoinVolume24h, prefix: r'$'),
                icon: Icons.monitor_heart_outlined,
                color: _marketPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Tổng coin',
                value: _formatInt(stats.totalCoins),
                icon: Icons.pie_chart_outline_rounded,
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Sàn giao dịch',
                value: _formatInt(stats.totalExchanges),
                icon: Icons.bar_chart_rounded,
                color: AppColors.primarySoft,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.change,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double? change;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 96,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBubble(icon: icon, color: color, size: 24, iconSize: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1.1,
            ),
          ),
          if (change != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  change! >= 0
                      ? Icons.arrow_outward_rounded
                      : Icons.south_east_rounded,
                  color: change! >= 0 ? AppColors.buy : AppColors.sell,
                  size: 12,
                ),
                const SizedBox(width: 3),
                Text(
                  _formatSignedPercent(change!),
                  style: AppTextStyles.micro.copyWith(
                    color: change! >= 0 ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SentimentGrid extends StatelessWidget {
  const _SentimentGrid({required this.stats, required this.breadth});

  final GlobalMarketStats stats;
  final MarketBreadth breadth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: VitCard(
            height: 183,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _MiniHeader(
                  icon: Icons.speed_rounded,
                  color: AppColors.primarySoft,
                  label: 'Fear & Greed',
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _FearGreedGauge(
                    value: stats.fearGreedIndex,
                    label: stats.fearGreedLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: VitCard(
            height: 183,
            padding: const EdgeInsets.all(16),
            child: _MarketBreadthCard(breadth: breadth),
          ),
        ),
      ],
    );
  }
}

class _MarketBreadthCard extends StatelessWidget {
  const _MarketBreadthCard({required this.breadth});

  final MarketBreadth breadth;

  @override
  Widget build(BuildContext context) {
    final total = breadth.advancing + breadth.declining;
    final advancingPct = total == 0 ? 0.0 : breadth.advancing / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MiniHeader(
          icon: Icons.gps_fixed_rounded,
          color: _marketPrimary,
          label: 'Biến động thị trường',
        ),
        const SizedBox(height: 16),
        _BreadthLine(
          label: 'Tăng',
          value: breadth.advancing,
          color: AppColors.buy,
        ),
        const SizedBox(height: 9),
        _BreadthLine(
          label: 'Giảm',
          value: breadth.declining,
          color: AppColors.sell,
        ),
        const SizedBox(height: 13),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Row(
              children: [
                Expanded(
                  flex: (advancingPct * 1000).round(),
                  child: const ColoredBox(color: AppColors.buy),
                ),
                Expanded(
                  flex: ((1 - advancingPct) * 1000).round(),
                  child: const ColoredBox(color: AppColors.sell),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                '${breadth.newATH} ATH mới',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${breadth.dropping10Pct} giảm >10%',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.sell,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BreadthLine extends StatelessWidget {
  const _BreadthLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1,
            ),
          ),
        ),
        Text(
          _formatInt(value),
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _FearGreedGauge extends StatelessWidget {
  const _FearGreedGauge({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = _fearGreedColor(value);
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 64,
          child: CustomPaint(painter: _FearGreedGaugePainter(value: value)),
        ),
        const Spacer(),
        Text(
          '$value',
          style: AppTextStyles.heroNumber.copyWith(
            color: color,
            fontSize: 27,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _FearGreedGaugePainter extends CustomPainter {
  const _FearGreedGaugePainter({required this.value});

  final int value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 4);
    final radius = size.width / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final shader = const SweepGradient(
      startAngle: math.pi,
      endAngle: math.pi * 2,
      colors: [
        AppColors.sell,
        AppColors.primarySoft,
        Color(0xFF6B7280),
        AppColors.buy,
        Color(0xFF059669),
      ],
    ).createShader(rect);

    final basePaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.25);
    final progressPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi, math.pi, false, basePaint);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * (value.clamp(0, 100) / 100),
      false,
      progressPaint,
    );

    final needleColor = _fearGreedColor(value);
    final angle = ((value.clamp(0, 100) / 100) * 180 - 90) * math.pi / 180;
    final needleEnd = Offset(
      center.dx + math.cos(angle) * (radius - 12),
      center.dy + math.sin(angle) * (radius - 12),
    );
    final needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 4, Paint()..color = needleColor);
  }

  @override
  bool shouldRepaint(covariant _FearGreedGaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

class _QuickNavigation extends StatelessWidget {
  const _QuickNavigation();

  @override
  Widget build(BuildContext context) {
    const items = [
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickMoversKey,
        label: 'Biến động',
        icon: Icons.trending_up_rounded,
        color: AppColors.buy,
        route: '/markets/movers',
      ),
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickSectorsKey,
        label: 'Ngành',
        icon: Icons.layers_rounded,
        color: _sectorPurple,
        route: '/markets/sectors',
      ),
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickHeatmapKey,
        label: 'Heatmap',
        icon: Icons.bar_chart_rounded,
        color: _marketPrimary,
        route: '/markets/heatmap',
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(child: items[i]),
          if (i < items.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _QuickNavItem extends StatelessWidget {
  const _QuickNavItem({
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  }) : super(key: buttonKey);

  final Key buttonKey;
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 90,
      padding: const EdgeInsets.all(12),
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _IconBubble(icon: icon, color: color, size: 40, iconSize: 18),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoversGrid extends StatelessWidget {
  const _MoversGrid({required this.movers});

  final List<MarketMover> movers;

  @override
  Widget build(BuildContext context) {
    final gainers = movers.where((mover) => mover.change24h > 0).toList()
      ..sort((a, b) => b.change24h.compareTo(a.change24h));
    final losers = movers.where((mover) => mover.change24h < 0).toList()
      ..sort((a, b) => a.change24h.compareTo(b.change24h));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MoverListCard(
            title: 'Tăng mạnh',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            movers: gainers.take(5).toList(),
            headerKey: MarketOverviewPage.topGainersKey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MoverListCard(
            title: 'Giảm mạnh',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            movers: losers.take(5).toList(),
            headerKey: MarketOverviewPage.topLosersKey,
          ),
        ),
      ],
    );
  }
}

class _MoverListCard extends StatelessWidget {
  const _MoverListCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.movers,
    required this.headerKey,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<MarketMover> movers;
  final Key headerKey;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 272,
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 11),
      child: Column(
        children: [
          InkWell(
            key: headerKey,
            onTap: () => context.go('/markets/movers'),
            borderRadius: AppRadii.smRadius,
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final mover in movers) ...[
            _QuickMoverRow(mover: mover),
            if (mover != movers.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _QuickMoverRow extends StatelessWidget {
  const _QuickMoverRow({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    final positive = mover.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: mover.color.withValues(alpha: 0.18),
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            mover.symbol.substring(0, math.min(3, mover.symbol.length)),
            style: AppTextStyles.micro.copyWith(
              color: mover.color,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            mover.symbol,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 3),
        SizedBox(
          width: 34,
          child: Text(
            _formatPrice(mover.price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 58,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: positive ? AppColors.buy15 : AppColors.sell15,
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            _formatSignedPercent(mover.change24h),
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectorPerformance extends StatelessWidget {
  const _SectorPerformance({required this.sectors});

  final List<MarketSector> sectors;

  @override
  Widget build(BuildContext context) {
    final topSectors = [...sectors]
      ..sort((a, b) => b.change24h.compareTo(a.change24h));

    return VitPageSection(
      label: 'Hiệu suất ngành',
      accentColor: _sectorPurple,
      children: [
        VitCard(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final sector in topSectors.take(5))
                _SectorRow(
                  key: Key('sc009_sector_${sector.id}'),
                  sector: sector,
                  onTap: () => context.go('/markets/sectors?id=${sector.id}'),
                ),
              InkWell(
                key: MarketOverviewPage.allSectorsKey,
                onTap: () => context.go('/markets/sectors'),
                borderRadius: AppRadii.smRadius,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Xem tất cả ngành',
                        style: AppTextStyles.caption.copyWith(
                          color: _marketPrimary,
                          fontWeight: AppTextStyles.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: _marketPrimary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectorRow extends StatelessWidget {
  const _SectorRow({super.key, required this.sector, required this.onTap});

  final MarketSector sector;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = sector.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 61,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            _IconBubble(
              icon: sector.icon,
              color: sector.color,
              size: 36,
              iconSize: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sector.nameVi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${sector.coinCount} coins',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatSignedPercent(sector.change24h),
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatCompact(sector.totalMarketCap, prefix: r'$'),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 7),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _FearGreedHistory extends StatelessWidget {
  const _FearGreedHistory({required this.points});

  final List<FearGreedPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Lịch sử Fear & Greed (7 ngày)',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          height: 128,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < points.length; i++) ...[
                      Expanded(
                        child: _HistoryBar(
                          point: points[i],
                          active: i == points.length - 1,
                        ),
                      ),
                      if (i < points.length - 1) const SizedBox(width: 4),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '7 ngày trước',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 8,
                      height: 1,
                    ),
                  ),
                  Text(
                    'Hôm nay',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 8,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryBar extends StatelessWidget {
  const _HistoryBar({required this.point, required this.active});

  final FearGreedPoint point;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final height = point.value / 100 * 64;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${point.value}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 8,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: _fearGreedColor(
              point.value,
            ).withValues(alpha: active ? 1 : 0.62),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
          ),
        ),
      ],
    );
  }
}

class _MarketTools extends StatelessWidget {
  const _MarketTools();

  @override
  Widget build(BuildContext context) {
    const tools = [
      _MarketTool(
        buttonKey: MarketOverviewPage.watchlistToolKey,
        label: 'Danh sách theo dõi',
        icon: Icons.star_rounded,
        color: AppColors.primarySoft,
        route: '/markets/watchlist',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.alertsToolKey,
        label: 'Cảnh báo giá',
        icon: Icons.notifications_rounded,
        color: AppColors.primarySoft,
        route: '/markets/alerts',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.heatmapToolKey,
        label: 'Biểu đồ nhiệt',
        icon: Icons.map_rounded,
        color: Color(0xFF06B6D4),
        route: '/markets/heatmap',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.marketListToolKey,
        label: 'Danh sách thị trường',
        icon: Icons.article_rounded,
        color: Color(0xFFF59E0B),
        route: AppRoutePaths.markets,
      ),
    ];

    return VitPageSection(
      label: 'Công cụ thị trường',
      accentColor: _marketPrimary,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(child: tools[0]),
                const SizedBox(width: 8),
                Expanded(child: tools[1]),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: tools[2]),
                const SizedBox(width: 8),
                Expanded(child: tools[3]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MarketTool extends StatelessWidget {
  const _MarketTool({
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  }) : super(key: buttonKey);

  final Key buttonKey;
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: () => context.go(route),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: AppTextStyles.bold,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniHeader extends StatelessWidget {
  const _MiniHeader({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(size / 3.2),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class _ChangePill extends StatelessWidget {
  const _ChangePill({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        '${positive ? '▲' : '▼'} ${value.abs().toStringAsFixed(2)}%',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

Color _fearGreedColor(int value) {
  if (value <= 25) return AppColors.sell;
  if (value <= 45) return AppColors.primarySoft;
  if (value <= 55) return const Color(0xFF6B7280);
  if (value <= 75) return AppColors.buy;
  return const Color(0xFF059669);
}

String _formatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${_formatFixed(value / 1000000000, 2)}B';
  }
  if (value >= 1000000) {
    return '$prefix${_formatFixed(value / 1000000, 2)}M';
  }
  if (value >= 1000) {
    return '$prefix${_formatFixed(value / 1000, 2)}K';
  }
  return '$prefix${_formatFixed(value, 2)}';
}

String _formatPrice(double value) {
  if (value >= 1) {
    return _formatFixed(value, 2);
  }
  if (value >= 0.01) {
    return _formatFixed(value, 4);
  }
  return _formatFixed(value, 6);
}

String _formatFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
