part of '../pages/best_execution_reports_page.dart';

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
                  color: _bestPrimary.withValues(alpha: .14),
                  borderRadius: AppRadii.cardRadius,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.description_outlined,
                  color: _bestPrimary,
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
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Report period: Jan 1 - Mar 31, 2026. Due date: April 15, 2026. Status: Draft.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
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
                  background: _bestPanel2,
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
                  background: _bestPrimary,
                  foreground: AppColors.onAccent,
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
    return VitPageSection(
      label: 'Historical Reports',
      customGap: 12,
      children: [
        for (final report in reports)
          _Card(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _bestPrimary.withValues(alpha: .14),
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: _bestPrimary,
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
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.period,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
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
    return VitStatusPill(
      label: published ? 'Published' : 'Draft',
      status: published
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.neutral,
      size: VitStatusPillSize.sm,
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
    return VitCtaButton(
      onPressed: onTap,
      variant: bordered
          ? VitCtaButtonVariant.secondary
          : VitCtaButtonVariant.primary,
      height: 40,
      leading: Icon(icon, color: foreground, size: 15),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: foreground,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: padding,
      borderColor: _bestBorder.withValues(alpha: .72),
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
        color: AppColors.transparent,
        child: VitCard(
          variant: VitCardVariant.inner,
          borderColor: _bestBorder,
          padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
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
