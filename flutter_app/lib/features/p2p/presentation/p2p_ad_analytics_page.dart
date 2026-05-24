import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
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
    final snapshot = ref.watch(p2pRepositoryProvider).getAdAnalytics(adId);
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
        child: Column(
          children: [
            VitHeader(
              title: 'Phân tích quảng cáo',
              subtitle: 'Phân tích · P2P',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
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
    );
  }
}

class _AdIdentityCard extends StatelessWidget {
  const _AdIdentityCard({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final typeColor = snapshot.tradeType == P2PTradeType.sell
        ? AppColors.sell
        : AppColors.buy;
    final typeLabel = snapshot.tradeType == P2PTradeType.sell ? 'BÁN' : 'MUA';

    return VitCard(
      height: AppSpacing.x7 + AppSpacing.x3,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Text(
                '$typeLabel ${snapshot.asset}',
                style: AppTextStyles.micro.copyWith(
                  color: typeColor,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    _formatVnd(snapshot.priceVnd),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFamily: 'Roboto',
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  snapshot.currency,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.warn10,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    color: AppColors.warn,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    '#${snapshot.ranking}/${snapshot.totalActiveAds}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiItem(
        icon: Icons.visibility_outlined,
        label: 'Lượt xem',
        value: _formatCount(snapshot.impressions),
        subtitle: '7 ngày qua',
        color: AppColors.accent,
      ),
      _KpiItem(
        icon: Icons.ads_click_rounded,
        label: 'Lượt click',
        value: _formatCount(snapshot.clicks),
        subtitle:
            'CTR ${_fixed(snapshot.clicks / snapshot.impressions * 100)}%',
        color: AppModuleAccents.p2p,
      ),
      _KpiItem(
        icon: Icons.shopping_cart_outlined,
        label: 'Đơn tạo',
        value: _formatCount(snapshot.ordersCreated),
        subtitle: 'CVR ${_fixed(snapshot.conversionRate)}%',
        color: AppColors.warn,
      ),
      _KpiItem(
        icon: Icons.check_circle_outline_rounded,
        label: 'Hoàn thành',
        value: _formatCount(snapshot.ordersCompleted),
        subtitle: '${_fixed(snapshot.completionRate)}% tỷ lệ HT',
        color: AppColors.buy,
      ),
      _KpiItem(
        icon: Icons.trending_up_rounded,
        label: 'Tổng volume',
        value: _formatCompactVnd(snapshot.totalVolume),
        subtitle: 'TB ${_formatCompactVnd(snapshot.avgOrderValue)}/đơn',
        color: AppColors.accent,
      ),
      _KpiItem(
        icon: Icons.bolt_rounded,
        label: 'Doanh thu',
        value: _formatCompactVnd(snapshot.totalRevenue),
        subtitle: 'phí + spread',
        color: AppColors.buy,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < cards.length; i += 2) ...[
          Row(
            children: [
              Expanded(child: _MetricCard(item: cards[i])),
              const SizedBox(width: AppSpacing.x3),
              Expanded(child: _MetricCard(item: cards[i + 1])),
            ],
          ),
          if (i < cards.length - 2) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _KpiItem {
  const _KpiItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.item});

  final _KpiItem item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.buttonHero + AppSpacing.x4 + AppSpacing.x1,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: .12),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: AppSpacing.iconSm,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontSize: 19,
              fontFamily: 'Roboto',
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickStat(
        Icons.schedule_rounded,
        '${snapshot.avgResponseTimeSeconds}s',
        'Phản hồi',
        AppColors.accent,
      ),
      _QuickStat(
        Icons.monitor_heart_outlined,
        '${snapshot.avgCompletionMinutes}m',
        'HT TB',
        AppColors.buy,
      ),
      _QuickStat(
        Icons.star_border_rounded,
        _fixed(snapshot.rating),
        'Rating',
        AppColors.warn,
      ),
      _QuickStat(
        Icons.group_outlined,
        '${snapshot.reviewsCount}',
        'Reviews',
        AppColors.accent,
      ),
    ];

    return VitCard(
      height: AppSpacing.x7 + AppSpacing.x6,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(child: _QuickStatView(item: items[i])),
            if (i < items.length - 1) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _QuickStat {
  const _QuickStat(this.icon, this.value, this.label, this.color);

  final IconData icon;
  final String value;
  final String label;
  final Color color;
}

class _QuickStatView extends StatelessWidget {
  const _QuickStatView({required this.item});

  final _QuickStat item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(item.icon, color: item.color, size: AppSpacing.iconSm),
        const SizedBox(height: AppSpacing.x2),
        Text(
          item.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFamily: 'Roboto',
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

class _ConversionFunnel extends StatelessWidget {
  const _ConversionFunnel({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final base = snapshot.impressions;
    final stages = [
      _FunnelStage('Lượt xem', snapshot.impressions, 100, AppColors.accent),
      _FunnelStage(
        'Lượt click',
        snapshot.clicks,
        snapshot.clicks / base * 100,
        AppColors.primary,
      ),
      _FunnelStage(
        'Đơn tạo',
        snapshot.ordersCreated,
        snapshot.ordersCreated / base * 100,
        AppColors.warn,
      ),
      _FunnelStage(
        'Hoàn thành',
        snapshot.ordersCompleted,
        snapshot.ordersCompleted / base * 100,
        AppColors.buy,
      ),
    ];

    return VitCard(
      key: P2PAdAnalyticsPage.funnelKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Phễu chuyển đổi',
            color: AppColors.accent,
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < stages.length; i++) ...[
            _FunnelBar(stage: stages[i], showPct: i > 0),
            if (i < stages.length - 1) const SizedBox(height: AppSpacing.x3),
          ],
          const SizedBox(height: AppSpacing.x4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _SmallInlineStat(
                  icon: Icons.cancel_outlined,
                  label: 'Hủy: ${snapshot.ordersCancelled}',
                  color: AppColors.sell,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _SmallInlineStat(
                    icon: Icons.warning_amber_rounded,
                    label: 'Tranh chấp: ${snapshot.ordersDisputed}',
                    color: AppColors.warn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FunnelStage {
  const _FunnelStage(this.label, this.value, this.percent, this.color);

  final String label;
  final int value;
  final double percent;
  final Color color;
}

class _FunnelBar extends StatelessWidget {
  const _FunnelBar({required this.stage, required this.showPct});

  final _FunnelStage stage;
  final bool showPct;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                stage.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              _formatCount(stage.value),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            if (showPct) ...[
              const SizedBox(width: AppSpacing.x3),
              Text(
                '${_fixed(stage.percent)}%',
                style: AppTextStyles.micro.copyWith(
                  color: stage.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.smRadius,
          child: LinearProgressIndicator(
            value: stage.percent.clamp(0, 100) / 100,
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(stage.color),
          ),
        ),
      ],
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.trending_up_rounded,
            title: 'Hiệu suất 7 ngày',
            color: AppColors.buy,
          ),
          Text(
            'Lượt xem & Đơn hàng theo ngày',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.buttonHero * 2,
            child: CustomPaint(
              painter: _PerformanceLinePainter(snapshot.dailyPerformance),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: AppColors.accent, label: 'Lượt xem'),
              SizedBox(width: AppSpacing.x5),
              _LegendDot(color: AppColors.buy, label: 'Đơn hàng'),
            ],
          ),
        ],
      ),
    );
  }
}

class _VolumeCard extends StatelessWidget {
  const _VolumeCard({required this.points});

  final List<P2PAdDailyPerformanceDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.bar_chart_rounded,
            title: 'Volume giao dịch',
            color: AppColors.primary,
          ),
          Text(
            'Tổng giá trị giao dịch theo ngày (VND)',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: AppSpacing.x7 * 3,
            child: CustomPaint(
              painter: _VolumeBarPainter(points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.points});

  final List<P2PAdHourlyHeatmapDraft> points;

  @override
  Widget build(BuildContext context) {
    final maxOrders = points.fold<int>(
      0,
      (max, point) => math.max(max, point.orders),
    );

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.monitor_heart_outlined,
            title: 'Heatmap theo giờ',
            color: AppColors.buy,
          ),
          Text(
            'Số đơn hàng phân bổ theo giờ trong ngày (0-23h)',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          LayoutBuilder(
            builder: (context, constraints) {
              final gap = AppSpacing.x2;
              final side = (constraints.maxWidth - gap * 11) / 12;
              return Wrap(
                spacing: gap,
                runSpacing: AppSpacing.x3,
                children: [
                  for (final point in points)
                    SizedBox(
                      width: side,
                      child: Column(
                        children: [
                          Container(
                            width: side,
                            height: side,
                            decoration: BoxDecoration(
                              color: _heatColor(point.orders, maxOrders),
                              borderRadius: AppRadii.smRadius,
                            ),
                          ),
                          if (point.hour % 3 == 0) ...[
                            const SizedBox(height: AppSpacing.x1),
                            Text(
                              '${point.hour}h',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontSize: 7,
                                height: 1,
                              ),
                            ),
                          ] else
                            const SizedBox(height: AppSpacing.x3),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _LegendDot(color: AppColors.buy10, label: 'Ít'),
              Row(
                children: const [
                  _HeatLegendCell(alpha: .22),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .38),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .54),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .70),
                ],
              ),
              const _LegendDot(color: AppColors.buy, label: 'Nhiều'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentBreakdownCard extends StatelessWidget {
  const _PaymentBreakdownCard({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final total = snapshot.paymentBreakdown.fold<int>(
      0,
      (sum, item) => sum + item.volume,
    );

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.credit_card_rounded,
            title: 'Thanh toán phân bổ',
            color: AppColors.warn,
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < snapshot.paymentBreakdown.length; i++) ...[
            _PaymentRow(
              item: snapshot.paymentBreakdown[i],
              totalVolume: total,
              color: i.isEven ? AppColors.accent : AppColors.primary,
            ),
            if (i < snapshot.paymentBreakdown.length - 1)
              const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.item,
    required this.totalVolume,
    required this.color,
  });

  final P2PAdPaymentBreakdownDraft item;
  final int totalVolume;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = totalVolume == 0 ? 0.0 : item.volume / totalVolume;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.method,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontSize: 11,
                ),
              ),
            ),
            Text(
              '${item.count} đơn',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(width: AppSpacing.x4),
            Text(
              _formatCompactVnd(item.volume),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.smRadius,
          child: LinearProgressIndicator(
            value: pct,
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _CompetitorCard extends StatelessWidget {
  const _CompetitorCard({required this.rows});

  final List<P2PAdCompetitorComparisonDraft> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.emoji_events_outlined,
            title: 'So sánh đối thủ',
            color: AppColors.warn,
          ),
          Text(
            'So với trung bình thị trường & top merchant',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            height: AppSpacing.buttonHero * 2 + AppSpacing.x6,
            child: CustomPaint(
              painter: _RadarComparisonPainter(rows),
              child: const SizedBox.expand(),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: AppColors.accent, label: 'Bạn'),
              SizedBox(width: AppSpacing.x4),
              _LegendDot(color: AppColors.text3, label: 'TB thị trường'),
              SizedBox(width: AppSpacing.x4),
              _LegendDot(color: AppColors.buy, label: 'Top'),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          ClipRRect(
            borderRadius: AppRadii.cardRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Column(
                children: [
                  const _ComparisonTableRow(
                    metric: 'Chỉ số',
                    yours: 'Bạn',
                    average: 'TB',
                    top: 'Top',
                    header: true,
                  ),
                  for (final row in rows)
                    _ComparisonTableRow(
                      metric: row.metric,
                      yours: _formatComparison(row.metric, row.yours),
                      average: _formatComparison(row.metric, row.average),
                      top: _formatComparison(row.metric, row.top),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonTableRow extends StatelessWidget {
  const _ComparisonTableRow({
    required this.metric,
    required this.yours,
    required this.average,
    required this.top,
    this.header = false,
  });

  final String metric;
  final String yours;
  final String average;
  final String top;
  final bool header;

  @override
  Widget build(BuildContext context) {
    final bg = header ? AppColors.surface2 : Colors.transparent;
    final weight = header ? AppTextStyles.bold : AppTextStyles.normal;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        border: header
            ? null
            : const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                metric,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: header ? AppColors.text3 : AppColors.text2,
                  fontWeight: weight,
                  fontSize: 9,
                ),
              ),
            ),
            Expanded(
              child: _TableCell(
                text: yours,
                color: header ? AppColors.accent : AppColors.text1,
                bold: header,
              ),
            ),
            Expanded(
              child: _TableCell(
                text: average,
                color: AppColors.text3,
                bold: header,
              ),
            ),
            Expanded(
              child: _TableCell(text: top, color: AppColors.buy, bold: header),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    required this.color,
    required this.bold,
  });

  final String text;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: bold ? AppTextStyles.bold : AppTextStyles.medium,
        fontSize: 9,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.tips});

  final List<P2PAdOptimizationTipDraft> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.bolt_rounded,
            title: 'Gợi ý tối ưu',
            color: AppColors.warn,
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < tips.length; i++) ...[
            _TipRow(tip: tips[i]),
            if (i < tips.length - 1) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.tip});

  final P2PAdOptimizationTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.tone);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .06),
        border: Border.all(color: color.withValues(alpha: .14)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_tipIcon(tip.iconKey), color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                tip.text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallInlineStat extends StatelessWidget {
  const _SmallInlineStat({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.x3,
          height: AppSpacing.x3,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _HeatLegendCell extends StatelessWidget {
  const _HeatLegendCell({required this.alpha});

  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x3,
      height: AppSpacing.x3,
      decoration: BoxDecoration(
        color: AppColors.buy.withValues(alpha: alpha),
        borderRadius: AppRadii.smRadius,
      ),
    );
  }
}

class _PerformanceLinePainter extends CustomPainter {
  const _PerformanceLinePainter(this.points);

  final List<P2PAdDailyPerformanceDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final chart = Rect.fromLTRB(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width,
      size.height - AppSpacing.x5,
    );
    _paintGrid(canvas, chart);
    _paintLine(
      canvas,
      chart,
      values: points.map((point) => point.impressions.toDouble()).toList(),
      color: AppColors.accent,
      fill: true,
    );
    _paintLine(
      canvas,
      chart,
      values: points.map((point) => point.orders.toDouble()).toList(),
      color: AppColors.buy,
      maxOverride: 24,
    );
    for (var i = 0; i < points.length; i += 2) {
      final x = chart.left + chart.width * i / (points.length - 1);
      _paintTinyText(
        canvas,
        points[i].date,
        Offset(x - AppSpacing.x4, chart.bottom + AppSpacing.x2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformanceLinePainter oldDelegate) =>
      oldDelegate.points != points;
}

class _VolumeBarPainter extends CustomPainter {
  const _VolumeBarPainter(this.points);

  final List<P2PAdDailyPerformanceDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final chart = Rect.fromLTRB(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width,
      size.height - AppSpacing.x5,
    );
    _paintGrid(canvas, chart);
    final maxVolume = points
        .map((point) => point.volume)
        .reduce(math.max)
        .toDouble();
    final slot = chart.width / points.length;
    final paint = Paint()..color = AppColors.primary;
    for (var i = 0; i < points.length; i++) {
      final barHeight = chart.height * points[i].volume / maxVolume;
      final left = chart.left + slot * i + slot * .24;
      final right = chart.left + slot * (i + 1) - slot * .24;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, chart.bottom - barHeight, right, chart.bottom),
        const Radius.circular(AppSpacing.x1),
      );
      canvas.drawRRect(rect, paint);
    }
    for (var i = 0; i < points.length; i += 2) {
      final x = chart.left + slot * i + slot * .1;
      _paintTinyText(
        canvas,
        points[i].date,
        Offset(x, chart.bottom + AppSpacing.x2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VolumeBarPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _RadarComparisonPainter extends CustomPainter {
  const _RadarComparisonPainter(this.rows);

  final List<P2PAdCompetitorComparisonDraft> rows;

  @override
  void paint(Canvas canvas, Size size) {
    if (rows.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2 + AppSpacing.x2);
    final radius = math.min(size.width, size.height) * .32;
    final grid = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var level = 1; level <= 4; level++) {
      final path = Path();
      for (var i = 0; i < rows.length; i++) {
        final point = _radarPoint(center, radius * level / 4, i, rows.length);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, grid);
    }

    for (var i = 0; i < rows.length; i++) {
      final end = _radarPoint(center, radius, i, rows.length);
      canvas.drawLine(center, end, grid);
      final label = _radarPoint(center, radius + AppSpacing.x5, i, rows.length);
      _paintTinyText(
        canvas,
        rows[i].metric,
        label.translate(-AppSpacing.x5, -AppSpacing.x2),
      );
    }

    _paintRadarSeries(
      canvas,
      center,
      radius,
      _normalizedRadarValues(rows, (row) => row.average),
      AppColors.text3,
      .10,
    );
    _paintRadarSeries(
      canvas,
      center,
      radius,
      _normalizedRadarValues(rows, (row) => row.top),
      AppColors.buy,
      .12,
    );
    _paintRadarSeries(
      canvas,
      center,
      radius,
      _normalizedRadarValues(rows, (row) => row.yours),
      AppColors.accent,
      .24,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarComparisonPainter oldDelegate) =>
      oldDelegate.rows != rows;
}

void _paintGrid(Canvas canvas, Rect chart) {
  final paint = Paint()
    ..color = AppColors.divider
    ..strokeWidth = 1;
  for (var i = 0; i <= 4; i++) {
    final y = chart.bottom - chart.height * i / 4;
    canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), paint);
  }
}

void _paintLine(
  Canvas canvas,
  Rect chart, {
  required List<double> values,
  required Color color,
  bool fill = false,
  double? maxOverride,
}) {
  if (values.length < 2) return;
  final maxValue = maxOverride ?? values.reduce(math.max);
  final minValue = maxOverride == null ? values.reduce(math.min) : 0;
  final span = math.max(maxValue - minValue, 1);
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = chart.left + chart.width * i / (values.length - 1);
    final y = chart.bottom - chart.height * (values[i] - minValue) / span;
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  if (fill) {
    final fillPath = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = color.withValues(alpha: .10));
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round,
  );
}

void _paintRadarSeries(
  Canvas canvas,
  Offset center,
  double radius,
  List<double> values,
  Color color,
  double fillAlpha,
) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final point = _radarPoint(center, radius * values[i], i, values.length);
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  canvas.drawPath(path, Paint()..color = color.withValues(alpha: fillAlpha));
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5,
  );
}

List<double> _normalizedRadarValues(
  List<P2PAdCompetitorComparisonDraft> rows,
  double Function(P2PAdCompetitorComparisonDraft row) selector,
) {
  return [
    for (final row in rows)
      _normalizedRadarMetric(row, selector(row)).clamp(0, 1),
  ];
}

double _normalizedRadarMetric(
  P2PAdCompetitorComparisonDraft row,
  double value,
) {
  final maxValue = math.max(row.yours, math.max(row.average, row.top));
  if (maxValue <= 0) return 0;
  if (row.metric.contains('Phản hồi')) {
    return (maxValue - value + 1) / maxValue;
  }
  return value / maxValue;
}

Offset _radarPoint(Offset center, double radius, int index, int total) {
  final angle = -math.pi / 2 + (math.pi * 2 * index / total);
  return Offset(
    center.dx + math.cos(angle) * radius,
    center.dy + math.sin(angle) * radius,
  );
}

void _paintTinyText(Canvas canvas, String text, Offset offset) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3, fontSize: 8),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: AppSpacing.x7 + AppSpacing.x4);
  painter.paint(canvas, offset);
}

Color _heatColor(int orders, int maxOrders) {
  if (orders <= 0 || maxOrders <= 0) return AppColors.surface2;
  final intensity = orders / maxOrders;
  return AppColors.buy.withValues(alpha: .16 + intensity * .58);
}

Color _toneColor(String tone) {
  return switch (tone) {
    'buy' => AppColors.buy,
    'accent' => AppColors.accent,
    'warn' => AppColors.warn,
    'sell' => AppColors.sell,
    _ => AppModuleAccents.p2p,
  };
}

IconData _tipIcon(String iconKey) {
  return switch (iconKey) {
    'check' => Icons.check_circle_outline_rounded,
    'clock' => Icons.schedule_rounded,
    'trend' => Icons.trending_up_rounded,
    _ => Icons.info_outline_rounded,
  };
}

String _formatCount(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}

String _formatCompactVnd(int value) {
  if (value >= 1000000000) {
    return '₫${_trim(value / 1000000000)}B';
  }
  if (value >= 1000000) {
    return '₫${_trim(value / 1000000)}M';
  }
  return '₫${_formatVnd(value)}';
}

String _formatComparison(String metric, double value) {
  if (metric == 'Giá') return _formatCompactPlain(value);
  return _fixed(value);
}

String _formatCompactPlain(double value) {
  if (value >= 1000) return '${_trim(value / 1000)}K';
  return _fixed(value);
}

String _fixed(double value) => value.toStringAsFixed(1);

String _trim(double value) {
  final text = value.toStringAsFixed(2);
  if (text.endsWith('00')) return text.substring(0, text.length - 3);
  if (text.endsWith('0')) return text.substring(0, text.length - 1);
  return text;
}
