part of '../pages/orders_history_page.dart';

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
          color: active ? _tradePrimary : _fieldBackground,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.onAccent : AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.onAccent.withValues(alpha: .18)
                    : AppColors.surface3,
                borderRadius: AppRadii.xsRadius,
              ),
              child: Text(
                '$count',
                style: AppTextStyles.micro.copyWith(
                  color: active ? AppColors.onAccent : AppColors.text2,
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
      ('all', 'Tất cả', _tradePrimary),
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
          color: active ? color : AppColors.transparent,
          borderRadius: AppRadii.lgRadius,
        ),
        child: compactAll
            ? const SizedBox.shrink()
            : Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? AppColors.onAccent : AppColors.text2,
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
                  backgroundColor: AppColors.surface3,
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
