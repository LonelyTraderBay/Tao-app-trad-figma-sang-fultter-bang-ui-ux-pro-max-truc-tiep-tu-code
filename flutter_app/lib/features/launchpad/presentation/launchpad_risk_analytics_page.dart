import 'dart:math' as math;

import 'package:flutter/material.dart';
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
import '../data/launchpad_repository.dart';

enum _RiskAnalyticsTab { overview, dueDiligence, report }

class LaunchpadRiskAnalyticsPage extends ConsumerStatefulWidget {
  const LaunchpadRiskAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc317_launchpad_risk_content');
  static const tabsKey = Key('sc317_launchpad_risk_tabs');
  static const scoreKey = Key('sc317_launchpad_risk_score');
  static const breakdownKey = Key('sc317_launchpad_risk_breakdown');
  static const quickChecksKey = Key('sc317_launchpad_risk_quick_checks');
  static const warningsKey = Key('sc317_launchpad_risk_warnings');
  static const strengthsKey = Key('sc317_launchpad_risk_strengths');
  static const dueDiligenceKey = Key('sc317_launchpad_risk_due_diligence');
  static const reportKey = Key('sc317_launchpad_risk_report');
  static const distributionKey = Key('sc317_launchpad_risk_distribution');

  static Key projectKey(String id) => Key('sc317_launchpad_risk_project_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadRiskAnalyticsPage> createState() =>
      _LaunchpadRiskAnalyticsPageState();
}

class _LaunchpadRiskAnalyticsPageState
    extends ConsumerState<LaunchpadRiskAnalyticsPage> {
  var _activeTab = _RiskAnalyticsTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getRiskAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        navInset + MediaQuery.paddingOf(context).bottom + AppSpacing.x6;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-317 LaunchpadRiskAnalyticsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _Tabs(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: LaunchpadRiskAnalyticsPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.defaultPadding,
                  customGap: AppSpacing.x4,
                  children: [
                    if (_activeTab == _RiskAnalyticsTab.overview) ...[
                      _OverallRiskCard(project: snapshot.project),
                      _RiskBreakdownCard(metrics: snapshot.metrics),
                      _QuickChecksSection(project: snapshot.project),
                      _SignalSection(
                        sectionKey: LaunchpadRiskAnalyticsPage.warningsKey,
                        label: 'Canh bao',
                        accent: AppColors.sell,
                        icon: Icons.warning_amber_rounded,
                        messages: snapshot.project.warnings,
                      ),
                      _SignalSection(
                        sectionKey: LaunchpadRiskAnalyticsPage.strengthsKey,
                        label: 'Diem manh',
                        accent: AppColors.buy,
                        icon: Icons.check_circle_outline_rounded,
                        messages: snapshot.project.strengths,
                      ),
                    ] else if (_activeTab ==
                        _RiskAnalyticsTab.dueDiligence) ...[
                      _DueDiligenceTab(snapshot: snapshot),
                    ] else ...[
                      _ReportTab(snapshot: snapshot),
                    ],
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeTab, required this.onChanged});

  final _RiskAnalyticsTab activeTab;
  final ValueChanged<_RiskAnalyticsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadRiskAnalyticsPage.tabsKey,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: VitTabBar(
        tabs: const [
          VitTabItem(key: 'overview', label: 'Tong quan'),
          VitTabItem(key: 'dueDiligence', label: 'Due Diligence'),
          VitTabItem(key: 'report', label: 'Bao cao'),
        ],
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_RiskAnalyticsTab.values.byName(key)),
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

class _OverallRiskCard extends StatelessWidget {
  const _OverallRiskCard({required this.project});

  final LaunchpadRiskProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(project.level);
    return VitCard(
      key: LaunchpadRiskAnalyticsPage.scoreKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Risk Score',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${project.score.overall}/100',
                      style: AppTextStyles.heroNumber.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    _RiskPill(level: project.level),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Icon(Icons.shield_outlined, color: color, size: 32),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _ScoreProgress(value: project.score.overall, color: color),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Based on 6 metrics: Team, Audit, Tokenomics, Community, Security, Liquidity',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RiskBreakdownCard extends StatelessWidget {
  const _RiskBreakdownCard({required this.metrics});

  final List<LaunchpadRiskMetricDraft> metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadRiskAnalyticsPage.breakdownKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk Breakdown',
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          SizedBox(
            height: 250,
            child: CustomPaint(
              painter: _RadarChartPainter(metrics),
              child: Stack(
                children: [
                  for (var i = 0; i < metrics.length; i++)
                    _RadarLabel(
                      index: i,
                      count: metrics.length,
                      metrics: metrics,
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

class _RadarLabel extends StatelessWidget {
  const _RadarLabel({
    required this.index,
    required this.count,
    required this.metrics,
  });

  final int index;
  final int count;
  final List<LaunchpadRiskMetricDraft> metrics;

  @override
  Widget build(BuildContext context) {
    final angle = -math.pi / 2 + (math.pi * 2 * index / count);
    final x = .5 + math.cos(angle) * .42;
    final y = .5 + math.sin(angle) * .42;
    return Align(
      alignment: Alignment((x * 2) - 1, (y * 2) - 1),
      child: Text(
        metrics[index].label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  _RadarChartPainter(this.metrics);

  final List<LaunchpadRiskMetricDraft> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .34;
    final axisPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final polygonFill = Paint()
      ..color = AppColors.primary.withValues(alpha: .24)
      ..style = PaintingStyle.fill;
    final polygonStroke = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (var ring = 1; ring <= 4; ring++) {
      final path = Path();
      for (var i = 0; i < metrics.length; i++) {
        final point = _point(center, radius * ring / 4, i, metrics.length);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, axisPaint);
    }

    for (var i = 0; i < metrics.length; i++) {
      canvas.drawLine(
        center,
        _point(center, radius, i, metrics.length),
        axisPaint,
      );
    }

    final scorePath = Path();
    for (var i = 0; i < metrics.length; i++) {
      final valueRadius = radius * metrics[i].value / 100;
      final point = _point(center, valueRadius, i, metrics.length);
      if (i == 0) {
        scorePath.moveTo(point.dx, point.dy);
      } else {
        scorePath.lineTo(point.dx, point.dy);
      }
    }
    scorePath.close();
    canvas.drawPath(scorePath, polygonFill);
    canvas.drawPath(scorePath, polygonStroke);
  }

  Offset _point(Offset center, double radius, int index, int count) {
    final angle = -math.pi / 2 + (math.pi * 2 * index / count);
    return Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.metrics != metrics;
  }
}

class _QuickChecksSection extends StatelessWidget {
  const _QuickChecksSection({required this.project});

  final LaunchpadRiskProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final checks = [
      _QuickCheckDraft(
        label: 'Audit Verified',
        icon: Icons.description_outlined,
        status: project.auditStatus == LaunchpadRiskAuditStatus.verified,
      ),
      _QuickCheckDraft(
        label: 'Team Doxxed',
        icon: Icons.groups_2_outlined,
        status: project.teamDoxxed,
      ),
      _QuickCheckDraft(
        label: 'Contract Verified',
        icon: Icons.code_rounded,
        status: project.contractVerified,
      ),
      _QuickCheckDraft(
        label: 'Liquidity Locked',
        icon: Icons.lock_outline_rounded,
        status: project.liquidityLocked,
      ),
    ];

    return Container(
      key: LaunchpadRiskAnalyticsPage.quickChecksKey,
      child: VitPageSection(
        label: 'Kiem tra nhanh',
        accentColor: AppColors.primary,
        children: [
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.x3,
            crossAxisSpacing: AppSpacing.x3,
            childAspectRatio: 2.15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              for (final check in checks) _QuickCheckCard(check: check),
            ],
          ),
        ],
      ),
    );
  }
}

final class _QuickCheckDraft {
  const _QuickCheckDraft({
    required this.label,
    required this.icon,
    required this.status,
  });

  final String label;
  final IconData icon;
  final bool status;
}

class _QuickCheckCard extends StatelessWidget {
  const _QuickCheckCard({required this.check});

  final _QuickCheckDraft check;

  @override
  Widget build(BuildContext context) {
    final color = check.status ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .20)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(check.icon, color: color, size: 16),
              const SizedBox(width: AppSpacing.x2),
              Icon(
                check.status
                    ? Icons.check_circle_outline_rounded
                    : Icons.cancel_outlined,
                color: color,
                size: 15,
              ),
            ],
          ),
          const Spacer(),
          Text(
            check.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalSection extends StatelessWidget {
  const _SignalSection({
    required this.sectionKey,
    required this.label,
    required this.accent,
    required this.icon,
    required this.messages,
  });

  final Key sectionKey;
  final String label;
  final Color accent;
  final IconData icon;
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      child: VitPageSection(
        label: label,
        accentColor: accent,
        children: [
          for (final message in messages)
            Container(
              padding: const EdgeInsets.all(AppSpacing.x3),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .08),
                border: Border.all(color: accent.withValues(alpha: .20)),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: accent, size: 16),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.medium,
                      ),
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

class _DueDiligenceTab extends StatelessWidget {
  const _DueDiligenceTab({required this.snapshot});

  final LaunchpadRiskAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final score = snapshot.project.score;
    return Container(
      key: LaunchpadRiskAnalyticsPage.dueDiligenceKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Team & Governance',
            accentColor: AppColors.buy,
            children: [
              _DueDiligenceCard(
                title: 'Team Transparency',
                score: score.teamTransparency,
                rows: const [
                  _InfoRowDraft(label: 'Doxxed Team', value: 'Verified'),
                  _InfoRowDraft(
                    label: 'LinkedIn Profiles',
                    value: '5/5 verified',
                  ),
                  _InfoRowDraft(
                    label: 'Previous Projects',
                    value: '2 successful',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Security Audit',
            accentColor: AppColors.primary,
            children: [
              _DueDiligenceCard(
                title: 'Audit Score',
                score: score.auditScore,
                rows: [
                  for (final audit in snapshot.auditReports)
                    _InfoRowDraft(
                      label: audit.firm,
                      value:
                          '${audit.status} - ${audit.criticalIssues} critical issues',
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Tokenomics Analysis',
            accentColor: AppColors.warn,
            children: [
              _DueDiligenceCard(
                title: 'Tokenomics Health',
                score: score.tokenomics,
                rows: const [
                  _InfoRowDraft(label: 'Total Supply', value: '1B VIT'),
                  _InfoRowDraft(label: 'Circulating', value: '250M (25%)'),
                  _InfoRowDraft(label: 'Team Tokens', value: '15% locked'),
                  _InfoRowDraft(label: 'Top 10 Holders', value: '45%'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _InfoRowDraft {
  const _InfoRowDraft({required this.label, required this.value});

  final String label;
  final String value;
}

class _DueDiligenceCard extends StatelessWidget {
  const _DueDiligenceCard({
    required this.title,
    required this.score,
    required this.rows,
  });

  final String title;
  final int score;
  final List<_InfoRowDraft> rows;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 58,
                child: _ScoreProgress(value: score, color: color),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '$score',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),
                Text(
                  row.value,
                  style: AppTextStyles.caption.copyWith(
                    color: row.value.contains('45%')
                        ? AppColors.warn
                        : AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
            if (row != rows.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _ReportTab extends StatelessWidget {
  const _ReportTab({required this.snapshot});

  final LaunchpadRiskAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadRiskAnalyticsPage.reportKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'So sanh du an',
            accentColor: AppColors.primary,
            children: [
              for (final project in snapshot.comparisonProjects)
                _ComparisonProjectCard(project: project),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _RiskDistributionCard(projects: snapshot.comparisonProjects),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'Tai lieu tham khao',
            accentColor: AppColors.primary,
            children: [
              for (final resource in snapshot.resources)
                _ResourceRow(resource: resource),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Container(
            padding: const EdgeInsets.all(AppSpacing.x3),
            decoration: BoxDecoration(
              color: AppColors.primary08,
              border: Border.all(color: AppColors.primary20),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Risk analysis is for reference only. Always do your own research before investing. Past performance does not guarantee future results.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.55,
                    ),
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

class _ComparisonProjectCard extends StatelessWidget {
  const _ComparisonProjectCard({required this.project});

  final LaunchpadRiskProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(project.level);
    return VitCard(
      key: LaunchpadRiskAnalyticsPage.projectKey(project.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      project.symbol,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${project.score.overall}',
                    style: AppTextStyles.base.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  _RiskPill(level: project.level, compact: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _ScoreProgress(value: project.score.overall, color: color),
        ],
      ),
    );
  }
}

class _RiskDistributionCard extends StatelessWidget {
  const _RiskDistributionCard({required this.projects});

  final List<LaunchpadRiskProjectDraft> projects;

  @override
  Widget build(BuildContext context) {
    final levels = LaunchpadRiskLevel.values;
    return VitCard(
      key: LaunchpadRiskAnalyticsPage.distributionKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Risk Distribution (Market)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          ClipRRect(
            borderRadius: AppRadii.inputRadius,
            child: SizedBox(
              height: 22,
              child: Row(
                children: [
                  for (final level in levels)
                    Expanded(
                      flex: projects.where((p) => p.level == level).length,
                      child: ColoredBox(color: _riskColor(level)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.x2,
            crossAxisSpacing: AppSpacing.x2,
            childAspectRatio: 5.2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              for (final level in levels)
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _riskColor(level),
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      _riskLabel(level),
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.resource});

  final LaunchpadRiskResourceDraft resource;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              resource.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text3,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _ScoreProgress extends StatelessWidget {
  const _ScoreProgress({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 1.0;
        final fillWidth = width * value.clamp(0, 100) / 100;
        return Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: AppRadii.inputRadius,
          ),
          alignment: Alignment.centerLeft,
          child: Container(
            width: fillWidth,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadii.inputRadius,
            ),
          ),
        );
      },
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.level, this.compact = false});

  final LaunchpadRiskLevel level;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(level);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.x2 : AppSpacing.x3,
          vertical: compact ? 2 : AppSpacing.x1,
        ),
        child: Text(
          compact
              ? _riskLabel(level).toUpperCase()
              : '${_riskLabel(level).toUpperCase()} RISK',
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: compact ? 9 : 11,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

Color _riskColor(LaunchpadRiskLevel level) {
  return switch (level) {
    LaunchpadRiskLevel.low => AppColors.buy,
    LaunchpadRiskLevel.medium => AppColors.warn,
    LaunchpadRiskLevel.high => AppColors.sell,
    LaunchpadRiskLevel.critical => AppColors.sell,
  };
}

Color _scoreColor(int score) {
  if (score >= 80) return AppColors.buy;
  if (score >= 60) return AppColors.warn;
  return AppColors.sell;
}

String _riskLabel(LaunchpadRiskLevel level) {
  return switch (level) {
    LaunchpadRiskLevel.low => 'Low',
    LaunchpadRiskLevel.medium => 'Medium',
    LaunchpadRiskLevel.high => 'High',
    LaunchpadRiskLevel.critical => 'Critical',
  };
}
