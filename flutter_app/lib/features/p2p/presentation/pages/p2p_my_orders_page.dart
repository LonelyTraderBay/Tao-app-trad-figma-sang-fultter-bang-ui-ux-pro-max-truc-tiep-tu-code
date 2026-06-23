import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_my_orders_page_sections.dart';
part '../widgets/p2p_my_orders_page_common.dart';

const double _p2pMyOrdersVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pMyOrdersNativeNavClearance =
    _p2pMyOrdersVisualNavClearance - AppSpacing.x4;
const double _p2pMyOrdersVisualClearance = AppSpacing.x3;
const double _p2pMyOrdersNativeClearance = AppSpacing.x2;
const double _p2pMyOrdersSectionGap = AppSpacing.x3;
const double _p2pMyOrdersTightGap = AppSpacing.x2;
const double _p2pMyOrdersSortHeight = AppSpacing.buttonCompact;
const double _p2pMyOrdersDividerHeight = AppSpacing.dividerHairline;
const EdgeInsets _p2pMyOrdersScrollPadding = EdgeInsets.fromLTRB(
  AppSpacing.contentPad,
  AppSpacing.x3,
  AppSpacing.contentPad,
  0,
);
const EdgeInsets _p2pMyOrdersStatPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.x2,
  vertical: AppSpacing.x2,
);
const EdgeInsets _p2pMyOrdersCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _p2pMyOrdersCompactPadding = EdgeInsets.all(AppSpacing.x2);
const EdgeInsets _p2pMyOrdersLargePadding = EdgeInsets.all(AppSpacing.x4);
const EdgeInsets _p2pMyOrdersChipPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.x2,
  vertical: AppSpacing.x1,
);

enum _OrdersSort { date, amount }

class P2PMyOrdersPage extends ConsumerStatefulWidget {
  const P2PMyOrdersPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc281_p2p_my_orders_content');
  static const dashboardKey = Key('sc281_p2p_my_orders_dashboard');
  static const statsKey = Key('sc281_p2p_my_orders_stats');
  static const searchKey = Key('sc281_p2p_my_orders_search');
  static const sortKey = Key('sc281_p2p_my_orders_sort');
  static const emptyKey = Key('sc281_p2p_my_orders_empty');

  static Key tabKey(String id) => Key('sc281_p2p_my_orders_tab_$id');
  static Key orderKey(String id) => Key('sc281_p2p_my_orders_order_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PMyOrdersPage> createState() => _P2PMyOrdersPageState();
}

class _P2PMyOrdersPageState extends ConsumerState<P2PMyOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  late String _tab;
  String _query = '';
  _OrdersSort _sort = _OrdersSort.date;
  bool _initialized = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pMyOrdersProvider);
    _ensureState(snapshot);
    final orders = _filteredOrders(snapshot.orders);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pMyOrdersVisualNavClearance + _p2pMyOrdersVisualClearance
            : _p2pMyOrdersNativeNavClearance + _p2pMyOrdersNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-281 P2PMyOrdersPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
            actions: [
              VitHeaderActionItem(
                key: P2PMyOrdersPage.dashboardKey,
                type: VitHeaderActionType.analytics,
                tooltip: 'P2P Dashboard',
                onPressed: () => context.go(snapshot.dashboardRoute),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: P2PMyOrdersPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: _p2pMyOrdersScrollPadding.copyWith(
                      bottom: scrollEndPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _StatsRow(snapshot: snapshot),
                        const SizedBox(height: _p2pMyOrdersSectionGap),
                        _OrderTabs(
                          snapshot: snapshot,
                          active: _tab,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() => _tab = value);
                          },
                        ),
                        const SizedBox(height: _p2pMyOrdersSectionGap),
                        _SearchSortRow(
                          hint: snapshot.searchHint,
                          controller: _searchController,
                          sort: _sort,
                          onQueryChanged: (value) =>
                              setState(() => _query = value),
                          onSort: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _sort = _sort == _OrdersSort.date
                                  ? _OrdersSort.amount
                                  : _OrdersSort.date;
                            });
                          },
                        ),
                        const SizedBox(height: _p2pMyOrdersSectionGap),
                        if (orders.isEmpty)
                          _EmptyOrders(snapshot: snapshot, activeTab: _tab)
                        else
                          for (final order in orders) ...[
                            _OrderCard(
                              order: order,
                              onTap: () => _openOrder(context, order),
                            ),
                            const SizedBox(height: _p2pMyOrdersTightGap),
                          ],
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: _p2pMyOrdersCompactPadding,
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'P2P order list review',
                            message:
                                'Pending, completed and disputed orders keep status, amount, merchant, detail route and next settlement step visible before navigation.',
                            contractId: 'p2p-my-orders-review',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ensureState(P2PMyOrdersSnapshot snapshot) {
    if (_initialized) return;
    _tab = snapshot.defaultTab;
    _initialized = true;
  }

  List<P2PMyOrderDraft> _filteredOrders(List<P2PMyOrderDraft> orders) {
    final query = _query.trim().toLowerCase();
    final filtered = orders.where((order) {
      final inTab = switch (_tab) {
        'completed' =>
          order.status == 'released' || order.status == 'cancelled',
        'disputed' => order.status == 'disputed',
        _ => order.status == 'pending_payment' || order.status == 'paid',
      };
      if (!inTab) return false;
      if (query.isEmpty) return true;
      return order.id.toLowerCase().contains(query) ||
          order.orderNumber.toLowerCase().contains(query) ||
          order.merchant.toLowerCase().contains(query);
    }).toList();
    filtered.sort((a, b) {
      if (_sort == _OrdersSort.amount) return b.total.compareTo(a.total);
      return b.createdAt.compareTo(a.createdAt);
    });
    return filtered;
  }

  void _openOrder(BuildContext context, P2PMyOrderDraft order) {
    HapticFeedback.selectionClick();
    if (order.status == 'disputed') {
      context.go(AppRoutePaths.p2pDisputeDetail(order.id));
      return;
    }
    context.go(AppRoutePaths.p2pOrder(order.id));
  }
}
