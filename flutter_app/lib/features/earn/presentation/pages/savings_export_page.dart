import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/savings_export_config_widgets.dart';
part '../widgets/savings_export_option_widgets.dart';
part '../widgets/savings_export_summary_widgets.dart';

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
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
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
                        VitHighRiskStatePanel(
                          state: _previewReady
                              ? VitHighRiskUiState.success
                              : VitHighRiskUiState.riskReview,
                          title: _previewReady
                              ? 'Export preview ready'
                              : 'Export review required',
                          message:
                              'Masked account data, report scope, file format, fee impact and transaction period are reviewed before export.',
                          contractId:
                              'savings-export-${selectedReport.name}-${selectedFormat.name}',
                        ),
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
