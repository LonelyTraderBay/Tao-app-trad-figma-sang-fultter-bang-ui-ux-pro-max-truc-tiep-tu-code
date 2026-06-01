import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';

part '../widgets/launchpad_limit_orders_header_widgets.dart';
part '../widgets/launchpad_limit_orders_active_widgets.dart';
part '../widgets/launchpad_limit_orders_history_widgets.dart';
part '../widgets/launchpad_limit_orders_create_widgets.dart';
part '../widgets/launchpad_limit_orders_create_fields.dart';
part '../widgets/launchpad_limit_orders_preview_widgets.dart';
part '../widgets/launchpad_limit_orders_formatters.dart';

enum _LimitOrderTab { active, history, create }

class LaunchpadLimitOrdersPage extends ConsumerStatefulWidget {
  const LaunchpadLimitOrdersPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc315_launchpad_limit_orders_content');
  static const tabsKey = Key('sc315_launchpad_limit_orders_tabs');
  static const statsKey = Key('sc315_launchpad_limit_orders_stats');
  static const activeListKey = Key('sc315_launchpad_limit_orders_active_list');
  static const historyKey = Key('sc315_launchpad_limit_orders_history');
  static const createKey = Key('sc315_launchpad_limit_orders_create');
  static const headerCreateKey = Key(
    'sc315_launchpad_limit_orders_header_create',
  );
  static const tokenFieldKey = Key('sc315_launchpad_limit_orders_token_field');
  static const targetFieldKey = Key(
    'sc315_launchpad_limit_orders_target_field',
  );
  static const amountFieldKey = Key(
    'sc315_launchpad_limit_orders_amount_field',
  );
  static const partialFillKey = Key(
    'sc315_launchpad_limit_orders_partial_fill',
  );
  static const previewKey = Key('sc315_launchpad_limit_orders_preview');
  static const ctaKey = Key('sc315_launchpad_limit_orders_cta');

  static Key orderKey(String id) => Key('sc315_launchpad_limit_order_$id');
  static Key expiryKey(String days) =>
      Key('sc315_launchpad_limit_orders_expiry_$days');
  static Key sideKey(LaunchpadLimitOrderSide side) =>
      Key('sc315_launchpad_limit_orders_side_${side.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadLimitOrdersPage> createState() =>
      _LaunchpadLimitOrdersPageState();
}

class _LaunchpadLimitOrdersPageState
    extends ConsumerState<LaunchpadLimitOrdersPage> {
  late final TextEditingController _tokenController;
  late final TextEditingController _targetPriceController;
  late final TextEditingController _amountController;
  var _activeTab = _LimitOrderTab.active;
  var _orderSide = LaunchpadLimitOrderSide.buy;
  var _expiryDays = '7';
  var _partialFill = true;
  String? _submissionMessage;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: 'ARB');
    _targetPriceController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _targetPriceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadControllerProvider).getLimitOrders();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final showCta =
        _activeTab == _LimitOrderTab.create &&
        _targetPriceController.text.trim().isNotEmpty &&
        _amountController.text.trim().isNotEmpty;
    final ctaInset = showCta ? 118.0 : 0.0;
    final bottomInset = navInset + safeBottom + AppSpacing.x6 + ctaInset;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-315 LaunchpadLimitOrdersPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  onBack: () => context.go(snapshot.backRoute),
                  trailing: _HeaderCreateButton(
                    onTap: () => setState(() {
                      _activeTab = _LimitOrderTab.create;
                    }),
                  ),
                ),
                _Tabs(
                  activeTab: _activeTab,
                  onChanged: (tab) => setState(() => _activeTab = tab),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadLimitOrdersPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
                        if (_activeTab == _LimitOrderTab.active) ...[
                          _StatsCard(snapshot: snapshot),
                          _ActiveOrdersSection(orders: snapshot.activeOrders),
                        ] else if (_activeTab == _LimitOrderTab.history) ...[
                          _HistorySection(orders: snapshot.historyOrders),
                        ] else ...[
                          _CreateOrderSection(
                            orderSide: _orderSide,
                            tokenController: _tokenController,
                            targetPriceController: _targetPriceController,
                            amountController: _amountController,
                            expiryDays: _expiryDays,
                            partialFill: _partialFill,
                            submissionMessage: _submissionMessage,
                            onSideChanged: (side) =>
                                setState(() => _orderSide = side),
                            onExpiryChanged: (days) =>
                                setState(() => _expiryDays = days),
                            onPartialFillChanged: (value) =>
                                setState(() => _partialFill = value),
                            onInputChanged: () => setState(() {
                              _submissionMessage = null;
                            }),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (showCta)
              Positioned(
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: VitStickyFooter(
                  backgroundColor: AppColors.surface.withValues(alpha: .94),
                  child: VitCtaButton(
                    key: LaunchpadLimitOrdersPage.ctaKey,
                    onPressed: _submitOrder,
                    leading: const Icon(Icons.add_rounded),
                    child: const Text('Tao Limit Order'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submitOrder() {
    final side = _orderSide == LaunchpadLimitOrderSide.buy ? 'BUY' : 'SELL';
    setState(() {
      _submissionMessage =
          'Limit order queued: $side ${_amountController.text.trim()} ${_tokenController.text.trim()} @ \$${_targetPriceController.text.trim()}';
    });
  }
}
