import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/riy_calculator_page_sections.dart';
part '../widgets/riy_calculator_page_common.dart';

const _riyBackground = AppColors.bg;
const _riyPanel2 = AppColors.surface2;
const _riyBorder = AppColors.borderSolid;
const _riyPrimary = AppColors.primary;
const _riyGreen = AppColors.buy;
const _riyRed = AppColors.sell;
const _riyGrid = AppColors.portfolioBtnGhost;

class RIYCalculatorPage extends ConsumerStatefulWidget {
  const RIYCalculatorPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc106_riy_content');
  static const investmentKey = Key('sc106_riy_investment');
  static const expectedReturnKey = Key('sc106_riy_expected_return');
  static const totalCostsKey = Key('sc106_riy_total_costs');
  static const yearsKey = Key('sc106_riy_years');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RIYCalculatorPage> createState() => _RIYCalculatorPageState();
}

class _RIYCalculatorPageState extends ConsumerState<RIYCalculatorPage> {
  late double _investment;
  late double _expectedReturn;
  late double _totalCosts;
  late int _years;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(tradeReadModelControllerProvider)
        .getRiyCalculator();
    _investment = snapshot.investmentAmount;
    _expectedReturn = snapshot.expectedReturnPct;
    _totalCosts = snapshot.totalCostsPct;
    _years = snapshot.holdingPeriodYears;
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;
    final projections = _buildProjections(
      investment: _investment,
      expectedReturn: _expectedReturn,
      totalCosts: _totalCosts,
      years: _years,
    );
    final finalWithoutCosts = projections.last.withoutCosts;
    final finalWithCosts = projections.last.withCosts;
    final difference = finalWithoutCosts - finalWithCosts;
    final lossPct = finalWithoutCosts <= 0
        ? 0.0
        : (difference / finalWithoutCosts) * 100;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-106 RIYCalculatorPage',
      child: Material(
        color: _riyBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'RIY Calculator',
            subtitle: 'Cost Impact Analysis',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyExAnteCosts),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: RIYCalculatorPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 15, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 12,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review cost impact before proceeding',
                        message:
                            'Confirm fees, risk assumptions, holding period, and next steps before using RIY projections for copy trading.',
                      ),
                      const _SectionLabel('Investment Parameters'),
                      _InputCard(
                        investment: _investment,
                        expectedReturn: _expectedReturn,
                        totalCosts: _totalCosts,
                        years: _years,
                        onInvestmentChanged: (value) =>
                            setState(() => _investment = value),
                        onExpectedReturnChanged: (value) =>
                            setState(() => _expectedReturn = value),
                        onTotalCostsChanged: (value) =>
                            setState(() => _totalCosts = value),
                        onYearsChanged: (value) =>
                            setState(() => _years = value),
                      ),
                      const _SectionLabel('Impact Analysis'),
                      Row(
                        children: [
                          Expanded(
                            child: _ResultMetric(
                              label: 'Without Costs',
                              value: _formatEur(finalWithoutCosts),
                              color: _riyGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ResultMetric(
                              label: 'With Costs',
                              value: _formatEur(finalWithCosts),
                              color: _riyRed,
                            ),
                          ),
                        ],
                      ),
                      _CostImpactCard(
                        years: _years,
                        difference: difference,
                        lossPct: lossPct,
                      ),
                      const _SectionLabel('Growth Comparison'),
                      _ChartCard(projections: projections),
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
