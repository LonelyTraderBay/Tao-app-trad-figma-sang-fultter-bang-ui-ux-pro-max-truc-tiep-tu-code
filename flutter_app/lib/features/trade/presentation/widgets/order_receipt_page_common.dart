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
      height: 58,
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
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
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 14,
              fontFamily: 'monospace',
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
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.warn.withValues(alpha: .06),
        border: Border.all(color: AppColors.warn.withValues(alpha: .22)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Lệnh có thể bị khớp 1 phần hoặc hủy nếu giá thay đổi nhanh. '
              'Kiểm tra trạng thái tại Lệnh đang mở.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontSize: 11,
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
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
              size: 16,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                'Cần hỗ trợ lệnh này?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            Text(
              'Mở hồ sơ',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primary,
              size: 16,
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
        padding: const EdgeInsets.fromLTRB(40, 16, 40, 8),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  key: OrderReceiptPage.shareKey,
                  onPressed: onShare,
                  icon: Icon(
                    Icons.share_rounded,
                    color: sharePressed
                        ? AppColors.receiptTextActive
                        : AppColors.textMutedLight,
                    size: 16,
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
            const SizedBox(width: 12),
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
                      fontSize: 16,
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
