import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/bot_risk_dashboard_score.dart';
part '../widgets/bot_risk_dashboard_metrics.dart';
part '../widgets/bot_risk_dashboard_charts.dart';
part '../widgets/bot_risk_dashboard_controls.dart';

const _riskPrimary = AppColors.primary;
const _riskGreen = AppColors.buy;
const _riskAmber = AppColors.caution;
const _riskRed = AppColors.sell;
const _riskPurple = AppColors.accent;
const _riskTrack = AppColors.chartTrackRisk;

class BotRiskDashboardPage extends ConsumerWidget {
  const BotRiskDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc120_bot_risk_dashboard_content');
  static const emergencyHeaderKey = Key('sc120_bot_risk_header_emergency');
  static const emergencyButtonKey = Key('sc120_bot_risk_emergency_button');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotRiskDashboard();

    return VitTradeHubScaffold(
      title: 'Risk Dashboard',
      subtitle: 'Giám sát rủi ro bot theo thời gian thực',
      semanticLabel: 'SC-120 BotRiskDashboardPage',
      contentKey: BotRiskDashboardPage.contentKey,
      shellRenderMode: shellRenderMode,
      activeProductId: 'bots',
      onBack: () => context.go(AppRoutePaths.tradeBots),
      headerActions: [
        VitHeaderActionItem(
          key: BotRiskDashboardPage.emergencyHeaderKey,
          type: VitHeaderActionType.emergency,
          onPressed: () => context.go(snapshot.emergencyPath),
        ),
      ],
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Điểm rủi ro',
          primaryValue: '${snapshot.riskScore}',
          primaryColor: _riskAmber,
          secondaryLabel: 'Bot đang chạy',
          secondaryValue: '${snapshot.runningBots}',
          secondaryColor: AppColors.buy,
        ),
        VitTradeSection(
          title: 'Tổng quan rủi ro',
          child: _RiskScoreCard(snapshot: snapshot),
        ),
        VitTradeSection(
          title: 'Critical Metrics',
          child: _CriticalMetricsGrid(snapshot: snapshot),
        ),
        VitTradeSection(
          title: 'Drawdown Trend (24h)',
          child: _DrawdownChartCard(points: snapshot.drawdownPoints),
        ),
        VitTradeSection(
          title: 'Exposure by Asset',
          child: _ExposureCard(exposures: snapshot.exposures),
        ),
        VitTradeSection(
          title: 'VaR Trend (7 days)',
          child: _VarChartCard(points: snapshot.varHistory),
        ),
        VitTradeSection(
          title: 'Safety Controls',
          child: _SafetyControlsCard(controls: snapshot.safetyControls),
        ),
        VitTradeSection(
          title: 'Emergency Actions',
          child: _EmergencyActionCard(
            runningBots: snapshot.runningBots,
            onTap: () => context.go(snapshot.emergencyPath),
          ),
        ),
        VitTradeSection(
          title: 'Risk explanation',
          child: const _RiskExplanationCard(),
        ),
        const VitBotRiskReviewFooter(
          title: 'Risk dashboard review',
          message:
              'Score, critical metrics, exposure, VaR trend, safety controls and emergency-stop next step are reviewed before bot risk action.',
          contractId: 'bot-risk-dashboard-review',
          statusLabel: 'Emergency route confirmed',
          status: VitStatusPillStatus.warning,
        ),
      ],
    );
  }
}
