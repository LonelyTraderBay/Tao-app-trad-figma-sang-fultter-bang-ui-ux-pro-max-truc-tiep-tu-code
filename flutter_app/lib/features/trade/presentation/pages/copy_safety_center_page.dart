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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/copy_safety_overview.dart';
part '../widgets/copy_safety_metrics_tools.dart';
part '../widgets/copy_safety_enforcement_common.dart';

const _safetyPrimary = AppColors.primary;
const _safetyTabsBackground = AppColors.surface;
const _safetyWarningBorder = AppColors.warningBorderStrong;

class CopySafetyCenterPage extends ConsumerStatefulWidget {
  const CopySafetyCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc083_copy_safety_center_content');
  static Key tabKey(String id) => Key('sc083_tab_$id');
  static Key metricKey(String name) => Key('sc083_metric_$name');
  static Key toolKey(String id) => Key('sc083_tool_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopySafetyCenterPage> createState() =>
      _CopySafetyCenterPageState();
}

class _CopySafetyCenterPageState extends ConsumerState<CopySafetyCenterPage> {
  String? _activeTabId;
  String? _expandedMetric;
  bool _showEmergencyPanel = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getCopySafetyCenter();
    _activeTabId ??= snapshot.defaultTabId;

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-083 CopySafetyCenterPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Safety Center',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: CopySafetyCenterPage.contentKey,
                      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        customGap: 24,
                        fullBleed: true,
                        children: [
                          _HeroBanner(snapshot: snapshot),
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Review copy safety controls',
                            message:
                                'Check verification, trust metrics, reporting tools, and emergency stop before allowing copied trades.',
                            contractId: 'Safety tab: ${_activeTabId!}',
                          ),
                          _SafetyTabs(
                            tabs: snapshot.tabs,
                            activeId: _activeTabId!,
                            onChanged: (id) =>
                                setState(() => _activeTabId = id),
                          ),
                          _SafetyTabBody(
                            activeTabId: _activeTabId!,
                            snapshot: snapshot,
                            expandedMetric: _expandedMetric,
                            onMetricToggle: (name) => setState(() {
                              _expandedMetric = _expandedMetric == name
                                  ? null
                                  : name;
                            }),
                            onEmergency: () =>
                                setState(() => _showEmergencyPanel = true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showEmergencyPanel)
              _EmergencyPanel(
                onClose: () => setState(() => _showEmergencyPanel = false),
              ),
          ],
        ),
      ),
    );
  }
}
