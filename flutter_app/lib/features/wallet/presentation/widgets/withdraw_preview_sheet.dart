import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_common.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

class WithdrawPreviewSheet extends StatelessWidget {
  const WithdrawPreviewSheet({required this.preview, super.key});

  final WithdrawPreview preview;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.transferSheetPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Xác nhận rút tiền', style: AppTextStyles.sectionTitle),
            const SizedBox(height: AppSpacing.transferInfoGap),
            WithdrawPreviewRow(label: 'Số lượng', value: preview.amountLabel),
            WithdrawPreviewRow(label: 'Mạng lưới', value: preview.networkName),
            WithdrawPreviewRow(label: 'Phí mạng', value: preview.feeLabel),
            WithdrawPreviewRow(
              label: 'Nhận dự kiến',
              value: preview.receivedLabel,
            ),
            WithdrawPreviewRow(
              label: 'Địa chỉ nhận',
              value: preview.maskedAddress,
            ),
            const SizedBox(height: AppSpacing.transferInfoGap),
            VitCard(
              variant: VitCardVariant.inner,
              borderColor: withdrawAmber.withValues(alpha: .24),
              padding: AppSpacing.cardPadding,
              child: Text(
                'High-risk action: preview + confirm + audit trail required.',
                style: AppTextStyles.caption.copyWith(color: withdrawAmber),
              ),
            ),
            const SizedBox(height: AppSpacing.transferInfoGap),
            Row(
              children: [
                Expanded(
                  child: WithdrawConfirmActionButton(
                    key: withdrawCancelConfirmKey,
                    label: 'Cancel',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3 - AppSpacing.x1),
                Expanded(
                  child: WithdrawConfirmActionButton(
                    key: withdrawConfirmWithdrawKey,
                    label: 'Confirm withdraw',
                    primary: true,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WithdrawConfirmActionButton extends StatelessWidget {
  const WithdrawConfirmActionButton({
    required this.label,
    required this.onTap,
    this.primary = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: primary ? 'Confirm withdrawal' : 'Cancel withdrawal preview',
      child: VitCtaButton(
        height: AppSpacing.ctaHeight,
        variant: primary
            ? VitCtaButtonVariant.warning
            : VitCtaButtonVariant.secondary,
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
      ),
    );
  }
}

class WithdrawPreviewRow extends StatelessWidget {
  const WithdrawPreviewRow({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.walletWithdrawPreviewRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(value, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
