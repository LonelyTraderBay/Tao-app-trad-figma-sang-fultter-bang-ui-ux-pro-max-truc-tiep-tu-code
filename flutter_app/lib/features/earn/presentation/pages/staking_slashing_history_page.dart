import 'dart:math' as math;

import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

enum _SlashingTab { history, statistics, prevention }

class StakingSlashingHistoryPage extends ConsumerStatefulWidget {
  const StakingSlashingHistoryPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc382_info');
  static const statsKey = Key('sc382_stats');
  static const tabsKey = Key('sc382_tabs');
  static const historyKey = Key('sc382_history');
  static const statisticsKey = Key('sc382_statistics');
  static const trendKey = Key('sc382_trend');
  static const preventionKey = Key('sc382_prevention');
  static const exportKey = Key('sc382_export');
  static const footerKey = Key('sc382_footer');

  static Key tabKey(String id) => Key('sc382_tab_$id');
  static Key eventKey(String id) => Key('sc382_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingSlashingHistoryPage> createState() =>
      _StakingSlashingHistoryPageState();
}

class _StakingSlashingHistoryPageState
    extends ConsumerState<StakingSlashingHistoryPage> {
  _SlashingTab _activeTab = _SlashingTab.history;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingSlashingHistoryRepositoryProvider)
        .getSlashingHistory();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-382 StakingSlashingHistoryPage',
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
                    _InsuranceBanner(snapshot: snapshot),
                    _SummaryStats(stats: snapshot.stats),
                    _SlashingTabs(
                      active: _activeTab,
                      onChanged: (tab) => setState(() => _activeTab = tab),
                    ),
                    switch (_activeTab) {
                      _SlashingTab.history => _HistoryTab(snapshot: snapshot),
                      _SlashingTab.statistics => _StatisticsTab(
                        snapshot: snapshot,
                      ),
                      _SlashingTab.prevention => _PreventionTab(
                        snapshot: snapshot,
                      ),
                    },
                    _ExportButton(label: snapshot.exportLabel),
                    _FooterNote(note: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsuranceBanner extends StatelessWidget {
  const _InsuranceBanner({required this.snapshot});

  final StakingSlashingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSlashingHistoryPage.infoKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.infoTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.55,
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

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({required this.stats});

  final StakingSlashingStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSlashingHistoryPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.x3,
        crossAxisSpacing: AppSpacing.x3,
        childAspectRatio: 1.65,
        children: [
          _StatTile(
            label: 'Total Events',
            value: stats.totalEvents.toString(),
            caption: 'Last 12 months',
          ),
          _StatTile(
            label: 'Total Slashed',
            value: '${_formatEth(stats.totalSlashedEth)} ETH',
            caption: 'All networks',
            color: AppColors.sell,
            borderColor: AppColors.sell20,
          ),
          _StatTile(
            label: 'Insurance Paid',
            value: '${_formatEth(stats.totalCoveredEth)} ETH',
            caption: '${stats.coverageRate}% coverage',
            color: AppColors.buy,
            borderColor: AppColors.buy20,
          ),
          _StatTile(
            label: 'Avg Recovery',
            value: stats.avgRecoveryTime,
            caption: 'Time to payout',
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.caption,
    this.color,
    this.borderColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.text1;
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: textColor,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _SlashingTabs extends StatelessWidget {
  const _SlashingTabs({required this.active, required this.onChanged});

  final _SlashingTab active;
  final ValueChanged<_SlashingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingSlashingHistoryPage.tabsKey,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          for (final tab in _SlashingTab.values)
            Expanded(
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: StakingSlashingHistoryPage.tabKey(tab.name),
                  onTap: () => onChanged(tab),
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.x4),
                    child: Column(
                      children: [
                        Text(
                          _tabLabel(tab),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: active == tab ? AppSpacing.buttonHero : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: active == tab
                                ? AppColors.primarySoft
                                : AppColors.transparent,
                            borderRadius: AppRadii.xsRadius,
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

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.snapshot});

  final StakingSlashingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingSlashingHistoryPage.historyKey,
      label: 'Slashing Events',
      accentColor: AppColors.primarySoft,
      children: [
        for (final event in snapshot.events) _SlashingEventCard(event: event),
      ],
    );
  }
}

class _SlashingEventCard extends StatelessWidget {
  const _SlashingEventCard({required this.event});

  final StakingSlashingEventDraft event;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(event.status);
    return VitCard(
      key: StakingSlashingHistoryPage.eventKey(event.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
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
                    Text(event.validator, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${event.network} - ${event.dateLabel}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(
                label: _statusLabel(event.status),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Reason: ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                    children: [
                      TextSpan(
                        text: event.reason,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Slashed',
                        value: '${_formatEth(event.slashedAmount)} ETH',
                        color: AppColors.sell,
                      ),
                    ),
                    Expanded(
                      child: _EventMetric(
                        label: 'Coverage',
                        value: '${event.insuranceCoverage}%',
                        color: AppColors.warn,
                      ),
                    ),
                    Expanded(
                      child: _EventMetric(
                        label: 'Users',
                        value: event.affectedUsers.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Insurance payout: ${_formatEth(event.slashedAmount * event.insuranceCoverage / 100)} ETH',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventMetric extends StatelessWidget {
  const _EventMetric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

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
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatisticsTab extends StatelessWidget {
  const _StatisticsTab({required this.snapshot});

  final StakingSlashingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingSlashingHistoryPage.statisticsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          key: StakingSlashingHistoryPage.trendKey,
          label: '12-Month Trend',
          accentColor: AppColors.primarySoft,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  SizedBox(
                    height: 172,
                    child: CustomPaint(
                      painter: _TrendPainter(snapshot.trend),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      const Icon(
                        Icons.trending_down_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      Text(
                        '-40% vs 12 months ago',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                      const CircleAvatar(
                        radius: 2,
                        backgroundColor: AppColors.borderSolid,
                      ),
                      Text(
                        'Avg: 0.25 events/month',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Breakdown by Network',
          accentColor: AppColors.primarySoft,
          children: [
            for (final item in snapshot.networkBreakdown)
              _NetworkBreakdownCard(item: item),
          ],
        ),
        VitPageSection(
          label: 'Breakdown by Reason',
          accentColor: AppColors.primarySoft,
          children: [
            for (final item in snapshot.reasonBreakdown)
              _ReasonBreakdownCard(item: item),
          ],
        ),
      ],
    );
  }
}

class _NetworkBreakdownCard extends StatelessWidget {
  const _NetworkBreakdownCard({required this.item});

  final StakingSlashingNetworkDraft item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.network, style: AppTextStyles.baseMedium),
              ),
              Text(
                '${item.events} events',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _BreakdownTile(
                  label: 'Total Slashed',
                  value: '${_formatEth(item.amount)} ${item.unit}',
                  color: AppColors.sell,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _BreakdownTile(
                  label: 'Coverage',
                  value: '${item.coverage}%',
                  color: AppColors.buy,
                  borderColor: AppColors.buy20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.label,
    required this.value,
    required this.color,
    this.borderColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonBreakdownCard extends StatelessWidget {
  const _ReasonBreakdownCard({required this.item});

  final StakingSlashingReasonDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(item.severity);
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.reason, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_capitalize(item.severity)} severity',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            item.events.toString(),
            style: AppTextStyles.baseMedium.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreventionTab extends StatelessWidget {
  const _PreventionTab({required this.snapshot});

  final StakingSlashingHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingSlashingHistoryPage.preventionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Active Prevention Measures',
          accentColor: AppColors.primarySoft,
          children: [
            for (final measure in snapshot.preventionMeasures)
              _PreventionCard(measure: measure),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.buy20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.tips_and_updates_outlined,
                color: AppColors.primarySoft,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'Proactive Protection: ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                      height: 1.55,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Our multi-layered prevention system has reduced slashing events by 40% year-over-year. Continuous monitoring and automated rebalancing ensure your stake is always protected.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.55,
                        ),
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

class _PreventionCard extends StatelessWidget {
  const _PreventionCard({required this.measure});

  final StakingSlashingPreventionDraft measure;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.ctaHeight,
            height: AppSpacing.ctaHeight,
            decoration: BoxDecoration(
              color: AppColors.buy.withValues(alpha: 0.12),
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(Icons.shield_outlined, color: AppColors.buy),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        measure.measure,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    _StatusPill(
                      label: _capitalize(measure.status),
                      color: AppColors.buy,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  measure.description,
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

class _ExportButton extends StatelessWidget {
  const _ExportButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSlashingHistoryPage.exportKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.file_download_outlined,
            color: AppColors.text1,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSlashingHistoryPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        note,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.55,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter(this.points);

  final List<StakingSlashingTrendPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    if (points.isEmpty) return;
    final maxAmount = points.map((p) => p.amountEth).reduce(math.max);
    final scale = maxAmount <= 0 ? 1 : maxAmount;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1 ? 0.0 : size.width * i / (points.length - 1);
      final y = size.height - (points[i].amountEth / scale) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = AppColors.sell
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = AppColors.sell
      ..style = PaintingStyle.fill;
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1 ? 0.0 : size.width * i / (points.length - 1);
      final y = size.height - (points[i].amountEth / scale) * size.height;
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _tabLabel(_SlashingTab tab) {
  return switch (tab) {
    _SlashingTab.history => 'History',
    _SlashingTab.statistics => 'Statistics',
    _SlashingTab.prevention => 'Prevention',
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'partial' => AppColors.warn,
    'uncovered' => AppColors.sell,
    _ => AppColors.buy,
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'partial' => 'Partially Covered',
    'uncovered' => 'Not Covered',
    _ => 'Fully Covered',
  };
}

Color _severityColor(String severity) {
  return switch (severity) {
    'critical' => AppColors.sell,
    'high' => AppColors.riskHigh,
    _ => AppColors.warn,
  };
}

String _capitalize(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}

String _formatEth(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}
