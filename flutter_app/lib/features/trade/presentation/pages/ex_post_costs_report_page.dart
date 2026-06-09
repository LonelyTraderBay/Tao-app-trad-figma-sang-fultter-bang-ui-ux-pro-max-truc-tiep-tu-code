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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/ex_post_costs_report_summary.dart';
part '../widgets/ex_post_costs_report_variance_common.dart';

const _reportBackground = AppColors.bg;
const _reportPanel2 = AppColors.surface2;
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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-107 ExPostCostsReportPage',
      child: Material(
        color: _reportBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Ex-Post Cost Report',
            subtitle: 'Annual Actual Costs',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyExAnteCosts),
            actions: [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                onPressed: () => repository.createExPostCostsReportExport(
                  year: _selectedYear,
                ),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ExPostCostsReportPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 27, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 0,
                    children: [
                      _ComplianceNotice(year: report.year),
                      const SizedBox(height: 35),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              label: 'Total Actual Costs',
                              value: _formatEur(report.totalActual),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryCard(
                              label: 'Estimated Costs',
                              value: _formatEur(report.totalEstimated),
                              muted: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.success,
                        title: 'Actual cost report ready',
                        message:
                            'Review actual versus estimated costs, variance drivers, fee impact, and next-step export before using this report for disclosure.',
                        contractId: 'SC-107 ${report.year} report',
                      ),
                      const SizedBox(height: 24),
                      _YearTabs(
                        reports: snapshot.reports,
                        activeYear: _selectedYear,
                        onChanged: (year) => setState(() {
                          _selectedYear = year;
                        }),
                      ),
                      const SizedBox(height: 27),
                      const _SectionLabel('Actual vs. Estimated'),
                      const SizedBox(height: 12),
                      _CostBreakdownCard(
                        title: 'One-off Costs',
                        actual: report.oneOff,
                        estimate: report.estimatedOneOff,
                      ),
                      const SizedBox(height: 13),
                      _CostBreakdownCard(
                        title: 'Recurring Costs',
                        actual: report.recurring,
                        estimate: report.estimatedRecurring,
                        note: _VarianceNote.lower(
                          report.estimatedRecurring - report.recurring,
                        ),
                      ),
                      const SizedBox(height: 13),
                      _CostBreakdownCard(
                        title: 'Incidental Costs',
                        actual: report.incidental,
                        estimate: report.estimatedIncidental,
                        note: _VarianceNote.higher(
                          report.incidental - report.estimatedIncidental,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const _SectionLabel('Variance Analysis'),
                      const SizedBox(height: 12),
                      _VarianceCard(report: report),
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
}
