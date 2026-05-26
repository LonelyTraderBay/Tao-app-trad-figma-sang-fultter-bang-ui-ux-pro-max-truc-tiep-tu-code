import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _reportBackground = AppColors.bg;
const _reportPanel = AppColors.surface;
const _reportPanel2 = AppColors.surface2;
const _reportBorder = AppColors.borderSolid;
const _reportPrimary = AppColors.primary;
const _reportGreen = Color(0xFF10B981);
const _reportRed = Color(0xFFEF4444);
const _reportAmber = Color(0xFFF59E0B);
const _reportMuted = Color(0xFF94A3B8);

class TransactionReportingPage extends ConsumerStatefulWidget {
  const TransactionReportingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc093_transaction_reporting_content');
  static const searchKey = Key('sc093_transaction_reporting_search');
  static Key tabKey(String id) => Key('sc093_transaction_tab_$id');
  static Key actionKey(String id) => Key('sc093_transaction_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TransactionReportingPage> createState() =>
      _TransactionReportingPageState();
}

class _TransactionReportingPageState
    extends ConsumerState<TransactionReportingPage> {
  String _tab = 'queue';
  String _query = '';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getTransactionReporting();
    final reports = _filteredReports(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-093 TransactionReportingPage',
      child: Material(
        color: _reportBackground,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: 'Transaction Reporting',
                  subtitle: 'MiFID II - EMIR Compliance',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: TransactionReportingPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _ComplianceNotice(),
                        const SizedBox(height: 14),
                        _StatsGrid(stats: snapshot.stats),
                        const SizedBox(height: 14),
                        _SearchField(
                          query: _query,
                          onChanged: (value) => setState(() => _query = value),
                        ),
                        const SizedBox(height: 14),
                        _Tabs(
                          activeId: _tab,
                          stats: snapshot.stats,
                          onChanged: (id) => setState(() => _tab = id),
                        ),
                        const SizedBox(height: 16),
                        if (_tab == 'stats')
                          _StatsTab(stats: snapshot.stats)
                        else
                          _ReportsSection(
                            reports: reports,
                            query: _query,
                            onViewXml: (report) => setState(() {
                              _notice = 'ISO 20022 XML: ${report.id}';
                            }),
                            onRetry: (report) => setState(() {
                              _notice = 'Retry queued: ${report.id}';
                            }),
                            onCopy: (report) {
                              final messageId = report.messageId;
                              if (messageId == null) return;
                              Clipboard.setData(ClipboardData(text: messageId));
                              setState(() => _notice = 'Message ID copied');
                            },
                          ),
                        const SizedBox(height: 14),
                        _QuickActions(
                          onDashboard: () => context.go(
                            AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
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

  List<TradeTransactionReport> _filteredReports(
    TradeTransactionReportingSnapshot snapshot,
  ) {
    final reports = snapshot.reportsForTab(_tab);
    if (_query.trim().isEmpty) return reports;
    final query = _query.toLowerCase();
    return reports
        .where(
          (report) =>
              report.transactionId.toLowerCase().contains(query) ||
              report.instrument.toLowerCase().contains(query),
        )
        .toList();
  }
}

class _ComplianceNotice extends StatelessWidget {
  const _ComplianceNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: _reportPrimary.withValues(alpha: .10),
        border: Border.all(color: _reportPrimary.withValues(alpha: .35)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: _reportPrimary, size: 17),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MiFID II Article 26 Compliance',
                  style: AppTextStyles.caption.copyWith(
                    color: _reportPrimary,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'All transactions must be reported to ARM within T+1. Reports include 65+ RTS 22 fields. Auto-submission enabled.',
                  style: AppTextStyles.micro.copyWith(
                    color: _reportPrimary,
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

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final TradeTransactionReportingStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total Today',
            value: '${stats.total}',
            caption: '${stats.confirmed} confirmed',
            color: AppColors.primary,
            icon: Icons.description_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Avg Latency',
            value: '${stats.avgLatencySeconds}s',
            caption: 'Under 60s SLA',
            color: _reportGreen,
            icon: Icons.bolt_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'SLA Compliance',
            value: '${(stats.onTime / stats.total * 100).toStringAsFixed(0)}%',
            caption: '${stats.onTime}/${stats.total} on-time',
            color: _reportGreen,
            icon: Icons.trending_up_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final String caption;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 11),
      decoration: BoxDecoration(
        color: _reportPanel,
        border: Border.all(color: _reportBorder.withValues(alpha: .65)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  value,
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
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.smRadius,
            ),
            child: Icon(icon, color: color, size: 17),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.query, required this.onChanged});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        key: TransactionReportingPage.searchKey,
        controller: TextEditingController(text: query)
          ..selection = TextSelection.collapsed(offset: query.length),
        onChanged: onChanged,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontSize: 13,
          height: 1,
        ),
        decoration: InputDecoration(
          hintText: 'Search by transaction ID or instrument...',
          hintStyle: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.text3,
            size: 18,
          ),
          filled: true,
          fillColor: _reportPanel2,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: AppRadii.cardRadius,
            borderSide: const BorderSide(color: _reportBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadii.cardRadius,
            borderSide: const BorderSide(color: _reportBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadii.cardRadius,
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.activeId,
    required this.stats,
    required this.onChanged,
  });

  final String activeId;
  final TradeTransactionReportingStats stats;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('queue', 'Queue (${stats.pending})'),
      ('history', 'History'),
      ('failed', 'Failed (${stats.failed})'),
      ('stats', 'Stats'),
    ];

    return Container(
      height: 54,
      color: _reportPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: TransactionReportingPage.tabKey(tab.$1),
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
                                ? AppColors.primary
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
                      color: AppColors.primary,
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

class _ReportsSection extends StatelessWidget {
  const _ReportsSection({
    required this.reports,
    required this.query,
    required this.onViewXml,
    required this.onRetry,
    required this.onCopy,
  });

  final List<TradeTransactionReport> reports;
  final String query;
  final ValueChanged<TradeTransactionReport> onViewXml;
  final ValueChanged<TradeTransactionReport> onRetry;
  final ValueChanged<TradeTransactionReport> onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${reports.length} Reports',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        if (reports.isEmpty)
          _EmptyReports(query: query)
        else
          for (final report in reports) ...[
            _ReportCard(
              report: report,
              onViewXml: () => onViewXml(report),
              onRetry: () => onRetry(report),
              onCopy: () => onCopy(report),
            ),
            if (report != reports.last) const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.report,
    required this.onViewXml,
    required this.onRetry,
    required this.onCopy,
  });

  final TradeTransactionReport report;
  final VoidCallback onViewXml;
  final VoidCallback onRetry;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final status = _statusConfig(report.status);
    final sla = _slaConfig(report.slaStatus);
    final sideColor = report.side == 'buy' ? _reportGreen : _reportRed;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: _reportPanel,
        border: Border.all(color: _reportBorder.withValues(alpha: .7)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Icon(status.icon, color: status.color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  report.instrument,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                    fontSize: 13,
                                    fontWeight: AppTextStyles.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              _SmallPill(
                                label: report.side.toUpperCase(),
                                color: sideColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '${report.transactionId} - ${report.tradingVenue}',
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
                    _SmallPill(label: status.label, color: status.color),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DetailValue(
                        label: 'Qty',
                        value: _formatAmount(report.quantity),
                      ),
                    ),
                    Expanded(
                      child: _DetailValue(
                        label: 'Value',
                        value: _formatUsd(report.value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: _DetailValue(
                        label: 'ARM',
                        value: report.armProvider,
                      ),
                    ),
                    Expanded(
                      child: _DetailValue(
                        label: 'Type',
                        value: report.reportType.toUpperCase(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: sla.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      sla.label,
                      style: AppTextStyles.micro.copyWith(
                        color: sla.color,
                        fontSize: 9,
                        fontWeight: AppTextStyles.bold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                if (report.errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(9, 8, 9, 8),
                    decoration: BoxDecoration(
                      color: _reportRed.withValues(alpha: .10),
                      border: Border.all(
                        color: _reportRed.withValues(alpha: .28),
                      ),
                      borderRadius: AppRadii.smRadius,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: _reportRed,
                          size: 13,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            report.errorMessage!,
                            style: AppTextStyles.micro.copyWith(
                              color: _reportRed,
                              fontSize: 9,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ActionChip(
                      label: 'View XML',
                      icon: Icons.visibility_outlined,
                      onTap: onViewXml,
                    ),
                    if (report.status == 'failed')
                      _ActionChip(
                        label: 'Retry',
                        icon: Icons.refresh_rounded,
                        color: AppColors.primary,
                        onTap: onRetry,
                      ),
                    if (report.messageId != null)
                      _ActionChip(
                        label: 'Copy ID',
                        icon: Icons.copy_rounded,
                        onTap: onCopy,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
            height: 1,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 10,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text2,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: color == AppColors.text2 ? .08 : .14),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
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
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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

class _StatsTab extends StatelessWidget {
  const _StatsTab({required this.stats});

  final TradeTransactionReportingStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Reporting Statistics',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _reportPanel,
            border: Border.all(color: _reportBorder.withValues(alpha: .7)),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatColumn(
                  title: "Today's Volume",
                  rows: [
                    ('MiFID II Reports', '${stats.mifidReports}'),
                    ('EMIR Reports', '${stats.emirReports}'),
                    ('Total Value', _formatUsd(stats.totalValue)),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _StatColumn(
                  title: 'ARM Providers',
                  rows: stats.providerCounts.entries
                      .map((entry) => (entry.key, '${entry.value}'))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: FilledButton.icon(
            key: TransactionReportingPage.actionKey('dashboard-primary'),
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyRegulatoryReportsDashboard),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            icon: const Icon(Icons.bar_chart_rounded, size: 17),
            label: const Text('View Full Dashboard'),
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 11,
            height: 1,
          ),
        ),
        const SizedBox(height: 11),
        for (final row in rows) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  row.$1,
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
                row.$2,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                  height: 1,
                ),
              ),
            ],
          ),
          if (row != rows.last) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _EmptyReports extends StatelessWidget {
  const _EmptyReports({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
      decoration: BoxDecoration(
        color: _reportPanel,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Icon(
            Icons.storage_outlined,
            color: AppColors.text3.withValues(alpha: .5),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'No reports found',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 6),
          Text(
            query.isEmpty
                ? 'Reports will appear here automatically'
                : 'Try a different search term',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onDashboard, required this.onArmStatus});

  final VoidCallback onDashboard;
  final VoidCallback onArmStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            key: TransactionReportingPage.actionKey('dashboard'),
            icon: Icons.bar_chart_rounded,
            title: 'Dashboard',
            subtitle: 'View all reports',
            color: AppColors.primary,
            onTap: onDashboard,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            key: TransactionReportingPage.actionKey('arm-status'),
            icon: Icons.monitor_heart_outlined,
            title: 'ARM Status',
            subtitle: 'Connection health',
            color: _reportGreen,
            onTap: onArmStatus,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 88,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _reportPanel2,
          border: Border.all(color: _reportBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 19),
            const Spacer(),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
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
            color: _reportPanel,
            border: Border.all(color: AppColors.primary.withValues(alpha: .4)),
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
                color: _reportGreen,
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

({Color color, String label, IconData icon}) _statusConfig(String status) {
  return switch (status) {
    'pending' => (
      color: _reportMuted,
      label: 'Pending',
      icon: Icons.schedule_rounded,
    ),
    'submitting' => (
      color: _reportPrimary,
      label: 'Submitting',
      icon: Icons.send_rounded,
    ),
    'submitted' => (
      color: _reportAmber,
      label: 'Submitted',
      icon: Icons.waves_rounded,
    ),
    'confirmed' => (
      color: _reportGreen,
      label: 'Confirmed',
      icon: Icons.check_circle_outline,
    ),
    'failed' => (
      color: _reportRed,
      label: 'Failed',
      icon: Icons.cancel_outlined,
    ),
    _ => (color: _reportAmber, label: 'Retrying', icon: Icons.refresh_rounded),
  };
}

({Color color, String label}) _slaConfig(String status) {
  return switch (status) {
    'warning' => (color: _reportAmber, label: 'Warning'),
    'breach' => (color: _reportRed, label: 'SLA Breach'),
    _ => (color: _reportGreen, label: 'On-time'),
  };
}

String _formatUsd(double value) {
  final raw = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(value < 1 ? 2 : 1);
}
