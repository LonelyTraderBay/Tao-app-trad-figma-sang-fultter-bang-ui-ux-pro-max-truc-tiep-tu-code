import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/withdraw_common.dart';

class WithdrawPreviewSheet extends StatelessWidget {
  const WithdrawPreviewSheet({required this.preview, super.key});

  final WithdrawPreview preview;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Xác nhận rút tiền',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 14),
            WithdrawPreviewRow(label: 'Số lượng', value: preview.amountLabel),
            WithdrawPreviewRow(label: 'Mạng lưới', value: preview.networkName),
            WithdrawPreviewRow(label: 'Phí mạng', value: preview.feeLabel),
            WithdrawPreviewRow(
              label: 'Nhận dự kiến',
              value: preview.receivedLabel,
            ),
            WithdrawPreviewRow(
              label: 'Địa chỉ đến',
              value: preview.maskedAddress,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: withdrawAmber.withValues(alpha: .10),
                border: Border.all(color: withdrawAmber.withValues(alpha: .24)),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Text(
                'High-risk action: preview + confirm + audit trail required.',
                style: AppTextStyles.caption.copyWith(
                  color: withdrawAmber,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: WithdrawConfirmActionButton(
                    key: withdrawCancelConfirmKey,
                    label: 'Cancel',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
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
    final foreground = primary ? AppColors.text1 : AppColors.text2;
    return Semantics(
      button: true,
      enabled: true,
      label: primary ? 'Confirm withdrawal' : 'Cancel withdrawal preview',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primary ? withdrawPrimary : withdrawPanel2,
            border: Border.all(
              color: primary
                  ? withdrawPrimary.withValues(alpha: .65)
                  : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: foreground,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
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
      padding: const EdgeInsets.only(bottom: 10),
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
