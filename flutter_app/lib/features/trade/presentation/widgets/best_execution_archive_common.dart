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
        color: published ? _bestGreen.withValues(alpha: .14) : _bestPanel2,
        borderRadius: AppRadii.smRadius,
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
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: background,
          border: bordered ? Border.all(color: _bestBorder) : null,
          borderRadius: AppRadii.mdRadius,
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
            color: _bestPrimary,
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
        color: _bestPanel,
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
        color: AppColors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
          decoration: BoxDecoration(
            color: _bestPanel2,
            border: Border.all(color: _bestBorder),
            borderRadius: AppRadii.inputRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.dynamicIslandBg.withValues(alpha: .25),
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
