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

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsExportPage extends ConsumerStatefulWidget {
  const SavingsExportPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc348_summary');
  static const reportTypesKey = Key('sc348_report_types');
  static const formatsKey = Key('sc348_formats');
  static const periodsKey = Key('sc348_periods');
  static const scopesKey = Key('sc348_scopes');
  static const optionsKey = Key('sc348_options');
  static const summaryRowsKey = Key('sc348_summary_rows');
  static const exportButtonKey = Key('sc348_export_button');
  static const previewBannerKey = Key('sc348_preview_banner');
  static const historyListKey = Key('sc348_history_list');

  static Key tabKey(String id) => Key('sc348_tab_$id');
  static Key reportTypeKey(SavingsExportReportType id) =>
      Key('sc348_report_${id.name}');
  static Key formatKey(SavingsExportFormat id) =>
      Key('sc348_format_${id.name}');
  static Key periodKey(SavingsExportPeriod id) =>
      Key('sc348_period_${id.name}');
  static Key scopeKey(SavingsExportScope id) => Key('sc348_scope_${id.name}');
  static Key optionKey(String id) => Key('sc348_option_$id');
  static Key historyKey(String id) => Key('sc348_history_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsExportPage> createState() => _SavingsExportPageState();
}

class _SavingsExportPageState extends ConsumerState<SavingsExportPage> {
  String? _tab;
  SavingsExportReportType? _reportType;
  SavingsExportFormat? _format;
  SavingsExportPeriod? _period;
  SavingsExportScope? _scope;
  Set<String>? _enabledOptions;
  bool _previewReady = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(savingsExportRepositoryProvider).getExport();
    final activeTab = _tab ?? snapshot.defaultTab;
    final selectedReport = _reportType ?? snapshot.defaultReportType;
    final selectedFormat = _format ?? snapshot.defaultFormat;
    final selectedPeriod = _period ?? snapshot.defaultPeriod;
    final selectedScope = _scope ?? snapshot.defaultScope;
    final enabledOptions = _enabledOptions ?? snapshot.defaultEnabledOptions;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-348 SavingsExportPage',
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
                    _ExportHero(snapshot: snapshot),
                    _ExportTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'create') ...[
                      _SectionTitle(label: 'Loại báo cáo'),
                      _ReportTypeList(
                        reports: snapshot.reportTypes,
                        selected: selectedReport,
                        onChanged: (report) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _reportType = report;
                            _previewReady = false;
                          });
                        },
                      ),
                      _SectionTitle(label: 'Định dạng file'),
                      _FormatCards(
                        formats: snapshot.formats,
                        selected: selectedFormat,
                        onChanged: (format) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _format = format;
                            _previewReady = false;
                          });
                        },
                      ),
                      _SectionTitle(label: 'Khoảng thời gian'),
                      _PeriodChips(
                        periods: snapshot.periods,
                        selected: selectedPeriod,
                        onChanged: (period) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _period = period;
                            _previewReady = false;
                          });
                        },
                      ),
                      _SectionTitle(label: 'Loại giao dịch'),
                      _ScopeChips(
                        scopes: snapshot.scopes,
                        selected: selectedScope,
                        onChanged: (scope) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _scope = scope;
                            _previewReady = false;
                          });
                        },
                      ),
                      _SectionTitle(label: 'Tùy chọn thêm'),
                      _OptionsList(
                        options: snapshot.options,
                        enabled: enabledOptions,
                        onToggle: _toggleOption,
                      ),
                      _ExportSummary(
                        snapshot: snapshot,
                        selectedReport: selectedReport,
                        selectedFormat: selectedFormat,
                      ),
                      _SensitiveNotice(text: snapshot.sensitiveNotice),
                      if (_previewReady)
                        _PreviewReadyBanner(format: selectedFormat),
                      VitCtaButton(
                        key: SavingsExportPage.exportButtonKey,
                        onPressed: () => _previewExport(selectedFormat),
                        leading: const Icon(Icons.file_download_outlined),
                        child: Text(
                          'Xem trước & Xuất ${_formatLabel(selectedFormat)}',
                        ),
                      ),
                    ] else
                      _HistoryList(history: snapshot.history),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleOption(String id) {
    HapticFeedback.selectionClick();
    final snapshot = ref.read(savingsExportRepositoryProvider).getExport();
    final next = <String>{
      ...(_enabledOptions ?? snapshot.defaultEnabledOptions),
    };
    if (!next.add(id)) {
      next.remove(id);
    }
    setState(() {
      _enabledOptions = next;
      _previewReady = false;
    });
  }

  void _previewExport(SavingsExportFormat format) {
    HapticFeedback.mediumImpact();
    setState(() => _previewReady = true);
  }
}

class _ExportHero extends StatelessWidget {
  const _ExportHero({required this.snapshot});

  final SavingsExportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsExportPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.file_download_outlined,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng báo cáo đã tạo',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      '${snapshot.createdReports}',
                      style: AppTextStyles.heroNumber.copyWith(fontSize: 34),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Loại báo cáo',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    snapshot.reportTypeCountLabel,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroPill(
                  label: 'Định dạng',
                  value: snapshot.formatSummary,
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroPill(
                  label: 'Lưu trữ',
                  value: snapshot.retentionLabel,
                  color: AppColors.buy,
                  icon: Icons.shield_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(color: color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExportTabs extends StatelessWidget {
  const _ExportTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            icon: tab.id == 'create'
                ? Icons.note_add_outlined
                : Icons.history_rounded,
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 15,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(label, style: _captionBold.copyWith(color: AppColors.text2)),
      ],
    );
  }
}

class _ReportTypeList extends StatelessWidget {
  const _ReportTypeList({
    required this.reports,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsExportReportDraft> reports;
  final SavingsExportReportType selected;
  final ValueChanged<SavingsExportReportType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsExportPage.reportTypesKey,
      children: [
        for (final report in reports) ...[
          _ReportTypeCard(
            report: report,
            selected: report.id == selected,
            onTap: () => onChanged(report.id),
          ),
          if (report != reports.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ReportTypeCard extends StatelessWidget {
  const _ReportTypeCard({
    required this.report,
    required this.selected,
    required this.onTap,
  });

  final SavingsExportReportDraft report;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.buy : AppColors.text3;

    return VitCard(
      key: SavingsExportPage.reportTypeKey(report.id),
      variant: selected ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.lg,
      borderColor: selected ? AppColors.buy : AppColors.cardBorder,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _RoundIcon(icon: _iconFor(report.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: AppTextStyles.body.copyWith(
                    color: selected ? AppColors.text1 : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  report.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.28,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  report.rowsLabel,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _SelectionDot(selected: selected, color: color),
        ],
      ),
    );
  }
}

class _FormatCards extends StatelessWidget {
  const _FormatCards({
    required this.formats,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsExportFormatDraft> formats;
  final SavingsExportFormat selected;
  final ValueChanged<SavingsExportFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: SavingsExportPage.formatsKey,
      children: [
        for (final format in formats) ...[
          Expanded(
            child: _FormatCard(
              format: format,
              selected: format.id == selected,
              onTap: () => onChanged(format.id),
            ),
          ),
          if (format != formats.last) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _FormatCard extends StatelessWidget {
  const _FormatCard({
    required this.format,
    required this.selected,
    required this.onTap,
  });

  final SavingsExportFormatDraft format;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.buy : AppColors.text3;

    return VitCard(
      key: SavingsExportPage.formatKey(format.id),
      variant: selected ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.md,
      borderColor: selected ? AppColors.buy : AppColors.cardBorder,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Icon(Icons.description_outlined, color: color, size: 24),
          const SizedBox(height: AppSpacing.x3),
          Text(
            format.label,
            style: _captionBold.copyWith(
              color: selected ? AppColors.buy : AppColors.text2,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            format.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodChips extends StatelessWidget {
  const _PeriodChips({
    required this.periods,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsExportPeriodDraft> periods;
  final SavingsExportPeriod selected;
  final ValueChanged<SavingsExportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: SavingsExportPage.periodsKey,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x3,
      children: [
        for (final period in periods)
          _ChoicePill(
            key: SavingsExportPage.periodKey(period.id),
            label: period.label,
            selected: period.id == selected,
            icon: null,
            onTap: () => onChanged(period.id),
          ),
      ],
    );
  }
}

class _ScopeChips extends StatelessWidget {
  const _ScopeChips({
    required this.scopes,
    required this.selected,
    required this.onChanged,
  });

  final List<SavingsExportScopeDraft> scopes;
  final SavingsExportScope selected;
  final ValueChanged<SavingsExportScope> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: SavingsExportPage.scopesKey,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x3,
      children: [
        for (final scope in scopes)
          _ChoicePill(
            key: SavingsExportPage.scopeKey(scope.id),
            label: scope.label,
            selected: scope.id == selected,
            icon: _iconFor(scope.iconKey),
            onTap: () => onChanged(scope.id),
          ),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary12 : Colors.transparent,
            border: Border.all(
              color: selected ? AppColors.primary30 : AppColors.cardBorder,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSpacing.iconSm,
                  color: selected ? AppColors.primary : AppColors.text3,
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Text(
                label,
                style: _captionBold.copyWith(
                  color: selected ? AppColors.primary : AppColors.text2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionsList extends StatelessWidget {
  const _OptionsList({
    required this.options,
    required this.enabled,
    required this.onToggle,
  });

  final List<SavingsExportOptionDraft> options;
  final Set<String> enabled;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsExportPage.optionsKey,
      children: [
        for (final option in options) ...[
          _OptionRow(
            option: option,
            enabled: enabled.contains(option.id),
            onTap: () => onToggle(option.id),
          ),
          if (option != options.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.enabled,
    required this.onTap,
  });

  final SavingsExportOptionDraft option;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.buy : AppColors.text3;

    return VitCard(
      key: SavingsExportPage.optionKey(option.id),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.md,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          Icon(_iconFor(option.iconKey), color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  style: _captionBold.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  option.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (_) => onTap(),
            activeThumbColor: AppColors.buy,
            activeTrackColor: AppColors.buy20,
            inactiveThumbColor: AppColors.text3,
            inactiveTrackColor: AppColors.toggleTrackOff,
          ),
        ],
      ),
    );
  }
}

class _ExportSummary extends StatelessWidget {
  const _ExportSummary({
    required this.snapshot,
    required this.selectedReport,
    required this.selectedFormat,
  });

  final SavingsExportSnapshot snapshot;
  final SavingsExportReportType selectedReport;
  final SavingsExportFormat selectedFormat;

  @override
  Widget build(BuildContext context) {
    final report = snapshot.reportTypes.firstWhere(
      (item) => item.id == selectedReport,
      orElse: () => snapshot.reportTypes.first,
    );

    return VitCard(
      key: SavingsExportPage.summaryRowsKey,
      variant: VitCardVariant.standard,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.visibility_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tóm tắt',
                style: _captionBold.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'Số dòng',
                  value: report.rowsLabel.split(' ').first,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryTile(
                  label: 'Kích thước',
                  value: snapshot.summaryFileSize,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SummaryTile(
                  label: 'Định dạng',
                  value: _formatLabel(selectedFormat),
                  accent: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.accent = false,
  });

  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _captionBold.copyWith(
              color: accent ? AppColors.buy : AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SensitiveNotice extends StatelessWidget {
  const _SensitiveNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewReadyBanner extends StatelessWidget {
  const _PreviewReadyBanner({required this.format});

  final SavingsExportFormat format;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsExportPage.previewBannerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Bản xem trước ${_formatLabel(format)} đã sẵn sàng để tải xuống.',
              style: _captionBold.copyWith(color: AppColors.text1),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.history});

  final List<SavingsExportHistoryDraft> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsExportPage.historyListKey,
      children: [
        for (final item in history) ...[
          _HistoryCard(item: item),
          if (item != history.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item});

  final SavingsExportHistoryDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(item.status);

    return VitCard(
      key: SavingsExportPage.historyKey(item.id),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _RoundIcon(icon: Icons.description_outlined, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _captionBold.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_reportTypeLabel(item.reportType)} · ${_formatLabel(item.format)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(label: _statusLabel(item.status), color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _MetaText(label: 'Kỳ', value: item.period),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetaText(label: 'Dung lượng', value: item.fileSize),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Tạo ${item.createdAt} · Hết hạn ${item.expiresAt}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.label, required this.value});

  final String label;
  final String value;

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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _microBold.copyWith(color: AppColors.text2),
        ),
      ],
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
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(icon, color: color, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? color : AppColors.borderSolid),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'download' => Icons.file_download_outlined,
    'upload' => Icons.file_upload_outlined,
    'shield' => Icons.shield_outlined,
    'portfolio' => Icons.account_balance_wallet_outlined,
    'trend' => Icons.trending_up_rounded,
    'filter' => Icons.filter_alt_outlined,
    'bolt' => Icons.bolt_outlined,
    'info' => Icons.info_outline_rounded,
    'chart' => Icons.show_chart_rounded,
    'settings' => Icons.tune_rounded,
    'mail' => Icons.mail_outline_rounded,
    _ => Icons.description_outlined,
  };
}

String _formatLabel(SavingsExportFormat format) {
  return switch (format) {
    SavingsExportFormat.csv => 'CSV',
    SavingsExportFormat.pdf => 'PDF',
    SavingsExportFormat.xlsx => 'Excel',
  };
}

String _reportTypeLabel(SavingsExportReportType type) {
  return switch (type) {
    SavingsExportReportType.transaction => 'Lịch sử giao dịch',
    SavingsExportReportType.tax => 'Báo cáo thuế',
    SavingsExportReportType.portfolio => 'Ảnh chụp danh mục',
    SavingsExportReportType.performance => 'Hiệu suất đầu tư',
  };
}

String _statusLabel(SavingsExportStatus status) {
  return switch (status) {
    SavingsExportStatus.ready => 'Sẵn sàng',
    SavingsExportStatus.generating => 'Đang tạo',
    SavingsExportStatus.completed => 'Hoàn tất',
    SavingsExportStatus.failed => 'Lỗi',
  };
}

Color _statusColor(SavingsExportStatus status) {
  return switch (status) {
    SavingsExportStatus.ready => AppColors.primary,
    SavingsExportStatus.generating => AppColors.warn,
    SavingsExportStatus.completed => AppColors.buy,
    SavingsExportStatus.failed => AppColors.sell,
  };
}
