import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
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
import '../data/arena_repository.dart';

class MyArenaReportsPage extends ConsumerStatefulWidget {
  const MyArenaReportsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc204_reports_content');
  static const emptyKey = Key('sc204_reports_empty');

  static Key filterKey(String id) => Key('sc204_filter_$id');

  static Key reportKey(String id) => Key('sc204_report_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MyArenaReportsPage> createState() => _MyArenaReportsPageState();
}

class _MyArenaReportsPageState extends ConsumerState<MyArenaReportsPage> {
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getMyArenaReports();
    final reports = _filteredReports(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-204 MyArenaReportsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Báo cáo của tôi',
              subtitle: 'Báo cáo · Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: MyArenaReportsPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    children: [
                      _ReportsSummary(summary: snapshot.summary),
                      _FilterRail(
                        filters: snapshot.filters,
                        activeFilter: _activeFilter,
                        onChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeFilter = id);
                        },
                      ),
                      _ProcessBanner(snapshot: snapshot),
                      if (reports.isEmpty)
                        VitEmptyState(
                          key: MyArenaReportsPage.emptyKey,
                          icon: Icons.flag_outlined,
                          title: snapshot.emptyTitle,
                          message: _emptyMessage(snapshot),
                        )
                      else
                        _ReportsCard(reports: reports),
                      if (reports.isNotEmpty)
                        Text(
                          _countLabel(reports.length, snapshot.filters),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
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

  List<ArenaReportCaseDraft> _filteredReports(MyArenaReportsSnapshot snapshot) {
    final activeFilter = snapshot.filters.firstWhere(
      (filter) => filter.id == _activeFilter,
      orElse: () => snapshot.filters.first,
    );
    final status = activeFilter.status;
    if (status == null) return snapshot.reports;
    return snapshot.reports
        .where((report) => report.status == status)
        .toList(growable: false);
  }

  String _emptyMessage(MyArenaReportsSnapshot snapshot) {
    if (_activeFilter == 'all') return snapshot.emptySubtitle;
    final filter = snapshot.filters.firstWhere(
      (item) => item.id == _activeFilter,
      orElse: () => snapshot.filters.first,
    );
    return 'Không có báo cáo nào ở trạng thái "${filter.label}".';
  }

  String _countLabel(int count, List<MyArenaReportsFilterDraft> filters) {
    if (_activeFilter == 'all') return '$count báo cáo';
    final filter = filters.firstWhere(
      (item) => item.id == _activeFilter,
      orElse: () => filters.first,
    );
    return '$count báo cáo (${filter.label})';
  }

  static void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _ReportsSummary extends StatelessWidget {
  const _ReportsSummary({required this.summary});

  final MyArenaReportsSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryTile(
            label: 'Tổng cộng',
            value: summary.total,
            color: AppColors.text2,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _SummaryTile(
            label: 'Đang xử lý',
            value: summary.inReview,
            color: AppColors.warn,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _SummaryTile(
            label: 'Đã giải quyết',
            value: summary.resolved,
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<MyArenaReportsFilterDraft> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x2),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final active = filter.id == activeFilter;
          return _FilterChip(
            key: MyArenaReportsPage.filterKey(filter.id),
            filter: filter,
            active: active,
            onTap: () => onChanged(filter.id),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.filter,
    required this.active,
    required this.onTap,
  });

  final MyArenaReportsFilterDraft filter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = _filterColor(filter);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
          decoration: BoxDecoration(
            color: active ? AppColors.primary12 : AppColors.cardBg,
            border: Border.all(
              color: active ? AppColors.primary : AppColors.cardBorder,
              width: active ? 1.5 : 1,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            children: [
              Text(
                filter.label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (filter.count > 0) ...[
                const SizedBox(width: AppSpacing.x2),
                Container(
                  height: 20,
                  constraints: const BoxConstraints(minWidth: 20),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: active
                        ? accentColor.withValues(alpha: 0.18)
                        : AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                  ),
                  child: Text(
                    '${filter.count}',
                    style: AppTextStyles.micro.copyWith(
                      color: active ? accentColor : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessBanner extends StatelessWidget {
  const _ProcessBanner({required this.snapshot});

  final MyArenaReportsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ToneIcon(icon: Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.bannerTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.bannerDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
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

class _ReportsCard extends StatelessWidget {
  const _ReportsCard({required this.reports});

  final List<ArenaReportCaseDraft> reports;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < reports.length; index++)
            _ReportRow(
              key: MyArenaReportsPage.reportKey(reports[index].id),
              report: reports[index],
              isLast: index == reports.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({super.key, required this.report, required this.isLast});

  final ArenaReportCaseDraft report;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accentColor = _targetColor(report.targetType);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(AppRoutePaths.arenaReportCase(report.id));
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isLast ? Colors.transparent : AppColors.divider,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                _ReportIcon(
                  icon: _targetIcon(report.targetType),
                  color: accentColor,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              report.targetName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          _ReportStatusPill(status: report.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        report.reason,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Wrap(
                        spacing: AppSpacing.x2,
                        runSpacing: 2,
                        children: [
                          Text(
                            _targetLabel(report.targetType),
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            '· Gửi ${report.createdAt}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            '· Cập nhật ${report.updatedAt}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.text3,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportIcon extends StatelessWidget {
  const _ReportIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 19),
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _ReportStatusPill extends StatelessWidget {
  const _ReportStatusPill({required this.status});

  final ArenaReportCaseStatus status;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: _statusLabel(status),
      status: _statusKind(status),
      icon: _statusIcon(status),
      size: VitStatusPillSize.sm,
    );
  }
}

Color _filterColor(MyArenaReportsFilterDraft filter) {
  return switch (filter.status) {
    ArenaReportCaseStatus.submitted => AppColors.primary,
    ArenaReportCaseStatus.underReview => AppColors.warn,
    ArenaReportCaseStatus.actionTaken => AppColors.buy,
    ArenaReportCaseStatus.closed => AppColors.text3,
    ArenaReportCaseStatus.appealOpen => AppColors.sell,
    null => AppColors.text3,
  };
}

String _statusLabel(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => 'Đã gửi',
    ArenaReportCaseStatus.underReview => 'Đang xem xét',
    ArenaReportCaseStatus.actionTaken => 'Đã xử lý',
    ArenaReportCaseStatus.closed => 'Đã đóng',
    ArenaReportCaseStatus.appealOpen => 'Đang khiếu nại',
  };
}

VitStatusPillStatus _statusKind(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => VitStatusPillStatus.info,
    ArenaReportCaseStatus.underReview => VitStatusPillStatus.warning,
    ArenaReportCaseStatus.actionTaken => VitStatusPillStatus.success,
    ArenaReportCaseStatus.closed => VitStatusPillStatus.neutral,
    ArenaReportCaseStatus.appealOpen => VitStatusPillStatus.error,
  };
}

IconData _statusIcon(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => Icons.description_outlined,
    ArenaReportCaseStatus.underReview => Icons.schedule_outlined,
    ArenaReportCaseStatus.actionTaken => Icons.check_circle_outline,
    ArenaReportCaseStatus.closed => Icons.lock_outline,
    ArenaReportCaseStatus.appealOpen => Icons.warning_amber_rounded,
  };
}

IconData _targetIcon(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => Icons.flag_outlined,
    ArenaReportTargetType.mode => Icons.description_outlined,
    ArenaReportTargetType.user => Icons.block,
  };
}

Color _targetColor(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => AppColors.warn,
    ArenaReportTargetType.mode => AppColors.accent,
    ArenaReportTargetType.user => AppColors.sell,
  };
}

String _targetLabel(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => 'Challenge',
    ArenaReportTargetType.mode => 'Mode',
    ArenaReportTargetType.user => 'Người dùng',
  };
}
