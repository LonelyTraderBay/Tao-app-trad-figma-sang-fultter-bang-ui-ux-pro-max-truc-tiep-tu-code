import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

class StakingDashboardPage extends ConsumerStatefulWidget {
  const StakingDashboardPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc358_summary_card');
  static const performanceKey = Key('sc358_performance_chart');
  static const allocationKey = Key('sc358_allocation_card');
  static const positionsKey = Key('sc358_positions_section');
  static const stakeMoreKey = Key('sc358_stake_more');
  static const analyticsKey = Key('sc358_analytics');
  static const historyKey = Key('sc358_history');
  static const calendarKey = Key('sc358_calendar');
  static const alertKey = Key('sc358_maturity_alert');

  static Key positionKey(String id) => Key('sc358_position_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingDashboardPage> createState() =>
      _StakingDashboardPageState();
}

class _StakingDashboardPageState extends ConsumerState<StakingDashboardPage> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingDashboardRepositoryProvider)
        .getDashboard();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-358 StakingDashboardPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _SummaryCard(
                      snapshot: snapshot,
                      isRefreshing: _isRefreshing,
                      onRefresh: _refresh,
                      onExport: _exportReport,
                    ),
                    VitPageSection(
                      label: 'Biểu đồ Hiệu suất (6 tháng)',
                      accentColor: AppColors.primary,
                      children: [
                        _PerformanceCard(points: snapshot.performance),
                      ],
                    ),
                    VitPageSection(
                      label: 'Phân bổ Tài sản',
                      accentColor: AppColors.primary,
                      children: [
                        _AllocationCard(
                          key: StakingDashboardPage.allocationKey,
                          allocations: snapshot.allocations,
                          total: snapshot.totalStakedUsd,
                        ),
                      ],
                    ),
                    VitPageSection(
                      key: StakingDashboardPage.positionsKey,
                      label: 'Vị thế Hoạt động (${snapshot.positions.length})',
                      accentColor: AppColors.primary,
                      children: [
                        for (final position in snapshot.positions)
                          _PositionCard(position: position),
                      ],
                    ),
                    _QuickActions(snapshot: snapshot),
                    _NavigationCards(snapshot: snapshot),
                    if (snapshot.maturingSoon > 0)
                      _MaturityAlert(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refresh() {
    HapticFeedback.selectionClick();
    setState(() => _isRefreshing = true);
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _isRefreshing = false);
    });
  }

  void _exportReport() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Xuất báo cáo CSV/PDF sẽ sớm ra mắt')),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.snapshot,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onExport,
  });

  final StakingDashboardSnapshot snapshot;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDashboardPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng giá trị Staking',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      _formatUsd(snapshot.totalStakedUsd),
                      style: AppTextStyles.display.copyWith(
                        color: Colors.white,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              _CircleIconButton(
                icon: isRefreshing ? Icons.sync_rounded : Icons.refresh_rounded,
                onTap: onRefresh,
              ),
              const SizedBox(width: AppSpacing.x2),
              _CircleIconButton(
                icon: Icons.file_download_outlined,
                onTap: onExport,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Tổng thu nhập',
                  value: '+${_formatUsd(snapshot.totalEarnedUsd)}',
                  color: AppColors.buy,
                  border: AppColors.buy20,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'APY trung bình',
                  value: '${snapshot.weightedApy.toStringAsFixed(2)}%',
                  color: AppColors.primarySoft,
                  border: AppColors.primary30,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Vị thế',
                  value: '${snapshot.activePositions} active',
                  color: AppColors.warn,
                  border: AppColors.warn15,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ProjectionMetric(
                  label: 'Hàng ngày',
                  value: snapshot.dailyEarningsUsd,
                ),
              ),
              Expanded(
                child: _ProjectionMetric(
                  label: 'Hàng tháng',
                  value: snapshot.monthlyEarningsUsd,
                ),
              ),
              Expanded(
                child: _ProjectionMetric(
                  label: 'Hàng năm',
                  value: snapshot.yearlyProjectionUsd,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.portfolioBtnGhost,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.portfolioBtnGhostBorder),
            borderRadius: AppRadii.xlRadius,
          ),
          child: SizedBox(
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            child: Icon(icon, color: Colors.white, size: AppSpacing.iconMd),
          ),
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.border,
  });

  final String label;
  final String value;
  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: border,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextDim,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectionMetric extends StatelessWidget {
  const _ProjectionMetric({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '+${_formatUsd(value)}',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.points});

  final List<StakingPerformancePointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDashboardPage.performanceKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.buttonHero + AppSpacing.x7 + AppSpacing.x6,
            child: Stack(
              children: [
                const Positioned(
                  left: 0,
                  top: AppSpacing.x3,
                  bottom: AppSpacing.x7,
                  child: _AxisLabels(),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PerformancePainter(points: points),
                    child: const SizedBox.expand(),
                  ),
                ),
                Positioned(
                  left: AppSpacing.x7,
                  right: AppSpacing.x3,
                  bottom: AppSpacing.x3,
                  child: _DateLabels(points: points),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: AppColors.primary, label: 'Tổng giá trị'),
              const SizedBox(width: AppSpacing.x6),
              _LegendDot(color: AppColors.buy, label: 'Lợi nhuận'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  const _AllocationCard({
    super.key,
    required this.allocations,
    required this.total,
  });

  final List<StakingAllocationDraft> allocations;
  final double total;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.buttonHero + AppSpacing.x7,
            height: AppSpacing.buttonHero + AppSpacing.x6,
            child: CustomPaint(
              painter: _AllocationPainter(
                allocations: allocations,
                total: total,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Wrap(
              runSpacing: AppSpacing.x3,
              spacing: AppSpacing.x5,
              children: [
                for (final item in allocations)
                  _AllocationLegend(item: item, total: total),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AxisLabels extends StatelessWidget {
  const _AxisLabels();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final label in const ['\$16k', '\$12k', '\$8k', '\$4k', '\$0k'])
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class _DateLabels extends StatelessWidget {
  const _DateLabels({required this.points});

  final List<StakingPerformancePointDraft> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final index in _dateIndexes(points.length))
          Text(
            points[index].date,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}

class _AllocationLegend extends StatelessWidget {
  const _AllocationLegend({required this.item, required this.total});

  final StakingAllocationDraft item;
  final double total;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : item.valueUsd / total * 100;
    return SizedBox(
      width: AppSpacing.buttonHero,
      child: Row(
        children: [
          Container(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            decoration: BoxDecoration(
              color: _assetColor(item.colorIndex),
              borderRadius: AppRadii.xsRadius,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.asset,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
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

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final StakingPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(position.colorIndex);

    return VitCard(
      key: StakingDashboardPage.positionKey(position.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetBadge(asset: position.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            position.product,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (position.daysUntilMaturity != null)
                          _MaturityPill(days: position.daysUntilMaturity!),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Icon(
                          _typeIcon(position.type),
                          color: _typeColor(position.type),
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Text(
                          _typeLabel(position.type),
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${position.apy.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _PositionMetric(
                  label: 'Đang stake',
                  value: '${_formatAmount(position.amount)} ${position.asset}',
                  detail: _formatUsd(position.usdValue),
                  valueColor: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _PositionMetric(
                  label: 'Đã nhận',
                  value: '+${_formatAmount(position.earned)} ${position.asset}',
                  detail: '+${_formatUsd(position.earnedUsd)}',
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.45)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _MaturityPill extends StatelessWidget {
  const _MaturityPill({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: const BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        '$days ngày nữa',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.warn,
          fontWeight: AppTextStyles.bold,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
    required this.label,
    required this.value,
    required this.detail,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String detail;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            detail,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.snapshot});

  final StakingDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: StakingDashboardPage.stakeMoreKey,
            leading: const Icon(Icons.add_rounded),
            onPressed: () => context.go(snapshot.stakingRoute),
            child: const Text('Stake thêm'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: StakingDashboardPage.analyticsKey,
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.trending_up_rounded),
            onPressed: () => context.go(snapshot.analyticsRoute),
            child: const Text('Phân tích'),
          ),
        ),
      ],
    );
  }
}

class _NavigationCards extends StatelessWidget {
  const _NavigationCards({required this.snapshot});

  final StakingDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NavCard(
            key: StakingDashboardPage.historyKey,
            icon: Icons.calendar_month_rounded,
            label: 'Lịch sử',
            caption: 'Xem giao dịch',
            route: snapshot.historyRoute,
            accent: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _NavCard(
            key: StakingDashboardPage.calendarKey,
            icon: Icons.paid_outlined,
            label: 'Lịch nhận lãi',
            caption: 'Xem lịch trình',
            route: snapshot.calendarRoute,
            accent: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    super.key,
    required this.icon,
    required this.label,
    required this.caption,
    required this.route,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String caption;
  final String route;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: () => context.go(route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  border: Border.all(color: accent.withValues(alpha: 0.35)),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: SizedBox(
                  width: AppSpacing.x7,
                  height: AppSpacing.x7,
                  child: Icon(icon, color: accent, size: AppSpacing.iconMd),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.baseMedium),
                    Text(
                      caption,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }
}

class _MaturityAlert extends StatelessWidget {
  const _MaturityAlert({required this.snapshot});

  final StakingDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDashboardPage.alertKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.alertTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.alertBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          VitCtaButton(
            variant: VitCtaButtonVariant.warning,
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            onPressed: () => context.go(snapshot.calendarRoute),
            child: const Text('Xem'),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.x4,
          height: AppSpacing.x1,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _PerformancePainter extends CustomPainter {
  const _PerformancePainter({required this.points});

  final List<StakingPerformancePointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final left = AppSpacing.x7;
    final right = size.width - AppSpacing.x3;
    final top = AppSpacing.x4;
    final bottom = size.height - AppSpacing.x7;
    final chart = Rect.fromLTRB(left, top, right, bottom);

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    void drawLine(
      double Function(StakingPerformancePointDraft p) valueOf,
      Color color,
    ) {
      const minValue = 0.0;
      final maxValue = points
          .map((point) => math.max(point.valueUsd, point.earnedUsd))
          .reduce(math.max);
      final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x = chart.left + chart.width * i / (points.length - 1);
        final normalized = (valueOf(points[i]) - minValue) / range;
        final y = chart.bottom - normalized * chart.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawPath(path, paint);
    }

    drawLine((point) => point.valueUsd, AppColors.primary);
    drawLine((point) => point.earnedUsd, AppColors.buy);
  }

  @override
  bool shouldRepaint(covariant _PerformancePainter oldDelegate) =>
      oldDelegate.points != points;
}

class _AllocationPainter extends CustomPainter {
  const _AllocationPainter({required this.allocations, required this.total});

  final List<StakingAllocationDraft> allocations;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .34;
    final stroke = AppSpacing.x6;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = AppColors.surface3,
    );

    for (final item in allocations) {
      final sweep = total == 0 ? 0.0 : item.valueUsd / total * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..color = _assetColor(item.colorIndex);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _AllocationPainter oldDelegate) =>
      oldDelegate.allocations != allocations || oldDelegate.total != total;
}

Color _assetColor(int index) {
  return switch (index % 5) {
    0 => AppColors.primary,
    1 => AppColors.buy,
    2 => AppColors.accent,
    3 => AppColors.warn,
    _ => AppColors.sell,
  };
}

IconData _typeIcon(StakingDashboardPositionType type) {
  return switch (type) {
    StakingDashboardPositionType.fixed => Icons.lock_outline_rounded,
    StakingDashboardPositionType.defi => Icons.bolt_rounded,
    StakingDashboardPositionType.flexible =>
      Icons.account_balance_wallet_outlined,
  };
}

Color _typeColor(StakingDashboardPositionType type) {
  return switch (type) {
    StakingDashboardPositionType.fixed => AppColors.warn,
    StakingDashboardPositionType.defi => AppColors.accent,
    StakingDashboardPositionType.flexible => AppColors.buy,
  };
}

String _typeLabel(StakingDashboardPositionType type) {
  return switch (type) {
    StakingDashboardPositionType.fixed => 'Cố định',
    StakingDashboardPositionType.defi => 'DeFi',
    StakingDashboardPositionType.flexible => 'Linh hoạt',
  };
}

List<int> _dateIndexes(int length) {
  if (length <= 1) return const [0];
  final last = length - 1;
  final indexes = <int>{0, (last * .25).round(), (last * .5).round(), last};
  return indexes.toList()..sort();
}

String _formatUsd(double value) {
  final negative = value < 0;
  final fixed = value.abs().toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${negative ? '-' : ''}\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  final decimals = value < 1
      ? 5
      : value >= 100
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final position = raw.length - i;
    buffer.write(raw[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
