import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/advanced_trading_demo_page_sections.dart';
part '../widgets/advanced_trading_demo_page_common.dart';

const _advancedGreen = AppColors.buy;
const _advancedRed = AppColors.sell;
const _advancedPrimary = AppColors.primary;
const double _advancedSheetClearance = 72;
const double _advancedSpace = AppSpacing.x2;
const double _advancedTinySpace = AppSpacing.x1;
const double _advancedActionMinExtent = 44;
const double _advancedSheetActionExtent = 44;
const double _advancedLineBody = 1.24;

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
    final scrollEndClearance = tradeScrollBottomInset(
      context,
      shellRenderMode: mode,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-088 AdvancedTradingDemoPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Giao dịch nâng cao',
                subtitle: 'Vị thế & lệnh',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.tradeMargin),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: AdvancedTradingDemoPage.contentKey,
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollEndClearance,
                      ),
                      child: VitPageContent(
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: tradeShellWithProductTabs(
                          context: context,
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
                            title: 'Giới hạn demo thực thi',
                            message:
                                'Điều khiển lệnh nâng cao chỉ hiển thị ở chế độ demo. Thực thi thật cần xem trước, ký quỹ, phí và rủi ro thanh lý.',
                            contractId: 'SC-088',
                            density: VitDensity.compact,
                          ),
                          ],
                        ),
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
