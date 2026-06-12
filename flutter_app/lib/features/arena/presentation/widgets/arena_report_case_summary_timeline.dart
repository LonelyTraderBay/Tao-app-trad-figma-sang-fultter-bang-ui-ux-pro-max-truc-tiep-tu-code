part of '../pages/arena_report_case_page.dart';

class _CaseSummaryCard extends StatelessWidget {
  const _CaseSummaryCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    final accentColor = _targetColor(reportCase.targetType);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${reportCase.id.toUpperCase()}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              _ReportStatusPill(status: reportCase.status),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _ToneIcon(
                icon: _targetIcon(reportCase.targetType),
                color: accentColor,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportCase.targetName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_targetLabel(reportCase.targetType)} · Báo cáo lúc ${reportCase.createdAt}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportReasonCard extends StatelessWidget {
  const _ReportReasonCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Lý do báo cáo',
      accentColor: AppColors.sell,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        borderColor: AppColors.sell20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.flag_outlined,
              color: AppColors.sell,
              size: AppSpacing.arenaReportInlineIcon,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                reportCase.reason,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: AppSpacing.arenaReportBodyLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Tiến trình xử lý',
      accentColor: AppColors.buy,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          children: [
            for (var index = 0; index < reportCase.timeline.length; index++)
              _TimelineRow(
                step: reportCase.timeline[index],
                isLast: index == reportCase.timeline.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.step, required this.isLast});

  final ArenaReportTimelineStepDraft step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = step.done ? AppColors.buy : AppColors.surface2;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.arenaReportTimelineColumnWidth,
          child: Column(
            children: [
              Container(
                width: AppSpacing.arenaReportTimelineDot,
                height: AppSpacing.arenaReportTimelineDot,
                margin: const EdgeInsets.only(top: AppSpacing.x1),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: step.done
                      ? null
                      : Border.all(
                          color: AppColors.borderSolid,
                          width: AppSpacing.arenaReportTimelineBorderWidth,
                        ),
                ),
              ),
              if (!isLast)
                Container(
                  width: AppSpacing.arenaReportTimelineLineWidth,
                  height: AppSpacing.arenaReportTimelineLineHeight,
                  color: step.done ? AppColors.buy20 : AppColors.divider,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: AppTextStyles.body.copyWith(
                    color: step.done ? AppColors.text1 : AppColors.text3,
                    fontWeight: step.done
                        ? AppTextStyles.medium
                        : AppTextStyles.normal,
                    height: AppSpacing.arenaReportBodyLineHeight,
                  ),
                ),
                if (step.date.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.arenaReportTimelineDateGap),
                  Text(
                    step.date,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTakenCard extends StatelessWidget {
  const _ActionTakenCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Hành động đã thực hiện',
      accentColor: AppColors.warn,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ToneIcon(icon: Icons.shield_outlined, color: AppColors.buy),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hành động đã thực hiện',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        reportCase.actionTaken!,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          height: AppSpacing.arenaReportActionLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (reportCase.systemNote != null) ...[
              const SizedBox(height: AppSpacing.x3),
              _SystemNotePanel(note: reportCase.systemNote!),
            ],
          ],
        ),
      ),
    );
  }
}
