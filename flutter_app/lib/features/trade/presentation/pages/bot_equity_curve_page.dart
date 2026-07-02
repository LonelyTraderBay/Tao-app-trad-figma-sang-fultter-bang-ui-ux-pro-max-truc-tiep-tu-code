import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_equity_curve_summary_tabs.dart';
part '../widgets/bot_equity_curve_charts_cards.dart';
part '../widgets/bot_equity_curve_analysis_painters.dart';

const _equityGreen = AppColors.buy;
const _equityPrimary = AppColors.primary;
const _equityRed = AppColors.sell;
const _equityAxis = AppColors.chartAxisStrong;
const double _equitySummaryMetricExtent =
    AppSpacing.buttonCompact + AppSpacing.x4;
const double _equityChartExtent = AppSpacing.buttonStandard * 3 + AppSpacing.x4;
const double _equitySharpeExtent =
    AppSpacing.buttonStandard * 2 + AppSpacing.x6;
const double _equityProgressExtent = AppSpacing.x2 + AppSpacing.x1;

class BotEquityCurvePage extends ConsumerStatefulWidget {
  const BotEquityCurvePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc130_bot_equity_curve_content');
  static Key tabKey(String id) => Key('sc130_equity_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotEquityCurvePage> createState() => _BotEquityCurvePageState();
}

class _BotEquityCurvePageState extends ConsumerState<BotEquityCurvePage> {
  String _view = 'equity';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotEquityCurve();
    return VitTradeHubScaffold(
      title: 'Equity Curve',
      semanticLabel: 'SC-130 BotEquityCurvePage',
      contentKey: BotEquityCurvePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.tradeBots),
      children: [
        VitTradeSection(
          title: 'Summary',
          child: _SummaryRow(summary: snapshot.summary),
        ),
        VitTradeSection(
          title: 'Đánh giá rủi ro',
          child: VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.tradeBotCompactCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Equity curve review',
                  message:
                      'Equity trend, alpha, drawdown, Sharpe context and risk next steps are reviewed before bot changes.',
                  contractId: 'bot-equity-curve-review',
                ),
                SizedBox(height: AppSpacing.x2),
                VitStatusPill(
                  label: 'Performance is not guaranteed',
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
              ],
            ),
          ),
        ),
        VitTradeSection(
          title: 'View',
          child: _Tabs(
            active: _view,
            onChanged: (id) => setState(() => _view = id),
          ),
        ),
        if (_view == 'equity')
          VitTradeSection(
            title: 'Equity Curve vs Buy & Hold',
            child: _EquityChartCard(points: snapshot.equityPoints),
          )
        else if (_view == 'sharpe')
          VitTradeSection(
            title: 'Rolling 30-Day Sharpe Ratio',
            child: _SharpeCard(points: snapshot.equityPoints),
          )
        else
          VitTradeSection(
            title: 'Monthly Alpha (Bot vs Market)',
            child: _MonthlyAlphaCard(months: snapshot.monthlyReturns),
          ),
        VitTradeSection(
          title: 'Performance Statistics',
          child: _PerformanceCard(stats: snapshot.performanceStats),
        ),
        VitTradeSection(
          title: 'Analysis',
          child: _AnalysisCard(items: snapshot.analysisItems),
        ),
      ],
    );
  }
}
