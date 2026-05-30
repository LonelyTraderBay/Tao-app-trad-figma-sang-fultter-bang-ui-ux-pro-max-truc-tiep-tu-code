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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-281 P2PMyOrdersPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
              trailing: VitIconButton(
                key: P2PMyOrdersPage.dashboardKey,
                icon: Icons.bar_chart_rounded,
                tooltip: 'P2P Dashboard',
                variant: VitIconButtonVariant.primary,
                onPressed: () => context.go(snapshot.dashboardRoute),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PMyOrdersPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatsRow(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _OrderTabs(
                        snapshot: snapshot,
                        active: _tab,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _tab = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
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
                      const SizedBox(height: AppSpacing.x5),
                      if (orders.isEmpty)
                        _EmptyOrders(snapshot: snapshot, activeTab: _tab)
                      else
                        for (final order in orders) ...[
                          _OrderCard(
                            order: order,
                            onTap: () => _openOrder(context, order),
                          ),
                          const SizedBox(height: AppSpacing.x3),
                        ],
                    ],
                  ),
                ),
              ),
            ),
          ],
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

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot});

  final P2PMyOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatMeta('Tổng đơn', '${snapshot.orders.length}', AppColors.text1),
      _StatMeta('Hoàn thành', '${snapshot.completedCount}', AppColors.buy),
      _StatMeta(
        'Tổng KL',
        _formatCompactVnd(snapshot.completedVolume),
        AppModuleAccents.p2p,
      ),
    ];
    return Row(
      key: P2PMyOrdersPage.statsKey,
      children: [
        for (var index = 0; index < stats.length; index++) ...[
          Expanded(child: _StatCard(meta: stats[index])),
          if (index != stats.length - 1) const SizedBox(width: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.meta});

  final _StatMeta meta;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            meta.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(color: meta.color),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            meta.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _OrderTabs extends StatelessWidget {
  const _OrderTabs({
    required this.snapshot,
    required this.active,
    required this.onChanged,
  });

  final P2PMyOrdersSnapshot snapshot;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in snapshot.tabs)
          VitTabItem(key: tab.id, label: tab.label),
      ],
    );
  }
}

class _SearchSortRow extends StatelessWidget {
  const _SearchSortRow({
    required this.hint,
    required this.controller,
    required this.sort,
    required this.onQueryChanged,
    required this.onSort,
  });

  final String hint;
  final TextEditingController controller;
  final _OrdersSort sort;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSearchBar(
            key: P2PMyOrdersPage.searchKey,
            controller: controller,
            placeholder: hint,
            variant: VitSearchBarVariant.compact,
            onChanged: onQueryChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Material(
          key: P2PMyOrdersPage.sortKey,
          color: AppColors.surface2,
          borderRadius: AppRadii.inputRadius,
          child: InkWell(
            onTap: onSort,
            borderRadius: AppRadii.inputRadius,
            child: Container(
              height: AppSpacing.buttonCompact + AppSpacing.x2 + AppSpacing.x2,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderSolid),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    color: AppColors.text2,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    sort == _OrdersSort.date ? 'Ngày' : 'Số tiền',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final P2PMyOrderDraft order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = _statusMeta(order.status);
    final isBuy = order.type == 'buy';
    final typeColor = isBuy ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: P2PMyOrdersPage.orderKey(order.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _TypePill(label: isBuy ? 'MUA' : 'BÁN', color: typeColor),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '#${order.id.toUpperCase()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Icon(status.icon, color: status.color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x1),
              Text(
                status.label,
                style: AppTextStyles.micro.copyWith(
                  color: status.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _OrderMetric(
                  label: 'Số lượng',
                  value: '${_formatCrypto(order.amount)} ${order.asset}',
                ),
              ),
              Expanded(
                child: _OrderMetric(
                  label: 'Giá',
                  value: _formatVnd(order.price),
                ),
              ),
              Expanded(
                child: _OrderMetric(
                  label: 'Tổng tiền',
                  value: _formatVnd(order.total),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              CircleAvatar(
                radius: AppSpacing.x4,
                backgroundColor: AppModuleAccents.p2p,
                child: Text(
                  order.merchant.characters.first.toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  order.merchant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Text(
                _formatDateTime(order.createdAt),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: AppSpacing.x1),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderMetric extends StatelessWidget {
  const _OrderMetric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.snapshot, required this.activeTab});

  final P2PMyOrdersSnapshot snapshot;
  final String activeTab;

  @override
  Widget build(BuildContext context) {
    final message = switch (activeTab) {
      'disputed' => 'Không có đơn tranh chấp',
      'completed' => 'Chưa có đơn hoàn tất',
      _ => 'Bạn không có đơn đang xử lý',
    };
    return VitCard(
      key: P2PMyOrdersPage.emptyKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(snapshot.emptyTitle, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x1),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            variant: VitCtaButtonVariant.primary,
            onPressed: () => context.go(snapshot.parentRoute),
            child: const Text('Tạo giao dịch P2P'),
          ),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

final class _StatMeta {
  const _StatMeta(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;
}

final class _StatusMeta {
  const _StatusMeta(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

_StatusMeta _statusMeta(String status) {
  return switch (status) {
    'pending_payment' => const _StatusMeta(
      'Chờ thanh toán',
      AppModuleAccents.p2p,
      Icons.schedule_rounded,
    ),
    'paid' => const _StatusMeta(
      'Đã thanh toán',
      AppColors.primary,
      Icons.schedule_rounded,
    ),
    'released' => const _StatusMeta(
      'Hoàn tất',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    'cancelled' => const _StatusMeta(
      'Đã hủy',
      AppColors.sell,
      Icons.cancel_outlined,
    ),
    'disputed' => const _StatusMeta(
      'Tranh chấp',
      AppColors.sell,
      Icons.report_problem_outlined,
    ),
    _ => const _StatusMeta('Hết hạn', AppColors.text3, Icons.schedule_rounded),
  };
}

String _formatCrypto(double value) => value.toStringAsFixed(4);

String _formatVnd(num value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write('.');
    buffer.write(text[i]);
  }
  return buffer.toString();
}

String _formatCompactVnd(double value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(2)}M';
  }
  return _formatVnd(value);
}

String _formatDateTime(String value) {
  if (value.length < 16) return value;
  return '${value.substring(5, 10)} ${value.substring(11, 16)}';
}
