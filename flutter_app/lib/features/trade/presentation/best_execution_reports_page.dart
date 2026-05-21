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

const _bestBg = Color(0xFF080C14);
const _bestSurface = Color(0xFF151A23);
const _bestSurface2 = Color(0xFF1E2535);
const _bestBorder = Color(0xFF273142);
const _bestGreen = Color(0xFF10B981);
const _bestAmber = Color(0xFFF59E0B);
const _bestBlue = Color(0xFF3B82F6);

class BestExecutionReportsPage extends ConsumerStatefulWidget {
  const BestExecutionReportsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc096_best_execution_content');
  static Key tabKey(String id) => Key('sc096_best_execution_tab_$id');
  static Key venueKey(int rank) => Key('sc096_best_execution_venue_$rank');
  static const analysisKey = Key('sc096_best_execution_analysis');
  static const exportKey = Key('sc096_best_execution_export');
  static const publishKey = Key('sc096_best_execution_publish');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BestExecutionReportsPage> createState() =>
      _BestExecutionReportsPageState();
}

class _BestExecutionReportsPageState
    extends ConsumerState<BestExecutionReportsPage> {
  String _tab = 'current';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getBestExecutionReports();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-096 BestExecutionReportsPage',
      child: Material(
        color: _bestBg,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Best Execution Reports',
                  subtitle: 'RTS 27 / RTS 28 Compliance',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                  trailing: IconButton(
                    onPressed: () =>
                        setState(() => _notice = 'PDF export queued'),
                    icon: const Icon(Icons.download_rounded, size: 19),
                    color: AppColors.text1,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: BestExecutionReportsPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _ComplianceNotice(),
                        const SizedBox(height: 22),
                        _SummaryGrid(summary: snapshot.summary),
                        const SizedBox(height: 26),
                        _Tabs(activeId: _tab, onChanged: _setTab),
                        const SizedBox(height: 26),
                        if (_tab == 'current')
                          _CurrentReport(
                            venues: snapshot.venues,
                            onAnalysis: () => context.go(
                              AppRoutePaths.tradeCopyExecutionVenueAnalysis,
                            ),
                            onExport: () =>
                                setState(() => _notice = 'PDF export queued'),
                            onPublish: () =>
                                setState(() => _notice = 'Report submitted'),
                          )
                        else
                          _ArchiveReport(
                            reports: snapshot.archive,
                            onExport: (id) =>
                                setState(() => _notice = '$id PDF queued'),
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

  void _setTab(String tab) => setState(() => _tab = tab);
}

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice();

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
          const Icon(Icons.shield_outlined, color: AppColors.text1, size: 17),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MiFID II RTS 27/28 Compliance',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Quarterly disclosure of Top 5 execution venues by trading volume. Reports assessed on price, cost, speed, likelihood of execution, and settlement.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final TradeBestExecutionSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.bar_chart_rounded,
            iconColor: _bestBlue,
            label: 'Total Orders',
            value: _formatInt(summary.totalOrders),
            subtitle: 'Q1 2026 (YTD)',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.attach_money_rounded,
            iconColor: _bestGreen,
            label: 'Total Value',
            value: '\$${(summary.totalValue / 1000000000).toStringAsFixed(2)}B',
            subtitle: 'Executed value',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.workspace_premium_outlined,
            iconColor: _bestAmber,
            label: 'Avg Score',
            value: summary.avgScore.toStringAsFixed(1),
            subtitle: 'Quality index',
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: const EdgeInsets.fromLTRB(12, 13, 12, 12),
      decoration: BoxDecoration(
        color: _bestSurface,
        border: Border.all(color: _bestBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 15),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
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
          const SizedBox(height: 16),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontSize: 20,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [('current', 'Q1 2026 (Current)'), ('archive', 'Archive')];
    return Container(
      height: 52,
      color: _bestSurface,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: BestExecutionReportsPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _bestBlue
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 160 : 0,
                      height: 2,
                      color: _bestBlue,
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

class _CurrentReport extends StatelessWidget {
  const _CurrentReport({
    required this.venues,
    required this.onAnalysis,
    required this.onExport,
    required this.onPublish,
  });

  final List<TradeExecutionVenue> venues;
  final VoidCallback onAnalysis;
  final VoidCallback onExport;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Top 5 Execution Venues (By Volume)'),
        const SizedBox(height: 12),
        for (final venue in venues) ...[
          _VenueCard(venue: venue),
          if (venue != venues.last) const SizedBox(height: 12),
        ],
        const SizedBox(height: 20),
        _AnalysisButton(onTap: onAnalysis),
        const SizedBox(height: 26),
        const _SectionLabel('Report Actions'),
        const SizedBox(height: 12),
        _ReportActions(onExport: onExport, onPublish: onPublish),
      ],
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.venue});

  final TradeExecutionVenue venue;

  @override
  Widget build(BuildContext context) {
    final isWinner = venue.rank == 1;
    return Container(
      key: BestExecutionReportsPage.venueKey(venue.rank),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bestSurface,
        border: Border.all(color: _bestBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isWinner
                      ? _bestAmber.withValues(alpha: .15)
                      : _bestSurface2,
                  border: isWinner
                      ? Border.all(color: _bestAmber, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '#${venue.rank}',
                  style: AppTextStyles.body.copyWith(
                    color: isWinner ? _bestAmber : AppColors.text1,
                    fontSize: 18,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            venue.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontSize: 15,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        if (isWinner) ...[
                          const SizedBox(width: 9),
                          const Icon(
                            Icons.workspace_premium_outlined,
                            color: _bestAmber,
                            size: 15,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      '${_formatInt(venue.volume)} orders • ${_formatUsd(venue.value)} value',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    venue.score.toStringAsFixed(1),
                    style: AppTextStyles.body.copyWith(
                      color: _bestGreen,
                      fontSize: 20,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Quality',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _VenueMetric(
                  label: 'Avg Price',
                  value: '\$${_formatInt(venue.avgPrice)}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VenueMetric(
                  label: 'Cost',
                  value:
                      '${venue.avgCost.toStringAsFixed(venue.avgCost == .10 ? 1 : 2)}%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VenueMetric(
                  label: 'Speed',
                  value:
                      '${venue.avgSpeed.toStringAsFixed(venue.avgSpeed == .3 || venue.avgSpeed == .4 || venue.avgSpeed == .5 ? 1 : 2)}s',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _VenueMetric(
                  label: 'Fill Rate',
                  value: '${venue.fillRate.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Composite Quality Score',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${venue.score.toStringAsFixed(1)}/100',
                style: AppTextStyles.micro.copyWith(
                  color: _bestGreen,
                  fontSize: 10,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  const ColoredBox(color: _bestSurface2),
                  FractionallySizedBox(
                    widthFactor: (venue.score / 100).clamp(0, 1).toDouble(),
                    child: const ColoredBox(color: _bestGreen),
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

class _VenueMetric extends StatelessWidget {
  const _VenueMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
      decoration: BoxDecoration(
        color: _bestSurface2,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisButton extends StatelessWidget {
  const _AnalysisButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: BestExecutionReportsPage.analysisKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: _bestSurface2,
          border: Border.all(color: _bestBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bar_chart_rounded,
              color: AppColors.text1,
              size: 17,
            ),
            const SizedBox(width: 9),
            Text(
              'View Detailed Analysis',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(width: 7),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text1,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportActions extends StatelessWidget {
  const _ReportActions({required this.onExport, required this.onPublish});

  final VoidCallback onExport;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _bestBlue.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.description_outlined,
                  color: _bestBlue,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q1 2026 Best Execution Report',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Report period: Jan 1 - Mar 31, 2026. Due date: April 15, 2026. Status: Draft.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  key: BestExecutionReportsPage.exportKey,
                  label: 'Export PDF',
                  icon: Icons.download_rounded,
                  background: _bestSurface2,
                  foreground: AppColors.text1,
                  bordered: true,
                  onTap: onExport,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  key: BestExecutionReportsPage.publishKey,
                  label: 'Publish Report',
                  icon: Icons.open_in_new_rounded,
                  background: _bestBlue,
                  foreground: Colors.white,
                  onTap: onPublish,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArchiveReport extends StatelessWidget {
  const _ArchiveReport({required this.reports, required this.onExport});

  final List<TradeQuarterlyReport> reports;
  final ValueChanged<String> onExport;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Historical Reports'),
        const SizedBox(height: 12),
        for (final report in reports) ...[
          _Card(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _bestBlue.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: _bestBlue,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${report.quarter} ${report.year}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.period,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                _ReportStatus(status: report.status),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => onExport(report.id),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.download_rounded, size: 16),
                  color: AppColors.text3,
                ),
              ],
            ),
          ),
          if (report != reports.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ReportStatus extends StatelessWidget {
  const _ReportStatus({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final published = status == 'published';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: published ? _bestGreen.withValues(alpha: .14) : _bestSurface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        published ? 'Published' : 'Draft',
        style: AppTextStyles.micro.copyWith(
          color: published ? _bestGreen : AppColors.text3,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.bordered = false,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: background,
          border: bordered ? Border.all(color: _bestBorder) : null,
          borderRadius: BorderRadius.circular(13),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground, size: 15),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: foreground,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
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
            color: _bestBlue,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
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
        color: _bestSurface,
        border: Border.all(color: _bestBorder.withValues(alpha: .72)),
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
      top: MediaQuery.paddingOf(context).top + 18,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
          decoration: BoxDecoration(
            color: _bestSurface2,
            border: Border.all(color: _bestBorder),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: _bestGreen,
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

String _formatInt(num value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final indexFromEnd = text.length - i;
    buffer.write(text[i]);
    if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _formatUsd(double value) {
  return '\$${_formatInt(value)}.00';
}
