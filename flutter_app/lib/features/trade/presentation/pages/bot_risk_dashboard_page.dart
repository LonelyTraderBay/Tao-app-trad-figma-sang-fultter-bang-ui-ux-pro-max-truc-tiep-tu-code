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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/bot_risk_dashboard_score.dart';
part '../widgets/bot_risk_dashboard_metrics.dart';
part '../widgets/bot_risk_dashboard_charts.dart';
part '../widgets/bot_risk_dashboard_controls.dart';

const _riskBackground = AppColors.bg;
const _riskPanel = AppColors.surface;
const _riskPanel2 = AppColors.surface2;
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
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 104
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-120 BotRiskDashboardPage',
      child: Material(
        color: _riskBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Risk Dashboard',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
              trailing: _HeaderEmergencyButton(
                onTap: () => context.go(snapshot.emergencyPath),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotRiskDashboardPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _RiskScoreCard(snapshot: snapshot),
                    const SizedBox(height: 16),
                    const _SectionLabel('Critical Metrics'),
                    const SizedBox(height: 8),
                    _CriticalMetricsGrid(snapshot: snapshot),
                    const SizedBox(height: 14),
                    const _SectionLabel('Drawdown Trend (24h)'),
                    const SizedBox(height: 12),
                    _DrawdownChartCard(points: snapshot.drawdownPoints),
                    const SizedBox(height: 18),
                    const _SectionLabel('Exposure by Asset'),
                    const SizedBox(height: 12),
                    _ExposureCard(exposures: snapshot.exposures),
                    const SizedBox(height: 18),
                    const _SectionLabel('VaR Trend (7 days)'),
                    const SizedBox(height: 12),
                    _VarChartCard(points: snapshot.varHistory),
                    const SizedBox(height: 18),
                    const _SectionLabel('Safety Controls'),
                    const SizedBox(height: 12),
                    _SafetyControlsCard(controls: snapshot.safetyControls),
                    const SizedBox(height: 18),
                    const _SectionLabel('Emergency Actions'),
                    const SizedBox(height: 12),
                    _EmergencyActionCard(
                      runningBots: snapshot.runningBots,
                      onTap: () => context.go(snapshot.emergencyPath),
                    ),
                    const SizedBox(height: 18),
                    const _RiskExplanationCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
