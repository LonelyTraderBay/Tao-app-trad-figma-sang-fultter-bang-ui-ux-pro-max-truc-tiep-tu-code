import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/regulatory_reports_dashboard_kpis.dart';
part '../widgets/regulatory_reports_dashboard_controls.dart';
part '../widgets/regulatory_reports_dashboard_overview.dart';
part '../widgets/regulatory_reports_dashboard_painters.dart';
part '../widgets/regulatory_reports_dashboard_queue_compliance.dart';
part '../widgets/regulatory_reports_dashboard_exports.dart';

const _dashBackground = AppColors.bg;
const _dashPanel2 = AppColors.surface2;
const _dashBorder = AppColors.borderSolid;
const _dashGreen = AppColors.buy;
const _dashRed = AppColors.sell;
const _dashAmber = AppColors.caution;
const _dashPrimary = AppColors.primary;

class RegulatoryReportsDashboardPage extends ConsumerStatefulWidget {
  const RegulatoryReportsDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc094_regulatory_reports_content');
  static const kpiGridKey = Key('sc094_regulatory_reports_kpi_grid');
  static Key tabKey(String id) => Key('sc094_regulatory_tab_$id');
  static Key rangeKey(String id) => Key('sc094_regulatory_range_$id');
  static Key actionKey(String id) => Key('sc094_regulatory_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RegulatoryReportsDashboardPage> createState() =>
      _RegulatoryReportsDashboardPageState();
}

class _RegulatoryReportsDashboardPageState
    extends ConsumerState<RegulatoryReportsDashboardPage> {
  String _tab = 'overview';
  String _range = '7D';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeRegulatoryRepositoryProvider)
        .getRegulatoryReportsDashboard();
    return Material(
      color: _dashBackground,
      child: Stack(
        children: [
          VitTradeHubScaffold(
            title: 'Regulatory Reports',
            subtitle: 'Dashboard - MiFID II - EMIR',
            semanticLabel: 'SC-094 RegulatoryReportsDashboardPage',
            contentKey: RegulatoryReportsDashboardPage.contentKey,
            shellRenderMode: widget.shellRenderMode,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.tradeCopyTransactionReporting,
              mode: BackNavigationMode.historyThenFallback,
            ),
            headerActions: [
              VitHeaderActionItem(
                type: VitHeaderActionType.export,
                onPressed: () => setState(() => _notice = 'Export queued'),
              ),
            ],
            children: [
              VitTradeSection(
                title: 'KPIs',
                child: _KpiGrid(totals: snapshot.totals),
              ),
              VitTradeSection(
                title: 'Review',
                child: const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Regulatory report review',
                  message:
                      'Report queue, confirmed count, failed count, export action, ARM route and remediation next step are reviewed before submission follow-up.',
                  contractId: 'regulatory-reports-review',
                ),
              ),
              VitTradeComplianceSection(
                title: 'Report review',
                statusPill: const VitStatusPill(
                  label: 'SLA and failures visible',
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Success rate',
                    value: '${snapshot.totals.successRate.toStringAsFixed(1)}%',
                  ),
                  VitTradeComplianceItem(
                    label: 'Failed',
                    value: '${snapshot.totals.failed}',
                  ),
                ],
              ),
              VitTradeSection(
                title: 'Dashboard',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    VitTradeComplianceHero(
                      title: '100% SLA Compliance (Last 7 Days)',
                      description:
                          'All reports submitted within T+1. Zero regulatory '
                          'breaches. Avg latency: '
                          '${snapshot.totals.avgLatency.round()}s.',
                      icon: Icons.check_circle_outline,
                      accentColor: AppColors.text1,
                    ),
                    _RangeSelector(
                      ranges: snapshot.timeRanges,
                      activeId: _range,
                      onChanged: (id) => setState(() => _range = id),
                    ),
                    _Tabs(
                      activeId: _tab,
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                    if (_tab == 'overview')
                      _OverviewTab(snapshot: snapshot)
                    else if (_tab == 'queue')
                      _QueueTab(snapshot: snapshot)
                    else if (_tab == 'compliance')
                      _ComplianceTab(totals: snapshot.totals)
                    else
                      _ExportsTab(
                        onNotice: (text) => setState(() => _notice = text),
                      ),
                    _QuickActions(
                      onQueue: () => context.push(
                        AppRoutePaths.tradeCopyTransactionReporting,
                      ),
                      onArmStatus: () => context.push(
                        AppRoutePaths.tradeCopyArmIntegrationStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_notice != null)
            Positioned(
              left: AppSpacing.contentPad,
              right: AppSpacing.contentPad,
              bottom:
                  TradeSpacingTokens.tradeBotBottomInsetVisual +
                  TradeSpacingTokens.tradeBotPanelGap +
                  MediaQuery.paddingOf(context).bottom,
              child: VitBanner(
                variant: VitBannerVariant.success,
                icon: Icons.check_circle_outline,
                message: _notice!,
                onDismiss: () => setState(() => _notice = null),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('overview', 'Overview'),
    ('queue', 'Queue'),
    ('compliance', 'Compliance'),
    ('exports', 'Exports'),
  ];

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      activeKey: activeId,
      tabs: [
        for (final tab in _tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: RegulatoryReportsDashboardPage.tabKey(tab.$1),
          ),
      ],
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
    );
  }
}
