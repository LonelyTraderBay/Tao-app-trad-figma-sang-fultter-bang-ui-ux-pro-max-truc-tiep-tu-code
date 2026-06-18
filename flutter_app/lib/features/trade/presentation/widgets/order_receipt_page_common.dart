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
    return VitCard(
      height: AppSpacing.tradeReceiptRiskBoxHeight,
      padding: AppSpacing.tradeReceiptRiskBoxPadding,
      borderColor: color.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.badge.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.tradeReceiptRiskValueGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.control.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
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
    return VitCard(
      margin: AppSpacing.tradeReceiptHorizontalMargin,
      padding: AppSpacing.tradeReceiptNoticePadding,
      borderColor: AppColors.warn.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.zeroInsets.copyWith(
              top: AppSpacing.tradeReceiptNoticeIconTop,
            ),
            child: const Icon(
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
    return VitCard(
      key: OrderReceiptPage.supportKey,
      onTap: () => context.go(supportRoute),
      height: AppSpacing.tradeReceiptSupportHeight,
      margin: AppSpacing.tradeReceiptHorizontalMargin,
      padding: AppSpacing.tradeReceiptSupportPadding,
      borderColor: AppColors.primary.withValues(alpha: .18),
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
              ),
            ),
          ),
          Text(
            'Mở hồ sơ',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
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
    return ColoredBox(
      color: _footerBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          Padding(
            padding: AppSpacing.tradeReceiptFooterPadding,
            child: Row(
              children: [
                Expanded(
                  child: VitCtaButton(
                    variant: VitCtaButtonVariant.ghost,
                    height: AppSpacing.tradeReceiptFooterButtonHeight,
                    key: OrderReceiptPage.shareKey,
                    onPressed: onShare,
                    leading: Icon(
                      Icons.share_rounded,
                      color: sharePressed
                          ? AppColors.receiptTextActive
                          : AppColors.textMutedLight,
                      size: AppSpacing.tradeReceiptFooterIcon,
                    ),
                    child: Text(
                      sharePressed ? 'Đã chia sẻ' : 'Chia sẻ',
                      style: AppTextStyles.caption.copyWith(
                        color: sharePressed
                            ? AppColors.receiptTextActive
                            : AppColors.textMutedLight,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.tradeReceiptFooterGap),
                Expanded(
                  flex: 2,
                  child: VitCtaButton(
                    variant: VitCtaButtonVariant.success,
                    height: AppSpacing.inputHeight,
                    key: OrderReceiptPage.continueTradingKey,
                    onPressed: onContinue,
                    child: Text(
                      'Tiếp tục giao dịch',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
