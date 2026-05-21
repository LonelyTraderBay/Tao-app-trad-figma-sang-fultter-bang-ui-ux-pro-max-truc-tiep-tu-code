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
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _dashBg = Color(0xFF080C14);
const _dashSurface = Color(0xFF151A23);
const _dashSurface2 = Color(0xFF1E2535);
const _dashBorder = Color(0xFF273142);
const _dashGreen = Color(0xFF10B981);
const _dashRed = Color(0xFFEF4444);
const _dashAmber = Color(0xFFF59E0B);
const _dashBlue = Color(0xFF3B82F6);

class RegulatoryReportsDashboardPage extends ConsumerStatefulWidget {
  const RegulatoryReportsDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc094_regulatory_reports_content');
  static Key tabKey(String id) => Key('sc094_regulatory_tab_$id');
  static Key rangeKey(String id) => Key('sc094_regulatory_range_$id');
  static Key actionKey(String id) => Key('sc094_regulatory_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RegulatoryReportsDashboardPage> createState() =>
      _RegulatoryReportsDashboardPageState();
}

class _RegulatoryReportsDashboardPageState
    extends ConsumerState<RegulatoryReportsDashboardPage> {
  String _tab = 'overview';
  String _range = '7D';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getRegulatoryReportsDashboard();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-094 RegulatoryReportsDashboardPage',
      child: Material(
        color: _dashBg,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Regulatory Reports',
                  subtitle: 'Dashboard - MiFID II - EMIR',
                  showBack: true,
                  onBack: () =>
                      context.go(AppRoutePaths.tradeCopyTransactionReporting),
                  trailing: IconButton(
                    onPressed: () => setState(() => _notice = 'Export queued'),
                    icon: const Icon(Icons.download_rounded, size: 19),
                    color: AppColors.text1,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: RegulatoryReportsDashboardPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ComplianceAlert(totals: snapshot.totals),
                        const SizedBox(height: 35),
                        _KpiGrid(totals: snapshot.totals),
                        const SizedBox(height: 24),
                        _RangeSelector(
                          ranges: snapshot.timeRanges,
                          activeId: _range,
                          onChanged: (id) => setState(() => _range = id),
                        ),
                        const SizedBox(height: 20),
                        _Tabs(
                          activeId: _tab,
                          onChanged: (id) => setState(() => _tab = id),
                        ),
                        const SizedBox(height: 26),
                        if (_tab == 'overview')
                          _OverviewTab(snapshot: snapshot)
                        else if (_tab == 'queue')
                          _QueueTab(snapshot: snapshot)
                        else if (_tab == 'compliance')
                          _ComplianceTab(totals: snapshot.totals)
                        else
                          _ExportsTab(
                            onNotice: (text) => setState(() => _notice = text),
                          ),
                        const SizedBox(height: 14),
                        _QuickActions(
                          onQueue: () => context.go(
                            AppRoutePaths.tradeCopyTransactionReporting,
                          ),
                          onArmStatus: () => context.go(
                            AppRoutePaths.tradeCopyArmIntegrationStatus,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_notice != null)
              _NoticePanel(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }
}

class _ComplianceAlert extends StatelessWidget {
  const _ComplianceAlert({required this.totals});

  final TradeRegulatoryDashboardTotals totals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.text1,
            size: 17,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '100% SLA Compliance (Last 7 Days)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'All reports submitted within T+1. Zero regulatory breaches. Avg latency: ${totals.avgLatency.round()}s.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    height: 1.4,
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

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.totals});

  final TradeRegulatoryDashboardTotals totals;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Total Reports',
        _formatInt(totals.total),
        '+12% vs last week',
        _dashBlue,
        Icons.description_outlined,
      ),
      (
        'Success Rate',
        '${totals.successRate.toStringAsFixed(1)}%',
        '${totals.confirmed}/${totals.total} confirmed',
        _dashGreen,
        Icons.check_circle_outline,
      ),
      (
        'Avg Latency',
        '${totals.avgLatency.round()}s',
        'Under 60s SLA',
        _dashAmber,
        Icons.bolt_rounded,
      ),
      (
        'Failed',
        '${totals.failed}',
        '${(totals.failed / totals.total * 100).toStringAsFixed(1)}% failure rate',
        _dashRed,
        Icons.cancel_outlined,
      ),
    ];

    return Row(
      children: [
        for (final item in items) ...[
          Expanded(child: _KpiCard(item: item)),
          if (item != items.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.item});

  final (String, String, String, Color, IconData) item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124,
      padding: const EdgeInsets.fromLTRB(9, 11, 9, 10),
      decoration: BoxDecoration(
        color: _dashSurface,
        border: Border.all(color: _dashBorder.withValues(alpha: .68)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.$5, color: item.$4, size: 15),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  item.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            item.$2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontSize: 20,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            item.$3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: item.$4 == _dashAmber ? _dashGreen : item.$4,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({
    required this.ranges,
    required this.activeId,
    required this.onChanged,
  });

  final List<String> ranges;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final range in ranges) ...[
          InkWell(
            key: RegulatoryReportsDashboardPage.rangeKey(range),
            onTap: () => onChanged(range),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: activeId == range ? _dashBlue : _dashSurface2,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                range,
                style: AppTextStyles.caption.copyWith(
                  color: activeId == range ? Colors.white : AppColors.text2,
                  fontSize: 12,
                  fontWeight: activeId == range
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ),
          ),
          if (range != ranges.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('overview', 'Overview'),
    ('queue', 'Queue'),
    ('compliance', 'Compliance'),
    ('exports', 'Exports'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: _dashSurface,
      child: Row(
        children: [
          for (final tab in _tabs)
            Expanded(
              child: InkWell(
                key: RegulatoryReportsDashboardPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _dashBlue
                                : AppColors.text3,
                            fontSize: 11,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      width: activeId == tab.$1 ? 58 : 0,
                      color: _dashBlue,
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

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final TradeRegulatoryReportsDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Submission Trend (Last 7 Days)'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _TrendPainter(stats: snapshot.dailyStats),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _SectionLabel('Report Distribution by Regulation'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Card(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 180,
                  child: CustomPaint(
                    painter: _DonutPainter(items: snapshot.distribution),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DistributionLegend(
                items: snapshot.distribution,
                total: snapshot.totals.distributionTotal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SectionLabel('ARM Provider Performance'),
        const SizedBox(height: 12),
        for (final provider in snapshot.providers) ...[
          _ProviderCard(provider: provider),
          if (provider != snapshot.providers.last) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _DistributionLegend extends StatelessWidget {
  const _DistributionLegend({required this.items, required this.total});

  final List<TradeRegulatoryDistributionItem> items;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) ...[
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: _dashSurface2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(item.colorHex),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                ),
                Text(
                  _formatInt(item.value),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          if (item != items.last) const SizedBox(height: 8),
        ],
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(top: 11),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: _dashBorder)),
          ),
          child: Row(
            children: [
              Text(
                'Total',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                _formatInt(total),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider});

  final TradeRegulatoryArmProvider provider;

  @override
  Widget build(BuildContext context) {
    final healthy = provider.status == 'healthy';
    final color = healthy ? _dashGreen : _dashAmber;
    return _Card(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  provider.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${_formatInt(provider.reports)} reports',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SmallMetric(
                  label: 'Success Rate',
                  value: '${provider.successRate.toStringAsFixed(1)}%',
                  color: _dashGreen,
                ),
              ),
              Expanded(
                child: _SmallMetric(
                  label: 'Avg Latency',
                  value: '${provider.avgLatency}s',
                ),
              ),
              Expanded(
                child: _SmallMetric(
                  label: 'Status',
                  value: provider.status,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QueueTab extends StatelessWidget {
  const _QueueTab({required this.snapshot});

  final TradeRegulatoryReportsDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Submission Queue Summary'),
        const SizedBox(height: 12),
        for (final stat in snapshot.dailyStats.take(4)) ...[
          _Card(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: _dashBlue,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    stat.date,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                _SmallPill(
                  label: '${stat.confirmed} confirmed',
                  color: _dashGreen,
                ),
                const SizedBox(width: 8),
                _SmallPill(label: '${stat.failed} failed', color: _dashRed),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ComplianceTab extends StatelessWidget {
  const _ComplianceTab({required this.totals});

  final TradeRegulatoryDashboardTotals totals;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('SLA Compliance (T+1)', 100.0, '100%', _dashGreen),
      ('Field Accuracy (RTS 22)', 99.8, '99.8%', _dashGreen),
      (
        'Submission Success Rate',
        totals.successRate,
        '${totals.successRate.toStringAsFixed(1)}%',
        _dashGreen,
      ),
      (
        'Latency Performance (<60s)',
        totals.avgLatency / 60 * 100,
        '${totals.avgLatency.round()}s',
        _dashGreen,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Compliance Metrics'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (final item in items) ...[
                _ProgressMetric(
                  label: item.$1,
                  pct: item.$2,
                  value: item.$3,
                  color: item.$4,
                ),
                if (item != items.last) const SizedBox(height: 18),
              ],
              Container(
                margin: const EdgeInsets.only(top: 18),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                decoration: BoxDecoration(
                  color: _dashGreen.withValues(alpha: .10),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      color: _dashGreen,
                      size: 17,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Full regulatory compliance maintained for 90 consecutive days',
                        style: AppTextStyles.caption.copyWith(
                          color: _dashGreen,
                          fontSize: 11,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExportsTab extends StatelessWidget {
  const _ExportsTab({required this.onNotice});

  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Export Reports'),
        const SizedBox(height: 12),
        _ExportCard(
          title: 'ISO 20022 XML Export',
          subtitle: 'Standard regulatory format',
          icon: Icons.description_outlined,
          color: _dashBlue,
          onTap: () => onNotice('XML export queued'),
        ),
        const SizedBox(height: 10),
        _ExportCard(
          title: 'Compliance Report (PDF)',
          subtitle: 'Executive summary',
          icon: Icons.bar_chart_rounded,
          color: _dashGreen,
          onTap: () => onNotice('PDF export queued'),
        ),
        const SizedBox(height: 10),
        _ExportCard(
          title: 'Raw Data Export (CSV)',
          subtitle: 'All fields, all reports',
          icon: Icons.storage_outlined,
          color: _dashAmber,
          onTap: () => onNotice('CSV export queued'),
        ),
      ],
    );
  }
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: _Card(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.download_rounded,
              color: AppColors.text3,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.pct,
    required this.value,
    required this.color,
  });

  final String label;
  final double pct;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 14,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: Stack(
              children: [
                const ColoredBox(color: _dashSurface2),
                FractionallySizedBox(
                  widthFactor: math.min(pct / 100, 1),
                  child: ColoredBox(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onQueue, required this.onArmStatus});

  final VoidCallback onQueue;
  final VoidCallback onArmStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            key: RegulatoryReportsDashboardPage.actionKey('queue'),
            label: 'Live Queue',
            icon: Icons.waves_rounded,
            color: _dashBlue,
            onTap: onQueue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickAction(
            key: RegulatoryReportsDashboardPage.actionKey('arm-status'),
            label: 'ARM Status',
            icon: Icons.shield_outlined,
            color: _dashGreen,
            onTap: onArmStatus,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _dashSurface2,
          border: Border.all(color: _dashBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
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
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: _dashBlue,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _dashSurface,
        border: Border.all(color: _dashBorder.withValues(alpha: .7)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _NoticePanel extends StatelessWidget {
  const _NoticePanel({required this.text, required this.onClose});

  final String text;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 108 + MediaQuery.paddingOf(context).bottom,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          decoration: BoxDecoration(
            color: _dashSurface,
            border: Border.all(color: _dashGreen.withValues(alpha: .35)),
            borderRadius: AppRadii.cardRadius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x99000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _dashGreen,
                size: 18,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({required this.stats});

  final List<TradeRegulatoryDailyStat> stats;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = _dashBorder.withValues(alpha: .62)
      ..strokeWidth = 1;
    final axis = Paint()
      ..color = AppColors.text3.withValues(alpha: .50)
      ..strokeWidth = 1;
    final chartRect = Rect.fromLTWH(58, 8, size.width - 66, size.height - 34);
    const maxValue = 240.0;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final label in const [240, 180, 120, 60, 0]) {
      final y = chartRect.bottom - (label / maxValue) * chartRect.height;
      _drawDashedLine(
        canvas,
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        grid,
      );
      textPainter.text = TextSpan(
        text: '$label',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartRect.left - textPainter.width - 8, y - 6),
      );
    }

    for (var i = 0; i < stats.length; i++) {
      final x = chartRect.left + chartRect.width * i / (stats.length - 1);
      _drawDashedLine(
        canvas,
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        grid,
      );
    }

    canvas.drawLine(chartRect.topLeft, chartRect.bottomLeft, axis);
    canvas.drawLine(chartRect.bottomLeft, chartRect.bottomRight, axis);

    _drawLine(
      canvas,
      chartRect,
      stats.map((item) => item.total.toDouble()).toList(),
      _dashBlue,
      maxValue,
    );
    _drawLine(
      canvas,
      chartRect,
      stats.map((item) => item.confirmed.toDouble()).toList(),
      _dashGreen,
      maxValue,
    );
    _drawLine(
      canvas,
      chartRect,
      stats.map((item) => item.failed.toDouble()).toList(),
      _dashRed,
      maxValue,
    );

    for (var i = 0; i < stats.length; i++) {
      final x = chartRect.left + chartRect.width * i / (stats.length - 1);
      textPainter.text = TextSpan(
        text: stats[i].date,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 9,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartRect.bottom + 8),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 3.0;
    const gap = 3.0;
    final distance = (end - start).distance;
    if (distance == 0) {
      return;
    }
    final direction = Offset(
      (end.dx - start.dx) / distance,
      (end.dy - start.dy) / distance,
    );
    var drawn = 0.0;
    while (drawn < distance) {
      final segmentEnd = math.min(drawn + dash, distance);
      canvas.drawLine(
        start + direction * drawn,
        start + direction * segmentEnd,
        paint,
      );
      drawn += dash + gap;
    }
  }

  void _drawLine(
    Canvas canvas,
    Rect chartRect,
    List<double> values,
    Color color,
    double maxValue,
  ) {
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chartRect.left + chartRect.width * i / (values.length - 1);
      final normalized = (values[i] / maxValue).clamp(0.0, 1.0).toDouble();
      final y = chartRect.bottom - normalized * chartRect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = color);
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

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.stats != stats;
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.items});

  final List<TradeRegulatoryDistributionItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    final total = items.fold<int>(0, (sum, item) => sum + item.value);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 14;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;
    for (final item in items) {
      final sweep = item.value / total * math.pi * 2;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = Color(item.colorHex)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 22
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: _formatInt(total),
        style: AppTextStyles.sectionTitle.copyWith(
          color: AppColors.text1,
          fontSize: 20,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    )..layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.items != items;
  }
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
