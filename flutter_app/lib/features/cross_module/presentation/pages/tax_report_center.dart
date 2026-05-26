import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/cross_module/data/tax_report_repository.dart';

class TaxReportCenter extends ConsumerStatefulWidget {
  const TaxReportCenter({super.key, this.shellRenderMode});

  static const contentKey = Key('sc324_tax_report_center_content');
  static const generateButtonKey = Key('sc324_generate_tax_report');
  static const includeArenaKey = Key('sc324_include_arena_toggle');
  static Key tabKey(TaxReportTab tab) => Key('sc324_tab_${tab.name}');
  static Key formatKey(TaxExportFormat format) =>
      Key('sc324_format_${format.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TaxReportCenter> createState() => _TaxReportCenterState();
}

class _TaxReportCenterState extends ConsumerState<TaxReportCenter> {
  TaxReportTab _activeTab = TaxReportTab.generate;
  TaxExportFormat _format = TaxExportFormat.pdf;
  String _jurisdictionId = 'us';
  String _startDate = '01/01/2024';
  String _endDate = '12/31/2024';
  bool _includeArena = false;
  bool _exportQueued = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(taxReportRepositoryProvider).getCenter();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-324 TaxReportCenter',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _TaxTabs(
              tabs: snapshot.tabs,
              active: _activeTab,
              onChanged: (tab) {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = tab);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                key: TaxReportCenter.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.defaultGap,
                  children: [
                    if (_activeTab == TaxReportTab.generate)
                      _GenerateTaxReportTab(
                        snapshot: snapshot,
                        startDate: _startDate,
                        endDate: _endDate,
                        format: _format,
                        jurisdictionId: _jurisdictionId,
                        exportQueued: _exportQueued,
                        onPresetSelected: (start, end) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _startDate = start;
                            _endDate = end;
                          });
                        },
                        onFormatChanged: (format) {
                          HapticFeedback.selectionClick();
                          setState(() => _format = format);
                        },
                        onJurisdictionChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _jurisdictionId = id);
                        },
                        onGenerate: () {
                          HapticFeedback.mediumImpact();
                          setState(() => _exportQueued = true);
                        },
                      )
                    else if (_activeTab == TaxReportTab.reports)
                      _ReportsTab(snapshot: snapshot)
                    else
                      _TaxSettingsTab(
                        includeArena: _includeArena,
                        onToggleArena: () {
                          HapticFeedback.selectionClick();
                          setState(() => _includeArena = !_includeArena);
                        },
                      ),
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

class _TaxTabs extends StatelessWidget {
  const _TaxTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<TaxReportTabDraft> tabs;
  final TaxReportTab active;
  final ValueChanged<TaxReportTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
        child: Row(
          children: [
            for (final tab in tabs)
              Expanded(
                child: InkWell(
                  key: TaxReportCenter.tabKey(tab.tab),
                  onTap: () => onChanged(tab.tab),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x4,
                        ),
                        child: Text(
                          tab.label,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.tab == active
                                ? AppColors.primary
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: AppSpacing.x1,
                        width: tab.tab == active ? AppSpacing.buttonHero : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadii.xlRadius,
                        ),
                      ),
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

class _GenerateTaxReportTab extends StatelessWidget {
  const _GenerateTaxReportTab({
    required this.snapshot,
    required this.startDate,
    required this.endDate,
    required this.format,
    required this.jurisdictionId,
    required this.exportQueued,
    required this.onPresetSelected,
    required this.onFormatChanged,
    required this.onJurisdictionChanged,
    required this.onGenerate,
  });

  final TaxReportSnapshot snapshot;
  final String startDate;
  final String endDate;
  final TaxExportFormat format;
  final String jurisdictionId;
  final bool exportQueued;
  final void Function(String startDate, String endDate) onPresetSelected;
  final ValueChanged<TaxExportFormat> onFormatChanged;
  final ValueChanged<String> onJurisdictionChanged;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final jurisdiction = snapshot.jurisdictions.firstWhere(
      (item) => item.id == jurisdictionId,
      orElse: () => snapshot.jurisdictions.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TaxSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.sectionGap),
        _TaxPeriodCard(
          startDate: startDate,
          endDate: endDate,
          onPresetSelected: onPresetSelected,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Module Breakdown',
          children: [
            for (final activity in snapshot.activities)
              _TaxActivityCard(activity: activity),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        _ExportFormatCard(selected: format, onChanged: onFormatChanged),
        const SizedBox(height: AppSpacing.sectionGap),
        _JurisdictionCard(
          jurisdiction: jurisdiction,
          jurisdictions: snapshot.jurisdictions,
          onChanged: onJurisdictionChanged,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        _GenerateReportButton(
          format: format,
          queued: exportQueued,
          onTap: onGenerate,
        ),
        if (exportQueued) ...[
          const SizedBox(height: AppSpacing.x3),
          const _InfoPanel(
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            background: AppColors.buy10,
            border: AppColors.buy20,
            text:
                'Export request queued locally. Production wiring will post to /exports with the selected period and format.',
          ),
        ],
        const SizedBox(height: AppSpacing.x4),
        const _InfoPanel(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warn,
          background: AppColors.warn08,
          border: AppColors.warn15,
          text:
              'Tax reports are for reference only. Consult a tax professional for accurate filing. We are not tax advisors.',
        ),
      ],
    );
  }
}

class _TaxSummaryCard extends StatelessWidget {
  const _TaxSummaryCard({required this.snapshot});

  final TaxReportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(
                icon: Icons.description_outlined,
                color: AppColors.buy,
                background: AppColors.buy10,
                size: AppSpacing.inputHeight,
                iconSize: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax Summary',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'All taxable activities',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  label: 'Total Gain/Loss',
                  value: _formatMoney(snapshot.totalGainLoss),
                  valueColor: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MetricBlock(
                  label: 'Transactions',
                  value: _formatInteger(snapshot.totalTransactions),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  label: 'Taxable Modules',
                  value: '${snapshot.taxableModules}',
                  compact: true,
                ),
              ),
              Expanded(
                child: _MetricBlock(
                  label: 'Reports Generated',
                  value: '${snapshot.reports.length}',
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.compact = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style:
              (compact ? AppTextStyles.baseMedium : AppTextStyles.sectionTitle)
                  .copyWith(
                    color: valueColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
        ),
      ],
    );
  }
}

class _TaxPeriodCard extends StatelessWidget {
  const _TaxPeriodCard({
    required this.startDate,
    required this.endDate,
    required this.onPresetSelected,
  });

  final String startDate;
  final String endDate;
  final void Function(String startDate, String endDate) onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tax Period',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _DateField(label: 'Start Date', value: startDate),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _DateField(label: 'End Date', value: endDate),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _PresetButton(
                label: '2024',
                onTap: () => onPresetSelected('01/01/2024', '12/31/2024'),
              ),
              const SizedBox(width: AppSpacing.x3),
              _PresetButton(
                label: 'Q4 2024',
                onTap: () => onPresetSelected('10/01/2024', '12/31/2024'),
              ),
              const SizedBox(width: AppSpacing.x3),
              _PresetButton(
                label: 'YTD',
                onTap: () => onPresetSelected('01/01/2024', '05/25/2026'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x2),
        DecoratedBox(
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
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: AppSpacing.iconSm,
                  color: AppColors.text3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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

class _ReportStatusBadge extends StatelessWidget {
  const _ReportStatusBadge({required this.status});

  final TaxReportStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TaxReportStatus.ready => AppColors.buy,
      TaxReportStatus.generating => AppColors.warn,
      TaxReportStatus.error => AppColors.sell,
    };
    final background = switch (status) {
      TaxReportStatus.ready => AppColors.buy10,
      TaxReportStatus.generating => AppColors.warn10,
      TaxReportStatus.error => AppColors.sell10,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          status.name.toUpperCase(),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: AppSpacing.x3,
          ),
        ),
      ),
    );
  }
}

class _TaxSettingsTab extends StatelessWidget {
  const _TaxSettingsTab({
    required this.includeArena,
    required this.onToggleArena,
  });

  final bool includeArena;
  final VoidCallback onToggleArena;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Report Settings',
          children: [
            VitCard(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Include Arena Points',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Text(
                          'Show Arena activity in reports (typically non-taxable)',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ToggleSwitch(
                    key: TaxReportCenter.includeArenaKey,
                    enabled: includeArena,
                    onTap: onToggleArena,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          radius: VitCardRadius.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tax Resources',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              for (final resource in const [
                'IRS Publication 544 - Sales and Other Dispositions',
                'Form 8949 - Sales and Dispositions of Capital Assets',
                'Schedule D - Capital Gains and Losses',
                'Crypto Tax Guide by IRS',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.buy,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          resource,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const _ImportantNoticeCard(),
        const SizedBox(height: AppSpacing.x4),
        const _InfoPanel(
          icon: Icons.info_outline_rounded,
          color: AppColors.primary,
          background: AppColors.primary08,
          border: AppColors.primary20,
          text:
              'Tax reports aggregate data from all modules. Each transaction includes timestamp, type, amount, and gain/loss calculation.',
        ),
      ],
    );
  }
}

class _ImportantNoticeCard extends StatelessWidget {
  const _ImportantNoticeCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.sell10,
        border: Border.all(color: AppColors.sell20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.sell,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Important Notice',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        'This platform does not provide tax advice. Tax reports are generated for your convenience only. Please consult a qualified tax professional or accountant for accurate tax filing guidance specific to your jurisdiction.',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            for (final note in const [
              'Reports may not include all taxable events',
              'Tax laws vary by jurisdiction',
              'Accuracy depends on transaction data quality',
              'Arena Points are typically non-taxable but check local laws',
              'We are not tax advisors or accountants',
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: AppColors.text3,
                      size: AppSpacing.x2,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        note,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: AppSpacing.inputHeight,
        height: AppSpacing.x6,
        padding: const EdgeInsets.all(AppSpacing.x2),
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.toggleTrackOff,
          borderRadius: AppRadii.xlRadius,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: AppSpacing.x5,
            height: AppSpacing.x5,
            decoration: const BoxDecoration(
              color: AppColors.navCenterIcon,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
    this.size = AppSpacing.x6,
    this.iconSize = AppSpacing.iconSm,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadii.smRadius,
        ),
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.color,
    required this.background,
    required this.border,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final Color border;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ActivityVisual {
  const _ActivityVisual({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;
}

_ActivityVisual _activityVisual(TaxActivityModuleId module) {
  return switch (module) {
    TaxActivityModuleId.trading => const _ActivityVisual(
      icon: Icons.bar_chart_rounded,
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    TaxActivityModuleId.p2p => const _ActivityVisual(
      icon: Icons.shopping_cart_outlined,
      color: AppModuleAccents.p2p,
      background: AppColors.warn10,
    ),
    TaxActivityModuleId.predictions => const _ActivityVisual(
      icon: Icons.track_changes_rounded,
      color: AppModuleAccents.predictions,
      background: AppColors.accent10,
    ),
    TaxActivityModuleId.dca => const _ActivityVisual(
      icon: Icons.show_chart_rounded,
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    TaxActivityModuleId.wallet => const _ActivityVisual(
      icon: Icons.account_balance_wallet_outlined,
      color: AppModuleAccents.wallet,
      background: AppColors.primary12,
    ),
    TaxActivityModuleId.arena => const _ActivityVisual(
      icon: Icons.bolt_rounded,
      color: AppModuleAccents.arena,
      background: AppColors.warn10,
    ),
  };
}

String _formatLabel(TaxExportFormat format) {
  return switch (format) {
    TaxExportFormat.pdf => 'PDF',
    TaxExportFormat.csv => 'CSV',
    TaxExportFormat.excel => 'Excel',
  };
}

String _formatInteger(int value) {
  return value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
}

String _formatMoney(int value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatInteger(value.abs())}';
}
