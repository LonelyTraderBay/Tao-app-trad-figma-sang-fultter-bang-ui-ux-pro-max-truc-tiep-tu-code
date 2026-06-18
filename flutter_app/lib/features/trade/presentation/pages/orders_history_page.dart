import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

import '../widgets/trade_body_review_widgets.dart';

part '../widgets/orders_history_page_sections.dart';
part '../widgets/orders_history_page_common.dart';

const _tradePrimary = AppColors.primary;

class OrdersHistoryPage extends ConsumerStatefulWidget {
  const OrdersHistoryPage({super.key, this.shellRenderMode});

  static const openTabKey = Key('sc050_open_tab');
  static const historyTabKey = Key('sc050_history_tab');
  static const cancelFirstOrderKey = Key('sc050_cancel_first_order');
  static Key filterKey(String id) => Key('sc050_filter_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends ConsumerState<OrdersHistoryPage> {
  String _activeTab = 'open';
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeOrdersHistoryControllerProvider)
        .state
        .snapshot;
    final orders = _visibleOrders(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? AppSpacing.tradeHistoryBottomInsetVisual
            : AppSpacing.tradeHistoryBottomInsetNative);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-050 OrdersHistoryPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Lịch sử lệnh',
            subtitle: 'Lệnh · Trade',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.trade),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.zeroInsets.copyWith(bottom: bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _OrderTopTabs(
                        active: _activeTab,
                        openCount: snapshot.openOrders.length,
                        historyCount: snapshot.historyOrders.length,
                        onChanged: (tab) => setState(() => _activeTab = tab),
                      ),
                      _FilterRow(
                        active: _filter,
                        onChanged: (filter) => setState(() => _filter = filter),
                      ),
                      if (orders.isEmpty)
                        _EmptyState(activeTab: _activeTab)
                      else
                        for (var i = 0; i < orders.length; i++)
                          _OrderHistoryTile(
                            order: orders[i],
                            actionKey: i == 0
                                ? OrdersHistoryPage.cancelFirstOrderKey
                                : null,
                            onCancel: () => _cancelOrder(orders[i].id),
                          ),
                      const TradeBodyReviewSection(
                        title: 'Orders history body review',
                        message: 'Orders history body reviewed',
                        detail:
                            'Open/history tabs, filters, empty, cancel, snackbar, and result states stay visible.',
                        primary:
                            'Tabs and filters stay above order rows for recovery from empty states.',
                        secondary:
                            'Cancel action keeps selected order context visible.',
                        tertiary:
                            'History rows remain separated from live position management.',
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

  List<TradeHistoryOrder> _visibleOrders(TradeOrdersHistorySnapshot snapshot) {
    final source = _activeTab == 'open'
        ? snapshot.openOrders
        : snapshot.historyOrders;
    if (_filter == 'buy') {
      return source
          .where((order) => order.side == TradeOrderSide.buy)
          .toList(growable: false);
    }
    if (_filter == 'sell') {
      return source
          .where((order) => order.side == TradeOrderSide.sell)
          .toList(growable: false);
    }
    return source;
  }

  void _cancelOrder(String orderId) {
    final result = ref
        .read(tradeOrdersHistoryControllerProvider)
        .cancelOrder(orderId);
    if (Scaffold.maybeOf(context) != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã hủy ${result.orderId}')));
    }
  }
}
