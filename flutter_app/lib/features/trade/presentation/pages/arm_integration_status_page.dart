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

part '../widgets/arm_integration_providers.dart';
part '../widgets/arm_integration_sla_actions.dart';
part '../widgets/arm_integration_common_painter.dart';

const _armBackground = AppColors.bg;
const _armPanel2 = AppColors.surface2;
const _armBorder = AppColors.borderSolid;
const _armGreen = AppColors.buy;
const _armAmber = AppColors.caution;
const _armRed = AppColors.sell;
const _armPrimary = AppColors.primary;

class ArmIntegrationStatusPage extends ConsumerStatefulWidget {
  const ArmIntegrationStatusPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc095_arm_integration_content');
  static Key connectionKey(String id) => Key('sc095_arm_connection_$id');
  static Key testKey(String id) => Key('sc095_arm_test_$id');
  static Key actionKey(String id) => Key('sc095_arm_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArmIntegrationStatusPage> createState() =>
      _ArmIntegrationStatusPageState();
}

class _ArmIntegrationStatusPageState
    extends ConsumerState<ArmIntegrationStatusPage> {
  String? _testingId;

  void _testConnection(String id) {
    setState(() => _testingId = id);
    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (mounted && _testingId == id) {
        setState(() => _testingId = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getArmIntegrationStatus();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-095 ARMIntegrationStatusPage',
      child: Material(
        color: _armBackground,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'ARM Integration',
            subtitle: 'Connection Health · Monitoring',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.tradeCopyRegulatoryReportsDashboard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ArmIntegrationStatusPage.contentKey,
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    customGap: 14,
                    fullBleed: true,
                    children: [
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review ARM integration health',
                        message:
                            'Confirm provider failover, latency limits, reporting queue impact, and next steps before retrying submissions.',
                      ),
                      const _OperationalAlert(),
                      const _SectionLabel('ARM Providers'),
                      for (final connection in snapshot.connections)
                        _ArmProviderCard(
                          connection: connection,
                          isTesting: _testingId == connection.id,
                          onTest: () => _testConnection(connection.id),
                        ),
                      const _SectionLabel('Latency Monitoring (Last 15 min)'),
                      _LatencyCard(points: snapshot.latencyHistory),
                      const _SectionLabel('SLA Compliance'),
                      _SlaCard(sla: snapshot.sla),
                      _QuickActions(
                        onQueue: () => context.go(
                          AppRoutePaths.tradeCopyTransactionReporting,
                        ),
                        onDashboard: () => context.go(
                          AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
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
