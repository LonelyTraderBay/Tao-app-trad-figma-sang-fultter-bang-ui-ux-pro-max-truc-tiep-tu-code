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
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/widgets/settings/trade_bot_radio_icon.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../widgets/settings/bot_tax_reporting_notice_year.dart';
part '../../widgets/settings/bot_tax_reporting_summary.dart';
part '../../widgets/settings/bot_tax_reporting_reports.dart';
part '../../widgets/settings/bot_tax_reporting_common.dart';

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
  String? _selectedYear;
  String? _costBasisMethod;
  Set<String>? _selectedReportIds;
  bool _generating = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotTaxReportingProvider);
    const generateFooterHeight = AppSpacing.inputHeight + AppSpacing.x4;

    return Stack(
      children: [
        VitTradeHubScaffold(
          title: 'Tax Reporting',
          subtitle: 'Báo cáo thuế bot giao dịch',
          semanticLabel: 'Báo cáo thuế cho giao dịch bot',
          semanticIdentifier: 'SC-133',
          contentKey: BotTaxReportingPage.contentKey,
          shellRenderMode: widget.shellRenderMode,
          activeProductId: 'bots',
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.tradeBots,
            mode: BackNavigationMode.historyThenFallback,
          ),
          children: snapshotAsync.when(
            loading: () => const [VitSkeletonList()],
            error: (error, stackTrace) => [
              VitErrorState(
                title: 'Không tải được báo cáo thuế',
                message: 'Vui lòng kiểm tra kết nối và thử lại.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(tradeBotTaxReportingProvider),
              ),
            ],
            data: (snapshot) {
              _selectedYear ??= snapshot.defaultYear;
              _costBasisMethod ??= snapshot.defaultCostBasisMethod;
              _selectedReportIds ??= {
                for (final report in snapshot.reportTypes)
                  if (report.selectedByDefault) report.id,
              };
              final selectedYear = _selectedYear!;
              final costBasisMethod = _costBasisMethod!;
              final selectedReportIds = _selectedReportIds!;
              return [
                const VitTradeSection(title: 'Notice', child: _TaxNotice()),
                VitTradeSection(
                  title: 'Select Tax Year',
                  child: _YearPicker(
                    years: snapshot.taxYears,
                    selectedYear: selectedYear,
                    onChanged: (year) {
                      setState(() => _selectedYear = year);
                    },
                  ),
                ),
                VitTradeSection(
                  title: 'Summary for $selectedYear',
                  child: _SummaryCard(summary: snapshot.summary),
                ),
                VitTradeSection(
                  title: 'Cost Basis Method',
                  child: _CostBasisPicker(
                    selectedMethod: costBasisMethod,
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
                          selected: selectedReportIds.contains(report.id),
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
              ];
            },
          ),
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
            disabled: (_selectedReportIds?.isEmpty ?? true) || _generating,
            generating: _generating,
            selectedCount: _selectedReportIds?.length ?? 0,
            selectedYear: _selectedYear ?? '',
            onPressed: _generate,
          ),
        ),
      ],
    );
  }

  void _toggleReport(String id) {
    setState(() {
      final ids = {...?_selectedReportIds};
      if (ids.contains(id)) {
        ids.remove(id);
      } else {
        ids.add(id);
      }
      _selectedReportIds = ids;
    });
  }

  Future<void> _generate() async {
    final reportIds = _selectedReportIds;
    final year = _selectedYear;
    final costBasisMethod = _costBasisMethod;
    if (reportIds == null ||
        year == null ||
        costBasisMethod == null ||
        reportIds.isEmpty ||
        _generating) {
      return;
    }
    setState(() => _generating = true);
    await ref
        .read(tradeBotAnalyticsRepositoryProvider)
        .createBotTaxReportExport(
          TradeBotTaxReportExportRequest(
            year: year,
            reportTypeIds: reportIds.toList(growable: false),
            costBasisMethod: costBasisMethod,
          ),
        );
    if (!mounted) return;
    setState(() => _generating = false);
  }
}
