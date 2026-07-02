import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';

import '../widgets/trade_body_review_widgets.dart';

part '../widgets/ex_post_costs_report_summary.dart';
part '../widgets/ex_post_costs_report_variance_common.dart';

const _reportBorder = AppColors.borderSolid;
const _reportPrimary = AppColors.primary;
const _reportGreen = AppColors.buy;
const _reportAmber = AppColors.caution;
const _reportRed = AppColors.sell;

class ExPostCostsReportPage extends ConsumerStatefulWidget {
  const ExPostCostsReportPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc107_ex_post_content');
  static const downloadKey = Key('sc107_ex_post_download');
  static Key tabKey(int year) => Key('sc107_ex_post_tab_$year');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExPostCostsReportPage> createState() =>
      _ExPostCostsReportPageState();
}

class _ExPostCostsReportPageState extends ConsumerState<ExPostCostsReportPage> {
  int _selectedYear = 2025;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tradeReadModelControllerProvider);
    final snapshot = repository.getExPostCostsReport();
    final report = snapshot.reportForYear(_selectedYear);
    return VitTradeHubScaffold(
      title: 'Ex-Post Cost Report',
      subtitle: 'Annual Actual Costs',
      semanticLabel: 'SC-107 ExPostCostsReportPage',
      contentKey: ExPostCostsReportPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeCopyExAnteCosts),
      headerActions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.export,
          onPressed: () =>
              repository.createExPostCostsReportExport(year: _selectedYear),
        ),
      ],
      children: [
        VitTradeSection(
          title: 'Notice',
          child: _ComplianceNotice(year: report.year),
        ),
        VitTradeSection(
          title: 'Report',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Total Actual Costs',
                      value: _formatEur(report.totalActual),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Estimated Costs',
                      value: _formatEur(report.totalEstimated),
                      muted: true,
                    ),
                  ),
                ],
              ),
              VitHighRiskStatePanel(
                state: VitHighRiskUiState.success,
                title: 'Actual cost report ready',
                message:
                    'Review actual versus estimated costs, variance drivers, fee impact, and next-step export before using this report for disclosure.',
                contractId: 'SC-107 ${report.year} report',
                density: VitDensity.compact,
              ),
              _YearTabs(
                reports: snapshot.reports,
                activeYear: _selectedYear,
                onChanged: (year) => setState(() {
                  _selectedYear = year;
                }),
              ),
              const _SectionLabel('Actual vs. Estimated'),
              _CostBreakdownCard(
                title: 'One-off Costs',
                actual: report.oneOff,
                estimate: report.estimatedOneOff,
              ),
              _CostBreakdownCard(
                title: 'Recurring Costs',
                actual: report.recurring,
                estimate: report.estimatedRecurring,
                note: _VarianceNote.lower(
                  report.estimatedRecurring - report.recurring,
                ),
              ),
              _CostBreakdownCard(
                title: 'Incidental Costs',
                actual: report.incidental,
                estimate: report.estimatedIncidental,
                note: _VarianceNote.higher(
                  report.incidental - report.estimatedIncidental,
                ),
              ),
              const _SectionLabel('Variance Analysis'),
              _VarianceCard(report: report),
              const TradeBodyReviewSection(
                title: 'Cost report body review',
                message: 'Ex-post cost report body reviewed',
                detail:
                    'Year tabs, actual costs, estimates, variance, disclosure, empty, and result states stay visible.',
                primary:
                    'Actual and estimated costs remain visible before variance details.',
                secondary: 'Year switching preserves cost-report context.',
                tertiary:
                    'Disclosure copy stays informational and not execution-oriented.',
              ),
            ],
          ),
        ),
        VitTradeComplianceSection(
          title: 'Report status',
          statusPill: VitStatusPill(
            label: '${report.year} report',
            status: VitStatusPillStatus.success,
            size: VitStatusPillSize.sm,
          ),
          items: const [
            VitTradeComplianceItem(
              label: 'Framework',
              value: 'MiFID II cost disclosure',
            ),
            VitTradeComplianceItem(
              label: 'Action',
              value: 'Review variance before export',
            ),
          ],
        ),
      ],
    );
  }
}
