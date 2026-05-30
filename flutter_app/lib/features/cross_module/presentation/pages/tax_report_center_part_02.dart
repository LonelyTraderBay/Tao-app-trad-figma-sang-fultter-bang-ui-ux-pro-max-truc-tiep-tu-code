part of 'tax_report_center.dart';

class _PresetButton extends StatelessWidget {
  const _PresetButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppColors.bg,
        borderRadius: AppRadii.xlRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.xlRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaxActivityCard extends StatelessWidget {
  const _TaxActivityCard({required this.activity});

  final TaxableActivityDraft activity;

  @override
  Widget build(BuildContext context) {
    final visual = _activityVisual(activity.module);
    final gainColor = activity.gainLoss > 0
        ? AppColors.buy
        : activity.gainLoss < 0
        ? AppColors.sell
        : AppColors.text3;

    return Opacity(
      opacity: activity.taxable ? 1 : 0.58,
      child: VitCard(
        padding: const EdgeInsets.all(AppSpacing.x4),
        radius: VitCardRadius.lg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconBadge(
                  icon: visual.icon,
                  color: visual.color,
                  background: visual.background,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    activity.moduleName,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                if (!activity.taxable) const _NonTaxableBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.x5),
            Row(
              children: [
                Expanded(
                  child: _MetricBlock(
                    label: 'Transactions',
                    value: '${activity.count}',
                    compact: true,
                  ),
                ),
                Expanded(
                  child: _MetricBlock(
                    label: 'Gain/Loss',
                    value: activity.taxable
                        ? _formatMoney(activity.gainLoss)
                        : 'N/A',
                    valueColor: activity.taxable ? gainColor : AppColors.text3,
                    compact: true,
                  ),
                ),
              ],
            ),
            if (activity.note != null) ...[
              const SizedBox(height: AppSpacing.x4),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.warn08,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x3),
                  child: Text(
                    activity.note!,
                    style: AppTextStyles.micro.copyWith(color: AppColors.warn),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NonTaxableBadge extends StatelessWidget {
  const _NonTaxableBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          'NON-TAXABLE',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
            fontSize: AppSpacing.x3,
          ),
        ),
      ),
    );
  }
}

class _ExportFormatCard extends StatelessWidget {
  const _ExportFormatCard({required this.selected, required this.onChanged});

  final TaxExportFormat selected;
  final ValueChanged<TaxExportFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Format',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final item in TaxExportFormat.values) ...[
                Expanded(
                  child: _FormatButton(
                    format: item,
                    selected: item == selected,
                    onTap: () => onChanged(item),
                  ),
                ),
                if (item != TaxExportFormat.values.last)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  const _FormatButton({
    required this.format,
    required this.selected,
    required this.onTap,
  });

  final TaxExportFormat format;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.bg,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        key: TaxReportCenter.formatKey(format),
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
          child: Text(
            _formatLabel(format),
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.navCenterIcon : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _JurisdictionCard extends StatelessWidget {
  const _JurisdictionCard({
    required this.jurisdiction,
    required this.jurisdictions,
    required this.onChanged,
  });

  final TaxJurisdictionDraft jurisdiction;
  final List<TaxJurisdictionDraft> jurisdictions;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tax Jurisdiction',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          PopupMenuButton<String>(
            color: AppColors.surface2,
            onSelected: onChanged,
            itemBuilder: (context) => [
              for (final item in jurisdictions)
                PopupMenuItem(
                  value: item.id,
                  child: Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
            ],
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.bg,
                borderRadius: AppRadii.xlRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4,
                  vertical: AppSpacing.x3,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        jurisdiction.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: AppSpacing.iconMd,
                      color: AppColors.text2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenerateReportButton extends StatelessWidget {
  const _GenerateReportButton({
    required this.format,
    required this.queued,
    required this.onTap,
  });

  final TaxExportFormat format;
  final bool queued;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: queued ? AppColors.buy : AppColors.primary,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: TaxReportCenter.generateButtonKey,
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.ctaHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                queued
                    ? Icons.check_circle_outline_rounded
                    : Icons.description_outlined,
                color: AppColors.navCenterIcon,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                queued
                    ? '${_formatLabel(format)} Export Queued'
                    : 'Generate Tax Report',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.navCenterIcon,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab({required this.snapshot});

  final TaxReportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Generated Reports',
      children: [
        for (final report in snapshot.reports) _ReportCard(report: report),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});

  final GeneratedTaxReportDraft report;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
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
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        Text(
                          report.period,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _ReportStatusBadge(status: report.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      report.dateRange,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _IconAction(
                icon: Icons.file_download_outlined,
                color: AppColors.primary,
                background: AppColors.primary12,
                onTap: HapticFeedback.selectionClick,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _ReportMetric(
                  label: 'Format',
                  value: _formatLabel(report.format),
                ),
              ),
              Expanded(
                child: _ReportMetric(
                  label: 'Transactions',
                  value: '${report.transactionCount}',
                ),
              ),
              Expanded(
                child: _ReportMetric(
                  label: 'Gain/Loss',
                  value: _formatMoney(report.totalGainLoss),
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: AppSpacing.iconSm,
                color: AppColors.text3,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                report.generatedAtLabel,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
