import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_equity_curve_summary_tabs.dart';
part '../widgets/bot_equity_curve_charts_cards.dart';
part '../widgets/bot_equity_curve_analysis_painters.dart';

const _equityBackground = AppColors.bg;
const _equityGreen = AppColors.buy;
const _equityPrimary = AppColors.primary;
const _equityRed = AppColors.sell;
const _equityAxis = AppColors.chartAxisStrong;

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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 94
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-130 BotEquityCurvePage',
      child: Material(
        color: _equityBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Equity Curve',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotEquityCurvePage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: 12,
                    children: [
                      _SummaryRow(summary: snapshot.summary),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: VitPageContent(
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          customGap: 8,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Equity curve review',
                              message:
                                  'Equity trend, alpha, drawdown, Sharpe context and risk next steps are reviewed before bot changes.',
                              contractId: 'bot-equity-curve-review',
                            ),
                            VitStatusPill(
                              label: 'Performance is not guaranteed',
                              status: VitStatusPillStatus.warning,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
                      _Tabs(
                        active: _view,
                        onChanged: (id) => setState(() => _view = id),
                      ),
                      if (_view == 'equity')
                        VitPageSection(
                          label: 'Equity Curve vs Buy & Hold',
                          children: [
                            _EquityChartCard(points: snapshot.equityPoints),
                          ],
                        )
                      else if (_view == 'sharpe')
                        VitPageSection(
                          label: 'Rolling 30-Day Sharpe Ratio',
                          children: [
                            _SharpeCard(points: snapshot.equityPoints),
                          ],
                        )
                      else
                        VitPageSection(
                          label: 'Monthly Alpha (Bot vs Market)',
                          children: [
                            _MonthlyAlphaCard(months: snapshot.monthlyReturns),
                          ],
                        ),
                      VitPageSection(
                        label: 'Performance Statistics',
                        children: [
                          _PerformanceCard(stats: snapshot.performanceStats),
                        ],
                      ),
                      _AnalysisCard(items: snapshot.analysisItems),
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
