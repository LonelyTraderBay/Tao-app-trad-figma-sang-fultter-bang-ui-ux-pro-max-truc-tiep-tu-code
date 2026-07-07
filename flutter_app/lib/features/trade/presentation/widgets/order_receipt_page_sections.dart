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
          // card-tile: allow-start — fixed surface, not horizontal strip tile
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
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
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

    return VitTradeSection(
      title: 'Tóm tắt khớp lệnh',
      headerTrailing: _StatusBadge(
        key: OrderReceiptPage.openOrdersKey,
        status: receipt.status,
        onTap: () => context.go(AppRoutePaths.tradeOrdersHistory),
      ),
      child: VitCard(
        clip: true,
        density: VitDensity.compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: VitDensity.compact.cardPadding,
              child: Row(
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
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            _DetailRow(
              label: 'Mã lệnh',
              value: receipt.orderId,
              trailing: _CopyOrderIdButton(orderId: receipt.orderId),
            ),
            _DetailRow(label: 'Loại lệnh', value: receipt.orderType),
            _DetailRow(label: 'Giá', value: '\$${_formatMoney(receipt.price)}'),
            _DetailRow(
              label: 'Khối lượng',
              value: '${_formatAmount(receipt.amount)} ${receipt.baseAsset}',
            ),
            const Divider(height: 1, color: AppColors.divider),
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
            if (receipt.tpPrice != null || receipt.slPrice != null) ...[
              const Divider(height: 1, color: AppColors.divider),
              Padding(
                padding: VitDensity.compact.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Kiểm soát rủi ro',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMutedLight,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
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
              ),
            ],
          ],
        ),
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

    return VitStatusPill(
      label: label,
      status: VitStatusPillStatus.info,
      size: VitStatusPillSize.sm,
      onTap: onTap,
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
