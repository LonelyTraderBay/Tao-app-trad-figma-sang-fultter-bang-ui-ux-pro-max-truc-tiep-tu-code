part of '../pages/order_receipt_page.dart';

class _SuccessHero extends StatelessWidget {
  const _SuccessHero({required this.receipt});

  final TradeOrderReceiptDetails receipt;

  @override
  Widget build(BuildContext context) {
    final sideLabel = receipt.side == TradeOrderSide.buy ? 'Mua' : 'Bán';
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 34, 40, 38),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.buy.withValues(alpha: .08),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.buy.withValues(alpha: .08),
                  blurRadius: 0,
                  spreadRadius: 12,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: 34,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Đặt lệnh thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontSize: 18,
              height: 1.18,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lệnh $sideLabel ${receipt.symbol} đang được xử lý',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMutedLight,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});

  final TradeOrderReceiptDetails receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == TradeOrderSide.buy;
    final sideColor = isBuy ? AppColors.buy : AppColors.sell;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SideBadge(label: isBuy ? 'MUA' : 'BÁN', color: sideColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  receipt.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _StatusBadge(
                key: OrderReceiptPage.openOrdersKey,
                status: receipt.status,
                onTap: () => context.go(AppRoutePaths.tradeOrdersHistory),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 13),
          _DetailRow(
            label: 'Order ID',
            value: receipt.orderId,
            trailing: _CopyOrderIdButton(orderId: receipt.orderId),
          ),
          _DetailRow(label: 'Loại lệnh', value: receipt.orderType),
          _DetailRow(label: 'Giá', value: '\$${_formatMoney(receipt.price)}'),
          _DetailRow(
            label: 'Khối lượng',
            value: '${_formatAmount(receipt.amount)} ${receipt.baseAsset}',
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 9),
          _DetailRow(
            label: 'Thành tiền',
            value: '\$${_formatMoney(receipt.total)}',
            highlight: true,
          ),
          _DetailRow(
            label: 'Phí giao dịch',
            value: '\$${receipt.fee.toStringAsFixed(4)} (${receipt.feeRate})',
          ),
          if (receipt.estimatedFill != null)
            _DetailRow(
              label: 'Thời gian ước tính',
              value: receipt.estimatedFill!,
            ),
          _DetailRow(label: 'Thời gian đặt', value: receipt.timestamp),
          const SizedBox(height: 4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 13),
          Text(
            'Quản lý rủi ro',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMutedLight,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              if (receipt.tpPrice != null)
                Expanded(
                  child: _RiskBox(
                    label: 'Take Profit',
                    value: _formatPrice(receipt.tpPrice!),
                    color: AppColors.buy,
                  ),
                ),
              if (receipt.tpPrice != null && receipt.slPrice != null)
                const SizedBox(width: 12),
              if (receipt.slPrice != null)
                Expanded(
                  child: _RiskBox(
                    label: 'Stop Loss',
                    value: _formatPrice(receipt.slPrice!),
                    color: AppColors.sell,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SideBadge extends StatelessWidget {
  const _SideBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({super.key, required this.status, required this.onTap});

  final TradeReceiptStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      TradeReceiptStatus.submitted => 'Đã gửi',
      TradeReceiptStatus.pending => 'Đang xử lý',
      TradeReceiptStatus.partiallyFilled => 'Khớp 1 phần',
    };

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: _tradePrimary.withValues(alpha: .08),
          borderRadius: AppRadii.smRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule_rounded, color: _tradePrimary, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: _tradePrimary,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.trailing,
  });

  final String label;
  final String value;
  final bool highlight;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: highlight
                          ? AppColors.text1
                          : AppColors.receiptTextMuted,
                      fontSize: highlight ? 14 : 11.5,
                      fontWeight: highlight
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                      fontFamily: 'monospace',
                      height: 1.1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 4), trailing!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyOrderIdButton extends StatelessWidget {
  const _CopyOrderIdButton({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: IconButton(
        key: OrderReceiptPage.copyOrderIdKey,
        padding: EdgeInsets.zero,
        onPressed: () => Clipboard.setData(ClipboardData(text: orderId)),
        icon: const Icon(Icons.copy_rounded, size: 12, color: AppColors.text3),
      ),
    );
  }
}
