import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_tax_reporting_notice_year.dart';
part '../widgets/bot_tax_reporting_summary.dart';
part '../widgets/bot_tax_reporting_reports.dart';
part '../widgets/bot_tax_reporting_common.dart';

const _taxBackground = AppColors.bg;
const _taxPanel = AppColors.surface;
const _taxPanel2 = AppColors.surface2;
const _taxPrimary = AppColors.primary;
const _taxGreen = AppColors.buy;
const _taxAmber = AppColors.caution;
const _taxRed = AppColors.sell;
const _taxOptionBorder = AppColors.taxOptionBorder;

class BotTaxReportingPage extends ConsumerStatefulWidget {
  const BotTaxReportingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc133_bot_tax_reporting_content');
  static const generateKey = Key('sc133_bot_tax_reporting_generate');
  static Key yearKey(String year) => Key('sc133_bot_tax_year_$year');
  static Key methodKey(String method) => Key('sc133_bot_tax_method_$method');
  static Key reportKey(String reportId) =>
      Key('sc133_bot_tax_report_$reportId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotTaxReportingPage> createState() =>
      _BotTaxReportingPageState();
}

class _BotTaxReportingPageState extends ConsumerState<BotTaxReportingPage> {
  late String _selectedYear;
  late String _costBasisMethod;
  late Set<String> _selectedReportIds;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(tradeReadModelControllerProvider)
        .getBotTaxReporting();
    _selectedYear = snapshot.defaultYear;
    _costBasisMethod = snapshot.defaultCostBasisMethod;
    _selectedReportIds = {
      for (final report in snapshot.reportTypes)
        if (report.selectedByDefault) report.id,
    };
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tradeReadModelControllerProvider);
    final snapshot = repository.getBotTaxReporting();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 128
            : DeviceMetrics.nativeBottomChrome + 96) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-133 BotTaxReportingPage',
      child: Material(
        color: _taxBackground,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Tax Reporting',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.tradeBots),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: BotTaxReportingPage.contentKey,
                      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _TaxNotice(),
                          const SizedBox(height: 31),
                          const _SectionLabel('Select Tax Year'),
                          const SizedBox(height: 10),
                          _YearPicker(
                            years: snapshot.taxYears,
                            selectedYear: _selectedYear,
                            onChanged: (year) {
                              setState(() => _selectedYear = year);
                            },
                          ),
                          const SizedBox(height: 18),
                          _SectionLabel('Summary for $_selectedYear'),
                          const SizedBox(height: 10),
                          _SummaryCard(summary: snapshot.summary),
                          const SizedBox(height: 18),
                          const _SectionLabel('Cost Basis Method'),
                          const SizedBox(height: 10),
                          _CostBasisPicker(
                            selectedMethod: _costBasisMethod,
                            onChanged: (method) {
                              setState(() => _costBasisMethod = method);
                            },
                          ),
                          const SizedBox(height: 18),
                          const _SectionLabel('Select Report Types'),
                          const SizedBox(height: 10),
                          for (final report in snapshot.reportTypes) ...[
                            _ReportTypeCard(
                              report: report,
                              selected: _selectedReportIds.contains(report.id),
                              onTap: () => _toggleReport(report.id),
                            ),
                            if (report != snapshot.reportTypes.last)
                              const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 18),
                          const _SectionLabel('Capital Gains Breakdown'),
                          const SizedBox(height: 10),
                          _BreakdownCard(
                            summary: snapshot.summary,
                            breakdown: snapshot.breakdown,
                          ),
                          const SizedBox(height: 17),
                          _TaxNotesCard(notes: snapshot.taxNotes),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _GenerateFooter(
              visualMode: mode.usesVisualQaFrame,
              disabled: _selectedReportIds.isEmpty || _generating,
              generating: _generating,
              selectedCount: _selectedReportIds.length,
              selectedYear: _selectedYear,
              onPressed: () => _generate(repository),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleReport(String id) {
    setState(() {
      if (_selectedReportIds.contains(id)) {
        _selectedReportIds.remove(id);
      } else {
        _selectedReportIds.add(id);
      }
    });
  }

  void _generate(TradeRepository repository) {
    if (_selectedReportIds.isEmpty || _generating) return;
    setState(() => _generating = true);
    repository.createBotTaxReportExport(
      TradeBotTaxReportExportRequest(
        year: _selectedYear,
        reportTypeIds: _selectedReportIds.toList(growable: false),
        costBasisMethod: _costBasisMethod,
      ),
    );
    setState(() => _generating = false);
  }
}
