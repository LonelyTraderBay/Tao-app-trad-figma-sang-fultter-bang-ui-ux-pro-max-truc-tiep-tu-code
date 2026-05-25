import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class StakingAuditReportsPage extends ConsumerStatefulWidget {
  const StakingAuditReportsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc374_audit_hero');
  static const statsKey = Key('sc374_audit_stats');
  static const tabsKey = Key('sc374_audit_tabs');
  static const reportsListKey = Key('sc374_audit_reports_list');
  static const bugBountyKey = Key('sc374_bug_bounty');
  static const bugBountyCtaKey = Key('sc374_bug_bounty_cta');
  static const footerKey = Key('sc374_footer');

  static Key reportKey(String id) => Key('sc374_report_$id');
  static Key downloadButtonKey(String id) => Key('sc374_download_$id');
  static Key viewButtonKey(String id) => Key('sc374_view_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAuditReportsPage> createState() =>
      _StakingAuditReportsPageState();
}

class _StakingAuditReportsPageState
    extends ConsumerState<StakingAuditReportsPage> {
  String? _activeTab;
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingAuditReportsRepositoryProvider)
        .getAuditReports();
    _activeTab ??= snapshot.defaultTabId;
    final reports = _filteredReports(snapshot.reports, _activeTab!);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-374 StakingAuditReportsPage',
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
                    _HeroCard(snapshot: snapshot),
                    _StatsSummary(stats: snapshot.stats),
                    _Tabs(
                      tabs: snapshot.tabs,
                      activeTab: _activeTab!,
                      onChanged: (id) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _activeTab = id;
                          _feedback = null;
                        });
                      },
                    ),
                    if (_feedback != null) _FeedbackNote(text: _feedback!),
                    _ReportList(
                      reports: reports,
                      onDownload: _downloadReport,
                      onView: _viewReport,
                    ),
                    _BugBountySection(
                      bugBounty: snapshot.bugBounty,
                      onOpen: _openBugBounty,
                    ),
                    _FooterNote(text: snapshot.footerNote),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<StakingAuditReportDraft> _filteredReports(
    List<StakingAuditReportDraft> reports,
    String tab,
  ) {
    if (tab == 'all') return reports;
    return [
      for (final report in reports)
        if (_typeId(report.type) == tab) report,
    ];
  }

  void _downloadReport(StakingAuditReportDraft report) {
    HapticFeedback.selectionClick();
    setState(() => _feedback = 'Preparing ${report.title} PDF export');
  }

  void _viewReport(StakingAuditReportDraft report) {
    HapticFeedback.selectionClick();
    setState(() => _feedback = 'Opening ${report.title}');
  }

  void _openBugBounty() {
    HapticFeedback.selectionClick();
    setState(() => _feedback = 'Opening Immunefi bug bounty program');
  }
}

class _FeedbackNote extends StatelessWidget {
  const _FeedbackNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final StakingAuditReportsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAuditReportsPage.heroKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.heroBody,
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

class _StatsSummary extends StatelessWidget {
  const _StatsSummary({required this.stats});

  final List<StakingAuditStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAuditReportsPage.statsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          for (final stat in stats) ...[
            Expanded(child: _StatItem(stat: stat)),
            if (stat != stats.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat});

  final StakingAuditStatDraft stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stat.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          stat.value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: _toneColor(stat.tone),
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        if (stat.caption != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.caption!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<StakingAuditTabDraft> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: StakingAuditReportsPage.tabsKey,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
        activeKey: activeTab,
        onChanged: onChanged,
      ),
    );
  }
}

class _ReportList extends StatelessWidget {
  const _ReportList({
    required this.reports,
    required this.onDownload,
    required this.onView,
  });

  final List<StakingAuditReportDraft> reports;
  final ValueChanged<StakingAuditReportDraft> onDownload;
  final ValueChanged<StakingAuditReportDraft> onView;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingAuditReportsPage.reportsListKey,
      children: [
        for (final report in reports) ...[
          _ReportCard(
            key: StakingAuditReportsPage.reportKey(report.id),
            report: report,
            onDownload: () => onDownload(report),
            onView: () => onView(report),
          ),
          if (report != reports.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    super.key,
    required this.report,
    required this.onDownload,
    required this.onView,
  });

  final StakingAuditReportDraft report;
  final VoidCallback onDownload;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final typeColor = _reportTypeColor(report.type);
    final isPublished = report.status == StakingAuditReportStatus.published;

    return Opacity(
      opacity: isPublished ? 1 : 0.78,
      child: VitCard(
        radius: VitCardRadius.lg,
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoundIcon(icon: Icons.description_outlined, color: typeColor),
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
                              report.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          Icon(
                            isPublished
                                ? Icons.check_circle_outline_rounded
                                : Icons.schedule_rounded,
                            color: isPublished ? AppColors.buy : AppColors.warn,
                            size: AppSpacing.iconSm,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        'By ${report.auditor} \u2022 ${report.dateLabel}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _SmallPill(
                          label: _reportTypeLabel(report.type),
                          color: typeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              report.summary,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
            if (isPublished && report.findings.resolvedFindings > 0) ...[
              const SizedBox(height: AppSpacing.x4),
              _FindingsSummary(findings: report.findings),
            ],
            const SizedBox(height: AppSpacing.x4),
            _ScopeList(scope: report.scope),
            if (isPublished && report.pdfUrl != null) ...[
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      key: StakingAuditReportsPage.downloadButtonKey(report.id),
                      label: 'Download PDF',
                      icon: Icons.download_rounded,
                      primary: true,
                      onTap: onDownload,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _ActionButton(
                      key: StakingAuditReportsPage.viewButtonKey(report.id),
                      label: 'View',
                      icon: Icons.open_in_new_rounded,
                      primary: false,
                      onTap: onView,
                    ),
                  ),
                ],
              ),
            ],
            if (!isPublished) ...[
              const SizedBox(height: AppSpacing.x4),
              _ProgressNote(report: report),
            ],
          ],
        ),
      ),
    );
  }
}

class _FindingsSummary extends StatelessWidget {
  const _FindingsSummary({required this.findings});

  final StakingAuditFindingsDraft findings;

  @override
  Widget build(BuildContext context) {
    final items = [
      _FindingItem('Critical', findings.critical, AppColors.sell),
      _FindingItem('High', findings.high, AppColors.warn),
      _FindingItem('Medium', findings.medium, AppColors.primarySoft),
      _FindingItem('Low', findings.low, AppColors.primary),
      _FindingItem('Info', findings.informational, AppColors.text3),
    ];

    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Findings Summary',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(children: [for (final item in items) Expanded(child: item)]),
        ],
      ),
    );
  }
}

class _FindingItem extends StatelessWidget {
  const _FindingItem(this.label, this.value, this.color);

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: AppTextStyles.baseMedium.copyWith(color: color)),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ScopeList extends StatelessWidget {
  const _ScopeList({required this.scope});

  final List<String> scope;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scope',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final item in scope)
              _SmallPill(label: item, color: AppColors.text2),
          ],
        ),
      ],
    );
  }
}

class _ProgressNote extends StatelessWidget {
  const _ProgressNote({required this.report});

  final StakingAuditReportDraft report;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Audit in progress - Expected: ${report.dateLabel}',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BugBountySection extends StatelessWidget {
  const _BugBountySection({required this.bugBounty, required this.onOpen});

  final StakingBugBountyDraft bugBounty;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Bug Bounty Program',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          key: StakingAuditReportsPage.bugBountyKey,
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _RoundIcon(
                    icon: Icons.shield_outlined,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bugBounty.title, style: AppTextStyles.baseMedium),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          bugBounty.subtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                bugBounty.body,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.55,
                  crossAxisSpacing: AppSpacing.x3,
                  mainAxisSpacing: AppSpacing.x2,
                  children: [
                    for (final payout in bugBounty.payouts)
                      _PayoutItem(payout: payout),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              _ActionButton(
                key: StakingAuditReportsPage.bugBountyCtaKey,
                label: 'View on Immunefi',
                icon: Icons.open_in_new_rounded,
                primary: true,
                onTap: onOpen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PayoutItem extends StatelessWidget {
  const _PayoutItem({required this.payout});

  final StakingBugBountyPayoutDraft payout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          payout.severity,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          payout.amount,
          style: AppTextStyles.baseMedium.copyWith(
            color: _toneColor(payout.tone),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = primary ? AppColors.primary : AppColors.surface3;
    final fg = primary ? AppColors.text1 : AppColors.text1;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: bg,
        borderRadius: AppRadii.lgRadius,
        child: InkWell(
          borderRadius: AppRadii.lgRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: fg, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: fg,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAuditReportsPage.footerKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: 1.5,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

String _typeId(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => 'smart-contract',
    StakingAuditReportType.financial => 'financial',
    StakingAuditReportType.security => 'security',
  };
}

String _reportTypeLabel(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => 'Smart Contract',
    StakingAuditReportType.financial => 'Financial',
    StakingAuditReportType.security => 'Security',
  };
}

Color _reportTypeColor(StakingAuditReportType type) {
  return switch (type) {
    StakingAuditReportType.smartContract => AppColors.accent,
    StakingAuditReportType.financial => AppColors.buy,
    StakingAuditReportType.security => AppColors.warn,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}
