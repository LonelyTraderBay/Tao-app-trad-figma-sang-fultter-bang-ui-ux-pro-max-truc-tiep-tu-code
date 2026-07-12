import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../widgets/slippage_monitoring_overview.dart';
part '../widgets/slippage_monitoring_events.dart';
part '../widgets/slippage_monitoring_tabs.dart';
part '../widgets/slippage_monitoring_common.dart';

const _slipBackground = AppColors.bg;
const _slipPanel2 = AppColors.surface2;
const _slipBorder = AppColors.borderSolid;
const _slipGreen = AppColors.buy;
const _slipAmber = AppColors.caution;
const _slipRed = AppColors.sell;
const _slipPrimary = AppColors.primary;

class SlippageMonitoringPage extends ConsumerStatefulWidget {
  const SlippageMonitoringPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc098_slippage_content');
  static Key tabKey(String id) => Key('sc098_slippage_tab_$id');
  static Key eventKey(String id) => Key('sc098_slippage_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SlippageMonitoringPage> createState() =>
      _SlippageMonitoringPageState();
}

class _SlippageMonitoringPageState
    extends ConsumerState<SlippageMonitoringPage> {
  String _tab = 'realtime';
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getSlippageMonitoring();
    return Material(
      color: _slipBackground,
      child: Stack(
        children: [
          VitTradeHubScaffold(
            title: 'Slippage Monitoring',
            subtitle: 'Real-time Tracking · Alerts',
            semanticLabel: 'SC-098 SlippageMonitoringPage',
            contentKey: SlippageMonitoringPage.contentKey,
            shellRenderMode: widget.shellRenderMode,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            headerActions: [
              VitHeaderActionItem(
                type: VitHeaderActionType.settings,
                onPressed: () =>
                    setState(() => _notice = 'Alert settings opened'),
              ),
            ],
            children: [
              VitTradeSection(
                title: 'Alert',
                child: _CriticalAlert(summary: snapshot.summary),
              ),
              VitTradeComplianceSection(
                title: 'Slippage status',
                statusPill: VitStatusPill(
                  label: '${snapshot.summary.critical} critical',
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Avg slippage',
                    value:
                        '${snapshot.summary.avgSlippage.toStringAsFixed(2)} bps',
                  ),
                  VitTradeComplianceItem(
                    label: 'Events',
                    value: '${snapshot.events.length} tracked',
                  ),
                ],
              ),
              VitTradeSection(
                title: 'Monitoring',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      density: VitDensity.compact,
                      title: 'Slippage risk review',
                      message:
                          'Review critical events, average slippage, provider routing, alert thresholds, fee impact, and next steps before changing copy execution settings.',
                      contractId: 'SC-098 slippage monitoring review',
                    ),
                    _StatsGrid(summary: snapshot.summary),
                    _Tabs(
                      activeId: _tab,
                      summary: snapshot.summary,
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                    if (_tab == 'realtime')
                      _RealtimeTab(events: snapshot.events)
                    else if (_tab == 'providers')
                      _ProvidersTab(providers: snapshot.providers)
                    else if (_tab == 'history')
                      _HistoryTab(history: snapshot.history)
                    else
                      const _AlertsTab(),
                  ],
                ),
              ),
            ],
          ),
          if (_notice != null)
            _NoticePanel(
              text: _notice!,
              onClose: () => setState(() => _notice = null),
            ),
        ],
      ),
    );
  }
}
