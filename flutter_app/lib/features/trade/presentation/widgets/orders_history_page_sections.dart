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
    return VitCard(
      radius: VitCardRadius.sm,
      padding: AppSpacing.tradeHistoryTopTabsPadding,
      borderColor: AppColors.border,
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
          const SizedBox(width: AppSpacing.tradeHistoryTabGap),
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
    return VitCtaButton(
      onPressed: onTap,
      variant: active ? VitCtaButtonVariant.primary : VitCtaButtonVariant.ghost,
      height: AppSpacing.tradeHistoryTopTabHeight,
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
          const SizedBox(width: AppSpacing.tradeHistoryTabGap),
          VitAccentPill(
            label: '$count',
            accentColor: active ? AppColors.onAccent : AppColors.text2,
          ),
        ],
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
      padding: AppSpacing.tradeHistoryFilterPadding,
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
            const SizedBox(width: AppSpacing.tradeHistoryFilterGap),
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
    return VitCard(
      width: compactAll
          ? AppSpacing.tradeHistoryFilterCompactWidth
          : AppSpacing.tradeHistoryFilterWidth,
      height: AppSpacing.tradeHistoryFilterHeight,
      padding: compactAll
          ? AppSpacing.zeroInsets
          : AppSpacing.tradeHistoryFilterPaddingCompact,
      alignment: Alignment.center,
      borderColor: active ? color : AppColors.border,
      onTap: onTap,
      child: Text(
        compactAll ? '' : label,
        style: AppTextStyles.caption.copyWith(
          color: active ? color : AppColors.text2,
          fontWeight: AppTextStyles.bold,
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

    return VitCard(
      radius: VitCardRadius.sm,
      padding: AppSpacing.tradeHistoryTilePadding,
      borderColor: AppColors.divider,
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
                        style: AppTextStyles.baseMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.tradeHistorySymbolGap),
                    _SmallBadge(
                      label: isBuy ? 'MUA' : 'BÁN',
                      color: isBuy ? AppColors.buy : AppColors.sell,
                    ),
                    const SizedBox(width: AppSpacing.tradeHistoryTypeGap),
                    _TypeBadge(type: order.type),
                  ],
                ),
              ),
              SizedBox(
                width: AppSpacing.tradeHistoryStatusWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      status.icon,
                      color: status.color,
                      size: AppSpacing.tradeHistoryStatusIcon,
                    ),
                    const SizedBox(width: AppSpacing.tradeHistoryStatusGap),
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
          const SizedBox(height: AppSpacing.tradeHistoryTileGap),
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
            const SizedBox(height: AppSpacing.tradeHistoryTileSmallGap),
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
          const SizedBox(height: AppSpacing.tradeHistoryTileSmallGap),
          _InfoColumn(label: 'Thời gian', value: order.createdAt),
          if (order.status == TradeOrderStatus.partial) ...[
            const SizedBox(height: AppSpacing.tradeHistoryTileGap),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: LinearProgressIndicator(
                value: fillPercent,
                minHeight: AppSpacing.tradeHistoryProgressHeight,
                color: AppColors.buy,
                backgroundColor: AppColors.surface3,
              ),
            ),
          ],
          if (actionable) ...[
            const SizedBox(height: AppSpacing.tradeHistoryTileGap),
            SizedBox(
              height: AppSpacing.tradeHistoryCancelHeight,
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
    );
  }
}
