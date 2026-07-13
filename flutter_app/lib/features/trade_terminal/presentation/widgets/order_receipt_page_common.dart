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
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
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
          const SizedBox(height: AppSpacing.x1),
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
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: AppColors.warn.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
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
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: AppColors.primary.withValues(alpha: .18),
      child: Row(
        children: [
          const Icon(
            Icons.support_agent_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x2),
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
          const SizedBox(width: AppSpacing.x1),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
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
    required this.bottomPadding,
  });

  final bool sharePressed;
  final VoidCallback onShare;
  final VoidCallback onContinue;
  final double bottomPadding;

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
            padding: EdgeInsetsDirectional.fromSTEB(
              AppSpacing.x4,
              AppSpacing.x2,
              AppSpacing.x4,
              AppSpacing.x2 + bottomPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: VitCtaButton(
                    variant: VitCtaButtonVariant.ghost,
                    height: VitDensity.compact.controlHeight,
                    key: OrderReceiptPage.shareKey,
                    onPressed: onShare,
                    leading: Icon(
                      Icons.share_rounded,
                      color: sharePressed
                          ? AppColors.receiptTextActive
                          : AppColors.textMutedLight,
                      size: AppSpacing.iconSm,
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
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  flex: 2,
                  child: VitCtaButton(
                    variant: VitCtaButtonVariant.success,
                    height: VitDensity.compact.controlHeight,
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

String _formatMoney(double value) => formatTradeMoney(value);

String _formatPrice(double value) {
  final text = _formatMoney(value);
  return text.endsWith('.00') ? text.substring(0, text.length - 3) : text;
}

String _formatAmount(double value) => value.toStringAsFixed(6);
