part of '../pages/order_receipt_page.dart';

class _SuccessHero extends StatelessWidget {
  const _SuccessHero({required this.receipt});

  final TradeOrderReceiptDetails receipt;

  @override
  Widget build(BuildContext context) {
    final sideLabel = receipt.side == TradeOrderSide.buy ? 'Mua' : 'Bán';
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: AppSpacing.x2,
        bottom: AppSpacing.x1,
      ),
      child: Column(
        children: [
          VitCard(
            width: _receiptHeroExtent,
            height: _receiptHeroExtent,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.large,
            alignment: Alignment.center,
            borderColor: AppColors.buy.withValues(alpha: .22),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconLg,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Đặt lệnh thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.amountSm.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Lệnh $sideLabel ${receipt.symbol} đang được xử lý',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMutedLight,
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

    return VitCard(
      variant: VitCardVariant.inner,
      padding: VitDensity.compact.cardPadding,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Execution summary',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              _SideBadge(label: isBuy ? 'MUA' : 'BÁN', color: sideColor),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  receipt.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium,
                ),
              ),
              _StatusBadge(
                key: OrderReceiptPage.openOrdersKey,
                status: receipt.status,
                onTap: () => context.go(AppRoutePaths.tradeOrdersHistory),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.x2),
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
          const SizedBox(height: AppSpacing.x1),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.x2),
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
          const SizedBox(height: AppSpacing.x1),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Risk controls',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMutedLight,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
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
                const SizedBox(width: AppSpacing.x2),
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
    return VitAccentPill(label: label, accentColor: color);
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

    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      borderColor: _tradePrimary.withValues(alpha: .18),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: _tradePrimary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: _tradePrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
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
    return VitInfoRow(
      label: label,
      value: value,
      trailing: trailing,
      density: VitDensity.compact,
      valueColor: highlight ? AppColors.text1 : AppColors.receiptTextMuted,
    );
  }
}

class _CopyOrderIdButton extends StatelessWidget {
  const _CopyOrderIdButton({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _receiptCopyActionExtent,
      height: _receiptCopyActionExtent,
      child: VitInlineIconAction(
        key: OrderReceiptPage.copyOrderIdKey,
        icon: Icons.copy_rounded,
        tooltip: 'Copy order id',
        color: AppColors.text3,
        size: AppSpacing.iconSm,
        padding: 0,
        onPressed: () => Clipboard.setData(ClipboardData(text: orderId)),
      ),
    );
  }
}
