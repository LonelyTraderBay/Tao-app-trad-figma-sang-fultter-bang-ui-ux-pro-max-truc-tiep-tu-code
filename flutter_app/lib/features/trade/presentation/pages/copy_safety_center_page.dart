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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/copy_safety_overview.dart';
part '../widgets/copy_safety_metrics_tools.dart';
part '../widgets/copy_safety_enforcement_common.dart';

const _safetyPrimary = AppColors.primary;
const _safetyWarningBorder = AppColors.warningBorderStrong;
const _safetySpace = AppSpacing.x2;
const _safetyCardSpace = AppSpacing.x3;
const _safetyHeroMinHeight = 84.0;
const _safetyTabsHeight = 60.0;
const _safetyHeroLineHeight = 1.08;
const _safetyBodyLineHeight = 1.22;
const _safetyReadableLineHeight = 1.28;
const _safetyTierMinHeight = 0.0;
const _safetyActionIconSize = 20.0;
const _safetySheetButtonHeight = 44.0;

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
    final scrollEndClearance = tradeScrollBottomInset(
        context,
        shellRenderMode: mode,
      );

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
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollEndClearance,
                      ),
                      child: VitPageContent(
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: [
                          _HeroBanner(snapshot: snapshot),
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Review copy safety controls',
                            message:
                                'Check verification, trust metrics, reporting tools, and emergency stop before allowing copied trades.',
                            contractId: 'Safety tab: ${_activeTabId!}',
                            density: VitDensity.compact,
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
