part of '../pages/my_arena_reports_page.dart';

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
      padding: AppSpacing.myArenaReportsSummaryTilePadding,
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
      height: AppSpacing.myArenaReportsFilterHeight,
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
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.myArenaReportsFilterHeight,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: active ? AppColors.primary12 : AppColors.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.inputRadius,
                side: BorderSide(
                  color: active ? AppColors.primary : AppColors.cardBorder,
                  width: active ? 1.5 : 1,
                ),
              ),
            ),
            child: Padding(
              padding: AppSpacing.myArenaReportsFilterPadding,
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
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: AppSpacing.myArenaReportsBadgeMinWidth,
                      ),
                      child: SizedBox(
                        height: AppSpacing.myArenaReportsBadgeHeight,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: active
                                ? accentColor.withValues(alpha: 0.18)
                                : AppColors.surface2,
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadii.smRadius,
                            ),
                          ),
                          child: Padding(
                            padding: AppSpacing.myArenaReportsBadgePadding,
                            child: Center(
                              child: Text(
                                '${filter.count}',
                                style: AppTextStyles.micro.copyWith(
                                  color: active ? accentColor : AppColors.text3,
                                  fontWeight: AppTextStyles.bold,
                                  height: AppSpacing
                                      .myArenaReportsCompactLineHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
      padding: AppSpacing.myArenaReportsCardPadding,
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
                    height: AppSpacing.myArenaReportsBodyLineHeight,
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
      padding: AppSpacing.zeroInsets,
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
      color: AppColors.transparent,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              context.go(AppRoutePaths.arenaReportCase(report.id));
            },
            child: Padding(
              padding: AppSpacing.myArenaReportsCardPadding,
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
                          runSpacing: AppSpacing.myArenaReportsWrapRunSpacing,
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
                    size: AppSpacing.myArenaReportsChevron,
                  ),
                ],
              ),
            ),
          ),
          if (!isLast)
            const Divider(
              height: AppSpacing.myArenaReportsDividerHeight,
              color: AppColors.divider,
            ),
        ],
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
    return SizedBox.square(
      dimension: AppSpacing.myArenaReportsIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: 0.14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Icon(icon, color: color, size: AppSpacing.myArenaReportsIcon),
        ),
      ),
    );
  }
}
