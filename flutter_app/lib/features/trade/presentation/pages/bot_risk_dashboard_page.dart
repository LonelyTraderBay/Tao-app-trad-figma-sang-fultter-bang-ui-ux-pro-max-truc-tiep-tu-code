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
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_risk_dashboard_score.dart';
part '../widgets/bot_risk_dashboard_metrics.dart';
part '../widgets/bot_risk_dashboard_charts.dart';
part '../widgets/bot_risk_dashboard_controls.dart';

const _riskBackground = AppColors.bg;
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
    final bottomInset = tradeScrollBottomInset(
        context,
        shellRenderMode: mode,
      );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-120 BotRiskDashboardPage',
      child: Material(
        color: _riskBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Risk Dashboard',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeBots),
            actions: [
              VitHeaderActionItem(
                key: BotRiskDashboardPage.emergencyHeaderKey,
                type: VitHeaderActionType.emergency,
                onPressed: () => context.go(snapshot.emergencyPath),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: BotRiskDashboardPage.contentKey,
                  clipBehavior: Clip.none,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.contentPad,
                    top: AppSpacing.x2,
                    right: AppSpacing.contentPad,
                    bottom: bottomInset,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    density: VitDensity.compact,
                    fullBleed: true,
                    children: [
                      _RiskScoreCard(snapshot: snapshot),
                      const _SectionLabel('Critical Metrics'),
                      VitPageSection(
                        density: VitDensity.compact,
                        children: [_CriticalMetricsGrid(snapshot: snapshot)],
                      ),
                      const _SectionLabel('Drawdown Trend (24h)'),
                      _DrawdownChartCard(points: snapshot.drawdownPoints),
                      const _SectionLabel('Exposure by Asset'),
                      _ExposureCard(exposures: snapshot.exposures),
                      const _SectionLabel('VaR Trend (7 days)'),
                      _VarChartCard(points: snapshot.varHistory),
                      const _SectionLabel('Safety Controls'),
                      _SafetyControlsCard(controls: snapshot.safetyControls),
                      const _SectionLabel('Emergency Actions'),
                      _EmergencyActionCard(
                        runningBots: snapshot.runningBots,
                        onTap: () => context.go(snapshot.emergencyPath),
                      ),
                      const _RiskExplanationCard(),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        density: VitDensity.compact,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Risk dashboard review',
                              message:
                                  'Score, critical metrics, exposure, VaR trend, safety controls and emergency-stop next step are reviewed before bot risk action.',
                              contractId: 'bot-risk-dashboard-review',
                              density: VitDensity.compact,
                            ),
                            SizedBox(height: AppSpacing.x2),
                            VitStatusPill(
                              label: 'Emergency route confirmed',
                              status: VitStatusPillStatus.warning,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ),
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
