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
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/advanced_trading_demo_page_sections.dart';
part '../widgets/advanced_trading_demo_page_common.dart';

const _advancedGreen = AppColors.buy;
const _advancedRed = AppColors.sell;
const _advancedPrimary = AppColors.primary;

class AdvancedTradingDemoPage extends ConsumerStatefulWidget {
  const AdvancedTradingDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc088_advanced_trading_demo_content');
  static Key tabKey(String id) => Key('sc088_advanced_tab_$id');
  static Key modeKey(String id) => Key('sc088_position_mode_$id');
  static Key actionKey(String id) => Key('sc088_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedTradingDemoPage> createState() =>
      _AdvancedTradingDemoPageState();
}

class _AdvancedTradingDemoPageState
    extends ConsumerState<AdvancedTradingDemoPage> {
  String _tab = 'position';
  String _positionMode = 'one-way';
  String? _activeSheetTitle;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getAdvancedTradingDemo();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 28);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-088 AdvancedTradingDemoPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Advanced Trading',
                subtitle: 'Position & Order Controls',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.tradeMargin),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: AdvancedTradingDemoPage.contentKey,
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.compact,
                        customGap: 16,
                        children: [
                          _PositionModeCard(
                            activeMode: _positionMode,
                            onChanged: (mode) =>
                                setState(() => _positionMode = mode),
                          ),
                          _UnderlineTabs(
                            activeId: _tab,
                            onChanged: (id) => setState(() => _tab = id),
                          ),
                          if (_tab == 'position')
                            _PositionTab(
                              snapshot: snapshot,
                              onAction: (action) => setState(
                                () => _activeSheetTitle = action.label,
                              ),
                            )
                          else if (_tab == 'orders')
                            _OrdersTab(snapshot: snapshot)
                          else
                            _AnalyticsTab(snapshot: snapshot),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Demo execution boundary',
                            message:
                                'Advanced order controls are shown in demo mode. Live execution requires preview, margin, fee, and liquidation review.',
                            contractId: 'SC-088',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_activeSheetTitle != null)
              _DemoSheet(
                title: _activeSheetTitle!,
                onClose: () => setState(() => _activeSheetTitle = null),
              ),
          ],
        ),
      ),
    );
  }
}
