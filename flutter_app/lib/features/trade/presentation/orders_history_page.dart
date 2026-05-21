import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _tradeBlue = Color(0xFF3B82F6);
const _fieldBg = Color(0xFF1D2435);

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
    final snapshot = ref.watch(tradeRepositoryProvider).getOrdersHistory();
    final orders = _visibleOrders(snapshot);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 42 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-050 OrdersHistoryPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Lịch sử lệnh',
              subtitle: 'Lệnh · Trade',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset),
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
                  ],
                ),
              ),
            ),
          ],
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
        .read(tradeRepositoryProvider)
        .submitOrderAction(orderId: orderId, action: 'cancel');
    if (Scaffold.maybeOf(context) != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã hủy ${result.orderId}')));
    }
  }
}

class _OrderTopTabs extends StatelessWidget {
  const _OrderTopTabs({
    required this.active,
    required this.openCount,
    required this.historyCount,
    required this.onChanged,
  });

  final String active;
  final int openCount;
  final int historyCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: _TopTabButton(
                key: OrdersHistoryPage.openTabKey,
                label: 'Lệnh mở',
                count: openCount,
                active: active == 'open',
                onTap: () => onChanged('open'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TopTabButton(
                key: OrdersHistoryPage.historyTabKey,
                label: 'Lịch sử',
                count: historyCount,
                active: active == 'history',
                onTap: () => onChanged('history'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopTabButton extends StatelessWidget {
  const _TopTabButton({
    super.key,
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _tradeBlue : _fieldBg,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? Colors.white : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: active
                    ? Colors.white.withValues(alpha: .18)
                    : AppColors.surface3,
                borderRadius: AppRadii.xsRadius,
              ),
              child: Text(
                '$count',
                style: AppTextStyles.micro.copyWith(
                  color: active ? Colors.white : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = const [
      ('all', 'Tất cả', _tradeBlue),
      ('buy', 'Mua', AppColors.buy),
      ('sell', 'Bán', AppColors.sell),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterChip(
              key: OrdersHistoryPage.filterKey(filter.$1),
              id: filter.$1,
              label: filter.$2,
              color: filter.$3,
              active: active == filter.$1,
              onTap: () => onChanged(filter.$1),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.id,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String id;
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final compactAll = id == 'all' && active;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.lgRadius,
      child: Container(
        height: 34,
        width: compactAll ? 61 : 58,
        padding: compactAll
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          borderRadius: AppRadii.lgRadius,
        ),
        child: compactAll
            ? const SizedBox.shrink()
            : Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? Colors.white : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
      ),
    );
  }
}

class _OrderHistoryTile extends StatelessWidget {
  const _OrderHistoryTile({
    required this.order,
    required this.onCancel,
    this.actionKey,
  });

  final TradeHistoryOrder order;
  final VoidCallback onCancel;
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    final status = _statusPresentation(order.status);
    final isBuy = order.side == TradeOrderSide.buy;
    final fillPercent = order.amount == 0 ? 0.0 : order.filled / order.amount;
    final actionable =
        order.status == TradeOrderStatus.open ||
        order.status == TradeOrderStatus.partial;

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          order.symbol,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _SmallBadge(
                        label: isBuy ? 'MUA' : 'BÁN',
                        color: isBuy ? AppColors.buy : AppColors.sell,
                      ),
                      const SizedBox(width: 6),
                      _TypeBadge(type: order.type),
                    ],
                  ),
                ),
                SizedBox(
                  width: 118,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(status.icon, color: status.color, size: 15),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          status.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: status.color,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoColumn(
                    label: 'Giá',
                    value: '\$${_formatMoney(order.price)}',
                  ),
                ),
                Expanded(
                  child: _InfoColumn(
                    label: 'Số lượng',
                    value: order.amount.toStringAsFixed(4),
                  ),
                ),
              ],
            ),
            if (order.status == TradeOrderStatus.partial || order.fee > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: order.status == TradeOrderStatus.partial
                        ? _InfoColumn(
                            label: 'Đã khớp',
                            value:
                                '${order.filled.toStringAsFixed(4)}  (${(fillPercent * 100).toStringAsFixed(0)}%)',
                            valueColor: AppColors.buy,
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: order.fee > 0
                        ? _InfoColumn(
                            label: 'Phí',
                            value: '\$${order.fee.toStringAsFixed(2)}',
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            _InfoColumn(label: 'Thời gian', value: order.createdAt),
            if (order.status == TradeOrderStatus.partial) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: AppRadii.xsRadius,
                child: LinearProgressIndicator(
                  value: fillPercent,
                  minHeight: 5,
                  color: AppColors.buy,
                  backgroundColor: const Color(0xFF33405F),
                ),
              ),
            ],
            if (actionable) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: OutlinedButton(
                  key: actionKey,
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.sell,
                    side: BorderSide(
                      color: AppColors.sell.withValues(alpha: .55),
                    ),
                    backgroundColor: AppColors.sell.withValues(alpha: .10),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.cardRadius,
                    ),
                  ),
                  child: Text(
                    'Hủy lệnh',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final TradeOrderType type;

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      TradeOrderType.market => '',
      TradeOrderType.limit => 'Limit',
      TradeOrderType.stop => 'Stop',
    };
    return Container(
      constraints: const BoxConstraints(minWidth: 18),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontFamily: 'monospace',
            fontWeight: AppTextStyles.bold,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.activeTab});

  final String activeTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 84),
      child: Column(
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: AppColors.borderSolid,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            activeTab == 'open'
                ? 'Không có lệnh đang mở'
                : 'Chưa có lịch sử giao dịch',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

({String label, Color color, IconData icon}) _statusPresentation(
  TradeOrderStatus status,
) {
  return switch (status) {
    TradeOrderStatus.open => (
      label: 'Đang mở',
      color: _tradeBlue,
      icon: Icons.access_time_rounded,
    ),
    TradeOrderStatus.partial => (
      label: 'Khớp 1 phần',
      color: AppColors.warn,
      icon: Icons.trending_up_rounded,
    ),
    TradeOrderStatus.filled => (
      label: 'Đã khớp',
      color: AppColors.buy,
      icon: Icons.check_circle_rounded,
    ),
    TradeOrderStatus.cancelled => (
      label: 'Đã hủy',
      color: AppColors.text3,
      icon: Icons.cancel_rounded,
    ),
  };
}

String _formatMoney(double value) {
  final raw = value.toStringAsFixed(2);
  final parts = raw.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$buffer.${parts.last}';
}
