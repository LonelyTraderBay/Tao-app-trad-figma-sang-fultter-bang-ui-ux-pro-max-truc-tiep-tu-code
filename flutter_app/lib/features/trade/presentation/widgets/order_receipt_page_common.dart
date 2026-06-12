part of '../pages/order_receipt_page.dart';

class _RiskBox extends StatelessWidget {
  const _RiskBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.tradeReceiptRiskBoxHeight,
      padding: AppSpacing.tradeReceiptRiskBoxPadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeReceiptRiskValueGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1.1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.tradeReceiptHorizontalMargin,
      padding: AppSpacing.tradeReceiptNoticePadding,
      decoration: BoxDecoration(
        color: AppColors.warn.withValues(alpha: .06),
        border: Border.all(color: AppColors.warn.withValues(alpha: .22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.tradeReceiptNoticeIconTop),
            child: Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.tradeReceiptNoticeIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.tradeReceiptNoticeGap),
          Expanded(
            child: Text(
              'Lệnh có thể bị khớp 1 phần hoặc hủy nếu giá thay đổi nhanh. '
              'Kiểm tra trạng thái tại Lệnh đang mở.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                height: 1.45,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSupportLink extends StatelessWidget {
  const _OrderSupportLink({required this.supportRoute});

  final String supportRoute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: OrderReceiptPage.supportKey,
      onTap: () => context.go(supportRoute),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.tradeReceiptSupportHeight,
        margin: AppSpacing.tradeReceiptHorizontalMargin,
        padding: AppSpacing.tradeReceiptSupportPadding,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .08),
          border: Border.all(color: AppColors.primary.withValues(alpha: .18)),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.support_agent_rounded,
              color: AppColors.primary,
              size: AppSpacing.tradeReceiptSupportIcon,
            ),
            const SizedBox(width: AppSpacing.tradeReceiptSupportGap),
            Expanded(
              child: Text(
                'Cần hỗ trợ lệnh này?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            Text(
              'Mở hồ sơ',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(width: AppSpacing.tradeReceiptSupportChevronGap),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primary,
              size: AppSpacing.tradeReceiptSupportIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptFooter extends StatelessWidget {
  const _ReceiptFooter({
    required this.sharePressed,
    required this.onShare,
    required this.onContinue,
  });

  final bool sharePressed;
  final VoidCallback onShare;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: _footerBackground,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: AppSpacing.tradeReceiptFooterPadding,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppSpacing.tradeReceiptFooterButtonHeight,
                child: OutlinedButton.icon(
                  key: OrderReceiptPage.shareKey,
                  onPressed: onShare,
                  icon: Icon(
                    Icons.share_rounded,
                    color: sharePressed
                        ? AppColors.receiptTextActive
                        : AppColors.textMutedLight,
                    size: AppSpacing.tradeReceiptFooterIcon,
                  ),
                  label: Text(sharePressed ? 'Đã chia sẻ' : 'Chia sẻ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textMutedLight,
                    side: const BorderSide(color: AppColors.borderSolid),
                    backgroundColor: AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                    textStyle: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.tradeReceiptFooterGap),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: AppSpacing.inputHeight,
                child: ElevatedButton(
                  key: OrderReceiptPage.continueTradingKey,
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: AppColors.onAccent,
                    backgroundColor: AppColors.buy,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
                    textStyle: AppTextStyles.baseMedium.copyWith(
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                    ),
                  ),
                  child: const Text('Tiếp tục giao dịch'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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

String _formatPrice(double value) {
  final text = _formatMoney(value);
  return text.endsWith('.00') ? text.substring(0, text.length - 3) : text;
}

String _formatAmount(double value) => value.toStringAsFixed(6);
