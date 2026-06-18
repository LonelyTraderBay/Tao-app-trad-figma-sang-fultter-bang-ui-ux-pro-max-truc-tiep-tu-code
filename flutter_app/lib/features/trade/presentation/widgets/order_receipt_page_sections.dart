part of '../pages/order_receipt_page.dart';

class _SuccessHero extends StatelessWidget {
  const _SuccessHero({required this.receipt});

  final TradeOrderReceiptDetails receipt;

  @override
  Widget build(BuildContext context) {
    final sideLabel = receipt.side == TradeOrderSide.buy ? 'Mua' : 'Bán';
    return Padding(
      padding: AppSpacing.tradeReceiptHeroPadding,
      child: Column(
        children: [
          VitCard(
            width: AppSpacing.tradeReceiptHeroIconBox,
            height: AppSpacing.tradeReceiptHeroIconBox,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.lg,
            alignment: Alignment.center,
            borderColor: AppColors.buy.withValues(alpha: .22),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.tradeReceiptHeroIcon,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeReceiptHeroTitleGap),
          Text(
            'Đặt lệnh thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.amountSm.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeReceiptHeroSubtitleGap),
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
      margin: AppSpacing.tradeReceiptHorizontalMargin,
      padding: AppSpacing.tradeReceiptCardPadding,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SideBadge(label: isBuy ? 'MUA' : 'BÁN', color: sideColor),
              const SizedBox(width: AppSpacing.tradeReceiptHeaderGap),
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
          const SizedBox(height: AppSpacing.tradeReceiptDividerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.tradeReceiptSectionGap),
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
          const SizedBox(height: AppSpacing.tradeReceiptSmallDividerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.tradeReceiptTotalGap),
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
          const SizedBox(height: AppSpacing.tradeReceiptSmallDividerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.tradeReceiptSectionGap),
          Text(
            'Quản lý rủi ro',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMutedLight,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeReceiptRiskTitleGap),
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
                const SizedBox(width: AppSpacing.tradeReceiptRiskColumnGap),
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
      radius: VitCardRadius.sm,
      padding: AppSpacing.tradeReceiptStatusBadgePadding,
      borderColor: _tradePrimary.withValues(alpha: .18),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: _tradePrimary,
            size: AppSpacing.tradeReceiptStatusIcon,
          ),
          const SizedBox(width: AppSpacing.tradeReceiptStatusGap),
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
    return Padding(
      padding: AppSpacing.tradeReceiptDetailPadding,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.tradeReceiptDetailLabelWidth,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.tradeReceiptDetailGap),
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
                      fontWeight: highlight
                          ? AppTextStyles.bold
                          : AppTextStyles.medium,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(
                    width: AppSpacing.tradeReceiptDetailTrailingGap,
                  ),
                  trailing!,
                ],
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
      width: AppSpacing.tradeReceiptCopyButton,
      height: AppSpacing.tradeReceiptCopyButton,
      child: VitInlineIconAction(
        key: OrderReceiptPage.copyOrderIdKey,
        icon: Icons.copy_rounded,
        tooltip: 'Copy order id',
        color: AppColors.text3,
        size: AppSpacing.tradeReceiptCopyIcon,
        padding: 0,
        onPressed: () => Clipboard.setData(ClipboardData(text: orderId)),
      ),
    );
  }
}
