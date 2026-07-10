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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

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

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          VitTradeHubScaffold(
            title: 'Safety Center',
            semanticLabel: 'SC-083 CopySafetyCenterPage',
            contentKey: CopySafetyCenterPage.contentKey,
            shellRenderMode: widget.shellRenderMode,
            useCopyTradingInset: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            children: [
              VitTradeSection(
                title: 'Overview',
                child: _HeroBanner(snapshot: snapshot),
              ),
              VitTradeSection(
                title: 'Controls',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SafetyTabs(
                      tabs: snapshot.tabs,
                      activeId: _activeTabId!,
                      onChanged: (id) => setState(() => _activeTabId = id),
                    ),
                    _SafetyTabBody(
                      activeTabId: _activeTabId!,
                      snapshot: snapshot,
                      expandedMetric: _expandedMetric,
                      onMetricToggle: (name) => setState(() {
                        _expandedMetric = _expandedMetric == name ? null : name;
                      }),
                      onEmergency: () =>
                          setState(() => _showEmergencyPanel = true),
                    ),
                  ],
                ),
              ),
              VitTradeComplianceSection(
                title: 'Safety review',
                statusPill: VitStatusPill(
                  label: 'Tab: ${_activeTabId!}',
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
                items: const [
                  VitTradeComplianceItem(
                    label: 'Scope',
                    value: 'Verification, trust metrics, reporting',
                  ),
                  VitTradeComplianceItem(
                    label: 'Action',
                    value: 'Review before allowing copied trades',
                  ),
                ],
              ),
            ],
          ),
          if (_showEmergencyPanel)
            _EmergencyPanel(
              onClose: () => setState(() => _showEmergencyPanel = false),
            ),
        ],
      ),
    );
  }
}
