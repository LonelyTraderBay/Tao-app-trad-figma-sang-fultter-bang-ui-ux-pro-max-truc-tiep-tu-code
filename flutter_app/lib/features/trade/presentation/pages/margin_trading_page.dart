import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part 'margin_trading_page_part_01.dart';
part 'margin_trading_page_part_02.dart';
part 'margin_trading_page_part_03.dart';
part 'margin_trading_page_part_04.dart';
part '../widgets/margin_trading_price_pair.dart';
part '../widgets/margin_trading_order_controls.dart';
part '../widgets/margin_trading_order_inputs.dart';
part '../widgets/margin_trading_order_summary.dart';
part '../widgets/margin_trading_risk_cards.dart';
part '../widgets/margin_trading_positions_orders.dart';

const _marginBackground = AppColors.bg;
const _marginCard = AppColors.surface;
const _marginPanel = AppColors.surface2;
const _marginHero = AppColors.surface;
const _marginHeroBorder = AppColors.primary20;
const _marginPrimary = AppColors.primary;
const _marginGreen = AppColors.buy;
const _marginAmber = AppColors.caution;
const _marginRed = AppColors.sell;

class MarginTradingPage extends ConsumerStatefulWidget {
  const MarginTradingPage({
    super.key,
    this.pairId = 'btcusdt',
    this.pairRouteVariant = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc085_margin_trading_content');
  static Key modeKey(String id) => Key('sc085_mode_$id');
  static Key tabKey(String id) => Key('sc085_tab_$id');
  static Key sideKey(String id) => Key('sc085_side_$id');
  static Key orderTypeKey(String id) => Key('sc085_order_type_$id');
  static const leverageKey = Key('sc085_leverage');
  static const maxAmountKey = Key('sc085_max_amount');
  static const submitKey = Key('sc085_submit');

  final String pairId;
  final bool pairRouteVariant;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarginTradingPage> createState() => _MarginTradingPageState();
}

class _MarginTradingPageState extends ConsumerState<MarginTradingPage> {
  late String _mode = 'cross';
  late String _tab = 'trade';
  late String _side = 'long';
  late int _leverage = 5;
  late String _orderType = 'limit';
  String _amount = '0.00';
  bool _showLeverageSheet = false;
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      tradeMarginControllerProvider((
        pairId: widget.pairId,
        pairRouteVariant: widget.pairRouteVariant,
      )),
    );
    final snapshot = controller.state.snapshot;
    final modePositions = controller.positionsForMode(_mode);
    final totalPnl = controller.totalPnlForMode(_mode);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.pairRouteVariant
          ? 'SC-086 MarginTradingPage'
          : 'SC-085 MarginTradingPage',
      child: Material(
        color: _marginBackground,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Margin Trading',
                subtitle: 'Ký quỹ · Giao dịch',
                showBack: true,
                onBack: () => goBackOrFallback(
                  context,
                  fallbackPath: AppRoutePaths.trade,
                  mode: BackNavigationMode.historyThenFallback,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      key: MarginTradingPage.contentKey,
                      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        customGap: 0,
                        children: [
                          _ClientCategoryCard(
                            category: snapshot.clientCategory,
                          ),
                          const SizedBox(height: 12),
                          const VitCard(
                            variant: VitCardVariant.inner,
                            padding: EdgeInsets.all(12),
                            child: VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Margin order review required',
                              message:
                                  'Leverage, liquidation risk, fee estimate, limit, preview and confirmation are reviewed before order submission.',
                              contractId: 'margin-trading-review',
                            ),
                          ),
                          const SizedBox(height: 18),
                          _SegmentedTabs(
                            tabs: snapshot.modeTabs,
                            activeId: _mode,
                            activeColor: _marginPrimary,
                            height: 50,
                            onChanged: (id) => setState(() => _mode = id),
                            keyBuilder: MarginTradingPage.modeKey,
                          ),
                          const SizedBox(height: 16),
                          _AccountHero(
                            account: snapshot.account,
                            totalPnl: totalPnl,
                          ),
                          const SizedBox(height: 18),
                          _SegmentedTabs(
                            tabs: [
                              for (final tab in snapshot.contentTabs)
                                TradeMarginTab(
                                  id: tab.id,
                                  label: tab.id == 'positions'
                                      ? '${tab.label} (${modePositions.length})'
                                      : tab.label,
                                ),
                            ],
                            activeId: _tab,
                            activeColor: _marginPrimary,
                            height: 46,
                            onChanged: (id) => setState(() => _tab = id),
                            keyBuilder: MarginTradingPage.tabKey,
                          ),
                          const SizedBox(height: 16),
                          VitPageSection(
                            customGap: 0,
                            children: [
                              if (_tab == 'trade')
                                _TradeTab(
                                  snapshot: snapshot,
                                  side: _side,
                                  leverage: _leverage,
                                  orderType: _orderType,
                                  amount: _amount,
                                  showLeverageSheet: _showLeverageSheet,
                                  onSideChanged: (side) =>
                                      setState(() => _side = side),
                                  onLeverageToggle: () => setState(
                                    () => _showLeverageSheet =
                                        !_showLeverageSheet,
                                  ),
                                  onLeverageChanged: (leverage) => setState(() {
                                    _leverage = leverage;
                                    _showLeverageSheet = false;
                                  }),
                                  onOrderTypeChanged: (type) =>
                                      setState(() => _orderType = type),
                                  onMaxAmount: () => setState(() {
                                    _amount = controller.maxAmountFor(
                                      leverage: _leverage,
                                    );
                                  }),
                                  onNotice: (notice) =>
                                      setState(() => _notice = notice),
                                )
                              else if (_tab == 'positions')
                                _PositionsTab(positions: modePositions)
                              else
                                const _OrdersTab(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_notice != null)
              _NoticeSheet(
                text: _notice!,
                onClose: () => setState(() => _notice = null),
              ),
          ],
        ),
      ),
    );
  }
}
