import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

part '../widgets/staking_risk_dashboard_page_sections.dart';
part '../widgets/staking_risk_dashboard_page_common.dart';

class StakingRiskDashboardPage extends ConsumerWidget {
  const StakingRiskDashboardPage({super.key, this.shellRenderMode});

  static const scoreKey = Key('sc381_score');
  static const metricsKey = Key('sc381_metrics');
  static const exposureKey = Key('sc381_exposure');
  static const eventsKey = Key('sc381_events');
  static const actionsKey = Key('sc381_actions');
  static const footerKey = Key('sc381_footer');

  static Key metricKey(String category) => Key('sc381_metric_$category');
  static Key actionKey(String title) => Key('sc381_action_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(stakingRiskDashboardRepositoryProvider)
        .getRiskDashboard();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-381 StakingRiskDashboardPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.earnBottomInsetPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    children: [
                      _OverallRiskCard(snapshot: snapshot),
                      VitPageSection(
                        key: metricsKey,
                        label: 'Risk Breakdown',
                        accentColor: AppColors.primarySoft,
                        children: [
                          for (final metric in snapshot.riskMetrics)
                            _RiskMetricCard(metric: metric),
                        ],
                      ),
                      VitPageSection(
                        key: exposureKey,
                        label: 'Exposure by Asset',
                        accentColor: AppColors.primarySoft,
                        children: [
                          _ExposureCard(exposures: snapshot.exposures),
                        ],
                      ),
                      VitPageSection(
                        key: eventsKey,
                        label: 'Recent Risk Events',
                        accentColor: AppColors.primarySoft,
                        children: [
                          for (final event in snapshot.events)
                            _RiskEventCard(event: event),
                        ],
                      ),
                      VitPageSection(
                        key: actionsKey,
                        label: 'Risk Management Actions',
                        accentColor: AppColors.primarySoft,
                        children: [_ActionsGrid(actions: snapshot.actions)],
                      ),
                      _FooterNote(note: snapshot.footerNote),
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
