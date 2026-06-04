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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
part '../widgets/launchpad_risk_tabs_overview.dart';
part '../widgets/launchpad_risk_painter.dart';
part '../widgets/launchpad_risk_due_diligence.dart';
part '../widgets/launchpad_risk_report_common.dart';

enum _RiskAnalyticsTab { overview, dueDiligence, report }

class LaunchpadRiskAnalyticsPage extends ConsumerStatefulWidget {
  const LaunchpadRiskAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc317_launchpad_risk_content');
  static const tabsKey = Key('sc317_launchpad_risk_tabs');
  static const scoreKey = Key('sc317_launchpad_risk_score');
  static const breakdownKey = Key('sc317_launchpad_risk_breakdown');
  static const quickChecksKey = Key('sc317_launchpad_risk_quick_checks');
  static const warningsKey = Key('sc317_launchpad_risk_warnings');
  static const strengthsKey = Key('sc317_launchpad_risk_strengths');
  static const dueDiligenceKey = Key('sc317_launchpad_risk_due_diligence');
  static const reportKey = Key('sc317_launchpad_risk_report');
  static const distributionKey = Key('sc317_launchpad_risk_distribution');

  static Key projectKey(String id) => Key('sc317_launchpad_risk_project_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadRiskAnalyticsPage> createState() =>
      _LaunchpadRiskAnalyticsPageState();
}

class _LaunchpadRiskAnalyticsPageState
    extends ConsumerState<LaunchpadRiskAnalyticsPage> {
  var _activeTab = _RiskAnalyticsTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getRiskAnalytics();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        navInset + MediaQuery.paddingOf(context).bottom + AppSpacing.x6;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-317 LaunchpadRiskAnalyticsPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          bottomInset: bottomInset,
          semanticLabel: 'SC-317 LaunchpadRiskAnalyticsPage scroll surface',
          header: VitHeader(
            title: snapshot.title,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            children: [
              _Tabs(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: SingleChildScrollView(
                  key: LaunchpadRiskAnalyticsPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    customGap: AppSpacing.x4,
                    children: [
                      if (_activeTab == _RiskAnalyticsTab.overview) ...[
                        _OverallRiskCard(project: snapshot.project),
                        _RiskBreakdownCard(metrics: snapshot.metrics),
                        _QuickChecksSection(project: snapshot.project),
                        _SignalSection(
                          sectionKey: LaunchpadRiskAnalyticsPage.warningsKey,
                          label: 'Canh bao',
                          accent: AppColors.sell,
                          icon: Icons.warning_amber_rounded,
                          messages: snapshot.project.warnings,
                        ),
                        _SignalSection(
                          sectionKey: LaunchpadRiskAnalyticsPage.strengthsKey,
                          label: 'Diem manh',
                          accent: AppColors.buy,
                          icon: Icons.check_circle_outline_rounded,
                          messages: snapshot.project.strengths,
                        ),
                      ] else if (_activeTab ==
                          _RiskAnalyticsTab.dueDiligence) ...[
                        _DueDiligenceTab(snapshot: snapshot),
                      ] else ...[
                        _ReportTab(snapshot: snapshot),
                      ],
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
