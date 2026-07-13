import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trade_bot_analytics_repository.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/bot_tax_reporting_notice_year.dart';
part '../widgets/bot_tax_reporting_summary.dart';
part '../widgets/bot_tax_reporting_reports.dart';
part '../widgets/bot_tax_reporting_common.dart';

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
        .read(tradeBotAnalyticsRepositoryProvider)
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
    final repository = ref.watch(tradeBotAnalyticsRepositoryProvider);
    final snapshot = repository.getBotTaxReporting();
    const generateFooterHeight = AppSpacing.inputHeight + AppSpacing.x4;

    return Stack(
      children: [
        VitTradeHubScaffold(
          title: 'Tax Reporting',
          subtitle: 'Báo cáo thuế bot giao dịch',
          semanticLabel: 'SC-133 BotTaxReportingPage',
          contentKey: BotTaxReportingPage.contentKey,
          shellRenderMode: widget.shellRenderMode,
          activeProductId: 'bots',
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.tradeBots,
            mode: BackNavigationMode.historyThenFallback,
          ),
          children: [
            VitTradeSection(title: 'Notice', child: const _TaxNotice()),
            VitTradeSection(
              title: 'Select Tax Year',
              child: _YearPicker(
                years: snapshot.taxYears,
                selectedYear: _selectedYear,
                onChanged: (year) {
                  setState(() => _selectedYear = year);
                },
              ),
            ),
            VitTradeSection(
              title: 'Summary for $_selectedYear',
              child: _SummaryCard(summary: snapshot.summary),
            ),
            VitTradeSection(
              title: 'Cost Basis Method',
              child: _CostBasisPicker(
                selectedMethod: _costBasisMethod,
                onChanged: (method) {
                  setState(() => _costBasisMethod = method);
                },
              ),
            ),
            VitTradeSection(
              title: 'Select Report Types',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final report in snapshot.reportTypes)
                    _ReportTypeCard(
                      report: report,
                      selected: _selectedReportIds.contains(report.id),
                      onTap: () => _toggleReport(report.id),
                    ),
                ],
              ),
            ),
            VitTradeSection(
              title: 'Capital Gains Breakdown',
              child: _BreakdownCard(
                summary: snapshot.summary,
                breakdown: snapshot.breakdown,
              ),
            ),
            VitTradeSection(
              title: 'Tax notes',
              child: _TaxNotesCard(notes: snapshot.taxNotes),
            ),
            const VitBotRiskReviewFooter(
              title: 'Tax export review required',
              message:
                  'Tax year, cost basis, report type, generated file, sensitive data masking and next steps are reviewed before export.',
              contractId: 'bot-tax-reporting-review',
              statusLabel: 'Report preview before export',
            ),
            const SizedBox(height: generateFooterHeight),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _GenerateFooter(
            bottomInset: tradeScrollBottomInset(
              context,
              shellRenderMode: widget.shellRenderMode,
            ),
            disabled: _selectedReportIds.isEmpty || _generating,
            generating: _generating,
            selectedCount: _selectedReportIds.length,
            selectedYear: _selectedYear,
            onPressed: () => _generate(repository),
          ),
        ),
      ],
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

  void _generate(TradeBotAnalyticsRepository repository) {
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
